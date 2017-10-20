options(java.parameters = "- Xmx1024m")

library(xlsx)
library(data.table)


#read base sheets
#Skiping the required rows
base_crime <- data.table(read.xlsx("2017 Community Crime Statistics.xls", sheetName = "",encoding = "UTF-8",stringsAsFactors = FALSE))