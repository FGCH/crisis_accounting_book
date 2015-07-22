# ---------------------------------------------------------------------------- #
# Off-Trend Debt Regression Results
# Christopher Gandrud
# MIT LICENSE
# ---------------------------------------------------------------------------- #

# Load required packages
library(devtools)
library(dplyr)
library(DataCombine)
library(stargazer)

# Set working directory. Change as needed
possible_wd <- c('/git_repositories/whose_account_book/')
repmis::set_valid_wd(possible_wd)

# Estimate model
source('chapter4/regressions.R')

# Load plot function
devtools::source_gist('d270ff55c2ca26286e90')

# Set working directory. Change as needed
possible_wd <- c('/git_repositories/whose_account_book/')
repmis::set_valid_wd(possible_wd)

# Create residuals table
stargazer(m_r1,
          dep.var.labels = c('Central Gov. Debt \\% GDP (2005 GDP rebased)'),
          covariate.labels = c('Debt$_{t-1}$',
                               'FinStress',
                               'Output Gap'),
          omit = 'iso2c', omit.labels = 'country fixed effects',
          float = F,
          df = F,
          notes = ('Standard errors in parentheses.'),
          out = 'tables/debt_residual_regress.tex'
)

stargazer(m1_t1, m2_t1, m3_t1, m4_t1, m5_t1, m6_t1,
          dep.var.labels = c('$\\Delta$ Off-Trend Debt',
                             '$\\Delta$ Off-Trend Spending'),
          covariate.labels = c('$\\Delta$ Off-Trend Debt$_{t-1}$',
                               '$\\Delta$ Off-Trend Spend',
                               '$\\Delta$ Off-Trend Spend$_{t-1}$',
                               'Post-Election Yr.', 'Loss Prob.',
                               'Econ Ideology', 'Political Constraints',
                               'Fixed FX',
                               'Post-Election Yr. * Loss Prob.'),
          omit = 'iso2c', omit.labels = 'country fixed effects',
          float = F,
          df = F,
          font.size = 'tiny',
          notes = ('Standard errors in parentheses.'),
          out = 'tables/elect_regressions.tex'
)


##### Plot stress/crisis interaction
plot_me(obj = m5_t1, term1 = 'election_year_11', term2 = 'lpr',
        fitted2 = seq(0, 0.75, by = 0.05)) +
    scale_y_continuous(limits = c(-10, 13)) +
    xlab('\nElectoral Loss Probability') +
    ylab('Marginal Effect of Post-Election Year\n') +
    ggtitle('Change in Off-Trend Debt\n')

ggsave(filename = 'figures/post_elect_loss.pdf')
