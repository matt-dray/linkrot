
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {linkrot}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
<!-- badges: end -->

An R package to help detect
[linkrot](https://en.wikipedia.org/wiki/Link_rot), which is when links
to a web page break because it’s been taken down or moved.

Very much a concept for now. Feel free to contribute.

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

Here’s a check on one of my older blog posts:

``` r
library(linkrot)
page <-  "https://www.rostrum.blog/2018/04/14/r-trek-exploring-stardates/"
lr_check(page)
#> # A tibble: 14 x 5
#>    page           link_url           link_text    response_code response_catego…
#>    <chr>          <chr>              <chr>                <int> <chr>           
#>  1 https://www.r… https://www.r-pro… R statistic…           200 Success         
#>  2 https://www.r… https://en.wikipe… Star Trek: …           200 Success         
#>  3 https://www.r… https://github.co… regex                  200 Success         
#>  4 https://www.r… https://en.wikipe… Wikipedia              200 Success         
#>  5 https://www.r… https://cran.r-pr… how-to vign…           404 Client error    
#>  6 https://www.r… https://www.htmlw… htmlwidget             200 Success         
#>  7 https://www.r… https://github.co… ggsci                  200 Success         
#>  8 https://www.r… https://rostrum.b… Adriana                200 Success         
#>  9 https://www.r… https://xkcd.com/… relevant xk…           200 Success         
#> 10 https://www.r… https://github.co… RTrek                  200 Success         
#> 11 https://www.r… https://en.wikipe… Wikipedia              200 Success         
#> 12 https://www.r… https://creativec… CC BY-NC-SA…           200 Success         
#> 13 https://www.r… https://www.rostr… Feed                   200 Success         
#> 14 https://www.r… https://github.co… Source                 200 Success
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
set_names(map(pages, lr_check), basename(pages))
#> $`r-trek-exploring-stardates`
#> # A tibble: 14 x 5
#>    page           link_url           link_text    response_code response_catego…
#>    <chr>          <chr>              <chr>                <int> <chr>           
#>  1 https://www.r… https://www.r-pro… R statistic…           200 Success         
#>  2 https://www.r… https://en.wikipe… Star Trek: …           200 Success         
#>  3 https://www.r… https://github.co… regex                  200 Success         
#>  4 https://www.r… https://en.wikipe… Wikipedia              200 Success         
#>  5 https://www.r… https://cran.r-pr… how-to vign…           404 Client error    
#>  6 https://www.r… https://www.htmlw… htmlwidget             200 Success         
#>  7 https://www.r… https://github.co… ggsci                  200 Success         
#>  8 https://www.r… https://rostrum.b… Adriana                200 Success         
#>  9 https://www.r… https://xkcd.com/… relevant xk…           200 Success         
#> 10 https://www.r… https://github.co… RTrek                  200 Success         
#> 11 https://www.r… https://en.wikipe… Wikipedia              200 Success         
#> 12 https://www.r… https://creativec… CC BY-NC-SA…           200 Success         
#> 13 https://www.r… https://www.rostr… Feed                   200 Success         
#> 14 https://www.r… https://github.co… Source                 200 Success         
#> 
#> $`two-dogs-in-toilet-elderly-lady-involved`
#> # A tibble: 30 x 5
#>    page            link_url          link_text    response_code response_catego…
#>    <chr>           <chr>             <chr>                <int> <chr>           
#>  1 https://www.ro… https://www.twit… @mattdray              200 Success         
#>  2 https://www.ro… https://data.lon… the London …           200 Success         
#>  3 https://www.ro… https://github.c… the sf pack…           200 Success         
#>  4 https://www.ro… https://rstudio.… interactive…           200 Success         
#>  5 https://www.ro… https://en.wikip… eastings an…           200 Success         
#>  6 https://www.ro… https://en.wikip… latitude               200 Success         
#>  7 https://www.ro… https://en.wikip… longitude              200 Success         
#>  8 https://www.ro… https://rstudio.… leaflet                200 Success         
#>  9 https://www.ro… https://www.r-pr… R                      200 Success         
#> 10 https://www.ro… https://github.c… sf (‘simple…           200 Success         
#> # … with 20 more rows
#> 
#> $`pokeballs-in-super-smash-bros`
#> # A tibble: 20 x 5
#>    page         link_url         link_text        response_code response_catego…
#>    <chr>        <chr>            <chr>                    <int> <chr>           
#>  1 https://www… https://en.wiki… Super Smash Bros           200 Success         
#>  2 https://www… https://en.wiki… Super Smash Bro…           400 Client error    
#>  3 https://www… https://en.wiki… SSB Melee, 2001            200 Success         
#>  4 https://www… https://en.wiki… SSB Brawl, 2008            200 Success         
#>  5 https://www… https://en.wiki… SSB ‘4’, 2014              200 Success         
#>  6 https://www… https://www.ssb… a series of org…           200 Success         
#>  7 https://www… https://en.wiki… the Super Mario…           200 Success         
#>  8 https://www… https://en.wiki… Zelda                      200 Success         
#>  9 https://www… https://en.wiki… EarthBound                 200 Success         
#> 10 https://www… https://en.wiki… the Pokémon ser…           400 Client error    
#> 11 https://www… https://www.ssb… The SSB wiki               200 Success         
#> 12 https://www… https://github.… a CSV on GitHub            200 Success         
#> 13 https://www… https://github.… the Rokemon pac…           200 Success         
#> 14 https://www… https://www.ssb… the SSB wiki               200 Success         
#> 15 https://www… https://www.you… the indie docum…           200 Success         
#> 16 https://www… https://guangch… Guangchuang Yu             200 Success         
#> 17 https://www… https://cran.r-… plots points as…           404 Client error    
#> 18 https://www… https://creativ… CC BY-NC-SA 4.0            200 Success         
#> 19 https://www… https://www.ros… Feed                       200 Success         
#> 20 https://www… https://github.… Source                     200 Success
```

Uh-oh, more broken links.

## Code of Conduct

Please note that the {linkrot} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
