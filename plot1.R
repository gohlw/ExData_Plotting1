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

## time to plot the graph
# NOTE : if during the first time you run this script, the png is display as a blank file with grey background,
#        close R studio, and by right the graph will be print to the PNG file and display properly
png("plot1.png", width=480, height=480) #open a plot device
hist(data$Global_active_power,
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency",
     col="red")
dev.off()