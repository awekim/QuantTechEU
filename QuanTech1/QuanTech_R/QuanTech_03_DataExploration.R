#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project - Data Prep 03. Data Exploration
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

library(dplyr)
library(magrittr)
library(ggplot2)
library(readr)
library(tidyr)
library(ggrepel)
library(geomtextpath)
# locale("ko")

### Label table
# Sys.setlocale("LC_ALL","Korean") # 언어 다시 한글로
quan_lable <- read.csv(file="qc_label.csv", 
                       encoding = "UTF-8") 
names(quan_lable) <- c("qc_category","label")

### List of files generated
# load(file="R file/quant_pub.RData")
# load(file="R file/quant_author.RData")
# load(file="R file/quant_inst.RData")
# load(file="R file/funding.RData")

### Create integrated table
load(file="R file/quant_pub.RData")
load(file="R file/quant_author.RData")
load(file="R file/quant_inst.RData")

length(unique(quant_pub$pubid))
length(unique(quant_author$pubid))
length(unique(quant_inst$pubid))

quant_pub_ed <- quant_pub %>% 
  inner_join(quant_pub %>% select(pubid) %>% unique %>%
               inner_join(quant_author %>% filter(is.na(author_id_te)==FALSE) %>%
                            select(pubid) %>% unique) %>%
               inner_join(quant_inst %>% filter(is.na(institution_id_te)==FALSE) %>%
                            select(pubid) %>% unique))
length(unique(quant_pub_ed$pubid)) # (without author) 4,794,879 (with author) 2,085,256
# (without author) 295,127 (with author) 295,127
# (all) 143,892 -> 154,103
quant_pub_ed$pubyear %>% table
quant_pub_ed %>% filter(pubyear==2009) %>% head(5)
save(quant_pub_ed, file="R file/quant_pub_ed.RData")
rm(quant_pub, quant_author, quant_inst)

load(file="R file/quant_pub_ed.RData")
load(file="R file/quant_inst.RData")
quant_inst_ed <- quant_pub_ed %>% select(pubid) %>% unique %>% 
  inner_join(quant_inst)
save(quant_inst_ed, file="R file/quant_inst_ed.RData")
length(unique(quant_inst_ed$pubid)) # 143,892 -> 154,103
length(unique(quant_inst_ed$institution_id_te)) # 1,303,620 -> 494,643 -> 530,423
rm(quant_inst)

### Restrict to European Regions
load(file="R file/quant_pub_ed.RData")
load(file="R file/quant_inst_ed.RData")

quant_pub_ed$pubid %>% unique %>% length
quant_inst_ed$pubid %>% unique %>% length
quant_inst_ed$country %>% unique %>% length 
quant_inst_ed$country %>% unique %>% sort 
# eu_country <- c("GREECE","SPAIN","SWEDEN","GERMANY","NETHERLAND",
#                 "ENGLAND","FRANCE","SCOTLAND","ITALY","HUNGARY",
#                 "CZECH REPUBLIC","BELGIUM","SWITZERLAND",
#                 "SERBIA","TURKEY","POLAND","BOSNIA & HERCEG",
#                 "PORTUGAL","ROMANIA","AUSTRIA","DENMARK","CYPRUS","NORWAY",
#                 "FINLAND","WALES","CROATIA","LUXEMBOURG",
#                 "NORTH IRELAND","GREENLAND","UNITED KINGDOM",
#                 "EUROPE","BELGIUM","BULGARIA")
eu_country <- 
  c("GREECE","NETHERLANDS","DENMARK","GERMANY","LATVIA","ROMANIA","LUXEMBOURG",
    "LITHUANIA","MALTA","BELGIUM","BULGARIA","SWEDEN","SPAIN","SLOVAKIA","SLOVENIA",
    "IRELAND","ESTONIA","AUSTRIA","ITALY","CZECH REPUBLIC","CROATIA","CYPRUS",
    "PORTUGAL","POLAND","FRANCE","FINLAND","HUNGARY",
    "SWITZERLAND","ENGLAND","NORWAY","ICELAND","FINLAND","ISRAEL")
  # "AUSTRIA","BELARUS","BELGIUM","BOSNIA & HERCEG","BULGARIA",
  # "CZECH REPUBLIC","DENMARK","ENGLAND","ESTONIA",
  # "FINLAND","FRANCE","FRENCH GUIANA",
  # "GERMANY","GREECE","HUNGARY",
  # "ICELAND","IRELAND","ITALY",
  # "LIECHTENSTEIN","LITHUANIA","LUXEMBOURG",
  # "MACEDONIA","MOLDOVA","MONACO","MONTENEGRO",
  # "NETHERLANDS","NORTH IRELAND","NORTH MACEDONIA","NORWAY","POLAND","PORTUGAL",
  # "REP OF GEORGIA","SCOTLAND","SERBIA","SERBIA MONTENEG","SLOVAKIA","SLOVENIA",
  # "SPAIN","SWEDEN","SWITZERLAND","WALES",
  # "ISRAEL"
