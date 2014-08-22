[![Build Status](https://travis-ci.org/hrbrmstr/dtupdate.png)](https://travis-ci.org/hrbrmstr/dtupdate)

The `dtupdate` packages has functions that attempt to figure out which packages have non-CRAN versions (currently only looks for github ones) and then tries to figure out which ones have updates (i.e. the github version is \> local version). It provides an option (not recommended) to auto-update any packages with newer development versions, which is tempered by the ability to selectively install said packages.

The `URL` and `BugReports` fields are, frankly, a mess. Many packages have multiple URLs in one or both of those fields and the non-github URLs are all over the place in terms of formatting. It will take some time, but I'm pretty confident I can get r-forge, bitbucket, gitorius and other external repos working. This was an easy first step.

The following functions are implemented:

-   `github_update` - find, report and optionally update packages installed from or available on github. This initial version just keys off of the `BugReports:` field, looking for a github-ish URL and then grabbing what info that it can to see if the repo is in package format and has a `DESCRIPTION` file it can key off of

### News

-   Version `1.2` switches from `plyr` to `dplyr` to stop [@jayjacobs](<http://twitter.com/jayjacobs>) from whining, removes the `libLoc` switch from version `1.1` and replaces it with a boolean `all` parameter which let's you switch from inspecting the github packages installed across all library paths or just the first one (*usually* your user/local path), and adds a `show.location` parameter which will include the library path for each package in the data frame return
-   Version `1.1` incorporates functionality from [Thomas J Leeper](http://twitter.com/thosjleeper)'s gist: , including the ability to interactively select which packages to install, the option to specify which `libLoc` will be searched by `installed.packages` and handling of a fringe case where the repo name does not match the package name (ironically, this was due to Hadley's `reshape` repo for the `reshape2` package)
-   Version `1.0` released (nascent github pkg update capability)

### Installation

``` {.r}
devtools::install_github("hrbrmstr/dtupdate")
```

### Usage

``` {.r}
library(dtupdate)
```

    ## Loading required package: devtools
    ## 
    ## Attaching package: 'devtools'
    ## 
    ## The following objects are masked from 'package:utils':
    ## 
    ##     ?, help
    ## 
    ## The following object is masked from 'package:base':
    ## 
    ##     system.file
    ## 
    ## Loading required package: httr
    ## Loading required package: stringr
    ## Loading required package: dplyr
    ## 
    ## Attaching package: 'dplyr'
    ## 
    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` {.r}
# current verison
packageVersion("dtupdate")
```

    ## [1] '1.2'

``` {.r}
# see what packages are available for an update
github_update()
```

    ##           package           repo       owner installed.version current.version update.available
    ## 1            Rcpp           Rcpp    RcppCore            0.11.2        0.11.2.1             TRUE
    ## 2   RcppArmadillo  RcppArmadillo    RcppCore         0.4.400.0       0.4.400.0            FALSE
    ## 3      data.table     data.table  Rdatatable             1.9.3           1.9.3            FALSE
    ## 4        dtupdate       dtupdate    hrbrmstr               1.2             1.1            FALSE
    ## 5        forecast       forecast robjhyndman               5.4             5.6             TRUE
    ## 6         formatR        formatR       yihui              0.10          0.10.5             TRUE
    ## 7          gmailr         gmailr   jimhester             0.0.1           0.0.1            FALSE
    ## 8        jsonlite       jsonlite  jeroenooms             0.9.9          0.9.10             TRUE
    ## 9           knitr          knitr       yihui             1.6.6          1.6.14             TRUE
    ## 10 knitrBootstrap knitrBootstrap   jimhester             1.0.0           1.0.0            FALSE
    ## 11      lubridate      lubridate      hadley             1.3.3           1.3.3            FALSE
    ## 12       markdown       markdown     rstudio             0.7.4           0.7.4            FALSE
    ## 13        memoise        memoise      hadley             0.2.1          0.2.99             TRUE
    ## 14           mime           mime       yihui             0.1.2           0.1.2            FALSE
    ## 15       miniCRAN       miniCRAN      andrie            0.0-20          0.0-20            FALSE
    ## 16        packrat        packrat     rstudio             0.4.0        0.4.0.12             TRUE
    ## 17       reshape2        reshape      hadley               1.4        1.4.0.99             TRUE
    ## 18         resolv         resolv    hrbrmstr             0.2.2           0.2.2            FALSE
    ## 19           rzmq           rzmq    armstrtw             0.7.0           0.7.0            FALSE
    ## 20         scales         scales      hadley          0.2.4.99        0.2.4.99            FALSE
    ## 21         scales         scales      hadley             0.2.4        0.2.4.99             TRUE
    ## 22          shiny          shiny     rstudio       0.10.0.9001     0.10.1.9004             TRUE
    ## 23       shinyAce       shinyAce trestletech             0.1.0           0.1.0            FALSE
    ## 24        slidify        slidify    ramnathv             0.4.5           0.4.5            FALSE
    ## 25         testit         testit       yihui               0.3             0.3            FALSE

### Test Results

``` {.r}
library(dtupdate)
library(testthat)

date()
```

    ## [1] "Fri Aug 22 16:16:01 2014"

``` {.r}
test_dir("tests/")
```

    ## basic functionality : .
