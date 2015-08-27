[![Build Status](https://travis-ci.org/hrbrmstr/dtupdate.png)](https://travis-ci.org/hrbrmstr/dtupdate)

CRAN and Bioconductor users have mechanisms to update their installed packages but those of us who live in the devtools GitHub world are levt to intall\_github all on our own. This package fills that gap by providing a function that attempts to figure out which packages were installed from GitHub and then tries to figure out which ones have updates (i.e. the GitHub version is \> local version). It provides an option (not recommended) to (optionally, selectively) auto-update any packages with newer GitHub development versions.

The following functions are implemented:

-   `github_update` - find, report and optionally update packages installed from or available on github

### News

-   Version `1.5` pkg is no longer "broken" and takes a step back and solely focuses on updates from github. `whats_new()` has been temporarily removed. output has been formatted to look more like `devtools` output
-   Version `1.4` adds a `whats_new()` function that uses `rmarkdown` to produce an HTML report from all the available `NEWS[.md]` files for any packages that have updates
-   Version `1.3` works with both the `BugReports:` and `URL:` field and handles some additional URL-retrieving exceptions
-   Version `1.2` switches from `plyr` to `dplyr` to stop [@jayjacobs](<http://twitter.com/jayjacobs>) from whining, removes the `libLoc` switch from version `1.1` and replaces it with a boolean `all` parameter which let's you switch from inspecting the github packages installed across all library paths or just the first one (*usually* your user/local path), and adds a `show.location` parameter which will include the library path for each package in the data frame return
-   Version `1.1` incorporates functionality from [Thomas J Leeper](http://twitter.com/thosjleeper)'s gist: , including the ability to interactively select which packages to install, the option to specify which `libLoc` will be searched by `installed.packages` and handling of a fringe case where the repo name does not match the package name (ironically, this was due to Hadley's `reshape` repo for the `reshape2` package)
-   Version `1.0` released (nascent github pkg update capability)

### Installation

``` r
devtools::install_github("hrbrmstr/dtupdate")
```

### Usage

``` r
library(dtupdate)

# current verison
packageVersion("dtupdate")
```

    ## [1] '1.5'

``` r
# see what packages are available for an update
github_update()
```

    ##             package       date    version gh_version *                                    source
    ## 1  AnomalyDetection 2015-05-18        1.0        1.0   Github (twitter/AnomalyDetection@c78f0df)
    ## 2              arco 2015-06-16        0.1        0.1                Github (leeper/arco@89954f0)
    ## 3               ask 2015-08-20      1.0.0      1.0.0            Github (gaborcsardi/ask@605599f)
    ## 4         data.tree 2015-08-27      0.1.9      0.1.9             Github (gluc/data.tree@73fd9cf)
    ## 5          devtools 2015-08-27      1.9.0      1.9.0            Github (hadley/devtools@76ada1d)
    ## 6             dmaps 2015-07-27      0.0.1      0.0.1          Github (jpmarindiaz/dmaps@320f550)
    ## 7             dplyr 2015-08-25 0.4.2.9002 0.4.2.9002               Github (hadley/dplyr@25a1522)
    ## 8             editR 2015-06-09      0.2.0      0.2.0            Github (swarm-lab/editR@70752e4)
    ## 9         ggfortify 2015-08-26      0.0.3      0.0.3          Github (sinhrks/ggfortify@393b20a)
    ## 10             ggsn 2015-08-27      0.2.0      0.2.0         Github (oswaldosantos/ggsn@3f01af2)
    ## 11           github 2015-08-27      0.9.7      0.9.7            Github (cscheid/rgithub@2d6f643)
    ## 12         gitstats 2015-06-21      0.2.7      0.2.7           Github (opencpu/gitstats@85ce1b5)
    ## 13             httr 2015-06-29 1.0.0.9000 1.0.0.9000                Github (hadley/httr@d9395f2)
    ## 14            Kmisc 2015-04-19      0.5.1      0.5.1           Github (kevinushey/Kmisc@b9a340e)
    ## 15          knitron 2015-06-08        0.2        0.2        Github (fhirschmann/knitron@2b5c1d4)
    ## 16         licorice 2015-07-02        0.1        0.1          Github (Bart6114/licorice@70c38d1)
    ## 17     lineworkmaps 2015-07-22 0.0.0.9000 0.0.0.9000      Github (hrbrmstr/lineworkmaps@2975bb0)
    ## 18        lubridate 2015-06-20 1.4.0.9500 1.4.0.9500           Github (hadley/lubridate@f9761ce)
    ## 19       mason.rpkg 2015-08-20      1.0.0      1.0.0        Github (metacran/mason.rpkg@662bf15)
    ## 20              PKI 2015-06-14      0.1-3      0.1-3                    Github (s-u/PKI@e58876e)
    ## 21           plotly 2015-08-27      1.0.7      1.0.7            Github (ropensci/plotly@b0532b9)
    ## 22           rapier 2015-07-02        0.1        0.1         Github (trestletech/rapier@012f083)
    ## 23           rbokeh 2015-08-27    0.2.3.2    0.2.3.2               Github (bokeh/rbokeh@2bab3a6)
    ## 24             rdom 2015-05-27      0.0.2      0.0.2             Github (cpsievert/rdom@0bfd967)
    ## 25           readxl 2015-07-03 0.1.0.9000 0.1.0.9000              Github (hadley/readxl@7c7f66b)
    ## 26              rio 2015-08-27      0.2.3      0.2.3                 Github (leeper/rio@f278e54)
    ## 27        rmarkdown 2015-08-26      0.7.3      0.7.3          Github (rstudio/rmarkdown@ee2f13c)
    ## 28             rope 2015-06-03      0.1.0      0.1.0             Github (ironholds/rope@9541abe)
    ## 29        rsconnect 2015-08-13    0.4.1.4    0.4.1.4          Github (rstudio/rsconnect@295276c)
    ## 30           secure 2015-06-14        0.1        0.1              Github (hadley/secure@b279c21)
    ## 31         shinyAce 2015-06-09      0.2.1      0.2.1       Github (trestletech/shinyAce@3217e8e)
    ## 32           SparkR 2015-07-02      1.4.0       <NA>               Github (apache/spark@22596c5)
    ## 33              ssh 2015-08-24        0.1        0.1             Github (jeroenooms/ssh@5a1fc00)
    ## 34           stocks 2015-06-21        9.0        9.0             Github (opencpu/stocks@5d1141a)
    ## 35            Sxslt 2015-07-07     0.91-1     0.91-1             Github (cboettig/Sxslt@2e007d0)
    ## 36           verisr 2015-08-18      2.0.6      2.0.6           Github (jayjacobs/verisr@f7fd01d)
    ## 37          viridis 2015-08-26      0.2.5      0.2.5         Github (sjmgarnier/viridis@ac54cc1)
    ## 38       websockets 2015-08-22      1.1.7      1.1.7       Github (rstudio/R-Websockets@b306dba)
    ## 39         webtools 2015-06-24      0.1.0      0.3.0 *       Github (ironholds/webtools@50c3e5f)

### Test Results

``` r
library(dtupdate)
library(testthat)

date()
```

    ## [1] "Thu Aug 27 16:54:17 2015"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 1 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE
