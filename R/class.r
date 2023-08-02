ConnectionPool <- R6::R6Class(
  "ConnectionPool",
  inherit = R6P::Singleton,
  public = list(
    initialize = function(factory, min = 1, max = 5) {
      private$factory <- factory
      private$min <- min
      private$max <- max

      for(i in seq(private$max)) {
        private$pool[[i]] <- factory()
      }
    },

    get_connection = function() {
      con_id <- setdiff(seq(1, length(private$pool)), private$used)

      if (!length(con_id))  {
        stop("Cannot create another connectiton, increase max dim")
      }

      con_id <- con_id[[1]]
      private$used <- c(private$used, con_id)
      new("PooledConnection", private$pool[[con_id]], con_id, self)
    },

    release = function(con) {
      con_id <- con@id
      private$used <- private$used[private$used != con_id]
    }
  ), # public

  private = list(
    factory = NULL,
    pool = list(),
    used = c(),
    min = 0,
    max = 1
  ), # private

  active = list() # active
)
