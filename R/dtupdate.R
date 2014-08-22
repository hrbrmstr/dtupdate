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
#' @param lib.loc character vector describing the location of R library trees to search through, or NULL for all known trees (see \link{.libPaths})
#' @return data frame of installed packages with information on owner & whether an update is available
#' @import plyr
#' @note package installation exceptions are caught with \code{try}, but are not reported out in any other way but console errors
#' @export
#' @examples \dontrun{
#' github_update()
#' ##      package.repo       owner installed.version current.version update.available
#' ## 1      data.table  Rdatatable             1.9.3           1.9.3            FALSE
#' ## 2        dtupdate    hrbrmstr               1.0             1.0            FALSE
#' ## 3        forecast robjhyndman               5.4             5.6             TRUE
#' ## 4          gmailr   jimhester             0.0.1           0.0.1            FALSE
#' ## 5        jsonlite  jeroenooms             0.9.9          0.9.10             TRUE
#' ## 6           knitr       yihui             1.6.6          1.6.14             TRUE
#' ## 7  knitrBootstrap   jimhester             1.0.0           1.0.0            FALSE
#' ## 8       lubridate      hadley             1.3.3           1.3.3            FALSE
#' ## 9        markdown     rstudio               0.7           0.7.4             TRUE
#' ## 10        memoise      hadley             0.2.1          0.2.99             TRUE
#' ## 11       miniCRAN      andrie            0.0-20          0.0-20            FALSE
#' ## 12        packrat     rstudio             0.4.0        0.4.0.12             TRUE
#' ## 13           Rcpp    RcppCore            0.11.2        0.11.2.1             TRUE
#' ## 14  RcppArmadillo    RcppCore         0.4.400.0       0.4.400.0            FALSE
#' ## 15       reshape2      hadley               1.4        1.4.0.99             TRUE
#' ## 16         resolv    hrbrmstr             0.2.2           0.2.2            FALSE
#' ## 17           rzmq    armstrtw             0.7.0           0.7.0            FALSE
#' ## 18         scales      hadley             0.2.4        0.2.4.99             TRUE
#' ## 19          shiny     rstudio       0.10.0.9001     0.10.1.9004             TRUE
#' ## 20       shinyAce trestletech             0.1.0           0.1.0            FALSE
#' ## 21        slidify    ramnathv             0.4.5           0.4.5            FALSE
#' ## 22         testit       yihui               0.3             0.3            FALSE
#' }
#'
github_update <- function(auto.install=FALSE, ask=TRUE, widget=FALSE, .progress=FALSE, lib.loc=NULL) {

  # without suppressWarnings, there are most likely going to be useless row.names warnings
  # prbly don't need "URL", but perhaps in the future

  suppressWarnings(pkgs <- data.frame(installed.packages(lib.loc=lib.loc, fields=c("URL", "BugReports")), stringsAsFactors=FALSE))

  # so, we cheat and use the fact that the author/maintainer has a github "BugReports" DESCRIPTION string
  # as an indicator that there may be github devtools version of the package available

  pkgs <- pkgs[grepl("github", pkgs$BugReports), c("Package", "Version", "BugReports")]

  # if there are alot of packages, you might appreciate knowing the progress

  if (.progress) pkg.pb <- txtProgressBar(min=0, max=nrow(pkgs), initial=0, title="Retrieving local and remote package information")

  # iterate over the possible github package list

  tmp <- adply(pkgs, 1, function(pkg) {

    if (.progress) setTxtProgressBar(pkg.pb, getTxtProgressBar(pkg.pb)+1)

    # work out the repo owner & the DESCRIPTION file URL

    description.file <- gsub("http[s]*://github.com", "https://raw.githubusercontent.com", pkg$BugReports)
    description.file <- gsub("/issues$", "", description.file)
    description.file <- paste(description.file, "/master/DESCRIPTION", sep="")

    owner <- gsub("(https://raw.githubusercontent.com/|/.*$)", "", description.file)

    # try to get the DESCRIPTION file

    req <- GET(description.file)

    # if it's not there (404) then we've run into a case where the owner may be using github
    # for version control but the repo is not in devtools package format
    #
    # if it *is* there, then get the version number from it

    if (req$status_code > 400) {
      gh.version <- NA
      gh.repo.name <- NA
    } else {
      gh.version <- str_extract(grep("Version", readLines(textConnection(content(req, as="text"))), value=TRUE), "([0-9\\.\\-]+)")
      gh.repo.name <- str_match(description.file, "https://raw.githubusercontent.com/[a-zA-Z0-9_\\.]+/([a-zA-Z0-9_\\.]+)")[2]
    }

    # we're building a data frame of pkg|owner|ourvers|theirvers|updateavail and we use
    # R's "compareVersion()" to determine whether there's an update available

    data.frame(package=pkg$Package,
               owner=owner,
               repo=gh.repo.name,
               installed.version=pkg$Version,
               current.version=gh.version,
               update.available=(compareVersion(pkg$Version, gh.version)<0))

  }, .expand=FALSE)

  # done with progress bars

  if (.progress) close(pkg.pb)

  # any pkgs using github for version control but w/o a repo in devtools format need to be purged

  tmp <- tmp[complete.cases(tmp), 2:7]

  # yes i cld have used an apply. but there aren't that many columns

  tmp$package <- as.character(tmp$package)
  tmp$owner <- as.character(tmp$owner)
  tmp$repo <- as.character(tmp$repo)
  tmp$installed.version <- as.character(tmp$installed.version)
  tmp$current.version <- as.character(tmp$current.version)

  tmp <- tmp[order(tmp$package),]
  rownames(tmp) <- NULL

  # auto installation of out of date packages is not recommended, but for those living on the edge, here ya go!

  if (auto.install) {

    message("automatically updating packages...")

    # start with assuming all pkgs with updates avail
    k <- tmp[tmp$update.available,]$package

    # filter if asked to
    if (ask) {

      # they wanted a GUI but can't support one
      if (widget & !(.Platform$OS.type == "windows" || .Platform$GUI ==
                       "AQUA" || (capabilities("tcltk") && capabilities("X11")))) {
        widget <- FALSE
      }

      k <- select.list(tmp[tmp$update.available,]$package,
                       preselect=FALSE, multiple = TRUE,
                       title = "Packages to be updated", graphics = widget)

    }

    # use the resultant list

    a_ply(tmp[tmp$package %in% k & tmp$update.available,], 1, function(p) {
      # this will prevent package install errors from stopping the function
      try(devtools::install_github(sprintf("%s/%s", p$owner, p$repo)))
    })

    # update the package version info on post-install

    tmp$installed.version <- sapply(tmp$package, function(x) { as.character(packageVersion(x))}, USE.NAMES=FALSE)
    tmp$update.available <- mapply(compareVersion, tmp$installed.version, tmp$current.version, USE.NAMES=FALSE)<0

  }

  tmp$repo <- NULL # no need to show the repo; only used it in a fringe case

  return(tmp)

}

