# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset readings for Baltimore City
Baltimore <- subset(NEI, fips == "24510")

# Perform a role-up of Baltimore City data by year for Emissions
agg_Baltimore <- aggregate(Emissions~year, sum, data=Baltimore)


#Open the PNG device
png(filename='plot2.png', width=960, height=480)
# Build the base plot and labels, disable x-axis, add lines to show irregular
# drop.
plot(agg_Baltimore$year, agg_Baltimore$Emissions, xaxt='n',
     main='Total Baltimore City Emissions of PM2.5 1999-2008', 
     sub='three year intervals',
     xlab='Year', ylab='PM2.5 (tons)',
     type='b')

# Build a three year x-axis
v1 <- c(1999, 2002, 2005, 2008)
v1_char <- as.character(v1)

# Print the axis
axis(1,
     at = v1,
     labels = v1_char
)

# Make a regression line to highlight the overall decrease
fit <- lm(Emissions~year, data=agg_Baltimore)
abline(fit, col='red')


# Close the device.
dev.off()
