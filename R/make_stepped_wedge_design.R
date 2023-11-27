#' Generate a Balanced Stepped-Wedge Design
#'
#' @param i Number of clusters.
#' @param j Number of periods.
#' @param intervention_seq Number of intervention sequences for the trial.
#'
#' @return A dataset with the following columns:
#' * `j`, identifying the distinct periods;
#' * `s`, identifying the distinct intervention sequences;
#' * `i`, identifying each cluster;
#' * `x`, denoting whether a certain cluster `i` was treated during a certain period `j`.
#'
#' @export
#'
#' @examples
#' # Trial design with 8 clusters, 4 intervention sequences (thus 2 clusters per
#' # intervention sequence), 5 time periods:
#' make_stepped_wedge_design(i = 8, j = 5, intervention_seq = 4)
make_stepped_wedge_design <- function(i, j, intervention_seq) {
  # Some checks to have a "balanced" design
  if ((i %% intervention_seq) != 0) {
    stop("Not every treatment sequence can be assigned to the same number of clusters. Change 'i' or 'intervention_seq'.", call. = FALSE)
  }
  if (intervention_seq != (j - 1)) {
    stop("Not enough periods (or too many treatment sequences). Change 'j' or 'intervention_seq'.", call. = FALSE)
  }

  # Grid of clusters by period
  i_by_j <- expand.grid(i = seq(i), j = seq(j))

  # Assign treatment sequence by cluster
  hw <- i / intervention_seq
  sequence_assigment <- data.frame(i = seq(i), s = rep(seq(intervention_seq), each = hw))

  # Create treatment sequences
  ts <- expand.grid(j = seq(j), s = seq(intervention_seq))
  ts$x <- with(ts, ifelse((j - 1) >= s, 1, 0))

  # Merge all information together and return a dataset with the design
  design <- merge(i_by_j, sequence_assigment, by = "i")
  design <- merge(design, ts, by = c("j", "s"))
  design <- design[order(design$i, design$j, design$s, design$x),]
  row.names(design) = NULL
  return(design)
}
