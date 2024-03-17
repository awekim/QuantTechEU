#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project - Data Prep 01. SQL Extraction
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

### Create institution-address table
# (addresses) 35,479,730 ~ (addresses_geocoded) 35,453,162
inst_address.SQL <- RMySQL::dbSendQuery(
    con, paste(
      "SELECT distinct address_id_institution_id.institution_id_te, addresses_geocoded.*",
      "FROM wos2024.address_id_institution_id address_id_institution_id",
      "LEFT JOIN addresses_geocoded addresses_geocoded",
      "ON address_id_institution_id.address_id_te = addresses_geocoded.address_id_te"
    ))
inst_address <- dbFetch(inst_address.SQL, n=-1)
length(unique(inst_address$pubid)) # 
save(inst_address, file="R file/inst_address.RData")
rm(inst_address, inst_address.SQL)

# OLD VERSION
# keywords_qc1.SQL <- RMySQL::dbSendQuery(
#   con, paste(
#     "SELECT distinct pub_keywords.pubid, keywords.keyword, keywords.kw_id",
#     "FROM wos.keywords keywords",
#     "INNER JOIN wos.pub_keywords pub_keywords",
#     "ON keywords.kw_id = pub_keywords.kw_id",
#     'WHERE keywords.keyword LIKE "QUANTUM%" or keywords.keyword LIKE "QUBIT%"' #'%quantum%'
#   ))

# qc: quantum tech

# qc1: 양자컴퓨팅
# qc11: 큐비트구현기술 
# qc111: 큐비트구현 기반기술
# qc112: 큐비트물리적 구현기술
# qc113: 큐비트양자얽힘게이트구현 기술

# qc12: 큐비트제어 고전 HW 기술
# qc121: 다중 큐비트상태 측정 하드웨어 기술 
# qc122: 다중 큐비트게이트신호생성 하드웨어 및 제어 기술
# qc123: 고속 하드웨어 제어 프로세서 및 펌웨어 기술

# qc13: 양자 SW 스택
# qc131: 양자컴퓨터 프론트엔드 및 백엔드 소프트웨어 스택 
# qc132: 양자 정보 및 양자컴퓨팅 이론
# qc133: 양자 오류 보정 및 제어 이론
# qc134: 양자 컴퓨터 알고리즘

# qc14: 확장가능한 복합양자HW 기술
# qc141: 시스템 통합화 및 확장가능한 큐비트아키텍쳐 
# qc142: 확장가능한 이종양자 인터페이스
# qc143: 양자 시뮬레이터

# qc2: 양자통신

# qc21: 양자암호통신
# qc211: 유선 양자암호
# qc212: 무선(자유 공간) 양자암호
# qc213: QKD 네트워크

# qc22: 양자네트워크
# qc221: 양자전송
# qc222: 양자 네트워크
# qc223: 위성 양자 통신
# qc224: 양자통신이론
# qc225: 양자통신용 소재/소자기술

# qc3: 양자센싱

# qc31: 양자센싱
# qc311: 양자 관성센서
# qc312: 양자 자기장 센서
# qc313: 양자 전기장 센서
# qc314: 양자 광학 센서
# qc315: 양자 시간및주파수 센서

# qc32: 양자계측
# qc321: 양자 센싱 기반기술

# qc4: 양자기반기술	
# qc41: 양자정보기술	
# qc42:양자소부장	
# qc421: 양자광원용 Wide Band-Gap 소부장기술
# qc422: 양자광원검출 초전도 소부장 기술
# qc423: 양자기술용 III-V & Si 소부장기술
# qc424: 양자기술용 결정 & 유전체 소부장 기술
# qc43: 양자지원기술	
# qc44: 큐빗플랫폼	초천도
# qc441: 이온트랩
# qc442: 반도체 양자점
# qc443: 중성원자
# qc444: 고체상태결함
# qc445: R06 광자

####
# qc11 --> start from qc1 then search in R
keywords_qc11.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    'WHERE keywords.keyword LIKE "%QUANTUM%" or keywords.keyword LIKE "%QUBIT%"' #'%quantum%'
  ))
keywords_qc11 <- dbFetch(keywords_qc11.SQL, n=-1)
length(unique(keywords_qc11$pubid)) # 178,014
save(keywords_qc11, file="R file/keywords_qc11.RData")
rm(keywords_qc11, keywords_qc11.SQL)

########################################
keywords_qc111.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos2024.keywords_plus keywords",
    "WHERE (LOWER(keywords.keyword) LIKE '%quantum%'
           OR LOWER(keywords.keyword) LIKE '%qubit%')
    AND (
      LOWER(keywords.keyword) LIKE '%single photon detection%'
      OR LOWER(keywords.keyword) LIKE '%single photon detectors%'
      OR LOWER(keywords.keyword) LIKE '%single photon avalanche%'
      OR LOWER(keywords.keyword) LIKE '%squid%'
      OR LOWER(keywords.keyword) LIKE '%avalanche photodiodes%'
      OR LOWER(keywords.keyword) LIKE '%entangled photon%'
      OR LOWER(keywords.keyword) LIKE '%entangled photons%'
      OR LOWER(keywords.keyword) LIKE '%correlated photon%'
      OR LOWER(keywords.keyword) LIKE '%nonclassical photon%'
      OR LOWER(keywords.keyword) LIKE '%photon-photon interaction%'
      OR LOWER(keywords.keyword) LIKE '%photon-photon interactions%'
      OR LOWER(keywords.keyword) LIKE '%photon pair generation%'
      OR LOWER(keywords.keyword) LIKE '%photon pair generations%'
      OR LOWER(keywords.keyword) LIKE '%photon-pair generation%'
      OR LOWER(keywords.keyword) LIKE '%photon-pair generations%'
      OR LOWER(keywords.keyword) LIKE '%multiphoton entangled%'
      OR LOWER(keywords.keyword) LIKE '%polarization-entangled%'
      OR LOWER(keywords.keyword) LIKE '%three-photon quantum%'
      OR LOWER(keywords.keyword) LIKE '%three-photon entangled%'
      OR LOWER(keywords.keyword) LIKE '%two-photon interference%'
      OR LOWER(keywords.keyword) LIKE '%hyper-entangled photons%'
      OR LOWER(keywords.keyword) LIKE '%multi-qubit quantum%'
      OR LOWER(keywords.keyword) LIKE '%spontaneous parametric down-conversion%'
      OR LOWER(keywords.keyword) LIKE '%hong–ou–mandel interference%'
      OR LOWER(keywords.keyword) LIKE '%photon pairs generated%'
      OR LOWER(keywords.keyword) LIKE '%photon-pair source%'
      OR LOWER(keywords.keyword) LIKE '%high-dimensional quantum states%'
      OR LOWER(keywords.keyword) LIKE '%bell state preparation%'
      OR LOWER(keywords.keyword) LIKE '%non-zero discord bipartite state%')"
  ))
keywords_qc111 <- dbFetch(keywords_qc111.SQL, n=-1)
length(unique(keywords_qc111$pubid)) # 8 -> 7
save(keywords_qc111, file="R file/keywords_qc111.RData")
rm(keywords_qc111, keywords_qc111.SQL)

publication_qc111.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((LOWER(publication.abstract) LIKE '%quantum%'
           OR LOWER(publication.abstract) LIKE '%qubit%')
    AND (
      LOWER(publication.abstract) LIKE '%single photon detection%'
      OR LOWER(publication.abstract) LIKE '%single photon detectors%'
      OR LOWER(publication.abstract) LIKE '%single photon avalanche%'
      OR LOWER(publication.abstract) LIKE '%squid%'
      OR LOWER(publication.abstract) LIKE '%avalanche photodiodes%'
      OR LOWER(publication.abstract) LIKE '%entangled photon%'
      OR LOWER(publication.abstract) LIKE '%entangled photons%'
      OR LOWER(publication.abstract) LIKE '%correlated photon%'
      OR LOWER(publication.abstract) LIKE '%nonclassical photon%'
      OR LOWER(publication.abstract) LIKE '%photon-photon interaction%'
      OR LOWER(publication.abstract) LIKE '%photon-photon interactions%'
      OR LOWER(publication.abstract) LIKE '%photon pair generation%'
      OR LOWER(publication.abstract) LIKE '%photon pair generations%'
      OR LOWER(publication.abstract) LIKE '%photon-pair generation%'
      OR LOWER(publication.abstract) LIKE '%photon-pair generations%'
      OR LOWER(publication.abstract) LIKE '%multiphoton entangled%'
      OR LOWER(publication.abstract) LIKE '%polarization-entangled%'
      OR LOWER(publication.abstract) LIKE '%three-photon quantum%'
      OR LOWER(publication.abstract) LIKE '%three-photon entangled%'
      OR LOWER(publication.abstract) LIKE '%two-photon interference%'
      OR LOWER(publication.abstract) LIKE '%hyper-entangled photons%'
      OR LOWER(publication.abstract) LIKE '%multi-qubit quantum%'
      OR LOWER(publication.abstract) LIKE '%spontaneous parametric down-conversion%'
      OR LOWER(publication.abstract) LIKE '%hong–ou–mandel interference%'
      OR LOWER(publication.abstract) LIKE '%photon pairs generated%'
      OR LOWER(publication.abstract) LIKE '%photon-pair source%'
      OR LOWER(publication.abstract) LIKE '%high-dimensional quantum states%'
      OR LOWER(publication.abstract) LIKE '%bell state preparation%'
      OR LOWER(publication.abstract) LIKE '%non-zero discord bipartite state%')) 
    OR
    ((LOWER(publication.itemtitle) LIKE '%quantum%'
           OR LOWER(publication.itemtitle) LIKE '%qubit%')
    AND (
      LOWER(publication.itemtitle) LIKE '%single photon detection%'
      OR LOWER(publication.itemtitle) LIKE '%single photon detectors%'
      OR LOWER(publication.itemtitle) LIKE '%single photon avalanche%'
      OR LOWER(publication.itemtitle) LIKE '%squid%'
      OR LOWER(publication.itemtitle) LIKE '%avalanche photodiodes%'
      OR LOWER(publication.itemtitle) LIKE '%entangled photon%'
      OR LOWER(publication.itemtitle) LIKE '%entangled photons%'
      OR LOWER(publication.itemtitle) LIKE '%correlated photon%'
      OR LOWER(publication.itemtitle) LIKE '%nonclassical photon%'
      OR LOWER(publication.itemtitle) LIKE '%photon-photon interaction%'
      OR LOWER(publication.itemtitle) LIKE '%photon-photon interactions%'
      OR LOWER(publication.itemtitle) LIKE '%photon pair generation%'
      OR LOWER(publication.itemtitle) LIKE '%photon pair generations%'
      OR LOWER(publication.itemtitle) LIKE '%photon-pair generation%'
      OR LOWER(publication.itemtitle) LIKE '%photon-pair generations%'
      OR LOWER(publication.itemtitle) LIKE '%multiphoton entangled%'
      OR LOWER(publication.itemtitle) LIKE '%polarization-entangled%'
      OR LOWER(publication.itemtitle) LIKE '%three-photon quantum%'
      OR LOWER(publication.itemtitle) LIKE '%three-photon entangled%'
      OR LOWER(publication.itemtitle) LIKE '%two-photon interference%'
      OR LOWER(publication.itemtitle) LIKE '%hyper-entangled photons%'
      OR LOWER(publication.itemtitle) LIKE '%multi-qubit quantum%'
      OR LOWER(publication.itemtitle) LIKE '%spontaneous parametric down-conversion%'
      OR LOWER(publication.itemtitle) LIKE '%hong–ou–mandel interference%'
      OR LOWER(publication.itemtitle) LIKE '%photon pairs generated%'
      OR LOWER(publication.itemtitle) LIKE '%photon-pair source%'
      OR LOWER(publication.itemtitle) LIKE '%high-dimensional quantum states%'
      OR LOWER(publication.itemtitle) LIKE '%bell state preparation%'
      OR LOWER(publication.itemtitle) LIKE '%non-zero discord bipartite state%'))"
  ))
publication_qc111 <- dbFetch(publication_qc111.SQL, n=-1)
length(unique(publication_qc111$pubid)) # 9,232
save(publication_qc111, file="R file/publication_qc111.RData")
rm(publication_qc111, publication_qc111.SQL)

########################################
keywords_qc112.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos2024.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%'
      OR LOWER(keywords.keyword) LIKE '%qubit%'
    )
    AND (
      LOWER(keywords.keyword) LIKE '%transmon qubit%'
      OR LOWER(keywords.keyword) LIKE '%hybrid qubit%'
      OR LOWER(keywords.keyword) LIKE '%singlet-triplet qubits%'
      OR LOWER(keywords.keyword) LIKE '%defect qubits%'
      OR LOWER(keywords.keyword) LIKE '%hybrid qubit in a gaas%'
    )"
  ))
keywords_qc112 <- dbFetch(keywords_qc112.SQL, n=-1)
length(unique(keywords_qc112$pubid)) # 12
save(keywords_qc112, file="R file/keywords_qc112.RData")
rm(keywords_qc112, keywords_qc112.SQL)

publication_qc112.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      LOWER(publication.abstract) LIKE '%quantum%'
      OR LOWER(publication.abstract) LIKE '%qubit%'
    )
    AND (
      LOWER(publication.abstract) LIKE '%transmon qubit%'
      OR LOWER(publication.abstract) LIKE '%hybrid qubit%'
      OR LOWER(publication.abstract) LIKE '%singlet-triplet qubits%'
      OR LOWER(publication.abstract) LIKE '%defect qubits%'
      OR LOWER(publication.abstract) LIKE '%hybrid qubit in a gaas%'
    )) 
    OR 
    ((
      LOWER(publication.itemtitle) LIKE '%quantum%'
      OR LOWER(publication.itemtitle) LIKE '%qubit%'
    )
    AND (
      LOWER(publication.itemtitle) LIKE '%transmon qubit%'
      OR LOWER(publication.itemtitle) LIKE '%hybrid qubit%'
      OR LOWER(publication.itemtitle) LIKE '%singlet-triplet qubits%'
      OR LOWER(publication.itemtitle) LIKE '%defect qubits%'
      OR LOWER(publication.itemtitle) LIKE '%hybrid qubit in a gaas%'
    ))"
  ))
publication_qc112 <- dbFetch(publication_qc112.SQL, n=-1)
length(unique(publication_qc112$pubid)) # 530
save(publication_qc112, file="R file/publication_qc112.RData")
rm(publication_qc112, publication_qc112.SQL)

########################################
keywords_qc113.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%'
      OR LOWER(keywords.keyword) LIKE '%qubit%'
    )
    AND (
      LOWER(keywords.keyword) LIKE '%greenberger–horne–zeilinger%'
      OR LOWER(keywords.keyword) LIKE '%swap%'
      OR LOWER(keywords.keyword) LIKE '%controlled-swap%'
      OR LOWER(keywords.keyword) LIKE '%controlled-not%'
    )"  
  ))
keywords_qc113 <- dbFetch(keywords_qc113.SQL, n=-1)
length(unique(keywords_qc113$pubid)) # 9
save(keywords_qc113, file="R file/keywords_qc113.RData")
rm(keywords_qc113, keywords_qc113.SQL)

publication_qc113.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      LOWER(publication.abstract) LIKE '%quantum%'
      OR LOWER(publication.abstract) LIKE '%qubit%'
    )
    AND (
      LOWER(publication.abstract) LIKE '%greenberger–horne–zeilinger%'
      OR LOWER(publication.abstract) LIKE '%swap%'
      OR LOWER(publication.abstract) LIKE '%controlled-swap%'
      OR LOWER(publication.abstract) LIKE '%controlled-not%'
    )) 
    OR
    ((
      LOWER(publication.itemtitle) LIKE '%quantum%'
      OR LOWER(publication.itemtitle) LIKE '%qubit%'
    )
    AND (
      LOWER(publication.itemtitle) LIKE '%greenberger–horne–zeilinger%'
      OR LOWER(publication.itemtitle) LIKE '%swap%'
      OR LOWER(publication.itemtitle) LIKE '%controlled-swap%'
      OR LOWER(publication.itemtitle) LIKE '%controlled-not%'
    ))"  
  ))
publication_qc113 <- dbFetch(publication_qc113.SQL, n=-1)
length(unique(publication_qc113$pubid)) # 2391
save(publication_qc113, file="R file/publication_qc113.RData")
rm(publication_qc113, publication_qc113.SQL)

########################################
keywords_qc121.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (LOWER(keywords.keyword) LIKE '%quantum computing%'
           OR LOWER(keywords.keyword) LIKE '%quantum computer%'
           OR LOWER(keywords.keyword) LIKE '%quantum computers%'
           OR LOWER(keywords.keyword) LIKE '%quantum processor%'
           OR LOWER(keywords.keyword) LIKE '%quantum processors%'
           OR LOWER(keywords.keyword) LIKE '%quantum device%'
           OR LOWER(keywords.keyword) LIKE '%quantum devices%'
           OR LOWER(keywords.keyword) LIKE '%quantum hardware%'
           OR LOWER(keywords.keyword) LIKE '%quantum hardwares%'
           OR LOWER(keywords.keyword) LIKE '%quantum information technology%'
           OR LOWER(keywords.keyword) LIKE '%quantum information technologies%'
           OR LOWER(keywords.keyword) LIKE '%quanatum information processing%'
           OR LOWER(keywords.keyword) LIKE '%nisq computer%'
           OR LOWER(keywords.keyword) LIKE '%nisq computers%'
           OR LOWER(keywords.keyword) LIKE '%nisq computing%'
           OR LOWER(keywords.keyword) LIKE '%nisq processor%'
           OR LOWER(keywords.keyword) LIKE '%nisq processors%')
    AND (LOWER(keywords.keyword) LIKE '%two qubits%'
         OR LOWER(keywords.keyword) LIKE '%three qubits%'
         OR LOWER(keywords.keyword) LIKE '%multiple qubits%'
         OR LOWER(keywords.keyword) LIKE '%two quantum bits%'
         OR LOWER(keywords.keyword) LIKE '%three quantum bits%'
         OR LOWER(keywords.keyword) LIKE '%multiple quantum bits%'
         OR LOWER(keywords.keyword) LIKE '%many qubits%'
         OR LOWER(keywords.keyword) LIKE '%large number of qubits%'
         OR LOWER(keywords.keyword) LIKE '%multiple qudits%'
         OR LOWER(keywords.keyword) LIKE '%multiple qumodes%'
         OR LOWER(keywords.keyword) LIKE '%multiple quantum states%'
         OR LOWER(keywords.keyword) LIKE '%many quantum states%'
         OR LOWER(keywords.keyword) LIKE '%multipartite entanglement%'
         OR LOWER(keywords.keyword) LIKE '%multiparty entanglement%'
         OR LOWER(keywords.keyword) LIKE '%entangled quantum states%'
         OR LOWER(keywords.keyword) LIKE '%entangled states%'
         OR LOWER(keywords.keyword) LIKE '%entangled qubits%'
         OR LOWER(keywords.keyword) LIKE '%entangled qudits%'
         OR LOWER(keywords.keyword) LIKE '%entangled qumodes%'
         OR LOWER(keywords.keyword) LIKE '%two-qubit%'
         OR LOWER(keywords.keyword) LIKE '%three-qubit%'
         OR LOWER(keywords.keyword) LIKE '%multi-qubit%'
         OR LOWER(keywords.keyword) LIKE '%two-qudit%'
         OR LOWER(keywords.keyword) LIKE '%three-qudit%'
         OR LOWER(keywords.keyword) LIKE '%multi-qudit%'
         OR LOWER(keywords.keyword) LIKE '%two-qumode%'
         OR LOWER(keywords.keyword) LIKE '%three-qumode%'
         OR LOWER(keywords.keyword) LIKE '%multi-qumode%')
    AND (LOWER(keywords.keyword) LIKE '%measure%'
         OR LOWER(keywords.keyword) LIKE '%detect%'
         OR LOWER(keywords.keyword) LIKE '%characteri%'
         OR LOWER(keywords.keyword) LIKE '%diagnos%'
         OR LOWER(keywords.keyword) LIKE '%examin%'
         OR LOWER(keywords.keyword) LIKE '%estimati%'
         OR LOWER(keywords.keyword) LIKE '%identif%'
         OR LOWER(keywords.keyword) LIKE '%verif%'
         OR LOWER(keywords.keyword) LIKE '%certif%')
    AND NOT (LOWER(keywords.keyword) LIKE '%quantum communication%'
             OR LOWER(keywords.keyword) LIKE '%quantum cryptography%'
             OR LOWER(keywords.keyword) LIKE '%quantum-inspired%'
             OR LOWER(keywords.keyword) LIKE '%quantum-assisted%'
             OR LOWER(keywords.keyword) LIKE '%quanutm-powered%'
             OR LOWER(keywords.keyword) LIKE '%quantum inspired%'
             OR LOWER(keywords.keyword) LIKE '%quantum assisted%'
             OR LOWER(keywords.keyword) LIKE '%quantum powered%'
             OR LOWER(keywords.keyword) LIKE '%quantum algorithm%'
             OR LOWER(keywords.keyword) LIKE '%variational quantum%'
             OR LOWER(keywords.keyword) LIKE '%topological insulators%'
             OR LOWER(keywords.keyword) LIKE '%postquantum%')"
  ))
keywords_qc121 <- dbFetch(keywords_qc121.SQL, n=-1)
length(unique(keywords_qc121$pubid)) # 0
save(keywords_qc121, file="R file/keywords_qc121.RData")
rm(keywords_qc121, keywords_qc121.SQL)

publication_qc121.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((LOWER(publication.abstract) LIKE '%quantum computing%'
           OR LOWER(publication.abstract) LIKE '%quantum computer%'
           OR LOWER(publication.abstract) LIKE '%quantum computers%'
           OR LOWER(publication.abstract) LIKE '%quantum processor%'
           OR LOWER(publication.abstract) LIKE '%quantum processors%'
           OR LOWER(publication.abstract) LIKE '%quantum device%'
           OR LOWER(publication.abstract) LIKE '%quantum devices%'
           OR LOWER(publication.abstract) LIKE '%quantum hardware%'
           OR LOWER(publication.abstract) LIKE '%quantum hardwares%'
           OR LOWER(publication.abstract) LIKE '%quantum information technology%'
           OR LOWER(publication.abstract) LIKE '%quantum information technologies%'
           OR LOWER(publication.abstract) LIKE '%quanatum information processing%'
           OR LOWER(publication.abstract) LIKE '%nisq computer%'
           OR LOWER(publication.abstract) LIKE '%nisq computers%'
           OR LOWER(publication.abstract) LIKE '%nisq computing%'
           OR LOWER(publication.abstract) LIKE '%nisq processor%'
           OR LOWER(publication.abstract) LIKE '%nisq processors%')
    AND (LOWER(publication.abstract) LIKE '%two qubits%'
         OR LOWER(publication.abstract) LIKE '%three qubits%'
         OR LOWER(publication.abstract) LIKE '%multiple qubits%'
         OR LOWER(publication.abstract) LIKE '%two quantum bits%'
         OR LOWER(publication.abstract) LIKE '%three quantum bits%'
         OR LOWER(publication.abstract) LIKE '%multiple quantum bits%'
         OR LOWER(publication.abstract) LIKE '%many qubits%'
         OR LOWER(publication.abstract) LIKE '%large number of qubits%'
         OR LOWER(publication.abstract) LIKE '%multiple qudits%'
         OR LOWER(publication.abstract) LIKE '%multiple qumodes%'
         OR LOWER(publication.abstract) LIKE '%multiple quantum states%'
         OR LOWER(publication.abstract) LIKE '%many quantum states%'
         OR LOWER(publication.abstract) LIKE '%multipartite entanglement%'
         OR LOWER(publication.abstract) LIKE '%multiparty entanglement%'
         OR LOWER(publication.abstract) LIKE '%entangled quantum states%'
         OR LOWER(publication.abstract) LIKE '%entangled states%'
         OR LOWER(publication.abstract) LIKE '%entangled qubits%'
         OR LOWER(publication.abstract) LIKE '%entangled qudits%'
         OR LOWER(publication.abstract) LIKE '%entangled qumodes%'
         OR LOWER(publication.abstract) LIKE '%two-qubit%'
         OR LOWER(publication.abstract) LIKE '%three-qubit%'
         OR LOWER(publication.abstract) LIKE '%multi-qubit%'
         OR LOWER(publication.abstract) LIKE '%two-qudit%'
         OR LOWER(publication.abstract) LIKE '%three-qudit%'
         OR LOWER(publication.abstract) LIKE '%multi-qudit%'
         OR LOWER(publication.abstract) LIKE '%two-qumode%'
         OR LOWER(publication.abstract) LIKE '%three-qumode%'
         OR LOWER(publication.abstract) LIKE '%multi-qumode%')
    AND (LOWER(publication.abstract) LIKE '%measure%'
         OR LOWER(publication.abstract) LIKE '%detect%'
         OR LOWER(publication.abstract) LIKE '%characteri%'
         OR LOWER(publication.abstract) LIKE '%diagnos%'
         OR LOWER(publication.abstract) LIKE '%examin%'
         OR LOWER(publication.abstract) LIKE '%estimati%'
         OR LOWER(publication.abstract) LIKE '%identif%'
         OR LOWER(publication.abstract) LIKE '%verif%'
         OR LOWER(publication.abstract) LIKE '%certif%')
    AND NOT (LOWER(publication.abstract) LIKE '%quantum communication%'
             OR LOWER(publication.abstract) LIKE '%quantum cryptography%'
             OR LOWER(publication.abstract) LIKE '%quantum-inspired%'
             OR LOWER(publication.abstract) LIKE '%quantum-assisted%'
             OR LOWER(publication.abstract) LIKE '%quanutm-powered%'
             OR LOWER(publication.abstract) LIKE '%quantum inspired%'
             OR LOWER(publication.abstract) LIKE '%quantum assisted%'
             OR LOWER(publication.abstract) LIKE '%quantum powered%'
             OR LOWER(publication.abstract) LIKE '%quantum algorithm%'
             OR LOWER(publication.abstract) LIKE '%variational quantum%'
             OR LOWER(publication.abstract) LIKE '%topological insulators%'
             OR LOWER(publication.abstract) LIKE '%postquantum%'
             ))
             OR 
    ((LOWER(publication.itemtitle) LIKE '%quantum computing%'
           OR LOWER(publication.itemtitle) LIKE '%quantum computer%'
           OR LOWER(publication.itemtitle) LIKE '%quantum computers%'
           OR LOWER(publication.itemtitle) LIKE '%quantum processor%'
           OR LOWER(publication.itemtitle) LIKE '%quantum processors%'
           OR LOWER(publication.itemtitle) LIKE '%quantum device%'
           OR LOWER(publication.itemtitle) LIKE '%quantum devices%'
           OR LOWER(publication.itemtitle) LIKE '%quantum hardware%'
           OR LOWER(publication.itemtitle) LIKE '%quantum hardwares%'
           OR LOWER(publication.itemtitle) LIKE '%quantum information technology%'
           OR LOWER(publication.itemtitle) LIKE '%quantum information technologies%'
           OR LOWER(publication.itemtitle) LIKE '%quanatum information processing%'
           OR LOWER(publication.itemtitle) LIKE '%nisq computer%'
           OR LOWER(publication.itemtitle) LIKE '%nisq computers%'
           OR LOWER(publication.itemtitle) LIKE '%nisq computing%'
           OR LOWER(publication.itemtitle) LIKE '%nisq processor%'
           OR LOWER(publication.itemtitle) LIKE '%nisq processors%')
    AND (LOWER(publication.itemtitle) LIKE '%two qubits%'
         OR LOWER(publication.itemtitle) LIKE '%three qubits%'
         OR LOWER(publication.itemtitle) LIKE '%multiple qubits%'
         OR LOWER(publication.itemtitle) LIKE '%two quantum bits%'
         OR LOWER(publication.itemtitle) LIKE '%three quantum bits%'
         OR LOWER(publication.itemtitle) LIKE '%multiple quantum bits%'
         OR LOWER(publication.itemtitle) LIKE '%many qubits%'
         OR LOWER(publication.itemtitle) LIKE '%large number of qubits%'
         OR LOWER(publication.itemtitle) LIKE '%multiple qudits%'
         OR LOWER(publication.itemtitle) LIKE '%multiple qumodes%'
         OR LOWER(publication.itemtitle) LIKE '%multiple quantum states%'
         OR LOWER(publication.itemtitle) LIKE '%many quantum states%'
         OR LOWER(publication.itemtitle) LIKE '%multipartite entanglement%'
         OR LOWER(publication.itemtitle) LIKE '%multiparty entanglement%'
         OR LOWER(publication.itemtitle) LIKE '%entangled quantum states%'
         OR LOWER(publication.itemtitle) LIKE '%entangled states%'
         OR LOWER(publication.itemtitle) LIKE '%entangled qubits%'
         OR LOWER(publication.itemtitle) LIKE '%entangled qudits%'
         OR LOWER(publication.itemtitle) LIKE '%entangled qumodes%'
         OR LOWER(publication.itemtitle) LIKE '%two-qubit%'
         OR LOWER(publication.itemtitle) LIKE '%three-qubit%'
         OR LOWER(publication.itemtitle) LIKE '%multi-qubit%'
         OR LOWER(publication.itemtitle) LIKE '%two-qudit%'
         OR LOWER(publication.itemtitle) LIKE '%three-qudit%'
         OR LOWER(publication.itemtitle) LIKE '%multi-qudit%'
         OR LOWER(publication.itemtitle) LIKE '%two-qumode%'
         OR LOWER(publication.itemtitle) LIKE '%three-qumode%'
         OR LOWER(publication.itemtitle) LIKE '%multi-qumode%')
    AND (LOWER(publication.itemtitle) LIKE '%measure%'
         OR LOWER(publication.itemtitle) LIKE '%detect%'
         OR LOWER(publication.itemtitle) LIKE '%characteri%'
         OR LOWER(publication.itemtitle) LIKE '%diagnos%'
         OR LOWER(publication.itemtitle) LIKE '%examin%'
         OR LOWER(publication.itemtitle) LIKE '%estimati%'
         OR LOWER(publication.itemtitle) LIKE '%identif%'
         OR LOWER(publication.itemtitle) LIKE '%verif%'
         OR LOWER(publication.itemtitle) LIKE '%certif%')
    AND NOT (LOWER(publication.itemtitle) LIKE '%quantum communication%'
             OR LOWER(publication.itemtitle) LIKE '%quantum cryptography%'
             OR LOWER(publication.itemtitle) LIKE '%quantum-inspired%'
             OR LOWER(publication.itemtitle) LIKE '%quantum-assisted%'
             OR LOWER(publication.itemtitle) LIKE '%quanutm-powered%'
             OR LOWER(publication.itemtitle) LIKE '%quantum inspired%'
             OR LOWER(publication.itemtitle) LIKE '%quantum assisted%'
             OR LOWER(publication.itemtitle) LIKE '%quantum powered%'
             OR LOWER(publication.itemtitle) LIKE '%quantum algorithm%'
             OR LOWER(publication.itemtitle) LIKE '%variational quantum%'
             OR LOWER(publication.itemtitle) LIKE '%topological insulators%'
             OR LOWER(publication.itemtitle) LIKE '%postquantum%'))"
  ))
publication_qc121 <- dbFetch(publication_qc121.SQL, n=-1)
length(unique(publication_qc121$pubid)) # 437
save(publication_qc121, file="R file/publication_qc121.RData")
rm(publication_qc121, publication_qc121.SQL)

########################################

keywords_qc122.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%quantum computers%' OR
        LOWER(keywords.keyword) LIKE '%quantum processor%' OR
        LOWER(keywords.keyword) LIKE '%quantum processors%' OR
        LOWER(keywords.keyword) LIKE '%nisq computer%' OR
        LOWER(keywords.keyword) LIKE '%nisq computers%' OR
        LOWER(keywords.keyword) LIKE '%nisq computing%' OR
        LOWER(keywords.keyword) LIKE '%nisq processor%' OR
        LOWER(keywords.keyword) LIKE '%nisq processors%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%two-qubit gate%' OR
        LOWER(keywords.keyword) LIKE '%two-qubit gates%' OR
        LOWER(keywords.keyword) LIKE '%cnot-gate%' OR
        LOWER(keywords.keyword) LIKE '%cnot gate%' OR
        LOWER(keywords.keyword) LIKE '%cnot gates%' OR
        LOWER(keywords.keyword) LIKE '%toffoli-gate%' OR
        LOWER(keywords.keyword) LIKE '%toffoli gate%' OR
        LOWER(keywords.keyword) LIKE '%toffoli gates%' OR
        LOWER(keywords.keyword) LIKE '%controlled-not%' OR
        LOWER(keywords.keyword) LIKE '%controlled-phase%' OR
        LOWER(keywords.keyword) LIKE '%two-qubit quantum gate%' OR
        LOWER(keywords.keyword) LIKE '%three-qubit gate%' OR
        LOWER(keywords.keyword) LIKE '%three-qubit gates%' OR
        LOWER(keywords.keyword) LIKE '%three-qubit quantum gate%' OR
        LOWER(keywords.keyword) LIKE '%multi-qubit gate%' OR
        LOWER(keywords.keyword) LIKE '%multi-qubit gates%' OR
        LOWER(keywords.keyword) LIKE '%multi-qubit quantum gate%' OR
        LOWER(keywords.keyword) LIKE '%multiple-qubit gate%' OR
        LOWER(keywords.keyword) LIKE '%multiple-qubit gates%' OR
        LOWER(keywords.keyword) LIKE '%multiple-qubit quantum gate%' OR
        LOWER(keywords.keyword) LIKE '%multiple-qubit quantum gates%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%control%' OR
        LOWER(keywords.keyword) LIKE '%operat%' OR
        LOWER(keywords.keyword) LIKE '%manipulat%' OR
        LOWER(keywords.keyword) LIKE '%feedback%' OR
        LOWER(keywords.keyword) LIKE '%feedforward%' OR
        LOWER(keywords.keyword) LIKE '%generat%' OR
        LOWER(keywords.keyword) LIKE '%calibrat%' OR
        LOWER(keywords.keyword) LIKE '%tune-up%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%quantum communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
        LOWER(keywords.keyword) LIKE '%quantum simulation%' OR
        LOWER(keywords.keyword) LIKE '%quantum-inspired%' OR
        LOWER(keywords.keyword) LIKE '%quantum-assisted%' OR
        LOWER(keywords.keyword) LIKE '%quantum-powered%' OR
        LOWER(keywords.keyword) LIKE '%quantum algorithm%' OR
        LOWER(keywords.keyword) LIKE '%variational quantum%' OR
        LOWER(keywords.keyword) LIKE '%topological insulators%' OR
        LOWER(keywords.keyword) LIKE '%postquantum%'
      ))"
  ))
keywords_qc122 <- dbFetch(keywords_qc122.SQL, n=-1)
length(unique(keywords_qc122$pubid)) # 0
save(keywords_qc122, file="R file/keywords_qc122.RData")
rm(keywords_qc122, keywords_qc122.SQL)

