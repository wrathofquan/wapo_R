#library(jsonlite)
library(tidyverse)
#library(tidytext)
#library(topicmodels)
library(ndjson)
library(lubridate)

validate("/Users/jquan42/Downloads/wapo/wapotest/wapo_test/articles.20200101.json")
tidy_json <- stream_in("/Users/jquan42/Downloads/wapo/wapotest/wapo_test/articles.20200101.json", cls = "tbl")

str(tidy_json) 

tidy_json2 <- tidy_json %>% 
  select(`_id`, publish_date, credits.by.0.additional_properties.original.firstName,
         credits.by.0.additional_properties.original.lastName,
         additional_properties.content_category,
         address.country_name,
         address.region, address.locality,
         matches("content_elements.*.content")) %>% 
  rename(id = `_id`,
         first_name = credits.by.0.additional_properties.original.firstName,
         last_name = credits.by.0.additional_properties.original.lastName,
         country = address.country_name,
         region = address.region,
         locality = address.locality,
         content_category = additional_properties.content_category) 

tidy_json2 <- unite(tidy_json2 , "content", 9:ncol(tidy_json2), 
                    na.rm = TRUE, remove = TRUE, sep = " ")
  
  
tidy_json3 <- mutate(tidy_json2, publish_date = parse_date_time(publish_date, c("ymd", "ymd HMS")))
tidy_json3<-  mutate(tidy_json2, publish_date = as.Date(publish_date))

tidy_json_distinct <- tidy_json3 %>% group_by(id) %>% distinct()

  
write_csv(tidy_json_distinct, path = "./tidy_wapo.csv")


# text <- mydf %>% select(contents.content)
# 
# text <- text %>% unnest_tokens(word, contents.content)
# 
# ## bar chart, removing stop words and showing highest freq. 
# text %>% count(word, sort = TRUE) %>% anti_join(stop_words) %>% 
#   filter(n > 3) %>% mutate(word = reorder(word, n)) %>% na.omit() %>% 
#   ggplot(aes(word, n)) + geom_col() + xlab(NULL) + coord_flip()
# 
# 
# 
# #topic modeling
# 
# text_lda <- text %>% count(word, sort = TRUE) %>% anti_join(stop_words) %>% 
#   filter(n > 3) %>% mutate(word = reorder(word, n)) %>% na.omit()
# 
# 
# text_counts_dtm <- text_lda %>% cast_tdm(word, n)
# 
# 
# wp_lda <- topicmodels::LDA(text, k = 2)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
