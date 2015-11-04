# Starting with the first page
install.packages("XML")
install.packages("xml2")
install.packages("rvest")


library(xml2)
library(rvest)
library(dplyr)
library(stringr)
library(date)
library(ggplot2)

#==================================================================================================
css.selector.title = ".heading-3 a"
css.selector.location = ".location"
css.selector.department = ".name a"
css.selector.date = ".date"
css.selector.detail = ".transaction a"
css.selector.ID = ".unique-reference"
css.selector.amount = ".paid-amount span"
css.selector.views = ".overview .views"
css.selector.all = ".ref-module-paid-bribe"



#defining the objects we want to scrape:
data = list()
link = "http://www.ipaidabribe.com/reports/paid?page="

#creating a vector with the pagenumbers ending the URL for each page
page <- c(seq(0,1000,10))

#creating a vector consisting of URL links to the first 100 pages
listoflinks = paste0(link, page)

#Creating a function that extracts the correct data from a given URL input
extraction_function = function(link) {
  site = read_html(link)
  title = site %>%
    html_nodes(css = css.selector.title) %>%
    html_text()
  department = site %>%
    html_nodes(css = css.selector.department) %>%
    html_text()
  location = site  %>% 
    html_nodes(css = css.selector.location) %>%
    html_text ()
  date = site  %>% 
    html_nodes(css = css.selector.date) %>% 
    html_text ()
  amount = site  %>%
    html_nodes(css = css.selector.amount) %>% 
    html_text ()
  detail = site  %>%
    html_nodes(css = css.selector.detail) %>% 
    html_text ()
  views = site  %>%
    html_nodes(css = css.selector.views) %>% 
    html_text ()
  ID = site  %>%
    html_nodes(css = css.selector.ID) %>% 
    html_text () 
  return(cbind(title, department, location, date, amount, detail, views, ID))
}

#Looping the function with all the links in the above defined vector
for (i in seq_along(listoflinks)) {
  data[[i]] = extraction_function(listoflinks[i])
  Sys.sleep(1)
}

# Har ændret html til read_html i extraction_function pga. warnings 
# og medtaget variablen title til control af information.
warnings()



#Converting the list of lists into a dataframe and tjekking variables & nr. of observations
bribe.data = ldply(data)
glimpse(bribe.data)
nrow(bribe.data)


# Har ændret så amounts og views er numeric samt deres navne. Derudover har jeg lavet en dato
# variabel.

#rens data
# Cleaning ==================================================================================================
#beløb
bribe.data$size_big   = str_extract(bribe.data$amount, "[0-9]+,[0-9]+,[0-9]+|[0-9]+,[0-9]+")
bribe.data$size_big   = as.numeric(gsub(",", "", bribe.data$size_big))
bribe.data$size_small = as.numeric(str_extract(bribe.data$amount, "[0-9]+"))
bribe.data = bribe.data %>% mutate( amount.c = ifelse(!is.na(size_big), size_big, size_small))


#antal visninger
bribe.data$views_big   = as.numeric(str_extract(bribe.data$views, "[0-9]+,[0-9]+,[0-9]+|[0-9]+,[0-9]+"))
bribe.data$views_small = as.numeric(str_extract(bribe.data$views, "[0-9]+"))
bribe.data = bribe.data %>% mutate( views.c = ifelse(!is.na(views_big), views_big, views_small))

#stat og by
bribe.data$city  = str_extract(bribe.data$location, "[A-z]*+")
bribe.data$state = str_extract(bribe.data$location, ", [A-z]*+")
bribe.data$state = gsub(", ", "", bribe.data$state)

#dato, mdr og år
bribe.data$year  = str_extract(bribe.data$date, ", [0-9]*+")
bribe.data$year  = as.numeric(gsub(", ", "", bribe.data$year))
bribe.data$month = str_extract(bribe.data$date, "[A-z]*+")
bribe.data$day   = as.numeric(str_extract(bribe.data$date, "([0-9])+(?=\u002C)"))


# Function that converts month from character to numeric.
numMonth <- function(x) {
  months <- list(january  =1,  february =2,  march     =3, 
                 april    =4,  may      =5,  june      =6, 
                 july     =7,  august   =8,  september =9, 
                 october  =10, november =11, december  =12)
  
  x <- tolower(x)
  sapply(x,function(x) months[[x]])
}
bribe.data$month_n = as.numeric(numMonth(bribe.data$month))

# Making a date.
bribe.data$day= ifelse(bribe.data$day<10, gsub(" ","", paste("0", bribe.data$day)),bribe.data$day)
bribe.data$date.c = as.Date(paste(bribe.data$year, bribe.data$month_n, bribe.data$day, sep="-"))


# Graph ==================================================================================================

bribe.data = bribe.data %>% select(title ,year, month,day, date.c, state, city, views.c, amount.c)


Graph_data  = bribe.data %>%
  group_by(date.c) %>%
  summarise(N = n()) 
Graph_data$cum = cumsum(Graph_data$N)

# Graph test
p = ggplot(Graph_data, aes(x = date.c, y = cum))
p + geom_line()+ theme_minimal()







