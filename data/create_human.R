# Rhaikonen
# 28.11.2021
# Wrangling the human data
library(dplyr)
library(pillar)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

dim(hd) # 195 X 8
dim(gii) # 195 X 10

summary(hd)
summary(gii)

# Changing the names 
# Original names
colnames(hd)
# [1] "HDI.Rank"                               "Country"                                "Human.Development.Index..HDI."         
# [4] "Life.Expectancy.at.Birth"               "Expected.Years.of.Education"            "Mean.Years.of.Education"               
# [7] "Gross.National.Income..GNI..per.Capita" "GNI.per.Capita.Rank.Minus.HDI.Rank"    

colnames(gii)
# [1] "GII.Rank"                                     "Country"                                      "Gender.Inequality.Index..GII."               
# [4] "Maternal.Mortality.Ratio"                     "Adolescent.Birth.Rate"                        "Percent.Representation.in.Parliament"        
# [7] "Population.with.Secondary.Education..Female." "Population.with.Secondary.Education..Male."   "Labour.Force.Participation.Rate..Female."    
# [10] "Labour.Force.Participation.Rate..Male."   

colnames(hd) <- c("HDI_Rank", "Country", "HDI", "Exp_Life", "Exp_Educ", "Mean_Educ",
                  "GNI", "GNI_HDI")

colnames(gii) <- c("GII_Rank", "Country", "GII", "Mort_ratio", "ABR", "PRP",
                   "edu2F", "edu2M", "labF", "labM")
gii <- mutate(gii,
              edu2_ratio = edu2F/edu2M,
              lab_ratio = labF/labM)

#joining two data sets
human <- inner_join(hd,gii,by=c("Country"))
dim(human) # 195 X 19
summary(human)

# Writing the data

write.csv(human, "data/human.csv", row.names = F)

# Optional importation (to uncomment select, and press Ctrl + Shift + C)
# human2 <- read.csv("data/human.csv",header = T)
# dim(human2)
# glimpse(human2)
# rm(human2)

###############################################################################
###############################################################################
# 1.12.2021
# Still RHaikonen on the other side of the screen
###############################################################################
###############################################################################

human <- read.csv("data/human.csv",header = T)
dim(human) # 195 observations in 19 variables
library(pillar)
glimpse(human)

# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi
# Data have following variables
# "Country" = Country name
 
# # Health and knowledge
# "HDI_Rank" = Human development index rank
# "HDI" = Human development index
# "Exp_Life" = Life expectancy at birth
# "Exp_Educ" = Expected years of schooling
# "Mean_Educ" = Mean years of education
# "GNI" = Gross National Income per capita
# "GNI_HDI" = GNI per capita rank - HDI rank
# "GII_Rank" = Gender inequality index rank
# "GII" = Gender inequality index
# "Mort_ratio" = Maternal mortality ratio
# "ABR" = Adolescent birth rate

# # Empowerment
# "PRP" = Percetange of female representatives in parliament
# "edu2F" = Proportion of females with at least secondary education
# "edu2M" = Proportion of males with at least secondary education
# "labF" = Proportion of females in the labour force
# "labM" " Proportion of males in the labour force
# "edu2_ratio" = Edu2.F / Edu2.M
# "lab_ratio" = Labo2.F / Labo2.M

# GNI to numeric

library(stringr)
str(human$GNI)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# Excluding data that is not needed
keep <- c("Country", "edu2_ratio", "lab_ratio", "Exp_Life", "Exp_Educ", "GNI", "Mort_ratio", "ABR", "PRP")
human <- select(human, one_of(keep))

# Excluding not complete cases i.e. missing values
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human_ <- filter(human, complete.cases(human))

# Still excluding, this time areas
tail(human_, 12) # 7 last are not countries but areas instead
last <- nrow(human_) - 7
human_ <- human_[1:last, ]
dim(human_) # 155 countries left

# Setting the row names
rownames(human_) <- human_$Country
human <- human_[, -1]
dim(human) # now 155 observations (countries) in 8 variables

write.csv(human, "data/human.csv", row.names = T)
# Again, optional importation (to uncomment select, and press Ctrl + Shift + C)
# human2 <- read.csv("data/human.csv",header = T, row.names = 1)
# dim(human2)
# glimpse(human2)
# rm(human2)
