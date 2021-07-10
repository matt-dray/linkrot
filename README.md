
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {linkrot}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/linkrot/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/linkrot/actions)
[![Codecov test
coverage](https://codecov.io/gh/matt-dray/linkrot/branch/main/graph/badge.svg)](https://codecov.io/gh/matt-dray/linkrot?branch=main)
[![rostrum.blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?style=flat&labelColor=black&logo=data:image/gif;base64,R0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh+QQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2021/07/10/linkrot/)
<!-- badges: end -->

An R package to help detect
[linkrot](https://en.wikipedia.org/wiki/Link_rot), which is when links
to a web page break because they’ve been taken down or moved.

Very much a concept. I wrote it to detect linkrot on my personal blog
and it works for my needs. Feel free to contribute.

## Install

This package is only available on GitHub. Install from an R session
with:

``` r
install.packages("remotes")
remotes::install_github("matt-dray/linkrot")
```

## Example

Pass a webpage URL to `lr_check()` and get a tibble with each https link
on that page and what its [response
code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) is
(ideally we want `200`).

Here’s a check on one of my older blog posts. The printout tells you the
URL you’re looking at, with a dot for each successful check.

``` r
library(linkrot)
page <-  "https://www.rostrum.blog/2018/04/14/r-trek-exploring-stardates/"
detect_rot(page)
#> Checking <https://www.rostrum.blog/2018/04/14/r-trek-exploring-stardates/> ..............................
#> # A tibble: 30 x 6
#>    page    link_url    link_text response_code response_catego… response_success
#>    <chr>   <chr>       <chr>             <dbl> <chr>            <lgl>           
#>  1 https:… https://ww… R statis…           200 Success          TRUE            
#>  2 https:… https://en… Star Tre…           200 Success          TRUE            
#>  3 https:… http://www… Star Tre…           200 Success          TRUE            
#>  4 https:… https://gi… regex               200 Success          TRUE            
#>  5 https:… http://vit… tidy                200 Success          TRUE            
#>  6 https:… https://en… Wikipedia           200 Success          TRUE            
#>  7 https:… http://sel… Selector…           200 Success          TRUE            
#>  8 https:… https://cr… how-to v…           404 Client error     FALSE           
#>  9 https:… https://ww… htmlwidg…           200 Success          TRUE            
#> 10 https:… https://gi… ggsci               200 Success          TRUE            
#> # … with 20 more rows
```

Uh oh, at least one is broken: it has a `response_code` of `404`.

You could iterate over multiple pages with {purrr}:

``` r
pages <- c(
  "https://www.rostrum.blog/2018/04/14/r-trek-exploring-stardates/",
  "https://www.rostrum.blog/2018/04/27/two-dogs-in-toilet-elderly-lady-involved/",
  "https://www.rostrum.blog/2018/05/19/pokeballs-in-super-smash-bros/"
)

library(purrr)
set_names(map(pages, detect_rot), basename(pages))
#> Checking <https://www.rostrum.blog/2018/04/14/r-trek-exploring-stardates/> ..............................
#> Checking <https://www.rostrum.blog/2018/04/27/two-dogs-in-toilet-elderly-lady-involved/> ........................................
#> Checking <https://www.rostrum.blog/2018/05/19/pokeballs-in-super-smash-bros/> .....................
#> $`r-trek-exploring-stardates`
#> # A tibble: 30 x 6
#>    page    link_url    link_text response_code response_catego… response_success
#>    <chr>   <chr>       <chr>             <dbl> <chr>            <lgl>           
#>  1 https:… https://ww… R statis…           200 Success          TRUE            
#>  2 https:… https://en… Star Tre…           200 Success          TRUE            
#>  3 https:… http://www… Star Tre…           200 Success          TRUE            
#>  4 https:… https://gi… regex               200 Success          TRUE            
#>  5 https:… http://vit… tidy                200 Success          TRUE            
#>  6 https:… https://en… Wikipedia           200 Success          TRUE            
#>  7 https:… http://sel… Selector…           200 Success          TRUE            
#>  8 https:… https://cr… how-to v…           404 Client error     FALSE           
#>  9 https:… https://ww… htmlwidg…           200 Success          TRUE            
#> 10 https:… https://gi… ggsci               200 Success          TRUE            
#> # … with 20 more rows
#> 
#> $`two-dogs-in-toilet-elderly-lady-involved`
#> # A tibble: 40 x 6
#>    page     link_url   link_text response_code response_catego… response_success
#>    <chr>    <chr>      <chr>             <dbl> <chr>            <lgl>           
#>  1 https:/… https://w… @mattdray           200 Success          TRUE            
#>  2 https:/… https://d… the Lond…           200 Success          TRUE            
#>  3 https:/… https://g… the sf p…           200 Success          TRUE            
#>  4 https:/… https://r… interact…           200 Success          TRUE            
#>  5 https:/… https://e… eastings…           200 Success          TRUE            
#>  6 https:/… https://e… latitude            200 Success          TRUE            
#>  7 https:/… https://e… longitude           200 Success          TRUE            
#>  8 https:/… https://r… leaflet             200 Success          TRUE            
#>  9 https:/… https://w… R                   200 Success          TRUE            
#> 10 https:/… https://g… sf (‘sim…           200 Success          TRUE            
#> # … with 30 more rows
#> 
#> $`pokeballs-in-super-smash-bros`
#> # A tibble: 21 x 6
#>    page    link_url    link_text response_code response_catego… response_success
#>    <chr>   <chr>       <chr>             <dbl> <chr>            <lgl>           
#>  1 https:… https://en… Super Sm…           200 Success          TRUE            
#>  2 https:… https://en… Super Sm…           400 Client error     FALSE           
#>  3 https:… https://en… SSB Mele…           200 Success          TRUE            
#>  4 https:… https://en… SSB Braw…           200 Success          TRUE            
#>  5 https:… https://en… SSB ‘4’,…           200 Success          TRUE            
#>  6 https:… https://ww… a series…           200 Success          TRUE            
#>  7 https:… https://en… the Supe…           200 Success          TRUE            
#>  8 https:… https://en… Zelda               200 Success          TRUE            
#>  9 https:… https://en… EarthBou…           200 Success          TRUE            
#> 10 https:… https://en… the Poké…           400 Client error     FALSE           
#> # … with 11 more rows
```

Uh-oh, more broken links.

## Code of Conduct

Please note that the {linkrot} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
