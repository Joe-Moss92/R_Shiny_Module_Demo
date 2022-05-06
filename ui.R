######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: ui.R
## Script purpose: All the app UI elements are called in this script
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# Dashboard header --------------------------------------------------------

Header <- dashboardHeader(
  titleWidth = "50px",
  controlbarIcon = icon("info-circle")
) 


# Dashboard sidebar (left) ------------------------------------------------

Sidebar_Left <- dashboardSidebar(
  width = 250,
  
  ## Create pages ini the app
  
  sidebarMenu(id = "tabs",
              menuItem("Home", tabName = "Home", icon = icon("home")),
              
              menuItem("Background", tabName = "Background", icon = icon("book")),
              
              menuItem("Decision tree", tabName = "Inputs", icon = icon("tree"))
  )
)


# Dashboard sidebar (right) -----------------------------------------------

Sidebar_Right = dashboardControlbar(
  width = 300,
  skin = "light",
  controlbarMenu(
    id = "Right_Menu",
    controlbarItem(
      id = 2,
      icon = icon("globe"),
      title = "About YHEC",
      br(),
      uiOutput("YHEC_About")
    )
  )
)


# Dashboard body ----------------------------------------------------------

Body <- dashboardBody(
  
  # Allow app to display warning messages on inputs
  
  shinyFeedback::useShinyFeedback(),
  
  # Title to right of button
  
  tags$head(tags$style(HTML(
    '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
  tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"><strong> R Shiny Module Demo </strong> </span>\');
      })
     ')),
  
  
  # Set the colour scheme
  theme_YHEC,
  
  # Change colour of warning sign icon
  
  tags$style(".fa-exclamation-circle {color:#F89406}"),
  
  # Change colour of the Teal box header
  
  tags$style(HTML("
    .box.box-solid.box-teal>.box-header {
                background:#47aeea;
                }
                    .box-title{
                color: #ffffff;
                    }")),
  
  #### Start of app pages ####
  
  tabItems(
    tabItem(tabName = "Home",
            Home_UI("Home")
    ),
    tabItem(tabName = "Background",
            Background_UI("Background", "Background - Disclaimer", Background_fileName),
            Background_UI("Background_Pt2", "Background Part 2", Background_Pt2_fileName),
            Background_UI("Background_Pt3", "Background Part 3", Background_Pt3_fileName)
    ),
    tabItem(tabName = "Inputs",
            Decision_Tree_UI("DT_Inputs")
    )
  ),
  
  # Trigger the loading screen
  
  use_waiter(),
  waiter_show_on_load(color = "white",
                      tagList(
                        logo = tags$img(src="YHEC logo high.png", height = "180"),#
                        h3(""),
                        h1("Loading the demo app", style = "color:black;"),
                        h1(span("", tags$img(src="ajax-loader-bar.gif", height = "20", width = "20")))
                      )
  ))


# Call UI element ---------------------------------------------------------

ui <- dashboardPage(title = "R Shiny Module Demo", Header, Sidebar_Left, Body, Sidebar_Right)