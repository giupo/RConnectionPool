#' Pooled connection and methods.
#'
#' @keywords internal
#' @export
#' @import DBI methods

PooledConnection <- methods::setClass("PooledConnection",
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



#' Releases the connection to the pool
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbDisconnect",
  "PooledConnection",
  function(conn) {
    conn@pool$release(conn)
    invisible(TRUE)
  })


#' Delegate for dbBegin
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbBegin",
  "PooledConnection",
  function(conn) {
    DBI::dbBegin(conn@connection)
  })

#' Delegate for dbCommit
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbCommit",
  "PooledConnection",
  function(conn) {
    DBI::dbCommit(conn@connection)
  })

#' Delegate for dbRollback
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbRollback",
  "PooledConnection",
  function(conn) {
    DBI::dbRollback(conn@connection)
  })

#' Delegate for dbSendQuery
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @param conn conn PooledConnection object with DBIConnection slot
#' @param ... generic arguments passed to DBIConnectiton
#' @seealso DBI::dbSendQuery
#' @export
methods::setMethod(
  "dbSendQuery",
  "PooledConnection",
  function(conn, ...) {
    DBI::dbSendQuery(conn@connection, ...)
  })

#' Delegate for dbGetQuery
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbGetQuery",
  c("PooledConnection", "character"),
  function(conn, statement) {
    DBI::dbGetQuery(conn@connection, statement)
  })

#' Delegate for dbExistsTable
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbExistsTable",
  c("PooledConnection", "character"),
  function(conn, name, ...) {
    DBI::dbExistsTable(conn@connection, name)
  })

#' Delegate for dbGetInfo
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbGetInfo",
  "PooledConnection",
  function(dbObj) {
    DBI::dbGetInfo(dbObj@connection)
  })


#' Delegate for dbIsValid
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbIsValid",
  "PooledConnection", function(dbObj) {
    DBI::dbIsValid(dbObj@connection)
  })

#' Delegate for dbListFields
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbListFields",
  c("PooledConnection", "Id"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' Delegate for dbListFields
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbListFields",
  c("PooledConnection", "character"), function(conn, name, ...) {
    DBI::dbGetQuery(conn@connection, name, ...)
  })

#' Delegate for dbListObjects
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbListObjects",
  c("PooledConnection", "ANY"),
  function(conn, prefix = NULL, ...) {
    DBI::dbListObjects(conn@connection, prefix, ...)
  })


#' Delegate for dbListTables
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbListTables", "PooledConnection", function(conn) {
    DBI::dbListTables(conn@connection)
  })

#' Delegate for dbRemoveTable
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbRemoveTable",
  c("PooledConnection", "character"),
  function(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE) {
    DBI::dbRemoveTable(conn@connection, name, ...,
                       temporary = temporary,
                       fail_if_missing = fail_if_missing)
  })


#' Delegate for dbUnquoteIdentifier
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbUnquoteIdentifier",
  c("PooledConnection", "SQL"), function(conn, x, ...) {
    DBI::dbUnquoteIdentifier(conn@connectiton, x, ...)
  })


#' Delegate for dbQuoteIdentifier
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbQuoteIdentifier",
  c("PooledConnection", "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteIdentifier(conn@connection, x, ...)
  })

#' Delegate for dbQuoteLiteral
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbQuoteLiteral",
  c("PooledConnection", "ANY"),
  function(conn, x, ...) {
    DBI::dbQuoteLiteral(conn@connection, x, ...)
  })

#' Delegate for dbExecute
#'
#' Calls the underlaying methtod on the DBIConnection object
#'
#' @usage NULL
#' @export
methods::setMethod(
  "dbExecute",
  c("PooledConnection", "ANY"),
  function(conn, statement,  ...) {
    DBI::dbExecute(conn@connection, statement, ...)
  })


#' prints to stdout the repr for PooledConnecttion
#'
#' @usage NULL
#' @export
setMethod("show", "PooledConnection", function(object) {
  cat("<PooledConnection>  => ")
  show(object@connection)
})
