test_that("test singleton", {
  expect_s3_class(pool1 <- ConnectionPool$new(), "Singleton")
  expect_s3_class(pool2 <- ConnectionPool$new(), "ConnectionPool")
  expect_identical(pool1, pool2)
})
