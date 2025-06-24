#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project - Data Prep 05. Revised Analysis
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


# library('devtools')
# library('backports')
# devtools::install_github("PABalland/EconGeo", force = T)
library('EconGeo')
library('igraph')
library('data.table')
library(GGally)
library(ggplot2)
library(dplyr)
library(magrittr)

library('dplyr')
library('magrittr')
library('tidyr')
library('ggplot2')
library('splitstackshape')

eu_country <- 
  c("GREECE","NETHERLANDS","DENMARK","GERMANY","LATVIA","ROMANIA","LUXEMBOURG",
    "LITHUANIA","MALTA","BELGIUM","BULGARIA","SWEDEN","SPAIN","SLOVAKIA","SLOVENIA",
    "IRELAND","ESTONIA","AUSTRIA","ITALY","CZECH REPUBLIC","CROATIA","CYPRUS",
    "PORTUGAL","POLAND","FRANCE","FINLAND","HUNGARY",
    "SWITZERLAND","ENGLAND","NORWAY","ICELAND","FINLAND","ISRAEL")

file.list <- c("../Quant_val/qc1-1_keyword_validation_최종(O)_완료.xlsx",
               "../Quant_val/qc1-2_keyword_validation_최종(O)_완료.xlsx",
               "../Quant_val/qc2_keyword_validation_최종(O)_완료.xlsx",
               "../Quant_val/qc3_keyword_validation_최종(O)_완료.xlsx",
               "../Quant_val/qc4_keyword_validation_최종(O)_완료.xlsx")

# qc11
qc11_val <- openxlsx::getSheetNames("../Quant_val/qc1-1_keyword_validation_최종(O)_완료.xlsx")
qc11_val <- qc11_val[qc11_val!="qc_label"]

qc11_val_list <- lapply(qc11_val,
                        openxlsx::read.xlsx,
                        xlsxFile="../Quant_val/qc1-1_keyword_validation_최종(O)_완료.xlsx")
names(qc11_val_list) <- qc11_val_list

qc11_val_df <- 0
for (i in 1:length(qc11_val_list)){
  names(qc11_val_list[[i]])[3] <- "val"
  names(qc11_val_list[[i]])[4] <- "comment"
  qc11_val_list[[i]] <- qc11_val_list[[i]] %>% 
    filter(is.na(val)==FALSE) %>% select(1:4)
  qc11_val_df <- rbind(qc11_val_df, qc11_val_list[[i]])
}
qc11_val_df <- qc11_val_df[2:nrow(qc11_val_df),]
qc11_val_df %>% head

# qc12
qc12_val <- openxlsx::getSheetNames("../Quant_val/qc1-2_keyword_validation_최종(O)_완료.xlsx")
qc12_val <- qc12_val[qc12_val!="qc_label"]

qc12_val_list <- lapply(qc12_val,
                        openxlsx::read.xlsx,
                        xlsxFile="../Quant_val/qc1-2_keyword_validation_최종(O)_완료.xlsx")
names(qc12_val_list) <- qc12_val_list

lapply(qc12_val_list, names)

qc12_val_df <- 0
for (i in 1:length(qc12_val_list)){
  names(qc12_val_list[[i]])[3] <- "val"
  names(qc12_val_list[[i]])[4] <- "comment"
  qc12_val_list[[i]] <- qc12_val_list[[i]] %>% 
    filter(is.na(val)==FALSE) %>% select(1:4)
  qc12_val_df <- rbind(qc12_val_df, qc12_val_list[[i]])
}
qc12_val_df <- qc12_val_df[2:nrow(qc12_val_df),]

# qc2
qc2_val <- openxlsx::getSheetNames("../Quant_val/qc2_keyword_validation_최종(O)_완료.xlsx")
qc2_val <- qc2_val[qc2_val!="qc_label"]
qc2_val <- gsub(" ", "", qc2_val, fixed = TRUE)

qc2_val_list <- lapply(qc2_val,
                        openxlsx::read.xlsx,
                        xlsxFile="../Quant_val/qc2_keyword_validation_최종(O)_완료.xlsx")
names(qc2_val_list) <- qc2_val_list

lapply(qc2_val_list, names)

qc2_val_df <- 0
for (i in 1:length(qc2_val_list)){
  names(qc2_val_list[[i]])[3] <- "val"
  names(qc2_val_list[[i]])[4] <- "comment"
  qc2_val_list[[i]] <- qc2_val_list[[i]] %>% 
    filter(is.na(val)==FALSE) %>% select(1:4)
  qc2_val_df <- rbind(qc2_val_df, qc2_val_list[[i]])
}
qc2_val_df <- qc2_val_df[2:nrow(qc2_val_df),]
qc2_val_df %>% filter(qc_category=="qc224") # no

# qc3
qc3_val <- openxlsx::getSheetNames("../Quant_val/qc3_keyword_validation_최종(O)_완료.xlsx")
qc3_val <- qc3_val[qc3_val!="qc_label"]

qc3_val_list <- lapply(qc3_val,
                       openxlsx::read.xlsx,
                       xlsxFile="../Quant_val/qc3_keyword_validation_최종(O)_완료.xlsx")
names(qc3_val_list) <- qc3_val_list

lapply(qc3_val_list, names)

qc3_val_df <- 0
for (i in 1:length(qc3_val_list)){
  names(qc3_val_list[[i]])[3] <- "val"
  names(qc3_val_list[[i]])[4] <- "comment"
  qc3_val_list[[i]] <- qc3_val_list[[i]] %>% 
    filter(is.na(val)==FALSE) %>% select(1:4)
  qc3_val_df <- rbind(qc3_val_df, qc3_val_list[[i]])
}
qc3_val_df <- qc3_val_df[2:nrow(qc3_val_df),]
qc3_val_df %>% filter(qc_category=="qc313") # no

# qc4
qc4_val <- openxlsx::getSheetNames("../Quant_val/qc4_keyword_validation_최종(O)_완료.xlsx")
qc4_val <- qc4_val[qc4_val!="qc_label"]

qc4_val_list <- lapply(qc4_val,
                       openxlsx::read.xlsx,
                       xlsxFile="../Quant_val/qc4_keyword_validation_최종(O)_완료.xlsx")
names(qc4_val_list) <- qc4_val_list

lapply(qc4_val_list, names)

qc4_val_df <- 0
for (i in 1:length(qc4_val_list)){
  names(qc4_val_list[[i]])[3] <- "val"
  names(qc4_val_list[[i]])[4] <- "comment"
  qc4_val_list[[i]] <- qc4_val_list[[i]] %>% 
    filter(is.na(val)==FALSE) %>% select(1:4)
  qc4_val_df <- rbind(qc4_val_df, qc4_val_list[[i]])
}
qc4_val_df <- qc4_val_df[2:nrow(qc4_val_df),]

qc_all_val_df <- qc11_val_df %>%
  rbind(qc12_val_df) %>% 
  rbind(qc2_val_df) %>%
  rbind(qc3_val_df) %>%
  rbind(qc4_val_df)

save(qc_all_val_df, file="R file/qc_all_val_df.RData")

qc11_val_df$qc_category %>% unique %>% sort
qc_all_val_df$qc_category %>% unique %>% sort

#####################################################################################

load(file="R file/qc_all_val_df.RData")
load(file="R file/quant_keyword.RData")

quant_keyword_ed <- quant_keyword %>% inner_join(qc_all_val_df)
save(quant_keyword_ed, file="R file/quant_keyword_ed.RData")

quant_keyword_ed %>% group_by(qc_category) %>%
  summarize(count=length(unique(pubid))) %>% data.frame

### Restrict to European Regions
load(file="R file/quant_pub_ed.RData")
load(file="R file/quant_inst_ed.RData")

quant_pub_ed_val <- quant_pub_ed %>% 
  inner_join(quant_keyword_ed %>% select(qc_category,pubid) %>% unique) 
save(quant_pub_ed_val, file="R file/quant_pub_ed_val.RData")

quant_inst_ed_eu_val <- quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique)
quant_inst_ed_eu_val$pubid %>% unique %>% length # 20,423
save(quant_inst_ed_eu_val, file="R file/quant_inst_ed_eu_val.RData")


library(stringr)
quant_inst_ed_eu_val <- quant_inst_ed_eu_val %>%
  mutate(
    organization_clean = str_match(organization, "\\(([^)]+)\\)")[,2],
    organization_clean = ifelse(is.na(organization_clean), organization, organization_clean)) 

quant_inst_ed_eu_val <- quant_inst_ed_eu_val %>%
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

quant_inst_ed_eu_val$pubid %>% unique %>% length # 20,423
quant_inst_ed_eu_val$organization %>% unique %>% length # 9,839
save(quant_inst_ed_eu_val, file="R file/quant_inst_ed_eu_val.RData")
write.csv(quant_inst_ed_eu_val, file="R file/quant_inst_ed_eu_val.csv")

quant_inst_ed_eu_val %>% filter(qc_category=="qc224")

quant_inst_ed_eu_val$qc_category %>% unique %>% sort

############################################################################################################
#### Institution name check

# ~~~ Python Codes QuanTech_org_preprocessing.ipynb ~~~ #  

quant_inst_ed_eu_fixed_val <-
  read.csv("R file/quant_inst_ed_eu_fixed_standardized.csv")
save(quant_inst_ed_eu_fixed_val, file="R file/quant_inst_ed_eu_fixed_val.RData")

load(file="R file/quant_inst_ed_eu_fixed_val.RData")
load(file="R file/quant_pub_ed_val.RData")

quant_inst_ed_eu_fixed_val %>% names
quant_inst_ed_eu_fixed_val$pubid %>% unique %>% length # 21,419
quant_inst_ed_eu_fixed_val$organization %>% unique %>% length # 9,986
quant_inst_ed_eu_fixed_val$standardized_organization %>% unique %>% length # 7,439
quant_inst_ed_eu_fixed_val$final_standardized_organization %>% unique %>% length # 7,450
quant_inst_ed_eu_fixed_val$final_grouped_organization %>% unique %>% length # 7,296

quant_inst_ed_eu_fixed_val %>% filter(qc_category=="qc224")
quant_inst_ed_eu_fixed_val %>% filter(final_grouped_organization=="RESEARCH ORGANIZATION OF INFORMATION  SYSTEMS ROIS")

quant_inst_ed_eu_fixed_val$final_standardized_organization %>% table %>%
  data.frame %>%
  arrange(desc(Freq))

############################################################################################################
#### Divide three parts

quan_lable <- read.csv(file="qc_label.csv", 
                       encoding = "UTF-8") 
names(quan_lable) <- c("qc_category","label")

# load(file="R file/quant_pub_ed_val.RData")
# quant_pub_ed_eu_val <- quant_pub_ed_val %>%  
#   inner_join(quant_inst_ed_eu_fixed_val %>% select(qc_category,pubid) %>% unique)
# quant_pub_ed_eu_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
# save(quant_pub_ed_eu_val, file=paste0("R file/quant_pub_ed_eu_val.RData"))
# write.csv(quant_pub_ed_eu_val, file=paste0("R file/quant_pub_ed_eu_val.csv"))

part1 <- c(qc11_val,qc2_val,qc3_val)
part2 <- c("qc11","qc12","qc13","qc14","qc21","qc22","qc1a1","qc1a2","qc1a3",
           "qc1a4","qc1a5","qc1a6","qc421","qc422","qc423","qc424","qc43")
part3 <- c(qc11_val,qc12_val,qc2_val,qc3_val)
part4 <- c(qc4_val)

part.list <- list(part1, part2, part3, part4)

