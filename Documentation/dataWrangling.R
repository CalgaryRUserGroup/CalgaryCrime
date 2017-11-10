#pull data from csv

#Method #1 file.choose()
#This function is the same as navigating to Tools -> Import Dataset
# From Text File in RStudio. file.choose() interfaces directly with your OS
#File paths are only case sensitive if your OS is case sensitive like Linux


file_path  <- file.choose()

#Now run the file and select data. This loads a file path not actual file 
#After selecting, file path is loaded into environment 

typeof(file_path)
file_path 

#Notice windows style filepaths are escaped, alternatively can use / if typing path manually
#Now that we have the file path, we can read it into a data frame using variety of methods

#Method 1: read.table() / write.table()

crime_df <- read.table(file_path, header = TRUE, sep = ",")

#Alternative using read.csv() 
crime_df2 <- read.csv(file_path, header = TRUE, sep = ",")

head(crime_df)
summary(crime_df$Community)
class(crime_df$Community)

head(crime_df2)
class(crime_df2$Community)

#Method 2: read.csv() / write.csv()

#write the first 100 rows only to working directory

getwd() 


write.csv(crime_df[1:100,],"crimedata.csv", row.names = TRUE) 

#Note that default behavior in R is to convert strings to factors, use stringsAsFactors=FALSE
#option to prevent this Example:

crime_df3 <- read.csv(file_path, stringsAsFactors = FALSE)
head(crime_df3)
summary(crime_df3$Community)

#This makes it easier to replace white space for example or work with strings using stringr package.
#There are many other options available for *.csv family of functions for example strip.white = TRUE
#will strip values of whitespace as they're read in. Options should be separated by , 


#Difference between read.csv and read.table is *.table family of functions require more options
#In fact read.csv is a wrapper around read.table that assumes data has headers and delimitter is a comma 

#Method 3: Working with excel files
#There are many packages for working directly with excel data 
#Most popular is Hadley Wickham's readxl package to install do

install.packages("readxl")
library(readxl)

#Note, if you save your file as .RData file, and start a new R session, you will have to call 
#library(package) again 

#view worksheets in excel file 
excel_sheets("crimedata.xlsx")

#Read in data sheet 
worksheet_1 <- read_excel("crimedata.xlsx", sheet="population")
head(worksheet_1,3)

#The output of this is a tbl_df object, which can be used with popular dplyr package
#Other packages to read excel files include: XLConnect, xlsx, excel.link, openxlsx and rjava

#XLConnect and xlsx require a lot of memory when working with Excel files this could be a problem. 
#Most of these packages are similar and include methods for interfacing with worksheets and
#loading worksheets into a data frame for analysis. There are also java dependencies for these packages.


#Method 4: Loading /Saving very large data sets 
#If data generated in R contains millions of rows, we can use an .RData file to serialize the data to disk
#This is usually much faster than calling write.csv or read.csv()

largeData <- data.frame(ID = 1:1000000, Value = rnorm(1000000))

system.time(write.csv(largeData,"testdata1.csv"))

#vs 

system.time(save(largeData,file="testdata2.RData"))

#Note that disadvantage of this is that .RData files can only be used within R.
#To load data data use follow

load("testdata2.RData")

#Method 5: Fast read and write
#readr and data.table packages provide functions such as read_csv for improved efficiency 
#However, this is a separate topic and outside scope of this documentation which focuses on Base R


