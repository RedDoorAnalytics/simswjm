
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {simswjm}: Simulating Stepped Wedge Trials With and Without Informative Dropout

<!-- badges: start -->

[![R-CMD-check](https://github.com/RedDoorAnalytics/simswjm/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/RedDoorAnalytics/simswjm/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The {simswjm} package can be used to simulate data from stepped wedge
trials with a continuous, binary, or count longitudinal outcome.
Moreover, data can be simulated assuming both non-informative and
informative dropout, with the dropout mechanism according to a joint
longitudinal-survival model with shared random effects or (loosely)
based on a mixed effects logistic regression model.

This package is a companion to the manuscript titled “Analysis of cohort
stepped wedge cluster-randomized trials with non-ignorable dropout via
joint modeling”, which is currently submitted for publication. A
pre-print is [available on arXiv](https://arxiv.org/abs/2404.14840).

# Installation

You can install the development version of {simswjm} from
[GitHub](https://github.com/RedDoorAnalytics/simswjm) with:

``` r
# install.packages("remotes")
remotes::install_github("RedDoorAnalytics/simswjm")
```

# Issues

If you have any questions or feedback on the package or experience any
bugs, please [file an issue on
GitHub](https://github.com/RedDoorAnalytics/simswjm/issues).
