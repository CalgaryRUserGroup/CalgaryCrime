# This file defines the user interface of the app. 

library(shiny)
library(shinydashboard)


shinyUI(
  # Everything visible on the app has to be an argument of shinyUI function.
  # Args:
  #   dashboardPage: 
  #   
  dashboardPage(
    # This is the only argument supplied to the shinyUI function. 
    # Args:
    #   skin: color of the app
    #   dashboardHeader: Header of the app. Stays same across all the pages
    #   dashboardSidebar: Sidebar of the app. Stays same across all the pages. Various interactions can be defined within it.
    #   dashboardBody: Main body of the app. Changes according to interactions
    
                skin = "purple",
                dashboardHeader(title = "Visualization of Calgary Crime Data", titleWidth = 300),
                dashboardSidebar(
                                label = h3("Calgary Crime Data"), 
                                 sidebarMenu(
                                   dateRangeInput("date", label = h3("Select Time Period"),start = "2016-01-01",
                                                  end = "2017-07-31",min = "2012-01-01",max = "2017-07-31"),
                                    menuItem("Crime Map", tabName = "mapCrime", icon = icon("map")),
                                    menuItem("Charts", tabName = "chartCrime", icon = icon("bar-chart-o")),
                                    menuItem("Raw Data", tabName = "rawData", icon = icon("table"))
                                 )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "mapCrime",
                            fluidRow(box(h4("Select time period from the menu on left. Map shows crime information by neighbourhood."),
                                         leafletOutput("mapCrimedf",width = "100%",height = 700),
                                         width = 12, height = 755)
                            )
                    ),
                    
                    # Drilling Activity chart tab content
                    tabItem(tabName = "chartCrime",
                            fluidRow(
                              box(h4("Select option to see crime trend"), hr(),
                                  radioButtons("radioDA", label = h3("Chart to plot: "),
                                               choices = list("Crime by Category" = 1, 
                                                              "Crime by Community" = 2
                                               ), 
                                               selected = 1, width = '90%'),width = 2,height = 800),
                              box(
                                plotOutput("chartCrime"),width = 10, height = 800)
                              )
                    ),
                    
                    # Crime Activity summary tab content
                    tabItem(tabName = "rawData",
                            h2('Summary of Crime'),
                            dataTableOutput('summaryCrimedf')
                    )
                    )
        )
))