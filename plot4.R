# Load the libraries ----
library(data.table)
library(dplyr)
library(lubridate)
# Download the data ----
filename <- "elec_power.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = filename)
}
unzip(filename, list=TRUE)

# Dataset ----
## Get the data ----
household_power_consumption <- fread(cmd = 'unzip -cq elec_power.zip', 
                                     sep = ";",
                                     na.strings = "?",
                                     colClasses = c("character", "character", rep("numeric", 7))) 
str(household_power_consumption)

## Tranform the data ----
### Assign the correct format to each variable
household_power_consumption_fmt <- household_power_consumption %>% 
    mutate(Date = dmy(Date)) %>% 
    filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% ### Filter the data from 2007-02-01 and 2007-02-02
    mutate(Time = strptime(paste(Date,Time), "%Y-%m-%d  %H:%M:%S"))
str(household_power_consumption_fmt)

# Plot 4 ----
png(filename = "plot4.png", width = 480, height = 480, units = "px")
## Plot 4 is a 2*2 matrix of plots
par(mfrow = c(2, 2), mar = c(4,4,4,1), cex = 0.8)
#### top left plot
with(household_power_consumption_fmt, plot(x = Time, 
                                           y = Global_active_power, 
                                           type = "S",
                                           ylab = "Global Active Power (kilowatts)",
                                           xlab = ""))
#### top right plot
with(household_power_consumption_fmt, plot(x = Time, 
                                           y = Voltage, 
                                           type = "S",
                                           ylab = "Voltage",
                                           xlab = "datetime"))

### bottom left plot
with(household_power_consumption_fmt, plot(x = Time, 
                                           y = Sub_metering_1, 
                                           type = "S",
                                           ylab = "Energy sub metering",
                                           col = "black"))
with(household_power_consumption_fmt, lines(x = Time, 
                                            y = Sub_metering_2, 
                                            type = "S",
                                            ylab = "Energy sub metering",
                                            col = "red"))
with(household_power_consumption_fmt, lines(x = Time, 
                                            y = Sub_metering_3, 
                                            type = "S",
                                            ylab = "Energy sub metering",
                                            col = "blue"))
legend("topright", 
       lty = 1, 
       cex = 0.9, 
       col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty="n")

#### bottom right plot
#### top left plot
with(household_power_consumption_fmt, plot(x = Time, 
                                           y = Global_reactive_power, 
                                           type = "S",
                                           #ylab = "Global Active Power (kilowatts)",
                                           xlab = "datetime"))

dev.off()
