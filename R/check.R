
#' Assess a Webpage for Linkrot
#'
#' Fetch web links from a given page and check for a response.
#'
#' @param page Character. A valid URL to a webpage that contains links you
#'     want to check for linkrot. Must start 'http://www.' or 'https://www.'.
#'
#' @return A data.frame with 5 columns (page, link_url, link_text, response_code
#'     and response_category, success) and as many rows per URLs found on the
#'     page provided by the user.
#'
#' @export
#'
#' @examples \dontrun{ lr_check("https://www.rostrum.blog/") }
lr_check <- function(page) {

  .validate_page(page)
  cat(paste0("[", Sys.time(), "]"), page)
  links <- .fetch_links(page)
  .check_links(links)

}
