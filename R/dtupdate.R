#' @title github_update - find, report and optionally update packages installed from or available on github
#' @description
#'     Finds local packages that [may] have github versions, then informs &
#'     optionally updates them to the newest versions. It is recommended that you
#'     still perform the updates by hand since you may want to double-check
#'     the repo for any gotchas or incompatibilities with other installed packages.
#' @param auto.install should it try to auto-install newer packages [not recommended] (bool, initially \code{FALSE})
#' @param .progress show a progress bar (bool, initially \code{FALSE})
#' @return data frame of installed packages with information on owner & whether an update is available
#' @note package installation exceptions are caught with \code{try}, but are not reported out in any other way but console errors
#' @export
#' @examples \dontrun{
#' github_update()
#' ##      package.repo       owner installed.version current.version update.available
#' ## 1        corrplot      taiyun              0.73            0.73               no
#' ## 2      data.table  Rdatatable             1.9.3           1.9.3               no
#' ## 3          gmailr   jimhester             0.0.1           0.0.1               no
#' ## 4        miniCRAN      andrie            0.0-20          0.0-20               no
#' ## 5   RcppArmadillo    RcppCore         0.4.400.0       0.4.400.0               no
#' ## 6        corrplot      taiyun              0.73            0.73               no
#' ## 7        forecast robjhyndman               5.4             5.6              yes
#' ## 8         formatR       yihui              0.10          0.10.5              yes
#' ## 9         ggplot2      hadley             1.0.0        1.0.0.99              yes
#' ## 10       ggthemes      jrnold             1.7.0           1.8.0              yes
#' ## 11          highr       yihui               0.3           0.3.1              yes
#' ## 13       jsonlite  jeroenooms             0.9.9          0.9.10              yes
#' ## 14          knitr       yihui             1.6.6          1.6.14              yes
#' ## 15 knitrBootstrap   jimhester             1.0.0           1.0.0               no
#' ## 16      lubridate      hadley             1.3.3           1.3.3               no
#' ## 17       markdown     rstudio               0.7           0.7.4              yes
#' ## 18        memoise      hadley             0.2.1          0.2.99              yes
#' ## 19           mime       yihui             0.1.1           0.1.2              yes
#' ## 20        packrat     rstudio             0.4.0        0.4.0.12              yes
#' ## 21           Rcpp    RcppCore            0.11.2        0.11.2.1              yes
#' ## 22       reshape2      hadley               1.4        1.4.0.99              yes
#' ## 23           rzmq    armstrtw             0.7.0           0.7.0               no
#' ## 24         scales      hadley             0.2.4        0.2.4.99              yes
#' ## 25          shiny     rstudio       0.10.0.9001     0.10.1.9004              yes
#' ## 26       shinyAce trestletech             0.1.0           0.1.0               no
#' ## 27        slidify    ramnathv             0.4.5           0.4.5               no
#' ## 28         testit       yihui               0.3             0.3               no
#' }
#'
github_update <- function(auto.install=FALSE, .progress=FALSE) {

  # without suppressWarnings, there are most likely going to be useless row.names warnings
  # prbly don't need "URL", but perhaps in the future

  suppressWarnings(pkgs <- data.frame(installed.packages(fields=c("URL", "BugReports")), stringsAsFactors=FALSE))

  # so, we cheat and use the fact that the author/maintainer has a github "BugReports" DESCRIPTION string
  # as an indicator that there may be github devtools version of the package available

  pkgs <- pkgs[grep("github", pkgs$BugReports), c("Package", "Version", "BugReports")]

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
    } else {
      gh.version <- str_extract(grep("Version", readLines(textConnection(content(req, as="text"))), value=TRUE), "([0-9\\.\\-]+)")
    }

    # we're building a data frame of pkg|owner|ourvers|theirvers|updateavail and we use
    # R's "compareVersion()" to determine whether there's an update available

    data.frame(package.repo=pkg$Package, owner=owner,
               installed.version=pkg$Version,
               current.version=gh.version,
               update.available=ifelse(compareVersion(pkg$Version, gh.version)<0, "yes", "no"))

  }, .expand=FALSE)

  # done with progress bars

  if (.progress) close(pkg.pb)

  # any pkgs using github for version control but w/o a repo in devtools format need to be purged

  tmp <- tmp[complete.cases(tmp), 2:6]

  # auto installation of out of date packages is not recommended, but for those living on the edge, here ya go!

  if (auto.install) {
    a_ply(tmp[tmp$update.available=="yes",], 1, function(p) {
      # this will prevent package install errors from stopping the function
      try(devtools::install_github(sprintf("%s/%s", p$owner, p$package.repo)))
    })
  }

  return(tmp)

}