publication_qc122.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%quantum computers%' OR
        LOWER(publication.abstract) LIKE '%quantum processor%' OR
        LOWER(publication.abstract) LIKE '%quantum processors%' OR
        LOWER(publication.abstract) LIKE '%nisq computer%' OR
        LOWER(publication.abstract) LIKE '%nisq computers%' OR
        LOWER(publication.abstract) LIKE '%nisq computing%' OR
        LOWER(publication.abstract) LIKE '%nisq processor%' OR
        LOWER(publication.abstract) LIKE '%nisq processors%'
      ) AND (
        LOWER(publication.abstract) LIKE '%two-qubit gate%' OR
        LOWER(publication.abstract) LIKE '%two-qubit gates%' OR
        LOWER(publication.abstract) LIKE '%cnot-gate%' OR
        LOWER(publication.abstract) LIKE '%cnot gate%' OR
        LOWER(publication.abstract) LIKE '%cnot gates%' OR
        LOWER(publication.abstract) LIKE '%toffoli-gate%' OR
        LOWER(publication.abstract) LIKE '%toffoli gate%' OR
        LOWER(publication.abstract) LIKE '%toffoli gates%' OR
        LOWER(publication.abstract) LIKE '%controlled-not%' OR
        LOWER(publication.abstract) LIKE '%controlled-phase%' OR
        LOWER(publication.abstract) LIKE '%two-qubit quantum gate%' OR
        LOWER(publication.abstract) LIKE '%three-qubit gate%' OR
        LOWER(publication.abstract) LIKE '%three-qubit gates%' OR
        LOWER(publication.abstract) LIKE '%three-qubit quantum gate%' OR
        LOWER(publication.abstract) LIKE '%multi-qubit gate%' OR
        LOWER(publication.abstract) LIKE '%multi-qubit gates%' OR
        LOWER(publication.abstract) LIKE '%multi-qubit quantum gate%' OR
        LOWER(publication.abstract) LIKE '%multiple-qubit gate%' OR
        LOWER(publication.abstract) LIKE '%multiple-qubit gates%' OR
        LOWER(publication.abstract) LIKE '%multiple-qubit quantum gate%' OR
        LOWER(publication.abstract) LIKE '%multiple-qubit quantum gates%'
      ) AND (
        LOWER(publication.abstract) LIKE '%control%' OR
        LOWER(publication.abstract) LIKE '%operat%' OR
        LOWER(publication.abstract) LIKE '%manipulat%' OR
        LOWER(publication.abstract) LIKE '%feedback%' OR
        LOWER(publication.abstract) LIKE '%feedforward%' OR
        LOWER(publication.abstract) LIKE '%generat%' OR
        LOWER(publication.abstract) LIKE '%calibrat%' OR
        LOWER(publication.abstract) LIKE '%tune-up%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%quantum communication%' OR
        LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
        LOWER(publication.abstract) LIKE '%quantum simulation%' OR
        LOWER(publication.abstract) LIKE '%quantum-inspired%' OR
        LOWER(publication.abstract) LIKE '%quantum-assisted%' OR
        LOWER(publication.abstract) LIKE '%quantum-powered%' OR
        LOWER(publication.abstract) LIKE '%quantum algorithm%' OR
        LOWER(publication.abstract) LIKE '%variational quantum%' OR
        LOWER(publication.abstract) LIKE '%topological insulators%' OR
        LOWER(publication.abstract) LIKE '%postquantum%'
      )) 
      OR
    ((
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computers%' OR
        LOWER(publication.itemtitle) LIKE '%quantum processor%' OR
        LOWER(publication.itemtitle) LIKE '%quantum processors%' OR
        LOWER(publication.itemtitle) LIKE '%nisq computer%' OR
        LOWER(publication.itemtitle) LIKE '%nisq computers%' OR
        LOWER(publication.itemtitle) LIKE '%nisq computing%' OR
        LOWER(publication.itemtitle) LIKE '%nisq processor%' OR
        LOWER(publication.itemtitle) LIKE '%nisq processors%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%two-qubit gate%' OR
        LOWER(publication.itemtitle) LIKE '%two-qubit gates%' OR
        LOWER(publication.itemtitle) LIKE '%cnot-gate%' OR
        LOWER(publication.itemtitle) LIKE '%cnot gate%' OR
        LOWER(publication.itemtitle) LIKE '%cnot gates%' OR
        LOWER(publication.itemtitle) LIKE '%toffoli-gate%' OR
        LOWER(publication.itemtitle) LIKE '%toffoli gate%' OR
        LOWER(publication.itemtitle) LIKE '%toffoli gates%' OR
        LOWER(publication.itemtitle) LIKE '%controlled-not%' OR
        LOWER(publication.itemtitle) LIKE '%controlled-phase%' OR
        LOWER(publication.itemtitle) LIKE '%two-qubit quantum gate%' OR
        LOWER(publication.itemtitle) LIKE '%three-qubit gate%' OR
        LOWER(publication.itemtitle) LIKE '%three-qubit gates%' OR
        LOWER(publication.itemtitle) LIKE '%three-qubit quantum gate%' OR
        LOWER(publication.itemtitle) LIKE '%multi-qubit gate%' OR
        LOWER(publication.itemtitle) LIKE '%multi-qubit gates%' OR
        LOWER(publication.itemtitle) LIKE '%multi-qubit quantum gate%' OR
        LOWER(publication.itemtitle) LIKE '%multiple-qubit gate%' OR
        LOWER(publication.itemtitle) LIKE '%multiple-qubit gates%' OR
        LOWER(publication.itemtitle) LIKE '%multiple-qubit quantum gate%' OR
        LOWER(publication.itemtitle) LIKE '%multiple-qubit quantum gates%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%control%' OR
        LOWER(publication.itemtitle) LIKE '%operat%' OR
        LOWER(publication.itemtitle) LIKE '%manipulat%' OR
        LOWER(publication.itemtitle) LIKE '%feedback%' OR
        LOWER(publication.itemtitle) LIKE '%feedforward%' OR
        LOWER(publication.itemtitle) LIKE '%generat%' OR
        LOWER(publication.itemtitle) LIKE '%calibrat%' OR
        LOWER(publication.itemtitle) LIKE '%tune-up%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%quantum simulation%' OR
        LOWER(publication.itemtitle) LIKE '%quantum-inspired%' OR
        LOWER(publication.itemtitle) LIKE '%quantum-assisted%' OR
        LOWER(publication.itemtitle) LIKE '%quantum-powered%' OR
        LOWER(publication.itemtitle) LIKE '%quantum algorithm%' OR
        LOWER(publication.itemtitle) LIKE '%variational quantum%' OR
        LOWER(publication.itemtitle) LIKE '%topological insulators%' OR
        LOWER(publication.itemtitle) LIKE '%postquantum%'
      ))"
  ))
publication_qc122 <- dbFetch(publication_qc122.SQL, n=-1)
length(unique(publication_qc122$pubid)) # 401
save(publication_qc122, file="R file/publication_qc122.RData")
rm(publication_qc122, publication_qc122.SQL)

########################################

keywords_qc123.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (((
        LOWER(keywords.keyword) LIKE '%full stack quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%full-stack quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%full stack quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%full stack quantum computers%' OR
        LOWER(keywords.keyword) LIKE '%full-stack quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%full-stack quantum computers%' OR
        LOWER(keywords.keyword) LIKE '%full stack quantum processor%' OR
        LOWER(keywords.keyword) LIKE '%full-stack quantum processor%' OR
        LOWER(keywords.keyword) LIKE '%full tack quantum processors%' OR
        LOWER(keywords.keyword) LIKE '%quantum computing architecture%' OR
        LOWER(keywords.keyword) LIKE '%quantum computing architectures%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer architectures%'
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%quantum computing%' OR
          LOWER(keywords.keyword) LIKE '%quantum computer%' OR
          LOWER(keywords.keyword) LIKE '%quantum computers%' OR
          LOWER(keywords.keyword) LIKE '%quantum processor%' OR
          LOWER(keywords.keyword) LIKE '%quantum processors%' OR
          LOWER(keywords.keyword) LIKE '%nisq computer%' OR
          LOWER(keywords.keyword) LIKE '%nisq computers%' OR
          LOWER(keywords.keyword) LIKE '%nisq computing%' OR
          LOWER(keywords.keyword) LIKE '%nisq processor%' OR
          LOWER(keywords.keyword) LIKE '%nisq processors%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%fast%' OR
          LOWER(keywords.keyword) LIKE '%ultrafast%' OR
          LOWER(keywords.keyword) LIKE '%ultra-fast%' OR
          LOWER(keywords.keyword) LIKE '%high-speed%' OR
          LOWER(keywords.keyword) LIKE '%high-perform%' OR
          LOWER(keywords.keyword) LIKE '%speedup%' OR
          LOWER(keywords.keyword) LIKE '%autonomous%' OR
          LOWER(keywords.keyword) LIKE '%learning-based%' OR
          LOWER(keywords.keyword) LIKE '%learning based%'
        )
      ) AND (
        LOWER(keywords.keyword) LIKE '%control%' OR
        LOWER(keywords.keyword) LIKE '%operat%' OR
        LOWER(keywords.keyword) LIKE '%manipulat%' OR
        LOWER(keywords.keyword) LIKE '%feedback%' OR
        LOWER(keywords.keyword) LIKE '%feedforward%' OR
        LOWER(keywords.keyword) LIKE '%characteri%' OR
        LOWER(keywords.keyword) LIKE '%diagnos%' OR
        LOWER(keywords.keyword) LIKE '%stabil%' OR
        LOWER(keywords.keyword) LIKE '%calibrat%' OR
        LOWER(keywords.keyword) LIKE '%automati%' OR
        LOWER(keywords.keyword) LIKE '%tune-up%'
      ) OR LOWER(keywords.keyword) LIKE '%quantum firmware%' OR
      LOWER(keywords.keyword) LIKE '%quantum middleware%'
    ) AND NOT (
      LOWER(keywords.keyword) LIKE '%quantum communication%' OR
      LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
      LOWER(keywords.keyword) LIKE '%quantum simulation%' OR
      LOWER(keywords.keyword) LIKE '%quantum-inspired%' OR
      LOWER(keywords.keyword) LIKE '%quantum-assisted%' OR
      LOWER(keywords.keyword) LIKE '%quantum-enhanced%' OR
      LOWER(keywords.keyword) LIKE '%quantum-powered%' OR
      LOWER(keywords.keyword) LIKE '%algorithm%' OR
      LOWER(keywords.keyword) LIKE '%variational quantum%' OR
      LOWER(keywords.keyword) LIKE '%topological insulators%' OR
      LOWER(keywords.keyword) LIKE '%postquantum%' OR
      LOWER(keywords.keyword) LIKE '%criticality%' OR
      LOWER(keywords.keyword) LIKE '%human%' OR
      LOWER(keywords.keyword) LIKE '%majorana%'
    ))"
  ))
keywords_qc123 <- dbFetch(keywords_qc123.SQL, n=-1)
length(unique(keywords_qc123$pubid)) # 0
save(keywords_qc123, file="R file/keywords_qc123.RData")
rm(keywords_qc123, keywords_qc123.SQL)

publication_qc123.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (((
        LOWER(publication.abstract) LIKE '%full stack quantum computing%' OR
        LOWER(publication.abstract) LIKE '%full-stack quantum computing%' OR
        LOWER(publication.abstract) LIKE '%full stack quantum computer%' OR
        LOWER(publication.abstract) LIKE '%full stack quantum computers%' OR
        LOWER(publication.abstract) LIKE '%full-stack quantum computer%' OR
        LOWER(publication.abstract) LIKE '%full-stack quantum computers%' OR
        LOWER(publication.abstract) LIKE '%full stack quantum processor%' OR
        LOWER(publication.abstract) LIKE '%full-stack quantum processor%' OR
        LOWER(publication.abstract) LIKE '%full tack quantum processors%' OR
        LOWER(publication.abstract) LIKE '%quantum computing architecture%' OR
        LOWER(publication.abstract) LIKE '%quantum computing architectures%' OR
        LOWER(publication.abstract) LIKE '%quantum computer architectures%'
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%quantum computing%' OR
          LOWER(publication.abstract) LIKE '%quantum computer%' OR
          LOWER(publication.abstract) LIKE '%quantum computers%' OR
          LOWER(publication.abstract) LIKE '%quantum processor%' OR
          LOWER(publication.abstract) LIKE '%quantum processors%' OR
          LOWER(publication.abstract) LIKE '%nisq computer%' OR
          LOWER(publication.abstract) LIKE '%nisq computers%' OR
          LOWER(publication.abstract) LIKE '%nisq computing%' OR
          LOWER(publication.abstract) LIKE '%nisq processor%' OR
          LOWER(publication.abstract) LIKE '%nisq processors%'
        ) AND (
          LOWER(publication.abstract) LIKE '%fast%' OR
          LOWER(publication.abstract) LIKE '%ultrafast%' OR
          LOWER(publication.abstract) LIKE '%ultra-fast%' OR
          LOWER(publication.abstract) LIKE '%high-speed%' OR
          LOWER(publication.abstract) LIKE '%high-perform%' OR
          LOWER(publication.abstract) LIKE '%speedup%' OR
          LOWER(publication.abstract) LIKE '%autonomous%' OR
          LOWER(publication.abstract) LIKE '%learning-based%' OR
          LOWER(publication.abstract) LIKE '%learning based%'
        )
      ) AND (
        LOWER(publication.abstract) LIKE '%control%' OR
        LOWER(publication.abstract) LIKE '%operat%' OR
        LOWER(publication.abstract) LIKE '%manipulat%' OR
        LOWER(publication.abstract) LIKE '%feedback%' OR
        LOWER(publication.abstract) LIKE '%feedforward%' OR
        LOWER(publication.abstract) LIKE '%characteri%' OR
        LOWER(publication.abstract) LIKE '%diagnos%' OR
        LOWER(publication.abstract) LIKE '%stabil%' OR
        LOWER(publication.abstract) LIKE '%calibrat%' OR
        LOWER(publication.abstract) LIKE '%automati%' OR
        LOWER(publication.abstract) LIKE '%tune-up%'
      ) OR LOWER(publication.abstract) LIKE '%quantum firmware%' OR
      LOWER(publication.abstract) LIKE '%quantum middleware%'
    ) AND NOT (
      LOWER(publication.abstract) LIKE '%quantum communication%' OR
      LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
      LOWER(publication.abstract) LIKE '%quantum simulation%' OR
      LOWER(publication.abstract) LIKE '%quantum-inspired%' OR
      LOWER(publication.abstract) LIKE '%quantum-assisted%' OR
      LOWER(publication.abstract) LIKE '%quantum-enhanced%' OR
      LOWER(publication.abstract) LIKE '%quantum-powered%' OR
      LOWER(publication.abstract) LIKE '%algorithm%' OR
      LOWER(publication.abstract) LIKE '%variational quantum%' OR
      LOWER(publication.abstract) LIKE '%topological insulators%' OR
      LOWER(publication.abstract) LIKE '%postquantum%' OR
      LOWER(publication.abstract) LIKE '%criticality%' OR
      LOWER(publication.abstract) LIKE '%human%' OR
      LOWER(publication.abstract) LIKE '%majorana%'
    )) 
    OR
    (((
        LOWER(publication.itemtitle) LIKE '%full stack quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%full-stack quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%full stack quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%full stack quantum computers%' OR
        LOWER(publication.itemtitle) LIKE '%full-stack quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%full-stack quantum computers%' OR
        LOWER(publication.itemtitle) LIKE '%full stack quantum processor%' OR
        LOWER(publication.itemtitle) LIKE '%full-stack quantum processor%' OR
        LOWER(publication.itemtitle) LIKE '%full tack quantum processors%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computing architecture%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computing architectures%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer architectures%'
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
          LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
          LOWER(publication.itemtitle) LIKE '%quantum computers%' OR
          LOWER(publication.itemtitle) LIKE '%quantum processor%' OR
          LOWER(publication.itemtitle) LIKE '%quantum processors%' OR
          LOWER(publication.itemtitle) LIKE '%nisq computer%' OR
          LOWER(publication.itemtitle) LIKE '%nisq computers%' OR
          LOWER(publication.itemtitle) LIKE '%nisq computing%' OR
          LOWER(publication.itemtitle) LIKE '%nisq processor%' OR
          LOWER(publication.itemtitle) LIKE '%nisq processors%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%fast%' OR
          LOWER(publication.itemtitle) LIKE '%ultrafast%' OR
          LOWER(publication.itemtitle) LIKE '%ultra-fast%' OR
          LOWER(publication.itemtitle) LIKE '%high-speed%' OR
          LOWER(publication.itemtitle) LIKE '%high-perform%' OR
          LOWER(publication.itemtitle) LIKE '%speedup%' OR
          LOWER(publication.itemtitle) LIKE '%autonomous%' OR
          LOWER(publication.itemtitle) LIKE '%learning-based%' OR
          LOWER(publication.itemtitle) LIKE '%learning based%'
        )
      ) AND (
        LOWER(publication.itemtitle) LIKE '%control%' OR
        LOWER(publication.itemtitle) LIKE '%operat%' OR
        LOWER(publication.itemtitle) LIKE '%manipulat%' OR
        LOWER(publication.itemtitle) LIKE '%feedback%' OR
        LOWER(publication.itemtitle) LIKE '%feedforward%' OR
        LOWER(publication.itemtitle) LIKE '%characteri%' OR
        LOWER(publication.itemtitle) LIKE '%diagnos%' OR
        LOWER(publication.itemtitle) LIKE '%stabil%' OR
        LOWER(publication.itemtitle) LIKE '%calibrat%' OR
        LOWER(publication.itemtitle) LIKE '%automati%' OR
        LOWER(publication.itemtitle) LIKE '%tune-up%'
      ) OR LOWER(publication.itemtitle) LIKE '%quantum firmware%' OR
      LOWER(publication.itemtitle) LIKE '%quantum middleware%'
    ) AND NOT (
      LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
      LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
      LOWER(publication.itemtitle) LIKE '%quantum simulation%' OR
      LOWER(publication.itemtitle) LIKE '%quantum-inspired%' OR
      LOWER(publication.itemtitle) LIKE '%quantum-assisted%' OR
      LOWER(publication.itemtitle) LIKE '%quantum-enhanced%' OR
      LOWER(publication.itemtitle) LIKE '%quantum-powered%' OR
      LOWER(publication.itemtitle) LIKE '%algorithm%' OR
      LOWER(publication.itemtitle) LIKE '%variational quantum%' OR
      LOWER(publication.itemtitle) LIKE '%topological insulators%' OR
      LOWER(publication.itemtitle) LIKE '%postquantum%' OR
      LOWER(publication.itemtitle) LIKE '%criticality%' OR
      LOWER(publication.itemtitle) LIKE '%human%' OR
      LOWER(publication.itemtitle) LIKE '%majorana%'
    ))"
  ))
publication_qc123 <- dbFetch(publication_qc123.SQL, n=-1)
length(unique(publication_qc123$pubid)) # 519
save(publication_qc123, file="R file/publication_qc123.RData")
rm(publication_qc123, publication_qc123.SQL)

########################################

keywords_qc131.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%quantum information%' OR
        LOWER(keywords.keyword) LIKE '%quantum circuit%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%software%' OR
        LOWER(keywords.keyword) LIKE '%programming%' OR
        LOWER(keywords.keyword) LIKE '%circuit synthesis%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%quantum software%' OR
        LOWER(keywords.keyword) LIKE '%quantum programming%' OR
        LOWER(keywords.keyword) LIKE '%stack%' OR
        LOWER(keywords.keyword) LIKE '%compiler%' OR
        LOWER(keywords.keyword) LIKE '%compiling%' OR
        LOWER(keywords.keyword) LIKE '%compilation%' OR
        LOWER(keywords.keyword) LIKE '%transpile%' OR
        LOWER(keywords.keyword) LIKE '%transpiling%' OR
        LOWER(keywords.keyword) LIKE '%transpilation%' OR
        LOWER(keywords.keyword) LIKE '%frontend%' OR
        LOWER(keywords.keyword) LIKE '%backend%' OR
        LOWER(keywords.keyword) LIKE '%quantum firmware%'
      ))"
  ))
keywords_qc131 <- dbFetch(keywords_qc131.SQL, n=-1)
length(unique(keywords_qc131$pubid)) # 0
save(keywords_qc131, file="R file/keywords_qc131.RData")
rm(keywords_qc131, keywords_qc131.SQL)

publication_qc131.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%quantum information%' OR
        LOWER(publication.abstract) LIKE '%quantum circuit%'
      ) AND (
        LOWER(publication.abstract) LIKE '%software%' OR
        LOWER(publication.abstract) LIKE '%programming%' OR
        LOWER(publication.abstract) LIKE '%circuit synthesis%'
      ) AND (
        LOWER(publication.abstract) LIKE '%quantum software%' OR
        LOWER(publication.abstract) LIKE '%quantum programming%' OR
        LOWER(publication.abstract) LIKE '%stack%' OR
        LOWER(publication.abstract) LIKE '%compiler%' OR
        LOWER(publication.abstract) LIKE '%compiling%' OR
        LOWER(publication.abstract) LIKE '%compilation%' OR
        LOWER(publication.abstract) LIKE '%transpile%' OR
        LOWER(publication.abstract) LIKE '%transpiling%' OR
        LOWER(publication.abstract) LIKE '%transpilation%' OR
        LOWER(publication.abstract) LIKE '%frontend%' OR
        LOWER(publication.abstract) LIKE '%backend%' OR
        LOWER(publication.abstract) LIKE '%quantum firmware%'
      ))
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%quantum information%' OR
        LOWER(publication.itemtitle) LIKE '%quantum circuit%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%software%' OR
        LOWER(publication.itemtitle) LIKE '%programming%' OR
        LOWER(publication.itemtitle) LIKE '%circuit synthesis%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%quantum software%' OR
        LOWER(publication.itemtitle) LIKE '%quantum programming%' OR
        LOWER(publication.itemtitle) LIKE '%stack%' OR
        LOWER(publication.itemtitle) LIKE '%compiler%' OR
        LOWER(publication.itemtitle) LIKE '%compiling%' OR
        LOWER(publication.itemtitle) LIKE '%compilation%' OR
        LOWER(publication.itemtitle) LIKE '%transpile%' OR
        LOWER(publication.itemtitle) LIKE '%transpiling%' OR
        LOWER(publication.itemtitle) LIKE '%transpilation%' OR
        LOWER(publication.itemtitle) LIKE '%frontend%' OR
        LOWER(publication.itemtitle) LIKE '%backend%' OR
        LOWER(publication.itemtitle) LIKE '%quantum firmware%'
      ))
    "
  ))
publication_qc131 <- dbFetch(publication_qc131.SQL, n=-1)
length(unique(publication_qc131$pubid)) # 133
save(publication_qc131, file="R file/publication_qc131.RData")
rm(publication_qc131, publication_qc131.SQL)

########################################

keywords_qc132.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum information%' AND
        (
          LOWER(keywords.keyword) LIKE '%information theory%' OR
          LOWER(keywords.keyword) LIKE '%complexity theory%' OR
          LOWER(keywords.keyword) LIKE '%complexity theoretic%' OR
          LOWER(keywords.keyword) LIKE '%computational complexity%' OR
          LOWER(keywords.keyword) LIKE '%bell inequality%'
        )
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%quantum%' OR
          LOWER(keywords.keyword) LIKE 'qubit%'
        ) AND (
          (
            LOWER(keywords.keyword) LIKE '%quantum process tomography%' AND LOWER(keywords.keyword) LIKE '%qubit channel%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum steerability%' AND LOWER(keywords.keyword) LIKE '%quantum correlations%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%entanglement witness%' AND LOWER(keywords.keyword) LIKE '%local measurement%' AND LOWER(keywords.keyword) LIKE '%multipartite systems%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%mutually unbiased bases%' AND LOWER(keywords.keyword) LIKE '%verification of entanglement%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum information processing%' AND LOWER(keywords.keyword) LIKE '%structural physical approximation%'
          ) OR LOWER(keywords.keyword) LIKE '%quantum 2-design%' OR (
            LOWER(keywords.keyword) LIKE '%geometric phase%' AND LOWER(keywords.keyword) LIKE '%quantum measurement back-action%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%geometric extension%' AND LOWER(keywords.keyword) LIKE '%clauser-horne inequality%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%state discrimination%' AND LOWER(keywords.keyword) LIKE '%quantum channels%' AND LOWER(keywords.keyword) LIKE '%quantum entanglement%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum learning speedup%' AND LOWER(keywords.keyword) LIKE '%classical input%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum sensitivity%' AND LOWER(keywords.keyword) LIKE '%decision making machinery%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%tightest conditions%' AND LOWER(keywords.keyword) LIKE '%violating the bell inequality%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%convex minimization%' AND LOWER(keywords.keyword) LIKE '%hermitian operators%' AND LOWER(keywords.keyword) LIKE '%joint measurability%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%area-law bound%' AND LOWER(keywords.keyword) LIKE '%entanglement%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%correlations%' AND LOWER(keywords.keyword) LIKE '%local measurements%' AND LOWER(keywords.keyword) LIKE '%entanglement%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%negative probability%' AND LOWER(keywords.keyword) LIKE '%quantum-measurement%' AND LOWER(keywords.keyword) LIKE '%polarization%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%nonclassicality%' AND LOWER(keywords.keyword) LIKE '%pure dephasing%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%learning%' AND LOWER(keywords.keyword) LIKE '%pure quantum states%' AND LOWER(keywords.keyword) LIKE '%quantum theory%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantifiable simulation%' AND LOWER(keywords.keyword) LIKE '%quantum computation%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum state learning%' AND LOWER(keywords.keyword) LIKE '%single-shot measurements%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%w states%' AND LOWER(keywords.keyword) LIKE '%via quantum erasure%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%svetlichny-zohren-gill%' AND LOWER(keywords.keyword) LIKE '%bell inequalities%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%white noise%' AND LOWER(keywords.keyword) LIKE '%bell inequality%' AND LOWER(keywords.keyword) LIKE '%dimensional systems%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%learning sample complexity%' AND LOWER(keywords.keyword) LIKE '%large classical samples%' AND LOWER(keywords.keyword) LIKE '%small quantum%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%linear optical%' AND LOWER(keywords.keyword) LIKE '%bell state preparation%' AND LOWER(keywords.keyword) LIKE '%measurement%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%sudden death%' AND LOWER(keywords.keyword) LIKE '%steering%' AND LOWER(keywords.keyword) LIKE '%bell nonlocality%'
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum game theory%' AND LOWER(keywords.keyword) LIKE '%decision making%'
          )
        )
      )
    ) AND NOT (
      LOWER(keywords.keyword) LIKE '%experimental quantum%' OR
      LOWER(keywords.keyword) LIKE '%hardware implementation%' OR
      LOWER(keywords.keyword) LIKE '%quantum algorithm%' OR
      LOWER(keywords.keyword) LIKE '%compiler%' OR
      LOWER(keywords.keyword) LIKE '%quantum software%' OR
      LOWER(keywords.keyword) LIKE '%quantum programming%' OR
      LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
      LOWER(keywords.keyword) LIKE '%quantum sensor%' OR
      LOWER(keywords.keyword) LIKE '%communication%' OR
      LOWER(keywords.keyword) LIKE '%cryptography%' OR
      LOWER(keywords.keyword) LIKE '%cryptographic%' OR
      LOWER(keywords.keyword) LIKE '%evolutionary games%'
    ))"
  ))
keywords_qc132 <- dbFetch(keywords_qc132.SQL, n=-1)
length(unique(keywords_qc132$pubid)) # 0
save(keywords_qc132, file="R file/keywords_qc132.RData")
rm(keywords_qc132, keywords_qc132.SQL)

publication_qc132.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum information%' AND
        (
          LOWER(publication.abstract) LIKE '%information theory%' OR
          LOWER(publication.abstract) LIKE '%complexity theory%' OR
          LOWER(publication.abstract) LIKE '%complexity theoretic%' OR
          LOWER(publication.abstract) LIKE '%computational complexity%' OR
          LOWER(publication.abstract) LIKE '%bell inequality%'
        )
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%quantum%' OR
          LOWER(publication.abstract) LIKE 'qubit%'
        ) AND (
          (
            LOWER(publication.abstract) LIKE '%quantum process tomography%' AND LOWER(publication.abstract) LIKE '%qubit channel%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum steerability%' AND LOWER(publication.abstract) LIKE '%quantum correlations%'
          ) OR (
            LOWER(publication.abstract) LIKE '%entanglement witness%' AND LOWER(publication.abstract) LIKE '%local measurement%' AND LOWER(publication.abstract) LIKE '%multipartite systems%'
          ) OR (
            LOWER(publication.abstract) LIKE '%mutually unbiased bases%' AND LOWER(publication.abstract) LIKE '%verification of entanglement%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum information processing%' AND LOWER(publication.abstract) LIKE '%structural physical approximation%'
          ) OR LOWER(publication.abstract) LIKE '%quantum 2-design%' OR (
            LOWER(publication.abstract) LIKE '%geometric phase%' AND LOWER(publication.abstract) LIKE '%quantum measurement back-action%'
          ) OR (
            LOWER(publication.abstract) LIKE '%geometric extension%' AND LOWER(publication.abstract) LIKE '%clauser-horne inequality%'
          ) OR (
            LOWER(publication.abstract) LIKE '%state discrimination%' AND LOWER(publication.abstract) LIKE '%quantum channels%' AND LOWER(publication.abstract) LIKE '%quantum entanglement%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum learning speedup%' AND LOWER(publication.abstract) LIKE '%classical input%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum sensitivity%' AND LOWER(publication.abstract) LIKE '%decision making machinery%'
          ) OR (
            LOWER(publication.abstract) LIKE '%tightest conditions%' AND LOWER(publication.abstract) LIKE '%violating the bell inequality%'
          ) OR (
            LOWER(publication.abstract) LIKE '%convex minimization%' AND LOWER(publication.abstract) LIKE '%hermitian operators%' AND LOWER(publication.abstract) LIKE '%joint measurability%'
          ) OR (
            LOWER(publication.abstract) LIKE '%area-law bound%' AND LOWER(publication.abstract) LIKE '%entanglement%'
          ) OR (
            LOWER(publication.abstract) LIKE '%correlations%' AND LOWER(publication.abstract) LIKE '%local measurements%' AND LOWER(publication.abstract) LIKE '%entanglement%'
          ) OR (
            LOWER(publication.abstract) LIKE '%negative probability%' AND LOWER(publication.abstract) LIKE '%quantum-measurement%' AND LOWER(publication.abstract) LIKE '%polarization%'
          ) OR (
            LOWER(publication.abstract) LIKE '%nonclassicality%' AND LOWER(publication.abstract) LIKE '%pure dephasing%'
          ) OR (
            LOWER(publication.abstract) LIKE '%learning%' AND LOWER(publication.abstract) LIKE '%pure quantum states%' AND LOWER(publication.abstract) LIKE '%quantum theory%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantifiable simulation%' AND LOWER(publication.abstract) LIKE '%quantum computation%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum state learning%' AND LOWER(publication.abstract) LIKE '%single-shot measurements%'
          ) OR (
            LOWER(publication.abstract) LIKE '%w states%' AND LOWER(publication.abstract) LIKE '%via quantum erasure%'
          ) OR (
            LOWER(publication.abstract) LIKE '%svetlichny-zohren-gill%' AND LOWER(publication.abstract) LIKE '%bell inequalities%'
          ) OR (
            LOWER(publication.abstract) LIKE '%white noise%' AND LOWER(publication.abstract) LIKE '%bell inequality%' AND LOWER(publication.abstract) LIKE '%dimensional systems%'
          ) OR (
            LOWER(publication.abstract) LIKE '%learning sample complexity%' AND LOWER(publication.abstract) LIKE '%large classical samples%' AND LOWER(publication.abstract) LIKE '%small quantum%'
          ) OR (
            LOWER(publication.abstract) LIKE '%linear optical%' AND LOWER(publication.abstract) LIKE '%bell state preparation%' AND LOWER(publication.abstract) LIKE '%measurement%'
          ) OR (
            LOWER(publication.abstract) LIKE '%sudden death%' AND LOWER(publication.abstract) LIKE '%steering%' AND LOWER(publication.abstract) LIKE '%bell nonlocality%'
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum game theory%' AND LOWER(publication.abstract) LIKE '%decision making%'
          )
        )
      )
    ) AND NOT (
      LOWER(publication.abstract) LIKE '%experimental quantum%' OR
      LOWER(publication.abstract) LIKE '%hardware implementation%' OR
      LOWER(publication.abstract) LIKE '%quantum algorithm%' OR
      LOWER(publication.abstract) LIKE '%compiler%' OR
      LOWER(publication.abstract) LIKE '%quantum software%' OR
      LOWER(publication.abstract) LIKE '%quantum programming%' OR
      LOWER(publication.abstract) LIKE '%quantum sensing%' OR
      LOWER(publication.abstract) LIKE '%quantum sensor%' OR
      LOWER(publication.abstract) LIKE '%communication%' OR
      LOWER(publication.abstract) LIKE '%cryptography%' OR
      LOWER(publication.abstract) LIKE '%cryptographic%' OR
      LOWER(publication.abstract) LIKE '%evolutionary games%'
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum information%' AND
        (
          LOWER(publication.itemtitle) LIKE '%information theory%' OR
          LOWER(publication.itemtitle) LIKE '%complexity theory%' OR
          LOWER(publication.itemtitle) LIKE '%complexity theoretic%' OR
          LOWER(publication.itemtitle) LIKE '%computational complexity%' OR
          LOWER(publication.itemtitle) LIKE '%bell inequality%'
        )
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%quantum%' OR
          LOWER(publication.itemtitle) LIKE 'qubit%'
        ) AND (
          (
            LOWER(publication.itemtitle) LIKE '%quantum process tomography%' AND LOWER(publication.itemtitle) LIKE '%qubit channel%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum steerability%' AND LOWER(publication.itemtitle) LIKE '%quantum correlations%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%entanglement witness%' AND LOWER(publication.itemtitle) LIKE '%local measurement%' AND LOWER(publication.itemtitle) LIKE '%multipartite systems%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%mutually unbiased bases%' AND LOWER(publication.itemtitle) LIKE '%verification of entanglement%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum information processing%' AND LOWER(publication.itemtitle) LIKE '%structural physical approximation%'
          ) OR LOWER(publication.itemtitle) LIKE '%quantum 2-design%' OR (
            LOWER(publication.itemtitle) LIKE '%geometric phase%' AND LOWER(publication.itemtitle) LIKE '%quantum measurement back-action%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%geometric extension%' AND LOWER(publication.itemtitle) LIKE '%clauser-horne inequality%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%state discrimination%' AND LOWER(publication.itemtitle) LIKE '%quantum channels%' AND LOWER(publication.itemtitle) LIKE '%quantum entanglement%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum learning speedup%' AND LOWER(publication.itemtitle) LIKE '%classical input%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum sensitivity%' AND LOWER(publication.itemtitle) LIKE '%decision making machinery%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%tightest conditions%' AND LOWER(publication.itemtitle) LIKE '%violating the bell inequality%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%convex minimization%' AND LOWER(publication.itemtitle) LIKE '%hermitian operators%' AND LOWER(publication.itemtitle) LIKE '%joint measurability%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%area-law bound%' AND LOWER(publication.itemtitle) LIKE '%entanglement%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%correlations%' AND LOWER(publication.itemtitle) LIKE '%local measurements%' AND LOWER(publication.itemtitle) LIKE '%entanglement%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%negative probability%' AND LOWER(publication.itemtitle) LIKE '%quantum-measurement%' AND LOWER(publication.itemtitle) LIKE '%polarization%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%nonclassicality%' AND LOWER(publication.itemtitle) LIKE '%pure dephasing%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%learning%' AND LOWER(publication.itemtitle) LIKE '%pure quantum states%' AND LOWER(publication.itemtitle) LIKE '%quantum theory%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantifiable simulation%' AND LOWER(publication.itemtitle) LIKE '%quantum computation%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum state learning%' AND LOWER(publication.itemtitle) LIKE '%single-shot measurements%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%w states%' AND LOWER(publication.itemtitle) LIKE '%via quantum erasure%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%svetlichny-zohren-gill%' AND LOWER(publication.itemtitle) LIKE '%bell inequalities%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%white noise%' AND LOWER(publication.itemtitle) LIKE '%bell inequality%' AND LOWER(publication.itemtitle) LIKE '%dimensional systems%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%learning sample complexity%' AND LOWER(publication.itemtitle) LIKE '%large classical samples%' AND LOWER(publication.itemtitle) LIKE '%small quantum%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%linear optical%' AND LOWER(publication.itemtitle) LIKE '%bell state preparation%' AND LOWER(publication.itemtitle) LIKE '%measurement%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%sudden death%' AND LOWER(publication.itemtitle) LIKE '%steering%' AND LOWER(publication.itemtitle) LIKE '%bell nonlocality%'
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum game theory%' AND LOWER(publication.itemtitle) LIKE '%decision making%'
          )
        )
      )
    ) AND NOT (
      LOWER(publication.itemtitle) LIKE '%experimental quantum%' OR
      LOWER(publication.itemtitle) LIKE '%hardware implementation%' OR
      LOWER(publication.itemtitle) LIKE '%quantum algorithm%' OR
      LOWER(publication.itemtitle) LIKE '%compiler%' OR
      LOWER(publication.itemtitle) LIKE '%quantum software%' OR
      LOWER(publication.itemtitle) LIKE '%quantum programming%' OR
      LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
      LOWER(publication.itemtitle) LIKE '%quantum sensor%' OR
      LOWER(publication.itemtitle) LIKE '%communication%' OR
      LOWER(publication.itemtitle) LIKE '%cryptography%' OR
      LOWER(publication.itemtitle) LIKE '%cryptographic%' OR
      LOWER(publication.itemtitle) LIKE '%evolutionary games%'
    ))"
  ))
