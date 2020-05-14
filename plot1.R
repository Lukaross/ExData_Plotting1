library(dplyr)
library(chron)
library(lubridate)

filename <- "exdata_data_household_power_consumption.zip"

# Download data:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename,mode = 'wb')
}  

#unzipps the data
if (!file.exists("household_power_consumption")) { 
  unzip(filename) 
}

#reads the data
table <- read.table("household_power_consumption.txt",header = TRUE,sep = ";")

#converts the data and time Cols to data and time
table$Date <- dmy(table$Date)
table$Time <- chron(times=table$Time)

#extracts measurements for 2007/02/01 and 2007/02/02 only
table <- filter(table,Date=="2007-02-01"|Date=="2007-02-02")


#changes the Global active power col to numeric
table$Global_active_power <- as.numeric(table$Global_active_power)


#plots the histogram and saves it to a png file 
png(file="plot1.png")
hist(table$Global_active_power,main = "Global Active Power",xlab = "Global Active Power (kilowatts)")
dev.off()
