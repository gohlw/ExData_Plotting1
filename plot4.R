## download the file
dataZip <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(dataZip, 'household_power_consumption.zip', mode='wb')
unzip('./household_power_consumption.zip')

## load data into R
unzippedfile <- "household_power_consumption.txt"
data <- read.table(unzippedfile,
                   header=TRUE,
                   sep=";",
                   colClasses=c("character", "character", rep("numeric",7)),
                   na="?")

## taking out only feb 01 and feb 02 for 2007
# first we need to convert the Date column to date type
data$Date <- as.Date(data$Date, "%d/%m/%Y")
# take out only the data for feb 01 and 02 2007
date_range <- as.Date(c("2007-02-01", "2007-02-02"), "%Y-%m-%d")
data <- subset(data, data$Date %in% date_range)
# time is used as well, so we need to convert the time
# this is placed here because processing 2880 rows is definitely faster than process all
data$Time <- strptime(paste(
  format(data$Date,format="%d/%m/%Y")
  , data$Time), "%d/%m/%Y %H:%M:%S")

## data cleaning
# we will need to remove the row with data$Global_active_power or data$Time is NA so the plot will be working
data <- na.omit(data) #basically all column are used, so we can just remove all rows with NA to ensure no error


## plot the graph
#plot the 4 in one grpah
png("plot4.png", width=480, height=480)

# a 4 split screen on grpahic device
grid <- c(2,2)
par(mfrow=grid)
# top left
plot(data$Time,data$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power")

# top right
plot(data$Time,data$Voltage,type="l",xlab="datetime",ylab="Voltage")

# bottom left
plot(data$Time,data$Sub_metering_1,type="l",col="black",xlab="",ylab="Energy sub metering")
lines(data$Time,data$Sub_metering_2,col="red")
lines(data$Time,data$Sub_metering_3,col="blue")
legend("topright",
       col=c("black","red","blue"),
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=1,
       box.lwd=0)

# bottom right
plot(data$Time,data$Global_reactive_power,type="n",xlab="datetime")
lines(data$Time,data$Global_reactive_power)

dev.off()