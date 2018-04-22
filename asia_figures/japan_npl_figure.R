# ---------------------------------------------------------------------------- #
# Japan NPLs plot
# Christopher Gandrud
# 2018-04-22
# ---------------------------------------------------------------------------- #

# Load required packages
library(pacman)
p_load(quantmod, ggplot2)

theme_set(theme_bw())

# Download data from World Development Indicators
getSymbols("DDSI02JPA156NWDB", src = "FRED")

# Convert to data.frame
jp_npl_df <- data.frame(date = index(DDSI02JPA156NWDB), coredata(DDSI02JPA156NWDB))

# Plot
ggplot(jp_npl_df, aes(date, DDSI02JPA156NWDB)) +
    geom_line() +
    scale_y_continuous(limits = c(0, 10)) +
    xlab("") + ylab("NPLs to Gross Loans (%)\n")

