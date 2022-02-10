library(rvest)
library(data.table)
library(tidyverse)

url <- "https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132"
urlHtml <- url %>% read_html() 
df <- urlHtml %>% html_table(header=TRUE) %>% .[[1]] %>% as_data_frame()
head(df)
tail(df)

df <- df %>% mutate(col = str_replace(`WLTP-tall`, "\\s", "|")) %>% 
  separate(col, into = c("first_WLTP", "rest_WLTP"), sep = "\\|")

df <- df %>% mutate(col = str_replace(`STOPP`, "\\s", "|")) %>% 
  separate(col, into = c("first_STOPP", "rest_STOPP"), sep = "\\|")

df$first_WLTP <- as.numeric(as.character(df$first_WLTP))
df$first_STOPP <- as.numeric(as.character(df$first_STOPP))

df <- na.omit(df) 

ggplot(df, aes(x=first_WLTP, y=first_STOPP)) + 
  geom_point(size=1, alpha=0.8, color = "black") +
  theme_minimal() + 
  scale_x_continuous(breaks = seq(200, 600, 100), limits=c(200, 600)) + 
  scale_y_continuous(breaks = seq(200, 600, 100), limits=c(200, 600)) +
  geom_abline(intercept = 0, slope = 1, size = 0.5, color="red") +
  labs(title = "Rekkeviddetallene", x = "WLTP-rekkevidde", y = "Stopptall",
       subtitle = "Sammenhengen mellom det som er lovet og faktisk kjørelengde") +
  annotate("text", x=350, y=500, size=3.5, 
           label="45∘ linje som viser hvor langt\nbilene “egentlig” skulle kjørt") +
  annotate("segment", x=350, xend = 400, y = 470, yend = 400, 
           colour = "black", size=0.5, arrow = arrow(length = unit(.2,"cm"))) 
  
coef(lm(first_STOPP ~ first_WLTP, data=df))[2]

summary(df$first_STOPP)
summary(df$first_WLTP)

# Ved 1 km økning i WLTP-rekkevidde forventes det at stopplengden øker med 0.86km.

ggplot(df, aes(x=first_WLTP, y=first_STOPP)) + 
  geom_point(size=1, alpha=0.8, color = "black") +
  theme_minimal() + 
  labs(title = "Rekkeviddetallene", x = "WLTP-rekkevidde", y = "Stopptall",
       subtitle = "Sammenhengen mellom det som er lovet og faktisk kjørelengde") +
  geom_smooth(method='lm')


+
  scale_x_continuous(breaks = seq(0.45, 0.80, 0.05), limits=c(0.45, 0.8)) + 
  scale_y_continuous(breaks = seq(0, 20, 5), limits=c(0, 20)) +
  labs(title = "Covid-19 deaths since universal adult vaccine eligibility compared with \n
                                            vaccination rates", 
       subtitle = "Avg monthly deaths per 100 000",
       x = "Share of population fully vaccinated", y = " ") +
  theme(plot.title = element_text(size=10, face="bold"), 
        plot.subtitle = element_text(size=8),
        axis.text.x=element_text(size=rel(1.0)),
        text = element_text(size=8)) + 
  annotate("text", x=0.61, y=17.5, size=2.5, 
           label="Lower vaccination rate,\nhigher death rate") +
  annotate("segment", x=0.567, xend = 0.55, y = 18, yend = 19, 
           colour = "black", size=0.5, arrow = arrow(length = unit(.2,"cm"))) +
  annotate("text", x=0.72, y=10, size=2.5, 
           label="Higher vaccination rate,\nlower death rate") +
  annotate("segment", x=0.75, xend = 0.77, y = 9, yend = 8, 
           colour = "black", size=0.5, arrow = arrow(length = unit(.2,"cm"))) +
  geom_text_repel(aes(label = geoid), max.overlaps = Inf, size = 2.5) + 
  geom_smooth(method = 'lm')
