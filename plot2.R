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

# Plot 2 ----
## Plot 2 is a lineplot of the Global Active Power by day
png(filename = "plot2.png", width = 480, height = 480, units = "px")
with(household_power_consumption_fmt, plot(x = Time, 
                                           y = Global_active_power, 
                                           type = "S",
                                           ylab = "Global Active Power (kilowatts)",
                                           xlab = ""))
dev.off()
