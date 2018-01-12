
[![Build
Status](https://travis-ci.org/hrbrmstr/dtupdate.png)](https://travis-ci.org/hrbrmstr/dtupdate)

# dtupdate

Keep Up-To-Date with Non-CRAN Package Updates

## Description

CRAN and Bioconductor users have mechanisms to update their installed
packages but those of us who live in the devtools GitHub world are levt
to intall\_github all on our own. This package fills that gap by
providing a function that attempts to figure out which packages were
installed from GitHub and then tries to figure out which ones have
updates (i.e. the GitHub version is \> local version). It provides an
option (not recommended) to (optionally, selectively) auto-update any
packages with newer GitHub development versions.

The following functions are implemented:

  - `github_update` - find, report and optionally update packages
    installed from or available on github

## Installation

``` r
devtools::install_github("hrbrmstr/dtupdate")
```

## Usage

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

    ## Warning in read.dcf(url_con, fields = "Version"): cannot open URL 'https://raw.githubusercontent.com/hrbrmstr/hannaford/
    ## master/DESCRIPTION': HTTP status was '404 Not Found'

    ##          package       date    version gh_version *                                     source
    ## 1  addinexamples 2017-06-18      0.1.0      0.1.0       Github (rstudio/addinexamples@fae9609)
    ## 2     adobecolor 2017-05-21        0.2        0.2         Github (hrbrmstr/adobecolor@7dc06f1)
    ## 3      albersusa 2017-08-24      0.3.0      0.3.0          Github (hrbrmstr/albersusa@82220d3)
    ## 4        archive 2017-10-08      1.0.0      1.0.0           Github (jimhester/archive@1c1a322)
    ## 5          callr 2017-12-19 1.0.0.9000 1.0.0.9000                 Github (r-lib/callr@550fa6b)
    ## 6   circlepackeR 2017-09-30 0.0.0.9000 0.0.0.9000     Github (jeromefroe/circlepackeR@f0a84d5)
    ## 7      codefinch 2017-09-01 0.0.0.9002 0.0.0.9002      Github (ropenscilabs/codefinch@d6dddbb)
    ## 8         crandb 2017-09-14      1.0.0      1.0.0             Github (metacran/crandb@c0c7c21)
    ## 9           curl 2017-12-24        3.1        3.1                 Github (jeroen/curl@85a37fe)
    ## 10     cyclocomp 2017-07-24      1.1.0      1.1.0       Github (MangoTheCat/cyclocomp@6156a12)
    ## 11    data.world 2017-12-27      1.1.1      1.1.1   Github (datadotworld/data.world-r@2134122)
    ## 12        dbplyr 2017-06-29 1.1.0.9000      1.2.0 *          Github (tidyverse/dbplyr@22fd4df)
    ## 13           egg 2017-11-29      0.3.0      0.4.0 *              Github (baptiste/egg@d261631)
    ## 14         falsy 2017-09-14      1.0.1      1.0.1           Github (gaborcsardi/falsy@ee26873)
    ## 15      fireData 2017-12-24        1.1        1.1              Github (Kohze/fireData@3803b24)
    ## 16  ggTimeSeries 2017-08-29        0.1        0.1    Github (AtherEnergy/ggTimeSeries@ca9639d)
    ## 17            gh 2017-09-14      1.0.1      1.0.1                    Github (r-lib/gh@27db16c)
    ## 18          ghql 2017-05-25 0.0.3.9110 0.0.3.9110               Github (ropensci/ghql@320549c)
    ## 19  goodpractice 2017-07-24      1.0.0      1.0.0    Github (MangoTheCat/goodpractice@9969799)
    ## 20     hannaford 2017-12-11      0.1.0       <NA>          Github (hrbrmstr/hannaford@a20b8cb)
    ## 21        harbor 2017-06-10      0.2.0      0.2.0                  Github (wch/harbor@4e6ce36)
    ## 22     htmltools 2017-06-18      0.3.6      0.3.6           Github (rstudio/htmltools@02678ee)
    ## 23      icdcoder 2017-10-04 0.0.0.9000 0.0.0.9000           Github (wtcooper/icdcoder@777c878)
    ## 24      jsonview 2017-05-16      0.2.0      0.2.0           Github (hrbrmstr/jsonview@d633133)
    ## 25         knitr 2018-01-10     1.18.4     1.18.5 *               Github (yihui/knitr@0a9a502)
    ## 26        miniUI 2017-06-18      0.1.1      0.1.1              Github (rstudio/miniUI@c705afe)
    ## 27        notary 2017-07-24      0.1.0      0.1.0         Github (ropenscilabs/notary@35748db)
    ## 28    pdfboxjars 2017-11-30      2.0.0      2.0.0         Github (hrbrmstr/pdfboxjars@fa2dd4d)
    ## 29      pkgbuild 2017-12-19 0.0.0.9000 0.0.0.9000              Github (r-lib/pkgbuild@ce7f6d1)
    ## 30       pkgdown 2017-06-18 0.1.0.9000 0.1.0.9000              Github (hadley/pkgdown@8f06abd)
    ## 31       pkgload 2017-12-19 0.0.0.9000 0.0.0.9000               Github (r-lib/pkgload@70eaef8)
    ## 32          riem 2017-11-17      0.1.1      0.1.1               Github (ropensci/riem@faee0b9)
    ## 33         rlang 2017-12-24 0.1.4.9000 0.1.6.9002 *           Github (tidyverse/rlang@2a8971e)
    ## 34      roxygen2 2017-12-19 6.0.1.9000 6.0.1.9000          Github (klutometis/roxygen@bbf259d)
    ## 35         rpwnd 2017-05-26      0.1.0      0.1.0              Github (hrbrmstr/rpwnd@5089bfb)
    ## 36     rrricanes 2017-08-13    0.2.0-6    0.2.0.7 *        Github (ropensci/rrricanes@95deb42)
    ## 37        rtweet 2018-01-10     0.6.15     0.6.15             Github (mkearney/rtweet@c33b019)
    ## 38        scales 2017-09-01 0.5.0.9000 0.5.0.9000               Github (hadley/scales@d767915)
    ## 39         shiny 2017-09-01 1.0.5.9000 1.0.5.9000               Github (rstudio/shiny@4fa2af7)
    ## 40        stackr 2017-12-28 0.0.0.9000 0.0.0.9000               Github (dgrtwo/stackr@3708582)
    ## 41      subtools 2017-04-29        0.1        0.1              Github (fkeck/subtools@da82ba9)
    ## 42     tabulizer 2017-05-22     0.1.24     0.1.24          Github (ropensci/tabulizer@a38d957)
    ## 43 tabulizerjars 2017-05-22      0.9.2      0.9.2      Github (ropensci/tabulizerjars@c6cc40e)
    ## 44      uaparser 2017-05-21      0.2.0      0.2.0             Github (ua-parser/uap-r@cbfdc17)
    ## 45         withr 2017-12-24 2.1.1.9000 2.1.1.9000             Github (jimhester/withr@df18523)
    ## 46       xmlview 2017-04-28      0.4.7      0.4.7            Github (hrbrmstr/xmlview@4e93801)

## Test Results

``` r
library(dtupdate)
library(testthat)

date()
```

    ## [1] "Fri Jan 12 07:57:26 2018"

``` r
test_dir("tests/")
```

    ## ✔ | OK F W S | Context
    ## ══ testthat results  ════════════════════════════════════════════════════════════════════
    ## OK: 2 SKIPPED: 0 FAILED: 0
    ## 
    ## ══ Results ══════════════════════════════════════════════════════════════════════════════
    ## Duration: 9.2 s
    ## 
    ## OK:       0
    ## Failed:   0
    ## Warnings: 0
    ## Skipped:  0
