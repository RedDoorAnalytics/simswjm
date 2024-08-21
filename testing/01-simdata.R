library(tidyverse)
library(haven)
library(devtools)
devtools::load_all()
set.seed(458622)
.k <- 50
.i <- 120

### Continuous:

# Gaussian, not informative:
d0g <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.2, 4),
  betas = rep(50, 5),
  family = "gaussian",
  sigma_epsilon = sqrt(50),
  sigma_alpha = sqrt(1),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(55),
  nu = -0.2,
  lambda = exp(-1.5),
  p = exp(0.0)
)
# Gaussian, informative:
d1g <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.2, 4),
  betas = rep(50, 5),
  family = "gaussian",
  sigma_epsilon = sqrt(50),
  sigma_alpha = sqrt(1),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(55),
  nu = -0.2,
  lambda = exp(-1.5),
  p = exp(0.0),
  omega1 = -0.1,
  omega2 = 0.0,
  omega3 = -0.1
)

### Binary:

# Binary, not informative:
d0b <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.2, 4),
  betas = rep(-2, 5),
  family = "binomial",
  sigma_alpha = sqrt(0.2),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(1.0),
  nu = -0.1,
  lambda = exp(-1.5),
  p = exp(0.0)
)
# Binary, informative:
d1b <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.2, 4),
  betas = rep(-2, 5),
  family = "binomial",
  sigma_alpha = sqrt(0.2),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(1.0),
  nu = -0.1,
  lambda = exp(-1.5),
  p = exp(0.0),
  omega1 = 1.0,
  omega2 = 0.0,
  omega3 = 0.4
)

### Count:

# Count, not informative:
d0c <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.1, 4),
  betas = rep(-1, 5),
  family = "poisson",
  sigma_alpha = sqrt(0.3),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(1.7),
  nu = -0.2,
  lambda = exp(-1.5),
  p = exp(0.0)
)
# Count, informative:
d1c <- swtrial_inf(
  repn = 1,
  k = .k,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = rep(0.1, 4),
  betas = rep(-1, 5),
  family = "poisson",
  sigma_alpha = sqrt(0.3),
  sigma_gamma = 0.0,
  sigma_phi = sqrt(1.7),
  nu = -0.2,
  lambda = exp(-1.5),
  p = exp(0.0),
  omega1 = 0.8,
  omega2 = 0.0,
  omega3 = 0.3
)

### Export
haven::write_dta(data = d0g, path = "testing/d0g.dta")
haven::write_dta(data = d1g, path = "testing/d1g.dta")
haven::write_dta(data = d0b, path = "testing/d0b.dta")
haven::write_dta(data = d1b, path = "testing/d1b.dta")
haven::write_dta(data = d0c, path = "testing/d0c.dta")
haven::write_dta(data = d1c, path = "testing/d1c.dta")
