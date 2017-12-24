

shinyUI(tagList(useShinyjs(),
                
                navbarPage("Calgary Crime", theme = shinytheme("slate"), id = "calgaryCrimeLanding",selected = "Calgary Map",
                           
                           
                           tabPanel("Calgary Map", id = "basePage",
                                    
                                    sidebarLayout(fluid = TRUE,
                                                  
                                                  sidebarPanel(id = "calgaryMapSidebar" ,width = 2,
                                                               selectInput("communitySelect",  label = h4("Select Community"),choices = c(''),selected = ''),
                                                               selectInput("crimeSelect", label = h4("Select Crime Type"),choices = c(''),selected = ''),
                                                               selectInput("dateSelect", label = h4("Select Date"),choices = c(''),selected = ''),
                                                               
                                                               HTML('<hr style="display:block; margin-top:10px; margin-bottom:1px; border-top:2px solid #8c8b8b;">'),
                                                               
                                                               h4("Number of Cases in Area by Date"),
                                                               textOutput("casesByDate"),
                                                               
                                                               HTML('<hr style="display:block; margin-top:10px; margin-bottom:1px; border-top:2px solid #8c8b8b;">'),
                                                               
                                                               h4("Total Crime In Community"),
                                                               textOutput("totalCrimeByRegion"),
                                                               
                                                               HTML('<hr style="display:block; margin-top:10px; margin-bottom:1px; border-top:2px solid #8c8b8b;">'),
                                                               
                                                               h4("Total Crime Type Accross Calgary"),
                                                               textOutput("totalCrimeByRegionType")
                                                               
                                                  ),
                                                  
                                                  
                                                  
                                                  mainPanel(id="calgaryMapMainPannel",
                                                            wellPanel(leafletOutput("calgaryMap"))
                                                            
                                                  )#End of Main Panel
                                                  
                                    )
                                    
                                    
                                    
                                    
                           )#END OF TAB Calgary Map
                )#END OF NAVBARPAGE
)#END OF TAGLIST



)# END OF UI
