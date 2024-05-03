#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project - Data Prep 01. SQL Extraction - KISTEP VERSION
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

keywords_kqc01.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    '(LOWER(publications.itemtitle) LIKE "%quantum information%" OR 
      LOWER(publications.itemtitle) LIKE "%von Neumann mutual information%" OR 
      LOWER(publications.itemtitle) LIKE "%quantum mutual information%" OR 
      LOWER(publications.itemtitle) LIKE "%quantum fisher information%") 
      OR
      (LOWER(publications.abstract) LIKE "%quantum information%" OR 
      LOWER(publications.abstract) LIKE "%von Neumann mutual information%" OR 
      LOWER(publications.abstract) LIKE "%quantum mutual information%" OR 
      LOWER(publications.abstract) LIKE "%quantum fisher information%")'
  ))
keywords_kqc01 <- dbFetch(keywords_kqc01.SQL, n=-1)
length(unique(keywords_kqc01$pubid)) # 15,566
save(keywords_kqc01, file="R file/keywords_kqc01.RData")
rm(keywords_kqc01, keywords_kqc01.SQL)

keywords_kqc02.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    '(LOWER(publications.itemtitle) LIKE "%quantum%technolog%" OR 
      LOWER(publications.itemtitle) LIKE "%quantum% %technolog%" OR 
      LOWER(publications.itemtitle) LIKE "%quantum% % %technolog%")
    OR 
    (LOWER(publications.abstract) LIKE "%quantum%technolog%" OR 
      LOWER(publications.abstract) LIKE "%quantum% %technolog%" OR 
      LOWER(publications.abstract) LIKE "%quantum% % %technolog%")'
  ))
keywords_kqc02 <- dbFetch(keywords_kqc02.SQL, n=-1)
length(unique(keywords_kqc02$pubid)) # 16,307
save(keywords_kqc02, file="R file/keywords_kqc02.RData")
rm(keywords_kqc02, keywords_kqc02.SQL)

keywords_kqc03.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    '((LOWER(publications.itemtitle) LIKE "%theor%qubit%" OR LOWER(publications.itemtitle) LIKE "%qubit%theor%")
    OR (LOWER(publications.itemtitle) LIKE "%theor%quantum bit%" OR LOWER(publications.itemtitle) LIKE "%quantum bit%theor%")
    )
    OR 
    ((LOWER(publications.abstract) LIKE "%theor%qubit%" OR LOWER(publications.abstract) LIKE "%qubit%theor%")
    OR (LOWER(publications.abstract) LIKE "%theor%quantum bit%" OR LOWER(publications.abstract) LIKE "%quantum bit%theor%"))'
  ))
keywords_kqc03 <- dbFetch(keywords_kqc03.SQL, n=-1)
length(unique(keywords_kqc03$pubid)) # 4,345
save(keywords_kqc03, file="R file/keywords_kqc03.RData")
rm(keywords_kqc03, keywords_kqc03.SQL)

keywords_kqc04.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum information control%' OR 
     LOWER(publications.itemtitle) LIKE '%control of quantum%' OR 
     LOWER(publications.itemtitle) LIKE '%control over quantum%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum optimal control%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum state control%' OR 
     LOWER(publications.itemtitle) LIKE '%control quantum%' OR 
     LOWER(publications.itemtitle) LIKE '%control the quantum%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum coherent control%' OR 
     LOWER(publications.itemtitle) LIKE '%qubit control%' OR 
     LOWER(publications.itemtitle) LIKE '%control of qubit%')
     OR
     (LOWER(publications.abstract) LIKE '%quantum information control%' OR 
     LOWER(publications.abstract) LIKE '%control of quantum%' OR 
     LOWER(publications.abstract) LIKE '%control over quantum%' OR 
     LOWER(publications.abstract) LIKE '%quantum optimal control%' OR 
     LOWER(publications.abstract) LIKE '%quantum state control%' OR 
     LOWER(publications.abstract) LIKE '%control quantum%' OR 
     LOWER(publications.abstract) LIKE '%control the quantum%' OR 
     LOWER(publications.abstract) LIKE '%quantum coherent control%' OR 
     LOWER(publications.abstract) LIKE '%qubit control%' OR 
     LOWER(publications.abstract) LIKE '%control of qubit%')"
  ))
keywords_kqc04 <- dbFetch(keywords_kqc04.SQL, n=-1)
length(unique(keywords_kqc04$pubid)) # 1,517
save(keywords_kqc04, file="R file/keywords_kqc04.RData")
rm(keywords_kqc04, keywords_kqc04.SQL)

