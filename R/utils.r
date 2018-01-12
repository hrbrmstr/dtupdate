# intended for use with dplyr's mutate() in github_update

.get_version <- function(x) {
  url_con <- url(x)
  res <- as.character(read.dcf(url_con, fields="Version"))
  close(url_con)
  res
}

get_versions <- function(github_user_repo) {

  base_url <- "https://raw.githubusercontent.com/%s/master/DESCRIPTION"
  gh_urls <- sprintf(base_url, github_user_repo)

  unlist(
    pbsapply(
      gh_urls,
      function(url) {
        version <- try(.get_version(url), silent=TRUE)
        version <- if (inherits(version, "try-error")) NA else version
        version
      },
      USE.NAMES=FALSE
    ),
   use.names=FALSE
  )

}

pkg_date <- function (desc)  {
  if (!is.null(desc$`Date/Publication`)) {
    date <- desc$`Date/Publication`
  } else if (!is.null(desc$Built)) {
    built <- strsplit(desc$Built, "; ")[[1]]
    date <- built[3]
  } else {
    date <- NA_character_
  }
  as.character(as.Date(strptime(date, "%Y-%m-%d")))
}

pkg_source <- function (desc)  {
  if (!is.null(desc$GithubSHA1)) {
    str <- paste0("Github (", desc$GithubUsername, "/", desc$GithubRepo,
                  "@", substr(desc$GithubSHA1, 1, 7), ")")
  } else if (!is.null(desc$RemoteType)) {
    str <- paste0(desc$RemoteType, " (", desc$RemoteUsername,
                  "/", desc$RemoteRepo, "@", substr(desc$RemoteSha,
                                                    1, 7), ")")
  } else if (!is.null(desc$Repository)) {
    repo <- desc$Repository
    if (!is.null(desc$Built)) {
      built <- strsplit(desc$Built, "; ")[[1]]
      ver <- sub("$R ", "", built[1])
      repo <- paste0(repo, " (", ver, ")")
    }
    repo
  } else if (!is.null(desc$biocViews)) {
    "Bioconductor"
  } else {
    "local"
  }
}
