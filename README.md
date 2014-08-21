The `dtupdate` packages has functions that attempt to figure out which packages have non-CRAN versions (currently only looks for github ones) and then tries to figure out which ones have updates (i.e. the github version is \> local version). It provides an option (not recommended) to auto-update any packages with newer development versions.

The `URL` and `BugReports` fields are, frankly, a mess. Many packages have multiple URLs in one or both of those fields and the non-github URLs are all over the place in terms of formatting. It will take some time, but I'm pretty confident I can get r-forge, bitbucket, gitorius and other external repos working. This was an easy first step.

The following functions are implemented:

-   `github_update` - find, report and optionally update packages installed from or available on github. This initial version just keys off of the `BugReports:` field, looking for a github-ish URL and then grabbing what info that it can to see if the repo is in package format and has a `DESCRIPTION` file it can key off of

The following data sets are included:

### News

-   Version `1.0` released (nascent github pkg update capability)

### Installation

``` {.r}
devtools::install_github("hrbrmstr/dtupdate")
```

### Usage

``` {.r}
library(dtupdate)

# current verison
packageVersion("dtupdate")
```

    ## [1] '1.0'

``` {.r}
# see what packages are available for an update
github_update()
```

    ##      package.repo       owner installed.version current.version update.available
    ## 1        corrplot      taiyun              0.73            0.73               no
    ## 2      data.table  Rdatatable             1.9.3           1.9.3               no
    ## 3        dtupdate    hrbrmstr               1.0             1.0               no
    ## 4         formatR       yihui            0.10.5          0.10.5               no
    ## 5         ggplot2      hadley          1.0.0.99        1.0.0.99               no
    ## 6        ggthemes      jrnold             1.8.0           1.8.0               no
    ## 7          gmailr   jimhester             0.0.1           0.0.1               no
    ## 8           highr       yihui             0.3.1           0.3.1               no
    ## 9        miniCRAN      andrie            0.0-20          0.0-20               no
    ## 10  RcppArmadillo    RcppCore         0.4.400.0       0.4.400.0               no
    ## 11       corrplot      taiyun              0.73            0.73               no
    ## 12       forecast robjhyndman               5.4             5.6              yes
    ## 13        formatR       yihui              0.10          0.10.5              yes
    ## 14        ggplot2      hadley             1.0.0        1.0.0.99              yes
    ## 15       ggthemes      jrnold             1.7.0           1.8.0              yes
    ## 16          highr       yihui               0.3           0.3.1              yes
    ## 18       jsonlite  jeroenooms             0.9.9          0.9.10              yes
    ## 19          knitr       yihui             1.6.6          1.6.14              yes
    ## 20 knitrBootstrap   jimhester             1.0.0           1.0.0               no
    ## 21      lubridate      hadley             1.3.3           1.3.3               no
    ## 22       markdown     rstudio               0.7           0.7.4              yes
    ## 23        memoise      hadley             0.2.1          0.2.99              yes
    ## 24           mime       yihui             0.1.1           0.1.2              yes
    ## 25        packrat     rstudio             0.4.0        0.4.0.12              yes
    ## 26           Rcpp    RcppCore            0.11.2        0.11.2.1              yes
    ## 27       reshape2      hadley               1.4        1.4.0.99              yes
    ## 28           rzmq    armstrtw             0.7.0           0.7.0               no
    ## 29         scales      hadley             0.2.4        0.2.4.99              yes
    ## 30          shiny     rstudio       0.10.0.9001     0.10.1.9004              yes
    ## 31       shinyAce trestletech             0.1.0           0.1.0               no
    ## 32        slidify    ramnathv             0.4.5           0.4.5               no
    ## 33         testit       yihui               0.3             0.3               no

### Test Results

``` {.r}
library(iptools)
library(testthat)

date()
```

    ## [1] "Thu Aug 21 10:27:43 2014"

``` {.r}
test_dir("tests/")
```

    ## basic functionality : .