data.frame(list=eu_country) %>% arrange(list)

quant_inst_ed_eu <- quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  left_join(quant_pub_ed %>% select(pubid, pubyear) %>% unique)
quant_inst_ed_eu$pubid %>% unique %>% length # 55,582 -> 58,453 -> 59,076
rm(quant_inst_ed, quant_pub_ed) # 50,278,314 -> 16,931,485

quant_inst_ed_eu$country %>% unique %>% sort

quant_inst_ed_eu %>% filter(is.na(pubyear)) %>% select(pubid) %>%
  unique %>% head
# Check
# 37754542, 38913972, 39263488, 39957997, 39938970, 39908615

# Manage Abbreviation
library(stringr)
quant_inst_ed_eu <- quant_inst_ed_eu %>%
  mutate(
    organization_clean = str_match(organization, "\\(([^)]+)\\)")[,2],
    organization_clean = ifelse(is.na(organization_clean), organization, organization_clean)) 
  
quant_inst_ed_eu <- quant_inst_ed_eu %>%
  mutate(
    # organization_clean = tolower(organization), 
    organization_clean = str_replace_all(organization_clean, "UNIVERSITY OF", "UNIV OF"), 
    # organization_clean = str_replace_all(organization_clean, "UNIVERSITY", "UNIV"), 
    # organization_clean = str_replace_all(organization_clean, "\\bUNIVERSITY\\b.*$", "UNIV"),
    organization_clean = str_replace_all(organization_clean, "\\s+", " "),
    organization_clean = str_replace_all(organization_clean, "COLLEGE", "COLL"),
    organization_clean = str_replace_all(organization_clean, "\\'", ""),
    organization_clean = str_replace_all(organization_clean, "UNIV OF", "UNIV"),
    organization_clean = str_replace_all(organization_clean, "UNIVERSITY COLLEGE LONDON", "UCL"),
    organization_clean = str_replace_all(organization_clean, "UNIV OXFORD", "UNIV OF OXFORD"),
    organization_clean = str_replace_all(organization_clean, "UNIV CAMBRIDGE", "UNIV OF CAMBRIDGE"),
    organization_clean = str_replace_all(organization_clean, "UNIV COPENHAGEN", "UNIV OF COPENHAGEN"),
    organization_clean = str_replace_all(organization_clean, "UNIV ULM", "ULM UNIVERSITY"),
    country = str_replace_all(country, "SERBIA MONTENEG", "SERBIA"),
    country = str_replace_all(country, "FRENCH GUIANA", "FRANCE"),
    country = str_replace_all(country, "NORTH MACEDONIA", "MACEDONIA")
  ) # %>% distinct(organization_clean, .keep_all = TRUE)

### Check
# quant_inst_eu %>% select(organization, organization_clean) %>%
#   head(50)
# quant_inst_eu %>% group_by(organization) %>% 
#   summarize(pub=length(unique(pubid))) %>% arrange(desc(pub)) %>%
#   head(20)
# quant_inst_eu %>% group_by(organization_clean) %>% 
#   summarize(pub=length(unique(pubid))) %>% arrange(desc(pub)) %>%
#   head(100) %>% data.frame

quant_inst_ed_eu$pubid %>% unique %>% length # 2,272,783 -> 1,808,860 -> 1,11,440 -> 55,582 -> 58,453 -> 59,076
quant_inst_ed_eu$organization %>% unique %>% length # 305,998 -> 31,102 -> 11,224 -> 11,759 -> 20,202
save(quant_inst_ed_eu, file="R file/quant_inst_ed_eu.RData")
write.csv(quant_inst_ed_eu, file="R file/quant_inst_ed_eu.csv")
rm(quant_inst_ed_eu)

