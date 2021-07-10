
#' Assess a Web Page for Link Rot
#'
#' Fetch all web links from a given web page and check for a response.
#'
#' @param page Character. A valid URL to a webpage that contains links you
#'     want to check for link rot. Must start 'http://' or 'https://'.
#'
#' @return A tibble with six columns (page, link_url, link_text, response_code,
#'     response_category and response_success) and as many rows as URLs found
#'     on the web page provided by the user.
#'
#' @export
#'
#' @examples \dontrun{ detect_rot("https://www.rostrum.blog/") }
detect_rot <- function(page) {

  .validate_page(page)
  cat(paste0("Checking <", page, "> "))
  links <- .fetch_links(page)
  .check_links(links)

}
