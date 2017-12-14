

shinyUI(tagList(useShinyjs(),
                
                navbarPage("Calgary Crime", theme = shinytheme("slate"), id = "calgaryCrimeLanding",selected = "Calgary Map",
                           
                           
                           tabPanel("Calgary Map", id = "basePage",
                                    
                                    sidebarLayout(fluid = TRUE,
                                      
                                      sidebarPanel(id = "calgaryMapSidebar" ,width = 2,
                                                   selectInput("communitySelect",  label = h4("Select Community"),choices = c(''),selected = ''),
                                                   selectInput("crimeSelect", label = h4("Select Crime Type"),choices = c(''),selected = ''),
                                                   dateInput("dateSelect",label = h4("Select Date"), value = NULL, min = NULL, max = NULL,
                                                              format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en"),
                                                   
                                                   
                                                   h4("Total Crime In Community"),
                                                   textOutput("totalCrimeByRegion"),
                                                   
                                                   h4("Total Crime Type"),
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
