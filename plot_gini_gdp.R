# Gini/GDP plot.ly plot

# Libs --------------------------------------------------------------------

require(plotly); require(SmarterPoland); require(ggplot2); require(reshape)
require(grid); require(scales)

# Data sourcing and merging------------------------------------------------

# Source the required data tables via the SmasterPoland package
gini.dta <- getEurostatRCV(kod = "ilc_di12")
gdp.dta <- getEurostatRCV(kod = "nama_aux_gph")
gdp.dta <- subset(x = gdp.dta, subset = unit == 'EUR_HAB' & indic_na == 'NGDPH')

# Merge the data sets by column and by time
dta.mrg <- merge(x = gdp.dta, y = gini.dta, by = c("geo", "time"),
                 suffixes = c(".gdp",".gini"))

# Melt the data for the plot, as ggplot likes long format
dta.mlt <- melt(data = dta.mrg, id = c("geo","time"),
                measure = c("value.gdp", "value.gini"))
# Format date
dta.mlt$time <- as.Date(x = dta.mlt$time, format = "%Y")
# Remove incomplete rows
dta.mlt <- dta.mlt[complete.cases(dta.mlt),]
# Proper names
dta.mlt$variable <- gsub("value.", "", dta.mlt$variable)


# Chart -------------------------------------------------------------------

# Make plot in ggplot
ggplot(data = subset(x = dta.mlt, subset = geo == 'UK' | geo == 'PL'),
       aes(x = time, y = value, colour = geo)) +
    geom_line(size = 1.5) +
    scale_x_date(breaks = "1 year", labels = date_format("%Y")) +
    facet_grid(variable ~ ., scales = 'free_y') +
    ggtitle("Gini and GDP") +
    xlab("Year") +
    ylab("Value") +
    theme(plot.title = element_text(size = 14, face="bold"),
          plot.background = element_rect(fill = 'white', colour = 'white'),
          panel.background = element_rect(fill = 'white', colour = 'black'),
          panel.grid.major = element_line(colour = "gray", linetype = "dashed"),
          axis.text.x=element_text(size = 12, colour = "black", angle = 45, hjust = 1),
          axis.text.y=element_text(size = 12, colour = "black"),
          axis.title=element_text(size = 12, colour = "black", face = "bold"),
          legend.position="bottom",
          legend.title=element_blank(),
          legend.background = element_rect(colour = 'black', fill = 'white'),
          legend.key=element_rect(fill=NA),
          legend.key.width=unit(2,"cm"))

# Push plot to plot.ly
py <- plotly()
py$ggplotly()
