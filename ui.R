
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US census."),
      
      selectInput("var", label="Choose a variable to display", 
                  choices = list("Percent White", "Percent Black",
                                 "Percent Hispanic", "Percent Asian"), selected="Percent White"),
      
      
      sliderInput("range", label = "Range of interest:", min=0, max=100, value=c(0,100))
      
    ),
    
    mainPanel()
  )

))
