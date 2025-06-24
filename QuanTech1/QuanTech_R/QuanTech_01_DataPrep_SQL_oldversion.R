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
length(unique(keywords_qc422$pubid)) # 76,511
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
length(unique(publication_qc422$pubid)) # 5,937,340
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
