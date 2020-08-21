library(caret)
library(readxl)
library(dplyr)
library(stringr)
library(rvest)
library(textreadr)
library(magrittr)
library(dplyr)
library(tidyverse)

######################## Load COVID-19 data for Peru ###############################################

COVID_19_Peru_Raw <- read_excel("data/COVID19_Peru.xlsx", 
                                 sheet = "Overall")

COVID_19_Peru_Raw_Inc2day <- read_excel("data/COVID19_Peru.xlsx", 
                                sheet = "Increase_per_2_days")

# create an "other province cases since there's not data for other province per day"
COVID_19_Peru_Raw <- COVID_19_Peru_Raw %>%
  mutate(Other_province_cases_increase = Peru_cases_increase - Lima_cases_increase) %>%
  mutate(Peru_serological_total = Peru_Total_Cases-Peru_molecular_total)
  
summary(COVID_19_Peru_Raw)
str(COVID_19_Peru_Raw)


summary(COVID_19_Peru_Raw_Inc2day)
str(COVID_19_Peru_Raw_Inc2day)


############### Pulling data directly from wikipedia ##########################

# download the wikipedia web page we use a specific version
# of the template page directly version of the wikipedia page

wikipedia_data_url <- paste("https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_Peru", 
                            sep = "")

outbreak_webpage <- textreadr::read_html(wikipedia_data_url)

# parse the web page and extract the data from the first
# table
COVID_19_Peru_Raw_Table1 <- outbreak_webpage %>% html_nodes("table") %>% 
  .[[2]] %>% html_table(fill = TRUE)

COVID19_Peru_Case_Region <- outbreak_webpage %>% html_nodes("table") %>% 
  .[[3]] %>% html_table(fill = TRUE)


COVID_19_Peru_Raw_Table1$Date <- as.Date(COVID_19_Peru_Raw_Table1$Date)

# COVID_19_Peru_Raw_Table1$`Total Cases` <- gsub(" .*]", "", COVID_19_Peru_Raw_Table1$`Total Cases`)
# COVID_19_Peru_Raw_Table1$`Lima Cases` <- gsub(" .*]", "", COVID_19_Peru_Raw_Table1$`Lima Cases`)


COVID_19_Peru_Raw_Table1 <- mutate_if(COVID_19_Peru_Raw_Table1,
                                      is.character,
                                      str_replace_all, pattern = " .*]", replacement = "")

COVID_19_Peru_Raw_Table1$

summary(COVID_19_Peru_Raw_Table1)

## Save dataset into rda folder
save(COVID_19_Peru_Raw, file = "rda/COVID_19_Peru_Raw.rda")
save(COVID_19_Peru_Raw_Inc2day, file = "rda/COVID_19_Peru_Raw_Inc2day.rda")
#save(COVID19_Peru_Case_Region, file = "rda/COVID19_Peru_Case_Region.rda")


