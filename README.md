[![Build Status](https://travis-ci.org/hrbrmstr/dtupdate.png)](https://travis-ci.org/hrbrmstr/dtupdate)

The `dtupdate` packages has functions that attempt to figure out which packages have non-CRAN versions (currently only looks for github ones) and then tries to figure out which ones have updates (i.e. the github version is \> local version). It provides an option (not recommended) to auto-update any packages with newer development versions, which is tempered by the ability to selectively install said packages.

The `URL` and `BugReports` fields are, frankly, a mess. Many packages have multiple URLs in one or both of those fields and the non-github URLs are all over the place in terms of formatting. It will take some time, but I'm pretty confident I can get r-forge, bitbucket, gitorius and other external repos working. This was an easy first step.

The following functions are implemented:

-   `github_update` - find, report and optionally update packages installed from or available on github. It keys off of the `BugReports:` or `URL:` fields, looking for a github-ish URL and then grabbing what info that it can to see if the repo is in package format and has a `DESCRIPTION` file it can work with

### News

-   Version `1.3` works with both the `BugReports:` and `URL:` field and handles some additional URL-retrieving exceptions
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

    ##           package           repo              owner installed.version current.version update.available
    ## 1           Hmisc          Hmisc           harrelfe            3.14-4          3.14-5             TRUE
    ## 2          RMySQL         RMySQL      jeffreyhorner             0.9-3           0.9-3            FALSE
    ## 3      RSvgDevice     RSvgDevice           mdecorde           0.6.4.4         0.6.4.3            FALSE
    ## 4            Rcpp           Rcpp           RcppCore            0.11.2        0.11.2.1             TRUE
    ## 5            Rcpp           Rcpp           RcppCore            0.11.1        0.11.2.1             TRUE
    ## 6     Rforecastio    Rforecastio           hrbrmstr             1.3.0           1.3.0            FALSE
    ## 7        Rgitbook       Rgitbook             jbryer               0.9             0.9            FALSE
    ## 8        Rttf2pt1       Rttf2pt1                wch             1.3.1           1.3.1            FALSE
    ## 9             WDI            WDI vincentarelbundock               2.4             2.4            FALSE
    ## 10          XML2R          XML2R          cpsievert             0.0.6           0.0.7             TRUE
    ## 11      animation      animation              yihui               2.2             2.3             TRUE
    ## 12    choroplethr    choroplethr             trulia            1.7.99          1.7.99            FALSE
    ## 13       corrplot       corrplot             taiyun              0.73            0.73            FALSE
    ## 14    countrycode    countrycode vincentarelbundock              0.17            0.17            FALSE
    ## 15          dplyr          dplyr             hadley          0.2.0.99        0.2.0.99            FALSE
    ## 16          dplyr          dplyr             hadley             0.1.3        0.2.0.99             TRUE
    ## 17       dtupdate       dtupdate           hrbrmstr               1.2             1.2            FALSE
    ## 18      extrafont      extrafont                wch              0.16       0.16.0.99             TRUE
    ## 19    extrafontdb    extrafontdb                wch               1.0             1.0            FALSE
    ## 20       forecast       forecast        robjhyndman               5.4             5.6             TRUE
    ## 21        formatR        formatR              yihui              0.10          0.10.6             TRUE
    ## 22        ggplot2        ggplot2             hadley             1.0.0        1.0.0.99             TRUE
    ## 23       ggthemes       ggthemes             jrnold             1.7.0           1.8.0             TRUE
    ## 24          highr          highr              yihui               0.3           0.3.1             TRUE
    ## 25         httpuv         httpuv            rstudio             1.3.0           1.3.1             TRUE
    ## 26       jsonlite       jsonlite         jeroenooms             0.9.9          0.9.10             TRUE
    ## 27  knitcitations  knitcitations           cboettig             1.0-1           1.0.2             TRUE
    ## 28          knitr          knitr              yihui             1.6.2          1.6.14             TRUE
    ## 29 knitrBootstrap knitrBootstrap          jimhester             1.0.0           1.0.0            FALSE
    ## 30      lubridate      lubridate             hadley             1.3.3           1.3.3            FALSE
    ## 31       markdown       markdown            rstudio               0.7           0.7.4             TRUE
    ## 32        memoise        memoise             hadley             0.2.1          0.2.99             TRUE
    ## 33           mime           mime              yihui             0.1.1           0.1.2             TRUE
    ## 34        packrat        packrat            rstudio           0.4.0.4        0.4.0.12             TRUE
    ## 35         repmis         repmis christophergandrud             0.2.9           0.2.9            FALSE
    ## 36       reshape2        reshape             hadley               1.4        1.4.0.99             TRUE
    ## 37         resolv         resolv           hrbrmstr             0.2.2           0.2.2            FALSE
    ## 38       roxygen2        roxygen         klutometis          4.0.1.99        4.0.1.99            FALSE
    ## 39         scales         scales             hadley             0.2.4        0.2.4.99             TRUE
    ## 40          shiny          shiny            rstudio            0.10.0     0.10.1.9004             TRUE
    ## 41       shinyAce       shinyAce        trestletech             0.1.0           0.1.0            FALSE
    ## 42         testit         testit              yihui               0.3             0.3            FALSE
    ## 43        whisker        whisker            edwindj             0.3-2             0.4             TRUE

### Test Results

``` {.r}
library(dtupdate)
library(testthat)

date()
```

    ## [1] "Sun Aug 24 08:22:07 2014"

``` {.r}
test_dir("tests/")
```

    ## basic functionality : [1;32m.[0m