i <- 2
for(i in 1:length(part.list)){
  load(file="R file/quant_inst_ed_eu_fixed_val.RData")
  if (i ==2){
    quant_inst_ed_eu_fixed_val <- quant_inst_ed_eu_fixed_val %>%
      mutate(type=substr(qc_category,1,4)) %>%
      mutate(qc_category=ifelse(type %in% c("qc11","qc12","qc13","qc14","qc21","qc22"),
                                type,qc_category)) %>% 
      filter(qc_category %in% part.list[[i]])
  } else{
    quant_inst_ed_eu_fixed_val <- quant_inst_ed_eu_fixed_val %>%
      filter(qc_category %in% part.list[[i]])
  }
  quant_inst_ed_eu_fixed_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
  save(quant_inst_ed_eu_fixed_val, 
       file=paste0("R file/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
  write.csv(quant_inst_ed_eu_fixed_val, 
            file=paste0("R file/part",i,"_quant_inst_ed_eu_fixed_val.csv"))
  
  load(file="R file/quant_pub_ed_val.RData")
  if (i ==2){
    quant_pub_ed_eu_val <- quant_pub_ed_val %>%
      mutate(type=substr(qc_category,1,4)) %>%
      mutate(qc_category=ifelse(type %in% c("qc11","qc12","qc13","qc14","qc21","qc22"),
                                type,qc_category)) %>% 
      filter(qc_category %in% part.list[[i]]) %>%
      inner_join(quant_inst_ed_eu_fixed_val %>% select(qc_category,pubid) %>% unique)
  } else{
    quant_pub_ed_eu_val <- quant_pub_ed_val %>% 
      filter(qc_category %in% part.list[[i]]) %>%
      inner_join(quant_inst_ed_eu_fixed_val %>% select(qc_category,pubid) %>% unique)
  }
  quant_pub_ed_eu_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
  save(quant_pub_ed_eu_val, file=paste0("R file/part",i,"_quant_pub_ed_eu_val.RData"))
  write.csv(quant_pub_ed_eu_val, file=paste0("R file/part",i,"_quant_pub_ed_eu_val.csv"))
  rm(quant_pub_ed_val, quant_pub_ed_eu_val)
  
  load(file="R file/quant_author.RData")
  if (i ==2){
    quant_author_ed_eu_val <- quant_author %>%
      mutate(type=substr(qc_category,1,4)) %>%
      mutate(qc_category=ifelse(type %in% c("qc11","qc12","qc13","qc14","qc21","qc22"),
                                type,qc_category)) %>% 
      filter(qc_category %in% part.list[[i]]) %>%
      inner_join(quant_inst_ed_eu_fixed_val %>% select(pubid) %>% unique)
  } else{ 
    quant_author_ed_eu_val <- quant_author %>% 
      filter(qc_category %in% part.list[[i]]) %>%
      inner_join(quant_inst_ed_eu_fixed_val %>% select(pubid) %>% unique)
  }
  quant_author_ed_eu_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
  save(quant_author_ed_eu_val, file=paste0("R file/part",i,"_quant_author_ed_eu_val.RData"))
  write.csv(quant_author_ed_eu_val, file=paste0("R file/part",i,"_quant_author_ed_eu_val.csv"))
  rm(quant_author, quant_author_ed_eu_val, quant_inst_ed_eu_fixed_val)
}

# load(file=paste0("R file/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
# load(file=paste0("R file/part",i,"_quant_pub_ed_eu_val.RData"))
# load(file=paste0("R file/part",i,"_quant_author_ed_eu_val.RData"))

####################################

load(file=paste0("R file/quant_pub_ed_eu_val.RData"))

# Frequency Table
quant_pub_ed_eu_val %>% group_by(qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% data.frame


############################################################################################################
#### Quant-EU Data Descriptives

i <- 2
load(file=paste0("R file/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
load(file=paste0("R file/part",i,"_quant_pub_ed_eu_val.RData"))
load(file=paste0("R file/part",i,"_quant_author_ed_eu_val.RData"))
# Merge researchers
quant_author_ed_eu_val$display_name[quant_author_ed_eu_val$author_id_te==13520735] <- "Gisin, Nicolas"
quant_author_ed_eu_val$author_id_te[quant_author_ed_eu_val$author_id_te==13520735] <- 13520752
quant_author_ed_eu_val$display_name[quant_author_ed_eu_val$author_id_te==6985964] <- "Chen, Yu"
quant_author_ed_eu_val$author_id_te[quant_author_ed_eu_val$author_id_te==6985964] <- 7063708

quant_author_ed_eu_val$qc_category %>% unique

# annual trend 
quant_pub_ed_eu_val %>% group_by(pubyear) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=1)) + geom_line() + theme_bw()

quant_pub_ed_eu_val %>% group_by(pubyear) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  mutate(pubyear=as.numeric(pubyear)) %>% arrange(pubyear) %>%
  mutate(Diff_year = pubyear - lag(pubyear),  # Difference in time (just in case there are gaps)
         Diff_growth = pub - lag(pub), # Difference in route between years
         Rate_percent = (Diff_growth / Diff_year)/pub * 100) %>% 
  mutate(mean(Rate_percent,na.rm=TRUE)) %>% data.frame

# annual trend - full digit
quant_pub_ed_eu_val %>% filter(nchar(qc_category)==5) %>%
  group_by(pubyear,qc_category) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=qc_category, color=qc_category)) + 
  geom_line() + theme_bw()

# annual trend - QC4
quant_pub_ed_eu_val %>% 
  mutate(qc3=substr(qc_category,1,3)) %>%
  group_by(pubyear,qc3) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=qc3, color=qc3)) + geom_line() +
  geomtextpath::geom_textline(aes(label = qc3), hjust = 1) + theme_bw()

quant_pub_ed_eu_val %>% 
  mutate(qc4=substr(qc_category,1,4)) %>%
  group_by(pubyear,qc4) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot2::ggplot(aes(x=pubyear, y=pub, group=qc4, color=qc4)) + geom_line() +
  geomtextpath::geom_textline(aes(label = qc4), hjust = 1) + theme_bw()
# geom_label_repel(aes(label = qc4), nudge_x = 1, na.rm = TRUE)

quant_inst_ed_eu_fixed_val %>% group_by(pubyear,country) %>%
  filter(country %in% eu_country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=country, color=country)) + geom_line() + 
  geomtextpath::geom_textline(aes(label = country), hjust = 1) + theme_bw() +
  theme_bw() + guides(color=FALSE)

### 3-1 양자과학기술 분류별 통계
### 3-2 양자과학기술 연도별 통계
### 3-3 양자과학기술 기관별 통계

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category, label,final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% 
  arrange(qc_category,desc(pub)) %>% #slice(1) %>% 
  filter(qc_category=="qc213") %>% 
  data.frame

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category, label) %>%
  summarize(org = length(unique(final_grouped_organization))) %>% 
  data.frame %>% 
  arrange(qc_category) 

