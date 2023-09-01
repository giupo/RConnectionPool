#' Connection Pool implementation
#' @description the classical and notorious connecton pool.
#'   It needs a `facotry` (a.k.a. a function) which creates
#'   the actual DB connections
#' @export

ConnectionPool <- R6::R6Class(
  "ConnectionPool",
  public = list(

    #' @description builds a Connection Pool
    #' @param factory actual function (callable) which creates the connection
    #' @param min minimun number of connections (default: 1)
    #' @param max maximum number of connections (default: 5)
    initialize = function(factory, min = 1, max = 5) {
      private$factory <- factory
      private$min <- min
      private$max <- max

      for(i in seq(private$max)) {
        private$pool[[i]] <- factory()
      }
    },

    #' @description returns a PooledConnection
    #'   the only thing a PooledConnection does is to return to the pool
    #'   when `DBI::dbDisconnect` is called on it
    get_connection = function() {
      con_id <- setdiff(seq(1, length(private$pool)), private$used)

      if (!length(con_id))  {
        # since this is not meant to be used in a multithreaded env,
        # let's fail
        stop("Cannot create another connectiton, increase max dim")
      }

      con_id <- con_id[[1]]
      private$used <- c(private$used, con_id)
      new("PooledConnection", private$pool[[con_id]], con_id, self)
    },

    #' @description releases a Connection to the pool
    #' @param con to be released
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


# to silence check waring

.not_used <- function() {
  R6::R6Class("")
}
