context("getavg")

test_that("check if getavg returns average values", {
  expect_equal(getavg(c(1)), 1) # 1/1 = 1
  expect_equal(getavg(c(1,3)), 2) # (1+3)/2 = 2
  expect_equal(getavg(c(1,3,5)), 3) # (1+3+5)/3 = 3
  expect_equal(getavg(c(-2,2)), 0) # (-2+2)/2 = 0

  expect_warning(getavg(NULL)) # getavg(NULL) should return a warning
})
