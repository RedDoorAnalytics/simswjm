#' Simulate Data from a Stepped-Wedge Trial
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
#' @param sigma_gamma Standard deviation of period-level random effect \eqn{\gamma}.
#'     Defaults to 0.0;
#' @param sigma_phi Standard deviation of subject-level random effect \eqn{\phi}.
#'     Defaults to 0.0.
#'
#' @return A simulated dataset from a stepped wedge trial.
#'
#' @export
#'
#' @examples
#' # Simulate a stepped-wedge trial with a continuous outcome:
#' swtrial(
#'   repn = 1, k = 3, i = 4, j = 5, intervention_seq = 4,
#'   deltas = c(0.5, 0.5, 0.5, 0.5),
#'   betas = c(0, 0.1, 0.2, 0.3, 0.4),
#'   family = "gaussian",
#'   sigma_epsilon = 1,
#'   sigma_alpha = 2,
#'   sigma_gamma = 0,
#'   sigma_phi = 3
#' )
swtrial <- function(repn, k, i = 8, j = 5, intervention_seq = 4, deltas, betas, family, sigma_epsilon = 0.0, sigma_alpha = 0.0, sigma_gamma = 0.0, sigma_phi = 0.0) {
  # We need a period effect per period, error if that's not the case
  if (j != length(betas)) {
    stop("Not enough (or too many) period-effect parameters 'betas', there must be 'j'.", call. = FALSE)
  }
  # We need a treatment effect per period, error if that's not the case
  if (length(deltas) != (j - 1)) {
    stop("Not enough (or too many) treatment-effect parameters 'deltas', there must be 'j - 1'.", call. = FALSE)
  }
  # Match family
  family <- match.arg(arg = family, choices = c("gaussian", "binomial", "poisson"), several.ok = FALSE)
  # Make stepped wedge design
  design <- make_stepped_wedge_design(i, j, intervention_seq)
  # Add patients to each cluster
  design <- tidyr::crossing(design, k = seq(k))
  # Simulate random cluster effect
  alphas <- data.frame(
    i = seq(i),
    alpha = stats::rnorm(n = i, sd = sigma_alpha)
  )
  # Simulate random period effects
  gammas <- tidyr::crossing(
    i = seq(i),
    j = seq(j)
  )
  gammas$gamma <- stats::rnorm(n = nrow(gammas), mean = 0, sd = sigma_gamma)
  gammas$jid <- seq(nrow(gammas))
  # Simulate random patient effects
  phis <- tidyr::crossing(
    i = seq(i),
    k = seq(k)
  )
  phis$phi <- stats::rnorm(n = nrow(phis), mean = 0, sd = sigma_phi)
  # Start assembling simulated dataset
  df <- expand.grid(
    k = seq(k),
    i = seq(i)
  )
  df$id <- seq(nrow(df))
  # Merge things together...
  df <- merge(design, df, by = c("i", "k"))
  df <- merge(df, alphas, by = "i")
  df <- merge(df, gammas, by = c("i", "j"))
  df <- merge(df, phis, by = c("i", "k"))
  # Add period effects
  betas <- data.frame(
    j = seq(j),
    beta = betas
  )
  df <- merge(df, betas, by = "j")
  # Add treatment effects
  deltas <- data.frame(
    cumx = 0:length(deltas),
    delta = c(0, deltas)
  )
  df <- dplyr::arrange(df, i, id, j)
  df <- dplyr::mutate(df, cumx = cumsum(x), .by = c("i", "id"))
  df <- merge(df, deltas)
  df <- dplyr::arrange(df, i, id, j)
  # Compute linear predictor
  df$xb <- with(df, beta + delta * x + alpha + gamma + phi)
  # Compute response
  if (family == "gaussian") {
    df$y <- stats::rnorm(n = nrow(df), mean = df$xb, sd = sigma_epsilon)
  } else if (family == "binomial") {
    df$y <- stats::rbinom(n = nrow(df), size = 1, prob = stats::plogis(q = df$xb))
  } else if (family == "poisson") {
    df$y <- stats::rpois(n = nrow(df), lambda = exp(df$xb))
  }
  # Done!
  df$repn <- repn
  # Sort
  df <- dplyr::arrange(df, i, id, j)
  # Now, return
  return(df)
}