publication_qc132 <- dbFetch(publication_qc132.SQL, n=-1)
length(unique(publication_qc132$pubid)) # 1266
save(publication_qc132, file="R file/publication_qc132.RData")
rm(publication_qc132, publication_qc132.SQL)

########################################

keywords_qc133.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%quantum information%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%quantum control%' OR
        LOWER(keywords.keyword) LIKE '%error correction%' OR
        LOWER(keywords.keyword) LIKE '%error correcting%' OR
        LOWER(keywords.keyword) LIKE '%fault-tolerant quantum%' OR
        LOWER(keywords.keyword) LIKE '%fault-tolerance%' OR
        LOWER(keywords.keyword) LIKE '%dynamical decoupling%' OR
        LOWER(keywords.keyword) LIKE '%error mitigation%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%experimental quantum%' OR
        LOWER(keywords.keyword) LIKE '%hardware implementation%' OR
        LOWER(keywords.keyword) LIKE '%compiler%' OR
        LOWER(keywords.keyword) LIKE '%quantum software%' OR
        LOWER(keywords.keyword) LIKE '%quantum programming%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensor%' OR
        LOWER(keywords.keyword) LIKE '%communication%' OR
        LOWER(keywords.keyword) LIKE '%cryptography%' OR
        LOWER(keywords.keyword) LIKE '%cryptographic%'
      ))"
  ))
keywords_qc133 <- dbFetch(keywords_qc133.SQL, n=-1)
length(unique(keywords_qc133$pubid)) # 0
save(keywords_qc133, file="R file/keywords_qc133.RData")
rm(keywords_qc133, keywords_qc133.SQL)

publication_qc133.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%quantum information%'
      ) AND (
        LOWER(publication.abstract) LIKE '%quantum control%' OR
        LOWER(publication.abstract) LIKE '%error correction%' OR
        LOWER(publication.abstract) LIKE '%error correcting%' OR
        LOWER(publication.abstract) LIKE '%fault-tolerant quantum%' OR
        LOWER(publication.abstract) LIKE '%fault-tolerance%' OR
        LOWER(publication.abstract) LIKE '%dynamical decoupling%' OR
        LOWER(publication.abstract) LIKE '%error mitigation%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%experimental quantum%' OR
        LOWER(publication.abstract) LIKE '%hardware implementation%' OR
        LOWER(publication.abstract) LIKE '%compiler%' OR
        LOWER(publication.abstract) LIKE '%quantum software%' OR
        LOWER(publication.abstract) LIKE '%quantum programming%' OR
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum sensor%' OR
        LOWER(publication.abstract) LIKE '%communication%' OR
        LOWER(publication.abstract) LIKE '%cryptography%' OR
        LOWER(publication.abstract) LIKE '%cryptographic%'
      ))
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%quantum information%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%quantum control%' OR
        LOWER(publication.itemtitle) LIKE '%error correction%' OR
        LOWER(publication.itemtitle) LIKE '%error correcting%' OR
        LOWER(publication.itemtitle) LIKE '%fault-tolerant quantum%' OR
        LOWER(publication.itemtitle) LIKE '%fault-tolerance%' OR
        LOWER(publication.itemtitle) LIKE '%dynamical decoupling%' OR
        LOWER(publication.itemtitle) LIKE '%error mitigation%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%experimental quantum%' OR
        LOWER(publication.itemtitle) LIKE '%hardware implementation%' OR
        LOWER(publication.itemtitle) LIKE '%compiler%' OR
        LOWER(publication.itemtitle) LIKE '%quantum software%' OR
        LOWER(publication.itemtitle) LIKE '%quantum programming%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensor%' OR
        LOWER(publication.itemtitle) LIKE '%communication%' OR
        LOWER(publication.itemtitle) LIKE '%cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%cryptographic%'
      ))"
  ))
publication_qc133 <- dbFetch(publication_qc133.SQL, n=-1)
length(unique(publication_qc133$pubid)) # 1293
save(publication_qc133, file="R file/publication_qc133.RData")
rm(publication_qc133, publication_qc133.SQL)

########################################

keywords_qc134.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%quantum information%'
      ) AND LOWER(keywords.keyword) LIKE '%quantum algorithm%' AND (
        LOWER(keywords.keyword) LIKE '%algorithm%' OR
        LOWER(keywords.keyword) LIKE '%quantum oracle%' OR
        LOWER(keywords.keyword) LIKE '%quantum machine learning%' OR
        LOWER(keywords.keyword) LIKE '%quantum learning%' OR
        LOWER(keywords.keyword) LIKE '%quantum optimization%' OR
        LOWER(keywords.keyword) LIKE '%vqe%' OR
        LOWER(keywords.keyword) LIKE '%vqc%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%experimental quantum%' OR
        LOWER(keywords.keyword) LIKE '%hardware implementation%' OR
        LOWER(keywords.keyword) LIKE '%compiler%' OR
        LOWER(keywords.keyword) LIKE '%quantum software%' OR
        LOWER(keywords.keyword) LIKE '%quantum programming%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensor%' OR
        LOWER(keywords.keyword) LIKE '%communication%' OR
        LOWER(keywords.keyword) LIKE '%cryptography%' OR
        LOWER(keywords.keyword) LIKE '%cryptographic%'
      ))"
  ))
keywords_qc134 <- dbFetch(keywords_qc134.SQL, n=-1)
length(unique(keywords_qc134$pubid)) # 0
save(keywords_qc134, file="R file/keywords_qc134.RData")
rm(keywords_qc134, keywords_qc134.SQL)

publication_qc134.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%quantum information%'
      ) AND LOWER(publication.abstract) LIKE '%quantum algorithm%' AND (
        LOWER(publication.abstract) LIKE '%algorithm%' OR
        LOWER(publication.abstract) LIKE '%quantum oracle%' OR
        LOWER(publication.abstract) LIKE '%quantum machine learning%' OR
        LOWER(publication.abstract) LIKE '%quantum learning%' OR
        LOWER(publication.abstract) LIKE '%quantum optimization%' OR
        LOWER(publication.abstract) LIKE '%vqe%' OR
        LOWER(publication.abstract) LIKE '%vqc%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%experimental quantum%' OR
        LOWER(publication.abstract) LIKE '%hardware implementation%' OR
        LOWER(publication.abstract) LIKE '%compiler%' OR
        LOWER(publication.abstract) LIKE '%quantum software%' OR
        LOWER(publication.abstract) LIKE '%quantum programming%' OR
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum sensor%' OR
        LOWER(publication.abstract) LIKE '%communication%' OR
        LOWER(publication.abstract) LIKE '%cryptography%' OR
        LOWER(publication.abstract) LIKE '%cryptographic%'
      )) 
      OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%quantum information%'
      ) AND LOWER(publication.itemtitle) LIKE '%quantum algorithm%' AND (
        LOWER(publication.itemtitle) LIKE '%algorithm%' OR
        LOWER(publication.itemtitle) LIKE '%quantum oracle%' OR
        LOWER(publication.itemtitle) LIKE '%quantum machine learning%' OR
        LOWER(publication.itemtitle) LIKE '%quantum learning%' OR
        LOWER(publication.itemtitle) LIKE '%quantum optimization%' OR
        LOWER(publication.itemtitle) LIKE '%vqe%' OR
        LOWER(publication.itemtitle) LIKE '%vqc%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%experimental quantum%' OR
        LOWER(publication.itemtitle) LIKE '%hardware implementation%' OR
        LOWER(publication.itemtitle) LIKE '%compiler%' OR
        LOWER(publication.itemtitle) LIKE '%quantum software%' OR
        LOWER(publication.itemtitle) LIKE '%quantum programming%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensor%' OR
        LOWER(publication.itemtitle) LIKE '%communication%' OR
        LOWER(publication.itemtitle) LIKE '%cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%cryptographic%'
      ))
    "
  ))
publication_qc134 <- dbFetch(publication_qc134.SQL, n=-1)
length(unique(publication_qc134$pubid)) # 976
save(publication_qc134, file="R file/publication_qc134.RData")
rm(publication_qc134, publication_qc134.SQL)

########################################

keywords_qc141.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND
      (
        LOWER(keywords.keyword) LIKE '%qubit%' OR
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computation%'
      ) AND (
        (
          (
            LOWER(keywords.keyword) LIKE '%quantum dot%' OR
            LOWER(keywords.keyword) LIKE '%quantum dots%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%chip%' OR
            LOWER(keywords.keyword) LIKE '%soc%' OR
            LOWER(keywords.keyword) LIKE '%multi-channel%' OR
            LOWER(keywords.keyword) LIKE '%multichannel%' OR
            LOWER(keywords.keyword) LIKE '%multichannels%' OR
            LOWER(keywords.keyword) LIKE '%scalable%'
          )
        ) OR (
          (
            LOWER(keywords.keyword) LIKE '%neutral atom%' OR
            LOWER(keywords.keyword) LIKE '%neutral atoms%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%photon interaction%' OR
            LOWER(keywords.keyword) LIKE '%photon interactions%' OR
            LOWER(keywords.keyword) LIKE '%modular%' OR
            LOWER(keywords.keyword) LIKE '%module%'
          )
        ) OR (
          LOWER(keywords.keyword) LIKE '%ion%' AND
          LOWER(keywords.keyword) LIKE '%trap%' AND
          (
            LOWER(keywords.keyword) LIKE '%qccd%' OR
            LOWER(keywords.keyword) LIKE '%modular%' OR
            LOWER(keywords.keyword) LIKE '%module%' OR
            LOWER(keywords.keyword) LIKE '%scalable%'
          )
        ) OR (
          LOWER(keywords.keyword) LIKE '%superconducting%' AND
          (
            LOWER(keywords.keyword) LIKE '%modular%' OR
            LOWER(keywords.keyword) LIKE '%module%' OR
            LOWER(keywords.keyword) LIKE '%integrated%' OR
            LOWER(keywords.keyword) LIKE '%3d%'
          )
        ) OR (
          LOWER(keywords.keyword) LIKE '%photonic%' AND
          (
            LOWER(keywords.keyword) LIKE '%multiple modes%' OR
            LOWER(keywords.keyword) LIKE '%multimode%' OR
            LOWER(keywords.keyword) LIKE '%multi-mode%' OR
            LOWER(keywords.keyword) LIKE '%scalable%' OR
            LOWER(keywords.keyword) LIKE '%integrated photonics%'
          )
        )
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%quantum cryptography%'
      ))"    
  ))
keywords_qc141 <- dbFetch(keywords_qc141.SQL, n=-1)
length(unique(keywords_qc141$pubid)) # 9
save(keywords_qc141, file="R file/keywords_qc141.RData")
rm(keywords_qc141, keywords_qc141.SQL)

publication_qc141.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND
      (
        LOWER(publication.abstract) LIKE '%qubit%' OR
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computation%'
      ) AND (
        (
          (
            LOWER(publication.abstract) LIKE '%quantum dot%' OR
            LOWER(publication.abstract) LIKE '%quantum dots%'
          ) AND (
            LOWER(publication.abstract) LIKE '%chip%' OR
            LOWER(publication.abstract) LIKE '%soc%' OR
            LOWER(publication.abstract) LIKE '%multi-channel%' OR
            LOWER(publication.abstract) LIKE '%multichannel%' OR
            LOWER(publication.abstract) LIKE '%multichannels%' OR
            LOWER(publication.abstract) LIKE '%scalable%'
          )
        ) OR (
          (
            LOWER(publication.abstract) LIKE '%neutral atom%' OR
            LOWER(publication.abstract) LIKE '%neutral atoms%'
          ) AND (
            LOWER(publication.abstract) LIKE '%photon interaction%' OR
            LOWER(publication.abstract) LIKE '%photon interactions%' OR
            LOWER(publication.abstract) LIKE '%modular%' OR
            LOWER(publication.abstract) LIKE '%module%'
          )
        ) OR (
          LOWER(publication.abstract) LIKE '%ion%' AND
          LOWER(publication.abstract) LIKE '%trap%' AND
          (
            LOWER(publication.abstract) LIKE '%qccd%' OR
            LOWER(publication.abstract) LIKE '%modular%' OR
            LOWER(publication.abstract) LIKE '%module%' OR
            LOWER(publication.abstract) LIKE '%scalable%'
          )
        ) OR (
          LOWER(publication.abstract) LIKE '%superconducting%' AND
          (
            LOWER(publication.abstract) LIKE '%modular%' OR
            LOWER(publication.abstract) LIKE '%module%' OR
            LOWER(publication.abstract) LIKE '%integrated%' OR
            LOWER(publication.abstract) LIKE '%3d%'
          )
        ) OR (
          LOWER(publication.abstract) LIKE '%photonic%' AND
          (
            LOWER(publication.abstract) LIKE '%multiple modes%' OR
            LOWER(publication.abstract) LIKE '%multimode%' OR
            LOWER(publication.abstract) LIKE '%multi-mode%' OR
            LOWER(publication.abstract) LIKE '%scalable%' OR
            LOWER(publication.abstract) LIKE '%integrated photonics%'
          )
        )
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%quantum cryptography%'
      )) 
      OR
      (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND
      (
        LOWER(publication.itemtitle) LIKE '%qubit%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computation%'
      ) AND (
        (
          (
            LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
            LOWER(publication.itemtitle) LIKE '%quantum dots%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%chip%' OR
            LOWER(publication.itemtitle) LIKE '%soc%' OR
            LOWER(publication.itemtitle) LIKE '%multi-channel%' OR
            LOWER(publication.itemtitle) LIKE '%multichannel%' OR
            LOWER(publication.itemtitle) LIKE '%multichannels%' OR
            LOWER(publication.itemtitle) LIKE '%scalable%'
          )
        ) OR (
          (
            LOWER(publication.itemtitle) LIKE '%neutral atom%' OR
            LOWER(publication.itemtitle) LIKE '%neutral atoms%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%photon interaction%' OR
            LOWER(publication.itemtitle) LIKE '%photon interactions%' OR
            LOWER(publication.itemtitle) LIKE '%modular%' OR
            LOWER(publication.itemtitle) LIKE '%module%'
          )
        ) OR (
          LOWER(publication.itemtitle) LIKE '%ion%' AND
          LOWER(publication.itemtitle) LIKE '%trap%' AND
          (
            LOWER(publication.itemtitle) LIKE '%qccd%' OR
            LOWER(publication.itemtitle) LIKE '%modular%' OR
            LOWER(publication.itemtitle) LIKE '%module%' OR
            LOWER(publication.itemtitle) LIKE '%scalable%'
          )
        ) OR (
          LOWER(publication.itemtitle) LIKE '%superconducting%' AND
          (
            LOWER(publication.itemtitle) LIKE '%modular%' OR
            LOWER(publication.itemtitle) LIKE '%module%' OR
            LOWER(publication.itemtitle) LIKE '%integrated%' OR
            LOWER(publication.itemtitle) LIKE '%3d%'
          )
        ) OR (
          LOWER(publication.itemtitle) LIKE '%photonic%' AND
          (
            LOWER(publication.itemtitle) LIKE '%multiple modes%' OR
            LOWER(publication.itemtitle) LIKE '%multimode%' OR
            LOWER(publication.itemtitle) LIKE '%multi-mode%' OR
            LOWER(publication.itemtitle) LIKE '%scalable%' OR
            LOWER(publication.itemtitle) LIKE '%integrated photonics%'
          )
        )
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%'
      ))"    
  ))
publication_qc141 <- dbFetch(publication_qc141.SQL, n=-1)
length(unique(publication_qc141$pubid)) # 918
save(publication_qc141, file="R file/publication_qc141.RData")
rm(publication_qc141, publication_qc141.SQL)

########################################

keywords_qc142.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND
      (
        LOWER(keywords.keyword) LIKE '%hybrid%' OR
        LOWER(keywords.keyword) LIKE '%interface%' OR
        LOWER(keywords.keyword) LIKE '%scalable%'
      ) AND
      LOWER(keywords.keyword) LIKE '%entanglement%' AND
      (
        (
          LOWER(keywords.keyword) LIKE '%ion%' AND
          LOWER(keywords.keyword) LIKE '%trap%'
        ) OR
        LOWER(keywords.keyword) LIKE '%photon%' OR
        LOWER(keywords.keyword) LIKE '%spin%' OR
        LOWER(keywords.keyword) LIKE '%quantum dot%' OR
        LOWER(keywords.keyword) LIKE '%quantum dots%' OR
        LOWER(keywords.keyword) LIKE '%atom%' OR
        LOWER(keywords.keyword) LIKE '%neutral atom%' OR
        LOWER(keywords.keyword) LIKE '%superconduc%' OR
        LOWER(keywords.keyword) LIKE '%continuous variable%' OR
        LOWER(keywords.keyword) LIKE '%continuous variables%' OR
        LOWER(keywords.keyword) LIKE '%coupling%' OR
        LOWER(keywords.keyword) LIKE '%single photon%' OR
        LOWER(keywords.keyword) LIKE '%cqed%' OR
        LOWER(keywords.keyword) LIKE '%microwave%'
      )
    )"
  ))
keywords_qc142 <- dbFetch(keywords_qc142.SQL, n=-1)
length(unique(keywords_qc142$pubid)) # 0
save(keywords_qc142, file="R file/keywords_qc142.RData")
rm(keywords_qc142, keywords_qc142.SQL)

publication_qc142.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND
      (
        LOWER(publication.abstract) LIKE '%hybrid%' OR
        LOWER(publication.abstract) LIKE '%interface%' OR
        LOWER(publication.abstract) LIKE '%scalable%'
      ) AND
      LOWER(publication.abstract) LIKE '%entanglement%' AND
      (
        (
          LOWER(publication.abstract) LIKE '%ion%' AND
          LOWER(publication.abstract) LIKE '%trap%'
        ) OR
        LOWER(publication.abstract) LIKE '%photon%' OR
        LOWER(publication.abstract) LIKE '%spin%' OR
        LOWER(publication.abstract) LIKE '%quantum dot%' OR
        LOWER(publication.abstract) LIKE '%quantum dots%' OR
        LOWER(publication.abstract) LIKE '%atom%' OR
        LOWER(publication.abstract) LIKE '%neutral atom%' OR
        LOWER(publication.abstract) LIKE '%superconduc%' OR
        LOWER(publication.abstract) LIKE '%continuous variable%' OR
        LOWER(publication.abstract) LIKE '%continuous variables%' OR
        LOWER(publication.abstract) LIKE '%coupling%' OR
        LOWER(publication.abstract) LIKE '%single photon%' OR
        LOWER(publication.abstract) LIKE '%cqed%' OR
        LOWER(publication.abstract) LIKE '%microwave%'
      )
    ) OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND
      (
        LOWER(publication.itemtitle) LIKE '%hybrid%' OR
        LOWER(publication.itemtitle) LIKE '%interface%' OR
        LOWER(publication.itemtitle) LIKE '%scalable%'
      ) AND
      LOWER(publication.itemtitle) LIKE '%entanglement%' AND
      (
        (
          LOWER(publication.itemtitle) LIKE '%ion%' AND
          LOWER(publication.itemtitle) LIKE '%trap%'
        ) OR
        LOWER(publication.itemtitle) LIKE '%photon%' OR
        LOWER(publication.itemtitle) LIKE '%spin%' OR
        LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
        LOWER(publication.itemtitle) LIKE '%quantum dots%' OR
        LOWER(publication.itemtitle) LIKE '%atom%' OR
        LOWER(publication.itemtitle) LIKE '%neutral atom%' OR
        LOWER(publication.itemtitle) LIKE '%superconduc%' OR
        LOWER(publication.itemtitle) LIKE '%continuous variable%' OR
        LOWER(publication.itemtitle) LIKE '%continuous variables%' OR
        LOWER(publication.itemtitle) LIKE '%coupling%' OR
        LOWER(publication.itemtitle) LIKE '%single photon%' OR
        LOWER(publication.itemtitle) LIKE '%cqed%' OR
        LOWER(publication.itemtitle) LIKE '%microwave%'
      )
    )"
  ))
publication_qc142 <- dbFetch(publication_qc142.SQL, n=-1)
length(unique(publication_qc142$pubid)) # 839
save(publication_qc142, file="R file/publication_qc142.RData")
rm(publication_qc142, publication_qc142.SQL)

########################################

keywords_qc143.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum%' AND
        (
          (
            LOWER(keywords.keyword) LIKE '%quantum simulation%' AND
            (
              LOWER(keywords.keyword) LIKE '%quantum computing%' OR
              LOWER(keywords.keyword) LIKE '%quantum computation%' OR
              LOWER(keywords.keyword) LIKE '%quantum information%' OR
              LOWER(keywords.keyword) LIKE '%quantum bit%' OR
              LOWER(keywords.keyword) LIKE 'qubit%' OR
              LOWER(keywords.keyword) LIKE 'qudit%'
            )
          ) OR
          LOWER(keywords.keyword) LIKE '%quantum annealer%' OR
          LOWER(keywords.keyword) LIKE '%quantum annealing%'
        ) AND
        (
          LOWER(keywords.keyword) LIKE '%hamiltonian%' OR
          LOWER(keywords.keyword) LIKE '%hubbard%' OR
          LOWER(keywords.keyword) LIKE '%ising%' OR
          LOWER(keywords.keyword) LIKE '%simulation%' OR
          LOWER(keywords.keyword) LIKE '%analog quantum%' OR
          LOWER(keywords.keyword) LIKE '%quantum control%' OR
          LOWER(keywords.keyword) LIKE '%many-body physics%'
        )
      ) OR
      (
        LOWER(keywords.keyword) LIKE '%ultracold atom%' AND
        LOWER(keywords.keyword) LIKE '%optical lattice%'
      ) OR
      LOWER(keywords.keyword) LIKE '%boson sampling%' OR
      LOWER(keywords.keyword) LIKE '%bosonsampling%' OR
      LOWER(keywords.keyword) LIKE '%optical lattice%'
    ) AND NOT (
      LOWER(keywords.keyword) LIKE '%quantum communication%' OR
      LOWER(keywords.keyword) LIKE '%quantum cryptography%'
    ))"
  ))
keywords_qc143 <- dbFetch(keywords_qc143.SQL, n=-1)
length(unique(keywords_qc143$pubid)) # 2572
save(keywords_qc143, file="R file/keywords_qc143.RData")
rm(keywords_qc143, keywords_qc143.SQL)

publication_qc143.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum%' AND
        (
          (
            LOWER(publication.abstract) LIKE '%quantum simulation%' AND
            (
              LOWER(publication.abstract) LIKE '%quantum computing%' OR
              LOWER(publication.abstract) LIKE '%quantum computation%' OR
              LOWER(publication.abstract) LIKE '%quantum information%' OR
              LOWER(publication.abstract) LIKE '%quantum bit%' OR
              LOWER(publication.abstract) LIKE 'qubit%' OR
              LOWER(publication.abstract) LIKE 'qudit%'
            )
          ) OR
          LOWER(publication.abstract) LIKE '%quantum annealer%' OR
          LOWER(publication.abstract) LIKE '%quantum annealing%'
        ) AND
        (
          LOWER(publication.abstract) LIKE '%hamiltonian%' OR
          LOWER(publication.abstract) LIKE '%hubbard%' OR
          LOWER(publication.abstract) LIKE '%ising%' OR
          LOWER(publication.abstract) LIKE '%simulation%' OR
          LOWER(publication.abstract) LIKE '%analog quantum%' OR
          LOWER(publication.abstract) LIKE '%quantum control%' OR
          LOWER(publication.abstract) LIKE '%many-body physics%'
        )
      ) OR
      (
        LOWER(publication.abstract) LIKE '%ultracold atom%' AND
        LOWER(publication.abstract) LIKE '%optical lattice%'
      ) OR
      LOWER(publication.abstract) LIKE '%boson sampling%' OR
      LOWER(publication.abstract) LIKE '%bosonsampling%' OR
      LOWER(publication.abstract) LIKE '%optical lattice%'
    ) AND NOT (
      LOWER(publication.abstract) LIKE '%quantum communication%' OR
      LOWER(publication.abstract) LIKE '%quantum cryptography%'
    )) 
    OR 
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' AND
        (
          (
            LOWER(publication.itemtitle) LIKE '%quantum simulation%' AND
            (
              LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
              LOWER(publication.itemtitle) LIKE '%quantum computation%' OR
              LOWER(publication.itemtitle) LIKE '%quantum information%' OR
              LOWER(publication.itemtitle) LIKE '%quantum bit%' OR
              LOWER(publication.itemtitle) LIKE 'qubit%' OR
              LOWER(publication.itemtitle) LIKE 'qudit%'
            )
          ) OR
          LOWER(publication.itemtitle) LIKE '%quantum annealer%' OR
          LOWER(publication.itemtitle) LIKE '%quantum annealing%'
        ) AND
        (
          LOWER(publication.itemtitle) LIKE '%hamiltonian%' OR
          LOWER(publication.itemtitle) LIKE '%hubbard%' OR
          LOWER(publication.itemtitle) LIKE '%ising%' OR
          LOWER(publication.itemtitle) LIKE '%simulation%' OR
          LOWER(publication.itemtitle) LIKE '%analog quantum%' OR
          LOWER(publication.itemtitle) LIKE '%quantum control%' OR
          LOWER(publication.itemtitle) LIKE '%many-body physics%'
        )
      ) OR
      (
        LOWER(publication.itemtitle) LIKE '%ultracold atom%' AND
        LOWER(publication.itemtitle) LIKE '%optical lattice%'
      ) OR
      LOWER(publication.itemtitle) LIKE '%boson sampling%' OR
      LOWER(publication.itemtitle) LIKE '%bosonsampling%' OR
      LOWER(publication.itemtitle) LIKE '%optical lattice%'
    ) AND NOT (
      LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
      LOWER(publication.itemtitle) LIKE '%quantum cryptography%'
    ))"
  ))
publication_qc143 <- dbFetch(publication_qc143.SQL, n=-1)
length(unique(publication_qc143$pubid)) # 8067
save(publication_qc143, file="R file/publication_qc143.RData")
rm(publication_qc143, publication_qc143.SQL)

########################################

keywords_qc211.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      LOWER(keywords.keyword) LIKE '%quantum%' AND (
        LOWER(keywords.keyword) LIKE '%qkd%' OR
        LOWER(keywords.keyword) LIKE '%quantum key distribution%' OR
        LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
        LOWER(keywords.keyword) LIKE '%qrng%' OR
        (
          LOWER(keywords.keyword) LIKE '%quantum random number%' AND (
            LOWER(keywords.keyword) LIKE '%generat%' OR
            LOWER(keywords.keyword) LIKE '%expansion%'
          )
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%qkd%' AND (
            LOWER(keywords.keyword) LIKE '%decoy%' OR
            LOWER(keywords.keyword) LIKE '%bb84%' OR
            LOWER(keywords.keyword) LIKE '%dps%' OR
            LOWER(keywords.keyword) LIKE '%cow%' OR
            LOWER(keywords.keyword) LIKE '%twin-field%' OR
            LOWER(keywords.keyword) LIKE '%twin field%' OR
            LOWER(keywords.keyword) LIKE '%tf%' OR
            LOWER(keywords.keyword) LIKE '%measurement device independent%' OR
            LOWER(keywords.keyword) LIKE '%measurement-device-independent%' OR
            LOWER(keywords.keyword) LIKE '%mdi%' OR
            LOWER(keywords.keyword) LIKE '%device independent%' OR
            LOWER(keywords.keyword) LIKE '%device-independent%' OR
            LOWER(keywords.keyword) LIKE '%di%' OR
            LOWER(keywords.keyword) LIKE '%continuous variable%' OR
            LOWER(keywords.keyword) LIKE '%cv%' OR
            LOWER(keywords.keyword) LIKE '%protocol%' OR
            LOWER(keywords.keyword) LIKE '%security%' OR
            LOWER(keywords.keyword) LIKE '%authenticat%' OR
            LOWER(keywords.keyword) LIKE '%post processing%' OR
            LOWER(keywords.keyword) LIKE '%post processor%' OR
            LOWER(keywords.keyword) LIKE '%privacy amplification%' OR
            LOWER(keywords.keyword) LIKE '%information reconciliation%' OR
            LOWER(keywords.keyword) LIKE '%chip%' OR
            LOWER(keywords.keyword) LIKE '%security proof%' OR
            LOWER(keywords.keyword) LIKE '%side channel attack%' OR
            LOWER(keywords.keyword) LIKE '%polarization%' OR
            LOWER(keywords.keyword) LIKE '%fpga%' OR
            LOWER(keywords.keyword) LIKE '%control%' OR
            LOWER(keywords.keyword) LIKE '%fib%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%quantum hacking%' OR
        LOWER(keywords.keyword) LIKE '%quantum secret sharing%'
      )
    ) AND NOT (
      LOWER(keywords.keyword) LIKE '%blind quantum computing%' OR
      LOWER(keywords.keyword) LIKE '%blind quantum computer%' OR
      LOWER(keywords.keyword) LIKE '%bqc%' OR
      LOWER(keywords.keyword) LIKE '%atmosphe%' OR
      LOWER(keywords.keyword) LIKE '%post-quantum%' OR
      LOWER(keywords.keyword) LIKE '%post quantum%' OR
      LOWER(keywords.keyword) LIKE '%pqc%' OR
      LOWER(keywords.keyword) LIKE '%satellite%'
    ))"
  ))
keywords_qc211 <- dbFetch(keywords_qc211.SQL, n=-1)
length(unique(keywords_qc211$pubid)) # 1242
save(keywords_qc211, file="R file/keywords_qc211.RData")
rm(keywords_qc211, keywords_qc211.SQL)

publication_qc211.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      LOWER(publication.abstract) LIKE '%quantum%' AND (
        LOWER(publication.abstract) LIKE '%qkd%' OR
        LOWER(publication.abstract) LIKE '%quantum key distribution%' OR
        LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
        LOWER(publication.abstract) LIKE '%qrng%' OR
        (
          LOWER(publication.abstract) LIKE '%quantum random number%' AND (
            LOWER(publication.abstract) LIKE '%generat%' OR
            LOWER(publication.abstract) LIKE '%expansion%'
          )
        ) OR
        (
          LOWER(publication.abstract) LIKE '%qkd%' AND (
            LOWER(publication.abstract) LIKE '%decoy%' OR
            LOWER(publication.abstract) LIKE '%bb84%' OR
            LOWER(publication.abstract) LIKE '%dps%' OR
            LOWER(publication.abstract) LIKE '%cow%' OR
            LOWER(publication.abstract) LIKE '%twin-field%' OR
            LOWER(publication.abstract) LIKE '%twin field%' OR
            LOWER(publication.abstract) LIKE '%tf%' OR
            LOWER(publication.abstract) LIKE '%measurement device independent%' OR
            LOWER(publication.abstract) LIKE '%measurement-device-independent%' OR
            LOWER(publication.abstract) LIKE '%mdi%' OR
            LOWER(publication.abstract) LIKE '%device independent%' OR
            LOWER(publication.abstract) LIKE '%device-independent%' OR
            LOWER(publication.abstract) LIKE '%di%' OR
            LOWER(publication.abstract) LIKE '%continuous variable%' OR
            LOWER(publication.abstract) LIKE '%cv%' OR
            LOWER(publication.abstract) LIKE '%protocol%' OR
            LOWER(publication.abstract) LIKE '%security%' OR
            LOWER(publication.abstract) LIKE '%authenticat%' OR
            LOWER(publication.abstract) LIKE '%post processing%' OR
            LOWER(publication.abstract) LIKE '%post processor%' OR
            LOWER(publication.abstract) LIKE '%privacy amplification%' OR
            LOWER(publication.abstract) LIKE '%information reconciliation%' OR
            LOWER(publication.abstract) LIKE '%chip%' OR
            LOWER(publication.abstract) LIKE '%security proof%' OR
            LOWER(publication.abstract) LIKE '%side channel attack%' OR
            LOWER(publication.abstract) LIKE '%polarization%' OR
            LOWER(publication.abstract) LIKE '%fpga%' OR
            LOWER(publication.abstract) LIKE '%control%' OR
            LOWER(publication.abstract) LIKE '%fib%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%quantum hacking%' OR
        LOWER(publication.abstract) LIKE '%quantum secret sharing%'
      )
    ) AND NOT (
      LOWER(publication.abstract) LIKE '%blind quantum computing%' OR
      LOWER(publication.abstract) LIKE '%blind quantum computer%' OR
      LOWER(publication.abstract) LIKE '%bqc%' OR
      LOWER(publication.abstract) LIKE '%atmosphe%' OR
      LOWER(publication.abstract) LIKE '%post-quantum%' OR
      LOWER(publication.abstract) LIKE '%post quantum%' OR
      LOWER(publication.abstract) LIKE '%pqc%' OR
      LOWER(publication.abstract) LIKE '%satellite%'
    ))
    OR
    ((
      LOWER(publication.itemtitle) LIKE '%quantum%' AND (
        LOWER(publication.itemtitle) LIKE '%qkd%' OR
        LOWER(publication.itemtitle) LIKE '%quantum key distribution%' OR
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%qrng%' OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum random number%' AND (
            LOWER(publication.itemtitle) LIKE '%generat%' OR
            LOWER(publication.itemtitle) LIKE '%expansion%'
          )
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%qkd%' AND (
            LOWER(publication.itemtitle) LIKE '%decoy%' OR
            LOWER(publication.itemtitle) LIKE '%bb84%' OR
            LOWER(publication.itemtitle) LIKE '%dps%' OR
            LOWER(publication.itemtitle) LIKE '%cow%' OR
            LOWER(publication.itemtitle) LIKE '%twin-field%' OR
            LOWER(publication.itemtitle) LIKE '%twin field%' OR
            LOWER(publication.itemtitle) LIKE '%tf%' OR
            LOWER(publication.itemtitle) LIKE '%measurement device independent%' OR
            LOWER(publication.itemtitle) LIKE '%measurement-device-independent%' OR
            LOWER(publication.itemtitle) LIKE '%mdi%' OR
            LOWER(publication.itemtitle) LIKE '%device independent%' OR
            LOWER(publication.itemtitle) LIKE '%device-independent%' OR
            LOWER(publication.itemtitle) LIKE '%di%' OR
            LOWER(publication.itemtitle) LIKE '%continuous variable%' OR
            LOWER(publication.itemtitle) LIKE '%cv%' OR
            LOWER(publication.itemtitle) LIKE '%protocol%' OR
            LOWER(publication.itemtitle) LIKE '%security%' OR
            LOWER(publication.itemtitle) LIKE '%authenticat%' OR
            LOWER(publication.itemtitle) LIKE '%post processing%' OR
            LOWER(publication.itemtitle) LIKE '%post processor%' OR
            LOWER(publication.itemtitle) LIKE '%privacy amplification%' OR
            LOWER(publication.itemtitle) LIKE '%information reconciliation%' OR
            LOWER(publication.itemtitle) LIKE '%chip%' OR
            LOWER(publication.itemtitle) LIKE '%security proof%' OR
            LOWER(publication.itemtitle) LIKE '%side channel attack%' OR
            LOWER(publication.itemtitle) LIKE '%polarization%' OR
            LOWER(publication.itemtitle) LIKE '%fpga%' OR
            LOWER(publication.itemtitle) LIKE '%control%' OR
            LOWER(publication.itemtitle) LIKE '%fib%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%quantum hacking%' OR
        LOWER(publication.itemtitle) LIKE '%quantum secret sharing%'
      )
    ) AND NOT (
      LOWER(publication.itemtitle) LIKE '%blind quantum computing%' OR
      LOWER(publication.itemtitle) LIKE '%blind quantum computer%' OR
      LOWER(publication.itemtitle) LIKE '%bqc%' OR
      LOWER(publication.itemtitle) LIKE '%atmosphe%' OR
      LOWER(publication.itemtitle) LIKE '%post-quantum%' OR
      LOWER(publication.itemtitle) LIKE '%post quantum%' OR
      LOWER(publication.itemtitle) LIKE '%pqc%' OR
      LOWER(publication.itemtitle) LIKE '%satellite%'
    ))"
  ))
