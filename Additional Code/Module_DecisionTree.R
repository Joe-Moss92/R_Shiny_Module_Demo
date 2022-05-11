######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: Module_DecisionTree.R
## Script purpose: Create the decision tree page UI and server logic
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# Decision Tree function --------------------------------------------------

# Create a function that calculates the number of patients in each health state of the decision tree

Decision_Tree_Func <- function(Population, Prevalence, Sensitivity, Specificity) {
  
  # Calc populations
  
  True_Pos <- Population*Sensitivity*Prevalence
  False_Pos <- Population*(1-Specificity)*(1-Prevalence)
  
  True_Neg <- Population*(1-Prevalence)*Specificity
  False_Neg <- Population*Prevalence*(1-Sensitivity)
  
  # Health state calcs
  
  Healthy <- True_Neg # People correctly identified as no disease plus those identified as a false positive but refuse treatment
  Untreated <- False_Neg
  Treated <- True_Pos
  Treated_Incorrectly <-False_Pos
  
  State_Populations <- list(Healthy = Healthy, Untreated = Untreated, Treated = Treated, Treated_Incorrectly = Treated_Incorrectly)
  
  return(State_Populations)
}


# UI Module ---------------------------------------------------------------

Decision_Tree_UI <- function(id) {
  ns = NS(id)
  tagList(
    h3(HTML("<strong>Decision Tree</strong>")),
    br(),
    fluidRow(
      column(6,
             box(title = HTML("<strong>Patient Population</strong>"), status = "teal",width = 12, solidHeader = TRUE, icon = icon("gears"),
                 numberWarningInput(ns("Pop_Size"), "Population size", 1000, Min = 0),
                 numberWarningInput(ns("Disease_Prev"), "Disease Prevalence (%)", 14, Min = 0, Max = 100)
                 )
      )
      ),
    fluidRow(
      column(6,
             box(title = HTML("<strong>Test A</strong>"), status = "teal",width = 12, solidHeader = TRUE, icon = icon("circle-notch"),
                 Sens_Spec_UI(ns("Test_A"))
                 )
      ),
      column(6,
             box(title = HTML("<strong>Test B</strong>"), status = "teal",width = 12, solidHeader = TRUE, icon = icon("circle-notch"),
                 Sens_Spec_UI(ns("Test_B"))
                 )
      )
    ),
    fluidRow(
      column(12,
             box(title = HTML("<strong>Decision Tree Results</strong>"), status = "teal",width = 12, solidHeader = TRUE, icon = icon("table"),
                 withSpinner(DT::dataTableOutput(ns("Patient_Summary"), height  ="100px"), type = 1, color = "#47aeea"))
      )
    )
  )
}


# Server Module -----------------------------------------------------------

Decision_Tree_Server <- function(input, output, session) {
  
  #### Population info ####
  
  Output_PopSize <- callModule(numberWarning, id = "Pop_Size")
  Output_DisPrev <- callModule(numberWarning, id = "Disease_Prev", Max = 100)
  
  
  #### Sens & Spec ####
  
  Output_DT_TstA <- callModule(Sens_Spec_Server, id = "Test_A", Sens = 91, Spec = 95, Sens_SE = 3, Spec_SE =1)
  Output_DT_TstB <- callModule(Sens_Spec_Server, id = "Test_B", Sens = 89, Spec = 98, Sens_SE = 1, Spec_SE =3)
  
  #### Decision tree ####
  
  # Set default values as NULL
  
  Decision_Tree_Results <- reactiveValues(
    Test_A = NULL,
    Test_B = NULL
  )
  
  # A series of reactive functions to ensure valid data - if invalid data present, results do no update
  
  TstA_Results_Updater <- reactive({
    req(Output_PopSize() >= 0) # Must note be a negative population size
    req(Output_DisPrev() >= 0 & Output_DisPrev() <= 100) # prevalence must be between 0 and 100%
    Decision_Tree_Results$Test_A <- Decision_Tree_Func(Output_PopSize(),
                                                                    Output_DisPrev()/100,
                                                                    Output_DT_TstA()[["Sensitivity"]]/100,
                                                                    Output_DT_TstA()[["Specificity"]]/100)
  })
  
  TstB_Results_Updater <- reactive({
    req(Output_PopSize() >= 0) # Must note be a negative population size
    req(Output_DisPrev() >= 0 & Output_DisPrev() <= 100) # prevalence must be between 0 and 100%
    Decision_Tree_Results$Test_B <- Decision_Tree_Func(Output_PopSize(),
                                                                    Output_DisPrev()/100,
                                                                    Output_DT_TstB()[["Sensitivity"]]/100,
                                                                    Output_DT_TstB()[["Specificity"]]/100)
  })
  
  ## Update reactive values
  
  observe({
    TstA_Results_Updater()
    TstB_Results_Updater()
  })
  
  # Combine the decision tree results into a data frame (note the Map function merges the results into a single list)
  
  Decision_Tree_Results_Comb <- reactive({
    if(is.null(Decision_Tree_Results$Test_A)){return(NULL)}
    else{
      Map(c,Decision_Tree_Results$Test_A,
          Decision_Tree_Results$Test_B) 
    }
  })
  
  ## Create result table
  
  output$Patient_Summary = DT::renderDataTable({
    
    req(Decision_Tree_Results_Comb(), cancelOutput = TRUE)
    req(nrow(as.data.frame(Decision_Tree_Results_Comb())) == 2, cancelOutput = TRUE)
    
    # First, convert the list of results into a data frame, add the screening names and format the numbers
    # Note, this means the order of the results is important.
    table_data <- as.data.frame(Decision_Tree_Results_Comb())
    table_data <- table_data %>% 
      mutate(across(where(is.numeric), round, 0)) %>% 
      mutate(across(where(is.numeric), formatC, format = "d", big.mark = ",")) %>% 
      mutate(X = c("Test A", "Test B"), .before = "Healthy")
    
    DT::datatable(data = table_data,
                  colnames = c("Healthy", "Untreated", "Treated", "Incorrectly Treated"),
                  rownames = FALSE,
                  class = "row-border compact",
                  options = list(
                    columnDefs = list(list(className = 'dt-center', targets = "_all")), dom='t', ordering=F,
                    scrollX = TRUE)) %>%
      formatStyle(column = 'X', fontWeight = 'bold', textAlign = 'left')
    
  })
  
}
