#' Simulate Data from a Stepped-Wedge Trial with Informative Dropout
#'
#' @param repn Index number for the current dataset, useful for simulations;
#' @param N Number of subjects per cluster;
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
#'
#' @return A simulated dataset from a stepped wedge trial with possibly informative
#'     dropout.
#'
#' @export
#'
#' @examples
#' # Simulate a stepped-wedge trial with a continuous outcome:
#' swtrial_inf(
#'   repn = 1, N = 3, i = 4, j = 5, intervention_seq = 4,
#'   deltas = c(0.5, 0.5, 0.5, 0.5),
#'   betas = c(0, 0.1, 0.2, 0.3, 0.4),
#'   family = "gaussian",
#'   sigma_epsilon = 1,
#'   sigma_alpha = 2,
#'   sigma_gamma = 0,
#'   sigma_phi = 3,
#'   omega1 = 1, omega3 = 1
#' )
swtrial_inf <- function(repn, N, i = 8, j = 5, intervention_seq = 4, deltas, betas, family, sigma_epsilon = 0.0, sigma_alpha = 0.0, sigma_gamma = 0.0, sigma_phi = 0.0, lambda = 0.05, p = 2, nu = 0.0, omega1 = 0.0, omega2 = 0.0, omega3 = 0.0) {
  # Simulate trial without dropout
  df <- swtrial(repn = repn, N = N, i = i, j = j, intervention_seq = intervention_seq, deltas = deltas, betas = betas, family = family, sigma_epsilon = sigma_epsilon, sigma_alpha = sigma_alpha, sigma_gamma = sigma_gamma, sigma_phi = sigma_phi)
  # Sort again (to be sure)
  df <- dplyr::arrange(df, i, id, j)
  # Add time (start of discrete intervention period) and tJ (time of intervention drop-in)
  df <- dplyr::mutate(df,
    t = j - 1,
    tJ = ifelse(x == 1, t, NA),
    tJ = min(tJ, na.rm = TRUE),
    .by = c("id")
  )
  # Then, move onto the survival (drop-out) part
  survdf <- dplyr::distinct(df, id, alpha, gamma, phi, tJ)
  uu <- stats::runif(n = nrow(survdf))
  xb <- with(survdf, omega1 * alpha + omega2 * gamma + omega3 * phi)
  b <- as.numeric(-log(uu) < (lambda * exp(xb) * (survdf$tJ^p)))
  T1 <- (-log(uu) / (lambda * exp(xb)))^(1 / p)
  T2 <- ((-log(uu) - lambda * exp(xb) * (survdf$tJ^p) + lambda * exp(nu) * exp(xb) * (survdf$tJ^p)) / (lambda * exp(nu) * exp(xb)))^(1 / p)
  survdf[["eventtime"]] <- (T1^(b == 1)) * (T2^(b == 0))
  survdf <- dplyr::mutate(survdf, status = as.numeric(eventtime <= j))
  survdf <- dplyr::mutate(survdf, actual_eventtime = eventtime)
  survdf <- dplyr::mutate(survdf, eventtime = pmin(eventtime, j))
  # Merge back drop-out information and censor trajectories
  df <- dplyr::left_join(df, survdf, by = c("id", "alpha", "gamma", "phi", "tJ"))
  df <- dplyr::mutate(df, yobs = ifelse(j <= eventtime, y, NA))
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
  # Sort again (to be sure)
  df <- dplyr::arrange(df, i, id, j)
  # Output to return
  return(df)
}