publication_qc211 <- dbFetch(publication_qc211.SQL, n=-1)
length(unique(publication_qc211$pubid)) # 7075
save(publication_qc211, file="R file/publication_qc211.RData")
rm(publication_qc211, publication_qc211.SQL)

########################################

keywords_qc212.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%qkd%' OR
        LOWER(keywords.keyword) LIKE '%quantum key distribution%' OR
        LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
        LOWER(keywords.keyword) LIKE '%quantum communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum network%' OR
        LOWER(keywords.keyword) LIKE '%quantum secure%' OR
        LOWER(keywords.keyword) LIKE '%quantum security%' OR
        LOWER(keywords.keyword) LIKE '%quantum direct%' OR
        LOWER(keywords.keyword) LIKE '%quantum teleportation%' OR
        LOWER(keywords.keyword) LIKE '%quantum repeater%' OR
        LOWER(keywords.keyword) LIKE '%quantum relay%' OR
        LOWER(keywords.keyword) LIKE '%decoy%' OR
        LOWER(keywords.keyword) LIKE '%single photon%' OR
        LOWER(keywords.keyword) LIKE '%quantum source%' OR
        LOWER(keywords.keyword) LIKE '%single photon detector%' OR
        LOWER(keywords.keyword) LIKE '%single photon detection%' OR
        LOWER(keywords.keyword) LIKE '%device independent%' OR
        LOWER(keywords.keyword) LIKE '%continuous variable%' OR
        LOWER(keywords.keyword) LIKE '%post processing%' OR
        LOWER(keywords.keyword) LIKE '%security proof%' OR
        LOWER(keywords.keyword) LIKE '%side channel attack%' OR
        LOWER(keywords.keyword) LIKE '%quantum hacking%' OR
        LOWER(keywords.keyword) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%free space%' OR
        LOWER(keywords.keyword) LIKE '%free-space%' OR
        LOWER(keywords.keyword) LIKE '%wireless%' OR
        LOWER(keywords.keyword) LIKE '%fso%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%fiber%' OR
        LOWER(keywords.keyword) LIKE '%sensing%'
      )
    )"
  ))
keywords_qc212 <- dbFetch(keywords_qc212.SQL, n=-1)
length(unique(keywords_qc212$pubid)) # 0
save(keywords_qc212, file="R file/keywords_qc212.RData")
rm(keywords_qc212, keywords_qc212.SQL)

publication_qc212.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%qkd%' OR
        LOWER(publication.abstract) LIKE '%quantum key distribution%' OR
        LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
        LOWER(publication.abstract) LIKE '%quantum communication%' OR
        LOWER(publication.abstract) LIKE '%quantum network%' OR
        LOWER(publication.abstract) LIKE '%quantum secure%' OR
        LOWER(publication.abstract) LIKE '%quantum security%' OR
        LOWER(publication.abstract) LIKE '%quantum direct%' OR
        LOWER(publication.abstract) LIKE '%quantum teleportation%' OR
        LOWER(publication.abstract) LIKE '%quantum repeater%' OR
        LOWER(publication.abstract) LIKE '%quantum relay%' OR
        LOWER(publication.abstract) LIKE '%decoy%' OR
        LOWER(publication.abstract) LIKE '%single photon%' OR
        LOWER(publication.abstract) LIKE '%quantum source%' OR
        LOWER(publication.abstract) LIKE '%single photon detector%' OR
        LOWER(publication.abstract) LIKE '%single photon detection%' OR
        LOWER(publication.abstract) LIKE '%device independent%' OR
        LOWER(publication.abstract) LIKE '%continuous variable%' OR
        LOWER(publication.abstract) LIKE '%post processing%' OR
        LOWER(publication.abstract) LIKE '%security proof%' OR
        LOWER(publication.abstract) LIKE '%side channel attack%' OR
        LOWER(publication.abstract) LIKE '%quantum hacking%' OR
        LOWER(publication.abstract) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(publication.abstract) LIKE '%free space%' OR
        LOWER(publication.abstract) LIKE '%free-space%' OR
        LOWER(publication.abstract) LIKE '%wireless%' OR
        LOWER(publication.abstract) LIKE '%fso%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%fiber%' OR
        LOWER(publication.abstract) LIKE '%sensing%'
      )
    )
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%qkd%' OR
        LOWER(publication.itemtitle) LIKE '%quantum key distribution%' OR
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum network%' OR
        LOWER(publication.itemtitle) LIKE '%quantum secure%' OR
        LOWER(publication.itemtitle) LIKE '%quantum security%' OR
        LOWER(publication.itemtitle) LIKE '%quantum direct%' OR
        LOWER(publication.itemtitle) LIKE '%quantum teleportation%' OR
        LOWER(publication.itemtitle) LIKE '%quantum repeater%' OR
        LOWER(publication.itemtitle) LIKE '%quantum relay%' OR
        LOWER(publication.itemtitle) LIKE '%decoy%' OR
        LOWER(publication.itemtitle) LIKE '%single photon%' OR
        LOWER(publication.itemtitle) LIKE '%quantum source%' OR
        LOWER(publication.itemtitle) LIKE '%single photon detector%' OR
        LOWER(publication.itemtitle) LIKE '%single photon detection%' OR
        LOWER(publication.itemtitle) LIKE '%device independent%' OR
        LOWER(publication.itemtitle) LIKE '%continuous variable%' OR
        LOWER(publication.itemtitle) LIKE '%post processing%' OR
        LOWER(publication.itemtitle) LIKE '%security proof%' OR
        LOWER(publication.itemtitle) LIKE '%side channel attack%' OR
        LOWER(publication.itemtitle) LIKE '%quantum hacking%' OR
        LOWER(publication.itemtitle) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%free space%' OR
        LOWER(publication.itemtitle) LIKE '%free-space%' OR
        LOWER(publication.itemtitle) LIKE '%wireless%' OR
        LOWER(publication.itemtitle) LIKE '%fso%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%fiber%' OR
        LOWER(publication.itemtitle) LIKE '%sensing%'
      )
    )"
  ))
publication_qc212 <- dbFetch(publication_qc212.SQL, n=-1)
length(unique(publication_qc212$pubid)) # 1006
save(publication_qc212, file="R file/publication_qc212.RData")
rm(publication_qc212, publication_qc212.SQL)

########################################

keywords_qc213.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%network%' AND
      LOWER(keywords.keyword) LIKE '%quantum key distribution%' AND
      (
        LOWER(keywords.keyword) LIKE '%qkd network%' OR
        (
          LOWER(keywords.keyword) LIKE '%qkd%' AND
          (
            LOWER(keywords.keyword) LIKE '%backbone%' OR
            LOWER(keywords.keyword) LIKE '%metropolitan%'
          )
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%satellite%' AND
          LOWER(keywords.keyword) LIKE '%qkd%'
        )
      )
    )"
  ))
keywords_qc213 <- dbFetch(keywords_qc213.SQL, n=-1)
length(unique(keywords_qc213$pubid)) # 0
save(keywords_qc213, file="R file/keywords_qc213.RData")
rm(keywords_qc213, keywords_qc213.SQL)

publication_qc213.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%network%' AND
      LOWER(publication.abstract) LIKE '%quantum key distribution%' AND
      (
        LOWER(publication.abstract) LIKE '%qkd network%' OR
        (
          LOWER(publication.abstract) LIKE '%qkd%' AND
          (
            LOWER(publication.abstract) LIKE '%backbone%' OR
            LOWER(publication.abstract) LIKE '%metropolitan%'
          )
        ) OR
        (
          LOWER(publication.abstract) LIKE '%satellite%' AND
          LOWER(publication.abstract) LIKE '%qkd%'
        )
      )
    )
    OR 
    (
      LOWER(publication.itemtitle) LIKE '%network%' AND
      LOWER(publication.itemtitle) LIKE '%quantum key distribution%' AND
      (
        LOWER(publication.itemtitle) LIKE '%qkd network%' OR
        (
          LOWER(publication.itemtitle) LIKE '%qkd%' AND
          (
            LOWER(publication.itemtitle) LIKE '%backbone%' OR
            LOWER(publication.itemtitle) LIKE '%metropolitan%'
          )
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%satellite%' AND
          LOWER(publication.itemtitle) LIKE '%qkd%'
        )
      )
    )"
  ))
publication_qc213 <- dbFetch(publication_qc213.SQL, n=-1)
length(unique(publication_qc213$pubid)) # 215
save(publication_qc213, file="R file/publication_qc213.RData")
rm(publication_qc213, publication_qc213.SQL)

########################################

keywords_qc221.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND (
        LOWER(keywords.keyword) LIKE '%entanglement distribution%' OR
        LOWER(keywords.keyword) LIKE '%entanglement distributor%' OR
        LOWER(keywords.keyword) LIKE '%heralded entanglement%' OR
        LOWER(keywords.keyword) LIKE '%entanglement heralding%' OR
        (
          LOWER(keywords.keyword) LIKE '%wave length%' AND (
            LOWER(keywords.keyword) LIKE '%transduce%' OR
            LOWER(keywords.keyword) LIKE '%convert%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%entanglement purification%' OR
        LOWER(keywords.keyword) LIKE '%entanglement distillation%' OR
        LOWER(keywords.keyword) LIKE '%entanglement swapping%' OR
        (
          LOWER(keywords.keyword) LIKE '%quantum%' AND (
            LOWER(keywords.keyword) LIKE '%communication%' OR
            LOWER(keywords.keyword) LIKE '%cryptography%'
          ) AND LOWER(keywords.keyword) LIKE '%error correction%'
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%quantum teleportation%' AND
          LOWER(keywords.keyword) LIKE '%protocol%'
        ) OR
        LOWER(keywords.keyword) LIKE '%quantum direct communication%' OR
        (
          LOWER(keywords.keyword) LIKE '%bell state measurement%' AND
          LOWER(keywords.keyword) LIKE '%teleportation%'
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%quantum repeater%' AND
          LOWER(keywords.keyword) LIKE '%teleportation%'
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%quantum memory%' AND
          LOWER(keywords.keyword) LIKE '%teleportation%'
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%space%' AND
          LOWER(keywords.keyword) LIKE '%quantum communication%'
        )
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%gravity%' OR
        LOWER(keywords.keyword) LIKE '%polymer%'
      )
    )" 
  ))
keywords_qc221 <- dbFetch(keywords_qc221.SQL, n=-1)
length(unique(keywords_qc221$pubid)) # 0
save(keywords_qc221, file="R file/keywords_qc221.RData")
rm(keywords_qc221, keywords_qc221.SQL)

publication_qc221.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND (
        LOWER(publication.abstract) LIKE '%entanglement distribution%' OR
        LOWER(publication.abstract) LIKE '%entanglement distributor%' OR
        LOWER(publication.abstract) LIKE '%heralded entanglement%' OR
        LOWER(publication.abstract) LIKE '%entanglement heralding%' OR
        (
          LOWER(publication.abstract) LIKE '%wave length%' AND (
            LOWER(publication.abstract) LIKE '%transduce%' OR
            LOWER(publication.abstract) LIKE '%convert%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%entanglement purification%' OR
        LOWER(publication.abstract) LIKE '%entanglement distillation%' OR
        LOWER(publication.abstract) LIKE '%entanglement swapping%' OR
        (
          LOWER(publication.abstract) LIKE '%quantum%' AND (
            LOWER(publication.abstract) LIKE '%communication%' OR
            LOWER(publication.abstract) LIKE '%cryptography%'
          ) AND LOWER(publication.abstract) LIKE '%error correction%'
        ) OR
        (
          LOWER(publication.abstract) LIKE '%quantum teleportation%' AND
          LOWER(publication.abstract) LIKE '%protocol%'
        ) OR
        LOWER(publication.abstract) LIKE '%quantum direct communication%' OR
        (
          LOWER(publication.abstract) LIKE '%bell state measurement%' AND
          LOWER(publication.abstract) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.abstract) LIKE '%quantum repeater%' AND
          LOWER(publication.abstract) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.abstract) LIKE '%quantum memory%' AND
          LOWER(publication.abstract) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.abstract) LIKE '%space%' AND
          LOWER(publication.abstract) LIKE '%quantum communication%'
        )
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%gravity%' OR
        LOWER(publication.abstract) LIKE '%polymer%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND (
        LOWER(publication.itemtitle) LIKE '%entanglement distribution%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement distributor%' OR
        LOWER(publication.itemtitle) LIKE '%heralded entanglement%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement heralding%' OR
        (
          LOWER(publication.itemtitle) LIKE '%wave length%' AND (
            LOWER(publication.itemtitle) LIKE '%transduce%' OR
            LOWER(publication.itemtitle) LIKE '%convert%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%entanglement purification%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement distillation%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement swapping%' OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum%' AND (
            LOWER(publication.itemtitle) LIKE '%communication%' OR
            LOWER(publication.itemtitle) LIKE '%cryptography%'
          ) AND LOWER(publication.itemtitle) LIKE '%error correction%'
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum teleportation%' AND
          LOWER(publication.itemtitle) LIKE '%protocol%'
        ) OR
        LOWER(publication.itemtitle) LIKE '%quantum direct communication%' OR
        (
          LOWER(publication.itemtitle) LIKE '%bell state measurement%' AND
          LOWER(publication.itemtitle) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum repeater%' AND
          LOWER(publication.itemtitle) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum memory%' AND
          LOWER(publication.itemtitle) LIKE '%teleportation%'
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%space%' AND
          LOWER(publication.itemtitle) LIKE '%quantum communication%'
        )
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%gravity%' OR
        LOWER(publication.itemtitle) LIKE '%polymer%'
      )
    )
    " 
  ))
publication_qc221 <- dbFetch(publication_qc221.SQL, n=-1)
length(unique(publication_qc221$pubid)) # 2598
save(publication_qc221, file="R file/publication_qc221.RData")
rm(publication_qc221, publication_qc221.SQL)

########################################

keywords_qc222.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND (
        LOWER(keywords.keyword) LIKE '%quantum repeater%' OR
        LOWER(keywords.keyword) LIKE '%trusted repeater%' OR
        LOWER(keywords.keyword) LIKE '%quantum memory%' OR
        LOWER(keywords.keyword) LIKE '%quantum switch%' OR
        (
          LOWER(keywords.keyword) LIKE '%quantum%' AND
          LOWER(keywords.keyword) LIKE '%router%'
        ) OR
        LOWER(keywords.keyword) LIKE '%quantum internet%' OR
        (
          LOWER(keywords.keyword) LIKE '%quantum%' AND
          LOWER(keywords.keyword) LIKE '%satellite%' AND
          LOWER(keywords.keyword) LIKE '%network%'
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%quantum network%' AND (
            LOWER(keywords.keyword) LIKE '%quantum entanglement%' OR
            LOWER(keywords.keyword) LIKE '%topology%' OR
            LOWER(keywords.keyword) LIKE '%management%' OR
            LOWER(keywords.keyword) LIKE '%quantum interface%' OR
            LOWER(keywords.keyword) LIKE '%blind%' OR
            LOWER(keywords.keyword) LIKE '%end node%' OR
            LOWER(keywords.keyword) LIKE '%sync%' OR
            LOWER(keywords.keyword) LIKE '%reference model%' OR
            LOWER(keywords.keyword) LIKE '%hybrid%'
          )
        )
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%key management%'
      )
    )"
  ))
keywords_qc222 <- dbFetch(keywords_qc222.SQL, n=-1)
length(unique(keywords_qc222$pubid)) # 259
save(keywords_qc222, file="R file/keywords_qc222.RData")
rm(keywords_qc222, keywords_qc222.SQL)

publication_qc222.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND (
        LOWER(publication.abstract) LIKE '%quantum repeater%' OR
        LOWER(publication.abstract) LIKE '%trusted repeater%' OR
        LOWER(publication.abstract) LIKE '%quantum memory%' OR
        LOWER(publication.abstract) LIKE '%quantum switch%' OR
        (
          LOWER(publication.abstract) LIKE '%quantum%' AND
          LOWER(publication.abstract) LIKE '%router%'
        ) OR
        LOWER(publication.abstract) LIKE '%quantum internet%' OR
        (
          LOWER(publication.abstract) LIKE '%quantum%' AND
          LOWER(publication.abstract) LIKE '%satellite%' AND
          LOWER(publication.abstract) LIKE '%network%'
        ) OR
        (
          LOWER(publication.abstract) LIKE '%quantum network%' AND (
            LOWER(publication.abstract) LIKE '%quantum entanglement%' OR
            LOWER(publication.abstract) LIKE '%topology%' OR
            LOWER(publication.abstract) LIKE '%management%' OR
            LOWER(publication.abstract) LIKE '%quantum interface%' OR
            LOWER(publication.abstract) LIKE '%blind%' OR
            LOWER(publication.abstract) LIKE '%end node%' OR
            LOWER(publication.abstract) LIKE '%sync%' OR
            LOWER(publication.abstract) LIKE '%reference model%' OR
            LOWER(publication.abstract) LIKE '%hybrid%'
          )
        )
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%key management%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND (
        LOWER(publication.itemtitle) LIKE '%quantum repeater%' OR
        LOWER(publication.itemtitle) LIKE '%trusted repeater%' OR
        LOWER(publication.itemtitle) LIKE '%quantum memory%' OR
        LOWER(publication.itemtitle) LIKE '%quantum switch%' OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum%' AND
          LOWER(publication.itemtitle) LIKE '%router%'
        ) OR
        LOWER(publication.itemtitle) LIKE '%quantum internet%' OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum%' AND
          LOWER(publication.itemtitle) LIKE '%satellite%' AND
          LOWER(publication.itemtitle) LIKE '%network%'
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%quantum network%' AND (
            LOWER(publication.itemtitle) LIKE '%quantum entanglement%' OR
            LOWER(publication.itemtitle) LIKE '%topology%' OR
            LOWER(publication.itemtitle) LIKE '%management%' OR
            LOWER(publication.itemtitle) LIKE '%quantum interface%' OR
            LOWER(publication.itemtitle) LIKE '%blind%' OR
            LOWER(publication.itemtitle) LIKE '%end node%' OR
            LOWER(publication.itemtitle) LIKE '%sync%' OR
            LOWER(publication.itemtitle) LIKE '%reference model%' OR
            LOWER(publication.itemtitle) LIKE '%hybrid%'
          )
        )
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%key management%'
      )
    )"
  ))
publication_qc222 <- dbFetch(publication_qc222.SQL, n=-1)
length(unique(publication_qc222$pubid)) # 3199
save(publication_qc222, file="R file/publication_qc222.RData")
rm(publication_qc222, publication_qc222.SQL)

########################################

keywords_qc223.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%qkd%' OR
        LOWER(keywords.keyword) LIKE '%quantum key distribution%' OR
        LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
        LOWER(keywords.keyword) LIKE '%quantum communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum network%' OR
        LOWER(keywords.keyword) LIKE '%quantum secure%' OR
        LOWER(keywords.keyword) LIKE '%quantum security%' OR
        LOWER(keywords.keyword) LIKE '%quantum direct%' OR
        LOWER(keywords.keyword) LIKE '%quantum teleportation%' OR
        LOWER(keywords.keyword) LIKE '%quantum repeater%' OR
        LOWER(keywords.keyword) LIKE '%quantum relay%' OR
        LOWER(keywords.keyword) LIKE '%decoy%' OR
        LOWER(keywords.keyword) LIKE '%single photon%' OR
        LOWER(keywords.keyword) LIKE '%quantum source%' OR
        LOWER(keywords.keyword) LIKE '%single photon detector%' OR
        LOWER(keywords.keyword) LIKE '%single photon detection%' OR
        LOWER(keywords.keyword) LIKE '%device independent%' OR
        LOWER(keywords.keyword) LIKE '%continuous variable%' OR
        LOWER(keywords.keyword) LIKE '%post processing%' OR
        LOWER(keywords.keyword) LIKE '%security proof%' OR
        LOWER(keywords.keyword) LIKE '%side channel attack%' OR
        LOWER(keywords.keyword) LIKE '%quantum hacking%' OR
        LOWER(keywords.keyword) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%free space%' OR
        LOWER(keywords.keyword) LIKE '%free-space%' OR
        LOWER(keywords.keyword) LIKE '%wireless%' OR
        LOWER(keywords.keyword) LIKE '%fso%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%satellite%' OR
        LOWER(keywords.keyword) LIKE '%intersat%' OR
        LOWER(keywords.keyword) LIKE '%inter-sat%' OR
        LOWER(keywords.keyword) LIKE '%space%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%fiber%' OR
        LOWER(keywords.keyword) LIKE '%sensing%' OR
        LOWER(keywords.keyword) LIKE '%underwater%'
      )
    )"
  ))
keywords_qc223 <- dbFetch(keywords_qc223.SQL, n=-1)
length(unique(keywords_qc223$pubid)) # 0
save(keywords_qc223, file="R file/keywords_qc223.RData")
rm(keywords_qc223, keywords_qc223.SQL)

publication_qc223.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%qkd%' OR
        LOWER(publication.abstract) LIKE '%quantum key distribution%' OR
        LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
        LOWER(publication.abstract) LIKE '%quantum communication%' OR
        LOWER(publication.abstract) LIKE '%quantum network%' OR
        LOWER(publication.abstract) LIKE '%quantum secure%' OR
        LOWER(publication.abstract) LIKE '%quantum security%' OR
        LOWER(publication.abstract) LIKE '%quantum direct%' OR
        LOWER(publication.abstract) LIKE '%quantum teleportation%' OR
        LOWER(publication.abstract) LIKE '%quantum repeater%' OR
        LOWER(publication.abstract) LIKE '%quantum relay%' OR
        LOWER(publication.abstract) LIKE '%decoy%' OR
        LOWER(publication.abstract) LIKE '%single photon%' OR
        LOWER(publication.abstract) LIKE '%quantum source%' OR
        LOWER(publication.abstract) LIKE '%single photon detector%' OR
        LOWER(publication.abstract) LIKE '%single photon detection%' OR
        LOWER(publication.abstract) LIKE '%device independent%' OR
        LOWER(publication.abstract) LIKE '%continuous variable%' OR
        LOWER(publication.abstract) LIKE '%post processing%' OR
        LOWER(publication.abstract) LIKE '%security proof%' OR
        LOWER(publication.abstract) LIKE '%side channel attack%' OR
        LOWER(publication.abstract) LIKE '%quantum hacking%' OR
        LOWER(publication.abstract) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(publication.abstract) LIKE '%free space%' OR
        LOWER(publication.abstract) LIKE '%free-space%' OR
        LOWER(publication.abstract) LIKE '%wireless%' OR
        LOWER(publication.abstract) LIKE '%fso%'
      ) AND (
        LOWER(publication.abstract) LIKE '%satellite%' OR
        LOWER(publication.abstract) LIKE '%intersat%' OR
        LOWER(publication.abstract) LIKE '%inter-sat%' OR
        LOWER(publication.abstract) LIKE '%space%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%fiber%' OR
        LOWER(publication.abstract) LIKE '%sensing%' OR
        LOWER(publication.abstract) LIKE '%underwater%'
      )
    )
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%qkd%' OR
        LOWER(publication.itemtitle) LIKE '%quantum key distribution%' OR
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum network%' OR
        LOWER(publication.itemtitle) LIKE '%quantum secure%' OR
        LOWER(publication.itemtitle) LIKE '%quantum security%' OR
        LOWER(publication.itemtitle) LIKE '%quantum direct%' OR
        LOWER(publication.itemtitle) LIKE '%quantum teleportation%' OR
        LOWER(publication.itemtitle) LIKE '%quantum repeater%' OR
        LOWER(publication.itemtitle) LIKE '%quantum relay%' OR
        LOWER(publication.itemtitle) LIKE '%decoy%' OR
        LOWER(publication.itemtitle) LIKE '%single photon%' OR
        LOWER(publication.itemtitle) LIKE '%quantum source%' OR
        LOWER(publication.itemtitle) LIKE '%single photon detector%' OR
        LOWER(publication.itemtitle) LIKE '%single photon detection%' OR
        LOWER(publication.itemtitle) LIKE '%device independent%' OR
        LOWER(publication.itemtitle) LIKE '%continuous variable%' OR
        LOWER(publication.itemtitle) LIKE '%post processing%' OR
        LOWER(publication.itemtitle) LIKE '%security proof%' OR
        LOWER(publication.itemtitle) LIKE '%side channel attack%' OR
        LOWER(publication.itemtitle) LIKE '%quantum hacking%' OR
        LOWER(publication.itemtitle) LIKE '%quantum secret sharing%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%free space%' OR
        LOWER(publication.itemtitle) LIKE '%free-space%' OR
        LOWER(publication.itemtitle) LIKE '%wireless%' OR
        LOWER(publication.itemtitle) LIKE '%fso%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%satellite%' OR
        LOWER(publication.itemtitle) LIKE '%intersat%' OR
        LOWER(publication.itemtitle) LIKE '%inter-sat%' OR
        LOWER(publication.itemtitle) LIKE '%space%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%fiber%' OR
        LOWER(publication.itemtitle) LIKE '%sensing%' OR
        LOWER(publication.itemtitle) LIKE '%underwater%'
      )
    )"
  ))
publication_qc223 <- dbFetch(publication_qc223.SQL, n=-1)
length(unique(publication_qc223$pubid)) # 640
save(publication_qc223, file="R file/publication_qc223.RData")
rm(publication_qc223, publication_qc223.SQL)

########################################

keywords_qc224.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum%' AND (
          LOWER(keywords.keyword) LIKE '%quantum channel capacity%' OR
          LOWER(keywords.keyword) LIKE '%quantum-channel-capacity%' OR
          LOWER(keywords.keyword) LIKE '%data compression%' OR
          LOWER(keywords.keyword) LIKE '%nois%' OR
          LOWER(keywords.keyword) LIKE '%channel coding%' OR
          LOWER(keywords.keyword) LIKE '%channel-coding%' OR
          LOWER(keywords.keyword) LIKE '%theorem%' OR
          LOWER(keywords.keyword) LIKE '%entangled encoding%' OR
          LOWER(keywords.keyword) LIKE '%entangled decoding%' OR
          LOWER(keywords.keyword) LIKE '%communication theory%' OR
          LOWER(keywords.keyword) LIKE '%communication channel%' OR
          LOWER(keywords.keyword) LIKE '%shannon theory%' OR
          LOWER(keywords.keyword) LIKE '%superadditivity%' OR
          LOWER(keywords.keyword) LIKE '%super-additivity%' OR
          LOWER(keywords.keyword) LIKE '%non-additivity%' OR
          LOWER(keywords.keyword) LIKE '%additivity violation%' OR
          LOWER(keywords.keyword) LIKE '%activation%' OR
          LOWER(keywords.keyword) LIKE '%superactivation%' OR
          LOWER(keywords.keyword) LIKE '%super-activation%' OR
          LOWER(keywords.keyword) LIKE '%multiplicativ%' OR
          LOWER(keywords.keyword) LIKE '%network%' AND LOWER(keywords.keyword) LIKE '%collision%' AND LOWER(keywords.keyword) LIKE '%theory%' OR
          LOWER(keywords.keyword) LIKE '%quantum teleportation%' OR
          LOWER(keywords.keyword) LIKE '%distribut%' OR
          LOWER(keywords.keyword) LIKE '%classical capacit%' OR
          LOWER(keywords.keyword) LIKE '%quantum capacit%' OR
          LOWER(keywords.keyword) LIKE '%private capacit%' OR
          LOWER(keywords.keyword) LIKE '%cryptogrph%' OR
          LOWER(keywords.keyword) LIKE '%primitive%' OR
          LOWER(keywords.keyword) LIKE '%quantum concentration%'
        ) AND NOT (
          LOWER(keywords.keyword) LIKE '%nano%' OR
          LOWER(keywords.keyword) LIKE '%metal%' OR
          LOWER(keywords.keyword) LIKE '%bio%' OR
          LOWER(keywords.keyword) LIKE '%experiment%' OR
          LOWER(keywords.keyword) LIKE '%demonstrat%' OR
          LOWER(keywords.keyword) LIKE '%cosmolog%' OR
          LOWER(keywords.keyword) LIKE '%cosmic%' OR
          LOWER(keywords.keyword) LIKE '%gravity%' OR
          LOWER(keywords.keyword) LIKE '%black hole%'
        )
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%quantum%' OR
          LOWER(keywords.keyword) LIKE '%qubit%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%entanglement%' AND LOWER(keywords.keyword) LIKE '%performance%' AND LOWER(keywords.keyword) LIKE '%channel discrimination tasks%' OR
          LOWER(keywords.keyword) LIKE '%entanglement detection%' AND LOWER(keywords.keyword) LIKE '%mutually unbiased bases%' AND LOWER(keywords.keyword) LIKE '%povm%' OR
          LOWER(keywords.keyword) LIKE '%optimal measurement%' AND LOWER(keywords.keyword) LIKE '%quantum channels%' AND LOWER(keywords.keyword) LIKE '%quantum communication%' OR
          LOWER(keywords.keyword) LIKE '%ghz like state%' AND LOWER(keywords.keyword) LIKE '%internal attack%' AND LOWER(keywords.keyword) LIKE '%quantum entity authentication%' OR
          LOWER(keywords.keyword) LIKE '%bells%' AND LOWER(keywords.keyword) LIKE '%channel capacity%' AND LOWER(keywords.keyword) LIKE '%internet protocols%' OR
          LOWER(keywords.keyword) LIKE '%quantum state discrimination%' AND LOWER(keywords.keyword) LIKE '%quantum simulations%' AND LOWER(keywords.keyword) LIKE '%quantum channels%' OR
          LOWER(keywords.keyword) LIKE '%communication channels%' AND (
            LOWER(keywords.keyword) LIKE '%decision theory%' OR
            LOWER(keywords.keyword) LIKE '%decision problems%' OR
            LOWER(keywords.keyword) LIKE '%distinguishability%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%dynamical maps%' OR
            LOWER(keywords.keyword) LIKE '%quantum entanglement%'
          ) OR
          LOWER(keywords.keyword) LIKE '%noisy channel%' AND LOWER(keywords.keyword) LIKE '%quantum 2 design%' AND LOWER(keywords.keyword) LIKE '%quantum communication%'
        )
      )
    )"
  ))
keywords_qc224 <- dbFetch(keywords_qc224.SQL, n=-1)
length(unique(keywords_qc224$pubid)) # 2527
save(keywords_qc224, file="R file/keywords_qc224.RData")
rm(keywords_qc224, keywords_qc224.SQL)

