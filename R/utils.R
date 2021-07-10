.validate_page <- function(page) {

  if (class(page) != "character" | length(page) != 1) {
    stop("Argument 'page' must be a character string of length 1.")
  }

  # Extremely basic URL validity check
  is_url_ok <- grepl("^http://|^https://", page)

  if (!is_url_ok) {
    stop("Argument 'page' must begin 'http(s)://'.")
  }

  # Can page be reached?
  pg_get    <- httr::GET(page)
  pg_status <- httr::status_code(pg_get)
  is_pg_ok  <- httr::http_error(pg_get)

  if (is_pg_ok) {
    stop("That page couldn't be reached (status code ", pg_status, ").")
  }

}

.fetch_links <- function(page) {

  # Fetch page content, extract links
  page_html  <- xml2::read_html(page)
  link_nodes <- rvest::html_nodes(page_html, "a")
  link_urls  <- rvest::html_attr(link_nodes, "href")
  link_texts <- rvest::html_text(link_nodes, "href")

  # Compose links into table
  links_df <- data.frame(
    page = page,
    link_url = link_urls,
    link_text = link_texts
  )

  # Only want links to webpages
  pattern <- "^http://|^https://"
  links_df[grepl(pattern, links_df$link_url), ]

}

.check_links <- function(links_df) {

  # Create response code column to fill with loop
  links_df$response_code <- NA_real_

  # Using a loop so we can return a dot for each iteration
  for (i in 1:nrow(links_df)) {

    tryCatch(
      links_df$response_code[i] <-
        httr::status_code(httr::GET(links_df$link_url[i])),
      error = function(e) {
        cat("!")
        links_df$response_code[i] <- NA_real_
      }
    )

    cat(".")

  }

  # Convert status code to message
  links_df$response_category <- unlist(
    lapply(
      links_df$response_code,
      function(x) {
        tryCatch(
          httr::http_status(x)$category,
          error = function(e) NA_real_
        )
      }
    )
  )

  # Logical rot status
  links_df$response_success <- unlist(
    lapply(
      links_df$response_category,
      function(x) ifelse(x == "Success", TRUE, FALSE)
    )
  )

  cat("\n")

  # Return as tibble for nicer printing
  tibble::as_tibble(links_df)



}
