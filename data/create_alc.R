# R Haikonen
# 19.11.2021
# Wrangling data
# Data from:
# https://archive.ics.uci.edu/ml/datasets/Student+Performance

# 3) reading in the data
setwd("~/Tilastotiede/IODS-project")

studentsPor <- read.csv("data/student-por.csv", sep=";")
studentsMat <- read.csv("data/student-mat.csv", sep=";")

# 4) Joining two data sets
# 5) combine the duplicated answers
# 6) take the avarage and make "high_use" variable

# Code by Reijo Sund makes tasks 4-6

library(dplyr)
por_id <- studentsPor %>% mutate(id=1000+row_number()) 
math_id <- studentsMat %>% mutate(id=2000+row_number())

free_cols <- c("id","failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
)

############################
# End of Reijo's code


#7. structure observation and writing
dim(pormath)
# 370 observations and 51 variables
glimpse(pormath)
#should be all right

write.csv(pormath, file = "data/alc.csv", row.names = T)

# Optional importation (to uncomment select, and press Ctrl + Shift + C)
# pormath2 <- read.csv("data/alc.csv",header = T,row.names = 1)
# dim(pormath2)
# glimpse(pormath2)
# rm(pormath2)
