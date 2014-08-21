context("basic functionality")
test_that("we can run the function and get back a dat frame", {

  expect_that(github_update(), is_a("data.frame"))

})