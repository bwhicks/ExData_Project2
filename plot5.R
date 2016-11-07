library(ggplot2)

# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI for Baltimore City and for ON-ROAD (assuming that motor vehicle
# manufacture is NOT part of what is to be assessed from the instructions)
Baltimore <- subset(NEI, type == 'ON-ROAD' & fips == '24510')

# Aggregate the totals and plot
aggregated <- aggregate(Emissions~year, sum, data=Baltimore)

# Round off jagged decimals to make chart cleaner without heavy overrides
aggregated$Emissions <- as.numeric(lapply(aggregated$Emissions, round))

dev.copy(png,filename='plot5.png', width=960, height=480)


ggplot(data=aggregated, aes(x=year, y=Emissions)) +
  labs(title='Motor Vehicle (ON-ROAD) Related PM2.5, Baltimore City, 1999-2005',
       x='Year',
       y='PM2.5 (tons)'
  ) +
  geom_bar(stat="identity") +
  scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), labels=c('1999', '2002',
                                                                '2005', '2008')) +
  stat_smooth(method='lm', color='red', level=0)

dev.off()
