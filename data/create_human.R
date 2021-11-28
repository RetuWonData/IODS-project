# Rhaikonen
# 28.11.2021
# Wrangling the human data

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

#joining the two datasets (1p)
human <- inner_join(hd,gii,by=c("Country"))
dim(human) # 195 X 19
summary(human)

#saving the data to the 'data' folder

write.csv(human, "data/human.csv", row.names = F)

# Optional importation (to uncomment select, and press Ctrl + Shift + C)
human2 <- read.csv("data/human.csv",header = T)
dim(human2)
glimpse(human2)
rm(human2)
