# R Haikonen
# 9.11.2021
# Reading in some data.

# reading in the data
learning2014 <- read.csv("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t")
# exploring
str(learning2014)
dim(learning2014) #183 X 60 quite much columns to merge but fortunately R does it
# There is some chr data as there is genders and then there are whole lot of integers values

# making select vectors
additude_questions <- c("Da", "Db" , "Dc" , "Dd" , "De" , "Df" , "Dg" , "Dh" , "Di" , "Dj")
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# additude calculations
additude_columns <- select(learning2014, one_of(additude_questions))
attitude <- rowMeans(additude_columns)

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
stra <- rowMeans(strategic_columns)

points <- rowMeans(cbind(strategic_columns, surface_columns, deep_columns))

learning <- cbind(learning2014[,c("gender","Age")],attitude, deep, stra, surf, learning2014$Points)
colnames(learning) <- c("gender", "age", "attitude", "deep", "stra", "surf", "points")
learning <- filter(learning, points > 0) # after excluding there is 166 observation and 7 variables.

# Setting the working directory
setwd("~/Tilastotiede/IODS-project")

# writing the data
write.csv(learning, file = "data/learning2014.csv",row.names = F)
# Optional importation (to uncomment select, and press Ctrl + Shift + C)
# learning2 <- read.csv("data/learning2014.csv",header = T)
# dim(learning2)
# head(learning2)


