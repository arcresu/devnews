
# devnews

<!-- badges: start -->
<!-- badges: end -->

Utilities for browsing and extracting NEWS entries for package source trees.

## Installation

You can install the development version of devnews like so:

``` r
remotes::install_github("arcresu/devnews")
```

## Example

``` r
library(devnews)

news_path <- find_news_file("/path/to/package")
news_db <- build_news_db_from_file(news_path)
show_news(news_db)
```

