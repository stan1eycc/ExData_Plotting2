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

# After I analyzed the data in data frame, the emissions from coal 
# combustion-related sources can be filtered out by "Coal" in column "EI.Sector"
scclist <- as.character(SCC[grep("Coal",SCC$EI.Sector),]$SCC)
dt <- NEI %>% filter(SCC %in% scclist) %>% group_by(year) %>% 
    summarise(Emissions = sum(Emissions))
g <- ggplot(dt,aes(year,Emissions))
g + geom_line() + geom_point() + xlab("Year") + ylab("PM2.5 Emissions (tons)") +
    ggtitle("PM2.5 Emissions from Coal Combustion-related Sources")

# Save to png
ggsave(filename="plot4.png",width=5.8, height=4.8, dpi=100)
