library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(ggrepel)
library(ectrlplot)
library(scales)
library(ftplottools)

# data from Holger 
daily_traffic <- read_csv("data/COVID_Page 2_Time series.csv")
daily_traffic <- daily_traffic %>% 
  janitor::clean_names() %>% 
  mutate(date = mdy(date), day = day(date), month = month(date)) %>% 
  pivot_longer(~date, cols = starts_with("x"), names_to = "year", values_to = "count") %>% 
  mutate(year = stringr::str_extract(year, "\\d{4}")) %>% 
  mutate(date = ymd(paste(year, month, day, sep= ' ')))

annot <- tribble(
  ~year, ~month, ~day, ~text,
  "2010", 4, 17, "volcanic ash",
  "2010", 12, 25, "Christmas",
  "2020", 3, 22, "COVID-19"
)
d <- daily_traffic %>% 
  mutate(d = ymd(paste("2010", month, day, sep= ' ')))
d_annot <- d %>%  left_join(annot)

w_annot <- d_annot %>% 
  mutate(week = isoweek(date)) %>% 
  group_by(year, week) %>% 
  mutate(traffic = floor(mean(count))) %>% 
  tidyr::fill(text, .direction = "downup") %>% 
  ungroup() %>% 
  group_by(year, week) %>% 
  slice(c(1))


p <- ggplot(w_annot) +
  geom_line(aes(x = d, y = traffic, group = year, colour = year)) +
  geom_text_repel(data = w_annot %>% filter(!is.na(text)),
                  mapping = aes(x = d, y = traffic, label = text),
                  segment.size  = 0.2,
                  nudge_y       = 100 - (w_annot %>% filter(!is.na(text)))$traffic,
                  segment.color = "grey50",
                  direction     = "both",
                  box.padding = 1) +
  scale_x_date(date_breaks = "1 month", date_labels =  "%b") +
  scale_y_continuous(label = unit_format(accuracy = 1, unit = "k", scale = 1e-3, sep = "")) +
  labs(title = "Weekly traffic in Europe",
       subtitle = "flights in Network Manager area") +
  ylab("Average number of flights") +
  ft_theme() +
  # theme_pru() +
  theme(axis.title.x=element_blank()) +
  NULL

add_logo(plot_name = p,
         source = "Source: Network Manager; analysis: PRU",
         width_pixels = 1280,
         height_pixels = 900,
         save_filepath = "weekly-traffic-covid19.png")  
