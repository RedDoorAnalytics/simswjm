#' Simulate Data from a Stepped-Wedge Trial with Informative Dropout
#'
#' @description
#' The [swtrial_inf()] function can be used to simulate data from a stepped wedge
#' cluster randomised trial with (or without) informative dropout, depending on
#' the values of the `omega1`, `omega2`, `omega3`, or `nu` arguments. More
#' information on the dropout mechanisms are included in the details section below.
#'
#' @param repn Index number for the current dataset, useful for simulations;
#' @param k Number of subjects per cluster;
#' @param i Number of clusters, passed to [make_stepped_wedge_design()].
#'     Defaults to 8;
#' @param j Number of time periods, passed to [make_stepped_wedge_design()].
#'     Defaults to 5;
#' @param intervention_seq Number of intervention sequences, passed to [make_stepped_wedge_design()].
#'     Defaults to 4
#' @param deltas Treatment effect parameter(s) on the longitudinal outcome.
#'     Must be a vector of length `j - 1`, corresponding to a general time on
#'     treatment model, but if all values are the same then that is equivalent
#'     to a constant intervention effect model;
#' @param betas Period effect parameters. Must be a vector of length `j`;
#' @param family Distribution of the outcome. Can be one of `"gaussian"`,
#'     `"binomial"`, or `"poisson"` for continuous, binary, count outcomes,
#'     respectively. Default link functions are assumed: identity for continuous
#'     outcomes, logit for binary outcomes, and log for count outcomes;
#' @param sigma_epsilon Standard deviation of the residual error term. Only
#'     applies when `family = "gaussian"`, and defaults to 0.0;
#' @param sigma_alpha Standard deviation of cluster-level random effect \eqn{\alpha}.
#'     Defaults to 0.0;
#' @param sigma_gamma Standard deviation of period-level random effect \eqn{\gamma};
#'     Defaults to 0.0;
#' @param sigma_phi Standard deviation of subject-level random effect \eqn{\phi}.
#'     Defaults to 0.0;
#' @param lambda Scale parameter of the Weibull baseline hazard function.
#'     Defaults to 0.05;
#' @param p Shape parameter of the Weibull baseline hazard.
#'     Defaults to 2;
#' @param nu Treatment effect in the survival submodel. Defaults to 0.0;
#' @param omega1 Association parameter linking the random intercept \eqn{\alpha}
#'     to the survival sub-model. Defaults to 0.0;
#' @param omega2 Association parameter linking the random intercept \eqn{\gamma}
#'     to the survival sub-model. Defaults to 0.0;
#' @param omega3 Association parameter linking the random intercept \eqn{\phi}
#'     to the survival sub-model. Defaults to 0.0.
#' @param logistic_dropout Logical value denoting whether a mixed effects logistic
#'     regression model should be used to simulate the dropout process instead of
#'     a parametric survival model. Defaults to `FALSE`. See the details section
#'     below for more information.
#' @param logistic_intercept Intercept of the logistic regression model, used when `logistic_dropout = TRUE`. Defaults to -2.
#'
#' @return A simulated dataset from a stepped wedge trial with possibly informative
#'     dropout.
#'
#' @details The model for dropout is, assuming default settings, a Weibull parametric
#'     survival model with scale parameter `lambda` and shape parameter `p`.
#'     If we set the argument `logistic_dropout = TRUE` (compared to the default
#'     value of `FALSE`), the dropout model is a mixed effects logistic regression
#'     model with the same linear predictor structure of the survival sub-model,
#'     assuming that once a subject drops out of the study they are never observed
#'     ever again. Note that the linear predictor of the mixed effects logistic
#'     model is standardised using the [scale()] function (with default
#'     arguments) before being combined with the user-defined intercept
#'     (argument `logistic_intercept`).
#'
#' @export
#'
#' @examples
#' # Simulate a stepped-wedge trial with a continuous outcome:
#' swtrial_inf(
#'   repn = 1, k = 3, i = 4, j = 5, intervention_seq = 4,
#'   deltas = c(0.5, 0.5, 0.5, 0.5),
#'   betas = c(0, 0.1, 0.2, 0.3, 0.4),
#'   family = "gaussian",
#'   sigma_epsilon = 1,
#'   sigma_alpha = 2,
#'   sigma_gamma = 0,
#'   sigma_phi = 3,
#'   omega1 = 1, omega3 = 1
#' )
swtrial_inf <- function(repn, k, i = 8, j = 5, intervention_seq = 4, deltas, betas, family, sigma_epsilon = 0.0, sigma_alpha = 0.0, sigma_gamma = 0.0, sigma_phi = 0.0, lambda = 0.05, p = 2, nu = 0.0, omega1 = 0.0, omega2 = 0.0, omega3 = 0.0, logistic_dropout = FALSE, logistic_intercept = -2) {
  # repn <- 1
  # k <- 10
  # i <- 8
  # j <- 5
  # intervention_seq <- 4
  # deltas <- rep(5, 4)
  # betas <- rep(30, 5)
  # family <- "gaussian"
  # sigma_epsilon <- 40.0
  # sigma_alpha <- 2.0
  # sigma_gamma <- 0.0
  # sigma_phi <- 55.0
  # lambda <- exp(-1.5)
  # p <- 1.0
  # nu <- -0.2
  # omega1 <- log(0.9)
  # omega2 <- 0.0
  # omega3 <- log(0.9)
  # logistic_dropout <- TRUE
  # logistic_intercept <- -2

  # Simulate trial without dropout
  df <- swtrial(repn = repn, k = k, i = i, j = j, intervention_seq = intervention_seq, deltas = deltas, betas = betas, family = family, sigma_epsilon = sigma_epsilon, sigma_alpha = sigma_alpha, sigma_gamma = sigma_gamma, sigma_phi = sigma_phi)
  # Sort again (to be sure)
  df <- dplyr::arrange(df, i, id, j)

  # Dropout, survival model:
  if (isFALSE(logistic_dropout)) {
    # Add time (start of discrete intervention period) and tJ (time of intervention drop-in)
    df <- dplyr::mutate(df,
      t = j - 1,
      tJ = ifelse(x == 1, t, NA),
      tJ = min(tJ, na.rm = TRUE),
      .by = "id"
    )
    # Then, move onto the survival (drop-out) part
    survdf <- dplyr::distinct(df, id, alpha, gamma, phi, tJ)
    uu <- stats::runif(n = nrow(survdf))
    xb <- with(survdf, omega1 * alpha + omega2 * gamma + omega3 * phi)
    b <- as.numeric(-log(uu) < (lambda * exp(xb) * (survdf$tJ^p)))
    T1 <- (-log(uu) / (lambda * exp(xb)))^(1 / p)
    T2 <- ((-log(uu) - lambda * exp(xb) * (survdf$tJ^p) + lambda * exp(nu) * exp(xb) * (survdf$tJ^p)) / (lambda * exp(nu) * exp(xb)))^(1 / p)
    survdf$eventtime <- (T1^(b == 1)) * (T2^(b == 0))
    survdf <- dplyr::mutate(survdf, status = as.numeric(eventtime <= j))
    survdf <- dplyr::mutate(survdf, actual_eventtime = eventtime)
    survdf <- dplyr::mutate(survdf, eventtime = pmin(eventtime, j))
    # Merge back drop-out information and censor trajectories
    df <- dplyr::left_join(df, survdf, by = c("id", "alpha", "gamma", "phi", "tJ"))
    df <- dplyr::mutate(df, yobs = ifelse((j - 1) <= eventtime, y, NA))
    # Sort again (to be sure)
    df <- dplyr::arrange(df, i, id, j)
    # Prepare datasets for analysis
    df <- dplyr::mutate(df, d = status, t0 = j - 1)
    df <- dplyr::mutate(df,
      t0 = ifelse(t0 < eventtime, t0, NA),
      d = ifelse(t0 < eventtime, d, NA)
    )
    df <- dplyr::group_by(df, id)
    df <- dplyr::mutate(df, t = dplyr::lead(t0))
    df <- dplyr::mutate(df, t = ifelse(is.na(t) & !is.na(t0), eventtime, t))
    df <- dplyr::mutate(df, d = ifelse(t0 == max(t0, na.rm = TRUE), d, 0))
    df <- dplyr::ungroup(df)
    df <- dplyr::select(df, repn, i, id, j, jid, x, cumx, y, yobs, t0, t, d, eventtime, actual_eventtime)
  } else {
    logdf <- df
    # Probability of dropout for a given interval
    logdf$p <- stats::plogis(q = c(scale(logdf$xb)) + logistic_intercept)
    # Draw and process dropout indicator
    logdf$status <- stats::rbinom(n = nrow(logdf), size = 1, prob = logdf$p)
    logdf <- dplyr::group_by(logdf, id)
    logdf <- dplyr::mutate(logdf, status = cumsum(status))
    logdf <- dplyr::mutate(logdf, d = pmin(status, 1))
    # Sort again (to be sure)
    logdf <- dplyr::arrange(logdf, i, id, j)
    # Identify dropout time
    logdf$u <- stats::runif(n = nrow(logdf))
    logdf <- dplyr::filter(logdf, status <= 1)
    logdf <- dplyr::mutate(logdf, eventtime = (j - 1) + u)
    logdf <- dplyr::summarise(logdf, eventtime = max(eventtime))
    # Merge back drop-out information and censor trajectories
    df <- dplyr::left_join(df, logdf, by = "id")
    df <- dplyr::mutate(df, yobs = ifelse((j - 1) <= eventtime, y, NA))
    # Sort again (to be sure)
    df <- dplyr::arrange(df, i, id, j)
    # Prepare datasets for analysis
    df <- dplyr::mutate(df, t0 = j - 1, t = j)
    df <- dplyr::mutate(df,
      t0 = ifelse(t0 < eventtime, t0, NA),
      d = ifelse(t < eventtime, 0, 1),
      t = ifelse(t < eventtime, t, NA)
    )
    df <- dplyr::mutate(df, t = ifelse(!is.na(t0) & is.na(t), eventtime, t))
    df <- dplyr::mutate(df, d = ifelse(is.na(t0) & is.na(t), NA, d))
    df <- dplyr::ungroup(df)
    df <- dplyr::select(df, repn, i, id, j, jid, x, cumx, y, yobs, t0, t, d, eventtime)
  }
  # Sort again (to be sure)
  df <- dplyr::arrange(df, i, id, j)
  # Output to return
  return(df)
}
