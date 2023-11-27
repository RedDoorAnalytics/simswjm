#' Calculate ICC Values
#'
#' @param sigma_alpha Standard deviation of cluster-level random effect \eqn{\alpha};
#' @param sigma_gamma Standard deviation of period-level random effect \eqn{\gamma};
#' @param sigma_phi Standard deviation of subject-level random effect \eqn{\phi};
#' @param sigma_epsilon Standard deviation of the residual error term.
#'
#' @return A list of values with within-individual ICC for repeated measures (`ICC_a`),
#'     within-period ICC (`ICC_w`), and between-period ICC (`ICC_b`).
#'
#' @export
#'
#' @examples
#' icc(sigma_alpha = 1.5, sigma_gamma = 0.0, sigma_phi = 2.0, sigma_epsilon = 4.0)
icc <- function(sigma_alpha, sigma_gamma, sigma_phi, sigma_epsilon) {
  # Squared inputs to have less verbose code:
  s2_a <- sigma_alpha^2
  s2_g <- sigma_gamma^2
  s2_p <- sigma_phi^2
  s2_e <- sigma_epsilon^2
  # Common denominator:
  denom <- (s2_a + s2_g + s2_p + s2_e)
  # Within-individual ICC:
  icc_a <- (s2_a + s2_p) / denom
  # Within-period ICC:
  icc_w <- (s2_a + s2_g) / denom
  # Between-period ICC:
  icc_b <- s2_a / denom
  # Return
  out <- list(ICC_a = icc_a, ICC_w = icc_w, ICC_b = icc_b)
  return(out)
}
