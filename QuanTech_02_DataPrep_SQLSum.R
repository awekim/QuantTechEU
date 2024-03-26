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

qc.file.list %>% nrow # 6,852,925
qc.file.list$pubid %>% unique %>% length # 6,512,435

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
      "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'"
    ))
quant_pub <- dbFetch(quant_pub.SQL, n=-1)
length(unique(quant_pub$pubid)) # 5,286,799
save(quant_pub, file="R file/quant_pub.RData")
write.csv(quant_pub, file="R file/quant_pub.csv", row.names=FALSE)
rm(quant_pub, quant_pub.SQL)

# Author table
quant_author.SQL <- RMySQL::dbSendQuery(
    con, paste(
      "SELECT distinct list.*, author.*",
      "FROM wos2024.qc_file_list list",
      "LEFT JOIN wos.pub_author pubauthor",
      "ON list.pubid = pubauthor.pubid",
      "LEFT JOIN wos2024.authors author",
      "ON pubauthor.author_id_te = author.author_id_te"
    ))
quant_author <- dbFetch(quant_author.SQL, n=-1)
length(unique(quant_author$pubid)) # 6,512,435
# quant_author <- quant_author[,-4] %>% head
save(quant_author, file="R file/quant_author_new.RData")
write.csv(quant_author, file="R file/quant_author_new.csv", row.names=FALSE)
rm(quant_author, quant_author.SQL)

quant_author %>% filter(is.na(author_id_te)==FALSE)  %>% head(1)
quant_author %>% select(pubid) %>% unique %>% nrow # 6,512,435
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
    "LEFT JOIN wos.pub_institutions pub_inst",
    "ON list.pubid = pub_inst.pubid",
    "LEFT JOIN wos.institutions institutions",
    "ON pub_inst.institution_id_te = institutions.institution_id_te"
  ))
quant_inst <- dbFetch(quant_inst.SQL, n=-1)
length(unique(quant_inst$pubid)) # 6,512,435

save(quant_inst, file="R file/quant_inst.RData")
write.csv(quant_inst, file="R file/quant_inst.csv", row.names=FALSE)
rm(quant_inst, quant_inst.SQL)

quant_inst %>% select(pubid) %>% unique %>% nrow # 6,512,435
quant_inst %>% filter(is.na(institution_id_te)==TRUE) %>% 
  select(pubid) %>% unique %>% nrow # 491,301

# Funding table
quant_funding.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, funding.*, fundingtext.funding_text",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.funding funding",
    "ON list.pubid = funding.pubid",
    "LEFT JOIN wos.fundingtext fundingtext",
    "ON funding.pubid = fundingtext.pubid"
  ))
quant_funding <- dbFetch(quant_funding.SQL, n=-1)
length(unique(quant_funding$pubid)) # 6,512,435
save(quant_funding, file="R file/quant_funding.RData")
write.csv(quant_funding, file="R file/quant_funding.csv", row.names=FALSE)
rm(quant_funding, quant_funding.SQL)

# Keyword table
quant_keyword.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, keywords_plus.keyword",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.keywords_plus keywords_plus",
    "ON list.pubid = keywords_plus.pubid"
  ))
quant_keyword <- dbFetch(quant_keyword.SQL, n=-1)
length(unique(quant_keyword$pubid)) # 6,512,435
save(quant_keyword, file="R file/quant_keyword.RData")
write.csv(quant_funding, file="R file/quant_keyword.csv", row.names=FALSE)
rm(quant_keyword, quant_keyword.SQL)

# Citation table
quant_cit.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, citations.*",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.citations citations",
    "ON list.pubid = citations.pub_cited",
    "WHERE list.qc_category = 'qc11'"
  ))
quant_cit <- dbFetch(quant_cit.SQL, n=-1)
length(unique(quant_cit$pubid)) # 6,512,435
save(quant_cit, file="R file/quant_cit.RData")
write.csv(quant_funding, file="R file/quant_funding.csv", row.names=FALSE)
rm(quant_funding, quant_funding.SQL)


