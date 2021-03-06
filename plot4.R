# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get SCC codes related to Coal combustion
# All the Coal comb ones have coal in them for their EI.sector, so simple grep
SCC_Index <- grep('Coal', SCC$EI.Sector)
SCC_Codes <- SCC[SCC_Index,'SCC']

# Subset NEI using the extracted SCC codes
coal_comb_NEI <- NEI[NEI$SCC %in% SCC_Codes,]

# Aggregate the sums for the entire US
aggregated <- aggregate(Emissions~year, sum, data=coal_comb_NEI)

# Round for clealiness
aggregated$Emissions <- as.numeric(lapply(aggregated$Emissions, function (x) {
  round(x/1000)
}))

# Make a plot using GG and bar graphs, call PNG device to write
dev.copy(png, filename='plot4.png', height=480, width=960)
ggplot(data=aggregated, aes(x=year, y=Emissions)) +
  labs(title='US Coal Combustion Related PM2.5, 1999-2005',
    x='Year',
    y='PM2.5 (thousands of tons)'
  ) +
  geom_bar(stat="identity") +
  scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), labels=c('1999', '2002',
                                                                '2005', '2008')) +
  stat_smooth(method='lm', color='red', level=0)
dev.off()

