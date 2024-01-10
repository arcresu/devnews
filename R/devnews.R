#' Search a package source tree for a NEWS file
#'
#' Follows the search order documented in `utils::news()`.
#'
#' @param dir Directory to package source tree
#'
#' @return Path to the first matching NEWS file, or NULL if none is found
#' @export
find_news_file <- function(dir) {
  news_path <- fs::path_abs(c(
    file.path(dir, "inst", "NEWS.Rd"),
    file.path(dir, "NEWS.md"),
    file.path(dir, "NEWS"),
    file.path(dir, "inst", "NEWS")
  ))
  news_path <- news_path[file.exists(news_path)]
  if (length(news_path >= 1L)) {
    return(news_path[[1]])
  }
}

#' Build a news database
#'
#' @param path Path to the NEWS file
#' @param mode Parser to use. `"auto"` determines the parser based on the file extension of `path`.
#'
#' @return news_db object, or NULL if the parser failed to find any valid entries
#' @export
build_news_db_from_file <- function(path, mode = c("auto", "Rd", "md", "plain")) {
  mode <- match.arg(mode)
  if (mode == "auto") {
    mode <- fs::path_ext(path)
  }

  switch (
    mode,
    Rd = tools:::.build_news_db_from_package_NEWS_Rd(path),
    md = tools:::.build_news_db_from_package_NEWS_md(path),
    plain = tools:::.news_reader_default(path)
  )
}

#' View NEWS entries as HTML
#'
#' Launches a browser to view the HTML, or if in rstudio uses the viewer pane.
#'
#' @param news_db NEWS entry database, a news_db object
#' @param ... Parameters passed to tools::HTMLheader()
#'
#' @return Nothing
#' @export
show_news <- function(news_db, ...) {
  html <- tools::toHTML(news_db, ...)
  tmp <- tempfile(fileext = ".html")
  message(tmp)
  write(html, tmp)

  if (requireNamespace('rstudioapi', quietly = TRUE) && rstudioapi::isAvailable("0.98.423")) {
    rstudioapi::viewer(tmp)
  } else {
    utils::browseURL(html)
  }
}