publication_qc224.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum%' AND (
          LOWER(publication.abstract) LIKE '%quantum channel capacity%' OR
          LOWER(publication.abstract) LIKE '%quantum-channel-capacity%' OR
          LOWER(publication.abstract) LIKE '%data compression%' OR
          LOWER(publication.abstract) LIKE '%nois%' OR
          LOWER(publication.abstract) LIKE '%channel coding%' OR
          LOWER(publication.abstract) LIKE '%channel-coding%' OR
          LOWER(publication.abstract) LIKE '%theorem%' OR
          LOWER(publication.abstract) LIKE '%entangled encoding%' OR
          LOWER(publication.abstract) LIKE '%entangled decoding%' OR
          LOWER(publication.abstract) LIKE '%communication theory%' OR
          LOWER(publication.abstract) LIKE '%communication channel%' OR
          LOWER(publication.abstract) LIKE '%shannon theory%' OR
          LOWER(publication.abstract) LIKE '%superadditivity%' OR
          LOWER(publication.abstract) LIKE '%super-additivity%' OR
          LOWER(publication.abstract) LIKE '%non-additivity%' OR
          LOWER(publication.abstract) LIKE '%additivity violation%' OR
          LOWER(publication.abstract) LIKE '%activation%' OR
          LOWER(publication.abstract) LIKE '%superactivation%' OR
          LOWER(publication.abstract) LIKE '%super-activation%' OR
          LOWER(publication.abstract) LIKE '%multiplicativ%' OR
          LOWER(publication.abstract) LIKE '%network%' AND LOWER(publication.abstract) LIKE '%collision%' AND LOWER(publication.abstract) LIKE '%theory%' OR
          LOWER(publication.abstract) LIKE '%quantum teleportation%' OR
          LOWER(publication.abstract) LIKE '%distribut%' OR
          LOWER(publication.abstract) LIKE '%classical capacit%' OR
          LOWER(publication.abstract) LIKE '%quantum capacit%' OR
          LOWER(publication.abstract) LIKE '%private capacit%' OR
          LOWER(publication.abstract) LIKE '%cryptogrph%' OR
          LOWER(publication.abstract) LIKE '%primitive%' OR
          LOWER(publication.abstract) LIKE '%quantum concentration%'
        ) AND NOT (
          LOWER(publication.abstract) LIKE '%nano%' OR
          LOWER(publication.abstract) LIKE '%metal%' OR
          LOWER(publication.abstract) LIKE '%bio%' OR
          LOWER(publication.abstract) LIKE '%experiment%' OR
          LOWER(publication.abstract) LIKE '%demonstrat%' OR
          LOWER(publication.abstract) LIKE '%cosmolog%' OR
          LOWER(publication.abstract) LIKE '%cosmic%' OR
          LOWER(publication.abstract) LIKE '%gravity%' OR
          LOWER(publication.abstract) LIKE '%black hole%'
        )
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%quantum%' OR
          LOWER(publication.abstract) LIKE '%qubit%'
        ) AND (
          LOWER(publication.abstract) LIKE '%entanglement%' AND LOWER(publication.abstract) LIKE '%performance%' AND LOWER(publication.abstract) LIKE '%channel discrimination tasks%' OR
          LOWER(publication.abstract) LIKE '%entanglement detection%' AND LOWER(publication.abstract) LIKE '%mutually unbiased bases%' AND LOWER(publication.abstract) LIKE '%povm%' OR
          LOWER(publication.abstract) LIKE '%optimal measurement%' AND LOWER(publication.abstract) LIKE '%quantum channels%' AND LOWER(publication.abstract) LIKE '%quantum communication%' OR
          LOWER(publication.abstract) LIKE '%ghz like state%' AND LOWER(publication.abstract) LIKE '%internal attack%' AND LOWER(publication.abstract) LIKE '%quantum entity authentication%' OR
          LOWER(publication.abstract) LIKE '%bells%' AND LOWER(publication.abstract) LIKE '%channel capacity%' AND LOWER(publication.abstract) LIKE '%internet protocols%' OR
          LOWER(publication.abstract) LIKE '%quantum state discrimination%' AND LOWER(publication.abstract) LIKE '%quantum simulations%' AND LOWER(publication.abstract) LIKE '%quantum channels%' OR
          LOWER(publication.abstract) LIKE '%communication channels%' AND (
            LOWER(publication.abstract) LIKE '%decision theory%' OR
            LOWER(publication.abstract) LIKE '%decision problems%' OR
            LOWER(publication.abstract) LIKE '%distinguishability%'
          ) AND (
            LOWER(publication.abstract) LIKE '%dynamical maps%' OR
            LOWER(publication.abstract) LIKE '%quantum entanglement%'
          ) OR
          LOWER(publication.abstract) LIKE '%noisy channel%' AND LOWER(publication.abstract) LIKE '%quantum 2 design%' AND LOWER(publication.abstract) LIKE '%quantum communication%'
        )
      )
    )
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' AND (
          LOWER(publication.itemtitle) LIKE '%quantum channel capacity%' OR
          LOWER(publication.itemtitle) LIKE '%quantum-channel-capacity%' OR
          LOWER(publication.itemtitle) LIKE '%data compression%' OR
          LOWER(publication.itemtitle) LIKE '%nois%' OR
          LOWER(publication.itemtitle) LIKE '%channel coding%' OR
          LOWER(publication.itemtitle) LIKE '%channel-coding%' OR
          LOWER(publication.itemtitle) LIKE '%theorem%' OR
          LOWER(publication.itemtitle) LIKE '%entangled encoding%' OR
          LOWER(publication.itemtitle) LIKE '%entangled decoding%' OR
          LOWER(publication.itemtitle) LIKE '%communication theory%' OR
          LOWER(publication.itemtitle) LIKE '%communication channel%' OR
          LOWER(publication.itemtitle) LIKE '%shannon theory%' OR
          LOWER(publication.itemtitle) LIKE '%superadditivity%' OR
          LOWER(publication.itemtitle) LIKE '%super-additivity%' OR
          LOWER(publication.itemtitle) LIKE '%non-additivity%' OR
          LOWER(publication.itemtitle) LIKE '%additivity violation%' OR
          LOWER(publication.itemtitle) LIKE '%activation%' OR
          LOWER(publication.itemtitle) LIKE '%superactivation%' OR
          LOWER(publication.itemtitle) LIKE '%super-activation%' OR
          LOWER(publication.itemtitle) LIKE '%multiplicativ%' OR
          LOWER(publication.itemtitle) LIKE '%network%' AND LOWER(publication.itemtitle) LIKE '%collision%' AND LOWER(publication.itemtitle) LIKE '%theory%' OR
          LOWER(publication.itemtitle) LIKE '%quantum teleportation%' OR
          LOWER(publication.itemtitle) LIKE '%distribut%' OR
          LOWER(publication.itemtitle) LIKE '%classical capacit%' OR
          LOWER(publication.itemtitle) LIKE '%quantum capacit%' OR
          LOWER(publication.itemtitle) LIKE '%private capacit%' OR
          LOWER(publication.itemtitle) LIKE '%cryptogrph%' OR
          LOWER(publication.itemtitle) LIKE '%primitive%' OR
          LOWER(publication.itemtitle) LIKE '%quantum concentration%'
        ) AND NOT (
          LOWER(publication.itemtitle) LIKE '%nano%' OR
          LOWER(publication.itemtitle) LIKE '%metal%' OR
          LOWER(publication.itemtitle) LIKE '%bio%' OR
          LOWER(publication.itemtitle) LIKE '%experiment%' OR
          LOWER(publication.itemtitle) LIKE '%demonstrat%' OR
          LOWER(publication.itemtitle) LIKE '%cosmolog%' OR
          LOWER(publication.itemtitle) LIKE '%cosmic%' OR
          LOWER(publication.itemtitle) LIKE '%gravity%' OR
          LOWER(publication.itemtitle) LIKE '%black hole%'
        )
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%quantum%' OR
          LOWER(publication.itemtitle) LIKE '%qubit%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%entanglement%' AND LOWER(publication.itemtitle) LIKE '%performance%' AND LOWER(publication.itemtitle) LIKE '%channel discrimination tasks%' OR
          LOWER(publication.itemtitle) LIKE '%entanglement detection%' AND LOWER(publication.itemtitle) LIKE '%mutually unbiased bases%' AND LOWER(publication.itemtitle) LIKE '%povm%' OR
          LOWER(publication.itemtitle) LIKE '%optimal measurement%' AND LOWER(publication.itemtitle) LIKE '%quantum channels%' AND LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
          LOWER(publication.itemtitle) LIKE '%ghz like state%' AND LOWER(publication.itemtitle) LIKE '%internal attack%' AND LOWER(publication.itemtitle) LIKE '%quantum entity authentication%' OR
          LOWER(publication.itemtitle) LIKE '%bells%' AND LOWER(publication.itemtitle) LIKE '%channel capacity%' AND LOWER(publication.itemtitle) LIKE '%internet protocols%' OR
          LOWER(publication.itemtitle) LIKE '%quantum state discrimination%' AND LOWER(publication.itemtitle) LIKE '%quantum simulations%' AND LOWER(publication.itemtitle) LIKE '%quantum channels%' OR
          LOWER(publication.itemtitle) LIKE '%communication channels%' AND (
            LOWER(publication.itemtitle) LIKE '%decision theory%' OR
            LOWER(publication.itemtitle) LIKE '%decision problems%' OR
            LOWER(publication.itemtitle) LIKE '%distinguishability%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%dynamical maps%' OR
            LOWER(publication.itemtitle) LIKE '%quantum entanglement%'
          ) OR
          LOWER(publication.itemtitle) LIKE '%noisy channel%' AND LOWER(publication.itemtitle) LIKE '%quantum 2 design%' AND LOWER(publication.itemtitle) LIKE '%quantum communication%'
        )
      )
    )"
  ))
publication_qc224 <- dbFetch(publication_qc224.SQL, n=-1)
length(unique(publication_qc224$pubid)) # 56037
save(publication_qc224, file="R file/publication_qc224.RData")
rm(publication_qc224, publication_qc224.SQL)

########################################

keywords_qc225.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum secure communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum-secured communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum communication%' OR
        LOWER(keywords.keyword) LIKE '%quantum key distribution%' OR
        LOWER(keywords.keyword) LIKE '%qkd%' OR
        LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
        LOWER(keywords.keyword) LIKE '%quantum teleportation%' OR
        LOWER(keywords.keyword) LIKE '%quantum channel%' OR
        LOWER(keywords.keyword) LIKE '%quantum network%' OR
        LOWER(keywords.keyword) LIKE '%quantum repeater%' OR
        LOWER(keywords.keyword) LIKE '%quantum optics%'
      ) AND (
        (
          LOWER(keywords.keyword) LIKE '%on-chip%' OR
          LOWER(keywords.keyword) LIKE '%on chip%' OR
          LOWER(keywords.keyword) LIKE '%chip-based%' OR
          LOWER(keywords.keyword) LIKE '%chip based%' OR
          LOWER(keywords.keyword) LIKE '%integrated photonic%' OR
          LOWER(keywords.keyword) LIKE '%integrated quantum photonic%' OR
          LOWER(keywords.keyword) LIKE '%quantum integrated photonic%' OR
          LOWER(keywords.keyword) LIKE '%integrated circuit%' OR
          LOWER(keywords.keyword) LIKE '%nanophotonic chip%' OR
          LOWER(keywords.keyword) LIKE '%integrated optics%' OR
          LOWER(keywords.keyword) LIKE '%integrated optical%' OR
          LOWER(keywords.keyword) LIKE '%integrated platform%' OR
          LOWER(keywords.keyword) LIKE '%quantum photonic chip%' OR
          LOWER(keywords.keyword) LIKE '%communication chip%' OR
          LOWER(keywords.keyword) LIKE '%photonic quantum%'
        ) AND (
          (
            LOWER(keywords.keyword) LIKE '%emitter%' OR
            LOWER(keywords.keyword) LIKE '%generat%' OR
            LOWER(keywords.keyword) LIKE '%source%' OR
            LOWER(keywords.keyword) LIKE '%emissi%' OR
            LOWER(keywords.keyword) LIKE '%detect%' OR
            LOWER(keywords.keyword) LIKE '%device%' AND (
              LOWER(keywords.keyword) LIKE '%single-photon%' OR
              LOWER(keywords.keyword) LIKE '%single photon%' OR
              LOWER(keywords.keyword) LIKE '%photon pair%' OR
              LOWER(keywords.keyword) LIKE '%spdc source%'
            ) OR
            LOWER(keywords.keyword) LIKE '%entanglement source%' OR
            LOWER(keywords.keyword) LIKE '%quantum relay chip%' OR
            LOWER(keywords.keyword) LIKE '%quantum interconnect%' OR
            LOWER(keywords.keyword) LIKE '%on-chip encoding%' OR
            LOWER(keywords.keyword) LIKE '%interferomet%' OR
            LOWER(keywords.keyword) LIKE '%modulat%' OR
            LOWER(keywords.keyword) LIKE '%transmit%' OR
            LOWER(keywords.keyword) LIKE '%receiv%'
          )
        )
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%cascade laser%' OR
        LOWER(keywords.keyword) LIKE '%quantum imaging%' OR
        LOWER(keywords.keyword) LIKE '%imaging sensor%' OR
        LOWER(keywords.keyword) LIKE '%lidar%' OR
        LOWER(keywords.keyword) LIKE '%quantum fluid%' OR
        LOWER(keywords.keyword) LIKE '%spad camera%' OR
        LOWER(keywords.keyword) LIKE '%cmos%' OR
        LOWER(keywords.keyword) LIKE '%pqc%' OR
        LOWER(keywords.keyword) LIKE '%simulat%' OR
        LOWER(keywords.keyword) LIKE '%phonon%' OR
        LOWER(keywords.keyword) LIKE '%plasmon%' OR
        LOWER(keywords.keyword) LIKE '%machin learning%' OR
        LOWER(keywords.keyword) LIKE '%algorithm%'
      )
    )"
  ))
keywords_qc225 <- dbFetch(keywords_qc225.SQL, n=-1)
length(unique(keywords_qc225$pubid)) # 0
save(keywords_qc225, file="R file/keywords_qc225.RData")
rm(keywords_qc225, keywords_qc225.SQL)

publication_qc225.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum secure communication%' OR
        LOWER(publication.abstract) LIKE '%quantum-secured communication%' OR
        LOWER(publication.abstract) LIKE '%quantum communication%' OR
        LOWER(publication.abstract) LIKE '%quantum key distribution%' OR
        LOWER(publication.abstract) LIKE '%qkd%' OR
        LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
        LOWER(publication.abstract) LIKE '%quantum teleportation%' OR
        LOWER(publication.abstract) LIKE '%quantum channel%' OR
        LOWER(publication.abstract) LIKE '%quantum network%' OR
        LOWER(publication.abstract) LIKE '%quantum repeater%' OR
        LOWER(publication.abstract) LIKE '%quantum optics%'
      ) AND (
        (
          LOWER(publication.abstract) LIKE '%on-chip%' OR
          LOWER(publication.abstract) LIKE '%on chip%' OR
          LOWER(publication.abstract) LIKE '%chip-based%' OR
          LOWER(publication.abstract) LIKE '%chip based%' OR
          LOWER(publication.abstract) LIKE '%integrated photonic%' OR
          LOWER(publication.abstract) LIKE '%integrated quantum photonic%' OR
          LOWER(publication.abstract) LIKE '%quantum integrated photonic%' OR
          LOWER(publication.abstract) LIKE '%integrated circuit%' OR
          LOWER(publication.abstract) LIKE '%nanophotonic chip%' OR
          LOWER(publication.abstract) LIKE '%integrated optics%' OR
          LOWER(publication.abstract) LIKE '%integrated optical%' OR
          LOWER(publication.abstract) LIKE '%integrated platform%' OR
          LOWER(publication.abstract) LIKE '%quantum photonic chip%' OR
          LOWER(publication.abstract) LIKE '%communication chip%' OR
          LOWER(publication.abstract) LIKE '%photonic quantum%'
        ) AND (
          (
            LOWER(publication.abstract) LIKE '%emitter%' OR
            LOWER(publication.abstract) LIKE '%generat%' OR
            LOWER(publication.abstract) LIKE '%source%' OR
            LOWER(publication.abstract) LIKE '%emissi%' OR
            LOWER(publication.abstract) LIKE '%detect%' OR
            LOWER(publication.abstract) LIKE '%device%' AND (
              LOWER(publication.abstract) LIKE '%single-photon%' OR
              LOWER(publication.abstract) LIKE '%single photon%' OR
              LOWER(publication.abstract) LIKE '%photon pair%' OR
              LOWER(publication.abstract) LIKE '%spdc source%'
            ) OR
            LOWER(publication.abstract) LIKE '%entanglement source%' OR
            LOWER(publication.abstract) LIKE '%quantum relay chip%' OR
            LOWER(publication.abstract) LIKE '%quantum interconnect%' OR
            LOWER(publication.abstract) LIKE '%on-chip encoding%' OR
            LOWER(publication.abstract) LIKE '%interferomet%' OR
            LOWER(publication.abstract) LIKE '%modulat%' OR
            LOWER(publication.abstract) LIKE '%transmit%' OR
            LOWER(publication.abstract) LIKE '%receiv%'
          )
        )
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%cascade laser%' OR
        LOWER(publication.abstract) LIKE '%quantum imaging%' OR
        LOWER(publication.abstract) LIKE '%imaging sensor%' OR
        LOWER(publication.abstract) LIKE '%lidar%' OR
        LOWER(publication.abstract) LIKE '%quantum fluid%' OR
        LOWER(publication.abstract) LIKE '%spad camera%' OR
        LOWER(publication.abstract) LIKE '%cmos%' OR
        LOWER(publication.abstract) LIKE '%pqc%' OR
        LOWER(publication.abstract) LIKE '%simulat%' OR
        LOWER(publication.abstract) LIKE '%phonon%' OR
        LOWER(publication.abstract) LIKE '%plasmon%' OR
        LOWER(publication.abstract) LIKE '%machin learning%' OR
        LOWER(publication.abstract) LIKE '%algorithm%'
      )
    )
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum secure communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum-secured communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
        LOWER(publication.itemtitle) LIKE '%quantum key distribution%' OR
        LOWER(publication.itemtitle) LIKE '%qkd%' OR
        LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
        LOWER(publication.itemtitle) LIKE '%quantum teleportation%' OR
        LOWER(publication.itemtitle) LIKE '%quantum channel%' OR
        LOWER(publication.itemtitle) LIKE '%quantum network%' OR
        LOWER(publication.itemtitle) LIKE '%quantum repeater%' OR
        LOWER(publication.itemtitle) LIKE '%quantum optics%'
      ) AND (
        (
          LOWER(publication.itemtitle) LIKE '%on-chip%' OR
          LOWER(publication.itemtitle) LIKE '%on chip%' OR
          LOWER(publication.itemtitle) LIKE '%chip-based%' OR
          LOWER(publication.itemtitle) LIKE '%chip based%' OR
          LOWER(publication.itemtitle) LIKE '%integrated photonic%' OR
          LOWER(publication.itemtitle) LIKE '%integrated quantum photonic%' OR
          LOWER(publication.itemtitle) LIKE '%quantum integrated photonic%' OR
          LOWER(publication.itemtitle) LIKE '%integrated circuit%' OR
          LOWER(publication.itemtitle) LIKE '%nanophotonic chip%' OR
          LOWER(publication.itemtitle) LIKE '%integrated optics%' OR
          LOWER(publication.itemtitle) LIKE '%integrated optical%' OR
          LOWER(publication.itemtitle) LIKE '%integrated platform%' OR
          LOWER(publication.itemtitle) LIKE '%quantum photonic chip%' OR
          LOWER(publication.itemtitle) LIKE '%communication chip%' OR
          LOWER(publication.itemtitle) LIKE '%photonic quantum%'
        ) AND (
          (
            LOWER(publication.itemtitle) LIKE '%emitter%' OR
            LOWER(publication.itemtitle) LIKE '%generat%' OR
            LOWER(publication.itemtitle) LIKE '%source%' OR
            LOWER(publication.itemtitle) LIKE '%emissi%' OR
            LOWER(publication.itemtitle) LIKE '%detect%' OR
            LOWER(publication.itemtitle) LIKE '%device%' AND (
              LOWER(publication.itemtitle) LIKE '%single-photon%' OR
              LOWER(publication.itemtitle) LIKE '%single photon%' OR
              LOWER(publication.itemtitle) LIKE '%photon pair%' OR
              LOWER(publication.itemtitle) LIKE '%spdc source%'
            ) OR
            LOWER(publication.itemtitle) LIKE '%entanglement source%' OR
            LOWER(publication.itemtitle) LIKE '%quantum relay chip%' OR
            LOWER(publication.itemtitle) LIKE '%quantum interconnect%' OR
            LOWER(publication.itemtitle) LIKE '%on-chip encoding%' OR
            LOWER(publication.itemtitle) LIKE '%interferomet%' OR
            LOWER(publication.itemtitle) LIKE '%modulat%' OR
            LOWER(publication.itemtitle) LIKE '%transmit%' OR
            LOWER(publication.itemtitle) LIKE '%receiv%'
          )
        )
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%cascade laser%' OR
        LOWER(publication.itemtitle) LIKE '%quantum imaging%' OR
        LOWER(publication.itemtitle) LIKE '%imaging sensor%' OR
        LOWER(publication.itemtitle) LIKE '%lidar%' OR
        LOWER(publication.itemtitle) LIKE '%quantum fluid%' OR
        LOWER(publication.itemtitle) LIKE '%spad camera%' OR
        LOWER(publication.itemtitle) LIKE '%cmos%' OR
        LOWER(publication.itemtitle) LIKE '%pqc%' OR
        LOWER(publication.itemtitle) LIKE '%simulat%' OR
        LOWER(publication.itemtitle) LIKE '%phonon%' OR
        LOWER(publication.itemtitle) LIKE '%plasmon%' OR
        LOWER(publication.itemtitle) LIKE '%machin learning%' OR
        LOWER(publication.itemtitle) LIKE '%algorithm%'
      )
    )"
  ))
publication_qc225 <- dbFetch(publication_qc225.SQL, n=-1)
length(unique(publication_qc225$pubid)) # 388
save(publication_qc225, file="R file/publication_qc225.RData")
rm(publication_qc225, publication_qc225.SQL)

########################################

keywords_qc311.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum%' OR
        LOWER(keywords.keyword) LIKE '%cold atom%' OR
        LOWER(keywords.keyword) LIKE '%trapped ion%' OR
        LOWER(keywords.keyword) LIKE '%nitrogen vacancy%' OR
        LOWER(keywords.keyword) LIKE '%nv center%' OR
        LOWER(keywords.keyword) LIKE '%optomechanics%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%displacement sensor%' OR
        LOWER(keywords.keyword) LIKE '%rotation sensor%' OR
        LOWER(keywords.keyword) LIKE '%acceleration sensor%' OR
        LOWER(keywords.keyword) LIKE '%force sensor%' OR
        LOWER(keywords.keyword) LIKE '%inertial sensor%' OR
        LOWER(keywords.keyword) LIKE '%displacement sensing%' OR
        LOWER(keywords.keyword) LIKE '%rotation sensing%' OR
        LOWER(keywords.keyword) LIKE '%acceleration sensing%' OR
        LOWER(keywords.keyword) LIKE '%force sensing%' OR
        LOWER(keywords.keyword) LIKE '%inertial sensing%'
      )
    ) OR (
      (
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensor%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%atomic interferometer%' OR
        LOWER(keywords.keyword) LIKE '%gravity gradiometer%' OR
        LOWER(keywords.keyword) LIKE '%gravimeter%' OR
        LOWER(keywords.keyword) LIKE '%gyroscope%' OR
        LOWER(keywords.keyword) LIKE '%velocimeter%' OR
        LOWER(keywords.keyword) LIKE '%accelerometer%'
      )
    ))"
  ))
keywords_qc311 <- dbFetch(keywords_qc311.SQL, n=-1)
length(unique(keywords_qc311$pubid)) # 0
save(keywords_qc311, file="R file/keywords_qc311.RData")
rm(keywords_qc311, keywords_qc311.SQL)

publication_qc311.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum%' OR
        LOWER(publication.abstract) LIKE '%cold atom%' OR
        LOWER(publication.abstract) LIKE '%trapped ion%' OR
        LOWER(publication.abstract) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.abstract) LIKE '%nv center%' OR
        LOWER(publication.abstract) LIKE '%optomechanics%'
      ) AND (
        LOWER(publication.abstract) LIKE '%displacement sensor%' OR
        LOWER(publication.abstract) LIKE '%rotation sensor%' OR
        LOWER(publication.abstract) LIKE '%acceleration sensor%' OR
        LOWER(publication.abstract) LIKE '%force sensor%' OR
        LOWER(publication.abstract) LIKE '%inertial sensor%' OR
        LOWER(publication.abstract) LIKE '%displacement sensing%' OR
        LOWER(publication.abstract) LIKE '%rotation sensing%' OR
        LOWER(publication.abstract) LIKE '%acceleration sensing%' OR
        LOWER(publication.abstract) LIKE '%force sensing%' OR
        LOWER(publication.abstract) LIKE '%inertial sensing%'
      )
    ) OR (
      (
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.abstract) LIKE '%atomic interferometer%' OR
        LOWER(publication.abstract) LIKE '%gravity gradiometer%' OR
        LOWER(publication.abstract) LIKE '%gravimeter%' OR
        LOWER(publication.abstract) LIKE '%gyroscope%' OR
        LOWER(publication.abstract) LIKE '%velocimeter%' OR
        LOWER(publication.abstract) LIKE '%accelerometer%'
      )
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' OR
        LOWER(publication.itemtitle) LIKE '%cold atom%' OR
        LOWER(publication.itemtitle) LIKE '%trapped ion%' OR
        LOWER(publication.itemtitle) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.itemtitle) LIKE '%nv center%' OR
        LOWER(publication.itemtitle) LIKE '%optomechanics%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%displacement sensor%' OR
        LOWER(publication.itemtitle) LIKE '%rotation sensor%' OR
        LOWER(publication.itemtitle) LIKE '%acceleration sensor%' OR
        LOWER(publication.itemtitle) LIKE '%force sensor%' OR
        LOWER(publication.itemtitle) LIKE '%inertial sensor%' OR
        LOWER(publication.itemtitle) LIKE '%displacement sensing%' OR
        LOWER(publication.itemtitle) LIKE '%rotation sensing%' OR
        LOWER(publication.itemtitle) LIKE '%acceleration sensing%' OR
        LOWER(publication.itemtitle) LIKE '%force sensing%' OR
        LOWER(publication.itemtitle) LIKE '%inertial sensing%'
      )
    ) OR (
      (
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%atomic interferometer%' OR
        LOWER(publication.itemtitle) LIKE '%gravity gradiometer%' OR
        LOWER(publication.itemtitle) LIKE '%gravimeter%' OR
        LOWER(publication.itemtitle) LIKE '%gyroscope%' OR
        LOWER(publication.itemtitle) LIKE '%velocimeter%' OR
        LOWER(publication.itemtitle) LIKE '%accelerometer%'
      )
    ))"
  ))
publication_qc311 <- dbFetch(publication_qc311.SQL, n=-1)
length(unique(publication_qc311$pubid))  #305
save(publication_qc311, file="R file/publication_qc311.RData")
rm(publication_qc311, publication_qc311.SQL)

########################################

keywords_qc312.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum clock%' OR
        LOWER(keywords.keyword) LIKE '%atom clock%' OR
        LOWER(keywords.keyword) LIKE '%atomic clock%' OR
        LOWER(keywords.keyword) LIKE '%optical clock%' OR
        LOWER(keywords.keyword) LIKE '%frequency standard%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%synchronization%' OR
        LOWER(keywords.keyword) LIKE '%syntonization%' OR
        LOWER(keywords.keyword) LIKE '%squeezing%' OR
        LOWER(keywords.keyword) LIKE '%squeezed%' OR
        LOWER(keywords.keyword) LIKE '%entanglement%' OR
        LOWER(keywords.keyword) LIKE '%entangled%' OR
        LOWER(keywords.keyword) LIKE '%superradiance%' OR
        LOWER(keywords.keyword) LIKE '%superrradiant%' OR
        LOWER(keywords.keyword) LIKE '%synthesis%' OR
        LOWER(keywords.keyword) LIKE '%synthesizer%' OR
        LOWER(keywords.keyword) LIKE '%synthesizing%' OR
        LOWER(keywords.keyword) LIKE '%stabiliz%' OR
        LOWER(keywords.keyword) LIKE '%chip-scale%' OR
        LOWER(keywords.keyword) LIKE '%chip scale%' OR
        LOWER(keywords.keyword) LIKE '%shield%' OR
        LOWER(keywords.keyword) LIKE '%waveguide%' OR
        LOWER(keywords.keyword) LIKE '%oscillator%' OR
        LOWER(keywords.keyword) LIKE '%cold atom%' OR
        LOWER(keywords.keyword) LIKE '%laser cooling%' OR
        LOWER(keywords.keyword) LIKE '%time transfer%' OR
        LOWER(keywords.keyword) LIKE '%time comparison%'
      )
    )" 
  ))
keywords_qc312 <- dbFetch(keywords_qc312.SQL, n=-1)
length(unique(keywords_qc312$pubid)) # 1
save(keywords_qc312, file="R file/keywords_qc312.RData")
rm(keywords_qc312, keywords_qc312.SQL)

publication_qc312.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum clock%' OR
        LOWER(publication.abstract) LIKE '%atom clock%' OR
        LOWER(publication.abstract) LIKE '%atomic clock%' OR
        LOWER(publication.abstract) LIKE '%optical clock%' OR
        LOWER(publication.abstract) LIKE '%frequency standard%'
      ) AND (
        LOWER(publication.abstract) LIKE '%synchronization%' OR
        LOWER(publication.abstract) LIKE '%syntonization%' OR
        LOWER(publication.abstract) LIKE '%squeezing%' OR
        LOWER(publication.abstract) LIKE '%squeezed%' OR
        LOWER(publication.abstract) LIKE '%entanglement%' OR
        LOWER(publication.abstract) LIKE '%entangled%' OR
        LOWER(publication.abstract) LIKE '%superradiance%' OR
        LOWER(publication.abstract) LIKE '%superrradiant%' OR
        LOWER(publication.abstract) LIKE '%synthesis%' OR
        LOWER(publication.abstract) LIKE '%synthesizer%' OR
        LOWER(publication.abstract) LIKE '%synthesizing%' OR
        LOWER(publication.abstract) LIKE '%stabiliz%' OR
        LOWER(publication.abstract) LIKE '%chip-scale%' OR
        LOWER(publication.abstract) LIKE '%chip scale%' OR
        LOWER(publication.abstract) LIKE '%shield%' OR
        LOWER(publication.abstract) LIKE '%waveguide%' OR
        LOWER(publication.abstract) LIKE '%oscillator%' OR
        LOWER(publication.abstract) LIKE '%cold atom%' OR
        LOWER(publication.abstract) LIKE '%laser cooling%' OR
        LOWER(publication.abstract) LIKE '%time transfer%' OR
        LOWER(publication.abstract) LIKE '%time comparison%'
      )
    )
    OR 
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum clock%' OR
        LOWER(publication.itemtitle) LIKE '%atom clock%' OR
        LOWER(publication.itemtitle) LIKE '%atomic clock%' OR
        LOWER(publication.itemtitle) LIKE '%optical clock%' OR
        LOWER(publication.itemtitle) LIKE '%frequency standard%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%synchronization%' OR
        LOWER(publication.itemtitle) LIKE '%syntonization%' OR
        LOWER(publication.itemtitle) LIKE '%squeezing%' OR
        LOWER(publication.itemtitle) LIKE '%squeezed%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement%' OR
        LOWER(publication.itemtitle) LIKE '%entangled%' OR
        LOWER(publication.itemtitle) LIKE '%superradiance%' OR
        LOWER(publication.itemtitle) LIKE '%superrradiant%' OR
        LOWER(publication.itemtitle) LIKE '%synthesis%' OR
        LOWER(publication.itemtitle) LIKE '%synthesizer%' OR
        LOWER(publication.itemtitle) LIKE '%synthesizing%' OR
        LOWER(publication.itemtitle) LIKE '%stabiliz%' OR
        LOWER(publication.itemtitle) LIKE '%chip-scale%' OR
        LOWER(publication.itemtitle) LIKE '%chip scale%' OR
        LOWER(publication.itemtitle) LIKE '%shield%' OR
        LOWER(publication.itemtitle) LIKE '%waveguide%' OR
        LOWER(publication.itemtitle) LIKE '%oscillator%' OR
        LOWER(publication.itemtitle) LIKE '%cold atom%' OR
        LOWER(publication.itemtitle) LIKE '%laser cooling%' OR
        LOWER(publication.itemtitle) LIKE '%time transfer%' OR
        LOWER(publication.itemtitle) LIKE '%time comparison%'
      )
    )" 
  ))
publication_qc312 <- dbFetch(publication_qc312.SQL, n=-1)
length(unique(publication_qc312$pubid)) # 2245
save(publication_qc312, file="R file/publication_qc312.RData")
rm(publication_qc312, publication_qc312.SQL)

########################################

keywords_qc313.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum%' OR
        LOWER(keywords.keyword) LIKE '%nitrogen vacancy%' OR
        LOWER(keywords.keyword) LIKE '%nv center%' OR
        LOWER(keywords.keyword) LIKE '%supercoductor%' OR
        LOWER(keywords.keyword) LIKE '%silicon carbide%' OR
        LOWER(keywords.keyword) LIKE '%boron nitride%' OR
        LOWER(keywords.keyword) LIKE '%squid%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%magnetic field sensor%' OR
        LOWER(keywords.keyword) LIKE '%magnetic field sensing%' OR
        LOWER(keywords.keyword) LIKE '%b field sensor%' OR
        LOWER(keywords.keyword) LIKE '%b field sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum magnetometry%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%magnetoresistance%' OR
        LOWER(keywords.keyword) LIKE '%hall effect%' OR
        LOWER(keywords.keyword) LIKE '%conference%'
      )
    ) OR (
      (
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensor%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%magnetic field%' OR
        LOWER(keywords.keyword) LIKE '%b field%' OR
        LOWER(keywords.keyword) LIKE '%nmr%' OR
        LOWER(keywords.keyword) LIKE '%squid%'
      )
    ) OR (
      (
        LOWER(keywords.keyword) LIKE '%nitrogen vacancy%' OR
        LOWER(keywords.keyword) LIKE '%nv center%'
      ) AND LOWER(keywords.keyword) LIKE '%nmr%'
    ))"
  ))
keywords_qc313 <- dbFetch(keywords_qc313.SQL, n=-1)
length(unique(keywords_qc313$pubid)) # 0
save(keywords_qc313, file="R file/keywords_qc313.RData")
rm(keywords_qc313, keywords_qc313.SQL)

publication_qc313.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum%' OR
        LOWER(publication.abstract) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.abstract) LIKE '%nv center%' OR
        LOWER(publication.abstract) LIKE '%supercoductor%' OR
        LOWER(publication.abstract) LIKE '%silicon carbide%' OR
        LOWER(publication.abstract) LIKE '%boron nitride%' OR
        LOWER(publication.abstract) LIKE '%squid%'
      ) AND (
        LOWER(publication.abstract) LIKE '%magnetic field sensor%' OR
        LOWER(publication.abstract) LIKE '%magnetic field sensing%' OR
        LOWER(publication.abstract) LIKE '%b field sensor%' OR
        LOWER(publication.abstract) LIKE '%b field sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum magnetometry%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%magnetoresistance%' OR
        LOWER(publication.abstract) LIKE '%hall effect%' OR
        LOWER(publication.abstract) LIKE '%conference%'
      )
    ) OR (
      (
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.abstract) LIKE '%magnetic field%' OR
        LOWER(publication.abstract) LIKE '%b field%' OR
        LOWER(publication.abstract) LIKE '%nmr%' OR
        LOWER(publication.abstract) LIKE '%squid%'
      )
    ) OR (
      (
        LOWER(publication.abstract) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.abstract) LIKE '%nv center%'
      ) AND LOWER(publication.abstract) LIKE '%nmr%'
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' OR
        LOWER(publication.itemtitle) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.itemtitle) LIKE '%nv center%' OR
        LOWER(publication.itemtitle) LIKE '%supercoductor%' OR
        LOWER(publication.itemtitle) LIKE '%silicon carbide%' OR
        LOWER(publication.itemtitle) LIKE '%boron nitride%' OR
        LOWER(publication.itemtitle) LIKE '%squid%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%magnetic field sensor%' OR
        LOWER(publication.itemtitle) LIKE '%magnetic field sensing%' OR
        LOWER(publication.itemtitle) LIKE '%b field sensor%' OR
        LOWER(publication.itemtitle) LIKE '%b field sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum magnetometry%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%magnetoresistance%' OR
        LOWER(publication.itemtitle) LIKE '%hall effect%' OR
        LOWER(publication.itemtitle) LIKE '%conference%'
      )
    ) OR (
      (
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%magnetic field%' OR
        LOWER(publication.itemtitle) LIKE '%b field%' OR
        LOWER(publication.itemtitle) LIKE '%nmr%' OR
        LOWER(publication.itemtitle) LIKE '%squid%'
      )
    ) OR (
      (
        LOWER(publication.itemtitle) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.itemtitle) LIKE '%nv center%'
      ) AND LOWER(publication.itemtitle) LIKE '%nmr%'
    ))"
  ))
publication_qc313 <- dbFetch(publication_qc313.SQL, n=-1)
length(unique(publication_qc313$pubid)) # 410
save(publication_qc313, file="R file/publication_qc313.RData")
rm(publication_qc313, publication_qc313.SQL)

########################################

