#' Find, report and optionally update packages installed from or available on github
#'
#' Finds local packages that [may] have github versions, then informs &
#' optionally updates them to the newest versions. It is recommended that you
#' still selectively perform the updates since you may want to double-check the
#' repo for any gotchas or incompatibilities with other installed packages.
#'
#' Added code from Thomas J Leeper's (@@thosjleeper) \code{#spiffy} gist:
#' \url{https://gist.github.com/leeper/9123584}
#'
#' @param auto.install Should it try to auto-install newer packages [not
#'   recommended] (bool, initially \code{FALSE})
#' @param ask If this and \code{auto.install}==\code{TRUE} a pkg install select
#'   list will be shown (graphical or text widget dependent upon \code{widget})
#' @param widget If this and \code{auto.install}==\code{TRUE} and
#'   \code{ask}==\code{TRUE} then a GUI select widget will
#' @return \code{data.frame} of installed packages with information on owner &
#'   whether an update is available (optionally includes installed library path)
#' @import dplyr
#' @note Package installation exceptions are caught with \code{try}, but are not
#'   reported out in any other way but console errors
#' @export
github_update <- function (auto.install=FALSE, ask=TRUE, widget=FALSE,
                           dependencies=TRUE, libpath=.libPaths()[1]) {

  pkgs <- data.frame(installed.packages(lib=libpath), stringsAsFactors=FALSE)
  pkgs <- pkgs$Package
  pkgs <- sort(pkgs)

  # get pkg info

  desc <- lapply(pkgs, packageDescription, lib.loc=libpath)
  version <- vapply(desc, function(x) x$Version, character(1))
  date <- vapply(desc, pkg_date, character(1))
  source <- vapply(desc, pkg_source, character(1))

  pkgs_df <- data.frame(package=pkgs, version=version, date=date, source=source,
                        stringsAsFactors=FALSE, check.names=FALSE)

  rownames(pkgs_df) <- NULL
  class(pkgs_df) <- c("dtupdate", "data.frame")

  # only care about github

  if (any(grepl("Github", pkgs_df$source))) {

    pkgs_df <- filter(pkgs_df, grepl("Github", source))
    just_repo <- str_match(pkgs_df$source,
                           "\\(([[:alnum:]-_\\.]*/[[:alnum:]-_\\.]*)[@[:alnum:]]*")[,2]
    pkgs_df$gh_version <- get_versions(just_repo)
    pkgs_df$`*` <- ifelse(mapply(compareVersion, pkgs_df$version, pkgs_df$gh_version,
                                 USE.NAMES=FALSE)<0, '*', '')
    pkgs_df$`*` <- ifelse(is.na(pkgs_df$gh_version), '', pkgs_df$`*`)

    if (auto.install) {

      message("automatically updating packages...")

      # start with assuming all pkgs with updates avail
      k <- (pkgs_df %>% filter(`*`=='*'))$package

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

        invisible(apply(pkgs_df %>% filter(package %in% k, `*`=='*'), 1, function(p) {
          just_repo <- str_match(p["source"],
                                 "\\(([[:alnum:]-_\\.]*/[[:alnum:]-_\\.]*)[@[:alnum:]]*")[,2]
          # this will prevent package install errors from stopping the function
          try(devtools::install_github(just_repo, dependencies=dependencies))
        }))

        # update the package version info on post-install

        pkgs_df$version <- sapply(pkgs_df$package, function(x) { as.character(packageVersion(x))}, USE.NAMES=FALSE)
        pkgs_df$`*` <- ifelse(mapply(compareVersion, pkgs_df$version, pkgs_df$gh_version,
                                     USE.NAMES=FALSE)<0, '*', '')

      }

    }
    return(select(pkgs_df, package, date, version, gh_version, `*`, source))

  } else {
    message("No packages installed via GitHub to update.")
    return(pkgs_df)
  }

}

