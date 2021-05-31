page <- "https://www.rostrum.blog/"
page_404 <- "https://www.rostrum.blog/404"

test_that("output of check is a dataframe", {

  valid_out <- lr_check(page)

  # Expect a tibble back if URL is valid
  expect_type(valid_out, "list")
  expect_equal(class(valid_out), c("tbl_df", "tbl", "data.frame"))

})

test_that("invalid inputs cause errors", {

  # Invalid page argument
  expect_error(lr_check())
  expect_error(lr_check(1))
  expect_error(lr_check(c(page, page)))
  expect_error(lr_check(list(page)))

  # Correct class, but can't resolve
  expect_error(lr_check("x"))

})

test_that("unresolvable page causes error", {

  expect_error(lr_check(page_404))

})
