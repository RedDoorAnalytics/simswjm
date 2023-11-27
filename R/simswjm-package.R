#' @title Simulate Data from Stepped Wedge Longitudinal Trials
#'
#' @description Tools, utilities, and functions that are useful to simulate data
#'     from stepped wedge longitudinal trials under a variety of study designs
#'     and assumptions.
#'
#' @name simswjm
#' @docType package
#' @author Alessandro Gasparini (alessandro.gasparini@@reddooranalytics.se)
NULL

# Quiets concerns of R CMD check re: variable names used internally
if (getRversion() >= "2.15.1") utils::globalVariables(c("i", "j", "id", "s", "x", "repn", "jid", "cumx", "y", "yobs", "t0", "t", "d", "eventtime", "actual_eventtime", "alpha", "phi", "status", "tJ"))
