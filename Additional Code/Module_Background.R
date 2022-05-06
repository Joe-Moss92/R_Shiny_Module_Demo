######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: Module_Background.R
## Script purpose: Create the background page UI module
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# UI Module ---------------------------------------------------------------

Background_UI <- function(id, title, txt_file) {
  ns = NS(id)
  
  Background_txt <- readLines(txt_file, file.info(txt_file)$size, encoding = "UTF-8")
  Background_txt <- paste(Background_txt, collapse = "<br>")
  
  tagList(
    shinydashboard::box(
      title = title, status = "primary", solidHeader = TRUE, width = "100%" , height = "100%",collapsible = TRUE,
      HTML(Background_txt)
    )
  )
}
