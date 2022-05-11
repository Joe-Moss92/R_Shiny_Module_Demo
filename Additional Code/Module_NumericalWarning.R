######################################################################################################################
## Project: R_Shiny_Module_Demo
## Script name: Module_NumericalWarning.R
## Script purpose: Create a shiny numericalInput element but uses the shinyFeedback package to apply warnings for invalid inputs
## Date: April 2022
## Author: Joe Moss
## Organisation: York Health Economics Consortium
######################################################################################################################


# UI Module ---------------------------------------------------------------

numberWarningInput <- function(id, Label, Value, Min = 0, Max = NA, Step = NA) {
  ns <- NS(id)
  tagList(
    useShinyFeedback(),
    numericInput(inputId = ns("warningInput"),
                 label = Label,
                 value = Value,
                 min = Min,
                 max = Max,
                 step = Step
    )
  )
}


# Server Module -----------------------------------------------------------

numberWarning <- function(input, output, session, Min = 0, Max = NULL) {
  
  Numeric_Output <- reactiveVal(0)
  
  Warning_id <- NULL # Work in progress to stop the same warning message appear multiple times
  
  observe({
    req(input$warningInput)
    if (input$warningInput < Min) {
      showFeedbackWarning(inputId = "warningInput", text = paste0("Value must be > ", Min), icon = icon("exclamation-circle"))
      
      if (!is.null(Warning_id))
        return()
      # Save the ID for removal later
      Warning_id <<- showNotification(HTML("<strong>Warning</strong><br>An invalid value has been entered into the model. The model results have not been updated in order to prevent errors. Model results should be interpreted with caution while this message is displayed."), duration = 0, type = "error", closeButton = FALSE)
    }
    else if(!is.null(Max)){
      if(input$warningInput > Max){
        showFeedbackWarning(inputId = "warningInput", text = paste0("Value must be < ", Max), icon = icon("exclamation-circle"))
        
        if (!is.null(Warning_id))
          return()
        # Save the ID for removal later
        Warning_id <<- showNotification(HTML("<strong>Warning</strong><br>An invalid value has been entered into the model. The model results have not been updated in order to prevent errors. Model results should be interpreted with caution while this message is displayed."), duration = 0, type = "error", closeButton = FALSE)
        
      }
      else{
        hideFeedback("warningInput")
        
        if (!is.null(Warning_id))
          removeNotification(Warning_id)
        Warning_id <<- NULL
        
      }
    }
    else {
      hideFeedback("warningInput")
      
      if (!is.null(Warning_id))
        removeNotification(Warning_id)
      Warning_id <<- NULL
      
    }
    
    Numeric_Output(input$warningInput)
    
  })
  
  # Return numerical input to other modules
  
  return(Numeric_Output)
  
}
