#' The dtupdate package has functions that try to make it easier to keep up with the non-CRAN universe
#' @name dtupdate
#' @docType package
#' @author Bob Rudis (@@hrbrmstr)
#' @description
#'     dtupdate attempts to figure out which packages have non-CRAN versions
#'     (currently only looks for github ones) and then tries to figure out
#'     which ones have updates (i.e. the github version is > local version).
#'     It provides an option (not recommended) to auto-update any packages with
#'     newer development versions.
#' @import httr plyr stringr devtools
#' @exportPattern ^[[:alpha:]]+
NULL