# 양자과학기술 분야별 논문 수
quant_pub_ed_eu_val %>% group_by(qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% data.frame

# 국가별 양자과학기술 논문 수
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% #head(30) %>%
  ggplot(aes(x=reorder(country,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("국가")

quant_inst_ed_eu_fixed_val %>% 
  # filter(country %in% eu_country) %>%
  group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame

# (전체) 국가별 양자과학기술 논문 수
quant_inst_ed_eu_fixed_val %>% 
  # filter(country %in% eu_country) %>%
  group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% # head(30) %>%
  ggplot(aes(x=reorder(country,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("국가")

# 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
  group_by(qc_category) %>% filter(pub==max(pub)) %>%
  arrange(qc_category) %>% 
  data.frame

# (유럽) 기관별 논문 수 (상위 30개)
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% head(30) %>%
  ggplot(aes(x=reorder(final_grouped_organization,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

# Organization - country list
org_country_list <- quant_inst_ed_eu_fixed_val %>% 
  group_by(final_grouped_organization,country) %>% 
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub))

# (비유럽) 기관별 논문 수 (상위 30개)
'%ni%' <- Negate('%in%')
quant_inst_ed_eu_fixed_val %>% 
  filter(country %ni% eu_country) %>%
  group_by(final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% head(30) %>% 
  ggplot(aes(x=reorder(final_grouped_organization,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

# 상위 한국-유럽 협력 기관
quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  group_by(final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame

quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  select(pubid) %>% unique %>%
  left_join(quant_inst_ed_eu_fixed_val) %>%
  filter(country != 'SOUTH KOREA') %>%
  group_by(final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(10)

# 상위 한국-유럽 협력 연구자
quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  select(pubid) %>% unique %>%
  left_join(quant_author_ed_eu_val) %>%
  inner_join(res.inst.sum) %>%
  group_by(author_id_te, display_name,final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(20)

quant_author_ed_eu_val %>% filter(author_id_te==7243816) %>%
  select(pubid) %>% head(2) %>%
  inner_join(quant_pub_ed_eu_val)

quant_inst_ed_eu_fixed_val %>% 
  select(pubid) %>% unique %>%
  left_join(quant_author_ed_eu_val) %>%
  inner_join(res.inst.sum) %>%
  filter(country == 'SOUTH KOREA') %>%
  group_by(author_id_te, display_name,final_groupedorganization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(10)


top.country <- c("GERMANY","ENGLAND","ITALY","FRANCE",
                 "SWITZERLAND","AUSTRIA","SPAIN","NETHERLANDS")
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% top.country) %>%
  group_by(country, final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  group_by(country) %>% arrange(desc(pub)) %>% slice(1:5) %>% data.frame

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% top.country) %>%
  group_by(country, final_grouped_organization,label) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  group_by(country, final_grouped_organization) %>% arrange(desc(pub)) %>% 
  slice(1:5) 

top.inst <- c("MAX PLANCK SOCIETY", "MAX PLANCK INSTITUTE QUANTEM OPT", 
              "UNIVERSITY OF MUNICH", "UNIVERSITY OF HANNOVER", "HELMHOLTZ ASSOCIATION",
              "UNIVERSITY OF OXFORD", "UNIVERSITY OF CAMBRIDGE", "IMPERIAL COLLEGE LONDON", 
              "UNIVERSITY OF BRISTOL", "QUEEN MARY UNIVERSITY OF LONDON",
              "CNRS", "UNIVERSITY OF PARIS SACLAY", "PSL RESEARCH UNIVERSITY PARIS", "SORBONNE UNIVERSITY", 
              "ECOLE NORMALE SUPERIEURE ENS PARIS",
              "CNR", "IST NAZL FIS NUCL", "SAPIENZA UNIVERSITY ROME", "UNIVERSITY OF PAVIA",
              "UNIVERSITY OF FIRENZE",
              "BARCELONA INSTITUTE OF SCIENCE  TECHNOL","ICFO","POLYTECHNIC UNIVERSITY OF CATALONIA",
              "ICREA","CSIC",
              "ETH","UNIVERSITY OF GENEVA","UNIVERSITY OF BASEL",
              "SWISS FED INSTITUTE TECHNOL","ECOLE POLYTECH FED LAUSANNE",
              "DELFT UNIVERSITY OF TECHNOL","UNIVERSITY OF AMSTERDAM","LEIDEN UNIVERSITY",
              "UNIVERSITY OF UTRECHT","EINDHOVEN UNIVERSITY OF TECHNOL",
              "UNIVERSITY OF INNSBRUCK","AUSTRIAN ACAD SCIENCE","UNIVERSITY OF VIENNA",
              "TECHNOLOGY UNIVERSITY OF WIEN","JOHANNES KEPLER UNIVERSITY")

# 기관별 양자과학기술 주 연구 분야
quant_inst_ed_eu_fixed_val %>% 
  filter(final_grouped_organization %in% top.inst) %>%  
  select(-c("country")) %>%
  left_join(org_country_list) %>%
  left_join(quant_author_ed_eu_val %>% select(pubid,author_id_te,full_name) %>% unique) %>%
  group_by(country,final_grouped_organization,qc_category) %>% 
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(country,final_grouped_organization) %>% arrange(desc(pub)) %>%
  slice(1:3) %>% data.frame
  
quant_inst_ed_eu_fixed_val %>% 
  filter(final_grouped_organization %in% top.inst) %>%  
  select(-c("country")) %>%
  left_join(org_country_list) %>%
  left_join(quant_author_ed_eu_val %>% select(pubid,author_id_te,full_name) %>% unique) %>%
  group_by(country,final_grouped_organization,qc_category) %>% 
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(country,final_grouped_organization) %>% arrange(desc(pub)) %>%
  slice(1:3) %>% ungroup %>%
  group_by(qc_category) %>% summarize(count=n())

# 양자과학기술 분야별 상위 기관
quant_inst_ed_eu_fixed_val %>% 
  # filter(country %in% eu_country) %>%
  group_by(qc_category, label,final_grouped_organization) %>%
  summarize(pub = length(unique(pubid))) %>% 
  arrange(qc_category,desc(pub)) %>% 
  # filter(qc_category=="qc131") %>% select(final_grouped_organization)
  slice(1) %>% data.frame 

# Organization - country list
res_org_list <- quant_author_ed_eu_val %>% 
  left_join(quant_inst_ed_eu_fixed_val %>% select(-c("country")) %>% 
              left_join(org_country_list) %>% select(pubid,final_grouped_organization,country) %>% unique) %>%
  group_by(author_id_te,full_name, final_grouped_organization,country) %>%
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub)) 

quant_author_ed_eu_val %>% 
  group_by(qc_category, author_id_te, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  inner_join(res_org_list) %>% 
  filter(country %ni% eu_country) %>%
  filter(qc_category=="qc131") %>% data.frame

quant_author_ed_eu_val %>% 
  filter(last_name == 'Schmidt') # Giazotto Treps Walther Barz

### 3-7 양자과학기술 연도별 분류별 기관별 통계
### 3-8 양자과학기술 연도별 분류별 연구자별 통계
### 3-9 양자과학기술 협력 통계

# Collaboration bar - country
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_inst_ed_eu_fixed_val %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_inst_ed_eu_fixed_val %>% group_by(pubid) %>%
                          summarize(count=length(unique(country)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE)

# Collaboration bar - organization
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_inst_ed_eu_fixed_val %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_inst_ed_eu_fixed_val %>% group_by(pubid) %>%
                          summarize(count=length(unique(final_grouped_organization)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.org.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.org.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  #coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "bottom") +
  scale_fill_discrete(name="Type") 

# sol org vs. collab org
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(final_grouped_organization))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.org", org!=1~"collab.org")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(count=length(unique(pubid))) %>%
  ggplot(aes(x=qc_category,y=count,fill=collab.d)) + geom_bar(position="dodge", stat='identity') +
  # coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "none") +
  scale_fill_discrete(name="Type") 

quant_inst_ed_eu_fixed_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(final_grouped_organization))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole", org!=1~"collab")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% filter(collab.d=="collab") %>% 
  ggplot(aes(x=qc_category,y=org)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE) +
  geom_hline(yintercept = 4.89, col="red") +
  geom_hline(yintercept = 2.94, col="blue") +
  ylab("Average Number of Organizations") + xlab("Quantum Category") + theme(legend.position = "bottom") 

quant_inst_ed_eu_fixed_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(final_grouped_organization))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole", org!=1~"collab")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% ungroup %>% 
  filter(collab.d=="collab") %>%
  mutate(mean.org=mean(org))

# Collaboration bar - researcher
quant_author_ed_eu_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_author_ed_eu_val %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_author_ed_eu_val %>% group_by(pubid) %>%
                          summarize(count=length(unique(author_id_te)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.res.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.res.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "bottom") +
  scale_fill_discrete(name="Type") 

# sole researcher vs. collab researcher
quant_author_ed_eu_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(author_id_te))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.res", org!=1~"collab.res")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(count=length(unique(pubid))) %>%
  ggplot(aes(x=qc_category,y=count,fill=collab.d)) + geom_bar(position="dodge", stat='identity') +
  # coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "none") +
  scale_fill_discrete(name="Type") 

quant_author_ed_eu_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(author_id_te))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.res", org!=1~"collab.res")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% filter(collab.d=="collab.res") %>% 
  ggplot(aes(x=qc_category,y=org)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE) +
  geom_hline(yintercept = 3.73, col="red") +
  geom_hline(yintercept = 6.36, col="blue") +
  ylab("Average Number of Researcher") + xlab("Quantum Category") + theme(legend.position = "bottom") 

quant_author_ed_eu_val %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(author_id_te))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.res", org!=1~"collab.res")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% ungroup %>% 
  filter(collab.d=="collab.res") %>%
  mutate(mean.org=mean(org))


### 3.2. 기관 네트워크
### 3.2.1. 기관 네트워크
### 1. DEG vs. BTW
### 2. EIG vs. BTW
### 3. OI vs. BTW
### 3.2.2. 분야별 기관 네트워크
### 1. DEG vs. BTW
### 2. EIG vs. BTW
### 3. OI vs. BTW
### 3.2.3. RCA vs. Relatedness Density

###############
# Final Data Preparation
###############

# load(file="R file/quant_pub_ed_eu_val.RData")
# quant_pub_ed_eu_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
# write.csv(quant_pub_ed_eu_val, file="../../07_QuanTumData/quant_pub_ed_eu_val.csv")
# 
# load(file="R file/quant_inst_ed_eu_fixed_val.RData")
# quant_inst_ed_eu_fixed_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
# write.csv(quant_inst_ed_eu_fixed_val, file="../../07_QuanTumData/quant_inst_ed_eu_fixed_val.csv")
# 
# load(file="R file/quant_author_ed_eu_val.RData")
# quant_author_ed_eu_val %<>% left_join(quan_lable %>% select(qc_category,label)) 
# write.csv(quant_author_ed_eu_val, file="../../07_QuanTumData/quant_author_ed_eu_val.csv")


###########################################################################
### Researcher-level analysis
###########################################################################

###########################################################################
### User-defined functions
###########################################################################

### [FUNCTION] GETTING EDGELIST
# Simpler version: available for big data set

getting.edgelist.local <- function(InputDF){
  
  # InputDF <- subset(app.inv.ipc, period==unique(app.inv.ipc$period)[[t]])
  # InputDF <- subset(pat.reg.cpc, US_CA_metro_name==unique(pat.reg.cpc$US_CA_metro_name)[[i]])
  InputDF <- org.set.w.type
  
  #1, Making list (Extracting unique cpc code for each observation to each list)
  from = which(colnames(InputDF)=="1")
  to = which(colnames(InputDF)==colnames(InputDF)[length(InputDF)])
  tech.list <- apply(InputDF,1,function(y) unique(y[c(from:to)]))
  
  #2. Excluding (NA code in cpc code)
  tech.list <- lapply(tech.list,function(y) y[!is.na(y)])  
  
  max.len <- max(sapply(tech.list, length))
  
  if (max.len >= 2) {
    corrected.list <- lapply(tech.list, function(x) {c(x, rep(NA, max.len - length(x)))})
    M1 <- do.call(rbind, corrected.list) 
    rm(corrected.list, tech.list)
    
    idx <- t(combn(max.len, 2))
    
    edgelist <- lapply(1:nrow(idx), function(ib) M1[, c(idx[ib, 1], idx[ib, 2])] %>% 
                         data.frame %>% 
                         drop_na()
    )
    
    edgelist <- do.call(rbind, edgelist) 
    
    edgelist %<>% mutate(share=1) %>% filter(is.na(X2)==FALSE) %>%
      dplyr::rename(Source=X1, Target=X2, weight=share)  
    
    edgelist <- edgelist[rowSums(is.na(edgelist[1:2]))==0, ]
    edgelist <- edgelist[edgelist$Source!="", ]
    edgelist <- edgelist[edgelist$Target!="", ] 
    edgelist <- edgelist[!is.na(edgelist$weight), ]
    edgelist <- edgelist %>% group_by(Source, Target) %>% summarize_at('weight', sum, na.rm=T)
    G <- graph.data.frame(edgelist,directed=FALSE)
    EL.DF <- data.frame(get.edgelist(G), weight=round(E(G)$weight, 3))
    names(EL.DF)<-c("Source", "Target", "Weight")
    
    return(EL.DF)
  } else {
    return(data.frame(Source=character(), Target=character(), Weight=numeric()))
  }
} 
rm(InputDF,from,to,tech.list,max.len,corrected.list,M1,idx,edgelist, EL.DF, G)

undirected.graph.summary<-function(Graph.object){
  Net<-Graph.object
  # 1. no. nodes
  no.node=length(V(Net))
  # 2. no. edges
  no.edge=length(E(Net))
  # 3. Net density: the ratio of the number of edges and the number of possible edges.
  # net.density=edge_density(Net, loops = FALSE)
  net.density=sum(E(Net)$weight) / ((vcount(Net)*(vcount(Net)-1)))
  # 4. Network Diameter: the length of the longest shortcut.
  net.diameter=diameter(Net, directed = F, unconnected = TRUE, weights = NULL)
  # 5. Ave. path length: mean value in the length of all the shortest paths
  ave.path=mean_distance(Net, directed = F, unconnected = TRUE)
  # 6. Ave. CC: the probability that the adjacent vertices of a vertex are connected
  ave.cc=transitivity(Net, type="global")
  
  ##
  output<-data.frame(no.node=no.node, no.edge=no.edge, net.density=round(net.density,3), 
                     net.diameter=round(net.diameter,3), ave.path=round(ave.path,3), ave.cc=round(ave.cc,3))
  return(output)
}

### [FUNCTION]  Centrality function
get.centrality<-function(Graph.object){
  # Net<-G.eu.p[[t]]
  Net<-Graph.object
  output<-data.frame(
    Deg=igraph::degree(Net),
    w.Deg=igraph::strength(Net),
    Btw=igraph::betweenness(Net, normalized = T),
    Eig=igraph::eigen_centrality(Net)$vector,
    Close=igraph::closeness(Net)
    # hub=hub_score(Net)$vector,
    # authority=authority_score(g)$vector
    # PageRank=page_rank(Net, directed = F)$vector
  )
  setDT(output, keep.rownames = TRUE)[]
  colnames(output)[1]<-"Id"
  return(output)}

directed.graph.summary<-function(Graph.object){
  Net<-Graph.object
  # 1. no. nodes
  no.node=length(V(Net))
  # 2. no. edges
  no.edge=length(E(Net))
  # 3. Net density: the ratio of the number of edges and the number of possible edges.
  # net.density=edge_density(Net, loops = FALSE)
  net.density=sum(E(Net)$weight) / ((vcount(Net)*(vcount(Net)-1)))
  # 4. Network Diameter: the length of the longest shortcut.
  net.diameter=diameter(Net, directed = F, unconnected = TRUE, weights = NULL)
  # 5. Ave. path length: mean value in the length of all the shortest paths
  ave.path=mean_distance(Net, directed = F, unconnected = TRUE)
  # 6. Ave. CC: the probability that the adjacent vertices of a vertex are connected
  ave.cc=transitivity(Net, type="global")
  
  ##
  output<-data.frame(no.node=no.node, no.edge=no.edge, net.density=round(net.density,3), 
                     net.diameter=round(net.diameter,3), ave.path=round(ave.path,3), ave.cc=round(ave.cc,3))
  return(output)
}

###########################################################################
### Country-level analysis
###########################################################################

### All 
w.ctr.table <- quant_inst_ed_eu_fixed_val %>% 
  group_by(pubid) %>% mutate(count=length(country)) %>%
  mutate(share=1/count) %>% ungroup %>%
  group_by(pubid,country) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  select(-c("weight"))

# generating ID (1,2,3,4...) by Application ID
ctr.set <- getanID(w.ctr.table, id.vars = "pubid")
colnames(ctr.set)[colnames(ctr.set)==".id"] <- "compound"
ctr.set$compound <- as.factor(ctr.set$compound)

# create CPC matrix: each row shows individual patent's list of CPCs
ctr.set.w <- spread(ctr.set, compound, country)

ALL.EL.total.all <- getting.edgelist.local(ctr.set.w)
ALL.EL.total.all %<>% dplyr::rename(weight=Weight)

ALL.EL.total.all %>% arrange(desc(weight)) %>%
  head(20)

# non-weight version  
ALL.G.p.all <- graph.data.frame(ALL.EL.total.all, directed=FALSE)
save(ALL.G.p.all, file="R file/ALL.G.p.all_val.RData")

ALL.EL.p.all <- data.frame(get.edgelist(ALL.G.p.all),
                           weight=round(E(ALL.G.p.all)$weight, 3))
names(ALL.EL.p.all) <- c("Source", "Target", "weight")

ALL.EL.p.all <- ALL.EL.p.all %>% 
  group_by(Source, Target) %>%
  summarize_at("weight", sum)

ID <- sort(unique(c(ALL.EL.p.all$Source, ALL.EL.p.all$Target)))
Node.table.all <- data.frame(Id=ID, Label=ID, tech=substr(ID, 0,1))

# Network analysis
summ.cen.all <- get.centrality(ALL.G.p.all) %>% 
  mutate(qc_category = "all")
save(summ.cen.all, file="R file/summ.cen.all_val.RData")

# 유럽만
summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(Id %in% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text() + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw() #+
  # geom_label(data = subset(summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))), 
  #                          Id == "ENGLAND"), 
  #            aes(x = w.Deg, y = Eig), 
  #            color = "darkgreen", 
  #            size = 5)

# 유럽 제외 나머지
`%ni%` <- Negate(`%in%`)
summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(Id %ni% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(color="blue") + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw() +
  geom_label(data = subset(summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))), 
                           Id == "SOUTH KOREA"), 
             aes(x = w.Deg, y = Eig), 
             color = "darkgreen", 
             size = 5)

summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text() + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() +
  geom_label(data = subset(summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))), 
                          Id == "SOUTH KOREA"), 
               aes(x = w.Deg, y = Eig), 
               color = "darkgreen", 
               size = 5) +
  geom_label(data = subset(summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))), 
                          Id == "ENGLAND"), 
            aes(x = w.Deg, y = Eig), 
            color = "darkgreen", 
            size = 5)
  
write.csv(summ.cen.all %>% data.frame, file="R file/network_measures_all_val.csv",
          row.names=FALSE)
write.csv(ALL.EL.p.all %>% data.frame, file="R file/qc_edges_all_val.csv",
          row.names=FALSE)
write.csv(Node.table.all %>% data.frame, file="R file/qc_nodes_all_val.csv",
          row.names=FALSE)

load(file="R file/ALL.G.p.all_val.RData")
qc_network.all <- ALL.G.p.all %>% 
  ggnet2(size = "degree", label=TRUE, #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) + ggtitle("all")
qc_network.all
ggsave(filename=paste0("R figure/org_network_all_val.png"), 
       plot=qc_network.all)

# Top 100
qc_network.eu <- 
  ALL.EL.total.all %>% 
  # filter(Source %in% eu_country | Target %in% eu_country) %>%
  arrange(desc(weight)) %>% 
  head(100) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size=1.5,
         label.trim=TRUE, node.color=highlight,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")
qc_network.eu
ggsave(filename=paste0("R figure/org_network_eu_val.png"), 
       plot=qc_network.eu)

ALL.EL.total.all %>% 
  # filter(Source %in% eu_country | Target %in% eu_country) %>%
  arrange(desc(weight)) %>% 
  filter(Source %in% c("SOUTH KOREA") | Target %in% c("SOUTH KOREA"))
  filter(Source %in% c("SOUTH KOREA","ENGLAND") | Target %in% c("SOUTH KOREA","ENGLAND"))
  

###########################################################################
### Category Summary 
###########################################################################

quant_inst_ed_eu_fixed_val %>% 
  group_by(qc_category,pubid) %>% 
  summarize(org=length(unique(final_grouped_organization))) %>%
  mutate(org.d = ifelse(org==1,"single.org","double.org")) %>%
  spread(key=org.d,value=org) %>%
  mutate(single.org = if_else(is.na(single.org), 0, single.org),
         double.org = if_else(is.na(double.org), 0, double.org)) %>%
  left_join(quant_inst_ed_eu_fixed_val %>% 
              group_by(qc_category,pubid) %>% 
              summarize(ctr=length(unique(country))) %>%
              mutate(ctr.d = ifelse(ctr==1,"single.ctr","double.ctr")) %>%
              spread(key=ctr.d,value=ctr) %>%
              mutate(single.ctr = if_else(is.na(single.ctr), 0, single.ctr),
                     double.ctr = if_else(is.na(double.ctr), 0, double.ctr))) %>%
  mutate(oi.org=(double.org-single.org)/(double.org+single.org),
         oi.ctr=(double.ctr-single.ctr)/(double.ctr+single.ctr)) %>%
  ungroup %>%
  group_by(qc_category) %>%
  summarize(oi.org=mean(oi.org),oi.ctr=mean(oi.ctr)) %>%
  ggplot(aes(x=oi.org, y=oi.ctr,label=qc_category)) + 
  #geom_point() +
  geom_hline(yintercept=0, col="red", linetype="dashed") + 
  geom_vline(xintercept=0, col="red", linetype="dashed") +
  geom_text(check_overlap = FALSE) + 
  xlab("Organization O-I") +
  scale_x_continuous(limits = c(-1, 1))+
  scale_y_continuous(limits = c(-1, 1)) +
  ylab("Country O-I") + theme_bw()

quant_inst_ed_eu_fixed_val %>% 
  group_by(qc_category,pubid) %>%
  summarize(org=length(unique(final_grouped_organization))) %>% 
  filter(org>=4) %>%
  left_join(quant_inst_ed_eu_fixed_val %>% select(pubid,final_grouped_organization) %>% unique) %>%
  ungroup %>%
  group_by(qc_category) %>%
  summarize(org=mean(org)) %>% data.frame
  
quant_inst_ed_eu_fixed_val %>% 
  select(pubid,final_grouped_organization) %>%
  unique

###########################################################################
### Organization-level analysis
###########################################################################

org.country.sum <- quant_inst_ed_eu_fixed_val %>% 
  group_by(final_grouped_organization,country) %>% 
  summarize(country.count=length(unique(pubid))) %>% ungroup %>%
  left_join(quant_inst_ed_eu_fixed_val %>% 
              group_by(final_grouped_organization,country) %>% 
              summarize(country.count=length(unique(pubid))) %>% ungroup %>%
              group_by(final_grouped_organization) %>% 
              arrange(final_grouped_organization,desc(country.count)) %>% 
              slice(1) %>% mutate(main.country="main")) %>%
  mutate(main.country=ifelse(main.country=="main","main","others"))

### All
# Non-weight version
w.org.table <- quant_inst_ed_eu_fixed_val %>% 
  group_by(pubid) %>% mutate(count=length(unique(final_grouped_organization))) %>%
  mutate(share=1/count) %>% ungroup %>%
  filter(count!=1) %>% 
  group_by(pubid,final_grouped_organization) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  select(-c("weight"))

# generating ID (1,2,3,4...) by Application ID
org.set <- getanID(w.org.table, id.vars = "pubid")
colnames(org.set)[colnames(org.set)==".id"] <- "compound"
org.set$compound <- as.factor(org.set$compound)

# create CPC matrix: each row shows individual patent's list of CPCs
org.set.w <- spread(org.set, compound, final_grouped_organization)

org.ALL.EL.total.all <- getting.edgelist.local(org.set.w)
org.ALL.EL.total.all %<>% dplyr::rename(weight=Weight)

org.ALL.EL.total.all %>% 
  left_join(quant_inst_ed_eu_fixed_val %>% 
              select(final_grouped_organization, country) %>% unique, 
            by=c("Source"="final_grouped_organization")) %>% 
  rename(Source.Country=country) %>%
  left_join(quant_inst_ed_eu_fixed_val %>% 
              select(final_grouped_organization, country) %>% unique, 
            by=c("Target"="final_grouped_organization")) %>%
  rename(Target.Country=country) 

# Organization - country list
org_country_list <- quant_inst_ed_eu_fixed_val %>% 
  group_by(final_grouped_organization,country) %>% 
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub))

# (전체) 기관 간 상위 10개 협력 
org.ALL.EL.total.all %>% arrange(desc(weight)) %>%
  head(10) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
            by=c("Source"="final_grouped_organization")) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
            by=c("Source"="final_grouped_organization")) %>%
  mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
  mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
  select(Source.country,Target.country,weight)

org.ALL.EL.total.all %>% arrange(desc(weight)) %>%
  head(20) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
            by=c("Source"="final_grouped_organization")) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
            by=c("Source"="final_grouped_organization")) %>%
  mutate(col.type = ifelse(Source.country==Target.country,"Internal","External")) %>%
  group_by(col.type) %>% 
  summarize(weight=mean(weight))

