library(tidyverse)
library(lubridate)

# data_source <- 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv'
data_source <- 'http://j.mp/covid19casescsv'
covid19 <- read_csv(url(data_source)) %>% 
  rename(Country = "Country/Region") %>%
  rename(State = "Province/State") %>%
  select(-c("Lat", "Long")) %>% 
  pivot_longer(-c(Country, State), names_to = "textdate", values_to = "Cases") %>%
  mutate(Date = mdy(textdate)) %>% 
  arrange(Date) %>% 
  select(-textdate) %>%
  group_by(Country, Date) %>%
  summarise(Cases = sum(Cases))

covid19 %>%
  filter(Country %in% c("US", "Italy")) %>%
  ggplot(aes(x=Date, y=Cases, col=Country)) + geom_point() + theme(axis.text.x = element_text(angle = 90))
