######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: Module_Home.R
## Script purpose: Create the home page UI module
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# UI Module ---------------------------------------------------------------

Home_UI <- function(id) {
  ns = NS(id)
  tagList(
    div(
      fluidRow(column(12, align = "center", h1(HTML("<strong>R Shiny Module Demo App</strong>")))),
      fluidRow(column(12, align = "center", h4("Dr Joe Moss"))),
      br(),
      fluidRow(column(12, align = "center", h4("R for HTA"))),
      fluidRow(column(12, align = "center", h4("20th May 2022"))),
      br(),br(),
      fluidRow(column(12, align = "center", img(src = "R_For_HTA_Logo.png", width = "20%")))
    )
  )
}
