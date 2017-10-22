#vector of required packages
require.packages <- c('readr', 'dplyr', 'tidyr', 'lubridate', 'ggplot2', 'dygraphs', 'rgdal', 'leaflet')

#load all the packages using lapply
lapply(require.packages, require, character.only = TRUE)


######################################################################################################
### Load data, clean and produce various charts

#load community crime by category csv directly from the github repository
CalgaryCrime <- read_csv("data/crime2017.csv", na = c("", "NA"), trim_ws = TRUE) # replace blank cells and NA strings with NA character type

#load community census results csv directly from the github repository
CalgaryCensus <- read_csv("data/census2017.csv", na = c("", "NA"), trim_ws = TRUE) # replace blank cells and NA strings with NA character type

#Just two place holders to keep the raw data frames so that I dont have to read them again and again
CalgaryCrime.raw <-CalgaryCrime
CalgaryCensus.raw <- CalgaryCensus

#replace all na with 0
CalgaryCrime[is.na(CalgaryCrime)] <- 0 # add zeroes to NA cells
CalgaryCensus[is.na(CalgaryCensus)] <- 0 # add zeroes to NA cells

# Last line of CalgaryCensus dataframe looks like a grand total so I will remove that line
CalgaryCensus <-CalgaryCensus[-dim(CalgaryCensus)[1],]

# I got an encoding error so I will encode both the dataframes into UTF-8. This might be a windows specific issue
CalgaryCrime <- tbl_df(apply(CalgaryCrime, 2, iconv, c('UTF-8')))
CalgaryCensus <- tbl_df(apply(CalgaryCensus, 2, iconv, c('UTF-8')))

# I will also make sure that all the columns are of the correct data type. This can be looked at by using str(dataframe)
# and making sure all the datatypes are what you want. I will convert the following into factors. This needs to be done
# because encoding function above changed all the column data types to chr
CalgaryCensus$Community <- as.factor(CalgaryCensus$Community)
CalgaryCrime$Category <- as.factor(CalgaryCrime$Category)
CalgaryCrime$Community <- as.factor(CalgaryCrime$Community)

CalgaryCrime<- cbind(CalgaryCrime[c(1:2)],apply(CalgaryCrime[c(3:dim(CalgaryCrime)[2])], 2, as.numeric))
CalgaryCensus<- cbind(CalgaryCensus[c(1)],apply(CalgaryCensus[c(2:dim(CalgaryCensus)[2])], 2, as.numeric))


#i will skip this line so that the code works when sept to dec 2017 data becomes available.
# TODO - remember to make adjustments for this in the following code
#CalgaryCrime <- select(CalgaryCrime, -SEP:-DEC) # remove unused columns


CalgaryCrimeTidy <- CalgaryCrime %>% gather(Date, Cases, 3:70) # move data columns into one column
CalgaryCrimeTidy$Date <- as.Date(CalgaryCrimeTidy$Date, format = "%m/%d/%Y") # convert Date column to date format


CalgaryCensus$AvgPop <- rowMeans(subset(CalgaryCensus, select = c(2:6))) # calc 5 yr pop average 
CalgaryData <- left_join(CalgaryCrimeTidy, CalgaryCensus, by = "Community") # add pop data to crime data


CalgaryData$Community <- as.factor(CalgaryData$Community) # we joined by column with different factors so R changes it to chr

####Plot total crime stats by category 
# Variable names have been changed from original CalgaryCrime.Rmd file
# CatTotal ---> Crime.Cat.Total
Crime.Cat.Total <-   CalgaryData %>% 
  group_by(Category) %>% 
  summarise(CrimeCategoryTotal = sum(Cases)) %>%
  arrange(desc(CrimeCategoryTotal))

Crime.Cat.Total.Plot <- ggplot(Crime.Cat.Total, aes(x=Category,y=CrimeCategoryTotal)) +
  geom_bar(stat="identity", fill="blue") +
  theme(axis.text.x = element_text(angle=45, hjust=1, size=10))
Crime.Cat.Total.Plot


#### Plot total crime stats by community 
# Variable names have been changed from original CalgaryCrime.Rmd file
# CasesTotal ---> Crime.Community.Total, TotalsByCommunity ---> CrimeCommunityTotal
Crime.Community.Total <-   CalgaryData %>% 
  group_by(Community) %>% 
  summarise(CrimeCommunityTotal = sum(Cases)) %>%
  arrange(desc(CrimeCommunityTotal))

Crime.Community.Total.Plot <- ggplot(Crime.Community.Total[1:25,], aes(x=reorder(Community, CrimeCommunityTotal), y=CrimeCommunityTotal)) +
  geom_bar(stat="identity", fill="red") +
  theme(axis.text.y = element_text(size=12)) +
  geom_text(aes(label=CrimeCommunityTotal), hjust=1.2, size=5, colour="white") +
  coord_flip()
Crime.Community.Total.Plot


#### Normalize total crime stats by population 
Crime.Community.Total <- left_join(Crime.Community.Total, CalgaryCensus, by = "Community")
Crime.Community.Total$Per100 <- Crime.Community.Total$CrimeCommunityTotal / Crime.Community.Total$AvgPop * 100 #results in zero division

