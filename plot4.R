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

#converts the data and time Cols to data and time class
table$Date <- dmy(table$Date)
table$Time <- chron(times=table$Time)

#extracts measurements for 2007/02/01 and 2007/02/02 only
table <- filter(table,Date=="2007-02-01"|Date=="2007-02-02")

#changes the Global active power, global reactive power and voltage cols to numeric
table$Global_active_power <- as.numeric(table$Global_active_power)
table$Voltage <- as.numeric(table$Voltage)
table$Global_reactive_power <- as.numeric(table$Global_reactive_power)

#makes a dateTime col
table$dateTime <- as.POSIXct(paste(table$Date, table$Time), format = "%Y-%m-%d %H:%M:%S")

#opens a png file
png(file="plot4.png")

#creates a 2x2 matrix for the 4 graphs
par(mfrow=c(2,2))

#plots graphs and saves the png file
plot(table$dateTime,table$Global_active_power,type="l",ylab = "Global active power (kilowatts)",xlab = "DateTime")

plot(table$dateTime,table$Voltage,type="l",ylab = "voltage",xlab = "DateTime")

plot(table$dateTime,table$Sub_metering_1,type="n",xlab = "DateTime",ylab = "Energy sub metering")
points(table$dateTime,table$Sub_metering_1,type = "l")
points(table$dateTime,table$Sub_metering_2,type = "l",col="red")
points(table$dateTime,table$Sub_metering_3,type = "l",col="blue")
legend("topright",legend=c("sub metering 1","sub metering 2","sub metering 3"),col=c("black","red","blue"),lty=1)

plot(table$dateTime,table$Global_reactive_power,type="l",xlab = "DateTime",ylab = "Global reactive power")
dev.off()


