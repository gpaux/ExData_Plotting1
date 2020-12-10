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
household_power_consumption <- fread(cmd = 'unzip -cq elec_power.zip') 
str(household_power_consumption)

## Tranform the data ----
### Assign the correct format to each variable
household_power_consumption_fmt <- household_power_consumption %>% 
    mutate(Date = dmy(Date)) %>% 
    filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% ### Filter the data from 2007-02-01 and 2007-02-02
    mutate_each(funs(replace(., .  == "?", "")),-Date) %>% ### Replace the ? by missing
    mutate(Time = strptime(paste(Date,Time), "%Y-%m-%d  %H:%M:%S"),
           Global_active_power  = as.numeric(Global_active_power),
           Global_reactive_power = as.numeric(Global_reactive_power),
           Voltage = as.numeric(Voltage),
           Global_intensity = as.numeric(Global_intensity),
           Sub_metering_1 = as.numeric(Sub_metering_1),
           Sub_metering_2 = as.numeric(Sub_metering_2),
           Sub_metering_3 = as.numeric(Sub_metering_3))
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
