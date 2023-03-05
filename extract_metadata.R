library(tidyverse)
library(rvest)
metadata <- read_html('https://www.mrlc.gov/downloads/sciweb1/shared/mrlc/metadata/himetadata_landcov.xml')
### if you go to that page and scroll down about 60% of the way down, looks like
### the info you need...


land_values <- metadata %>%
  html_elements('edom') %>% ### looks like <edom> defines the value-description pairs
  html_element('edomv') %>% ### the numeric value (in raster cells)
  html_text2() %>% as.integer()
land_descriptions <- metadata %>%
  html_elements('edom') %>%
  html_element('edomvd') %>% ### the description associated with numeric values
  html_text2()

metadata_df <- data.frame(value = land_values, 
                          desc  = land_descriptions) %>%
  mutate(name = str_remove(desc, '\\*.*|-.*'),
         name = str_squish(name))

write_csv(metadata_df, here::here('lc_value_to_desc_lookup.csv'))