keywords_kqc05.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "((LOWER(publications.itemtitle) LIKE '%quantum%' AND LOWER(publications.itemtitle) LIKE '%metrology%') OR 
     (LOWER(publications.itemtitle) LIKE '%quantum tomograph%' OR LOWER(publications.itemtitle) LIKE '%quantum tomographs%') OR 
     LOWER(publications.itemtitle) LIKE '%atomic clock%' OR 
     LOWER(publications.itemtitle) LIKE '%ion clock%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum clock%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum gravimeter%')
     OR
     ((LOWER(publications.abstract) LIKE '%quantum%' AND LOWER(publications.abstract) LIKE '%metrology%') OR 
     (LOWER(publications.abstract) LIKE '%quantum tomograph%' OR LOWER(publications.abstract) LIKE '%quantum tomographs%') OR 
     LOWER(publications.abstract) LIKE '%atomic clock%' OR 
     LOWER(publications.abstract) LIKE '%ion clock%' OR 
     LOWER(publications.abstract) LIKE '%quantum clock%' OR 
     LOWER(publications.abstract) LIKE '%quantum gravimeter%')"
  ))
keywords_kqc05 <- dbFetch(keywords_kqc05.SQL, n=-1)
length(unique(keywords_kqc05$pubid)) # 6,316
save(keywords_kqc05, file="R file/keywords_kqc05.RData")
rm(keywords_kqc05, keywords_kqc05.SQL)

keywords_kqc06.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum sensing%' OR 
    LOWER(publications.itemtitle) LIKE '%quantum sensor%' OR 
    LOWER(publications.itemtitle) LIKE '%quantum sensors%')
    OR
    (LOWER(publications.abstract) LIKE '%quantum sensing%' OR 
    LOWER(publications.abstract) LIKE '%quantum sensor%' OR 
    LOWER(publications.abstract) LIKE '%quantum sensors%')
    "
  ))
keywords_kqc06 <- dbFetch(keywords_kqc06.SQL, n=-1)
length(unique(keywords_kqc06$pubid)) # 1,055
save(keywords_kqc06, file="R file/keywords_kqc06.RData")
rm(keywords_kqc06, keywords_kqc06.SQL)

keywords_kqc07.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum imag%' OR 
     (LOWER(publications.itemtitle) LIKE '%quantum%' AND LOWER(publications.itemtitle) LIKE '%ghost imag%'))
     OR
     (LOWER(publications.abstract) LIKE '%quantum imag%' OR 
     (LOWER(publications.abstract) LIKE '%quantum%' AND LOWER(publications.abstract) LIKE '%ghost imag%'))
    "
  ))
keywords_kqc07 <- dbFetch(keywords_kqc07.SQL, n=-1)
length(unique(keywords_kqc07$pubid)) # 770
save(keywords_kqc07, file="R file/keywords_kqc07.RData")
rm(keywords_kqc07, keywords_kqc07.SQL)

keywords_kqc08.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum communication%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum network%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum optical communication%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum state transmission%' OR 
     ((LOWER(publications.itemtitle) LIKE '%quantum memor%' OR LOWER(publications.itemtitle) LIKE '%quantum storage%') AND
      LOWER(publications.itemtitle) LIKE '%photon%') OR
     LOWER(publications.itemtitle) LIKE '%quantum repeater%' OR
     LOWER(publications.itemtitle) LIKE '%quantum internet%' OR
     (LOWER(publications.itemtitle) LIKE '%quantum teleport%' AND 
      (LOWER(publications.itemtitle) LIKE '%qubit%' OR LOWER(publications.itemtitle) LIKE '%quantum bit%' OR LOWER(publications.itemtitle) LIKE '%entangle%')
     ))
     OR
    (LOWER(publications.abstract) LIKE '%quantum communication%' OR 
     LOWER(publications.abstract) LIKE '%quantum network%' OR 
     LOWER(publications.abstract) LIKE '%quantum optical communication%' OR 
     LOWER(publications.abstract) LIKE '%quantum state transmission%' OR 
     ((LOWER(publications.abstract) LIKE '%quantum memor%' OR LOWER(publications.abstract) LIKE '%quantum storage%') AND
      LOWER(publications.abstract) LIKE '%photon%') OR
     LOWER(publications.abstract) LIKE '%quantum repeater%' OR
     LOWER(publications.abstract) LIKE '%quantum internet%' OR
     (LOWER(publications.abstract) LIKE '%quantum teleport%' AND 
      (LOWER(publications.abstract) LIKE '%qubit%' OR LOWER(publications.abstract) LIKE '%quantum bit%' OR LOWER(publications.abstract) LIKE '%entangle%')
     ))"
  ))
