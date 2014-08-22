
build_description_url <- function(.BugReports) {
  description.file <- gsub("http[s]*://github.com", "https://raw.githubusercontent.com", .BugReports)
  description.file <- gsub("/issues$", "", description.file)
  description.file <- paste(description.file, "/master/DESCRIPTION", sep="")
}


extract_owner <- function(.description) {
  gsub("(https://raw.githubusercontent.com/|/.*$)", "", .description)
}

extract_repo <- function(.description) {
  return(str_match(.description, "https://raw.githubusercontent.com/[a-zA-Z0-9_\\.]+/([a-zA-Z0-9_\\.]+)")[,2])
}

retrieve_version <- function(.description, .progress=FALSE, pb=NULL) {
  unlist(sapply(.description, function(url) {
    if (.progress) setTxtProgressBar(pb, getTxtProgressBar(pb)+1)
    req <- GET(url)
    version <- str_extract(grep("Version", readLines(textConnection(content(req, as="text"))), value=TRUE), "([0-9\\.\\-]+)")
    ifelse(length(version) == 0 , NA, version)
  }, USE.NAMES=FALSE))
}



#' @title github_update - find, report and optionally update packages installed from or available on github
#' @description
#'     Finds local packages that [may] have github versions, then informs &
#'     optionally updates them to the newest versions. It is recommended that you
#'     still perform the updates by hand since you may want to double-check
#'     the repo for any gotchas or incompatibilities with other installed packages.
#'
#'     Added code from Thomas J Leeper's (@@thosjleeper) \code{#spiffy} gist: \url{https://gist.github.com/leeper/9123584}
#'
#' @param auto.install should it try to auto-install newer packages [not recommended] (bool, initially \code{FALSE})
#' @param ask if this and \code{auto.install}==\code{TRUE} a pkg install select list will be shown (graphical or text widget dependent upon \code{widget})
#' @param widget if this and \code{auto.install}==\code{TRUE} and \code{ask}==\code{TRUE} then a GUI select widget will
#' @param .progress show a progress bar (bool, initially \code{FALSE})
#' @param all search all \code{.libPaths()} (\code{TRUE}) or only the first one (initially \code{TRUE})
#' @param show.location include the library location in the returned data frame (initially \code{FALSE})
#' @return data frame of installed packages with information on owner & whether an update is available (optionally includes installed library path)
#' @import dplyr
#' @note package installation exceptions are caught with \code{try}, but are not reported out in any other way but console errors
#' @export
#' @examples \dontrun{
#' github_update()
#'
#' ##           package           repo       owner installed.version current.version update.available
#' ## 1            Rcpp           Rcpp    RcppCore            0.11.2        0.11.2.1             TRUE
#' ## 2   RcppArmadillo  RcppArmadillo    RcppCore         0.4.400.0       0.4.400.0            FALSE
#' ## 3      data.table     data.table  Rdatatable             1.9.3           1.9.3            FALSE
#' ## 4        dtupdate       dtupdate    hrbrmstr               1.1             1.1            FALSE
#' ## 5        forecast       forecast robjhyndman               5.4             5.6             TRUE
#' ## 6         formatR        formatR       yihui              0.10          0.10.5             TRUE
#' ## 7          gmailr         gmailr   jimhester             0.0.1           0.0.1            FALSE
#' ## 8        jsonlite       jsonlite  jeroenooms             0.9.9          0.9.10             TRUE
#' ## 9           knitr          knitr       yihui             1.6.6          1.6.14             TRUE
#' ## 10 knitrBootstrap knitrBootstrap   jimhester             1.0.0           1.0.0            FALSE
#' ## 11      lubridate      lubridate      hadley             1.3.3           1.3.3            FALSE
#' ## 12       markdown       markdown     rstudio             0.7.4           0.7.4            FALSE
#' ## 13        memoise        memoise      hadley             0.2.1          0.2.99             TRUE
#' ## 14           mime           mime       yihui             0.1.2           0.1.2            FALSE
#' ## 15       miniCRAN       miniCRAN      andrie            0.0-20          0.0-20            FALSE
#' ## 16        packrat        packrat     rstudio             0.4.0        0.4.0.12             TRUE
#' ## 17       reshape2        reshape      hadley               1.4        1.4.0.99             TRUE
#' ## 18         resolv         resolv    hrbrmstr             0.2.2           0.2.2            FALSE
#' ## 19          rzmq           rzmq    armstrtw             0.7.0           0.7.0            FALSE
#' ## 20         scales         scales      hadley             0.2.4        0.2.4.99             TRUE
#' ## 21          shiny          shiny     rstudio       0.10.0.9001     0.10.1.9004             TRUE
#' ## 22       shinyAce       shinyAce trestletech             0.1.0           0.1.0            FALSE
#' ## 23        slidify        slidify    ramnathv             0.4.5           0.4.5            FALSE
#' ## 24         testit         testit       yihui               0.3             0.3            FALSE
#' }
#'
github_update <- function(auto.install=FALSE, ask=TRUE, widget=FALSE, .progress=FALSE, all=TRUE, show.location=FALSE) {

  # without suppressWarnings, there are most likely going to be useless row.names warnings
  # prbly don't need "URL", but perhaps in the future

  locs <- .libPaths()
  if (!all) { locs <- locs[1] }

  suppressWarnings(pkgs <- data.frame(installed.packages(lib.loc=locs, fields=c("URL", "BugReports")), stringsAsFactors=FALSE))

  # so, we cheat and use the fact that the author/maintainer has a github "BugReports" DESCRIPTION string
  # as an indicator that there may be github devtools version of the package available

  # if there are alot of packages, you might appreciate knowing the progress

  if (.progress) pkg.pb <- txtProgressBar(min=0, max=nrow(pkgs), initial=0, title="Retrieving local and remote package information")

  # iterate over the possible github package list

  tmp <- pkgs %>%
    filter(grepl("github", BugReports)) %>%
    select(Package, Version, BugReports, LibPath) %>%
    mutate(description=build_description_url(BugReports),
           owner=extract_owner(description),
           repo=extract_repo(description),
           current.version=retrieve_version(description, .progress, pkg.pb),
           update.available=mapply(function(a, b) { compareVersion(a,b) < 0 }, Version, current.version, USE.NAMES=FALSE)) %>%
    filter(!is.na(current.version)) %>%
    arrange(Package)

  # done with progress bars

  if (.progress) close(pkg.pb)

  # auto installation of out of date packages is not recommended, but for those living on the edge, here ya go!

  if (auto.install) {

    message("automatically updating packages...")

    # start with assuming all pkgs with updates avail
    k <- (tmp %>% filter(update.available==TRUE))$Package

    # filter if asked to
    if (ask) {

      # they wanted a GUI but can't support one
      if (widget & !(.Platform$OS.type == "windows" || .Platform$GUI ==
                       "AQUA" || (capabilities("tcltk") && capabilities("X11")))) {
        widget <- FALSE
      }

      k <- select.list(k, preselect=FALSE, multiple = TRUE,
                       title = "Packages to be updated", graphics = widget)

    }

    if (length(k) > 0) {

      # use the resultant list

      invisible(apply(tmp %>% filter(Package %in% k, update.available==TRUE), 1, function(p) {
        # this will prevent package install errors from stopping the function
        try(devtools::install_github(sprintf("%s/%s", as.character(p["owner"]), as.character(p["repo"]))))
      }))

      # update the package version info on post-install

      tmp$installed.version <- sapply(tmp$Package, function(x) { as.character(packageVersion(x))}, USE.NAMES=FALSE)
      tmp$update.available <- mapply(compareVersion, tmp$Version, tmp$current.version, USE.NAMES=FALSE)<0

    }

  }

  if (show.location) {
    return(tmp %>% select(package=Package, repo, owner, installed.version=Version, current.version, update.available, lib=LibPath))
  } else {
    return(tmp %>% select(package=Package, repo, owner, installed.version=Version, current.version, update.available))
  }

}

