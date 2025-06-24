#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project - Data Prep 02. SQL Summary
##  goal : Quantum Tech Collaboration Analysis
##  Data set: WoS
##  Time Span: 
##  Variables
##      Input: 
##      Output:  
##  Methodology: 
##  Time-stamp: :  
##  Notice :
#######################################################################

# install.packages('RMySQL')
# devtools::install_github("rstats-db/RMySQL")
library(dplyr)
library(magrittr)
library(RMySQL)
library("RMariaDB")

### Create TechEvo connection
m <- dbDriver("MySQL")
con <- dbConnect(m, # MySQL()
                 host = 'tevo.mysql.database.azure.com',
                 port = 3306,
                 user = 'keungoui@tevo',
                 dbname= 'wos', 
                 password = 'Password1!')
con <- dbConnect(m, # MySQL()
                 host = 'localhost', #
                 port = 3306,
                 user = 'root',
                 dbname= 'wos2024', 
                 password = '1009')
con <- dbConnect(m, # MySQL()
                 host = '220.149.110.48', #
                 port = 3306,
                 user = 'awek',
                 dbname= 'wos', 
                 password = 'Kimkim86!!')

### Get list of files
file.list <- list.files(path='R file/', pattern = 'qc.*\\.RData')
# Remove qc11 & qv.file.list
file.list <- file.list[!grepl("kqc", file.list)]
file.list <- file.list[!grepl("list", file.list)]
file.list <- file.list[!grepl("keywords_qc11.RData", file.list)]
length(file.list) # 79

qc.file.list <- 0
for (i in 1:length(file.list)){
  # Load data
  x <- load(file=paste0('R file/',file.list[i]))
  temp <- get(x)
  
  # Extract file name
  qc_cat_name <- sub(".*_", "", file.list[i]) 
  qc_cat_name <- sub(".RData", "", qc_cat_name) 
  
  qc.file.list <- 
    qc.file.list %>% 
    rbind(temp %>% select(pubid) %>% unique %>% 
            mutate(qc_category = qc_cat_name))
  rm(x, temp, qc_cat_name)
  print(i)
}
qc.file.list <- qc.file.list[2:nrow(qc.file.list),]
qc.file.list %<>% arrange(qc_category)
save(qc.file.list, file='R file/qc.file.list.RData')

qc.file.list %>% nrow # 6,852,925 -> 493,374 -> 250,339 -> 266,218 
qc.file.list$pubid %>% unique %>% length # 6,852,925 -> 421,201 -> 187,666 -> 200,745 

### Upload QauntTech publication list to SQL Server
load(file='R file/qc.file.list.RData')

# enables user access to data loads from local sources
RMySQL::dbSendQuery(con, "SET GLOBAL local_infile = true;") 
# check
RMySQL::dbSendQuery(con, "SHOW GLOBAL VARIABLES LIKE 'local_infile';") 

dbRemoveTable(con, "qc_file_list") 
dbWriteTable(con, "qc_file_list", qc.file.list, row.names = FALSE)
rm(qc.file.list)

### 
# Publication table
quant_pub.SQL <- RMySQL::dbSendQuery(
    con, paste(
      "SELECT distinct list.*, publication.pubyear, publication.doi, publication.abstract, publication.itemtitle",
      "FROM wos.qc_file_list list",
      "LEFT JOIN wos.publications publication",
      "ON list.pubid = publication.pubid",
      "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
      AND publication.pubyear >= 1998 AND publication.pubyear <= 2021"
    ))
quant_pub <- dbFetch(quant_pub.SQL, n=-1)
length(unique(quant_pub$pubid)) # 154,454
save(quant_pub, file="R file/quant_pub.RData")
write.csv(quant_pub, file="R file/quant_pub.csv", row.names=FALSE)
rm(quant_pub, quant_pub.SQL)

# load(file="R file/quant_pub.RData")
library(ggplot2)
quant_pub %>% group_by(pubyear, qc_category) %>% 
  filter(qc_category!="qc11" & qc_category!="qc422") %>%
  filter(pubyear >= 1998 & pubyear <= 2021) %>%
  summarize(pub=length(unique(pubid))) %>%
  ggplot(aes(x=pubyear,y=pub,group=qc_category,color=qc_category)) +
  geom_line()
table(quant_pub$pubyear)

quant_pub %>% group_by(pubyear) %>% 
  filter(qc_category!="qc11" & qc_category!="qc422") %>%
  filter(pubyear >= 1998 & pubyear <= 2021) %>%
  summarize(pub=length(unique(pubid))) %>%
  ggplot(aes(x=pubyear,y=pub,group="all")) +
  geom_line()

# comparison wos and wos2024
# wos
# 1980  1981  1982  1983  1984  1985  1986  1987  1988  1989  1990  1991  1992  1993  1994  1995  1996 
# 1887  2104  2097  2297  2152  2293  2293  2610  2497  2657  3019  7472  7813  8007  8853  8672 10091 
# 1997  1998  1999  2000  2001  2002  2003  2004  2005  2006  2007  2008  2009  2010  2011  2012  2013 
# 9835  8451  8830  9746  9744 10859 11397 10924 12083 12557 13927 14079 14805 16113 16425 16801 18449 
# 2014  2015  2016  2017 
# 19121 20443 21804 21270 

