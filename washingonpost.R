library(jsonlite)
library(tidyverse)
library(tidytext)
library(topicmodels)
library(ndjson)

validate("/Users/jquan42/Downloads/wapo/wapotest/wapo_test/articles.json20200101.json")
tidy_json <- stream_in("/Users/jquan42/Downloads/wapo/wapotest/wapo_test/articles.20200101.json", cls = "tbl")

str(tidy_json) 

tidy_json2 <- tidy_json %>% 
  select(publish_date, credits.by.0.additional_properties.original.firstName,
         credits.by.0.additional_properties.original.lastName, 
         additional_properties.commercial_node,
         additional_properties.content_category,
         address.country_name,
         address.region, address.locality,
         matches("content_elements.*.content")) %>% 
  rename(first_name = credits.by.0.additional_properties.original.firstName,
         last_name = credits.by.0.additional_properties.original.lastName,
         commercial_node = additional_properties.commercial_node,
         country = address.country_name,
         region = address.region,
         locality = address.locality,
         content_category = additional_properties.content_category) 


tidy_json2 <- unite(tidy_json2, "content", 9:ncol(tidy_json2), 
                    na.rm = TRUE, remove = FALSE, sep = "")


write_csv(tidy_json2, path = "./tidy_wapo.csv")


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
