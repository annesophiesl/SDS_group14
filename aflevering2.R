# Starting with the first page
install.packages("XML")
install.packages("xml2")
install.packages("rvest")
library(rvest)
library(plyr)
library(xml2)

css.selector.title = ".heading-3 a"
css.selector.location = ".location"
css.selector.department = ".name a"
css.selector.date = ".date"
css.selector.detail = ".transaction a"
css.selector.ID = ".unique-reference"
css.selector.amount = ".paid-amount span"
css.selector.views = ".overview .views"
css.selector.all = ".ref-module-paid-bribe"






Samlet=data.frame()
linket = "http://www.ipaidabribe.com/reports/paid?page=--#gsc.tab=0"
to=2

  my.data = list()[1:to]
  for (i in 1:to){
  
    G10=i*10
    link = gsub("--",G10,linket)
    
    
    bribe.data = data.frame(read_html(link) %>% html_nodes(css = css.selector.title) %>% html_text ())
    
    # add variables 
    
    bribe.data$department = (read_html(link) %>% html_nodes(css = css.selector.department) %>% html_text ())

    bribe.data$location = (read_html(link) %>% html_nodes(css = css.selector.location) %>% html_text ())
    
    bribe.data$date = (read_html(link) %>% html_nodes(css = css.selector.date) %>% html_text ())
    
    bribe.data$amount = (read_html(link) %>% html_nodes(css = css.selector.amount) %>% html_text ())
    
    bribe.data$detail = (read_html(link) %>% html_nodes(css = css.selector.detail) %>% html_text ()) 
    
    bribe.data$views = (read_html(link) %>% html_nodes(css = css.selector.views) %>% html_text ()) 
    
    bribe.data$ID = (read_html(link) %>% html_nodes(css = css.selector.ID) %>% html_text ())     
    
 
    to_nr =10*i
    fr_nr =to_nr-9
    
    for (n in fr_nr:nr){
      Get=n-(10*i)+1
      Samelet[n,1]=bribe.data[get,1]
      Samelet[n,2]=bribe.data[get,2]
      Samelet[n,3]=bribe.data[get,3]
      Samelet[n,4]=bribe.data[get,4]
      Samelet[n,5]=bribe.data[get,5]
      Samelet[n,6]=bribe.data[get,6]
      Samelet[n,7]=bribe.data[get,7]
      Samelet[n,8]=bribe.data[get,8]
    }
    
    # waiting one second between hits
    Sys.sleep(1)
    cat(" done!\n")
  }

ns data

#beløb
bribe.data$size_big = str_extract(bribe.data$amount, "[0-9]+,[0-9]+,[0-9]+|[0-9]+,[0-9]+")
bribe.data$size_small = str_extract(bribe.data$amount, "[0-9]+")
bribe.data = transform(bribe.data, size = ifelse(!is.na(size_big), size_big, size_small))

#antal visninger
bribe.data$views_big = str_extract(bribe.data$views, "[0-9]+,[0-9]+,[0-9]+|[0-9]+,[0-9]+")
bribe.data$views_small = str_extract(bribe.data$views, "[0-9]+")
bribe.data = transform(bribe.data, size = ifelse(!is.na(views_num), views_big, views_small))

#stat og by
bribe.data$city= str_extract(bribe.data$location, "[A-z]*+")
bribe.data$state= str_extract(bribe.data$location, ", [A-z]*+")
bribe.data$state = gsub(", ", "", bribe.data$state)

#dato, mdr og år
bribe.data$year = str_extract(bribe.data$date, ", [0-9]*+")
bribe.data$year = gsub(", ", "", bribe.data$year)
bribe.data$month = str_extract(bribe.data$date, "[A-z]*+")
 




