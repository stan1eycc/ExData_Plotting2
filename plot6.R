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

# Filter one more fips "06037" and plot two trends on same graph to compare them
scclist <- as.character(SCC[grep("Vehicles",SCC$SCC.Level.Two),]$SCC)
dt <- NEI %>% filter(fips=="24510"|fips=="06037") %>% 
    filter(SCC %in% scclist) %>% group_by(year,fips) %>% 
    summarise(Emissions = sum(Emissions))
dt$fips <- factor(dt$fips)
g <- ggplot(dt,aes(year,Emissions,colour=fips))
g + geom_line() + geom_point() + 
    scale_color_manual("City\n",labels = c("LA", "BALTIMORE"), 
                       values = c("blue", "red")) +
    xlab("Year") + ylab("PM2.5 Emissions (tons)") +
    ggtitle("PM2.5 Emissions from Motor Vehicle Sources")

# Save to png
ggsave(filename="plot6.png",width=7.2, height=4.8, dpi=100)
