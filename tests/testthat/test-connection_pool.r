factory <- function() {
  DBI::dbConnect(RSQLite::SQLite(), ":memory:")
}

test_that("test singleton", {
  #expect_s3_class(pool1 <- ConnectionPool$new(factory), "Singleton")
  #expect_s3_class(pool2 <- ConnectionPool$new(factory), "ConnectionPool")
  #expect_identical(pool1, pool2)
})
