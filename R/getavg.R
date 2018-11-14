#' Returns the average of a given numeric vector.
#'
#' @param v A vector of numerics
#'
#' @return The average of v
#'
#' @examples
#' getavg(c(1,3)) # returns (1+3)/2 = 2
#' getavg(c(1,2,3)) # returns (1+2+3)/3 = 2
getavg <- function (v) {
  return (mean(v))
}