org.ALL.G.p.all <- graph.data.frame(org.ALL.EL.total.all, directed=FALSE)
save(org.ALL.G.p.all, file="R file/org.ALL.G.p.all_val.RData")

org.ALL.EL.p.all <-
  data.frame(data.frame(get.edgelist(org.ALL.G.p.all)),
             weight=round(E(org.ALL.G.p.all)$weight, 3))
names(org.ALL.EL.p.all) <- c("Source", "Target", "weight")

org.ALL.EL.p.all <- org.ALL.EL.p.all %>% 
  group_by(Source, Target) %>%
  summarize_at("weight", sum)

org.ID <- sort(unique(c(org.ALL.EL.p.all$Source, org.ALL.EL.p.all$Target)))
org.Node.table.all <- data.frame(Id=org.ID, Label=org.ID, tech=substr(org.ID, 0,1))

# Network analysis
org.summ.cen.all <- get.centrality(org.ALL.G.p.all) %>% 
  mutate(qc_category = "all")

org.summ.cen.all <- org.summ.cen.all %>%
  left_join(org_country_list %>%  
              select(-c("pub")) %>% unique,
            by=c("Id"="final_grouped_organization"))
save(org.summ.cen.all, file="R file/org.summ.cen.all_val.RData")

### Weight version
i<-1
org.w.collabo.table <- 0
for (i in 1:length(unique(w.org.table$pubid))){ # 6138
  temp <- w.org.table[w.org.table$pubid==unique(w.org.table$pubid)[[i]],]
  temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$final_grouped_organization, 2)))
  # temp.1 %<>% left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X1"="Region")) %>%
  #   left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X2"="Region"))
  temp.1 %<>% mutate(share=1/nrow(temp.1))
  names(temp.1) <- c("APPLN_ID","Source","Target","share")
  
  org.w.collabo.table <- rbind(org.w.collabo.table,temp.1)
  print(i)
}
org.w.collabo.table <- org.w.collabo.table[2:nrow(org.w.collabo.table),]
org.w.collabo.table <- org.w.collabo.table %>% 
  group_by(Source,Target) %>%
  dplyr::summarise(weight=sum(share))
save(org.w.collabo.table, file="R file/org.w.collabo.table.RData")

org.ALL.G.p.all.weight <- graph.data.frame(org.w.collabo.table, directed=FALSE)
org.summ.cen.all.weight <- get.centrality(org.ALL.G.p.all.weight) %>% 
  mutate(qc_category = "all")
save(org.summ.cen.all.weight, file="R file/org.summ.cen.all.weight.RData")

# (기관 네트워크 - 전체) 가중연결중심성 vs. 매개중심성
org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # filter(country %in% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point() +
  # geom_text(check_overlap = TRUE) + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# (기관 네트워크 - 유럽) 가중연결중심성 vs. 매개중심성
org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # filter(country %in% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# w.Deg vs. BTW
`%ni%` <- Negate(`%in%`)
org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(country %ni% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point() +
  # geom_text(check_overlap = TRUE,color="blue") + 
  # geom_text(color="blue") +
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw() 

# (기관 네트워크 - 비유럽) 가중연결중심성 vs. 매개중심성
org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(country %ni% eu_country) %>% 
  mutate(label.kr = ifelse(country=="SOUTH KOREA",Id,NA)) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=label.kr)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="blue") + 
  # geom_text(color="blue") +
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw() 

# w.Deg vs. EIG
org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  # filter(country %in% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point() + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %in% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %ni% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="blue") + 
  # geom_text(check_overlap = FALSE,color="blue") + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

org.summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %ni% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_text(check_overlap = TRUE,color="blue") + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

write.csv(summ.cen.all %>% data.frame, file="R file/network_measures_all_val.csv",
          row.names=FALSE)
write.csv(ALL.EL.p.all %>% data.frame, file="R file/qc_edges_all_val.csv",
          row.names=FALSE)
write.csv(Node.table.all %>% data.frame, file="R file/qc_nodes_all_val.csv",
          row.names=FALSE)

load(file="R file/ALL.G.p.all_val.RData")
org.qc_network.all <- 
  org.ALL.EL.total.all %>% arrange(desc(weight)) %>% head(100) %>%
  ggnet2(size = "degree", label=FALSE, #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) + ggtitle("all")
org.qc_network.all
ggsave(filename=paste0("R figure/org_network_all_val.png"), 
       plot=qc_network.all)

#### 유럽 - 비유럽 비교
node_info <- org.country.sum %>%
  filter(main.country == "main") %>%
  select(final_grouped_organization, country) %>% unique %>%
  mutate(color = ifelse(country %in% eu_country, "blue", "red"))

# 데이터 결합 및 필터링
graph_data <- org.ALL.EL.total.all %>% 
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Source" = "final_grouped_organization")) %>% 
  rename(source.country = country, source.color = color) %>%
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Target" = "final_grouped_organization")) %>% 
  rename(target.country = country, target.color = color) %>%
  filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(500)

# 그래프 데이터프레임 생성
net <- graph.data.frame(graph_data, directed = FALSE)

# 노드 정보 추가 (source.color를 사용)
V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
                       node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
                       "grey")

# 그래프 시각화
ggnet2(net, size = "degree", color = "color", label = FALSE, label.size = 1.5,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE)

# Top 100
org.qc_network.eu <- 
  org.ALL.EL.total.all %>% 
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(final_grouped_organization, country) %>% unique,
            by=c("Source"="final_grouped_organization")) %>% rename(source.country=country) %>%
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(final_grouped_organization, country) %>% unique,
            by=c("Target"="final_grouped_organization")) %>% rename(target.country=country) %>%
  filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(50) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size =1.5,
         label.trim=TRUE,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")
org.qc_network.eu
ggsave(filename=paste0("R figure/org_network_eu_val.png"), 
       plot=qc_network.eu)

org.ALL.EL.total.all %>% 
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(final_grouped_organization, country) %>% unique,
            by=c("Source"="final_grouped_organization")) %>% rename(source.country=country) %>%
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(final_grouped_organization, country) %>% unique,
            by=c("Target"="final_grouped_organization")) %>% rename(target.country=country) %>%
  # filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(50) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size =1.5,
         label.trim=TRUE,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")


### 한국-유럽 양자과학기술 협력 네트워크 (상위 100 개)
node_info <- org.country.sum %>%
  filter(main.country == "main") %>%
  select(final_grouped_organization, country) %>% unique %>%
  mutate(color = ifelse(country == "SOUTH KOREA", "red", 
                        ifelse(country %in% eu_country, "blue", "grey")))

graph_data <- org.ALL.EL.total.all %>% 
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Source" = "final_grouped_organization")) %>% 
  rename(source.country = country, source.color = color) %>%
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Target" = "final_grouped_organization")) %>% 
  rename(target.country = country, target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>% head(100)

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
                       node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
                       "grey")

ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 1.5,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) 

### (주요기관 중심) 한국-유럽 양자과학기술 협력 네트워크 (상위 100 개)
node_info <- org.country.sum %>%
  filter(main.country == "main") %>%
  select(final_grouped_organization, country) %>% unique %>%
  mutate(color = ifelse(country == "SOUTH KOREA", "red", 
                        ifelse(country =="ENGLAND", "blue", "grey")))

highlight_source <- org.ALL.EL.total.all %>%
  left_join(node_info %>% select(final_grouped_organization, country), 
            by = c("Source" = "final_grouped_organization")) %>% 
  rename(source.country = country) %>%
  left_join(node_info %>% select(final_grouped_organization, country), 
            by = c("Target" = "final_grouped_organization")) %>% 
  rename(target.country = country) %>%
  filter(Source %in% c("CNRS", "CNR", "MAX PLANCK SOCIETY") & target.country == "SOUTH KOREA") %>%
  select(final_grouped_organization = Target) %>%
  unique() %>%
  mutate(color = "green")

highlight_target <- org.ALL.EL.total.all %>%
  left_join(node_info %>% select(final_grouped_organization, country), 
            by = c("Source" = "final_grouped_organization")) %>% 
  rename(source.country = country) %>%
  left_join(node_info %>% select(final_grouped_organization, country), 
            by = c("Target" = "final_grouped_organization")) %>% 
  rename(target.country = country) %>%
  filter(Target %in% c("CNRS", "CNR", "MAX PLANCK SOCIETY") & source.country == "SOUTH KOREA") %>%
  select(final_grouped_organization = Source) %>%
  unique() %>%
  mutate(color = "green")

highlight_orgs <- bind_rows(highlight_source, highlight_target) %>% unique()

node_info <- node_info %>%
  left_join(highlight_orgs, by = "final_grouped_organization", suffix = c("", ".highlight")) %>%
  mutate(color = ifelse(!is.na(color.highlight), color.highlight, color)) %>%
  select(final_grouped_organization, country, color)

