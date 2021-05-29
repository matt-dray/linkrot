
#' Assess a Webpage for Linkrot
#'
#' Fetch the (https) URLs from a webpage and determine if they're still active
#' by checking for a response (i.e. a response code of 200).
#'
#' @param page Character. A valid https URL to a webpage that contains links you
#'     want to check for linkrot.
#'
#' @return A data.frame.
#' @export
#'
#' @examples lr_check_page("https://www.rostrum.blog/2021/05/22/mission-across-iow/")
lr_check <- function(page) {

  page_get <- httr::GET(page)

  page_200 <- identical(httr::status_code(page_get), 200L)

  if (!page_200) {

    stop("That page couldn't be reached (i.e. the response code was not 200).")

  } else {

    # Fetch page content
    page_html <- xml2::read_html(page)
    link_nodes <- rvest::html_nodes(page_html, "a")
    link_urls <- rvest::html_attr(link_nodes, "href")
    link_texts <- rvest::html_text(link_nodes, "href")

    # Compose links into table
    links_df <- tibble::tibble(
      page = page,
      link_url = link_urls,
      link_text = link_texts
    )

    # Filter for https links only
    links_df <- links_df[grepl("^https", links_df$link_url), ]

    # Get the status code
    response_codes <- lapply(
      links_df$link_url,
      function(x) httr::status_code(httr::GET(x))
    )

    # Add column of codes and messages to table
    links_df$response_code <- unlist(
      lapply(
        links_df$link_url,
        function(x) httr::status_code(httr::GET(x))
      )
    )

    # Convert status code to message
    links_df$response_category <- unlist(
      lapply(
        links_df$response_code,
        function(x) httr::http_status(x)$category
      )
    )

    return(links_df)

  }

}
