test_that("invalid inputs cause errors", {
  expect_error(lr_check())
  expect_error(lr_check(1))
  expect_error(lr_check(c(page, page)))
  expect_error(lr_check(list(page)))
  expect_error(lr_check("x"))
})

with_mock_dir("lr_check_success", {
  test_that("lr_check() output as expected", {
    expect_type(lr_check("https://www.rostrum.blog/"), "list")
    expect_equal(
      class(lr_check("https://www.rostrum.blog/")),
      c("tbl_df", "tbl", "data.frame")
    )
    expect_equal(
      names(lr_check("https://www.rostrum.blog/")),
      c("page", "link_url", "link_text", "response_code", "response_category")
    )
  })
})

with_mock_dir("lr_check_fail", {
  test_that("lr_check() fails with unreachable page", {
    expect_error(lr_check("http://httpbin.org/status/404"))
  })
})