graph_data <- org.ALL.EL.total.all %>% 
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Source" = "final_grouped_organization")) %>% 
  rename(source.country = country, source.color = color) %>%
  left_join(node_info %>% select(final_grouped_organization, country, color), 
            by = c("Target" = "final_grouped_organization")) %>% 
  rename(target.country = country, target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>% head(100)

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
                       node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
                       "grey")

ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 1.5,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) 

### Institute - per Quantum Tech

quant_inst_ed_eu_fixed_val %>% 
  filter(final_grouped_organization=='INSTITUTE OF ELECTRONIC MATERIALS TECHNOLOGY')


# (기술분야별) 기관 간 상위 협력
org.summ.cen.topcol <- 0
i<-16
for(i in 1:length(unique(quant_inst_ed_eu_fixed_val$qc_category))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
    filter(qc_category==unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(final_grouped_organization )) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,final_grouped_organization) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  # generating ID (1,2,3,4...) by Application ID
  org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  org.set.temp$compound <- as.factor(org.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  org.set.w.type <- spread(org.set.temp, compound, final_grouped_organization)
  
  org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  # (기술별) 기관 간 상위 3개 협력 
  org.summ.cen.topcol <- 
    rbind(org.summ.cen.topcol,
          org.ALL.EL.total.type %>% arrange(desc(weight)) %>%
            head(3) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="final_grouped_organization")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="final_grouped_organization")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            mutate(qc_category=unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
            select(qc_category,Source.country,Target.country,weight)) 
  print(i)
}
org.summ.cen.topcol <- org.summ.cen.topcol[2:nrow(org.summ.cen.topcol),]
org.summ.cen.topcol %>% arrange(qc_category)

i<-1
org.summ.cen.toprank <- 0
for(i in 1:length(unique(quant_inst_ed_eu_fixed_val$qc_category))){
  # Non-weight version
  # w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
  #   filter(qc_category==unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
  #   group_by(pubid) %>% mutate(count=length(final_grouped_organization )) %>%
  #   mutate(share=1/count) %>% ungroup %>%
  #   group_by(pubid,final_grouped_organization) %>%
  #   dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  #   select(-c("weight"))
  # 
  # # generating ID (1,2,3,4...) by Application ID
  # org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  # colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  # org.set.temp$compound <- as.factor(org.set.temp$compound)
  # 
  # # create CPC matrix: each row shows individual patent's list of CPCs
  # org.set.w.type <- spread(org.set.temp, compound, final_grouped_organization)
  # 
  # org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  # org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  # 
  # org.ALL.G.p.type <- 
  #   graph.data.frame(org.ALL.EL.total.type, directed=FALSE)
  # 
  # # Network analysis
  # org.summ.cen.type <- get.centrality(org.ALL.G.p.type) %>% 
  #   mutate(qc_category = unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  # 
  # org.summ.cen.type <- org.summ.cen.type %>%
  #   left_join(org_country_list %>%  
  #               select(-c("pub")) %>% unique,
  #             by=c("Id"="final_grouped_organization"))
  
  ### weight version
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category==unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(final_grouped_organization))) %>%  
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>% 
    group_by(pubid,final_grouped_organization) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  org.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.org.table.temp$pubid))){ 
    temp <- w.org.table.temp[w.org.table.temp$pubid==unique(w.org.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$final_grouped_organization, 2)))
    # temp.1 %<>% left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X1"="Region")) %>%
    #   left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X2"="Region"))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    
    org.w.collabo.table.type <- rbind(org.w.collabo.table.type,temp.1)
  }
  org.w.collabo.table.type <- org.w.collabo.table.type[2:nrow(org.w.collabo.table.type),]
  org.w.collabo.table.type <- org.w.collabo.table.type %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  save(org.w.collabo.table.type, 
       file=paste0("R file/or.w.collabo.table.",unique(quant_inst_ed_eu_fixed_val$qc_category)[i],".RData"))
  
  org.ALL.EL.total.type <- graph.data.frame(org.w.collabo.table.type, directed=FALSE)
  org.summ.cen.type <- get.centrality(org.ALL.EL.total.type) %>% 
    mutate(qc_category = unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  save(org.summ.cen.type, 
       file=paste0("R file/org.summ.cen.type.",unique(quant_inst_ed_eu_fixed_val$qc_category)[i],"RData"))
  
  # org.summ.cen.type <- org.summ.cen.type %>%
  #   left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)),
  #             by=c("Id"="author_id_te"))
  
  ###
  org.summ.cen.toprank <-
    rbind(org.summ.cen.toprank,
          org.summ.cen.type %>% arrange(desc(w.Deg)) %>% head(3) %>%
            mutate(Rank=1:n()) %>% mutate(w.Deg=Id) %>%
            select(qc_category, Rank, w.Deg) %>%
            left_join(org.summ.cen.type %>% arrange(desc(Btw)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Btw=Id) %>%
                        select(Rank, Btw)) %>%
            left_join(org.summ.cen.type %>% arrange(desc(Eig)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Eig=Id) %>%
                        select(Rank, Eig)) %>% data.frame)

  # node_info <- org.country.sum %>%
  #   filter(main.country == "main") %>%
  #   select(final_grouped_organization, country) %>% unique %>%
  #   mutate(color = ifelse(country == "SOUTH KOREA", "red", 
  #                         ifelse(country %in% eu_country, "blue", "grey")))
  # 
  # ### ALL
  # graph_data <- org.ALL.EL.total.type %>% 
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Source" = "final_grouped_organization")) %>% 
  #   rename(source.country = country, source.color = color) %>%
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Target" = "final_grouped_organization")) %>% 
  #   rename(target.country = country, target.color = color) %>%
  #   # filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  #   arrange(desc(weight)) %>% head(50)
  # 
  # net <- graph_from_data_frame(d = graph_data, directed = FALSE)
  # 
  # V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
  #                        node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
  #                        "grey")
  # 
  # ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 1.5,
  #        label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  #   guides(size = FALSE) +
  #   ggtitle(unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  # 
  # ### Korea
  # graph_data <- org.ALL.EL.total.type %>% 
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Source" = "final_grouped_organization")) %>% 
  #   rename(source.country = country, source.color = color) %>%
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Target" = "final_grouped_organization")) %>% 
  #   rename(target.country = country, target.color = color) %>%
  #   filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  #   arrange(desc(weight)) 
  # 
  # net <- graph_from_data_frame(d = graph_data, directed = FALSE)
  # 
  # V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
  #                        node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
  #                        "grey")
  # 
  # ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 3,
  #        label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  #   guides(size = FALSE) +
  #   ggtitle(unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  # 
}
org.summ.cen.toprank <- org.summ.cen.toprank[2:nrow(org.summ.cen.toprank),]
org.summ.cen.toprank %>% arrange(qc_category, Rank)

org.summ.cen.toprank %>% arrange(qc_category, Rank) %>%
  write.csv(file="inst_net_top_cen.csv")


###########################################################################
### Researcher-level analysis
###########################################################################

res.country.sum <- quant_author_ed_eu_val %>% 
  group_by(author_id_te,display_name) %>% 
  summarize(pub.count=length(unique(pubid)))

# 

# 양자과학기술 내 논문별 평균 연구자 수
quant_author_ed_eu_val %>% group_by(pubid) %>%
  summarize(count=length(unique(author_id_te))) %>%
  ungroup %>% summarize(avg=mean(count),max=max(count), min=min(count)) 

# 양자과학기술 내 분야별 논문 평균 연구자 수
quant_author_ed_eu_val %>% group_by(qc_category,pubid) %>%
  summarize(count=length(unique(author_id_te))) %>%
  ungroup %>% 
  mutate(type=substr(qc_category,1,3)) %>%
  group_by(type) %>% summarize(count=mean(count)) %>%
  arrange(type) %>% data.frame

quant_inst_ed_eu_fixed_val %>% 
  filter(final_grouped_organization=="TOSHIBA CORPORATION")

#### Fix Korean cases
# Filter by Korean names
quant_inst_ed_eu_fixed_val %>% filter(country=="SOUTH KOREA") %>%
  select(pubid) %>% unique

korea.res <- quant_inst_ed_eu_fixed_val %>% filter(country=="SOUTH KOREA") %>%
  select(pubid) %>% unique %>% 
  left_join(quant_author_ed_eu_val) %>%
  # select(pubid, qc_category, author_id_te, last_name, display_name) %>% unique %>%
  # filter(pubid %in% c(15488267, 35120214, 29517765, 39526291, 40674495, 
  #                     18471226, 20202044, 25795430, 45314759, 36600316))
  filter(last_name %in% c("Kang","Moon","Kim","Lim","Lee","Oh","Song","Chong",
                          "Hong","Shin","Kwon","Park","Jeong","Jang","Cho",
                          "Eom","Chung","Jung","Jeon","Paik","Han",
                          "Cheong","Joo","Jo","Son","Yang","Im","Nha",
                          "Yoon","Sung","Chow","An","Ann","Bae","Cheung",
                          "Choi","Gong","Jee","Jeon","Joo","Ko","Ra")) 
korea.res %>% select(author_id_te) %>% unique %>% nrow

i<-1   
kor.res.org <- 0
for(i in 1:length(unique(korea.res$author_id_te))){
  temp <- korea.res %>% filter(author_id_te==unique(korea.res$author_id_te)[i])
  kor.res.org <- 
    rbind(kor.res.org,
          temp %>% 
            left_join(quant_inst_ed_eu_fixed_val %>% filter(country=="SOUTH KOREA") %>%
                        select(pubid,final_grouped_organization,country) %>% unique))
  print(i)
}
kor.res.org <- kor.res.org[2:nrow(kor.res.org),]
kor.res.org %>% select(author_id_te) %>% unique %>% nrow

# 한국인 연구자
kor.res.per <- quant_author_ed_eu_val %>% 
  filter(last_name %in% c("Kang","Moon","Kim","Lim","Lee","Oh","Song","Chong",
                          "Hong","Shin","Kwon","Park","Jeong","Jang","Cho",
                          "Eom","Chung","Jung","Jeon","Paik","Han",
                          "Cheong","Joo","Jo","Son","Yang","Im","Nha",
                          "Yoon","Sung","Chow","An","Ann","Bae","Cheung",
                          "Choi","Gong","Jee","Jeon","Joo","Ko","Ra"))

quant_author_ed_eu_val %>% filter(author_id_te==43973943) %>%
  select(pubid) %>% head(2) %>%
  inner_join(quant_pub_ed_eu_val)

kor.res.per <- kor.res.per %>%
  filter(display_name %in% c("Paik, Hanhee","Kim, Na Young","Lee, Minjoo Larry","Jung, Daehwan", "Choi, D. -Y.",
                                     "Jung, Kyubong","Hong, Sungkun","Choi, Soonwon","Lee, Changhyoup","Lee, Yoo Seung",
                                     "Yang, Chih Hwan","Kim, P.","Shin, Y. J.","Jo, N. H.","Cho, S. U.","Kim, David",
                                     "Kim, I","Lee, K. C.","Lee, Chang-min","Lee, C. -M.","Kim, Wonjong",
                                     "Chung, T. H.","Kim, Myungshik","Oh, C-H","Hong, Sungkun","Park, Annie Jihyun",
                                     "Kim, Isaac H.","Sung, Kevin J.","Lee, CF","Lee, JW","Oh, C. H.","Lee, J. P.",
                                     "Kim, Sungwon","Lee, Hyung-Jin","Jeon, Charles","Kim, Hyochul","Lee, J. P.",
                                     "Lee, Joon Sue","Jung, Jason","Kim, Kihwan","Lee, Chang-Min","Park, Kimin",
                                     "Kim, M","Son, W","Cho, YongJin","Choi, S.","Lee, ES","Lee, C","Lee, DKK",
                                     "Joo, Jaewoo","Lee, P. J.","Kim, D. -H.","Han, Y. -J.","Lee, D. K. K.",
                                     "Lee, Jae Hoon","Kim, Na Young","Cho, Jaeyoon","Kim, N. Y.","Lee, Mark D.",
                                     "Choi, Jae-yoon","Moon, Geol","Kim, Timur","Oh, Seongshik","Song, DD","Oh, CH",
                                     "Lim, JY","Han, Kyu Young","Choi, Iris","Oh, Jungmi","Choi, I.","Lee, Antony R.",
                                     "Choi, Iris","Kim, Sejeong","Cho, J.","Park, Jae I.","Cho, Y. -W.","Park, Kimin",
                                     "Choi, Duk-Yong","Park, H.","Hong, Sungkun","Hong, Jiyun","Jeon, Sukyung",
                                     "Kim, Janice J.","Kim, Youngwan","Lee, Moonjoo","Shin, D. K."))
kor.res.per %>% #filter(is.na(check==TRUE)) %>%
  select(author_id_te, display_name) %>% unique %>% nrow

kor.reg.all <- 
  rbind(kor.res.org %>% select(author_id_te, display_name) %>% unique, 
        kor.res.per %>% select(author_id_te, display_name) %>% unique) %>% unique

kor.reg.all <- kor.reg.all %>%
  inner_join(quant_author_ed_eu_val)

