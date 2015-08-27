#' Keep Up-To-Date with Non-CRAN Package Updates
#' @name dtupdate
#' @docType package
#' @author Bob Rudis (@@hrbrmstr), Thomas J Leeper (@@thosjleeper)
#' @description
#'    CRAN and Bioconductor users have mechanisms to update their
#'    installed packages but those of us who live in the devtools GitHub world
#'    are levt to intall_github all on our own. This package fills that gap
#'    by providing a function that attempts to figure out which packages were
#'    installed from GitHub and then tries to figure
#'    out which ones have updates (i.e. the GitHub version is > local version).
#'    It provides an option (not recommended) to (optionally, selectively)
#'    auto-update any packages with newer GitHub development versions.
#' @import httr dplyr devtools pbapply
#' @importFrom stringr str_extract str_match
NULL
