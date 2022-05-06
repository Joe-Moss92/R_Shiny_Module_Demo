######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: global.R
## Script purpose: Loads all libraries, loads all inputs stored externally and sources all modules for the app
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# Libraries ---------------------------------------------------------------

library(V8)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinycssloaders)
library(dashboardthemes)
library(waiter)
library(DT)
library(shinyFeedback)
library(tidyverse)


# Load inputs -------------------------------------------------------------

Background_fileName <- "Inputs/Background.txt"
# Background_txt <- readLines(Background_fileName, file.info(Background_fileName)$size, encoding = "UTF-8")
# Background_txt <- paste(Background_txt, collapse = "<br>")

Background_Pt2_fileName <- "Inputs/Background_Pt2.txt"
# Background_Pt2_txt <- readLines(Background_Pt2_fileName, file.info(Background_Pt2_fileName)$size, encoding = "UTF-8")
# Background_Pt2_txt <- paste(Background_Pt2_txt, collapse = "<br>")

Background_Pt3_fileName <- "Inputs/Background_Pt3.txt"
# Background_Pt3_txt <- readLines(Background_Pt3_fileName, file.info(Background_Pt3_fileName)$size, encoding = "UTF-8")
# Background_Pt3_txt <- paste(Background_Pt3_txt, collapse = "<br>")


# Source modules ----------------------------------------------------------

source("Additional Code/YHEC_Dashboard_Colour_SCheme.R", local = TRUE)
source("Additional Code/Module_Home.R")
source("Additional Code/Module_Background.R")
source("Additional Code/Module_NumericalWarning.R")
source("Additional Code/Module_SensSpec.R")
source("Additional Code/Module_DecisionTree.R")