keywords_qc314.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum%' OR
        LOWER(keywords.keyword) LIKE '%rydberg atom%' OR
        LOWER(keywords.keyword) LIKE '%quantum dot%' OR
        LOWER(keywords.keyword) LIKE '%nv center%' OR
        LOWER(keywords.keyword) LIKE '%nitrogen vacancy%' OR
        LOWER(keywords.keyword) LIKE '%boron nitride%' OR
        LOWER(keywords.keyword) LIKE '%silicon carbide%' OR
        LOWER(keywords.keyword) LIKE '%trapped ion%' OR
        LOWER(keywords.keyword) LIKE '%optical cavity%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%electric field sensor%' OR
        LOWER(keywords.keyword) LIKE '%electric field sensing%' OR
        LOWER(keywords.keyword) LIKE '%e field sensor%' OR
        LOWER(keywords.keyword) LIKE '%e field sensing%' OR
        LOWER(keywords.keyword) LIKE '%e field sensitive%' OR
        LOWER(keywords.keyword) LIKE '%electrometry%' OR
        LOWER(keywords.keyword) LIKE '%electric field detection%' OR
        LOWER(keywords.keyword) LIKE '%e field detection%'
      )
    ) OR (
      (
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensor%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%electric field%' OR
        LOWER(keywords.keyword) LIKE '%e-field%' OR
        LOWER(keywords.keyword) LIKE '%rydberg atom%'
      )
    ))"
  ))
keywords_qc314 <- dbFetch(keywords_qc314.SQL, n=-1)
length(unique(keywords_qc314$pubid)) # 0
save(keywords_qc314, file="R file/keywords_qc314.RData")
rm(keywords_qc314, keywords_qc314.SQL)

publication_qc314.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum%' OR
        LOWER(publication.abstract) LIKE '%rydberg atom%' OR
        LOWER(publication.abstract) LIKE '%quantum dot%' OR
        LOWER(publication.abstract) LIKE '%nv center%' OR
        LOWER(publication.abstract) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.abstract) LIKE '%boron nitride%' OR
        LOWER(publication.abstract) LIKE '%silicon carbide%' OR
        LOWER(publication.abstract) LIKE '%trapped ion%' OR
        LOWER(publication.abstract) LIKE '%optical cavity%'
      ) AND (
        LOWER(publication.abstract) LIKE '%electric field sensor%' OR
        LOWER(publication.abstract) LIKE '%electric field sensing%' OR
        LOWER(publication.abstract) LIKE '%e field sensor%' OR
        LOWER(publication.abstract) LIKE '%e field sensing%' OR
        LOWER(publication.abstract) LIKE '%e field sensitive%' OR
        LOWER(publication.abstract) LIKE '%electrometry%' OR
        LOWER(publication.abstract) LIKE '%electric field detection%' OR
        LOWER(publication.abstract) LIKE '%e field detection%'
      )
    ) OR (
      (
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.abstract) LIKE '%electric field%' OR
        LOWER(publication.abstract) LIKE '%e-field%' OR
        LOWER(publication.abstract) LIKE '%rydberg atom%'
      )
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' OR
        LOWER(publication.itemtitle) LIKE '%rydberg atom%' OR
        LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
        LOWER(publication.itemtitle) LIKE '%nv center%' OR
        LOWER(publication.itemtitle) LIKE '%nitrogen vacancy%' OR
        LOWER(publication.itemtitle) LIKE '%boron nitride%' OR
        LOWER(publication.itemtitle) LIKE '%silicon carbide%' OR
        LOWER(publication.itemtitle) LIKE '%trapped ion%' OR
        LOWER(publication.itemtitle) LIKE '%optical cavity%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%electric field sensor%' OR
        LOWER(publication.itemtitle) LIKE '%electric field sensing%' OR
        LOWER(publication.itemtitle) LIKE '%e field sensor%' OR
        LOWER(publication.itemtitle) LIKE '%e field sensing%' OR
        LOWER(publication.itemtitle) LIKE '%e field sensitive%' OR
        LOWER(publication.itemtitle) LIKE '%electrometry%' OR
        LOWER(publication.itemtitle) LIKE '%electric field detection%' OR
        LOWER(publication.itemtitle) LIKE '%e field detection%'
      )
    ) OR (
      (
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensor%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%electric field%' OR
        LOWER(publication.itemtitle) LIKE '%e-field%' OR
        LOWER(publication.itemtitle) LIKE '%rydberg atom%'
      )
    ))"
  ))
publication_qc314 <- dbFetch(publication_qc314.SQL, n=-1)
length(unique(publication_qc314$pubid)) # 107
save(publication_qc314, file="R file/publication_qc314.RData")
rm(publication_qc314, publication_qc314.SQL)

########################################

keywords_qc315.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND
      (
        LOWER(keywords.keyword) LIKE '%optic%' OR
        LOWER(keywords.keyword) LIKE '%photon%'
      ) AND (
        (
          (
            LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
            LOWER(keywords.keyword) LIKE '%quantum sensor%' OR
            LOWER(keywords.keyword) LIKE '%quantum sensors%' AND
            (
              LOWER(keywords.keyword) LIKE '%entanglement%' OR
              LOWER(keywords.keyword) LIKE '%entangled%' OR
              LOWER(keywords.keyword) LIKE '%interference%' OR
              LOWER(keywords.keyword) LIKE '%interferometer%' OR
              LOWER(keywords.keyword) LIKE '%spectrometer%' OR
              LOWER(keywords.keyword) LIKE '%spectrum%' OR
              LOWER(keywords.keyword) LIKE '%spectroscopy%' OR
              LOWER(keywords.keyword) LIKE '%quantum lidar%' OR
              LOWER(keywords.keyword) LIKE '%quantum radar%' OR
              LOWER(keywords.keyword) LIKE '%quantum illumination%' OR
              LOWER(keywords.keyword) LIKE '%squeezed%' OR
              LOWER(keywords.keyword) LIKE '%noon%' OR
              LOWER(keywords.keyword) LIKE '%n00n%' OR
              LOWER(keywords.keyword) LIKE '%optical parametric amplification%' OR
              LOWER(keywords.keyword) LIKE '%opa%' OR
              LOWER(keywords.keyword) LIKE '%single photon detector%' OR
              LOWER(keywords.keyword) LIKE '%single photon detection%' OR
              LOWER(keywords.keyword) LIKE '%transition-edge sensor%' OR
              LOWER(keywords.keyword) LIKE '%detect%efficiency%' OR
              LOWER(keywords.keyword) LIKE '%detect%calibrat%' OR
              LOWER(keywords.keyword) LIKE '%homodyne detection%'
            )
          ) OR
          (
            LOWER(keywords.keyword) LIKE '%ligo%' OR
            LOWER(keywords.keyword) LIKE '%virgo%' AND
            LOWER(keywords.keyword) LIKE '%squeezed%'
          )
        ) AND NOT (
          LOWER(keywords.keyword) LIKE '%nanodiamond%' OR
          LOWER(keywords.keyword) LIKE '%nano-diamond%' OR
          LOWER(keywords.keyword) LIKE '%diamond%' OR
          LOWER(keywords.keyword) LIKE '%rydberg%' OR
          LOWER(keywords.keyword) LIKE '%mri%' OR
          LOWER(keywords.keyword) LIKE '%magnetometer%' OR
          LOWER(keywords.keyword) LIKE '%squid%' OR
          LOWER(keywords.keyword) LIKE '%laser cooling%'
        )
      )
    )"
  ))
keywords_qc315 <- dbFetch(keywords_qc315.SQL, n=-1)
length(unique(keywords_qc315$pubid)) # 9
save(keywords_qc315, file="R file/keywords_qc315.RData")
rm(keywords_qc315, keywords_qc315.SQL)

publication_qc315.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND
      (
        LOWER(publication.abstract) LIKE '%optic%' OR
        LOWER(publication.abstract) LIKE '%photon%'
      ) AND (
        (
          (
            LOWER(publication.abstract) LIKE '%quantum sensing%' OR
            LOWER(publication.abstract) LIKE '%quantum sensor%' OR
            LOWER(publication.abstract) LIKE '%quantum sensors%' AND
            (
              LOWER(publication.abstract) LIKE '%entanglement%' OR
              LOWER(publication.abstract) LIKE '%entangled%' OR
              LOWER(publication.abstract) LIKE '%interference%' OR
              LOWER(publication.abstract) LIKE '%interferometer%' OR
              LOWER(publication.abstract) LIKE '%spectrometer%' OR
              LOWER(publication.abstract) LIKE '%spectrum%' OR
              LOWER(publication.abstract) LIKE '%spectroscopy%' OR
              LOWER(publication.abstract) LIKE '%quantum lidar%' OR
              LOWER(publication.abstract) LIKE '%quantum radar%' OR
              LOWER(publication.abstract) LIKE '%quantum illumination%' OR
              LOWER(publication.abstract) LIKE '%squeezed%' OR
              LOWER(publication.abstract) LIKE '%noon%' OR
              LOWER(publication.abstract) LIKE '%n00n%' OR
              LOWER(publication.abstract) LIKE '%optical parametric amplification%' OR
              LOWER(publication.abstract) LIKE '%opa%' OR
              LOWER(publication.abstract) LIKE '%single photon detector%' OR
              LOWER(publication.abstract) LIKE '%single photon detection%' OR
              LOWER(publication.abstract) LIKE '%transition-edge sensor%' OR
              LOWER(publication.abstract) LIKE '%detect%efficiency%' OR
              LOWER(publication.abstract) LIKE '%detect%calibrat%' OR
              LOWER(publication.abstract) LIKE '%homodyne detection%'
            )
          ) OR
          (
            LOWER(publication.abstract) LIKE '%ligo%' OR
            LOWER(publication.abstract) LIKE '%virgo%' AND
            LOWER(publication.abstract) LIKE '%squeezed%'
          )
        ) AND NOT (
          LOWER(publication.abstract) LIKE '%nanodiamond%' OR
          LOWER(publication.abstract) LIKE '%nano-diamond%' OR
          LOWER(publication.abstract) LIKE '%diamond%' OR
          LOWER(publication.abstract) LIKE '%rydberg%' OR
          LOWER(publication.abstract) LIKE '%mri%' OR
          LOWER(publication.abstract) LIKE '%magnetometer%' OR
          LOWER(publication.abstract) LIKE '%squid%' OR
          LOWER(publication.abstract) LIKE '%laser cooling%'
        )
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND
      (
        LOWER(publication.itemtitle) LIKE '%optic%' OR
        LOWER(publication.itemtitle) LIKE '%photon%'
      ) AND (
        (
          (
            LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
            LOWER(publication.itemtitle) LIKE '%quantum sensor%' OR
            LOWER(publication.itemtitle) LIKE '%quantum sensors%' AND
            (
              LOWER(publication.itemtitle) LIKE '%entanglement%' OR
              LOWER(publication.itemtitle) LIKE '%entangled%' OR
              LOWER(publication.itemtitle) LIKE '%interference%' OR
              LOWER(publication.itemtitle) LIKE '%interferometer%' OR
              LOWER(publication.itemtitle) LIKE '%spectrometer%' OR
              LOWER(publication.itemtitle) LIKE '%spectrum%' OR
              LOWER(publication.itemtitle) LIKE '%spectroscopy%' OR
              LOWER(publication.itemtitle) LIKE '%quantum lidar%' OR
              LOWER(publication.itemtitle) LIKE '%quantum radar%' OR
              LOWER(publication.itemtitle) LIKE '%quantum illumination%' OR
              LOWER(publication.itemtitle) LIKE '%squeezed%' OR
              LOWER(publication.itemtitle) LIKE '%noon%' OR
              LOWER(publication.itemtitle) LIKE '%n00n%' OR
              LOWER(publication.itemtitle) LIKE '%optical parametric amplification%' OR
              LOWER(publication.itemtitle) LIKE '%opa%' OR
              LOWER(publication.itemtitle) LIKE '%single photon detector%' OR
              LOWER(publication.itemtitle) LIKE '%single photon detection%' OR
              LOWER(publication.itemtitle) LIKE '%transition-edge sensor%' OR
              LOWER(publication.itemtitle) LIKE '%detect%efficiency%' OR
              LOWER(publication.itemtitle) LIKE '%detect%calibrat%' OR
              LOWER(publication.itemtitle) LIKE '%homodyne detection%'
            )
          ) OR
          (
            LOWER(publication.itemtitle) LIKE '%ligo%' OR
            LOWER(publication.itemtitle) LIKE '%virgo%' AND
            LOWER(publication.itemtitle) LIKE '%squeezed%'
          )
        ) AND NOT (
          LOWER(publication.itemtitle) LIKE '%nanodiamond%' OR
          LOWER(publication.itemtitle) LIKE '%nano-diamond%' OR
          LOWER(publication.itemtitle) LIKE '%diamond%' OR
          LOWER(publication.itemtitle) LIKE '%rydberg%' OR
          LOWER(publication.itemtitle) LIKE '%mri%' OR
          LOWER(publication.itemtitle) LIKE '%magnetometer%' OR
          LOWER(publication.itemtitle) LIKE '%squid%' OR
          LOWER(publication.itemtitle) LIKE '%laser cooling%'
        )
      )
    )"
  ))
publication_qc315 <- dbFetch(publication_qc315.SQL, n=-1)
length(unique(publication_qc315$pubid)) # 9
save(publication_qc315, file="R file/publication_qc315.RData")
rm(publication_qc315, publication_qc315.SQL)

########################################

keywords_qc32.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND (
        LOWER(keywords.keyword) LIKE '%quantum sensor%' OR
        LOWER(keywords.keyword) LIKE '%quantum sensing%' OR
        LOWER(keywords.keyword) LIKE '%quantum metrology%' OR
        LOWER(keywords.keyword) LIKE '%quantum limit%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%cramer-rao%' OR
        LOWER(keywords.keyword) LIKE '%fisher information%' OR
        (
          LOWER(keywords.keyword) LIKE '%limit%' AND (
            LOWER(keywords.keyword) LIKE '%heisenberg%' OR
            LOWER(keywords.keyword) LIKE '%standard quantum%' OR
            LOWER(keywords.keyword) LIKE '%shot-noise%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%heisenberg scaling%' OR
        (
          LOWER(keywords.keyword) LIKE '%estimation%' AND (
            LOWER(keywords.keyword) LIKE '%parameter%' OR
            LOWER(keywords.keyword) LIKE '%simultaneous%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%distributed sensing%' OR
        LOWER(keywords.keyword) LIKE '%remote sensing%' OR
        LOWER(keywords.keyword) LIKE '%state estimation%' OR
        LOWER(keywords.keyword) LIKE '%state tomography%' OR
        LOWER(keywords.keyword) LIKE '%state inference%' OR
        LOWER(keywords.keyword) LIKE '%state reconstruction%' OR
        LOWER(keywords.keyword) LIKE '%compressive tomography%' OR
        LOWER(keywords.keyword) LIKE '%compressed sensing%' OR
        (
          (
            LOWER(keywords.keyword) LIKE '%quantum image%' OR
            LOWER(keywords.keyword) LIKE '%quantum images%' OR
            LOWER(keywords.keyword) LIKE '%quantum imaging%' OR
            LOWER(keywords.keyword) LIKE '%rayleigh%' OR
            LOWER(keywords.keyword) LIKE '%abbe%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%superresolution%' OR
            LOWER(keywords.keyword) LIKE '%super-resolution%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%entanglement of formation%' OR
        LOWER(keywords.keyword) LIKE '%concurrence%' OR
        LOWER(keywords.keyword) LIKE '%entanglement monotone%' OR
        LOWER(keywords.keyword) LIKE '%entanglement measure%' OR
        LOWER(keywords.keyword) LIKE '%entanglement witness%' OR
        LOWER(keywords.keyword) LIKE '%entanglement negativity%' OR
        LOWER(keywords.keyword) LIKE '%positive partial transpose%' OR
        LOWER(keywords.keyword) LIKE '%discord%' OR
        LOWER(keywords.keyword) LIKE '%steering%' OR
        (
          LOWER(keywords.keyword) LIKE '%bell%' AND (
            LOWER(keywords.keyword) LIKE '%inequality%' OR
            LOWER(keywords.keyword) LIKE '%violation%' OR
            LOWER(keywords.keyword) LIKE '%theorem%' OR
            LOWER(keywords.keyword) LIKE '%test%'
          )
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%noise%' AND (
            LOWER(keywords.keyword) LIKE '%cancellation%' OR
            LOWER(keywords.keyword) LIKE '%suppression%'
          )
        ) OR
        LOWER(keywords.keyword) LIKE '%state discrimination%' OR
        LOWER(keywords.keyword) LIKE '%hypothesis test%' OR
        LOWER(keywords.keyword) LIKE '%hypothesis testing%' OR
        LOWER(keywords.keyword) LIKE '%quantum illumination%' OR
        LOWER(keywords.keyword) LIKE '%target detection%' OR
        LOWER(keywords.keyword) LIKE '%quantum fidelity%' OR
        LOWER(keywords.keyword) LIKE '%bhattacharyya bound%' OR
        LOWER(keywords.keyword) LIKE '%chernoff bound%' OR
        LOWER(keywords.keyword) LIKE '%error probability%'
      )
    )"
  ))
keywords_qc32 <- dbFetch(keywords_qc32.SQL, n=-1)
length(unique(keywords_qc32$pubid)) # 9
save(keywords_qc32, file="R file/keywords_qc32.RData")
rm(keywords_qc32, keywords_qc32.SQL)

publication_qc32.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND (
        LOWER(publication.abstract) LIKE '%quantum sensor%' OR
        LOWER(publication.abstract) LIKE '%quantum sensing%' OR
        LOWER(publication.abstract) LIKE '%quantum metrology%' OR
        LOWER(publication.abstract) LIKE '%quantum limit%'
      ) AND (
        LOWER(publication.abstract) LIKE '%cramer-rao%' OR
        LOWER(publication.abstract) LIKE '%fisher information%' OR
        (
          LOWER(publication.abstract) LIKE '%limit%' AND (
            LOWER(publication.abstract) LIKE '%heisenberg%' OR
            LOWER(publication.abstract) LIKE '%standard quantum%' OR
            LOWER(publication.abstract) LIKE '%shot-noise%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%heisenberg scaling%' OR
        (
          LOWER(publication.abstract) LIKE '%estimation%' AND (
            LOWER(publication.abstract) LIKE '%parameter%' OR
            LOWER(publication.abstract) LIKE '%simultaneous%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%distributed sensing%' OR
        LOWER(publication.abstract) LIKE '%remote sensing%' OR
        LOWER(publication.abstract) LIKE '%state estimation%' OR
        LOWER(publication.abstract) LIKE '%state tomography%' OR
        LOWER(publication.abstract) LIKE '%state inference%' OR
        LOWER(publication.abstract) LIKE '%state reconstruction%' OR
        LOWER(publication.abstract) LIKE '%compressive tomography%' OR
        LOWER(publication.abstract) LIKE '%compressed sensing%' OR
        (
          (
            LOWER(publication.abstract) LIKE '%quantum image%' OR
            LOWER(publication.abstract) LIKE '%quantum images%' OR
            LOWER(publication.abstract) LIKE '%quantum imaging%' OR
            LOWER(publication.abstract) LIKE '%rayleigh%' OR
            LOWER(publication.abstract) LIKE '%abbe%'
          ) AND (
            LOWER(publication.abstract) LIKE '%superresolution%' OR
            LOWER(publication.abstract) LIKE '%super-resolution%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%entanglement of formation%' OR
        LOWER(publication.abstract) LIKE '%concurrence%' OR
        LOWER(publication.abstract) LIKE '%entanglement monotone%' OR
        LOWER(publication.abstract) LIKE '%entanglement measure%' OR
        LOWER(publication.abstract) LIKE '%entanglement witness%' OR
        LOWER(publication.abstract) LIKE '%entanglement negativity%' OR
        LOWER(publication.abstract) LIKE '%positive partial transpose%' OR
        LOWER(publication.abstract) LIKE '%discord%' OR
        LOWER(publication.abstract) LIKE '%steering%' OR
        (
          LOWER(publication.abstract) LIKE '%bell%' AND (
            LOWER(publication.abstract) LIKE '%inequality%' OR
            LOWER(publication.abstract) LIKE '%violation%' OR
            LOWER(publication.abstract) LIKE '%theorem%' OR
            LOWER(publication.abstract) LIKE '%test%'
          )
        ) OR
        (
          LOWER(publication.abstract) LIKE '%noise%' AND (
            LOWER(publication.abstract) LIKE '%cancellation%' OR
            LOWER(publication.abstract) LIKE '%suppression%'
          )
        ) OR
        LOWER(publication.abstract) LIKE '%state discrimination%' OR
        LOWER(publication.abstract) LIKE '%hypothesis test%' OR
        LOWER(publication.abstract) LIKE '%hypothesis testing%' OR
        LOWER(publication.abstract) LIKE '%quantum illumination%' OR
        LOWER(publication.abstract) LIKE '%target detection%' OR
        LOWER(publication.abstract) LIKE '%quantum fidelity%' OR
        LOWER(publication.abstract) LIKE '%bhattacharyya bound%' OR
        LOWER(publication.abstract) LIKE '%chernoff bound%' OR
        LOWER(publication.abstract) LIKE '%error probability%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND (
        LOWER(publication.itemtitle) LIKE '%quantum sensor%' OR
        LOWER(publication.itemtitle) LIKE '%quantum sensing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum metrology%' OR
        LOWER(publication.itemtitle) LIKE '%quantum limit%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%cramer-rao%' OR
        LOWER(publication.itemtitle) LIKE '%fisher information%' OR
        (
          LOWER(publication.itemtitle) LIKE '%limit%' AND (
            LOWER(publication.itemtitle) LIKE '%heisenberg%' OR
            LOWER(publication.itemtitle) LIKE '%standard quantum%' OR
            LOWER(publication.itemtitle) LIKE '%shot-noise%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%heisenberg scaling%' OR
        (
          LOWER(publication.itemtitle) LIKE '%estimation%' AND (
            LOWER(publication.itemtitle) LIKE '%parameter%' OR
            LOWER(publication.itemtitle) LIKE '%simultaneous%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%distributed sensing%' OR
        LOWER(publication.itemtitle) LIKE '%remote sensing%' OR
        LOWER(publication.itemtitle) LIKE '%state estimation%' OR
        LOWER(publication.itemtitle) LIKE '%state tomography%' OR
        LOWER(publication.itemtitle) LIKE '%state inference%' OR
        LOWER(publication.itemtitle) LIKE '%state reconstruction%' OR
        LOWER(publication.itemtitle) LIKE '%compressive tomography%' OR
        LOWER(publication.itemtitle) LIKE '%compressed sensing%' OR
        (
          (
            LOWER(publication.itemtitle) LIKE '%quantum image%' OR
            LOWER(publication.itemtitle) LIKE '%quantum images%' OR
            LOWER(publication.itemtitle) LIKE '%quantum imaging%' OR
            LOWER(publication.itemtitle) LIKE '%rayleigh%' OR
            LOWER(publication.itemtitle) LIKE '%abbe%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%superresolution%' OR
            LOWER(publication.itemtitle) LIKE '%super-resolution%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%entanglement of formation%' OR
        LOWER(publication.itemtitle) LIKE '%concurrence%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement monotone%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement measure%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement witness%' OR
        LOWER(publication.itemtitle) LIKE '%entanglement negativity%' OR
        LOWER(publication.itemtitle) LIKE '%positive partial transpose%' OR
        LOWER(publication.itemtitle) LIKE '%discord%' OR
        LOWER(publication.itemtitle) LIKE '%steering%' OR
        (
          LOWER(publication.itemtitle) LIKE '%bell%' AND (
            LOWER(publication.itemtitle) LIKE '%inequality%' OR
            LOWER(publication.itemtitle) LIKE '%violation%' OR
            LOWER(publication.itemtitle) LIKE '%theorem%' OR
            LOWER(publication.itemtitle) LIKE '%test%'
          )
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%noise%' AND (
            LOWER(publication.itemtitle) LIKE '%cancellation%' OR
            LOWER(publication.itemtitle) LIKE '%suppression%'
          )
        ) OR
        LOWER(publication.itemtitle) LIKE '%state discrimination%' OR
        LOWER(publication.itemtitle) LIKE '%hypothesis test%' OR
        LOWER(publication.itemtitle) LIKE '%hypothesis testing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum illumination%' OR
        LOWER(publication.itemtitle) LIKE '%target detection%' OR
        LOWER(publication.itemtitle) LIKE '%quantum fidelity%' OR
        LOWER(publication.itemtitle) LIKE '%bhattacharyya bound%' OR
        LOWER(publication.itemtitle) LIKE '%chernoff bound%' OR
        LOWER(publication.itemtitle) LIKE '%error probability%'
      )
    )"
  ))
publication_qc32 <- dbFetch(publication_qc32.SQL, n=-1)
length(unique(publication_qc32$pubid)) # 9
save(publication_qc32, file="R file/publication_qc32.RData")
rm(publication_qc32, publication_qc32.SQL)

########################################

keywords_qc41.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum information%' OR
      LOWER(keywords.keyword) LIKE '%von neumann mutual information%' OR
      LOWER(keywords.keyword) LIKE '%quantum mutual information%' OR
      LOWER(keywords.keyword) LIKE '%quantum fisher information%'
    )"
  ))
keywords_qc41 <- dbFetch(keywords_qc41.SQL, n=-1)
length(unique(keywords_qc41$pubid)) # 9
save(keywords_qc41, file="R file/keywords_qc41.RData")
rm(keywords_qc41, keywords_qc41.SQL)

publication_qc41.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum information%' OR
      LOWER(publication.abstract) LIKE '%von neumann mutual information%' OR
      LOWER(publication.abstract) LIKE '%quantum mutual information%' OR
      LOWER(publication.abstract) LIKE '%quantum fisher information%'
    ) 
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum information%' OR
      LOWER(publication.itemtitle) LIKE '%von neumann mutual information%' OR
      LOWER(publication.itemtitle) LIKE '%quantum mutual information%' OR
      LOWER(publication.itemtitle) LIKE '%quantum fisher information%'
    )"
  ))
publication_qc41 <- dbFetch(publication_qc41.SQL, n=-1)
length(unique(publication_qc41$pubid)) # 16147
save(publication_qc41, file="R file/publication_qc41.RData")
rm(publication_qc41, publication_qc41.SQL)

########################################

keywords_qc421.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' OR
      LOWER(keywords.keyword) LIKE '%quantom%' OR
      LOWER(keywords.keyword) LIKE '%quantometer%' OR
      LOWER(keywords.keyword) LIKE '%quatum%'
    ) AND (
      LOWER(keywords.keyword) LIKE '%material%' OR
      LOWER(keywords.keyword) LIKE '%materials%' OR
      LOWER(keywords.keyword) LIKE '%substance%' OR
      LOWER(keywords.keyword) LIKE '%ingredient%' OR
      LOWER(keywords.keyword) LIKE '%part%' OR
      LOWER(keywords.keyword) LIKE '%component%' OR
      LOWER(keywords.keyword) LIKE '%components%' OR
      LOWER(keywords.keyword) LIKE '%equipmen%' OR
      LOWER(keywords.keyword) LIKE '%machine%' OR
      LOWER(keywords.keyword) LIKE '%machines%' OR
      LOWER(keywords.keyword) LIKE '%facility%' OR
      LOWER(keywords.keyword) LIKE '%facilities%' OR
      LOWER(keywords.keyword) LIKE '%apparatus%' OR
      LOWER(keywords.keyword) LIKE '%tool%' OR
      LOWER(keywords.keyword) LIKE '%tools%' OR
      LOWER(keywords.keyword) LIKE '%device%' OR
      LOWER(keywords.keyword) LIKE '%devices%'
    )"
  ))
keywords_qc421 <- dbFetch(keywords_qc421.SQL, n=-1)
length(unique(keywords_qc421$pubid)) # 
save(keywords_qc421, file="R file/keywords_qc421.RData")
rm(keywords_qc421, keywords_qc421.SQL)

publication_qc421.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      LOWER(publication.abstract) LIKE '%quantum%' OR
      LOWER(publication.abstract) LIKE '%quantom%' OR
      LOWER(publication.abstract) LIKE '%quantometer%' OR
      LOWER(publication.abstract) LIKE '%quatum%'
    ) AND (
      LOWER(publication.abstract) LIKE '%material%' OR
      LOWER(publication.abstract) LIKE '%materials%' OR
      LOWER(publication.abstract) LIKE '%substance%' OR
      LOWER(publication.abstract) LIKE '%ingredient%' OR
      LOWER(publication.abstract) LIKE '%part%' OR
      LOWER(publication.abstract) LIKE '%component%' OR
      LOWER(publication.abstract) LIKE '%components%' OR
      LOWER(publication.abstract) LIKE '%equipmen%' OR
      LOWER(publication.abstract) LIKE '%machine%' OR
      LOWER(publication.abstract) LIKE '%machines%' OR
      LOWER(publication.abstract) LIKE '%facility%' OR
      LOWER(publication.abstract) LIKE '%facilities%' OR
      LOWER(publication.abstract) LIKE '%apparatus%' OR
      LOWER(publication.abstract) LIKE '%tool%' OR
      LOWER(publication.abstract) LIKE '%tools%' OR
      LOWER(publication.abstract) LIKE '%device%' OR
      LOWER(publication.abstract) LIKE '%devices%'
    ))
    OR
    ((
      LOWER(publication.itemtitle) LIKE '%quantum%' OR
      LOWER(publication.itemtitle) LIKE '%quantom%' OR
      LOWER(publication.itemtitle) LIKE '%quantometer%' OR
      LOWER(publication.itemtitle) LIKE '%quatum%'
    ) AND (
      LOWER(publication.itemtitle) LIKE '%material%' OR
      LOWER(publication.itemtitle) LIKE '%materials%' OR
      LOWER(publication.itemtitle) LIKE '%substance%' OR
      LOWER(publication.itemtitle) LIKE '%ingredient%' OR
      LOWER(publication.itemtitle) LIKE '%part%' OR
      LOWER(publication.itemtitle) LIKE '%component%' OR
      LOWER(publication.itemtitle) LIKE '%components%' OR
      LOWER(publication.itemtitle) LIKE '%equipmen%' OR
      LOWER(publication.itemtitle) LIKE '%machine%' OR
      LOWER(publication.itemtitle) LIKE '%machines%' OR
      LOWER(publication.itemtitle) LIKE '%facility%' OR
      LOWER(publication.itemtitle) LIKE '%facilities%' OR
      LOWER(publication.itemtitle) LIKE '%apparatus%' OR
      LOWER(publication.itemtitle) LIKE '%tool%' OR
      LOWER(publication.itemtitle) LIKE '%tools%' OR
      LOWER(publication.itemtitle) LIKE '%device%' OR
      LOWER(publication.itemtitle) LIKE '%devices%'
    ))"
  ))
publication_qc421 <- dbFetch(publication_qc421.SQL, n=-1)
length(unique(publication_qc421$pubid)) # 
save(publication_qc421, file="R file/publication_qc421.RData")
rm(publication_qc421, publication_qc421.SQL)

########################################

keywords_qc422.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%lamp%' OR
        LOWER(keywords.keyword) LIKE '%led%' OR
        LOWER(keywords.keyword) LIKE '%illuminant%' OR
        LOWER(keywords.keyword) LIKE '%luminous%' OR
        LOWER(keywords.keyword) LIKE '%fluorescent%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%crystal%' OR
        LOWER(keywords.keyword) LIKE '%crystallin%' OR
        LOWER(keywords.keyword) LIKE '%crysta%' OR
        LOWER(keywords.keyword) LIKE '%crystalline%' OR
        LOWER(keywords.keyword) LIKE '%single-crystal%' OR
        LOWER(keywords.keyword) LIKE '%sic%' OR
        LOWER(keywords.keyword) LIKE '%nitrogen%' OR
        LOWER(keywords.keyword) LIKE '%nv%' OR
        LOWER(keywords.keyword) LIKE '%mpcvd%' OR
        LOWER(keywords.keyword) LIKE '%implantation%' OR
        LOWER(keywords.keyword) LIKE '%implantat%' OR
        LOWER(keywords.keyword) LIKE '%infuse%'
      )
    ) OR (
      LOWER(keywords.keyword) LIKE '%superconduct%' OR
      LOWER(keywords.keyword) LIKE '%superconductive%' OR
      LOWER(keywords.keyword) LIKE '%super-conduct%' OR
      LOWER(keywords.keyword) LIKE '%superconduction%' OR
      LOWER(keywords.keyword) LIKE '%supercond%' OR
      LOWER(keywords.keyword) LIKE '%super-cond%'
    ))"
  ))
keywords_qc422 <- dbFetch(keywords_qc422.SQL, n=-1)
length(unique(keywords_qc422$pubid)) # 
save(keywords_qc422, file="R file/keywords_qc422.RData")
rm(keywords_qc422, keywords_qc422.SQL)

publication_qc422.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%lamp%' OR
        LOWER(publication.abstract) LIKE '%led%' OR
        LOWER(publication.abstract) LIKE '%illuminant%' OR
        LOWER(publication.abstract) LIKE '%luminous%' OR
        LOWER(publication.abstract) LIKE '%fluorescent%'
      ) AND (
        LOWER(publication.abstract) LIKE '%crystal%' OR
        LOWER(publication.abstract) LIKE '%crystallin%' OR
        LOWER(publication.abstract) LIKE '%crysta%' OR
        LOWER(publication.abstract) LIKE '%crystalline%' OR
        LOWER(publication.abstract) LIKE '%single-crystal%' OR
        LOWER(publication.abstract) LIKE '%sic%' OR
        LOWER(publication.abstract) LIKE '%nitrogen%' OR
        LOWER(publication.abstract) LIKE '%nv%' OR
        LOWER(publication.abstract) LIKE '%mpcvd%' OR
        LOWER(publication.abstract) LIKE '%implantation%' OR
        LOWER(publication.abstract) LIKE '%implantat%' OR
        LOWER(publication.abstract) LIKE '%infuse%'
      )
    ) OR (
      LOWER(publication.abstract) LIKE '%superconduct%' OR
      LOWER(publication.abstract) LIKE '%superconductive%' OR
      LOWER(publication.abstract) LIKE '%super-conduct%' OR
      LOWER(publication.abstract) LIKE '%superconduction%' OR
      LOWER(publication.abstract) LIKE '%supercond%' OR
      LOWER(publication.abstract) LIKE '%super-cond%'
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%lamp%' OR
        LOWER(publication.itemtitle) LIKE '%led%' OR
        LOWER(publication.itemtitle) LIKE '%illuminant%' OR
        LOWER(publication.itemtitle) LIKE '%luminous%' OR
        LOWER(publication.itemtitle) LIKE '%fluorescent%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%crystal%' OR
        LOWER(publication.itemtitle) LIKE '%crystallin%' OR
        LOWER(publication.itemtitle) LIKE '%crysta%' OR
        LOWER(publication.itemtitle) LIKE '%crystalline%' OR
        LOWER(publication.itemtitle) LIKE '%single-crystal%' OR
        LOWER(publication.itemtitle) LIKE '%sic%' OR
        LOWER(publication.itemtitle) LIKE '%nitrogen%' OR
        LOWER(publication.itemtitle) LIKE '%nv%' OR
        LOWER(publication.itemtitle) LIKE '%mpcvd%' OR
        LOWER(publication.itemtitle) LIKE '%implantation%' OR
        LOWER(publication.itemtitle) LIKE '%implantat%' OR
        LOWER(publication.itemtitle) LIKE '%infuse%'
      )
    ) OR (
      LOWER(publication.itemtitle) LIKE '%superconduct%' OR
      LOWER(publication.itemtitle) LIKE '%superconductive%' OR
      LOWER(publication.itemtitle) LIKE '%super-conduct%' OR
      LOWER(publication.itemtitle) LIKE '%superconduction%' OR
      LOWER(publication.itemtitle) LIKE '%supercond%' OR
      LOWER(publication.itemtitle) LIKE '%super-cond%'
    ))"
  ))
publication_qc422 <- dbFetch(publication_qc422.SQL, n=-1)
length(unique(publication_qc422$pubid)) # 
save(publication_qc422, file="R file/publication_qc422.RData")
rm(publication_qc422, publication_qc422.SQL)

