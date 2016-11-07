# Set working directory, assumes the .rds files are in the dir
setwd('~/R-project-2-ex-data/')
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Roll up data based on year for Emissions
aggregated_data <- aggregate(Emissions~year, sum, data=NEI)
aggregated_data$Emissions <- as.numeric(lapply(aggregated_data$Emissions, 
                                    function(x) {x/1000000}))
#Open the PNG device
dev.copy(png, filename='plot1.png', width=960, height=480)

# Build the base plot and labels, disable x-axis
plot(aggregated_data$year, aggregated_data$Emissions, xaxt='n',
     main='Total US Emissions of PM2.5 1999-2008', sub='three year intervals',
     xlab='Year', ylab='PM2.5 (millions of tons)')

# Build a three year x-axis
v1 <- c(1999, 2002, 2005, 2008)
v1_char <- as.character(v1)

# Print the axis
axis(1,
     at = v1,
     labels = v1_char
     )
# Make a regression line to highlight the decrease
fit <- lm(Emissions~year, data=aggregated_data)
abline(fit, col='red')

# Close the device.
dev.off()
