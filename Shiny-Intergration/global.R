require(shiny, quietly = T)
require(DT, quietly = T)
require(shinythemes, quietly = T)
require(shinyjs, quietly = T)
require(leaflet, quietly = T)
require(data.table, quietly = T)
require(compiler, quietly = T)


if (!exists("CalgaryCrime")) {
  source("LoadData.R")
}



setBaseSate <- function(session = NULL) {
  if (is.null(session)) {
    stop("Session is null in set base state")
  } else{
    updateSelectInput(session,
                      "communitySelect",
                      choices = community,
                      selected = "")
    updateSelectInput(session,
                      "crimeSelect",
                      choices = crimeTypes,
                      selected = "")
    
    updateDateInput(session,"dateSelect", min = min(CalgaryData$Date),max = max(CalgaryData$Date),value = min(CalgaryData$Date))
  }
  
  
}

buildMap <- function() {
  map <-  leaflet(boundries) %>%
    setView(lng = 	-114.062019,
            lat = 51.044270,
            zoom = 10)  %>%
    addTiles() %>%
    addPolygons(
      color = "#444444",
      weight = 1,
      smoothFactor = 0.5,
      opacity = 1.0,
      fillOpacity = 0.5,
      highlightOptions = highlightOptions(
        color = "white",
        weight = 2,
        bringToFront = TRUE
      )
    )
  
  return(map)
}





