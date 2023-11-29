library(tidyverse)
library(haven)
library(devtools)
devtools::load_all()
set.seed(458622)
.N <- 25
.i <- 4 * 25
.delta <- rep(0.5, 4)
.beta <- seq(0, 1, length.out = 5)
.sa <- 1.5
.sg <- 0.0
.sp <- 2.5
.se <- sqrt(10)
.nu <- 0.0
.omega <- 1.0

### Continuous:

# Gaussian, not informative:
d0g <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "gaussian",
  sigma_epsilon = .se,
  sigma_alpha = .sa,
  sigma_gamma = .sg,
  sigma_phi = .sp,
  nu = .nu
)
# Gaussian, informative:
d1g <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "gaussian",
  sigma_epsilon = .se,
  sigma_alpha = .sa,
  sigma_gamma = .sg,
  sigma_phi = .sp,
  nu = .nu,
  omega1 = .omega,
  omega2 = .omega, # shouldn't matter
  omega3 = .omega
)

### Binary:

# Binary, not informative:
d0b <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "binomial",
  sigma_alpha = .sa,
  sigma_gamma = .sg,
  sigma_phi = .sp,
  nu = .nu
)
# Binary, informative:
d1b <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "binomial",
  sigma_alpha = .sa,
  sigma_gamma = .sg,
  sigma_phi = .sp,
  nu = .nu,
  omega1 = .omega,
  omega2 = .omega, # shouldn't matter
  omega3 = .omega
)

### Count:

# Count, not informative:
d0c <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "poisson",
  sigma_alpha = .sa / 3,
  sigma_gamma = .sg / 3,
  sigma_phi = .sp / 3,
  nu = .nu
)
# Count, informative:
d1c <- swtrial_inf(
  repn = 1,
  N = .N,
  i = .i,
  j = 5,
  intervention_seq = 4,
  deltas = .delta,
  betas = .beta,
  family = "poisson",
  sigma_alpha = .sa / 3,
  sigma_gamma = .sg / 3,
  sigma_phi = .sp / 3,
  nu = .nu,
  omega1 = .omega,
  omega2 = .omega, # shouldn't matter
  omega3 = .omega
)

### Export
haven::write_dta(data = d0g, path = "testing/d0g.dta")
haven::write_dta(data = d1g, path = "testing/d1g.dta")
haven::write_dta(data = d0b, path = "testing/d0b.dta")
haven::write_dta(data = d1b, path = "testing/d1b.dta")
haven::write_dta(data = d0c, path = "testing/d0c.dta")
haven::write_dta(data = d1c, path = "testing/d1c.dta")
