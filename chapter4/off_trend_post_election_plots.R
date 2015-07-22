# ---------------------------------------------------------------------------- #
# Create descriptive plot of off-trend central government debt vs. post-election
# year
# Christopher Gandrud
# MIT License
# ---------------------------------------------------------------------------- #

# Load required packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(DataCombine)

# Set working directory. Change as needed
possible_wd <- c('/git_repositories/whose_account_book/')
repmis::set_valid_wd(possible_wd)

# Estimate model
source('chapter4/regressions.R')

# Extract residuals (i.e. off-trend debt)
res <- residuals(m_r1)

for_plot <- data.frame(country = sub_debt$country, 
                       year = sub_debt$year, 
                       residuals = res,
                       change_resid = sub_debt$rs_change_debt,
                       post_election = sub_debt$election_year_1)

for_plot$year <- as.integer(as.character(for_plot$year))

for_plot <- for_plot %>% arrange(country, year)

for_plot$post_election_year <- for_plot$year * 
                                as.numeric(as.character(for_plot$post_election))
for_plot$post_election_year[for_plot$post_election == 0] <- NA

for_plot <- subset(for_plot, !(country %in% c('Indonesia', 'India', 
                                              'Russian Federation')))

# Plot
comb_plot <- list()
for (i in unique(for_plot$country)) {
    message(i)
    temp <- subset(for_plot, country == i)
    comb_plot[[i]] <- ggplot(temp, aes(year, residuals, group = country)) +
                        geom_line() +
                        geom_vline(aes(xintercept = post_election_year),
                                   linetype = 'longdash', color = '#D8B70A') +
                        geom_hline(yintercept = 0, linetype = 'dotted') +
                        scale_x_continuous(breaks = c(2003, 2007, 2010)) +
                        xlab('') + ylab('') + ggtitle(i) +
                        theme_bw()
}

pdf('figures/off_trend_post_elect_desc.pdf', width = 15, height = 15)
    do.call(grid.arrange, comb_plot)
dev.off()
