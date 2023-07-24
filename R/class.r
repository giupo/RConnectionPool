ConnectionPool <- R6::R6Class(
  "ConnectionPool",
  inherit = R6P::Singleton,
  public = list(
    initialize = function(factory) {
      private$factory <- factory
      private$pool[[1]] <- factory()
    },

    get_connection = function() {
      new("PooledConnection", private$pool[[1]], self)
    },

    release = function(con) {
    }
  ), # public

  private = list(
    factory = NULL,
    pool = list()
  ), # private

  active = list() # active
)
