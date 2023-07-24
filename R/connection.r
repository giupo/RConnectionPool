
#' Pooled connection and methods.
#'
#' @keywords internal
#' @export
#' @include constants.r

setClass(PooledConnectionClassName,
  contains = "DBIConnection",
  slots = list(
    pool = "ANY",
    connection = "DBIConnection"
  )
)


methods::setMethod(
  "initialize",
  PooledConnectionClassName,
  function(.Object, connection, pool) { # nolint
    .Object@pool <- pool
    .Object@connection <- connection
    .Object
  }
)



#' @export
methods::setMethod(
  "dbDisconnect",
  PooledConnectionClassName,
  function(conn) {
    x@pool$release(x@connection)
    invisible(TRUE)
  })


#' @export
methods::setMethod(
  "dbBegin",
  PooledConnectionClassName,
  function(conn) {
    DBI::dbBegin(conn@connection)
  })

#' @export
methods::setMethod(
  "dbCommit",
  PooledConnectionClassName,
  function(conn) {
    DBI::dbCommit(conn@connection)
  })

#' @export
methods::setMethod(
  "dbRollback",
  PooledConnectionClassName,
  function(conn) {
    DBI::dbRollback(conn@connection)
  })

#' @export
methods::setMethod(
  "dbSendQuery",
  PooledConnectionClassName,
  function(conn, ...) {
    DBI::dbSendQuery(conn@connection, ...)
  })

#' @export
methods::setMethod(
  "dbGetQuery",
  c(PooledConnectionClassName, "character"),
  function(conn, statement) {
    DBI::dbGetQuery(conn@connection, statement)
  })

#' @export
methods::setMethod(
  "dbExistsTable",
  c(PooledConnectionClassName, "character"),
  function(conn, name, ...) {
    DBI::dbExistsTable(conn@connection, name)
  })

#' @export
methods::setMethod(
  "dbGetInfo",
  PooledConnectionClassName,
  function(dbObj) {
    DBI::dbGetInfo(dbObj@connection)
  })

#' @export
methods::setMethod(
  "dbIsValid",
  PooledConnectionClassName, function(dbObj) {
    DBI::dbIsValid(dbObj@connection)
  })

#' @export
methods::setMethod(
  "dbListFields",
  c(PooledConnectionClassName, "Id"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' @export
methods::setMethod(
  "dbListFields",
  c(PooledConnectionClassName, "character"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' @export
methods::setMethod(
  "dbListObjects",
  c(PooledConnectionClassName, "ANY"),
  function(conn, prefix = NULL, ...) {
    DBI::dbListObjects(conn@connection, prefix, ...)
  })

#' @export

methods::setMethod(
  "dbListTables", PooledConnectionClassName, function(conn) {
    DBI::dbListTables(conn@connection)
  })

#' @export

methods::setMethod(
  "dbRemoveTable",
  c(PooledConnectionClassName, "character"),
  function(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE) {
    DBI::dbRemoveTable(conn@connection, name, ...,
                       temporary = temporary,
                       fail_if_missing = fail_if_missing)
  })


#' @export

methods::setMethod(
  "dbUnquoteIdentifier",
  c(PooledConnectionClassName, "SQL"), function(conn, x, ...) {
    DBI::dbUnquoteIdentifier(conn@connectiton, x, ...)
  })


#' @export

methods::setMethod(
  "dbQuoteIdentifier",
  c(PooledConnectionClassName, "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteIdentifier(conn@connection, x, ...)
  })

#' @export

methods::setMethod(
  "dbQuoteLiteral",
  c(PooledConnectionClassName, "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteLiteral(conn@connection, x, ...)
  })

#' @export

methods::setMethod(
  "dbExecute",
  c(PooledConnectionClassName, "ANY"),
  function(conn, statement,  ...) {
    DBI::dbExecute(conn@connection, statement, ...)
  })


#' @export
setMethod("show", PooledConnectionClassName, function(object) {
  cat("<PooledConnection>  => ")
  show(object@connection)
})
