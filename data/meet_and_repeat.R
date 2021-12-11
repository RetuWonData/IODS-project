# Rhaikonen
# 11.12.2021
# Week 6 data wrangler

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

str(BPRS)
dim(BPRS)
# 40 observations in  11 variables
head(BPRS)

str(RATS)
dim(RATS)
# 16 observations in 13 variables
head(RATS)

# These data longitudinal sets are in wide format meaning that every column
# describe one measurement following previous column measurement i.e. in BPRS
# there are weeks.

# Each row describe what were measured e.g. rat in RATS data.

# Changing the categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Long form and adding variables
library(dplyr)
library(tidyr)

BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <- BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))


RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group)
RATSL <- RATSL%>% mutate(Time = as.integer(substr(WD, 3, 4))) 

# Now serious look. Don't smile.

colnames(BPRSL)
# "treatment" "subject"   "weeks"     "bprs"      "week"  
dim(BPRSL) # 360 X 5

colnames(RATSL)
# "ID"     "Group"  "WD"     "Weight"
dim(RATSL) # 176 X 4

# quick math gives us the results that long form is multiplication of rows
# and columns in wide format. For example BPRS has 9 measured variables and 40
# observation and the multiplication is 360, which is the number of rows in
# long format.

write.csv(RATSL, "data/Rats_longitudinal.csv")
write.csv(BPRSL, "data/Bprsl_longitudinal.csv")

# Again, optional importation (to uncomment select, and press Ctrl + Shift + C)
# RATSL2 <- read.csv("data/Rats_longitudinal.csv",header = T, row.names = 1)
# dim(RATSL2)
# glimpse(RATSL2)
# rm(RATSL2)
