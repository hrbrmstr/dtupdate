# intended for use with dplyr's mutate() in github_update

get_versions <- function(github_user_repo) {

  base_url <- "https://raw.githubusercontent.com/%s/master/DESCRIPTION"
  gh_urls <- sprintf(base_url, github_user_repo)

  unlist(pbsapply(gh_urls, function(url) {

    version <- NULL

    req <- try(GET(url), silent=TRUE)
    if (!inherits(req, "try-error")) {
      version <- str_extract(grep("Version",
                                  readLines(textConnection(content(req, as="text"))),
                                  value=TRUE),
                             "([0-9\\.\\-]+)")
    }

    ifelse(is.null(version) , NA, version)

  }, USE.NAMES=FALSE))

}


pkg_date <- function (desc)  {
  if (!is.null(desc$`Date/Publication`)) {
    date <- desc$`Date/Publication`
  }
  else if (!is.null(desc$Built)) {
    built <- strsplit(desc$Built, "; ")[[1]]
    date <- built[3]
  }
  else {
    date <- NA_character_
  }
  as.character(as.Date(strptime(date, "%Y-%m-%d")))
}

pkg_source <- function (desc)  {
  if (!is.null(desc$GithubSHA1)) {
    str <- paste0("Github (", desc$GithubUsername, "/", desc$GithubRepo,
                  "@", substr(desc$GithubSHA1, 1, 7), ")")
  }
  else if (!is.null(desc$RemoteType)) {
    str <- paste0(desc$RemoteType, " (", desc$RemoteUsername,
                  "/", desc$RemoteRepo, "@", substr(desc$RemoteSha,
                                                    1, 7), ")")
  }
  else if (!is.null(desc$Repository)) {
    repo <- desc$Repository
    if (!is.null(desc$Built)) {
      built <- strsplit(desc$Built, "; ")[[1]]
      ver <- sub("$R ", "", built[1])
      repo <- paste0(repo, " (", ver, ")")
    }
    repo
  }
  else if (!is.null(desc$biocViews)) {
    "Bioconductor"
  }
  else {
    "local"
  }
}
