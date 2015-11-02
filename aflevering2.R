# Starting with the first page
install.packages("XML")
install.packages("rvest")
library(rvest)
library(plyr)

link = "http://ipaidabribe.com/reports/paid/" 

css.selector.title = ".heading-3 a"
css.selector.location = ".location"
css.selector.department = ".name a"
css.selector.date = ".date"
css.selector.detail = ".transaction a"
css.selector.ID = ".unique-reference"
css.selector.amount = ".paid-amount span"
css.selector.views = ".overview .views"
css.selector.all = ".ref-module-paid-bribe"

#create data frame

bribe.data = data.frame(read_html(link) %>% html_nodes(css = css.selector.title) %>% html_text ())

# add variables 
                              
bribe.data$department = (read_html(link) %>% html_nodes(css = css.selector.department) %>% html_text ())

bribe.data$location = (read_html(link) %>% html_nodes(css = css.selector.location) %>% html_text ())

bribe.data$date = (read_html(link) %>% html_nodes(css = css.selector.date) %>% html_text ())

bribe.data$amount = (read_html(link) %>% html_nodes(css = css.selector.amount) %>% html_text ())

bribe.data$detail = (read_html(link) %>% html_nodes(css = css.selector.detail) %>% html_text ()) 

bribe.data$views = (read_html(link) %>% html_nodes(css = css.selector.views) %>% html_text ()) 

bribe.data$ID = (read_html(link) %>% html_nodes(css = css.selector.ID) %>% html_text ()) 

#bribe.all = data.frame(read_html(link) %>% html_nodes(css = css.selector.all) %>% html_text ())

#rens data



#beløb
bribe.data$size = str_extract(bribe.data$amount, )

                              