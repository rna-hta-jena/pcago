
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  titlePanel("PCA-GO"),
  
  sidebarLayout(
    sidebarPanel(
      
      fileInput('file', 'File upload'),
      
      radioButtons('dimensions', 'Dimensions', choices = list('2D','3D'), selected = '2D'),
      
      checkboxGroupInput('pc', 'Principal components', choices = list('PC1' = 1,'PC2' = 2,'PC3' = 3,'PC4' = 4), selected = list(1,2)),
      
      checkboxInput('breakdown', 'Show breakdown'),
      
      sliderInput("ntop_slider", label = "Number of genes:", min=10, max=5000, value=500),
      
      textInput('ntop', ''),
      
      actionButton('run', 'Slideshow'),
      
      helpText('Customize your PCA plot:'),
      
      uiOutput('conditions')
      
    ),
    
    mainPanel(
      
      textOutput("text1"),
      
      plotOutput("pca.plot")
      
    )
  )

))