########################################

keywords_qc423.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%photon%' OR
        LOWER(keywords.keyword) LIKE '%photonic%' OR
        LOWER(keywords.keyword) LIKE '%photoluminescence%' OR
        LOWER(keywords.keyword) LIKE '%thinfilm%' OR
        LOWER(keywords.keyword) LIKE '%thin-film%' OR
        LOWER(keywords.keyword) LIKE '%film%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%silicon%' OR
        LOWER(keywords.keyword) LIKE '%ingaas%' OR
        LOWER(keywords.keyword) LIKE '%spad%' OR
        LOWER(keywords.keyword) LIKE '%diod%' OR
        LOWER(keywords.keyword) LIKE '%fet%' OR
        LOWER(keywords.keyword) LIKE '%lamp%' OR
        LOWER(keywords.keyword) LIKE '%led%' OR
        LOWER(keywords.keyword) LIKE '%luminous%' OR
        LOWER(keywords.keyword) LIKE '%fluorescent%' OR
        LOWER(keywords.keyword) LIKE '%collect%' OR
        LOWER(keywords.keyword) LIKE '%deposit%' OR
        LOWER(keywords.keyword) LIKE '%deposition%'
      )
    ) AND (
      LOWER(keywords.keyword) LIKE '%crystal%' OR
      LOWER(keywords.keyword) LIKE '%fret%' OR
      LOWER(keywords.keyword) LIKE '%dielectric%' OR
      LOWER(keywords.keyword) LIKE '%dielect%' OR
      LOWER(keywords.keyword) LIKE '%insulate-layer%'
    ))"
  ))
keywords_qc423 <- dbFetch(keywords_qc423.SQL, n=-1)
length(unique(keywords_qc423$pubid)) # 
save(keywords_qc423, file="R file/keywords_qc423.RData")
rm(keywords_qc423, keywords_qc423.SQL)

publication_qc423.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%photon%' OR
        LOWER(publication.abstract) LIKE '%photonic%' OR
        LOWER(publication.abstract) LIKE '%photoluminescence%' OR
        LOWER(publication.abstract) LIKE '%thinfilm%' OR
        LOWER(publication.abstract) LIKE '%thin-film%' OR
        LOWER(publication.abstract) LIKE '%film%'
      ) AND (
        LOWER(publication.abstract) LIKE '%silicon%' OR
        LOWER(publication.abstract) LIKE '%ingaas%' OR
        LOWER(publication.abstract) LIKE '%spad%' OR
        LOWER(publication.abstract) LIKE '%diod%' OR
        LOWER(publication.abstract) LIKE '%fet%' OR
        LOWER(publication.abstract) LIKE '%lamp%' OR
        LOWER(publication.abstract) LIKE '%led%' OR
        LOWER(publication.abstract) LIKE '%luminous%' OR
        LOWER(publication.abstract) LIKE '%fluorescent%' OR
        LOWER(publication.abstract) LIKE '%collect%' OR
        LOWER(publication.abstract) LIKE '%deposit%' OR
        LOWER(publication.abstract) LIKE '%deposition%'
      )
    ) AND (
      LOWER(publication.abstract) LIKE '%crystal%' OR
      LOWER(publication.abstract) LIKE '%fret%' OR
      LOWER(publication.abstract) LIKE '%dielectric%' OR
      LOWER(publication.abstract) LIKE '%dielect%' OR
      LOWER(publication.abstract) LIKE '%insulate-layer%'
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%photon%' OR
        LOWER(publication.itemtitle) LIKE '%photonic%' OR
        LOWER(publication.itemtitle) LIKE '%photoluminescence%' OR
        LOWER(publication.itemtitle) LIKE '%thinfilm%' OR
        LOWER(publication.itemtitle) LIKE '%thin-film%' OR
        LOWER(publication.itemtitle) LIKE '%film%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%silicon%' OR
        LOWER(publication.itemtitle) LIKE '%ingaas%' OR
        LOWER(publication.itemtitle) LIKE '%spad%' OR
        LOWER(publication.itemtitle) LIKE '%diod%' OR
        LOWER(publication.itemtitle) LIKE '%fet%' OR
        LOWER(publication.itemtitle) LIKE '%lamp%' OR
        LOWER(publication.itemtitle) LIKE '%led%' OR
        LOWER(publication.itemtitle) LIKE '%luminous%' OR
        LOWER(publication.itemtitle) LIKE '%fluorescent%' OR
        LOWER(publication.itemtitle) LIKE '%collect%' OR
        LOWER(publication.itemtitle) LIKE '%deposit%' OR
        LOWER(publication.itemtitle) LIKE '%deposition%'
      )
    ) AND (
      LOWER(publication.itemtitle) LIKE '%crystal%' OR
      LOWER(publication.itemtitle) LIKE '%fret%' OR
      LOWER(publication.itemtitle) LIKE '%dielectric%' OR
      LOWER(publication.itemtitle) LIKE '%dielect%' OR
      LOWER(publication.itemtitle) LIKE '%insulate-layer%'
    ))"
  ))
publication_qc423 <- dbFetch(publication_qc423.SQL, n=-1)
length(unique(publication_qc423$pubid)) # 
save(publication_qc423, file="R file/publication_qc423.RData")
rm(publication_qc423, publication_qc423.SQL)

########################################

keywords_qc424.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      LOWER(keywords.keyword) LIKE '%lnoi%' OR
      LOWER(keywords.keyword) LIKE '%dpss%' OR
      LOWER(keywords.keyword) LIKE '%hgtr%'
    ) AND (
      LOWER(keywords.keyword) LIKE '%amp%' OR
      LOWER(keywords.keyword) LIKE '%radioamplifier%' OR
      LOWER(keywords.keyword) LIKE '%amplifier%' OR
      LOWER(keywords.keyword) LIKE '%random%' OR
      LOWER(keywords.keyword) LIKE '%nonce%' OR
      LOWER(keywords.keyword) LIKE '%random-number%' OR
      LOWER(keywords.keyword) LIKE '%wave%' OR
      LOWER(keywords.keyword) LIKE '%cryogen%' OR
      LOWER(keywords.keyword) LIKE '%low-temperature%' OR
      LOWER(keywords.keyword) LIKE '%low-temper%' OR
      LOWER(keywords.keyword) LIKE '%liquidnitrogen%' OR
      LOWER(keywords.keyword) LIKE '%cryogenic%' OR
      LOWER(keywords.keyword) LIKE '%cryo%' OR
      LOWER(keywords.keyword) LIKE '%cold%' OR
      LOWER(keywords.keyword) LIKE '%refri%' OR
      LOWER(keywords.keyword) LIKE '%freez%' OR
      LOWER(keywords.keyword) LIKE '%micro-wave%' OR
      LOWER(keywords.keyword) LIKE '%magnetron%' OR
      LOWER(keywords.keyword) LIKE '%microwave%'
    ))"
  ))
keywords_qc424 <- dbFetch(keywords_qc424.SQL, n=-1)
length(unique(keywords_qc424$pubid)) # 
save(keywords_qc424, file="R file/keywords_qc424.RData")
rm(keywords_qc424, keywords_qc424.SQL)

publication_qc424.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      LOWER(publication.abstract) LIKE '%lnoi%' OR
      LOWER(publication.abstract) LIKE '%dpss%' OR
      LOWER(publication.abstract) LIKE '%hgtr%'
    ) AND (
      LOWER(publication.abstract) LIKE '%amp%' OR
      LOWER(publication.abstract) LIKE '%radioamplifier%' OR
      LOWER(publication.abstract) LIKE '%amplifier%' OR
      LOWER(publication.abstract) LIKE '%random%' OR
      LOWER(publication.abstract) LIKE '%nonce%' OR
      LOWER(publication.abstract) LIKE '%random-number%' OR
      LOWER(publication.abstract) LIKE '%wave%' OR
      LOWER(publication.abstract) LIKE '%cryogen%' OR
      LOWER(publication.abstract) LIKE '%low-temperature%' OR
      LOWER(publication.abstract) LIKE '%low-temper%' OR
      LOWER(publication.abstract) LIKE '%liquidnitrogen%' OR
      LOWER(publication.abstract) LIKE '%cryogenic%' OR
      LOWER(publication.abstract) LIKE '%cryo%' OR
      LOWER(publication.abstract) LIKE '%cold%' OR
      LOWER(publication.abstract) LIKE '%refri%' OR
      LOWER(publication.abstract) LIKE '%freez%' OR
      LOWER(publication.abstract) LIKE '%micro-wave%' OR
      LOWER(publication.abstract) LIKE '%magnetron%' OR
      LOWER(publication.abstract) LIKE '%microwave%'
    ))
    OR
    ((
      LOWER(publication.itemtitle) LIKE '%lnoi%' OR
      LOWER(publication.itemtitle) LIKE '%dpss%' OR
      LOWER(publication.itemtitle) LIKE '%hgtr%'
    ) AND (
      LOWER(publication.itemtitle) LIKE '%amp%' OR
      LOWER(publication.itemtitle) LIKE '%radioamplifier%' OR
      LOWER(publication.itemtitle) LIKE '%amplifier%' OR
      LOWER(publication.itemtitle) LIKE '%random%' OR
      LOWER(publication.itemtitle) LIKE '%nonce%' OR
      LOWER(publication.itemtitle) LIKE '%random-number%' OR
      LOWER(publication.itemtitle) LIKE '%wave%' OR
      LOWER(publication.itemtitle) LIKE '%cryogen%' OR
      LOWER(publication.itemtitle) LIKE '%low-temperature%' OR
      LOWER(publication.itemtitle) LIKE '%low-temper%' OR
      LOWER(publication.itemtitle) LIKE '%liquidnitrogen%' OR
      LOWER(publication.itemtitle) LIKE '%cryogenic%' OR
      LOWER(publication.itemtitle) LIKE '%cryo%' OR
      LOWER(publication.itemtitle) LIKE '%cold%' OR
      LOWER(publication.itemtitle) LIKE '%refri%' OR
      LOWER(publication.itemtitle) LIKE '%freez%' OR
      LOWER(publication.itemtitle) LIKE '%micro-wave%' OR
      LOWER(publication.itemtitle) LIKE '%magnetron%' OR
      LOWER(publication.itemtitle) LIKE '%microwave%'
    ))"
  ))
publication_qc424 <- dbFetch(publication_qc424.SQL, n=-1)
length(unique(publication_qc424$pubid)) # 
save(publication_qc424, file="R file/publication_qc424.RData")
rm(publication_qc424, publication_qc424.SQL)

########################################

keywords_qc43.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum information control%' OR
      LOWER(keywords.keyword) LIKE '%control% of quantum%' OR
      LOWER(keywords.keyword) LIKE '%control% over quantum%' OR
      LOWER(keywords.keyword) LIKE '%quantum optimal control%' OR
      LOWER(keywords.keyword) LIKE '%quantum state% control%' OR
      LOWER(keywords.keyword) LIKE '%control% quantum%' OR
      LOWER(keywords.keyword) LIKE '%control% the quantum%' OR
      LOWER(keywords.keyword) LIKE '%quantum coherent control%' OR
      LOWER(keywords.keyword) LIKE '%qubit control%' OR
      LOWER(keywords.keyword) LIKE '%control% of qubit%'
    )"
  ))
keywords_qc43 <- dbFetch(keywords_qc43.SQL, n=-1)
length(unique(keywords_qc43$pubid)) # 9
save(keywords_qc43, file="R file/keywords_qc43.RData")
rm(keywords_qc43, keywords_qc43.SQL)

publication_qc43.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum information control%' OR
      LOWER(publication.abstract) LIKE '%control% of quantum%' OR
      LOWER(publication.abstract) LIKE '%control% over quantum%' OR
      LOWER(publication.abstract) LIKE '%quantum optimal control%' OR
      LOWER(publication.abstract) LIKE '%quantum state% control%' OR
      LOWER(publication.abstract) LIKE '%control% quantum%' OR
      LOWER(publication.abstract) LIKE '%control% the quantum%' OR
      LOWER(publication.abstract) LIKE '%quantum coherent control%' OR
      LOWER(publication.abstract) LIKE '%qubit control%' OR
      LOWER(publication.abstract) LIKE '%control% of qubit%'
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum information control%' OR
      LOWER(publication.itemtitle) LIKE '%control% of quantum%' OR
      LOWER(publication.itemtitle) LIKE '%control% over quantum%' OR
      LOWER(publication.itemtitle) LIKE '%quantum optimal control%' OR
      LOWER(publication.itemtitle) LIKE '%quantum state% control%' OR
      LOWER(publication.itemtitle) LIKE '%control% quantum%' OR
      LOWER(publication.itemtitle) LIKE '%control% the quantum%' OR
      LOWER(publication.itemtitle) LIKE '%quantum coherent control%' OR
      LOWER(publication.itemtitle) LIKE '%qubit control%' OR
      LOWER(publication.itemtitle) LIKE '%control% of qubit%'
    )"
  ))
publication_qc43 <- dbFetch(publication_qc43.SQL, n=-1)
length(unique(publication_qc43$pubid)) # 
save(publication_qc43, file="R file/publication_qc43.RData")
rm(publication_qc43, publication_qc43.SQL)

########################################

keywords_qc441.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%superconduct%' AND
      (
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%qubit%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%transmon%' OR
        LOWER(keywords.keyword) LIKE '%circuit qed%' OR
        LOWER(keywords.keyword) LIKE '%fluxonium%' OR
        LOWER(keywords.keyword) LIKE '%charge qubit%' OR
        LOWER(keywords.keyword) LIKE '%flux qubit%' OR
        LOWER(keywords.keyword) LIKE '%phase qubit%' OR
        LOWER(keywords.keyword) LIKE '%decoherence%' OR
        LOWER(keywords.keyword) LIKE '%fidelity%'
      )
    )"
  ))
keywords_qc441 <- dbFetch(keywords_qc441.SQL, n=-1)
length(unique(keywords_qc441$pubid)) # 
save(keywords_qc441, file="R file/keywords_qc441.RData")
rm(keywords_qc441, keywords_qc441.SQL)

publication_qc441.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%superconduct%' AND
      (
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%qubit%'
      ) AND (
        LOWER(publication.abstract) LIKE '%transmon%' OR
        LOWER(publication.abstract) LIKE '%circuit qed%' OR
        LOWER(publication.abstract) LIKE '%fluxonium%' OR
        LOWER(publication.abstract) LIKE '%charge qubit%' OR
        LOWER(publication.abstract) LIKE '%flux qubit%' OR
        LOWER(publication.abstract) LIKE '%phase qubit%' OR
        LOWER(publication.abstract) LIKE '%decoherence%' OR
        LOWER(publication.abstract) LIKE '%fidelity%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%superconduct%' AND
      (
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%qubit%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%transmon%' OR
        LOWER(publication.itemtitle) LIKE '%circuit qed%' OR
        LOWER(publication.itemtitle) LIKE '%fluxonium%' OR
        LOWER(publication.itemtitle) LIKE '%charge qubit%' OR
        LOWER(publication.itemtitle) LIKE '%flux qubit%' OR
        LOWER(publication.itemtitle) LIKE '%phase qubit%' OR
        LOWER(publication.itemtitle) LIKE '%decoherence%' OR
        LOWER(publication.itemtitle) LIKE '%fidelity%'
      )
    )"
  ))
publication_qc441 <- dbFetch(publication_qc441.SQL, n=-1)
length(unique(publication_qc441$pubid)) # 
save(publication_qc441, file="R file/publication_qc441.RData")
rm(publication_qc441, publication_qc441.SQL)

########################################

keywords_qc442.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        LOWER(keywords.keyword) LIKE '%quantum%' OR
        LOWER(keywords.keyword) LIKE '%qubit%'
      ) AND (
        LOWER(keywords.keyword) LIKE '%ion trap%' OR
        LOWER(keywords.keyword) LIKE '%ion traps%' OR
        LOWER(keywords.keyword) LIKE '%trapped ion%' OR
        LOWER(keywords.keyword) LIKE '%trapped ions%' OR
        LOWER(keywords.keyword) LIKE '%ion chains%'
      )
    )"
  ))
keywords_qc442 <- dbFetch(keywords_qc442.SQL, n=-1)
length(unique(keywords_qc442$pubid)) # 
save(keywords_qc442, file="R file/keywords_qc442.RData")
rm(keywords_qc442, keywords_qc442.SQL)

publication_qc442.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        LOWER(publication.abstract) LIKE '%quantum%' OR
        LOWER(publication.abstract) LIKE '%qubit%'
      ) AND (
        LOWER(publication.abstract) LIKE '%ion trap%' OR
        LOWER(publication.abstract) LIKE '%ion traps%' OR
        LOWER(publication.abstract) LIKE '%trapped ion%' OR
        LOWER(publication.abstract) LIKE '%trapped ions%' OR
        LOWER(publication.abstract) LIKE '%ion chains%'
      )
    )
    OR
    (
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' OR
        LOWER(publication.itemtitle) LIKE '%qubit%'
      ) AND (
        LOWER(publication.itemtitle) LIKE '%ion trap%' OR
        LOWER(publication.itemtitle) LIKE '%ion traps%' OR
        LOWER(publication.itemtitle) LIKE '%trapped ion%' OR
        LOWER(publication.itemtitle) LIKE '%trapped ions%' OR
        LOWER(publication.itemtitle) LIKE '%ion chains%'
      )
    )"
  ))
publication_qc442 <- dbFetch(publication_qc442.SQL, n=-1)
length(unique(publication_qc442$pubid)) # 2690
save(publication_qc442, file="R file/publication_qc442.RData")
rm(publication_qc442, publication_qc442.SQL)

########################################

keywords_qc443.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      (
        (
          LOWER(keywords.keyword) LIKE '%quantum computing%' OR
          LOWER(keywords.keyword) LIKE '%quantum technology%' OR
          LOWER(keywords.keyword) LIKE '%quantum information%' OR
          LOWER(keywords.keyword) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%quantum dot%' OR
          LOWER(keywords.keyword) LIKE '%hybrid-circuit%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%spin qubit%' OR
          LOWER(keywords.keyword) LIKE '%charge qubit%' OR
          LOWER(keywords.keyword) LIKE '%singlet triplet%' OR
          LOWER(keywords.keyword) LIKE '%exchange only qubit%' OR
          LOWER(keywords.keyword) LIKE '%hybrid qubit%' OR
          LOWER(keywords.keyword) LIKE '%rabi%' OR
          LOWER(keywords.keyword) LIKE '%ramsey%' OR
          LOWER(keywords.keyword) LIKE '%spin resonance%' OR
          LOWER(keywords.keyword) LIKE '%electric dipole spin%' OR
          LOWER(keywords.keyword) LIKE '%spin echo%' OR
          LOWER(keywords.keyword) LIKE '%cpmg%' OR
          LOWER(keywords.keyword) LIKE '%dynamical decoupling%' OR
          LOWER(keywords.keyword) LIKE '%tomography%' OR
          LOWER(keywords.keyword) LIKE '%fidelity%' OR
          LOWER(keywords.keyword) LIKE '%spin-photon%' OR
          LOWER(keywords.keyword) LIKE '%photon-mediated%' OR
          LOWER(keywords.keyword) LIKE '%cavity-mediated%' OR
          LOWER(keywords.keyword) LIKE '%long range%' OR
          LOWER(keywords.keyword) LIKE '%exchange interaction%' OR
          LOWER(keywords.keyword) LIKE '%spin-spin%' OR
          LOWER(keywords.keyword) LIKE '%two-qubit%' OR
          LOWER(keywords.keyword) LIKE '%benchmark%' OR
          LOWER(keywords.keyword) LIKE '%shuttling%' OR
          LOWER(keywords.keyword) LIKE '%scaling%' OR
          LOWER(keywords.keyword) LIKE '%architecture%' OR
          LOWER(keywords.keyword) LIKE '%high temperature operation%' OR
          LOWER(keywords.keyword) LIKE '%cmos%' OR
          LOWER(keywords.keyword) LIKE '%silicon%' OR
          LOWER(keywords.keyword) LIKE '%superconductor-semiconductor%' OR
          LOWER(keywords.keyword) LIKE '%microwave-mediated%' OR
          LOWER(keywords.keyword) LIKE '%germanium%' OR
          LOWER(keywords.keyword) LIKE '%gaas%' OR
          LOWER(keywords.keyword) LIKE '%isotopically enriched%' OR
          LOWER(keywords.keyword) LIKE '%isotopically purified silicon%' OR
          LOWER(keywords.keyword) LIKE '%single-shot%' OR
          LOWER(keywords.keyword) LIKE '%reflectometry%' OR
          LOWER(keywords.keyword) LIKE '%pauli spin blockade%' OR
          LOWER(keywords.keyword) LIKE '%energy selective tunneling%' OR
          LOWER(keywords.keyword) LIKE '%parity readout%' OR
          LOWER(keywords.keyword) LIKE '%foundry fabrication%'
        ) AND NOT (
          LOWER(keywords.keyword) LIKE '%self-assembled%' OR
          LOWER(keywords.keyword) LIKE '%colloidal%' OR
          LOWER(keywords.keyword) LIKE '%solar cell%' OR
          LOWER(keywords.keyword) LIKE '%automata%' OR
          LOWER(keywords.keyword) LIKE '%photon source%' OR
          LOWER(keywords.keyword) LIKE '%single photon emitter%' OR
          LOWER(keywords.keyword) LIKE '%telecom%' OR
          LOWER(keywords.keyword) LIKE '%telecommunication%' OR
          LOWER(keywords.keyword) LIKE '%droplet%' OR
          LOWER(keywords.keyword) LIKE '%ion trap%' OR
          LOWER(keywords.keyword) LIKE '%nanophotonic%'
        )
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%spin qubit%' OR
          LOWER(keywords.keyword) LIKE '%qubit%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%quantum dot%' OR
          LOWER(keywords.keyword) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%silicon%' OR
          LOWER(keywords.keyword) LIKE '%germanium%' OR
          LOWER(keywords.keyword) LIKE '%silicon-based%' OR
          LOWER(keywords.keyword) LIKE '%cmos-based%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%programmable%' OR
          LOWER(keywords.keyword) LIKE '%cryogenic control%' OR
          LOWER(keywords.keyword) LIKE '%three-qubit%' OR
          LOWER(keywords.keyword) LIKE '%quantum tomography%' OR
          LOWER(keywords.keyword) LIKE '%benchmark%' OR
          LOWER(keywords.keyword) LIKE '%scaling%' OR
          LOWER(keywords.keyword) LIKE '%two qubit%' OR
          LOWER(keywords.keyword) LIKE '%resonant swap%' OR
          LOWER(keywords.keyword) LIKE '%controlled not%' OR
          LOWER(keywords.keyword) LIKE '%cnot%' OR
          LOWER(keywords.keyword) LIKE '%cphase%' OR
          LOWER(keywords.keyword) LIKE '%controlled phase%' OR
          LOWER(keywords.keyword) LIKE '%spin qubit%' OR
          LOWER(keywords.keyword) LIKE '%fidelity%' OR
          LOWER(keywords.keyword) LIKE '%quantum processor%' OR
          LOWER(keywords.keyword) LIKE '%spin-photon%' OR
          LOWER(keywords.keyword) LIKE '%long range%' OR
          LOWER(keywords.keyword) LIKE '%singlet triplet%' OR
          LOWER(keywords.keyword) LIKE '%spin resonance%' OR
          LOWER(keywords.keyword) LIKE '%resonantly driven%'
        )
      )
    )"
  ))
keywords_qc443 <- dbFetch(keywords_qc443.SQL, n=-1)
length(unique(keywords_qc443$pubid)) # 0
save(keywords_qc443, file="R file/keywords_qc443.RData")
rm(keywords_qc443, keywords_qc443.SQL)

publication_qc443.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      (
        (
          LOWER(publication.abstract) LIKE '%quantum computing%' OR
          LOWER(publication.abstract) LIKE '%quantum technology%' OR
          LOWER(publication.abstract) LIKE '%quantum information%' OR
          LOWER(publication.abstract) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(publication.abstract) LIKE '%quantum dot%' OR
          LOWER(publication.abstract) LIKE '%hybrid-circuit%'
        ) AND (
          LOWER(publication.abstract) LIKE '%spin qubit%' OR
          LOWER(publication.abstract) LIKE '%charge qubit%' OR
          LOWER(publication.abstract) LIKE '%singlet triplet%' OR
          LOWER(publication.abstract) LIKE '%exchange only qubit%' OR
          LOWER(publication.abstract) LIKE '%hybrid qubit%' OR
          LOWER(publication.abstract) LIKE '%rabi%' OR
          LOWER(publication.abstract) LIKE '%ramsey%' OR
          LOWER(publication.abstract) LIKE '%spin resonance%' OR
          LOWER(publication.abstract) LIKE '%electric dipole spin%' OR
          LOWER(publication.abstract) LIKE '%spin echo%' OR
          LOWER(publication.abstract) LIKE '%cpmg%' OR
          LOWER(publication.abstract) LIKE '%dynamical decoupling%' OR
          LOWER(publication.abstract) LIKE '%tomography%' OR
          LOWER(publication.abstract) LIKE '%fidelity%' OR
          LOWER(publication.abstract) LIKE '%spin-photon%' OR
          LOWER(publication.abstract) LIKE '%photon-mediated%' OR
          LOWER(publication.abstract) LIKE '%cavity-mediated%' OR
          LOWER(publication.abstract) LIKE '%long range%' OR
          LOWER(publication.abstract) LIKE '%exchange interaction%' OR
          LOWER(publication.abstract) LIKE '%spin-spin%' OR
          LOWER(publication.abstract) LIKE '%two-qubit%' OR
          LOWER(publication.abstract) LIKE '%benchmark%' OR
          LOWER(publication.abstract) LIKE '%shuttling%' OR
          LOWER(publication.abstract) LIKE '%scaling%' OR
          LOWER(publication.abstract) LIKE '%architecture%' OR
          LOWER(publication.abstract) LIKE '%high temperature operation%' OR
          LOWER(publication.abstract) LIKE '%cmos%' OR
          LOWER(publication.abstract) LIKE '%silicon%' OR
          LOWER(publication.abstract) LIKE '%superconductor-semiconductor%' OR
          LOWER(publication.abstract) LIKE '%microwave-mediated%' OR
          LOWER(publication.abstract) LIKE '%germanium%' OR
          LOWER(publication.abstract) LIKE '%gaas%' OR
          LOWER(publication.abstract) LIKE '%isotopically enriched%' OR
          LOWER(publication.abstract) LIKE '%isotopically purified silicon%' OR
          LOWER(publication.abstract) LIKE '%single-shot%' OR
          LOWER(publication.abstract) LIKE '%reflectometry%' OR
          LOWER(publication.abstract) LIKE '%pauli spin blockade%' OR
          LOWER(publication.abstract) LIKE '%energy selective tunneling%' OR
          LOWER(publication.abstract) LIKE '%parity readout%' OR
          LOWER(publication.abstract) LIKE '%foundry fabrication%'
        ) AND NOT (
          LOWER(publication.abstract) LIKE '%self-assembled%' OR
          LOWER(publication.abstract) LIKE '%colloidal%' OR
          LOWER(publication.abstract) LIKE '%solar cell%' OR
          LOWER(publication.abstract) LIKE '%automata%' OR
          LOWER(publication.abstract) LIKE '%photon source%' OR
          LOWER(publication.abstract) LIKE '%single photon emitter%' OR
          LOWER(publication.abstract) LIKE '%telecom%' OR
          LOWER(publication.abstract) LIKE '%telecommunication%' OR
          LOWER(publication.abstract) LIKE '%droplet%' OR
          LOWER(publication.abstract) LIKE '%ion trap%' OR
          LOWER(publication.abstract) LIKE '%nanophotonic%'
        )
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%spin qubit%' OR
          LOWER(publication.abstract) LIKE '%qubit%'
        ) AND (
          LOWER(publication.abstract) LIKE '%quantum dot%' OR
          LOWER(publication.abstract) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(publication.abstract) LIKE '%silicon%' OR
          LOWER(publication.abstract) LIKE '%germanium%' OR
          LOWER(publication.abstract) LIKE '%silicon-based%' OR
          LOWER(publication.abstract) LIKE '%cmos-based%'
        ) AND (
          LOWER(publication.abstract) LIKE '%programmable%' OR
          LOWER(publication.abstract) LIKE '%cryogenic control%' OR
          LOWER(publication.abstract) LIKE '%three-qubit%' OR
          LOWER(publication.abstract) LIKE '%quantum tomography%' OR
          LOWER(publication.abstract) LIKE '%benchmark%' OR
          LOWER(publication.abstract) LIKE '%scaling%' OR
          LOWER(publication.abstract) LIKE '%two qubit%' OR
          LOWER(publication.abstract) LIKE '%resonant swap%' OR
          LOWER(publication.abstract) LIKE '%controlled not%' OR
          LOWER(publication.abstract) LIKE '%cnot%' OR
          LOWER(publication.abstract) LIKE '%cphase%' OR
          LOWER(publication.abstract) LIKE '%controlled phase%' OR
          LOWER(publication.abstract) LIKE '%spin qubit%' OR
          LOWER(publication.abstract) LIKE '%fidelity%' OR
          LOWER(publication.abstract) LIKE '%quantum processor%' OR
          LOWER(publication.abstract) LIKE '%spin-photon%' OR
          LOWER(publication.abstract) LIKE '%long range%' OR
          LOWER(publication.abstract) LIKE '%singlet triplet%' OR
          LOWER(publication.abstract) LIKE '%spin resonance%' OR
          LOWER(publication.abstract) LIKE '%resonantly driven%'
        )
      )
    )
    OR
    (
      (
        (
          LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
          LOWER(publication.itemtitle) LIKE '%quantum technology%' OR
          LOWER(publication.itemtitle) LIKE '%quantum information%' OR
          LOWER(publication.itemtitle) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
          LOWER(publication.itemtitle) LIKE '%hybrid-circuit%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%spin qubit%' OR
          LOWER(publication.itemtitle) LIKE '%charge qubit%' OR
          LOWER(publication.itemtitle) LIKE '%singlet triplet%' OR
          LOWER(publication.itemtitle) LIKE '%exchange only qubit%' OR
          LOWER(publication.itemtitle) LIKE '%hybrid qubit%' OR
          LOWER(publication.itemtitle) LIKE '%rabi%' OR
          LOWER(publication.itemtitle) LIKE '%ramsey%' OR
          LOWER(publication.itemtitle) LIKE '%spin resonance%' OR
          LOWER(publication.itemtitle) LIKE '%electric dipole spin%' OR
          LOWER(publication.itemtitle) LIKE '%spin echo%' OR
          LOWER(publication.itemtitle) LIKE '%cpmg%' OR
          LOWER(publication.itemtitle) LIKE '%dynamical decoupling%' OR
          LOWER(publication.itemtitle) LIKE '%tomography%' OR
          LOWER(publication.itemtitle) LIKE '%fidelity%' OR
          LOWER(publication.itemtitle) LIKE '%spin-photon%' OR
          LOWER(publication.itemtitle) LIKE '%photon-mediated%' OR
          LOWER(publication.itemtitle) LIKE '%cavity-mediated%' OR
          LOWER(publication.itemtitle) LIKE '%long range%' OR
          LOWER(publication.itemtitle) LIKE '%exchange interaction%' OR
          LOWER(publication.itemtitle) LIKE '%spin-spin%' OR
          LOWER(publication.itemtitle) LIKE '%two-qubit%' OR
          LOWER(publication.itemtitle) LIKE '%benchmark%' OR
          LOWER(publication.itemtitle) LIKE '%shuttling%' OR
          LOWER(publication.itemtitle) LIKE '%scaling%' OR
          LOWER(publication.itemtitle) LIKE '%architecture%' OR
          LOWER(publication.itemtitle) LIKE '%high temperature operation%' OR
          LOWER(publication.itemtitle) LIKE '%cmos%' OR
          LOWER(publication.itemtitle) LIKE '%silicon%' OR
          LOWER(publication.itemtitle) LIKE '%superconductor-semiconductor%' OR
          LOWER(publication.itemtitle) LIKE '%microwave-mediated%' OR
          LOWER(publication.itemtitle) LIKE '%germanium%' OR
          LOWER(publication.itemtitle) LIKE '%gaas%' OR
          LOWER(publication.itemtitle) LIKE '%isotopically enriched%' OR
          LOWER(publication.itemtitle) LIKE '%isotopically purified silicon%' OR
          LOWER(publication.itemtitle) LIKE '%single-shot%' OR
          LOWER(publication.itemtitle) LIKE '%reflectometry%' OR
          LOWER(publication.itemtitle) LIKE '%pauli spin blockade%' OR
          LOWER(publication.itemtitle) LIKE '%energy selective tunneling%' OR
          LOWER(publication.itemtitle) LIKE '%parity readout%' OR
          LOWER(publication.itemtitle) LIKE '%foundry fabrication%'
        ) AND NOT (
          LOWER(publication.itemtitle) LIKE '%self-assembled%' OR
          LOWER(publication.itemtitle) LIKE '%colloidal%' OR
          LOWER(publication.itemtitle) LIKE '%solar cell%' OR
          LOWER(publication.itemtitle) LIKE '%automata%' OR
          LOWER(publication.itemtitle) LIKE '%photon source%' OR
          LOWER(publication.itemtitle) LIKE '%single photon emitter%' OR
          LOWER(publication.itemtitle) LIKE '%telecom%' OR
          LOWER(publication.itemtitle) LIKE '%telecommunication%' OR
          LOWER(publication.itemtitle) LIKE '%droplet%' OR
          LOWER(publication.itemtitle) LIKE '%ion trap%' OR
          LOWER(publication.itemtitle) LIKE '%nanophotonic%'
        )
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%spin qubit%' OR
          LOWER(publication.itemtitle) LIKE '%qubit%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
          LOWER(publication.itemtitle) LIKE '%quantum electrodynamics%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%silicon%' OR
          LOWER(publication.itemtitle) LIKE '%germanium%' OR
          LOWER(publication.itemtitle) LIKE '%silicon-based%' OR
          LOWER(publication.itemtitle) LIKE '%cmos-based%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%programmable%' OR
          LOWER(publication.itemtitle) LIKE '%cryogenic control%' OR
          LOWER(publication.itemtitle) LIKE '%three-qubit%' OR
          LOWER(publication.itemtitle) LIKE '%quantum tomography%' OR
          LOWER(publication.itemtitle) LIKE '%benchmark%' OR
          LOWER(publication.itemtitle) LIKE '%scaling%' OR
          LOWER(publication.itemtitle) LIKE '%two qubit%' OR
          LOWER(publication.itemtitle) LIKE '%resonant swap%' OR
          LOWER(publication.itemtitle) LIKE '%controlled not%' OR
          LOWER(publication.itemtitle) LIKE '%cnot%' OR
          LOWER(publication.itemtitle) LIKE '%cphase%' OR
          LOWER(publication.itemtitle) LIKE '%controlled phase%' OR
          LOWER(publication.itemtitle) LIKE '%spin qubit%' OR
          LOWER(publication.itemtitle) LIKE '%fidelity%' OR
          LOWER(publication.itemtitle) LIKE '%quantum processor%' OR
          LOWER(publication.itemtitle) LIKE '%spin-photon%' OR
          LOWER(publication.itemtitle) LIKE '%long range%' OR
          LOWER(publication.itemtitle) LIKE '%singlet triplet%' OR
          LOWER(publication.itemtitle) LIKE '%spin resonance%' OR
          LOWER(publication.itemtitle) LIKE '%resonantly driven%'
        )
      )
    )"
  ))
