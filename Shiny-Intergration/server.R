
shinyServer(function(input, output,session) {
  
  
  #build the base state
  setBaseSate(session)
  selectedValues <- reactiveValues(selectedCommunity = "",selectedCrime = "", selectedDate = "")
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
  # Monitors the Date select box
  observeEvent(input$dateSelect,ignoreNULL = TRUE,ignoreInit = TRUE,{
    
    if(input$dateSelect != ""){
      selectedValues$selectedDate <- input$dateSelect
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
      value <- selectedValues$selectedCrime
      
      output <-  CatTotal[Category == value,TotalByCategory]
      
    }else{
      output <- ""
    }
    
    output
  })
  
  output$casesByDate <- renderText({ 
    if(selectedValues$selectedDate != "" && selectedValues$selectedCommunity != ""){
      value <- as.Date(selectedValues$selectedDate)
      
      output <- CalgaryData[Community == selectedValues$selectedCommunity & Date == value & Category == selectedValues$selectedCrime,Cases]
      
    }else{
      output <- ""
    }
    
    output
  })
  
  
  
  
  
  
})
