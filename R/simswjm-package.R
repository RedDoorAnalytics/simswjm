#' @title Simulate Data from Stepped Wedge Longitudinal Trials
#'
#' @description Tools, utilities, and functions that are useful to simulate data
#'     from stepped wedge longitudinal trials under a variety of study designs
#'     and assumptions.
#'
#' @name simswjm
#' @docType package
#' @author Alessandro Gasparini (alessandro.gasparini@@reddooranalytics.se)
#' @import stats tidyr
#' @importFrom dplyr arrange
NULL

# Quiets concerns of R CMD check re: variable names used internally
if (getRversion() >= "2.15.1") utils::globalVariables(c("i", "j", "id", "s", "x"))
