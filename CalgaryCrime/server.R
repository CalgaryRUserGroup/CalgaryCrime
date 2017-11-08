#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

shinyServer(function(input, output){
  
  ############################# VALUE BOXES ###########################################
  #output$NewWellsDrilledDA <- renderValueBox({
  #  drilling_activitySub <- subset(drilling_activity, Date > as.Date(input$date[1],"%y-%m-%d") 
  #                                 & Date < as.Date(input$date[2],"%y-%m-%d"))
  #  
  #  valueBox(
  #    dim(drilling_activitySub)[1], "Wells Drilled During This Period" ,icon = icon("download"),
  #    color = "purple"
  #  )
  #})
  
  
  ############################# CRIME CHARTS ###########################################
  
  output$chartCrime <- renderPlot({
    #Crime.Community.Total.Clean.Plot
    if (input$radioDA == 1) {
       Crime.Cat.Total.Plot
    } else if (input$radioDA == 2) {
       Crime.Community.Total.Plot    
    } 
  })
  
  ############################# MAP ###########################################
  output$mapCrimedf <- renderLeaflet({
    Crime.Map
  })

  ############################# DATA TABLE ###########################################
  output$summaryCrimedf = renderDataTable({
    Crime.Community.Total.Clean
  })
})
