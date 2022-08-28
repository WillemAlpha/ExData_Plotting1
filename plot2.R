
#see to it that a data file exist or is created
if(!file.exists("./data")){dir.create("./data")}

#Download file from the interwebs and unzip
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!(file.exists("data/powerCon.zip")))
{ download.file(file_url, destfile ="data/powercon.zip", method="curl")}
if (!file.exists("./data/household_power_consumption.txt"))
{unzip(zipfile = "data/powerCon.zip", exdir="data")}

# Instal pacakages
install.packages("tidyverse")
install.packages("readr")
install.packages("chron")

# Load packages
library(tidyverse)
library(readr)
library(chron)


# Read semicolon (";") separated values
        var_types <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"  )
        #var_names <- c("Date(dd/mm/yyyy)", "Time(hh:mm:ss)", "power_active_global(kW)", "power_reactive_global(kW)", "voltage(V)", "current_global(A)", "energyUse_sub1(Wh)", "energyUse_sub2(Wh)", "energyUse_sub3(Wh)")
        var_names <- c("date", "time", "power_active_global", "power_reactive_global", "voltage", "current_global", "energyUse_sub1", "energyUse_sub2", "energyUse_sub3")
        plot1_data <- read.csv2("./data/household_power_consumption.txt", sep = ";", dec = ".", colClasses = var_types, col.names = var_names, na.strings = "?", skip = 66636, nrows = 2880)

#convert date column to date
        plot1_data$date <- as.Date(plot1_data$date, format = "%d/%m/%Y")
        #alternatively:
        #plot1_data$date <- strptime(plot1_data$date, format = "%d/%m/%Y")

#convert time with chron package
plot1_data$time <- chron(times. = plot1_data$time)

#Add column with combined date and time in POSIXct format
#note that the as.date() or strptime() functions already convert the date to default format so the format specs aren't really necessary here
desired_format <- "%Y-%m-%d %H:%M:%S"
plot1_data <- mutate(plot1_data, date_time = as.POSIXct(paste(plot1_data$date, plot1_data$time), format = desired_format), .keep = "all", .before = date)

#Screen plot
#with(plot1_data, base::plot(date_time, power_active_global, type = "l", ylab = "Global Active Power (kW)", xlab = ""  ))

#see to it that a results file exist or is created
if(!file.exists("./results")){dir.create("./results")}

png(filename = "./results/plot2.png", width = 480, height = 480)
with(plot1_data, base::plot(date_time, power_active_global, type = "l", ylab = "Global Active Power (kW)", xlab = ""  ))
dev.off()