# Outliers ---> Crime.Community.Total.Outliers
Crime.Community.Total.Outliers <- Crime.Community.Total %>% 
  filter(!complete.cases(Per100) | Per100 =="Inf" | Per100 > 500)

# CasesTotalClean ---> Crime.Community.Total.Clean
Crime.Community.Total.Clean <-  Crime.Community.Total %>% 
  filter(complete.cases(Per100) & Per100 != "Inf" & Per100 < 500 & AvgPop > 500) %>%
  arrange(desc(Per100))
print(Crime.Community.Total.Clean)

Crime.Community.Total.Clean.Plot <- ggplot(Crime.Community.Total.Clean[1:25,], aes(x=reorder(Community, Per100), y=Per100)) +
  geom_bar(stat="identity", fill = "darkblue") +
  theme(axis.text.y = element_text(size=12)) +
  geom_text(aes(label= round(Per100)), hjust=1.2, size=5, colour="white") +
  geom_text(aes(label=round(AvgPop)), hjust=-0.2) +
  coord_flip()
Crime.Community.Total.Clean.Plot


## Community investigation
# Compare the total crime counts, by category, of one community to another community. 
# The mean crime counts are also included. To compare other communities, just change the 
# values for Comm1 and Comm2 (make sure the communities are in upper case).
CalgaryData$Date <- as.Date(CalgaryData$Date, format = "%m/%d/%Y")

# TODO - move this part to server.ui to provide interactivity on the website
communities.list <- levels(CalgaryData$Community)

Comm1 <- "BRIDGELAND/RIVERSIDE" # enter 1st community
Comm2 <- "BANFF TRAIL" # enter 2nd community

CommCat <-  CalgaryData %>% 
  filter(Community == Comm1) %>%
  group_by(Category, year(Date)) %>%
  summarise(sum(Cases))

CommCat2 <-  CalgaryData %>% 
  filter(Community == Comm2) %>%
  group_by(Category, year(Date)) %>%
  summarise(sum(Cases))

MeanCat <-  CalgaryData %>% 
  filter(complete.cases(AvgPop) & AvgPop != "Inf" & AvgPop > 500) %>%
  group_by(Category, year(Date)) %>%
  summarise(mean(Cases))
MeanCat$`mean(Cases)` <- MeanCat$`mean(Cases)` * 12 # convert data from monthly to yearly averages

TotalCat <- merge(CommCat ,CommCat2,by=c("Category","year(Date)")) # merge Community 1 and 2 together
TotalCat <- merge(TotalCat, MeanCat, by=c("Category","year(Date)")) # merge mean data

CommPlot <- ggplot(TotalCat, aes(x=`year(Date)`)) + 
  geom_line(aes(y=`mean(Cases)`, colour = "Average")) +
  geom_line(aes(y=`sum(Cases).x`, colour = Comm1)) +
  geom_line(aes(y=`sum(Cases).y`, colour = Comm2)) +
  geom_point(aes(y=`mean(Cases)`)) +
  geom_point(aes(y=`sum(Cases).x`)) +
  geom_point(aes(y=`sum(Cases).y`)) +
  facet_wrap(~ Category, ncol=2 ) +
  scale_y_log10() +
  scale_colour_manual(values=c("black", "red", "blue")) +
  theme_bw() + 
  theme(legend.position="top", legend.text=element_text(size=20),
        strip.text = element_text(face="bold", size=rel(1.5)),
        strip.background = element_rect(fill="lightblue", colour="black", size=1))
CommPlot



### Interactive map  
#Load the Calgary communities shapefile and merge the crime stats to the shape file dataframe.
shapefile.folder <- "./data/community_boundaries"
cb <- readOGR(dsn=shapefile.folder)


# merge crime stats to shapefile dataframe (cb@data)
colnames(cb@data)[5] <- "Community" # rename column to match crime stats dataframe
cb.df <- left_join(cb@data, Crime.Community.Total, by = "Community") # add pop data to crime data



# make map labels
labels <-   sprintf("<strong>%s</strong><br/> Community structure: %s<br/>
                    Class: %s <br/> Population: %s <br/>
                    Total crime: %s, Per 100 people: %s",
                    cb.df$Community, cb@data$comm_struc, 
                    cb@data$class, cb.df$AvgPop, 
                    cb.df$CrimeCommunityTotal, round(cb.df$Per100)) %>%
  lapply(htmltools::HTML)

# code to generate cloropleth (heat) colour palette
bins <- c(0, 50, 100, 200, 300, 400, 500)
pal <- colorBin("Reds", domain = round(cb.df$Per100), bins = bins)

# generate map using leaflet
Crime.Map <- leaflet(width="100%", height = 1000)  %>% 
  addTiles() %>% 
  setView(lng = -114.062019, lat=51.044270,zoom=11) %>% 
  addPolygons(data=cb,weight=2,col = 'blue', fillOpacity = 0) %>%
  addPolygons(data = cb, fillColor = ~pal(round(cb.df$Per100)),
              weight = 2,
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 10,
                color = "#666",
                dashArray = "",
                fillOpacity = 0,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto"))

