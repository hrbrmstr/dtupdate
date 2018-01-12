### News

- Version `1.5` pkg is no longer "broken" and takes a step back and solely focuses on updates from github. `whats_new()` has been temporarily removed. output has been formatted to look more like `devtools` output
- Version `1.4` adds a `whats_new()` function that uses `rmarkdown` to produce an HTML report from all the available `NEWS[.md]` files for any packages that have updates
- Version `1.3` works with both the `BugReports:` and `URL:` field and handles some additional URL-retrieving exceptions
- Version `1.2` switches from `plyr` to `dplyr` to stop [@jayjacobs](http://twitter.com/jayjacobs) from whining, removes the `libLoc` switch from version `1.1` and replaces it with a boolean `all` parameter which let's you switch from inspecting the github packages installed across all library paths or just the first one (*usually* your user/local path), and adds a `show.location` parameter which will include the library path for each package in the data frame return
- Version `1.1` incorporates functionality from [Thomas J Leeper](http://twitter.com/thosjleeper)'s \code{#spiffy} gist: \url{https://gist.github.com/leeper/9123584}, including the ability to interactively select which packages to install, the option to specify which `libLoc` will be searched by `installed.packages` and handling of a fringe case where the repo name does not match the package name (ironically, this was due to Hadley's `reshape` repo for the `reshape2` package)
- Version `1.0` released (nascent github pkg update capability)