####################################
#### Institution name check

# ~~~ Python Codes QuanTech_org_preprocessing.ipynb ~~~ #  

quant_inst_ed_eu_fixed <-
  read.csv("R file/quant_inst_ed_eu_fixed.csv")
save(quant_inst_ed_eu_fixed, file="R file/quant_inst_ed_eu_fixed.RData")

####################################

load(file="R file/quant_inst_ed_eu_fixed.RData")
load(file="R file/quant_pub_ed.RData")

quant_inst_ed_eu_fixed %>% head
quant_inst_ed_eu_fixed$pubid %>% unique %>% length # 55,582 -> 58,453 -> 59,076
quant_inst_ed_eu_fixed$organization %>% unique %>% length # 305,997 -> 31,102 -> 11,224 -> 11,759 -> 20,202
quant_inst_ed_eu_fixed$organization_clean %>% unique %>% length # 305,197 -> 30,617 -> 10,851 -> 11,379 -> 19,451
quant_inst_ed_eu_fixed$standardized_organization %>% unique %>% length # 305,329 -> 30,549 -> 10,874 -> 11,406 -> 19,002
quant_inst_ed_eu_fixed$final_standardized_organization %>% unique %>% length # 225,211 25,252 -> 8,894 -> 9,173 -> 15,435

quant_inst_ed_eu_fixed$final_standardized_organization %>% table %>%
  data.frame %>%
  arrange(desc(Freq))

quant_pub_ed_eu <- quant_pub_ed %>% 
  inner_join(quant_inst_ed_eu_fixed %>% select(pubid) %>% unique)
save(quant_pub_ed_eu, file="R file/quant_pub_ed_eu.RData")
write.csv(quant_pub_ed_eu, file="R file/quant_pub_ed_eu.csv")
rm(quant_pub_ed, quant_pub_ed_eu)

load(file="R file/quant_author.RData")
quant_author_ed_eu <- quant_author %>% 
  inner_join(quant_inst_ed_eu_fixed %>% select(pubid) %>% unique)
quant_author_ed_eu %>% filter(is.na(author_id_te))
quant_inst_ed_eu_fixed$pubid %>% unique %>% length # 55,582 -> 58,453 -> 59,076
save(quant_author_ed_eu, file="R file/quant_author_ed_eu.RData")
write.csv(quant_author_ed_eu, file="R file/quant_author_ed_eu.csv")
rm(quant_author, quant_author_ed_eu, quant_inst_ed_eu_fixed)

####################################
### Validation Check

load(file="R file/quant_keyword.RData")
load(file="R file/quant_pub_ed_eu.RData")

library(openxlsx)
library(xlsx)
j<-"qc1"
for(j in unique(substr(quant_pub_ed_eu$qc_category,1,3))){
  temp <- quant_keyword %>% 
    filter(substr(qc_category,1,3)==j) %>%
    inner_join(quant_pub_ed_eu) %>%
    select(qc_category,keyword) %>% unique %>%
    filter(is.na(keyword)==FALSE)
    
  temp.list <- list()
  for (i in 1:length(unique(temp$qc_category))){
    temp.list[[i]] <- temp %>%
      filter(qc_category==unique(temp$qc_category)[i])
    names(temp.list)[[i]] <- unique(temp$qc_category)[i]
    # names(temp.list[[i]]) <- unique(temp$qc_category)[i]
    # openxlsx::write.xlsx(temp.list,file=paste0("R file/",j,"_keyword_validation.xlsx"))
  }
  
  wb <- openxlsx::createWorkbook()
  for (sheet_name in names(temp.list)){
    addWorksheet(wb, sheetName = sheet_name)
    writeData(wb, sheet = sheet_name, x = temp.list[[sheet_name]])
  }
  
  file_path <- paste0("R file/", j, "_keyword_validation.xlsx")
  if (file.exists(file_path)) {
    file.remove(file_path)
  }
  
  openxlsx::saveWorkbook(wb, file = paste0("R file/", j, "_keyword_validation.xlsx"), 
                         overwrite = TRUE)
  
  print(j)
}


####################################

### Quant-EU Data Descriptives
load(file="R file/quant_pub_ed_eu.RData")
quant_pub_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 

