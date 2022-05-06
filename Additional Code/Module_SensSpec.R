######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: Module_SensSpec.R
## Script purpose: Create the Sens and Spec inputs for decision tree
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# UI Module ---------------------------------------------------------------

Sens_Spec_UI <- function(id) {
  ns = NS(id)
  tagList(fluidRow(
    column(width = 4, offset = 2,
           uiOutput(ns("Sensitivity_Output")),
           uiOutput(ns("Sensitivity_SE_Output"))
    ),
    column(width = 4, offset = 0,
           uiOutput(ns("Specificity_Output")),
           uiOutput(ns("Specificity_SE_Output"))
    )
  )
  )
}

# Server

Sens_Spec_Server <- function(input, output, session, Sens, Spec, Sens_SE, Spec_SE) {
  
  ns <- session$ns
  
  # Create a vector to update when inputs change
  
  Sens_Spec_Info <- reactiveVal(0)
  
  output$Sensitivity_Output <- renderUI({
    ns <- session$ns
    knobInput(ns("Sensitivity"), "Sensitivity", value =Sens, min = 0, max = 100, displayPrevious = TRUE, lineCap = "round", immediate = FALSE)
  })
  
  output$Sensitivity_SE_Output <- renderUI({
    ns <- session$ns
    numberWarningInput(ns("Sensitivity_SE"), Label = "Standard Error", Value = Sens_SE, Min = 0, Max = 100, Step = 0.1)
  })
  
  outputOptions(output, "Sensitivity_Output", suspendWhenHidden = FALSE)
  outputOptions(output, "Sensitivity_SE_Output", suspendWhenHidden = FALSE)
  
  output$Specificity_Output <- renderUI({
    ns <- session$ns
    knobInput(ns("Specificity"), "Specificity", value = Spec, min = 0, max = 100, displayPrevious = TRUE, lineCap = "round", immediate = FALSE)
  })
  
  output$Specificity_SE_Output <- renderUI({
    ns <- session$ns
    numberWarningInput(ns("Specificity_SE"), Label = "Standard Error", Value = Spec_SE, Min = 0, Max = 100, Step = 0.1)
  })
  
  outputOptions(output, "Specificity_Output", suspendWhenHidden = FALSE)
  outputOptions(output, "Specificity_SE_Output", suspendWhenHidden = FALSE)
  
  # Return SE outputs
  
  Sensitivity_SE_Out <- callModule(numberWarning, id = "Sensitivity_SE", Min = 0, Max = 100)
  Specificity_SE_Out <- callModule(numberWarning, id = "Specificity_SE", Min = 0, Max = 100)
  
  observe({
    
    Sens_Spec_Info(list(Sensitivity = input$Sensitivity,
                        Specificity = input$Specificity,
                        Sensitivity_SE = Sensitivity_SE_Out(),
                        Specificity_SE = Specificity_SE_Out()
    )
    )
  })
  
  return(Sens_Spec_Info)
  
}