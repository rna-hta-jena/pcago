
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyjs)
source("pca.R")

shinyServer(function(input, output) {

  build.condition.ui <- TRUE

  output$text1 <- renderText({
    if(is.null(input$file)) {
      "Principal Component Analysis (PCA) is a technique to reduce the information dimensionality of a dataset consisting of a large number of interrelated variables obtained from a combinatorial experiment or from a well organized database by projection methods, in a way that minimizes the loss of information. Please upload your normalized read count data!"
    }
  })

  output$pca.plot <- renderPlot({
    
    counts.matrix <- read_file(input$file$datapath)
    
    if (!is.null(counts.matrix)) {

      conditions <- colnames(counts.matrix)
      
      # fill the conditions ui

      
      if (build.condition.ui) {      
        output$conditions <- renderUI({
          checkboxGroupInput('conditions', 'Select colour for conditions:', conditions)
        })
      }
      build.condition.ui <<- FALSE

      # build a color hash if the value of input$colourButton becomes out of date (is pressed)
      eventReactive(input$colourButton, {
        selected.color <- input$colour
        selected.conditions <- input$conditions
        update_color_hash(selected.color, selected.conditions)
        
      })
      
      pca(counts.matrix, input$dimensions, input$ntop_slider, input$pc)
    }
  })
  

  # builds a reactive expression that only invalidates 
  # when the value of input$goButton becomes out of date 
  # (i.e., when the button is pressed)
  ntext <- eventReactive(input$goButton, {
    input$n
  })
  
  output$nText <- renderText({
    ntext()
    
  })
  
  
  
  
})