keywords_kqc08 <- dbFetch(keywords_kqc08.SQL, n=-1)
length(unique(keywords_kqc08$pubid)) # 8,240
save(keywords_kqc08, file="R file/keywords_kqc08.RData")
rm(keywords_kqc08, keywords_kqc08.SQL)

keywords_kqc09.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum crypto%' OR 
     LOWER(publications.itemtitle) LIKE '%pqcrypto%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum key distribution%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum encrypt%' OR 
     ((LOWER(publications.itemtitle) LIKE '%quantum secur%' OR LOWER(publications.itemtitle) LIKE '%quantum secre%') AND
      NOT (LOWER(publications.itemtitle) LIKE '%quantum secreted%' OR LOWER(publications.itemtitle) LIKE '%quantum secretion%')
    ))
    OR 
    (LOWER(publications.abstract) LIKE '%quantum crypto%' OR 
     LOWER(publications.abstract) LIKE '%pqcrypto%' OR 
     LOWER(publications.abstract) LIKE '%quantum key distribution%' OR 
     LOWER(publications.abstract) LIKE '%quantum encrypt%' OR 
     ((LOWER(publications.abstract) LIKE '%quantum secur%' OR LOWER(publications.abstract) LIKE '%quantum secre%') AND
      NOT (LOWER(publications.abstract) LIKE '%quantum secreted%' OR LOWER(publications.abstract) LIKE '%quantum secretion%')
    ))"
  ))
keywords_kqc09 <- dbFetch(keywords_kqc09.SQL, n=-1)
length(unique(keywords_kqc09$pubid)) # 7,903
save(keywords_kqc09, file="R file/keywords_kqc09.RData")
rm(keywords_kqc09, keywords_kqc09.SQL)

keywords_kqc10.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum comput%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum supremacy%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum error correction%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum annealer%' OR 
     (LOWER(publications.itemtitle) LIKE '%quantum%' AND 
      (LOWER(publications.itemtitle) LIKE '%automata%' OR LOWER(publications.itemtitle) LIKE '%automaton%')
     ) OR
     LOWER(publications.itemtitle) LIKE '%quantum clon% machine%' OR 
     LOWER(publications.itemtitle) LIKE '%NISQ%' OR 
     LOWER(publications.itemtitle) LIKE '%noisy intermediate scale quantum%'
     )
     OR
     (LOWER(publications.abstract) LIKE '%quantum comput%' OR 
     LOWER(publications.abstract) LIKE '%quantum supremacy%' OR 
     LOWER(publications.abstract) LIKE '%quantum error correction%' OR 
     LOWER(publications.abstract) LIKE '%quantum annealer%' OR 
     (LOWER(publications.abstract) LIKE '%quantum%' AND 
      (LOWER(publications.abstract) LIKE '%automata%' OR LOWER(publications.abstract) LIKE '%automaton%')
     ) OR
     LOWER(publications.abstract) LIKE '%quantum clon% machine%' OR 
     LOWER(publications.abstract) LIKE '%NISQ%' OR 
     LOWER(publications.abstract) LIKE '%noisy intermediate scale quantum%'
     )"
  ))
keywords_kqc10 <- dbFetch(keywords_kqc10.SQL, n=-1)
length(unique(keywords_kqc10$pubid)) # 19,298
save(keywords_kqc10, file="R file/keywords_kqc10.RData")
rm(keywords_kqc10, keywords_kqc10.SQL)

keywords_kqc11.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum hardware%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum device%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum circuit%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum processor%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum register%') 
     OR
     (LOWER(publications.abstract) LIKE '%quantum hardware%' OR 
     LOWER(publications.abstract) LIKE '%quantum device%' OR 
     LOWER(publications.abstract) LIKE '%quantum circuit%' OR 
     LOWER(publications.abstract) LIKE '%quantum processor%' OR 
     LOWER(publications.abstract) LIKE '%quantum register%')"
  ))
keywords_kqc11 <- dbFetch(keywords_kqc11.SQL, n=-1)
length(unique(keywords_kqc11$pubid)) # 6,210
save(keywords_kqc11, file="R file/keywords_kqc11.RData")
rm(keywords_kqc11, keywords_kqc11.SQL)

