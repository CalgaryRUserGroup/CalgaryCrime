
shinyServer(function(input, output,session) {
  
  
  #build the base state
  setBaseSate(session)
  selectedValues <- reactiveValues(selectedCommunity = "",selectedCrime = "")
  if(!exists("calgaryMap")){
    calgaryMap = buildMap()
    mapProxy <- leafletProxy("calgaryMap")
  }
  
  
  # Monitors the community select box
  observeEvent(input$communitySelect,ignoreNULL = TRUE,ignoreInit = TRUE,{
    
    if(input$communitySelect != ""){
      selectedValues$selectedCommunity <- input$communitySelect
    }
    
    
  })
  # Monitors the crime select box
  observeEvent(input$crimeSelect,ignoreNULL = TRUE,ignoreInit = TRUE,{
    
    if(input$crimeSelect != ""){
      selectedValues$selectedCrime <- input$crimeSelect
    }
    
  })
  
 #Renders the map
   output$calgaryMap <- renderLeaflet({
    calgaryMap
  })
   
  output$totalCrimeByRegion <- renderText({
    if(selectedValues$selectedCommunity != ""){
      value <- selectedValues$selectedCommunity
      
      output <-  CasesTotal[Community == value,TotalByCommunity]
      
    }else{
     output <- ""
    }
    
    output
  })
  
  output$totalCrimeByRegionType <- renderText({
    if(selectedValues$selectedCrime != ""){
      value <- selectedValues$selectedCommunity
      
      output <-  CasesTotal[Community == value,TotalByCommunity]
      
    }else{
      output <- ""
    }
    
    output
  }) 
  
  
})