publication_qc443 <- dbFetch(publication_qc443.SQL, n=-1)
length(unique(publication_qc443$pubid)) # 792
save(publication_qc443, file="R file/publication_qc443.RData")
rm(publication_qc443, publication_qc443.SQL)

########################################

keywords_qc444.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE ((
      (
        LOWER(keywords.keyword) LIKE '%quantum%' AND (
          (
            LOWER(keywords.keyword) LIKE '%quantum simulation%' AND (
              LOWER(keywords.keyword) LIKE '%quantum computing%' OR
              LOWER(keywords.keyword) LIKE '%quantum computation%' OR
              LOWER(keywords.keyword) LIKE '%quantum information%' OR
              LOWER(keywords.keyword) LIKE '%quantum bit%' OR
              LOWER(keywords.keyword) LIKE '%qubit%' OR
              LOWER(keywords.keyword) LIKE '%qudit%'
            )
          ) OR (
            LOWER(keywords.keyword) LIKE '%quantum annealer%' OR
            LOWER(keywords.keyword) LIKE '%quantum annealing%' OR
            LOWER(keywords.keyword) LIKE '%quantum simulator%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%hamiltonian%' OR
            LOWER(keywords.keyword) LIKE '%hubbard%' OR
            LOWER(keywords.keyword) LIKE '%ising%' OR
            LOWER(keywords.keyword) LIKE '%analog quantum%' OR
            LOWER(keywords.keyword) LIKE '%many-body physics%' OR
            LOWER(keywords.keyword) LIKE '%rydberg%' OR
            LOWER(keywords.keyword) LIKE '%ultracold%' OR
            LOWER(keywords.keyword) LIKE '%fermi gas%' OR
            LOWER(keywords.keyword) LIKE '%optical lattices%' OR
            LOWER(keywords.keyword) LIKE '%optical lattice%'
          )
        )
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%ultracold atoms%' OR
          LOWER(keywords.keyword) LIKE '%ultracold atom%' OR
          LOWER(keywords.keyword) LIKE '%fermi gas%' OR
          LOWER(keywords.keyword) LIKE '%quantum gas%'
        ) AND (
          LOWER(keywords.keyword) LIKE '%optical lattice%' OR
          LOWER(keywords.keyword) LIKE '%optical lattices%' OR
          LOWER(keywords.keyword) LIKE '%band%' OR
          LOWER(keywords.keyword) LIKE '%strongly correlated%'
        )
      ) OR (
        LOWER(keywords.keyword) LIKE '%rydberg atom%' OR
        LOWER(keywords.keyword) LIKE '%rydberg atoms%' OR
        LOWER(keywords.keyword) LIKE '%rydberg atom array%'
      ) OR (
        LOWER(keywords.keyword) LIKE '%quantum gas microscope%' OR
        LOWER(keywords.keyword) LIKE '%quantum gas microscopy%'
      ) OR (
        (
          LOWER(keywords.keyword) LIKE '%ultracold molecules%' OR
          LOWER(keywords.keyword) LIKE '%cold molecules%'
        ) AND LOWER(keywords.keyword) LIKE '%optical tweezer%'
      )
    ) AND NOT (
      LOWER(keywords.keyword) LIKE '%quantum communication%' OR
      LOWER(keywords.keyword) LIKE '%quantum cryptography%' OR
      LOWER(keywords.keyword) LIKE '%d-wave%' OR
      LOWER(keywords.keyword) LIKE '%superconducting%' OR
      LOWER(keywords.keyword) LIKE '%trapped ion%' OR
      LOWER(keywords.keyword) LIKE '%trapped ions%' OR
      LOWER(keywords.keyword) LIKE '%photonic crystal%' OR
      LOWER(keywords.keyword) LIKE '%photonic lattice%' OR
      LOWER(keywords.keyword) LIKE '%sensing%' OR
      LOWER(keywords.keyword) LIKE '%sensor%' OR
      LOWER(keywords.keyword) LIKE '%sensors%' OR
      LOWER(keywords.keyword) LIKE '%learning%'
    ))"
  ))
keywords_qc444 <- dbFetch(keywords_qc444.SQL, n=-1)
length(unique(keywords_qc444$pubid)) # 769
save(keywords_qc444, file="R file/keywords_qc444.RData")
rm(keywords_qc444, keywords_qc444.SQL)

publication_qc444.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE ((
      (
        LOWER(publication.abstract) LIKE '%quantum%' AND (
          (
            LOWER(publication.abstract) LIKE '%quantum simulation%' AND (
              LOWER(publication.abstract) LIKE '%quantum computing%' OR
              LOWER(publication.abstract) LIKE '%quantum computation%' OR
              LOWER(publication.abstract) LIKE '%quantum information%' OR
              LOWER(publication.abstract) LIKE '%quantum bit%' OR
              LOWER(publication.abstract) LIKE '%qubit%' OR
              LOWER(publication.abstract) LIKE '%qudit%'
            )
          ) OR (
            LOWER(publication.abstract) LIKE '%quantum annealer%' OR
            LOWER(publication.abstract) LIKE '%quantum annealing%' OR
            LOWER(publication.abstract) LIKE '%quantum simulator%'
          ) AND (
            LOWER(publication.abstract) LIKE '%hamiltonian%' OR
            LOWER(publication.abstract) LIKE '%hubbard%' OR
            LOWER(publication.abstract) LIKE '%ising%' OR
            LOWER(publication.abstract) LIKE '%analog quantum%' OR
            LOWER(publication.abstract) LIKE '%many-body physics%' OR
            LOWER(publication.abstract) LIKE '%rydberg%' OR
            LOWER(publication.abstract) LIKE '%ultracold%' OR
            LOWER(publication.abstract) LIKE '%fermi gas%' OR
            LOWER(publication.abstract) LIKE '%optical lattices%' OR
            LOWER(publication.abstract) LIKE '%optical lattice%'
          )
        )
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%ultracold atoms%' OR
          LOWER(publication.abstract) LIKE '%ultracold atom%' OR
          LOWER(publication.abstract) LIKE '%fermi gas%' OR
          LOWER(publication.abstract) LIKE '%quantum gas%'
        ) AND (
          LOWER(publication.abstract) LIKE '%optical lattice%' OR
          LOWER(publication.abstract) LIKE '%optical lattices%' OR
          LOWER(publication.abstract) LIKE '%band%' OR
          LOWER(publication.abstract) LIKE '%strongly correlated%'
        )
      ) OR (
        LOWER(publication.abstract) LIKE '%rydberg atom%' OR
        LOWER(publication.abstract) LIKE '%rydberg atoms%' OR
        LOWER(publication.abstract) LIKE '%rydberg atom array%'
      ) OR (
        LOWER(publication.abstract) LIKE '%quantum gas microscope%' OR
        LOWER(publication.abstract) LIKE '%quantum gas microscopy%'
      ) OR (
        (
          LOWER(publication.abstract) LIKE '%ultracold molecules%' OR
          LOWER(publication.abstract) LIKE '%cold molecules%'
        ) AND LOWER(publication.abstract) LIKE '%optical tweezer%'
      )
    ) AND NOT (
      LOWER(publication.abstract) LIKE '%quantum communication%' OR
      LOWER(publication.abstract) LIKE '%quantum cryptography%' OR
      LOWER(publication.abstract) LIKE '%d-wave%' OR
      LOWER(publication.abstract) LIKE '%superconducting%' OR
      LOWER(publication.abstract) LIKE '%trapped ion%' OR
      LOWER(publication.abstract) LIKE '%trapped ions%' OR
      LOWER(publication.abstract) LIKE '%photonic crystal%' OR
      LOWER(publication.abstract) LIKE '%photonic lattice%' OR
      LOWER(publication.abstract) LIKE '%sensing%' OR
      LOWER(publication.abstract) LIKE '%sensor%' OR
      LOWER(publication.abstract) LIKE '%sensors%' OR
      LOWER(publication.abstract) LIKE '%learning%'
    ))
    OR
    ((
      (
        LOWER(publication.itemtitle) LIKE '%quantum%' AND (
          (
            LOWER(publication.itemtitle) LIKE '%quantum simulation%' AND (
              LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
              LOWER(publication.itemtitle) LIKE '%quantum computation%' OR
              LOWER(publication.itemtitle) LIKE '%quantum information%' OR
              LOWER(publication.itemtitle) LIKE '%quantum bit%' OR
              LOWER(publication.itemtitle) LIKE '%qubit%' OR
              LOWER(publication.itemtitle) LIKE '%qudit%'
            )
          ) OR (
            LOWER(publication.itemtitle) LIKE '%quantum annealer%' OR
            LOWER(publication.itemtitle) LIKE '%quantum annealing%' OR
            LOWER(publication.itemtitle) LIKE '%quantum simulator%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%hamiltonian%' OR
            LOWER(publication.itemtitle) LIKE '%hubbard%' OR
            LOWER(publication.itemtitle) LIKE '%ising%' OR
            LOWER(publication.itemtitle) LIKE '%analog quantum%' OR
            LOWER(publication.itemtitle) LIKE '%many-body physics%' OR
            LOWER(publication.itemtitle) LIKE '%rydberg%' OR
            LOWER(publication.itemtitle) LIKE '%ultracold%' OR
            LOWER(publication.itemtitle) LIKE '%fermi gas%' OR
            LOWER(publication.itemtitle) LIKE '%optical lattices%' OR
            LOWER(publication.itemtitle) LIKE '%optical lattice%'
          )
        )
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%ultracold atoms%' OR
          LOWER(publication.itemtitle) LIKE '%ultracold atom%' OR
          LOWER(publication.itemtitle) LIKE '%fermi gas%' OR
          LOWER(publication.itemtitle) LIKE '%quantum gas%'
        ) AND (
          LOWER(publication.itemtitle) LIKE '%optical lattice%' OR
          LOWER(publication.itemtitle) LIKE '%optical lattices%' OR
          LOWER(publication.itemtitle) LIKE '%band%' OR
          LOWER(publication.itemtitle) LIKE '%strongly correlated%'
        )
      ) OR (
        LOWER(publication.itemtitle) LIKE '%rydberg atom%' OR
        LOWER(publication.itemtitle) LIKE '%rydberg atoms%' OR
        LOWER(publication.itemtitle) LIKE '%rydberg atom array%'
      ) OR (
        LOWER(publication.itemtitle) LIKE '%quantum gas microscope%' OR
        LOWER(publication.itemtitle) LIKE '%quantum gas microscopy%'
      ) OR (
        (
          LOWER(publication.itemtitle) LIKE '%ultracold molecules%' OR
          LOWER(publication.itemtitle) LIKE '%cold molecules%'
        ) AND LOWER(publication.itemtitle) LIKE '%optical tweezer%'
      )
    ) AND NOT (
      LOWER(publication.itemtitle) LIKE '%quantum communication%' OR
      LOWER(publication.itemtitle) LIKE '%quantum cryptography%' OR
      LOWER(publication.itemtitle) LIKE '%d-wave%' OR
      LOWER(publication.itemtitle) LIKE '%superconducting%' OR
      LOWER(publication.itemtitle) LIKE '%trapped ion%' OR
      LOWER(publication.itemtitle) LIKE '%trapped ions%' OR
      LOWER(publication.itemtitle) LIKE '%photonic crystal%' OR
      LOWER(publication.itemtitle) LIKE '%photonic lattice%' OR
      LOWER(publication.itemtitle) LIKE '%sensing%' OR
      LOWER(publication.itemtitle) LIKE '%sensor%' OR
      LOWER(publication.itemtitle) LIKE '%sensors%' OR
      LOWER(publication.itemtitle) LIKE '%learning%'
    ))"
  ))
publication_qc444 <- dbFetch(publication_qc444.SQL, n=-1)
length(unique(publication_qc444$pubid)) # 5116
save(publication_qc444, file="R file/publication_qc444.RData")
rm(publication_qc444, publication_qc444.SQL)

########################################

keywords_qc445.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%quantum%' AND (
        LOWER(keywords.keyword) LIKE '%solid-state spin%' OR
        LOWER(keywords.keyword) LIKE '%solid state spin%' OR
        (
          LOWER(keywords.keyword) LIKE '%spin-based%' AND
          LOWER(keywords.keyword) LIKE '%quantum%'
        ) OR
        LOWER(keywords.keyword) LIKE '%quantum-emitter%' OR
        LOWER(keywords.keyword) LIKE '%solid state qubit%' OR
        LOWER(keywords.keyword) LIKE '%solid-state qubit%' OR
        LOWER(keywords.keyword) LIKE '%solid-state defect%' OR
        (
          LOWER(keywords.keyword) LIKE '%silicon%' AND (
            LOWER(keywords.keyword) LIKE '%g-center%' OR
            LOWER(keywords.keyword) LIKE '%t-center%'
          )
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%diamond%' AND (
            LOWER(keywords.keyword) LIKE '%vacancy%' OR
            LOWER(keywords.keyword) LIKE '%color center%'
          )
        ) OR
        (
          (
            LOWER(keywords.keyword) LIKE '%sic%' OR
            LOWER(keywords.keyword) LIKE '%silicon carbide%'
          ) AND (
            LOWER(keywords.keyword) LIKE '%defect%' OR
            LOWER(keywords.keyword) LIKE '%vacancy%'
          )
        ) OR
        (
          LOWER(keywords.keyword) LIKE '%solid%' AND (
            LOWER(keywords.keyword) LIKE '%rare-earth ion%' OR
            LOWER(keywords.keyword) LIKE '%rare earth ion%'
          )
        )
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%gas%' OR
        LOWER(keywords.keyword) LIKE '%superconducting%' OR
        LOWER(keywords.keyword) LIKE '%trapped ion%' OR
        LOWER(keywords.keyword) LIKE '%trapped atom%' OR
        LOWER(keywords.keyword) LIKE '%quantumdot%' OR
        LOWER(keywords.keyword) LIKE '%quantum dot%' OR
        LOWER(keywords.keyword) LIKE '%cathodoluminescence%' OR
        LOWER(keywords.keyword) LIKE '%plexciton%' OR
        LOWER(keywords.keyword) LIKE '%chromophore%' OR
        LOWER(keywords.keyword) LIKE '%phosphore%' OR
        LOWER(keywords.keyword) LIKE '%photocatal%' OR
        LOWER(keywords.keyword) LIKE '%nanoparticle%' OR
        LOWER(keywords.keyword) LIKE '%nanocrystal%' OR
        LOWER(keywords.keyword) LIKE '%light-emitting diode%' OR
        LOWER(keywords.keyword) LIKE '%finfet%' OR
        LOWER(keywords.keyword) LIKE '%gan%' OR
        LOWER(keywords.keyword) LIKE '%lanthanide%' OR
        LOWER(keywords.keyword) LIKE '%modulus%' OR
        LOWER(keywords.keyword) LIKE '%magnetism%' OR
        LOWER(keywords.keyword) LIKE '%topological photonic crystal%' OR
        LOWER(keywords.keyword) LIKE '%topological phononic crystal%' OR
        LOWER(keywords.keyword) LIKE '%fiber laser%' OR
        LOWER(keywords.keyword) LIKE '%spin hall%' OR
        LOWER(keywords.keyword) LIKE '%harmonic generation%' OR
        LOWER(keywords.keyword) LIKE '%luminescent magnet%' OR
        LOWER(keywords.keyword) LIKE '%perovskite%' OR
        LOWER(keywords.keyword) LIKE '%quantum well%' OR
        LOWER(keywords.keyword) LIKE '%oled%' OR
        LOWER(keywords.keyword) LIKE '%wled%' OR
        LOWER(keywords.keyword) LIKE '%spintronic%' OR
        LOWER(keywords.keyword) LIKE '%mos device%' OR
        LOWER(keywords.keyword) LIKE '%spin chain%' OR
        LOWER(keywords.keyword) LIKE '%nanostructured crystal%' OR
        LOWER(keywords.keyword) LIKE '% transistors%' OR
        LOWER(keywords.keyword) LIKE '%deep levels%' OR
        LOWER(keywords.keyword) LIKE '%single molecule%' OR
        LOWER(keywords.keyword) LIKE '%photodetector%' OR
        LOWER(keywords.keyword) LIKE '%tellurite glass%' OR
        LOWER(keywords.keyword) LIKE '%ammonium tartrate%' OR
        LOWER(keywords.keyword) LIKE '%electronic property%' OR
        LOWER(keywords.keyword) LIKE '%electronic properties%'
      )
    )"
  ))
keywords_qc445 <- dbFetch(keywords_qc445.SQL, n=-1)
length(unique(keywords_qc445$pubid)) # 0
save(keywords_qc445, file="R file/keywords_qc445.RData")
rm(keywords_qc445, keywords_qc445.SQL)

publication_qc445.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%quantum%' AND (
        LOWER(publication.abstract) LIKE '%solid-state spin%' OR
        LOWER(publication.abstract) LIKE '%solid state spin%' OR
        (
          LOWER(publication.abstract) LIKE '%spin-based%' AND
          LOWER(publication.abstract) LIKE '%quantum%'
        ) OR
        LOWER(publication.abstract) LIKE '%quantum-emitter%' OR
        LOWER(publication.abstract) LIKE '%solid state qubit%' OR
        LOWER(publication.abstract) LIKE '%solid-state qubit%' OR
        LOWER(publication.abstract) LIKE '%solid-state defect%' OR
        (
          LOWER(publication.abstract) LIKE '%silicon%' AND (
            LOWER(publication.abstract) LIKE '%g-center%' OR
            LOWER(publication.abstract) LIKE '%t-center%'
          )
        ) OR
        (
          LOWER(publication.abstract) LIKE '%diamond%' AND (
            LOWER(publication.abstract) LIKE '%vacancy%' OR
            LOWER(publication.abstract) LIKE '%color center%'
          )
        ) OR
        (
          (
            LOWER(publication.abstract) LIKE '%sic%' OR
            LOWER(publication.abstract) LIKE '%silicon carbide%'
          ) AND (
            LOWER(publication.abstract) LIKE '%defect%' OR
            LOWER(publication.abstract) LIKE '%vacancy%'
          )
        ) OR
        (
          LOWER(publication.abstract) LIKE '%solid%' AND (
            LOWER(publication.abstract) LIKE '%rare-earth ion%' OR
            LOWER(publication.abstract) LIKE '%rare earth ion%'
          )
        )
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%gas%' OR
        LOWER(publication.abstract) LIKE '%superconducting%' OR
        LOWER(publication.abstract) LIKE '%trapped ion%' OR
        LOWER(publication.abstract) LIKE '%trapped atom%' OR
        LOWER(publication.abstract) LIKE '%quantumdot%' OR
        LOWER(publication.abstract) LIKE '%quantum dot%' OR
        LOWER(publication.abstract) LIKE '%cathodoluminescence%' OR
        LOWER(publication.abstract) LIKE '%plexciton%' OR
        LOWER(publication.abstract) LIKE '%chromophore%' OR
        LOWER(publication.abstract) LIKE '%phosphore%' OR
        LOWER(publication.abstract) LIKE '%photocatal%' OR
        LOWER(publication.abstract) LIKE '%nanoparticle%' OR
        LOWER(publication.abstract) LIKE '%nanocrystal%' OR
        LOWER(publication.abstract) LIKE '%light-emitting diode%' OR
        LOWER(publication.abstract) LIKE '%finfet%' OR
        LOWER(publication.abstract) LIKE '%gan%' OR
        LOWER(publication.abstract) LIKE '%lanthanide%' OR
        LOWER(publication.abstract) LIKE '%modulus%' OR
        LOWER(publication.abstract) LIKE '%magnetism%' OR
        LOWER(publication.abstract) LIKE '%topological photonic crystal%' OR
        LOWER(publication.abstract) LIKE '%topological phononic crystal%' OR
        LOWER(publication.abstract) LIKE '%fiber laser%' OR
        LOWER(publication.abstract) LIKE '%spin hall%' OR
        LOWER(publication.abstract) LIKE '%harmonic generation%' OR
        LOWER(publication.abstract) LIKE '%luminescent magnet%' OR
        LOWER(publication.abstract) LIKE '%perovskite%' OR
        LOWER(publication.abstract) LIKE '%quantum well%' OR
        LOWER(publication.abstract) LIKE '%oled%' OR
        LOWER(publication.abstract) LIKE '%wled%' OR
        LOWER(publication.abstract) LIKE '%spintronic%' OR
        LOWER(publication.abstract) LIKE '%mos device%' OR
        LOWER(publication.abstract) LIKE '%spin chain%' OR
        LOWER(publication.abstract) LIKE '%nanostructured crystal%' OR
        LOWER(publication.abstract) LIKE '% transistors%' OR
        LOWER(publication.abstract) LIKE '%deep levels%' OR
        LOWER(publication.abstract) LIKE '%single molecule%' OR
        LOWER(publication.abstract) LIKE '%photodetector%' OR
        LOWER(publication.abstract) LIKE '%tellurite glass%' OR
        LOWER(publication.abstract) LIKE '%ammonium tartrate%' OR
        LOWER(publication.abstract) LIKE '%electronic property%' OR
        LOWER(publication.abstract) LIKE '%electronic properties%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%quantum%' AND (
        LOWER(publication.itemtitle) LIKE '%solid-state spin%' OR
        LOWER(publication.itemtitle) LIKE '%solid state spin%' OR
        (
          LOWER(publication.itemtitle) LIKE '%spin-based%' AND
          LOWER(publication.itemtitle) LIKE '%quantum%'
        ) OR
        LOWER(publication.itemtitle) LIKE '%quantum-emitter%' OR
        LOWER(publication.itemtitle) LIKE '%solid state qubit%' OR
        LOWER(publication.itemtitle) LIKE '%solid-state qubit%' OR
        LOWER(publication.itemtitle) LIKE '%solid-state defect%' OR
        (
          LOWER(publication.itemtitle) LIKE '%silicon%' AND (
            LOWER(publication.itemtitle) LIKE '%g-center%' OR
            LOWER(publication.itemtitle) LIKE '%t-center%'
          )
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%diamond%' AND (
            LOWER(publication.itemtitle) LIKE '%vacancy%' OR
            LOWER(publication.itemtitle) LIKE '%color center%'
          )
        ) OR
        (
          (
            LOWER(publication.itemtitle) LIKE '%sic%' OR
            LOWER(publication.itemtitle) LIKE '%silicon carbide%'
          ) AND (
            LOWER(publication.itemtitle) LIKE '%defect%' OR
            LOWER(publication.itemtitle) LIKE '%vacancy%'
          )
        ) OR
        (
          LOWER(publication.itemtitle) LIKE '%solid%' AND (
            LOWER(publication.itemtitle) LIKE '%rare-earth ion%' OR
            LOWER(publication.itemtitle) LIKE '%rare earth ion%'
          )
        )
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%gas%' OR
        LOWER(publication.itemtitle) LIKE '%superconducting%' OR
        LOWER(publication.itemtitle) LIKE '%trapped ion%' OR
        LOWER(publication.itemtitle) LIKE '%trapped atom%' OR
        LOWER(publication.itemtitle) LIKE '%quantumdot%' OR
        LOWER(publication.itemtitle) LIKE '%quantum dot%' OR
        LOWER(publication.itemtitle) LIKE '%cathodoluminescence%' OR
        LOWER(publication.itemtitle) LIKE '%plexciton%' OR
        LOWER(publication.itemtitle) LIKE '%chromophore%' OR
        LOWER(publication.itemtitle) LIKE '%phosphore%' OR
        LOWER(publication.itemtitle) LIKE '%photocatal%' OR
        LOWER(publication.itemtitle) LIKE '%nanoparticle%' OR
        LOWER(publication.itemtitle) LIKE '%nanocrystal%' OR
        LOWER(publication.itemtitle) LIKE '%light-emitting diode%' OR
        LOWER(publication.itemtitle) LIKE '%finfet%' OR
        LOWER(publication.itemtitle) LIKE '%gan%' OR
        LOWER(publication.itemtitle) LIKE '%lanthanide%' OR
        LOWER(publication.itemtitle) LIKE '%modulus%' OR
        LOWER(publication.itemtitle) LIKE '%magnetism%' OR
        LOWER(publication.itemtitle) LIKE '%topological photonic crystal%' OR
        LOWER(publication.itemtitle) LIKE '%topological phononic crystal%' OR
        LOWER(publication.itemtitle) LIKE '%fiber laser%' OR
        LOWER(publication.itemtitle) LIKE '%spin hall%' OR
        LOWER(publication.itemtitle) LIKE '%harmonic generation%' OR
        LOWER(publication.itemtitle) LIKE '%luminescent magnet%' OR
        LOWER(publication.itemtitle) LIKE '%perovskite%' OR
        LOWER(publication.itemtitle) LIKE '%quantum well%' OR
        LOWER(publication.itemtitle) LIKE '%oled%' OR
        LOWER(publication.itemtitle) LIKE '%wled%' OR
        LOWER(publication.itemtitle) LIKE '%spintronic%' OR
        LOWER(publication.itemtitle) LIKE '%mos device%' OR
        LOWER(publication.itemtitle) LIKE '%spin chain%' OR
        LOWER(publication.itemtitle) LIKE '%nanostructured crystal%' OR
        LOWER(publication.itemtitle) LIKE '% transistors%' OR
        LOWER(publication.itemtitle) LIKE '%deep levels%' OR
        LOWER(publication.itemtitle) LIKE '%single molecule%' OR
        LOWER(publication.itemtitle) LIKE '%photodetector%' OR
        LOWER(publication.itemtitle) LIKE '%tellurite glass%' OR
        LOWER(publication.itemtitle) LIKE '%ammonium tartrate%' OR
        LOWER(publication.itemtitle) LIKE '%electronic property%' OR
        LOWER(publication.itemtitle) LIKE '%electronic properties%'
      )
    )"
  ))
publication_qc445 <- dbFetch(publication_qc445.SQL, n=-1)
length(unique(publication_qc445$pubid)) # 3824
save(publication_qc445, file="R file/publication_qc445.RData")
rm(publication_qc445, publication_qc445.SQL)

########################################

keywords_qc446.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct *",
    "FROM wos.keywords_plus keywords",
    "WHERE (
      LOWER(keywords.keyword) LIKE '%photon%' AND
      LOWER(keywords.keyword) LIKE '%quantum%' AND
      (
        LOWER(keywords.keyword) LIKE '%quantum%programable%' OR
        LOWER(keywords.keyword) LIKE '%quantum computer%' OR
        LOWER(keywords.keyword) LIKE '%quantum computation%' OR
        LOWER(keywords.keyword) LIKE '%quantum computational%' OR
        LOWER(keywords.keyword) LIKE '%quantum computing%' OR
        LOWER(keywords.keyword) LIKE '%loqc%' OR
        LOWER(keywords.keyword) LIKE '%mbqc%' OR
        LOWER(keywords.keyword) LIKE '%fbqc%' OR
        LOWER(keywords.keyword) LIKE '%cnot%' OR
        LOWER(keywords.keyword) LIKE '%controlled-not%' OR
        LOWER(keywords.keyword) LIKE '%controlled not%'
      ) AND NOT (
        LOWER(keywords.keyword) LIKE '%ion%' OR
        LOWER(keywords.keyword) LIKE '%diamond%' OR
        LOWER(keywords.keyword) LIKE '%superconducting qubit%' OR
        LOWER(keywords.keyword) LIKE '%josephson%' OR
        LOWER(keywords.keyword) LIKE '%microwave%' OR
        LOWER(keywords.keyword) LIKE '%rydberg%' OR
        LOWER(keywords.keyword) LIKE '%atom%' OR
        LOWER(keywords.keyword) LIKE '%spin%' OR
        LOWER(keywords.keyword) LIKE '%quantum key%' OR
        LOWER(keywords.keyword) LIKE '%transmon%' OR
        LOWER(keywords.keyword) LIKE '%communication%'
      )
    )"
  ))
keywords_qc446 <- dbFetch(keywords_qc446.SQL, n=-1)
length(unique(keywords_qc446$pubid)) # 0
save(keywords_qc446, file="R file/keywords_qc446.RData")
rm(keywords_qc446, keywords_qc446.SQL)

publication_qc446.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct publication.pubid, publication.doc_type, publication.pubyear, publication.pubtype, 
    publication.abstract, publication.source, publication.itemtitle",
    "FROM wos2024.publications publication",
    "WHERE (
      LOWER(publication.abstract) LIKE '%photon%' AND
      LOWER(publication.abstract) LIKE '%quantum%' AND
      (
        LOWER(publication.abstract) LIKE '%quantum%programable%' OR
        LOWER(publication.abstract) LIKE '%quantum computer%' OR
        LOWER(publication.abstract) LIKE '%quantum computation%' OR
        LOWER(publication.abstract) LIKE '%quantum computational%' OR
        LOWER(publication.abstract) LIKE '%quantum computing%' OR
        LOWER(publication.abstract) LIKE '%loqc%' OR
        LOWER(publication.abstract) LIKE '%mbqc%' OR
        LOWER(publication.abstract) LIKE '%fbqc%' OR
        LOWER(publication.abstract) LIKE '%cnot%' OR
        LOWER(publication.abstract) LIKE '%controlled-not%' OR
        LOWER(publication.abstract) LIKE '%controlled not%'
      ) AND NOT (
        LOWER(publication.abstract) LIKE '%ion%' OR
        LOWER(publication.abstract) LIKE '%diamond%' OR
        LOWER(publication.abstract) LIKE '%superconducting qubit%' OR
        LOWER(publication.abstract) LIKE '%josephson%' OR
        LOWER(publication.abstract) LIKE '%microwave%' OR
        LOWER(publication.abstract) LIKE '%rydberg%' OR
        LOWER(publication.abstract) LIKE '%atom%' OR
        LOWER(publication.abstract) LIKE '%spin%' OR
        LOWER(publication.abstract) LIKE '%quantum key%' OR
        LOWER(publication.abstract) LIKE '%transmon%' OR
        LOWER(publication.abstract) LIKE '%communication%'
      )
    )
    OR
    (
      LOWER(publication.itemtitle) LIKE '%photon%' AND
      LOWER(publication.itemtitle) LIKE '%quantum%' AND
      (
        LOWER(publication.itemtitle) LIKE '%quantum%programable%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computer%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computation%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computational%' OR
        LOWER(publication.itemtitle) LIKE '%quantum computing%' OR
        LOWER(publication.itemtitle) LIKE '%loqc%' OR
        LOWER(publication.itemtitle) LIKE '%mbqc%' OR
        LOWER(publication.itemtitle) LIKE '%fbqc%' OR
        LOWER(publication.itemtitle) LIKE '%cnot%' OR
        LOWER(publication.itemtitle) LIKE '%controlled-not%' OR
        LOWER(publication.itemtitle) LIKE '%controlled not%'
      ) AND NOT (
        LOWER(publication.itemtitle) LIKE '%ion%' OR
        LOWER(publication.itemtitle) LIKE '%diamond%' OR
        LOWER(publication.itemtitle) LIKE '%superconducting qubit%' OR
        LOWER(publication.itemtitle) LIKE '%josephson%' OR
        LOWER(publication.itemtitle) LIKE '%microwave%' OR
        LOWER(publication.itemtitle) LIKE '%rydberg%' OR
        LOWER(publication.itemtitle) LIKE '%atom%' OR
        LOWER(publication.itemtitle) LIKE '%spin%' OR
        LOWER(publication.itemtitle) LIKE '%quantum key%' OR
        LOWER(publication.itemtitle) LIKE '%transmon%' OR
        LOWER(publication.itemtitle) LIKE '%communication%'
      )
    )"
  ))
publication_qc446 <- dbFetch(publication_qc446.SQL, n=-1)
length(unique(publication_qc446$pubid)) # 62
save(publication_qc446, file="R file/publication_qc446.RData")
rm(publication_qc446, publication_qc446.SQL)


############################ OLD VERSION ############################

# keyword
keywords_qc11.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct pub_keywords.pubid, , keywords.kw_id",
    "FROM wos.keywords keywords",
    "INNER JOIN wos.pub_keywords pub_keywords",
    "ON keywords.kw_id = pub_keywords.kw_id",
    'WHERE LOWER() = (("quantum" or "qubit%") AND
    ("single photon detection" or "single photon detectors" or 
    "single photon avalanche" or "squid" or "avalanche photodiodes" or 
    "entangled photon" or "entangled photons" or "correlated photon" or 
    "nonclassical photon" or "photon-photon interaction" or 
    "photon-photon interactions" or "photon pair generation" or "photon pair generations" or 
    "photon-pair generation" or "photon-pair generations" or "multiphoton entangled" or 
    "polarization-entangled" or "three-photon quantum" or "three-photon entangled" or 
    "two-photon interference" or "hyper-entangled photons" or "multi-qubit quantum" or 
    "spontaneous parametric down-conversion" or "hong–ou–mandel interference" or 
    "photon pairs generated" or "photon-pair source" or "high-dimensional quantum states" or 
    "entangled photon" or "entangled photons" or "correlated photon" or "nonclassical photon" or 
    "photon-photon interaction" or "photon-photon interactions" or "photon pair generation" or 
    "photon pair generations" or "photon-pair generation" or "photon-pair generations" or 
    "multiphoton entangled" or "polarization-entangled" or "three-photon quantum" or 
    "three-photon entangled" or "two-photon interference" or "hyper-entangled photons" or 
    "multi-qubit quantum" or "spontaneous parametric down-conversion" or 
    "hong–ou–mandel interference" or "photon pairs generated" or "photon-pair source" or 
    "bell state preparation" or "non-zero discord bipartite state"))' #'%quantum%'
  ))
keywords_qc11 <- dbFetch(keywords_qc11.SQL, n=-1)
length(unique(keywords_qc11$pubid)) # 107,711
save(keywords_qc11, file="R file/keywords_qc11.RData")
rm(keywords_qc11, keywords_qc1.SQL)

keywords_qc12.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct pub_keywords.pubid, keywords.keyword, keywords.kw_id",
    "FROM wos.keywords keywords",
    "INNER JOIN wos.pub_keywords pub_keywords",
    "ON keywords.kw_id = pub_keywords.kw_id",
    'WHERE LOWER(keywords.keyword) = (("quantum" or "qubit%") AND 
    ("transmon qubit" or "hybrid qubit" or "singlet-triplet qubits" or 
    "defect qubits" or "Hybrid Qubit in a GaAs"))' #'%quantum%'
  ))
keywords_qc12 <- dbFetch(keywords_qc12.SQL, n=-1)
length(unique(keywords_qc12$pubid)) # 107,711
save(keywords_qc12, file="R file/keywords_qc12.RData")
rm(keywords_qc12, keywords_qc12.SQL)

keywords_qc13.SQL <- RMySQL::dbSendQuery(
  con, paste(
    "SELECT distinct pub_keywords.pubid, keywords.keyword, keywords.kw_id",
    "FROM wos.keywords keywords",
    "INNER JOIN wos.pub_keywords pub_keywords",
    "ON keywords.kw_id = pub_keywords.kw_id",
    'WHERE LOWER(keywords.keyword) = (("quantum" or "qubit%") AND 
    ("transmon qubit" or "hybrid qubit" or "singlet-triplet qubits" or 
    "defect qubits" or "Hybrid Qubit in a GaAs"))' #'%quantum%'
  ))
keywords_qc13 <- dbFetch(keywords_qc13.SQL, n=-1)
length(unique(keywords_qc13$pubid)) # 107,711
save(keywords_qc13, file="R file/keywords_qc12.RData")
rm(keywords_qc13, keywords_qc13.SQL)

(TS= ((quantum or qubit*) and ("Greenberger–Horne–Zeilinger" or "SWAP" or "controlled-swap" or "controlled-NOT")) ) AND (PY=2016-2021)
