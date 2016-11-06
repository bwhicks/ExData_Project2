# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset readings for Baltimore City
Baltimore <- subset(NEI, fips == "24510")

# Create subsets for each of the types of pollution, make a dataframe 
# from aggregate
point <- aggregate(Emissions~year, sum, data=subset(Baltimore, type =='POINT')) 
nonpoint <- aggregate(Emissions~year, sum, 
                      data=subset(Baltimore, type == 'NONPOINT'))
onroad <- aggregate(Emissions~year, sum, 
                    data=subset(Baltimore, type =='ON-ROAD'))
nonroad <- aggregate(Emissions~year, sum, 
                     data=subset(Baltimore, type == 'NON-ROAD'))

aggregate_df <- data.frame(point$year, point$Emissions, 
                           nonpoint$Emissions, onroad$Emissions, 
                           nonroad$Emissions)
names <- c('Year', 'Point', 'Nonpoint', 'On-road', 'Non-road')
colnames(aggregate_df) <- names

melted <- melt(aggregate_df, id.vars='Year')

png(filename = 'plot3.png', width=960, height=480)
ggplot(melted,
  aes(x=Year, y=value, color=variable)) +
  labs(title = "Baltimore City PM2.5 from all sources, 1999-2008",
       x='Year (3-year intervals)',
       y='PM2.5 (Tons)',
       color='Source Type') +
  scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), labels=c('1999', '2002',
                                                              '2005', '2008')) +
  geom_line()
dev.off()