keywords_kqc12.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct publications.*',
    'FROM wos.publications publications',
    'INNER JOIN wos.subjects subjects',
    'ON publications.pubid = subjects.pubid',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "((LOWER(publications.itemtitle) LIKE '%quantum simulat%' AND 
      (LOWER(publications.itemtitle) LIKE '%qubit%' OR LOWER(publications.itemtitle) LIKE '%quantum bit%' OR LOWER(publications.itemtitle) LIKE '%quantum comput%')
     ) OR LOWER(publications.itemtitle) LIKE '%quantum simulator%' OR
     (LOWER(publications.itemtitle) LIKE '%quantum simulat%' AND 
      (LOWER(subjects.subject) = 'quantum science technology' OR 
       LOWER(subjects.subject) = 'computer science theory methods')))
    OR
    ((LOWER(publications.abstract) LIKE '%quantum simulat%' AND 
      (LOWER(publications.abstract) LIKE '%qubit%' OR LOWER(publications.abstract) LIKE '%quantum bit%' OR LOWER(publications.abstract) LIKE '%quantum comput%')
     ) OR LOWER(publications.abstract) LIKE '%quantum simulator%' OR
     (LOWER(publications.abstract) LIKE '%quantum simulat%' AND 
      (LOWER(subjects.subject) = 'quantum science technology' OR 
       LOWER(subjects.subject) = 'computer science theory methods')))"
  ))
keywords_kqc12 <- dbFetch(keywords_kqc12.SQL, n=-1)
length(unique(keywords_kqc12$pubid)) # 1,315
save(keywords_kqc12, file="R file/keywords_kqc12.RData")
rm(keywords_kqc12, keywords_kqc12.SQL)

keywords_kqc13.SQL <- RMySQL::dbSendQuery(
  con, paste0(
    'SELECT distinct * ',
    'FROM wos.publications publications ',
    'WHERE publications.doc_type ="Article " AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND ',
    "(LOWER(publications.itemtitle) LIKE '%quantum algorithm%' OR 
     LOWER(publications.itemtitle) LIKE '%variational quantum algorithm%' OR 
     LOWER(publications.itemtitle) LIKE '%variational quantum eigensolver%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum approximate optimization algorithm%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum approximate optimisation algorithm%' OR 
     LOWER(publications.itemtitle) LIKE '%variational quantum linear solver%' OR 
     LOWER(publications.itemtitle) LIKE ", '"%Shor',"'s",' algorithm% "', " OR 
     LOWER(publications.itemtitle) LIKE ", '"%Grover',"'s",' algorithm% "', " OR 
     LOWER(publications.itemtitle) LIKE '%quantum simulation algorithm%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum linear algebra%')
     OR
     (LOWER(publications.abstract) LIKE '%quantum algorithm%' OR 
     LOWER(publications.abstract) LIKE '%variational quantum algorithm%' OR 
     LOWER(publications.abstract) LIKE '%variational quantum eigensolver%' OR 
     LOWER(publications.abstract) LIKE '%quantum approximate optimization algorithm%' OR 
     LOWER(publications.abstract) LIKE '%quantum approximate optimisation algorithm%' OR 
     LOWER(publications.abstract) LIKE '%variational quantum linear solver%' OR 
     LOWER(publications.abstract) LIKE ", '"%Shor',"'s",' algorithm% "', " OR 
     LOWER(publications.abstract) LIKE ", '"%Grover',"'s",' algorithm% "', " OR 
     LOWER(publications.abstract) LIKE '%quantum simulation algorithm%' OR 
     LOWER(publications.abstract) LIKE '%quantum linear algebra%')"
  ))
keywords_kqc13 <- dbFetch(keywords_kqc13.SQL, n=-1)
length(unique(keywords_kqc13$pubid)) # 2,961
save(keywords_kqc13, file="R file/keywords_kqc13.RData")
rm(keywords_kqc13, keywords_kqc13.SQL)

keywords_kqc14.SQL <- RMySQL::dbSendQuery(
  con, paste(
    'SELECT distinct *',
    'FROM wos.publications publications',
    'WHERE publications.doc_type ="Article" AND 
    publications.pubyear >= 2010 AND publications.pubyear <= 2022 AND',
    "(LOWER(publications.itemtitle) LIKE '%quantum software%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum cod%' OR 
     LOWER(publications.itemtitle) LIKE '%quantum program%')
     OR
     (LOWER(publications.abstract) LIKE '%quantum software%' OR 
     LOWER(publications.abstract) LIKE '%quantum cod%' OR 
     LOWER(publications.abstract) LIKE '%quantum program%')"
  ))
keywords_kqc14 <- dbFetch(keywords_kqc14.SQL, n=-1)
length(unique(keywords_kqc14$pubid)) # 1,118
save(keywords_kqc14, file="R file/keywords_kqc14.RData")
rm(keywords_kqc14, keywords_kqc14)



