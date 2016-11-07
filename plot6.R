library(ggplot2)
library(reshape2)
# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI for Baltimore City and for ON-ROAD (assuming that motor vehicle
# manufacture is NOT part of what is to be assessed from the instructions)
Baltimore <- subset(NEI, type == 'ON-ROAD' & fips == '24510')

# Same for Los Angeles County
LA <- subset(NEI, type == 'ON-ROAD' & fips == '06037')

# Aggregate both
Baltimore <- aggregate(Emissions~year, sum, data=Baltimore)
LA <- aggregate(Emissions~year, sum, data=LA)

# Merge 'em
Baltimore$Location <- 'Baltimore City'
LA$Location <- 'Los Angeles County'
combined <- rbind(Baltimore, LA)

# Round 'em
combined$Emissions <- as.numeric(lapply(combined$Emissions, round))

# Melt and ggplot
melted <- melt(combined, id.vars=c('year', 'Location'))

dev.copy(png, filename = 'plot6.png', width=960, height=480)

ggplot(melted,
       aes(x=year, y=value, color=Location)) +
  labs(title = "Change in Motor Vehicle (ON-ROAD) PM2.5, Baltimore City and LA County",
       x='Year (3-year intervals)',
       y='PM2.5 (Tons)',
       color='County') +
  scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), labels=c('1999', '2002',
                                                                '2005', '2008')) +
  geom_line()

dev.off()
