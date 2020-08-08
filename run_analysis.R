#revisando todo
dir()
setwd("F:/DAVID/datascience")
dir()
dir("getdata_projectfiles_UCI HAR Dataset.zip")
library(dplyr)
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"


if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# revisar si las carpetas existen
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
#nombre de todas las variables de la data que se va autilizar
f <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
a <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
s <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
we<- read.table("UCI HAR Dataset/test/X_test.txt", col.names = f$functions)
pe<- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
b <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
wt <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = f$functions)
pt<- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#nombre da las data principales
x<- rbind(wt, we)
y<- rbind(pt, pe)
Sub <- rbind(b, s)
Mergeddata <- cbind(Sub, y, x)
Data <- Mergeddata %>% select(subject, code, contains("mean"), contains("std"))

Data$code <- a[Data$code, 2]

names(Data)[2] = "activity"
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("tBody", "TimeBody", names(Data))
names(Data)<-gsub("-mean()", "Mean", names(Data))
names(Data)<-gsub("-std()", "STD", names(Data))
names(Data)<-gsub("-freq()", "Frequency", names(Data))
names(Data)<-gsub("angle", "Angle", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))

FData <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
#escribiendo el block de notas 
write.table(FData, "FinalData.txt", row.name=FALSE)
str(FData)
View(FData)
