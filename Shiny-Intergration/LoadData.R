#Fix for rjava issue in linux
#https://stackoverflow.com/questions/28462302/libjvm-so-cannot-open-shared-object-file-no-such-file-or-directory

library(xlsx)
library(dplyr)
library(tidyr)
library(readr)

xlsx_dir <- "Shiny-Intergration/RawData"

list_file_xls <- list.files(path = getwd(), pattern = "xls$",recursive = TRUE,full.names = TRUE)
list_file_csv <- list.files(path = paste0(getwd(),'/','Shiny-Intergration'), pattern = "csv$",recursive = TRUE,full.names = TRUE)

#for now just grab the first item in the list
#but this could be migrated to grab the latest

#this is really slow with na.strings
#https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf
#might be a valid replacement
CalgaryCrime <- read.xlsx(file = list_file_xls [1],sheetIndex = 2,startRow = 2,na.strings = c(""), stringsAsFactors = FALSE )
colnames(CalgaryCrime)[1:2] <- c("Category","Community")
CalgaryCrime[is.na(CalgaryCrime)] <- 0

#run a for loop across the columnsize to fix the names 
names <- colnames(CalgaryCrime)
names <- names[3:length(names)]

intialYear <- 2012
j <- 1


for (i in 1:length(names)) {
  
  
    
    if(j < 10){
      names[i] <-  paste0('0',j,'/01/',intialYear)
      
    }else{
      names[i]  <-   paste0(j,'/01/',intialYear)
    }
    
    if(j == 12){
      intialYear <- intialYear + 1
      j <- 1
    }else{
      j <- (j +1)
    }
    
  
  
  
}

colnames(CalgaryCrime)[3:ncol(CalgaryCrime)] <- names

#Applying data minp based on the work of Marc Boulet & Calgary R User Group

CalgaryCrime <- select(CalgaryCrime, -71:-75) # remove unused columns
CalgaryCrimeTidy <- CalgaryCrime %>% gather(Date, Cases, 3:70) # move data columns into one column
CalgaryCrimeTidy$Date <- as.Date(CalgaryCrimeTidy$Date, format = "%m/%d/%Y") # convert Date column to date format

CalgaryCensus <- read_csv(list_file_csv[1])
CalgaryCensus$AvgPop <- rowMeans(subset(CalgaryCensus, select = c(2:6))) # calc 5 yr pop average 
CalgaryData <- left_join(CalgaryCrimeTidy, CalgaryCensus, by = "Community") # add pop data to crime data

CatTotal <-   CalgaryData %>% 
  group_by(Category) %>% 
  summarise(TotalByCategory = sum(Cases)) %>%
  arrange(desc(TotalByCategory))

CasesTotal <-   CalgaryData %>% 
  group_by(Community) %>% 
  summarise(TotalByCommunity = sum(Cases)) %>%
  arrange(desc(TotalByCommunity))