# wos2024
# 1980  1981  1982  1983  1984  1985  1986  1987  1988  1989  1990  1991  1992  1993  1994  1995  1996 
# 49    58    67    63    78    87    96    99   124   119   168  1053  1149  1322  1414  1419  1896 
# 1997  1998  1999  2000  2001  2002  2003  2004  2005  2006  2007  2008  2009  2010  2011  2012  2013 
# 2726  8444  8831  9746  9763 10859 11473  9862 10888 10747 12157 12377 13273 14173 16384 16990 18712 
# 2014  2015  2016  2017  2018  2019  2020  2021  2022 
# 19616 20494 20917 14204 12676 15704 27232 28155   279 

# Author table
quant_author.SQL <- RMySQL::dbSendQuery(
    con, paste(
      "SELECT distinct list.*, author.*",
      "FROM wos.qc_file_list list",
      "LEFT JOIN wos.publications publication",
      "ON list.pubid = publication.pubid",
      "LEFT JOIN wos.pub_author pubauthor",
      "ON list.pubid = pubauthor.pubid",
      "LEFT JOIN wos.authors author",
      "ON pubauthor.author_id_te = author.author_id_te",
      "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
      AND publication.pubyear >= 1998 AND publication.pubyear <= 2021"
    ))
quant_author <- dbFetch(quant_author.SQL, n=-1)
length(unique(quant_author$pubid)) # 421,201 -> 174,695 -> 144,228 -> 154,454
# quant_author <- quant_author[,-4] %>% head
save(quant_author, file="R file/quant_author.RData")
write.csv(quant_author, file="R file/quant_author.csv", row.names=FALSE)
rm(quant_author, quant_author.SQL)

load(file="R file/quant_author_new.RData")
quant_author %>% filter(is.na(author_id_te)==FALSE)  %>% head(1)
quant_author %>% select(pubid) %>% unique %>% nrow # 6,512,435 -> 144,228 -> 154,454
quant_author %>% filter(is.na(author_id_te)==TRUE) %>% 
  select(pubid) %>% unique %>% nrow # 3,908,694
# !! Compare author (46,524,104) and reprint_author (9,974,424)
# (pub_author) pubid = 22,557,084
# (publication) pubid = 60,546,212
# (pub_institutions) pubid = 47,887,801

# Institution 
quant_inst.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, institutions.*",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.pub_institutions pub_inst",
    "ON list.pubid = pub_inst.pubid",
    "LEFT JOIN wos.institutions institutions",
    "ON pub_inst.institution_id_te = institutions.institution_id_te",
    "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    AND publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_inst <- dbFetch(quant_inst.SQL, n=-1)
length(unique(quant_inst$pubid)) # 6,512,435 -> 421,201 -> 174,695 -> 144,228 -> 154,454
save(quant_inst, file="R file/quant_inst.RData")
write.csv(quant_inst, file="R file/quant_inst.csv", row.names=FALSE)
rm(quant_inst, quant_inst.SQL)

quant_inst %>% filter(is.na(institution_id_te)==TRUE) %>% 
  select(pubid) %>% unique %>% nrow # 491,301 -> 23,035 -> 1338 -> 351

# Funding table
quant_funding.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, funding.*, fundingtext.funding_text",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.funding funding",
    "ON list.pubid = funding.pubid",
    "LEFT JOIN wos.fundingtext fundingtext",
    "ON funding.pubid = fundingtext.pubid",
    "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    AND publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_funding <- dbFetch(quant_funding.SQL, n=-1)
length(unique(quant_funding$pubid)) # 144,228 -> 154,454
save(quant_funding, file="R file/quant_funding.RData")
write.csv(quant_funding, file="R file/quant_funding.csv", row.names=FALSE)
rm(quant_funding, quant_funding.SQL)

# Keyword table
quant_keyword.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, keywords_plus.keyword",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.keywords_plus keywords_plus",
    "ON list.pubid = keywords_plus.pubid",
    "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    AND publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_keyword <- dbFetch(quant_keyword.SQL, n=-1)
length(unique(quant_keyword$pubid)) # 144,228 -> 154,454
save(quant_keyword, file="R file/quant_keyword.RData")
write.csv(quant_keyword, file="R file/quant_keyword.csv", row.names=FALSE)
rm(quant_keyword, quant_keyword.SQL)

# Citation table
quant_cit.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, citations.*",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.citations citations",
    "ON list.pubid = citations.pub_cited"
  ))
quant_cit <- dbFetch(quant_cit.SQL, n=-1)
length(unique(quant_cit$pubid)) # 200,745
save(quant_cit, file="R file/quant_cit.RData")
write.csv(quant_cit, file="R file/quant_cit.csv", row.names=FALSE)
rm(quant_cit, quant_cit.SQL)


