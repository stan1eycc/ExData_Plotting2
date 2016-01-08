# Check input file. Automatic download it for running
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "NEI_data.zip"
if ( !file.exists(filename) ) {
    download.file( url, filename, mode = "wb", method="curl")
    unzip(filename)
}

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# This code requires dplyr
library(dplyr)

# With dplyr, sum all Emissions and group by years.
# Plot with base plot system.
dt <- NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
with(dt, plot(year,Emissions,xlab="Year",ylab = "PM2.5 Emissions (tons)", 
              type="o",main="Total PM2.5 Emissions in the United States"))

# Save to png
dev.copy(png,file="plot1.png",width = 480, height = 480)
dev.off()