# 상위 한국-유럽 협력 한국인 연구자
kor.reg.all %>% 
  inner_join(res.inst.sum) %>%
  group_by(author_id_te, display_name, final_grouped_organization) %>%
  summarize(count=length(unique(pubid))) %>%
  arrange(desc(count)) %>% data.frame %>% head(10)

quant_author_ed_eu_val %>% filter(author_id_te==18148647) %>%
  # select(pubid) %>% unique %>% nrow
  select(pubid) %>% head(2) %>%
  # inner_join(quant_pub_ed_eu_val)
  inner_join(quant_inst_ed_eu_fixed_val)

# quant_inst_ed_eu_fixed_val %>% 
#   filter(pubid== 36600316)
# quant_author_ed_eu_val %>% 
#   filter(pubid== 29517765)
# quant_pub_ed_eu_val %>% 
#   filter(pubid== 36600316)
# 
# aa <-  quant_inst_ed_eu_fixed_val %>% filter(country=="SOUTH KOREA") %>%
#   select(pubid) %>% unique
# aa$pubid[aa$pubid %ni% bb$pubid]

# Search pub list
quant_author_ed_eu_val %>% filter(author_id_te ==22162555) %>%
  select(pubid) %>% left_join(quant_inst_ed_eu_fixed_val)

quant_author_ed_eu_val %>% filter(display_name =='Zwiller, V') %>%
  select(pubid) %>% left_join(quant_inst_ed_eu_fixed_val)
# Search publication
quant_pub_ed_eu_val %>% filter(pubid==8058209)

quant_pub_ed_eu_val %>% filter(pubid==9838848)

##
res.inst.sum <- quant_author_ed_eu_val %>% 
  select(pubid,author_id_te,display_name) %>% unique %>% 
  left_join(quant_inst_ed_eu_fixed_val %>% 
              select(pubid,final_grouped_organization,country) %>% unique) %>% 
  group_by(author_id_te,display_name,final_grouped_organization) %>%
  summarize(inst.count=length(unique(pubid))) %>% 
  # arrange(desc(inst.count))
  ungroup %>%
  group_by(author_id_te,display_name) %>%
  arrange(author_id_te,display_name,desc(inst.count)) %>% 
  slice(1) %>% mutate(main.inst="main") %>% 
  left_join(org.country.sum %>% filter(main.country=="main"))

for(i in kor.res.org$author_id_te){
  res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te==i] <-
    kor.res.org$final_grouped_organization[kor.res.org$author_id_te==i]
  res.inst.sum$country[res.inst.sum$author_id_te==i] <-
    kor.res.org$country[kor.res.org$author_id_te==i]
  print(i)
}

res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 40410245] <-"WEIZMANN INSTITUTE OF SCIENCE"
res.inst.sum$country[res.inst.sum$author_id_te== 40410245] <- "ISRAEL"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42356527] <-"RIKEN"
res.inst.sum$country[res.inst.sum$author_id_te== 42356527] <- "JAPAN"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42722758] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 44053414] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 32122829] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 32122829] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10292858] <-"UNIVERSITY OF WURZBURG"
res.inst.sum$country[res.inst.sum$author_id_te== 10292858] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 5161320] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 5161320] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7451861] <-"UNIVERSITY OF SYDNEY"
res.inst.sum$country[res.inst.sum$author_id_te== 7451861] <- "AUSTRALIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13675265] <-"UNIVERSITY OF BIRMINGHAM"
res.inst.sum$country[res.inst.sum$author_id_te== 13675265] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 17083679] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 17083679] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 44931475] <-"KIST"
res.inst.sum$country[res.inst.sum$author_id_te== 44931475] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 38890535] <-"SEOUL NATIONAL UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 38890535] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 32628187] <-"KAIST"
res.inst.sum$country[res.inst.sum$author_id_te== 32628187] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42356527] <-"POSTECH"
res.inst.sum$country[res.inst.sum$author_id_te== 42356527] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13675265] <-"APCTP"
res.inst.sum$country[res.inst.sum$author_id_te== 13675265] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 45314759] <-"KIAS"
res.inst.sum$country[res.inst.sum$author_id_te== 45314759] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 3769844] <-"HANYANG UNIVERSITY OF ERICA"
res.inst.sum$country[res.inst.sum$author_id_te== 3769844] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 5945201] <-"UNIVERSITY OF AQUILA"
res.inst.sum$country[res.inst.sum$author_id_te== 5945201] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 24140988] <-"SOUTHWEST JIAOTONG UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 24140988] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 30171606] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 30171606] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4162759] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 4162759] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 27298014] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 27298014] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 25682258] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 25682258] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 33713927] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 33713927] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 8215126] <-"ISI"
res.inst.sum$country[res.inst.sum$author_id_te== 8215126] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 33817389] <-"ISI"
res.inst.sum$country[res.inst.sum$author_id_te== 33817389] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 44801020] <-"ISI"
res.inst.sum$country[res.inst.sum$author_id_te== 44801020] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 3668055] <-"UNIVERSITY OF PORTO"
res.inst.sum$country[res.inst.sum$author_id_te== 3668055] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1192256] <-"IBM"
res.inst.sum$country[res.inst.sum$author_id_te== 1192256] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 6005084] <-"IBM"
res.inst.sum$country[res.inst.sum$author_id_te== 6005084] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10488493] <-"IBM RES ZURICH"
res.inst.sum$country[res.inst.sum$author_id_te== 10488493] <- "SWITZERLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18005109] <-"IBM"
res.inst.sum$country[res.inst.sum$author_id_te== 18005109] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 449667] <-"IST NAZL FIS NUCL"
res.inst.sum$country[res.inst.sum$author_id_te== 449667] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 21711152] <-"AUTONOMOUS UNIVERSITY OF BARCELONA"
res.inst.sum$country[res.inst.sum$author_id_te== 21711152] <- "SPAIN"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1921278] <-"TOKYO UNIVERSITY OF SCIENCE"
res.inst.sum$country[res.inst.sum$author_id_te== 1921278] <- "JAPAN"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 29281749] <-"TOKYO UNIVERSITY OF SCIENCE"
res.inst.sum$country[res.inst.sum$author_id_te== 29281749] <- "JAPAN"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10152908] <-"MCMASTER UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 10152908] <- "CANADA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 2171970] <-"MCMASTER UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 2171970] <- "CANADA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 25682258] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 25682258] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 27298014] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 27298014] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 27319478] <-"MATH INSTITUTE"
res.inst.sum$country[res.inst.sum$author_id_te== 27319478] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 22066292] <-"UNIVERSITY OF NEW S WALES"
res.inst.sum$country[res.inst.sum$author_id_te== 22066292] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 27469495] <-"UNIVERSITY OF NEW S WALES"
res.inst.sum$country[res.inst.sum$author_id_te== 27469495] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4713178] <-"UNIVERSITY OF COPENHAGEN"
res.inst.sum$country[res.inst.sum$author_id_te== 4713178] <- "DENMARK"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 37549901] <-"UNIVERSITY OF COPENHAGEN"
res.inst.sum$country[res.inst.sum$author_id_te== 37549901] <- "DENMARK"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 24140988] <-"SOUTHWEST JIAOTONG UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 24140988] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42476787] <-"SOUTHWEST JIAOTONG UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 42476787] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 27986284] <-"SAPIENZA UNIVERSITY ROME"
res.inst.sum$country[res.inst.sum$author_id_te== 27986284] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35851484] <-"INO CNR"
res.inst.sum$country[res.inst.sum$author_id_te== 35851484] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4252171] <-"MAX PLANCK INSTITUTE QUANTEM OPT"
res.inst.sum$country[res.inst.sum$author_id_te== 4252171] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 25078323] <-"MAX PLANCK INSTITUTE QUANTEM OPT"
res.inst.sum$country[res.inst.sum$author_id_te== 25078323] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42722705] <-"MAX PLANCK INSTITUTE QUANTEM OPT"
res.inst.sum$country[res.inst.sum$author_id_te== 42722705] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 40634463] <-"UNIVERSITY OF VIENNA"
res.inst.sum$country[res.inst.sum$author_id_te== 40634463] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 30171606] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 30171606] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 45058553] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 45058553] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 46229781] <-"UNIVERSITY OF GENEVA"
res.inst.sum$country[res.inst.sum$author_id_te== 46229781] <- "SWITZERLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 40634463] <-"UNIVERSITY OF VIENNA"
res.inst.sum$country[res.inst.sum$author_id_te== 40634463] <- "SWITZERLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 11918848] <-"TECHNOLOGY UNIVERSITY OF BERLIN"
res.inst.sum$country[res.inst.sum$author_id_te== 11918848] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18854946] <-"TECHNOLOGY UNIVERSITY OF BERLIN"
res.inst.sum$country[res.inst.sum$author_id_te== 18854946] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 33089785] <-"TECHNOLOGY UNIVERSITY OF BERLIN"
res.inst.sum$country[res.inst.sum$author_id_te== 33089785] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 33661426] <-"TECHNOLOGY UNIVERSITY OF BERLIN"
res.inst.sum$country[res.inst.sum$author_id_te== 33661426] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 196381] <-"UNIVERSITY OF HANNOVER"
res.inst.sum$country[res.inst.sum$author_id_te== 196381] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1072245] <-"UNIVERSITY OF HANNOVER"
res.inst.sum$country[res.inst.sum$author_id_te== 1072245] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7401341] <-"BNM"
res.inst.sum$country[res.inst.sum$author_id_te== 7401341] <- "FRANCE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35309868] <-"BNM"
res.inst.sum$country[res.inst.sum$author_id_te== 35309868] <- "FRANCE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 22128833] <-"BNM"
res.inst.sum$country[res.inst.sum$author_id_te== 22128833] <- "FRANCE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 34854315] <-"BNM"
res.inst.sum$country[res.inst.sum$author_id_te== 34854315] <- "FRANCE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7401341] <-"BNM"
res.inst.sum$country[res.inst.sum$author_id_te== 7401341] <- "FRNACE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13541498] <-"CORNELL UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 13541498] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18213354] <-"CORNELL UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 18213354] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13571603] <-"CORNELL UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 13571603] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 16337512] <-"STANFORD UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 16337512] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18213354] <-"OCTEVUE"
res.inst.sum$country[res.inst.sum$author_id_te== 18213354] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 19544598] <-"LIGO LIVINGSTON OBSERV"
res.inst.sum$country[res.inst.sum$author_id_te== 19544598] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 3005571] <-"CNRS"
res.inst.sum$country[res.inst.sum$author_id_te== 3005571] <- "FRANCE"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13278982] <-"IMPERIAL COLLEGE LONDON"
res.inst.sum$country[res.inst.sum$author_id_te== 13278982] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7004579] <-"MAX PLANCK SOCIETY"
res.inst.sum$country[res.inst.sum$author_id_te== 7004579] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 26586808] <-"UNIVERSITY OF WESTERN AUSTRALIA"
res.inst.sum$country[res.inst.sum$author_id_te== 26586808] <- "AUSTRALIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 36200514] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 36200514] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 36684500] <-"TOSHIBA RES EUROPE LTD"
res.inst.sum$country[res.inst.sum$author_id_te== 36684500] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10211984] <-"TOSHIBA RES EUROPE LTD"
res.inst.sum$country[res.inst.sum$author_id_te== 10211984] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 41029492] <-"UNIVERSITY OF LEEDS"
res.inst.sum$country[res.inst.sum$author_id_te== 41029492] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1055897] <-"RIKEN"
res.inst.sum$country[res.inst.sum$author_id_te== 1055897] <- "JAPAN"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 37214870] <-"MAX PLANCK INSTITUTE QUANTEM OPT"
res.inst.sum$country[res.inst.sum$author_id_te== 37214870] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 40736455] <-"UNIVERSITY OF CALIFORNIA BERKELEY"
res.inst.sum$country[res.inst.sum$author_id_te== 40736455] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 15541436] <-"HERIOT WATT UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 15541436] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35427578] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 35427578] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4744175] <-"MAX PLANCK INSTITUTE NUCL PHYS"
res.inst.sum$country[res.inst.sum$author_id_te== 4744175] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 41164510] <-"UNIVERSITY OF NEW S WALES"
res.inst.sum$country[res.inst.sum$author_id_te== 41164510] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4252205] <-"JOHANNES GUTENBERG UNIVERSITY OF MAINZ"
res.inst.sum$country[res.inst.sum$author_id_te== 4252205] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4252208] <-"JOHANNES GUTENBERG UNIVERSITY OF MAINZ"
res.inst.sum$country[res.inst.sum$author_id_te== 4252208] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4252211] <-"JOHANNES GUTENBERG UNIVERSITY OF MAINZ"
res.inst.sum$country[res.inst.sum$author_id_te== 4252211] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 33463641] <-"CNR"
res.inst.sum$country[res.inst.sum$author_id_te== 33463641] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 3553539] <-"UNIVERSITY OF MONS"
res.inst.sum$country[res.inst.sum$author_id_te== 3553539] <- "BELGIUM"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 17929117] <-"LEIDEN UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 17929117] <- "NETHERLANDS"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 5965296] <-"NANJING TECHNOLOGY UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 5965296] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1128103] <-"UNIVERSITY OF CALGARY"
res.inst.sum$country[res.inst.sum$author_id_te== 1128103] <- "CANADA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35510417] <-"UNIVERSITY OF WURZBURG"
res.inst.sum$country[res.inst.sum$author_id_te== 35510417] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 23488049] <-"MAX PLANCK SOCIETY"
res.inst.sum$country[res.inst.sum$author_id_te== 23488049] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 19967308] <-"IMPERIAL COLLEGE LONDON"
res.inst.sum$country[res.inst.sum$author_id_te== 19967308] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 19918437] <-"KIAS"
res.inst.sum$country[res.inst.sum$author_id_te== 19918437] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18537088] <-"KIAS"
res.inst.sum$country[res.inst.sum$author_id_te== 18537088] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 19918437] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 19918437] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 19299528] <-"UNIVERSITY OF CAMBRIDGE"
res.inst.sum$country[res.inst.sum$author_id_te== 19299528] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7150876] <-"TOSHIBA RES EUROPE LTD"
res.inst.sum$country[res.inst.sum$author_id_te== 7150876] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 7163285] <-"UNIVERSITY OF BONN"
res.inst.sum$country[res.inst.sum$author_id_te== 7163285] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 44017488] <-"UNIVERSITY OF SCIENCE  TECHNOL CHINA"
res.inst.sum$country[res.inst.sum$author_id_te== 44017488] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 8544110] <-"UNIVERSITY OF SCIENCE  TECHNOL CHINA"
res.inst.sum$country[res.inst.sum$author_id_te== 8544110] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 13596987] <-"GOOGLE QUANTUM"
res.inst.sum$country[res.inst.sum$author_id_te== 13596987] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 2734791] <-"GOOGLE QUANTUM"
res.inst.sum$country[res.inst.sum$author_id_te== 2734791] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35439623] <-"UNIVERSITY OF HEIDELBERG"
res.inst.sum$country[res.inst.sum$author_id_te== 35439623] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 12364560] <-"UNIVERSITY OF MUNICH"
res.inst.sum$country[res.inst.sum$author_id_te== 12364560] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42531463] <-"UNIVERSITY OF MUNICH"
res.inst.sum$country[res.inst.sum$author_id_te== 42531463] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18213354] <-"CORNELL UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 18213354] <- "USA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 20014392] <-"KISTI"
res.inst.sum$country[res.inst.sum$author_id_te== 20014392] <- "SOUTH KOREA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 26409800] <-"CNR"
res.inst.sum$country[res.inst.sum$author_id_te== 26409800] <- "ITALY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 45058566] <-"UNIVERSITY OF VIENNA"
res.inst.sum$country[res.inst.sum$author_id_te== 45058566] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 42476796] <-"DUBLIN CITY UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 42476796] <- "IRELAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10691401] <-"IMPERIAL COLLEGE LONDON"
res.inst.sum$country[res.inst.sum$author_id_te== 10691401] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 14655146] <-"UNIVERSITY OF SOUTHAMPTON"
res.inst.sum$country[res.inst.sum$author_id_te== 14655146] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4774165] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 4774165] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 18253169] <-"UNIVERSITY OF SCIENCE  TECHNOL CHINA"
res.inst.sum$country[res.inst.sum$author_id_te== 18253169] <- "PEOPLES R CHINA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 31125014] <-"UNIVERSITY OF MUNSTER"
res.inst.sum$country[res.inst.sum$author_id_te== 31125014] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 34914189] <-"TECHNION ISRAEL INSTITUTE TECHNOL"
res.inst.sum$country[res.inst.sum$author_id_te== 34914189] <- "ISRAEL"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 5095103] <-"UNIVERSITY OF BASEL"
res.inst.sum$country[res.inst.sum$author_id_te== 5095103] <- "SWITZERLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 5095101] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 5095101] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35427578] <-"UNIVERSITY OF INNSBRUCK"
res.inst.sum$country[res.inst.sum$author_id_te== 35427578] <- "AUSTRIA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 21302402] <-"HERIOT WATT UNIVERSITY"
res.inst.sum$country[res.inst.sum$author_id_te== 21302402] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 35675078] <-"UNIVERSITY OF KARLSRUHE"
res.inst.sum$country[res.inst.sum$author_id_te== 35675078] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 1631280] <-"ROYAL HOLLOWAY UNIVERSITY LONDON"
res.inst.sum$country[res.inst.sum$author_id_te== 1631280] <- "ENGLAND"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 41270888] <-"KIRCHHOFF INSTITUTE PHYS"
res.inst.sum$country[res.inst.sum$author_id_te== 41270888] <- "GERMANY"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 4378514] <-"UNIVERSITY OF BRITISH COLUMBIA"
res.inst.sum$country[res.inst.sum$author_id_te== 4378514] <- "CANADA"
res.inst.sum$final_grouped_organization[res.inst.sum$author_id_te== 10148701] <-"ECOLE POLYTECH FED LAUSANNE"
res.inst.sum$country[res.inst.sum$author_id_te== 10148701] <- "FRANCE"