# Random sampling 5 for each
write.csv(quant_pub_ed_eu %>% group_by(qc_category,label) %>%
            sample_n(4),
          file="R file/quant_pub_ed_eu_random.csv",
          fileEncoding="cp949")

# Frequency Table
quant_pub_ed_eu %>% group_by(qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% data.frame

# annual trend 
quant_pub_ed_eu %>% group_by(pubyear) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=1)) + geom_line() + theme_bw()

quant_pub_ed_eu %>% group_by(pubyear) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  mutate(pubyear=as.numeric(pubyear)) %>% arrange(pubyear) %>%
  mutate(Diff_year = pubyear - lag(pubyear),  # Difference in time (just in case there are gaps)
         Diff_growth = pub - lag(pub), # Difference in route between years
         Rate_percent = (Diff_growth / Diff_year)/pub * 100) %>% 
  mutate(mean(Rate_percent,na.rm=TRUE)) %>% data.frame

# annual trend - full digit
quant_pub_ed_eu %>% filter(nchar(qc_category)==5) %>%
  group_by(pubyear,qc_category) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=qc_category, color=qc_category)) + 
  geom_line() + theme_bw()

# annual trend - QC4
quant_pub_ed_eu %>% 
  mutate(qc3=substr(qc_category,1,3)) %>%
  group_by(pubyear,qc3) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=qc3, color=qc3)) + geom_line() +
  geomtextpath::geom_textline(aes(label = qc3), hjust = 1) + theme_bw()

quant_pub_ed_eu %>% 
  mutate(qc4=substr(qc_category,1,4)) %>%
  group_by(pubyear,qc4) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot2::ggplot(aes(x=pubyear, y=pub, group=qc4, color=qc4)) + geom_line() +
  geomtextpath::geom_textline(aes(label = qc4), hjust = 1) + theme_bw()
  # geom_label_repel(aes(label = qc4), nudge_x = 1, na.rm = TRUE)

load(file="R file/quant_inst_ed_eu_fixed.RData")
quant_inst_ed_eu_fixed %<>% left_join(quan_lable %>% select(qc_category,label)) 

quant_inst_ed_eu_fixed %>% group_by(pubyear,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=country, color=country)) + geom_line() + 
  geomtextpath::geom_textline(aes(label = country), hjust = 1) + theme_bw() +
  theme_bw() + guides(color=FALSE)

# Country distribution
quant_inst_ed_eu_fixed %>% group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=country, y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) 

quant_inst_ed_eu_fixed %>% group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  mutate(all_pub = length(unique(quant_inst_ed_eu_fixed$pubid))) %>%
  mutate(prop= pub/all_pub) %>% head(20)

# Collaboration bar
quant_inst_ed_eu_fixed %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_inst_ed_eu_fixed %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_inst_ed_eu_fixed %>% group_by(pubid) %>%
                          summarize(count=length(unique(country)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE)

quant_inst_ed_eu_fixed %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_inst_ed_eu_fixed %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_inst_ed_eu_fixed %>% group_by(pubid) %>%
                          summarize(count=length(unique(final_standardized_organization)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE)

# Number of publications for each country
quant_inst_ed_eu_fixed %>% 
  mutate(qc3=substr(qc_category,1,3)) %>%
  group_by(country,qc3) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=country, y=pub, group=qc3, fill=qc3)) + 
  geom_bar(position="fill", stat='identity') +
  coord_flip() + theme_bw()

ctr.cat.fig <- list()
for(i in 1:length(unique(quant_inst_ed_eu_fixed$country))){
  temp <- quant_inst_ed_eu_fixed %>% filter(country==unique(quant_inst_ed_eu_fixed$country)[i])
  ctr.cat.fig[[i]] <- temp %>% group_by(qc_category) %>%
    summarize(pub=length(unique(pubid))) %>%
    ggplot(aes(x=qc_category, y=pub)) + geom_bar(position="dodge", stat='identity') +
    coord_flip() + theme_bw() + guides(color=TRUE) +
    labs(x='Publications',y='Categories', title=paste(unique(temp$country))) 
  ctr.cat.fig[[i]]
  ggsave(paste0("R figure/",unique(temp$country),"_ctr_cat.png"))
}
quant_inst_ed_eu_fixed %>% group_by(country,qc_category) %>%
  summarize(pub=length(unique(pubid))) %>% ungroup %>%
  group_by(country) %>% arrange(desc(pub)) %>% slice(1) %>% data.frame

