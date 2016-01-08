# Check input file. Automatic download it for running
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "NEI_data.zip"
if ( !file.exists(filename) ) {
    download.file( url, filename, mode = "wb", method="curl")
    unzip(filename)
}

# This code requires dplyr and ggplot2
library(dplyr)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Fllow the data in qutions 2. Add new group index "type" to group_by().
# Transform types into factor class in order to assign them as colour setting.
# Use ggplot2 system to plot 4 lines.
dt <- NEI %>% filter(fips=="24510") %>% group_by(year,type) %>% 
    summarise(Emissions = sum(Emissions))
dt$type <- factor(dt$type)
g <- ggplot(dt,aes(year,Emissions,colour=type))
g + geom_line() + geom_point() + xlab("Year") + ylab("PM2.5 Emissions (tons)") +
    ggtitle("PM2.5 Emissions in the Baltimore City")

# Save to png
ggsave(filename="plot3.png",width=7.2, height=4.8, dpi=100)