save(res.inst.sum, file="R file/res.inst.sum.RData")

quant_author_ed_eu_val$qc_category %>% table

quant_author_ed_eu_val %>% 
  group_by(qc_category, author_id_te, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  inner_join(res.inst.sum) %>% 
  slice(1) %>% data.frame

# (유럽) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val %>% 
  group_by(qc_category, author_id_te, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  inner_join(res.inst.sum) %>% 
  filter(country %in% eu_country) %>%
  slice(1) %>% data.frame

# (비유럽) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val %>% 
  group_by(qc_category, author_id_te, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  inner_join(res.inst.sum) %>% 
  filter(country %ni% eu_country) %>%
  slice(1) %>% data.frame

res.inst.sum %>% filter(country=="SOUTH KOREA") %>% 
  select(author_id_te) %>% unique %>% nrow

# (전체) 연구자 간 상위 10개 협력
quant_author_ed_eu_val %>% 
  group_by(qc_category, author_id_te, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  inner_join(res.inst.sum) %>% 
  filter(country %in% eu_country) %>%
  slice(1) %>% data.frame

##########################################
### All 
w.res.table <- quant_author_ed_eu_val %>% 
  group_by(pubid) %>% mutate(count=length(author_id_te)) %>%
  mutate(share=1/count) %>% ungroup %>%
  group_by(pubid,author_id_te) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  filter(weight!=1) %>%
  select(-c("weight")) 

# generating ID (1,2,3,4...) by Application ID
res.set <- getanID(w.res.table, id.vars = "pubid")
colnames(res.set)[colnames(res.set)==".id"] <- "compound"
res.set$compound <- as.factor(res.set$compound)

# create CPC matrix: each row shows individual patent's list of CPCs
res.set.w <- spread(res.set, compound, author_id_te)

res.ALL.EL.total.all <- getting.edgelist.local(res.set.w)
res.ALL.EL.total.all %<>% dplyr::rename(weight=Weight)

top.res.list <- res.ALL.EL.total.all %>% arrange(desc(weight)) %>% 
  left_join(quant_author_ed_eu_val %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, display_name) %>% unique, 
            by=c("Source"="author_id_te")) %>% 
  rename(Source_display_name = display_name) %>%
  left_join(quant_author_ed_eu_val %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, display_name) %>% unique, 
            by=c("Target"="author_id_te")) %>% 
  rename(Target_display_name = display_name) %>%
  head(10) %>% 
  left_join(res.inst.sum  %>% rename(Source.country=country, Source.inst=final_grouped_organization) %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, Source.inst,Source.country),
            by=c("Source"="author_id_te")) %>%
  left_join(res.inst.sum  %>% rename(Target.country=country, Target.inst=final_grouped_organization) %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, Target.inst,Target.country),
            by=c("Target"="author_id_te")) %>%
  mutate(Source.inst = paste0(Source_display_name," (",Source.inst,")")) %>%
  mutate(Target.inst = paste0(Target_display_name," (",Target.inst,")")) 
top.res.list %>%
  select(Source, Target, Source.inst, Target.inst, weight)
top.res.list %>%
  select(Source, Target, Source_display_name, Target_display_name, weight)

quant_author_ed_eu_val %>% 
  filter(author_id_te=="10211984" | author_id_te=="36684500")
quant_inst_ed_eu_fixed_val %>% 
  filter(pubid==15274399)

### non-Weight version  
res.ALL.G.p.all <- graph.data.frame(res.ALL.EL.total.all, directed=FALSE)
save(res.ALL.G.p.all, file="R file/res.ALL.G.p.all_val.RData")

res.ALL.EL.p.all <- data.frame(get.edgelist(res.ALL.G.p.all),
                               weight=round(E(res.ALL.G.p.all)$weight, 3))
names(res.ALL.EL.p.all) <- c("Source", "Target", "weight")

res.ALL.EL.p.all <- res.ALL.EL.p.all %>% 
  group_by(Source, Target) %>%
  summarize_at("weight", sum)
save(res.ALL.EL.p.all, file="R file/res.ALL.EL.p.all.RData")

res.ID <- sort(unique(c(res.ALL.EL.p.all$Source, res.ALL.EL.p.all$Target)))
res.Node.table.all <- data.frame(Id=res.ID, Label=res.ID, tech=substr(res.ID, 0,1))

# Network analysis
res.summ.cen.all <- get.centrality(res.ALL.G.p.all) %>% 
  mutate(qc_category = "all")
save(res.summ.cen.all, file="R file/res.summ.cen.all_val.RData")

### Weight version
i<-1
res.w.collabo.table <- 0
for (i in 1:length(unique(w.res.table$pubid))){ # 6138
  temp <- w.res.table[w.res.table$pubid==unique(w.res.table$pubid)[[i]],]
  temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te, 2)))
  # temp.1 %<>% left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X1"="Region")) %>%
  #   left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X2"="Region"))
  temp.1 %<>% mutate(share=1/nrow(temp.1))
  names(temp.1) <- c("APPLN_ID","Source","Target","share")
  
  res.w.collabo.table <- rbind(res.w.collabo.table,temp.1)
  print(i)
}
res.w.collabo.table <- res.w.collabo.table[2:nrow(res.w.collabo.table),]
res.w.collabo.table <- res.w.collabo.table %>% 
  group_by(Source,Target) %>%
  dplyr::summarise(weight=sum(share))
save(res.w.collabo.table, file="R file/res.w.collabo.table.RData")

res.ALL.G.p.all.weight <- graph.data.frame(res.w.collabo.table, directed=FALSE)
res.summ.cen.all.weight <- get.centrality(res.ALL.G.p.all.weight) %>% 
  mutate(qc_category = "all")
save(res.summ.cen.all.weight, file="R file/res.summ.cen.all.weight.RData")

###
# 한-유럽 연구자 간 상위 협력
res.ALL.EL.p.all %>%
# res.w.collabo.table %>%
  left_join(res.inst.sum %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, display_name, final_grouped_organization) %>% unique, 
            by=c("Source"="author_id_te")) %>% 
  rename(Source_display_name = display_name, Source.inst=final_grouped_organization) %>%
  left_join(res.inst.sum %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, display_name, final_grouped_organization) %>% unique, 
            by=c("Target"="author_id_te")) %>% 
  rename(Target_display_name = display_name, Target.inst=final_grouped_organization) %>%
  left_join(kor.reg.all %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te) %>% unique %>% mutate(Source_kor="kor"),
            by=c("Source"="author_id_te")) %>%
  left_join(kor.reg.all %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te) %>% unique %>% mutate(Target_kor="kor"),
            by=c("Target"="author_id_te")) %>%
  mutate(Source.inst = paste0(Source_display_name," (",Source.inst,")")) %>%
  mutate(Target.inst = paste0(Target_display_name," (",Target.inst,")")) %>%
  filter(is.na(Source_kor)==FALSE | is.na(Target_kor)==FALSE) %>%
  arrange(desc(weight)) %>% data.frame %>% 
  head(10)
  
# 한-유럽 연구자 간 상위 중심성 지수별 연구자 목록
res.summ.cen.all.weight %>%
# res.summ.cen.all %>%
  left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te,display_name,final_grouped_organization,country) %>% unique,
            by=c("Id"="author_id_te")) %>%
  left_join(kor.reg.all %>% mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te) %>% unique %>% mutate(kor="kor"),
            by=c("Id"="author_id_te")) %>% 
  mutate(res.inst = paste0(display_name," (",final_grouped_organization,")")) %>%
  arrange(desc(Eig)) %>%
  filter(is.na(kor)==FALSE)
              
# (연구자 네트워크 - 전체) 가중연결중심성 vs. 매개중심성
res.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  left_join(quant_author_ed_eu_val %>% 
              mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te,pubid,display_name,qc_category) %>% unique %>%
              rename(label=qc_category),
            by=c("Id"="author_id_te")) %>%
  # filter(country %in% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=display_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point() +
  # geom_text(check_overlap = TRUE) + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# (연구자 네트워크 - 유럽) 가중연결중심성 vs. 매개중심성
res.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # left_join(quant_author_ed_eu_val %>% 
  #             mutate(author_id_te=as.character(author_id_te)) %>%
  #             select(author_id_te,display_name) %>% unique,
  #           by=c("Id"="author_id_te")) %>%
  left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)) %>% 
              ungroup %>% 
              select(author_id_te,display_name,final_grouped_organization,country,main.country),
            by=c("Id"="author_id_te")) %>%
  filter(country %in% eu_country & main.country=="main") %>%# arrange(desc(Btw)) 
  mutate(label.kr = ifelse(country=="SOUTH KOREA",display_name,NA)) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=display_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="black") + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# (연구자 네트워크 - 비유럽) 가중연결중심성 vs. 매개중심성
