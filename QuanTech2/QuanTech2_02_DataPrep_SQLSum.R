#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project2 - Data Prep 01. SQL Summary
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
                 host = 'localhost', #
                 port = 3306,
                 user = 'root',
                 dbname= 'wos', 
                 password = '1009')

dir <- "I:/Data_for_practice/Rfiles/QuanTech"

### Get list of files
file.list <- list.files(path=paste0(dir,'/quant_pub_list/'), pattern = 'qc.*\\.RData')
# Remove qc11 & qv.file.list
file.list <- file.list[!grepl("kqc", file.list)]
file.list <- file.list[!grepl("list", file.list)]
file.list <- file.list[!grepl("keywords_qc11.RData", file.list)]
length(file.list) # 79

qc.file.list <- 0
for (i in 1:length(file.list)){
  # Load data
  x <- load(file=paste0(dir,'/quant_pub_list/',file.list[i]))
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
qc.file.list$pubid %>% unique %>% length
save(qc.file.list, file=paste0(dir,'/qc.file.list.RData'))

qc.file.list %>% nrow # 6,852,925 -> 493,374 -> 250,339 -> 266,218 
qc.file.list$pubid %>% unique %>% length # 6,852,925 -> 421,201 -> 187,666 -> 200,745 

# Now we are going to use the new filtering technique
#

### Publication table
quant_pub.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, publication.pubyear, publication.doc_type, publication.pubtype, 
    publication.doi, publication.abstract, publication.itemtitle",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_pub <- dbFetch(quant_pub.SQL, n=-1)
length(unique(quant_pub$pubid)) # 154,454
save(quant_pub, file=paste0(dir,"/quant_pub.RData"))
rm(quant_pub, quant_pub.SQL)

load(file=paste0(dir,"/quant_pub.RData"))
quant_pub$pubid %>% unique %>% length # 186,141
rm(quant_pub)

# Author table
quant_author.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, pub_author_aff.position, pub_author_aff.role,
    pub_author_aff.author_id_te, pub_author_aff.addr_num, pub_author_aff.addr_num_ed,
    author.display_name, author.full_name, author.wos_standard, author.first_name,
    author.last_name",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.pub_author_aff pub_author_aff",
    "ON list.pubid = pub_author_aff.pubid",
    "LEFT JOIN wos.authors author",
    "ON pub_author_aff.author_id_te = author.author_id_te",
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_author <- dbFetch(quant_author.SQL, n=-1)
length(unique(quant_author$pubid)) # 421,201 -> 174,695 -> 144,228 -> 154,454 -> 186,641
# quant_author <- quant_author[,-4] %>% head
save(quant_author, file=paste0(dir,"/quant_author.RData"))
rm(quant_author, quant_author.SQL)

load(file=paste0(dir,"/quant_author.RData"))
quant_author %>% head

# Author_inst table
quant_author_inst.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, pub_author_aff.position, pub_author_aff.role,
    pub_author_aff.author_id_te, pub_author_aff.addr_num, pub_author_aff.addr_num_ed,
    institutions.*",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.pub_author_aff pub_author_aff",
    "ON list.pubid = pub_author_aff.pubid",
    "LEFT JOIN wos.pub_institutions_aff pub_institutions_aff",
    "ON (pub_institutions_aff.pubid = pub_author_aff.pubid AND pub_institutions_aff.addr_num = pub_author_aff.addr_num)",
    "LEFT JOIN wos.institutions institutions",
    "ON pub_institutions_aff.institution_id_te = institutions.institution_id_te",
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_author_inst <- dbFetch(quant_author_inst.SQL, n=-1)
length(unique(quant_author_inst$pubid)) # 421,201 -> 174,695 -> 144,228 -> 154,454 -> 186,641
save(quant_author_inst, file=paste0(dir,"/quant_author_inst.RData"))
rm(quant_author_inst, quant_author_inst.SQL)

# Institution 
quant_inst.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.*, pub_institutions_aff.addr_num,
    pub_institutions_aff.SEQ_NO,
    institutions.*",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.pub_institutions_aff pub_institutions_aff",
    "ON list.pubid = pub_institutions_aff.pubid",
    # "LEFT JOIN wos.pub_institutions pub_institutions",
    # "ON (pub_institutions.pubid = pub_institutions_aff.pubid AND pub_institutions.addr_num = pub_institutions_aff.addr_num)",
    "LEFT JOIN wos.institutions institutions",
    "ON pub_institutions_aff.institution_id_te = institutions.institution_id_te",
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_inst <- dbFetch(quant_inst.SQL, n=-1)
length(unique(quant_inst$pubid)) # 6,512,435 -> 421,201 -> 174,695 -> 144,228 -> 154,454 -> 186,641
save(quant_inst, file=paste0(dir,"/quant_inst.RData"))
write.csv(quant_inst, file=paste0(dir,"/quant_inst.csv"), row.names=FALSE)
rm(quant_inst, quant_inst.SQL)

# Funding table
quant_funding.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct list.qc_category, funding.*, fundingtext.funding_text",
    "FROM wos.qc_file_list list",
    "LEFT JOIN wos.publications publication",
    "ON list.pubid = publication.pubid",
    "LEFT JOIN wos.funding funding",
    "ON list.pubid = funding.pubid",
    "LEFT JOIN wos.fundingtext fundingtext",
    "ON funding.pubid = fundingtext.pubid",
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_funding <- dbFetch(quant_funding.SQL, n=-1)
length(unique(quant_funding$pubid)) # 144,228 -> 154,454
save(quant_funding, file=paste0(dir,"/quant_funding.RData"))
write.csv(quant_funding, file=paste0(dir,"/quant_funding.csv"), row.names=FALSE)
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
    # "WHERE publication.doc_type='Article' AND publication.pubtype = 'Journal'
    "WHERE publication.pubyear >= 1998 AND publication.pubyear <= 2021"
  ))
quant_keyword <- dbFetch(quant_keyword.SQL, n=-1)
length(unique(quant_keyword$pubid)) # 144,228 -> 154,454
save(quant_keyword, file=paste0(dir,"/quant_keyword.RData"))
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
save(quant_cit, file=paste0(dir,"/quant_cit.RData"))
write.csv(quant_cit, file="R file/quant_cit.csv", row.names=FALSE)
rm(quant_cit, quant_cit.SQL)

