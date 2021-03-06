% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check.R
\name{detect_rot}
\alias{detect_rot}
\title{Assess a Web Page for Link Rot}
\usage{
detect_rot(page)
}
\arguments{
\item{page}{Character. A valid URL to a webpage that contains links you
want to check for link rot. Must start 'http://' or 'https://'.}
}
\value{
A tibble with six columns (page, link_url, link_text, response_code,
response_category and response_success) and as many rows as URLs found
on the web page provided by the user.
}
\description{
Fetch all web links from a given web page and check for a response.
}
\examples{
\dontrun{ detect_rot("https://www.rostrum.blog/") }
}
