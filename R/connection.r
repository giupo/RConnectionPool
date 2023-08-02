
#' Pooled connection and methods.
#'
#' @keywords internal
#' @export
#' @include constants.r
#' @import DBI methods

methods::setClass("PooledConnection",
  contains = "DBIConnection",
  slots = list(
    pool = "ANY",
    connection = "DBIConnection",
    id = "numeric"
  )
)


methods::setMethod(
  "initialize",
  "PooledConnection",
  function(.Object, connection, id, pool) { # nolint
    .Object@pool <- pool
    .Object@connection <- connection
    .Object@id <- id
    .Object
  }
)


#' @export
methods::setMethod(
  "dbDisconnect",
  "PooledConnection",
  function(conn) {
    conn@pool$release(conn)
    invisible(TRUE)
  })


#' @export
methods::setMethod(
  "dbBegin",
  "PooledConnection",
  function(conn) {
    DBI::dbBegin(conn@connection)
  })

#' @export
methods::setMethod(
  "dbCommit",
  "PooledConnection",
  function(conn) {
    DBI::dbCommit(conn@connection)
  })

#' @export
methods::setMethod(
  "dbRollback",
  "PooledConnection",
  function(conn) {
    DBI::dbRollback(conn@connection)
  })

#' @export
methods::setMethod(
  "dbSendQuery",
  "PooledConnection",
  function(conn, ...) {
    DBI::dbSendQuery(conn@connection, ...)
  })

#' @export
methods::setMethod(
  "dbGetQuery",
  c("PooledConnection", "character"),
  function(conn, statement) {
    DBI::dbGetQuery(conn@connection, statement)
  })

#' @export
methods::setMethod(
  "dbExistsTable",
  c("PooledConnection", "character"),
  function(conn, name, ...) {
    DBI::dbExistsTable(conn@connection, name)
  })

#' @export
methods::setMethod(
  "dbGetInfo",
  "PooledConnection",
  function(dbObj) {
    DBI::dbGetInfo(dbObj@connection)
  })

#' @export
methods::setMethod(
  "dbIsValid",
  "PooledConnection", function(dbObj) {
    DBI::dbIsValid(dbObj@connection)
  })

#' @export
methods::setMethod(
  "dbListFields",
  c("PooledConnection", "Id"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' @export
methods::setMethod(
  "dbListFields",
  c("PooledConnection", "character"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' @export
methods::setMethod(
  "dbListObjects",
  c("PooledConnection", "ANY"),
  function(conn, prefix = NULL, ...) {
    DBI::dbListObjects(conn@connection, prefix, ...)
  })

#' @export

methods::setMethod(
  "dbListTables", "PooledConnection", function(conn) {
    DBI::dbListTables(conn@connection)
  })

#' @export

methods::setMethod(
  "dbRemoveTable",
  c("PooledConnection", "character"),
  function(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE) {
    DBI::dbRemoveTable(conn@connection, name, ...,
                       temporary = temporary,
                       fail_if_missing = fail_if_missing)
  })


#' @export

methods::setMethod(
  "dbUnquoteIdentifier",
  c("PooledConnection", "SQL"), function(conn, x, ...) {
    DBI::dbUnquoteIdentifier(conn@connectiton, x, ...)
  })


#' @export

methods::setMethod(
  "dbQuoteIdentifier",
  c("PooledConnection", "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteIdentifier(conn@connection, x, ...)
  })

#' @export

methods::setMethod(
  "dbQuoteLiteral",
  c("PooledConnection", "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteLiteral(conn@connection, x, ...)
  })

#' @export

methods::setMethod(
  "dbExecute",
  c("PooledConnection", "ANY"),
  function(conn, statement,  ...) {
    DBI::dbExecute(conn@connection, statement, ...)
  })


#' @export
setMethod("show", "PooledConnection", function(object) {
  cat("<PooledConnection>  => ")
  show(object@connection)
})
