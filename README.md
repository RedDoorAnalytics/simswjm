
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
joint modeling”, published in [Statistics in
Medicine](https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.10347). A
pre-print is also [available on
arXiv](https://arxiv.org/abs/2404.14840).

# Installation

You can install the development version of {simswjm} from
[GitHub](https://github.com/RedDoorAnalytics/simswjm) with:

``` r
# install.packages("remotes")
remotes::install_github("RedDoorAnalytics/simswjm")
```

# Example code

Example code to fit mixed-effects and joint models using the simulated
data is included within this repository as well, in the
[`testing/`](https://github.com/RedDoorAnalytics/simswjm/tree/main/testing)
folder. Specifically, models are fit using the `gsem` command in Stata
for continuous, binary, count outcomes; more details in [this
file](https://github.com/RedDoorAnalytics/simswjm/blob/main/testing/02-testanalysis.do).

# Citation

If you find this useful, please cite it in your work:

``` r
citation("simswjm")
#> To cite package 'simswjm' in publications use:
#> 
#>   Gasparini A, Crowther MJ, Hoogendijk EO, Li F, Harhay MO (2025).
#>   "Analysis of cohort stepped wedge cluster-randomized trials with
#>   non-ignorable dropout via joint modeling." _Statistics in Medicine_,
#>   *44*(5), e10347. doi:10.1002/sim.10347
#>   <https://doi.org/10.1002/sim.10347>,
#>   <https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.10347>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {Analysis of cohort stepped wedge cluster-randomized trials with non-ignorable dropout via joint modeling},
#>     author = {Alessandro Gasparini and Michael J. Crowther and Emiel O. Hoogendijk and Fan Li and Michael O. Harhay},
#>     year = {2025},
#>     journal = {Statistics in Medicine},
#>     volume = {44},
#>     number = {5},
#>     pages = {e10347},
#>     doi = {10.1002/sim.10347},
#>     url = {https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.10347},
#>   }
```

# Issues

If you have any questions or feedback on the package or experience any
bugs, please [file an issue on
GitHub](https://github.com/RedDoorAnalytics/simswjm/issues).