res.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # left_join(quant_author_ed_eu_val %>% 
  #             mutate(author_id_te=as.character(author_id_te)) %>%
  #             select(author_id_te,pubid,display_name,qc_category) %>% unique %>%
  #             rename(label=qc_category),
  #           by=c("Id"="author_id_te")) %>%
  left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)) %>% 
              ungroup %>% 
              select(author_id_te,display_name,final_grouped_organization,country,main.country),
            by=c("Id"="author_id_te")) %>%
  filter(country %ni% eu_country & main.country=="main") %>% # arrange(desc(Btw))
  mutate(label.kr = ifelse(country=="SOUTH KOREA",display_name,NA)) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=display_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="blue") + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

### Korea
node_info <- res.inst.sum %>%
  filter(main.country == "main") %>%
  select(final_grouped_organization, country) %>% unique %>%
  mutate(color = ifelse(country == "SOUTH KOREA", "red",
                        ifelse(country %in% eu_country, "blue", "grey")))

graph_data <- res.w.collabo.table %>%
  # res.ALL.EL.p.all %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te, display_name, country, color),
            by = c("Source" = "author_id_te")) %>%
  rename(source.res = display_name, source.country = country, 
         source.color = color) %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te, display_name, country, color),
            by = c("Target" = "author_id_te")) %>%
  rename(target.res = display_name, target.country = country, 
         target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight))

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$author_id_te,
                       node_info$color[match(V(net)$name, node_info$author_id_te)],
                       "grey")

ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 3,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) +
  ggtitle("all")



#########
# 한-유럽 연구자 간 상위 협력
sort(unique(quant_author_ed_eu_val$qc_category))
i<-1
res.ALL.EL.total.type.topcol <- 0
for(i in 1:length(unique(quant_author_ed_eu_val$qc_category))){
  w.res.table.temp <- quant_author_ed_eu_val %>% 
    filter(qc_category==unique(quant_author_ed_eu_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te))) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,author_id_te) %>%
    dplyr::summarise(weight=sum(share),pub=1) %>% 
    ungroup #%>% filter(weight!=1) #%>% select(-c("weight")) 

  # generating ID (1,2,3,4...) by Application ID
  res.set.temp <- getanID(w.res.table.temp, id.vars = "pubid")
  colnames(res.set.temp)[colnames(res.set.temp)==".id"] <- "compound"
  res.set.temp$compound <- as.factor(res.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  res.set.w.type <- spread(res.set.temp, compound, author_id_te)
  
  res.ALL.EL.total.type <- getting.edgelist.local(res.set.w.type)
  res.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  res.ALL.EL.total.type.topcol <-
    rbind(res.ALL.EL.total.type.topcol,
          res.ALL.EL.total.type %>% arrange(desc(weight)) %>% 
            left_join(quant_author_ed_eu_val %>% 
                        mutate(author_id_te=as.character(author_id_te)) %>%
                        select(author_id_te, display_name) %>% unique, 
                      by=c("Source"="author_id_te")) %>% 
            rename(Source_display_name = display_name) %>%
            left_join(quant_author_ed_eu_val %>% 
                        mutate(author_id_te=as.character(author_id_te)) %>%
                        select(author_id_te, display_name) %>% unique, 
                      by=c("Target"="author_id_te")) %>% 
            rename(Target_display_name = display_name) %>%
            head(5) %>% 
            left_join(res.inst.sum %>% rename(Source.country=country, Source.inst=final_grouped_organization) %>% 
                        mutate(author_id_te=as.character(author_id_te)) %>%
                        select(author_id_te, Source.inst,Source.country),
                      by=c("Source"="author_id_te")) %>%
            left_join(res.inst.sum  %>% rename(Target.country=country, Target.inst=final_grouped_organization) %>% 
                        mutate(author_id_te=as.character(author_id_te)) %>%
                        select(author_id_te, Target.inst,Target.country),
                      by=c("Target"="author_id_te")) %>%
            mutate(Source.inst = paste0(Source_display_name," (",Source.inst,")")) %>%
            mutate(Target.inst = paste0(Target_display_name," (",Target.inst,")")) %>%
            mutate(qc_category=unique(quant_author_ed_eu_val$qc_category)[i]) %>%
            select(qc_category,Source.inst, Target.inst, weight, Source.country, Target.country)) 
  print(i)
}
res.ALL.EL.total.type.topcol <- 
  res.ALL.EL.total.type.topcol[2:nrow(res.ALL.EL.total.type.topcol),]

res.ALL.EL.total.type.topcol %>% arrange(qc_category) %>%
  write.csv(file="res_net_top_col.csv")

res.inst.sum %>% filter(author_id_te==42476787)

### Check
quant_inst_ed_eu_fixed_val %>%
  filter(qc_category=="qc112") %>%
  filter(final_grouped_organization=="UNIVERSITY OF CAMBRIDGE") %>% 
  select(pubid,final_grouped_organization) %>% unique %>%
  left_join(quant_pub_ed_eu_val %>% select(pubid, itemtitle) %>% unique)

# Search publication list
search.category <-"qc422"
search.name <- "Bonn, D. A."
search.result <- quant_author_ed_eu_val %>%
  # filter(qc_category==search.category) %>%
  filter(display_name==search.name)
  # filter(pubid==25562146)
  # filter(author_id_te==7063708)
search.result



quant_pub_ed_eu_val %>%
  # filter(qc_category==search.category) %>%
  filter(pubid==search.result$pubid[1])

quant_inst_ed_eu_fixed_val %>%
  # filter(qc_category==search.category) %>%
  filter(pubid==search.result$pubid[1])

quant_inst_ed_eu_fixed_val %>%
  filter(qc_category==search.category) %>%
  select(pubid) %>% unique

quant_author_ed_eu_val %>%
  filter(pubid==search.result$pubid[1])

res.inst.sum %>%
  filter(author_id_te==5945201)

# Check author-institute collaboration difference
quant_inst_ed_eu_fixed_val %>% filter(qc_category=="qc225") %>%
  left_join(quant_author_ed_eu_val %>% filter(qc_category=="qc225")) %>%
  group_by(final_grouped_organization,pubid) %>%
  summarize(author=length(unique(author_id_te))) %>% ungroup %>%
  group_by(final_grouped_organization) %>%
  summarize(author.avg=mean(author)) %>%
  arrange(desc(author.avg)) %>%
  filter(final_grouped_organization=="LUBLIN UNIVERSITY OF TECHNOLOGY")

# 한-유럽 연구자 간 상위 중심성 지수별 연구자 목록
i<-2
res.summ.cen.toprank <- 0
for(i in 1:length(unique(quant_author_ed_eu_val$qc_category))){
  ### non-weight version
  # w.res.table.temp <- quant_author_ed_eu_val %>% 
  #   filter(qc_category==unique(quant_author_ed_eu_val$qc_category)[i]) %>%
  #   group_by(pubid) %>% mutate(count=length(author_id_te)) %>%
  #   mutate(share=1/count) %>% ungroup %>%
  #   group_by(pubid,author_id_te) %>%
  #   dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  #   filter(weight!=1) %>%
  #   select(-c("weight"))
  # 
  # # generating ID (1,2,3,4...) by Application ID
  # res.set.temp <- getanID(w.res.table.temp, id.vars = "pubid")
  # colnames(res.set.temp)[colnames(res.set.temp)==".id"] <- "compound"
  # res.set.temp$compound <- as.factor(res.set.temp$compound)
  # 
  # # create CPC matrix: each row shows individual patent's list of CPCs
  # res.set.w.type <- spread(res.set.temp, compound, author_id_te)
  # 
  # res.ALL.EL.total.type <- getting.edgelist.local(res.set.w.type)
  # res.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  # 
  # res.ALL.G.p.type <- 
  #   graph.data.frame(res.ALL.EL.total.type, directed=FALSE)
  # 
  # # Network analysis
  # res.summ.cen.type <- get.centrality(res.ALL.G.p.type) %>% 
  #   mutate(qc_category =unique(quant_author_ed_eu_val$qc_category)[i])
  # 
  # res.summ.cen.type <- res.summ.cen.type %>%
  #   left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)),
  #             by=c("Id"="author_id_te"))
  
  ### weight version
  w.res.table.temp <- quant_author_ed_eu_val %>% 
    filter(qc_category==unique(quant_author_ed_eu_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te))) %>%
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>%
    group_by(pubid,author_id_te) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    filter(weight!=1) %>%
    select(-c("weight")) 
  
  res.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.res.table.temp$pubid))){ 
    temp <- w.res.table.temp[w.res.table.temp$pubid==unique(w.res.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te, 2)))
    # temp.1 %<>% left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X1"="Region")) %>%
    #   left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X2"="Region"))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    
    res.w.collabo.table.type <- rbind(res.w.collabo.table.type,temp.1)
  }
  res.w.collabo.table.type <- res.w.collabo.table.type[2:nrow(res.w.collabo.table.type),]
  res.w.collabo.table.type <- res.w.collabo.table.type %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  save(res.w.collabo.table.type, 
       file=paste0("R file/res.w.collabo.table.",unique(quant_author_ed_eu_val$qc_category)[i],".RData"))
  
  res.ALL.EL.total.type <- graph.data.frame(res.w.collabo.table.type, directed=FALSE)
  res.summ.cen.type <- get.centrality(res.ALL.EL.total.type) %>% 
    mutate(qc_category = unique(quant_author_ed_eu_val$qc_category)[i])
  save(res.summ.cen.type, 
       file=paste0("R file/res.summ.cen.type.",unique(quant_author_ed_eu_val$qc_category)[i],"RData"))

  res.summ.cen.type <- res.summ.cen.type %>%
    left_join(res.inst.sum %>% mutate(author_id_te=as.character(author_id_te)),
              by=c("Id"="author_id_te"))

  ###
  res.summ.cen.toprank <-
    rbind(res.summ.cen.toprank,
          res.summ.cen.type %>% #filter(country %in% eu_country) %>%
            arrange(desc(w.Deg)) %>% head(5) %>%
            mutate(Rank=1:n()) %>% mutate(w.Deg=display_name, w.Deg.inst=final_grouped_organization) %>%
            mutate(w.Deg.inst.ed = paste0(w.Deg," (",w.Deg.inst,")")) %>%
            select(qc_category, Rank, w.Deg.inst.ed) %>% 
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Btw)) %>% head(5) %>%
                        mutate(Rank=1:n()) %>% mutate(Btw=display_name, Btw.inst=final_grouped_organization) %>%
                        mutate(Btw.inst.ed = paste0(Btw," (",Btw.inst,")")) %>%
                        select(Rank, Btw.inst.ed)) %>%
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Eig)) %>% head(5) %>%
                        mutate(Rank=1:n()) %>% mutate(Eig=display_name, Eig.inst=final_grouped_organization) %>%
                        mutate(Eig.inst.ed = paste0(Eig," (",Eig.inst,")")) %>%
                        select(Rank, Eig.inst.ed)) %>% data.frame) 
  
  # node_info <- res.inst.sum %>%
  #   filter(main.country == "main") %>%
  #   select(final_grouped_organization, country) %>% unique %>%
  #   mutate(color = ifelse(country == "SOUTH KOREA", "red", 
  #                         ifelse(country %in% eu_country, "blue", "grey")))
  
  ### ALL
  # graph_data <- res.ALL.EL.total.type %>% 
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Source" = "final_grouped_organization")) %>% 
  #   rename(source.country = country, source.color = color) %>%
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Target" = "final_grouped_organization")) %>% 
  #   rename(target.country = country, target.color = color) %>%
  #   # filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  #   arrange(desc(weight)) %>% head(50)
  # 
  # net <- graph_from_data_frame(d = graph_data, directed = FALSE)
  # 
  # V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
  #                        node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
  #                        "grey")
  # 
  # ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 1.5,
  #        label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  #   guides(size = FALSE) +
  #   ggtitle(unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  
  ### Korea
  # graph_data <- org.ALL.EL.total.type %>% 
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Source" = "final_grouped_organization")) %>% 
  #   rename(source.country = country, source.color = color) %>%
  #   left_join(node_info %>% select(final_grouped_organization, country, color), 
  #             by = c("Target" = "final_grouped_organization")) %>% 
  #   rename(target.country = country, target.color = color) %>%
  #   filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  #   arrange(desc(weight)) 
  # 
  # net <- graph_from_data_frame(d = graph_data, directed = FALSE)
  # 
  # V(net)$color <- ifelse(V(net)$name %in% node_info$final_grouped_organization, 
  #                        node_info$color[match(V(net)$name, node_info$final_grouped_organization)], 
  #                        "grey")
  # 
  # ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 3,
  #        label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  #   guides(size = FALSE) +
  #   ggtitle(unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  
}
res.summ.cen.toprank <- res.summ.cen.toprank[2:nrow(res.summ.cen.toprank),]

res.summ.cen.toprank %>% arrange(qc_category, Rank)

res.summ.cen.toprank %>% arrange(qc_category, Rank) %>%
  write.csv(file="res_net_top_cen.csv")





