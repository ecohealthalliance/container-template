#' This function is an example of what a function could like in a targets workflow.
#'
#'
#' @title create_exampletarget

#' @param x Logical. If TRUE, value of output is changed.
#'
#' @return
#' @author Collin Schwantes
#' @export
create_example_target <- function(x= FALSE) {
  output <- "Example Target"
  
  if(x){
    output <- "Some text"
  }
  
  return(output)

}
