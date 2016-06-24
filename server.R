
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("pca.R")

shinyServer(function(input, output) {

  output$text1 <- renderText({
    if(is.null(input$file)) {
      "Principal Component Analysis (PCA) is a technique to reduce the information dimensionality of a dataset consisting of a large number of interrelated variables obtained from a combinatorial experiment or from a well organized database by projection methods, in a way that minimizes the loss of information. Please upload your normalized read count data!"
    }
  })
  
  output$pca.plot <- renderPlot({
    counts.matrix <- read_file(input$file$datapath)
    conditions <- colnames(counts.matrix)
    if (!is.null(counts.matrix)) {
      pca(counts.matrix, input$dimensions, input$ntop_slider, input$pc)
    }
    
    #output$conditions <- renderUI({
    #  selectInput('conditions', 'Conditions:', conditions)
    #})
  })
  



})