# Top institute 
quant_inst_ed_eu_fixed %>% group_by(final_standardized_organization) %>%
  summarize(pub=length(unique(pubid))) %>% ungroup %>%
  arrange(desc(pub)) %>% head(20) %>% 
  ggplot(aes(x=final_standardized_organization, y=pub)) +
  geom_bar(stat="identity") +
  coord_flip() + theme_bw()

# Top institute for each country
quant_inst_ed_eu_fixed %>% group_by(country,final_standardized_organization) %>%
  summarize(pub=length(unique(pubid))) %>% ungroup %>%
  group_by(country) %>% arrange(desc(pub)) %>% slice(1) %>% data.frame %>%
  left_join(quant_inst_ed_eu_fixed %>% group_by(country) %>%
              summarize(ctr_pub=length(unique(pubid)))) %>%
  mutate(prop = pub/ctr_pub)


# Top institute for each category
load(file="R file/quant_inst_ed_eu_fixed.RData")
quant_inst_ed_eu_fixed %<>% left_join(quan_lable %>% select(qc_category,label)) 

quant_inst_ed_eu_fixed %>% head(1)

Top.inst.fig <- list()
for (i in 1:length(unique(quant_inst_ed_eu_fixed$qc_category))){
  temp <- quant_inst_ed_eu_fixed %>% 
    filter(qc_category==unique(quant_inst_ed_eu_fixed$qc_category)[i]) 
  Top.inst.fig[[i]] <- temp %>%
    group_by(qc_category,label,final_standardized_organization) %>%
    summarize(pub = length(unique(pubid))) %>% 
    arrange(qc_category, desc(pub)) %>%
    slice(1:5) %>%
    ggplot(aes(x=final_standardized_organization,y=pub)) + geom_bar(stat='identity') +
    labs(x='Organization',y='Number of Publications', 
               title=paste(unique(temp$qc_category),unique(temp$label))) +
    coord_flip()
  Top.inst.fig[[i]]
  ggsave(paste0("R figure/",unique(temp$qc_category),"_top_inst.png"))
}

Top.ctr.fig <- list()
for (i in 1:length(unique(quant_inst_ed_eu_fixed$qc_category))){
  temp <- quant_inst_ed_eu_fixed %>% 
    filter(qc_category==unique(quant_inst_ed_eu_fixed$qc_category)[i]) 
  Top.ctr.fig[[i]] <- temp %>%
    group_by(qc_category,label,country) %>%
    summarize(pub = length(unique(pubid))) %>% 
    arrange(qc_category, desc(pub)) %>%
    # slice(1:5) %>%
    ggplot(aes(x=country,y=pub)) + geom_bar(stat='identity') +
    labs(x='Country',y='Number of Publications', 
         title=paste(unique(temp$qc_category),unique(temp$label))) +
    coord_flip()
  Top.ctr.fig[[i]]
  ggsave(paste0("R figure/",unique(temp$qc_category),"_ctr_bar.png"))
}

###############
load(file="R file/quant_author_ed_eu.RData")
quant_author_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 
quant_author_ed_eu %>% head

# Collaboration bar
quant_author_ed_eu %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_author_ed_eu %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_author_ed_eu %>% group_by(pubid) %>%
                          summarize(count=length(unique(author_id_te)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.collab) %>%
  ggplot(aes(x=qc_label,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip()

quant_author_ed_eu %>% group_by(qc_category,label,wos_standard) %>%
  summarize(pub=length(unique(pubid))) %>%
  arrange(qc_category,label,pub) %>%
  slice(1:5)

###############
# Final Data Preparation
###############
load(file="R file/quant_pub_ed_eu.RData")
quant_pub_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 
write.csv(quant_pub_ed_eu, file="../../07_QuanTumData/quant_pub_ed_eu.csv")

load(file="R file/quant_inst_ed_eu_fixed.RData")
quant_inst_ed_eu_fixed %<>% left_join(quan_lable %>% select(qc_category,label)) 
write.csv(quant_inst_ed_eu_fixed, file="../../07_QuanTumData/quant_inst_ed_eu_fixed.csv")

load(file="R file/quant_author_ed_eu.RData")
quant_author_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 
write.csv(quant_author_ed_eu, file="../../07_QuanTumData/quant_author_ed_eu.csv")


