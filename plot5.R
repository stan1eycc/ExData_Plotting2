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

# Search "Vehicles" in Column "SCC.Level.Two".
# With dplyr, filter out Baltimore city FIPS and SCC from previous step.
# Following with similar processes as question 2.
scclist <- as.character(SCC[grep("Vehicles",SCC$SCC.Level.Two),]$SCC)
dt <- NEI %>% filter(fips=="24510") %>% filter(SCC %in% scclist) %>% 
    group_by(year) %>% summarise(Emissions = sum(Emissions))
g <- ggplot(dt,aes(year,Emissions))
g + geom_line() + geom_point() + xlab("Year") + ylab("PM2.5 Emissions (tons)") +
    ggtitle("PM2.5 Emissions from Motor Vehicle Sources")

# Save to png
ggsave(filename="plot5.png",width=5.6, height=4.8, dpi=100)
