######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: server.R
## Script purpose: All the app server elements are called in this script
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# Call server -------------------------------------------------------------

server <- function(input, output, session) {
  
  # YHEC about tab
  
  url <- a("website.", href="https://www.yhec.co.uk/", target="_blank")
  output$YHEC_About <- renderUI({
    tagList("For more information about YHEC and other services that are available, please visit their ", url)
  })
  

# Call modules ------------------------------------------------------------

  #### Decision tree ####
  
  callModule(Decision_Tree_Server, id = "DT_Inputs")
  
  #### Hide loading screen ####
  
  Sys.sleep(3) # Included to show the loading screen - otherwise it loads too quickly
  
  waiter_hide() # This should always be the last line
  
}
