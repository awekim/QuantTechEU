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
library(stringr)
library('tidyr')
library('ggplot2')
library('splitstackshape')

`%ni%` <- Negate(`%in%`)

dir <- "I:/Data_for_practice/Rfiles/QuanTech"
dir <- "D:/GD_awekimm/[YU]/[Project]/[Quantum]/Quantum_2nd/04_Analysis/QuanTech_R2/R file/"
# quant_inst_ed$country %>% unique %>% sort

eu_country <- 
  c("AUSTRIA","BELGIUM","BULGARIA","CROATIA","CYPRUS","CZECH REPUBLIC","DENMARK",
    "ENGLAND","ESTONIA","FINLAND","FINLAND","FRANCE","GERMANY","GREECE","HUNGARY",
    "ICELAND","IRELAND","ISRAEL","ITALY","LATVIA","LITHUANIA","LUXEMBOURG","MALTA",
    "NETHERLANDS","NORWAY","NORTH IRELAND",
    "POLAND","PORTUGAL","ROMANIA","SCOTLAND","SLOVAKIA","SLOVENIA",      
    "SPAIN","SWEDEN","SWITZERLAND","WALES","UK")
length(eu_country)

#####################################################################################

load(file=paste0(dir,"/quant_keyword.RData"))

quant_keyword %>% filter(qc_category=="qc111") %>% 
  select(pubid) %>% unique %>% nrow
quant_keyword %>% filter(qc_category=="qc111") %>%
  inner_join(qc11_val_df %>% filter(qc_category=="qc111")) %>%
  select(pubid) %>% unique %>% nrow

#####################################################################################

load(file=paste0(dir,"/qc_all_val_df.RData"))
load(file=paste0(dir,"/quant_keyword.RData"))

quant_keyword_ed <- quant_keyword %>% inner_join(qc_all_val_df)
save(quant_keyword_ed, file=paste0(dir,"/quant_keyword_ed.RData"))

quant_keyword_ed %>% group_by(qc_category) %>%
  summarize(count=length(unique(pubid))) %>% data.frame

#####################################################################################

## New way of filtering validated keywords to abstracts

load(file=paste0(dir,"/quant_pub_ed.RData"))
load(file=paste0(dir,'/qc.file.list.RData'))
load(file=paste0(dir,"/qc_all_val_df.RData"))
load(file=paste0(dir,"/quant_keyword_ed.RData"))

qc_all_val_df$val %>% unique

quant_pub_ed_key <- quant_pub_ed %>% 
  inner_join(quant_keyword_ed %>% filter(val=="o" | val== "O" | val== "o ") %>% 
               select(qc_category,pubid) %>% unique) %>%
  select(qc_category,pubid,pubyear,doc_type,pubtype)
save(quant_pub_ed_key, file=paste0(dir,"/quant_pub_ed_key.RData"))

## Test: Why so many?
# quant_keyword_ed %>% filter(qc_category=="qc111") %>%
#   filter(keyword=="SUPERPOSITION") %>% select(pubid) %>% unique %>% nrow
# quant_pub_ed %>% filter(qc_category=="qc111") %>%
#   filter(str_detect(tolower(abstract), tolower("SUPERPOSITION"))) %>% 
#            select(pubid) %>% unique %>% nrow

quant_pub_ed_abs <- 0
for (i in 1:length(unique(quant_pub_ed$qc_category))){
  temp <- quant_pub_ed %>% filter(qc_category==unique(quant_pub_ed$qc_category)[i])
  temp.1 <- qc_all_val_df %>% filter(qc_category==unique(quant_pub_ed$qc_category)[i]) %>%
    filter(val=="o" | val== "O" | val== "o ")
  
  pattern <- paste0("\\b(", paste(temp.1$keyword, collapse = "|"), ")\\b")
  
  matched_temp <- temp %>%
    filter(str_detect(tolower(abstract), tolower(pattern)) |
             str_detect(tolower(itemtitle), tolower(pattern))) %>%
    select(qc_category, pubid, pubyear, doc_type, pubtype) %>% unique
  
  quant_pub_ed_abs <- rbind(quant_pub_ed_abs, matched_temp)

  print(i)
}
quant_pub_ed_abs <- quant_pub_ed_abs[2:nrow(quant_pub_ed_abs),]
save(quant_pub_ed_abs, file=paste0(dir,"/quant_pub_ed_abs.RData"))

# This is new quant_pub_ed_val
quant_pub_ed_val <- rbind(quant_pub_ed_key, quant_pub_ed_abs) %>% 
  unique %>% arrange(qc_category,pubid)
save(quant_pub_ed_val, file=paste0(dir,"/quant_pub_ed_val.RData"))

### Restrict to European Regions
load(file=paste0(dir,"/quant_pub_ed.RData"))
load(file=paste0(dir,"/quant_inst_ed.RData"))
load(file=paste0(dir,"/quant_pub_ed_val.RData"))

# Total publication before keyword 
quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  select(pubid) %>% unique %>% nrow # 70,456 -> 71,502

# Total publication after keyword 
quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique) %>%
  select(pubid) %>% unique %>% nrow # 23,981 -> 66,784, 67,767

quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique) %>%
  group_by(qc_category) %>% count

### Check - BANG LAE
quant_inst_ed %>% 
  filter(country %in% eu_country) %>%
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  ### with validation
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique) %>%
  ### without validation
  # inner_join(quant_pub_ed) %>%
  filter(country=="FRANCE") %>% filter(pubyear >=2018) %>%
  select(pubid) %>% unique %>% nrow

### Check - JIN SEO
quant_inst_ed %>% 
  filter(country %in% eu_country) %>%
  # select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  ### with validation
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique) %>%
  ### without validation
  # inner_join(quant_pub_ed) %>%
  # filter(country=="FRANCE") %>% 
  filter(pubyear >=2010) %>%
  select(pubid) %>% unique %>% nrow

### Total publication after keyword 
### Institution
quant_inst_ed_eu_val <- quant_inst_ed %>% 
  filter(country %in% eu_country) %>% 
  select(pubid) %>% unique %>%
  inner_join(quant_inst_ed) %>%
  inner_join(quant_pub_ed_val %>% select(pubid, qc_category, pubyear) %>% unique) %>%
  arrange(qc_category, pubid)
quant_inst_ed_eu_val$pubid %>% unique %>% length # 67,767
save(quant_inst_ed_eu_val, file=paste0(dir,"/quant_inst_ed_eu_val.RData"))
quant_inst_ed_eu_val %>% head

quant_inst_ed_eu_val$organization %>% unique %>% length # 21,507
quant_inst_ed_eu_val$suborganization %>% unique %>% length # 33,442
write.csv(quant_inst_ed_eu_val, file=paste0(dir,"/quant_inst_ed_eu_val.csv"),
          row.names=FALSE)

#####################################################################################
### LLM paper validation version - Ignore

load(file=paste0(dir,"/quant_inst_ed_eu_val.RData"))

### LLM validation
quant.llm.val <- read.csv(file=paste0("../../quantum_classification_results_final_BH1.csv"))
quant.llm.val %>% head

quant.llm.val <- quant.llm.val %>% filter(relevance!="Error")

quant.llm.val$relevance %>% unique

quant.llm.val$pubid %>% unique %>% length # 70,528

#####################################################################################
#### Institution cleansing
#####################################################################################

###
# ! QuanTech_DataClearning_Inst.ipynb
###

quant_inst_ed_eu_fixed_val <-
  read.csv(file=paste0(dir,"/quant_inst_ed_eu_val_cleaned.csv")) 
# Convert ENGLAND, SCOTLAND, WALES TO UK
quant_inst_ed_eu_fixed_val %<>% 
  mutate(country=ifelse(country %in% c("ENGLAND","SCOTLAND","WALES"),"UK",country))
save(quant_inst_ed_eu_fixed_val, 
     file=paste0(dir,"/quant_inst_ed_eu_fixed_val.RData"))

quant_inst_ed_eu_fixed_val %>%
  filter(organization_cleaned=="CENTRE NATIONAL DE LA RECHERCHE SCIENTIFIQUE (CNRS)") %>%
  select(organization_cleaned,full_address) %>% unique

quant_inst_ed_eu_fixed_val %>% head

load(paste0(dir,"/quant_inst_ed_eu_fixed_val.RData"))
load(paste0(dir,"/quant_pub_ed_val.RData"))

quant_inst_ed_eu_fixed_val %>% names
quant_inst_ed_eu_fixed_val$pubid %>% unique %>% length # 21,419 -> 67,767
quant_inst_ed_eu_fixed_val$organization %>% unique %>% length # 9,986 -> 21,507
quant_inst_ed_eu_fixed_val$organization_cleaned %>% unique %>% length # 7,298 -> 15,353 -> 12,501

quant_inst_ed_eu_fixed_val %>% filter(qc_category=="qc224")
quant_inst_ed_eu_fixed_val %>% filter(organization_cleaned=="RESEARCH ORGANIZATION OF INFORMATION  SYSTEMS ROIS")

quant_inst_ed_eu_fixed_val$organization_cleaned %>% table %>%
  data.frame %>%
  arrange(desc(Freq)) %>% head(20)

#####################################################################################
# Comparing Results: Original vs. LLM  
load(paste0(dir,"/quant_inst_ed_eu_fixed_val.RData"))

### Original version
quant_inst_ed_eu_fixed_val %>% 
  filter(is.na(qc_category)==FALSE) %>% 
  select(pubid) %>% unique %>% nrow # 67,767

# 표8. 양자과학기술 분야별 논문 수 
quant_inst_ed_eu_fixed_val %>% group_by(qc_category) %>%
  summarize(count=length(unique(pubid))) %>% data.frame

quant_pub_ed_val %>% head

### LLM Version
quant.llm.val %>% filter(relevance=="Related") %>% 
  select(pubid) %>% unique %>%
  left_join(quant_inst_ed_eu_val %>% select(pubid, qc_category) %>% unique) %>%
  filter(is.na(qc_category)==FALSE) %>% 
  select(pubid) %>% unique %>% nrow # 55,122

# 양자과학기술 분야별 논문 수 
quant.llm.val %>% filter(relevance=="Related") %>% 
  select(pubid) %>% unique %>%
  left_join(quant_inst_ed_eu_val %>% select(pubid, qc_category) %>% unique) %>%
  group_by(qc_category) %>%
  summarize(count=length(unique(pubid))) %>% data.frame

#####################################################################################
#### Author cleansing
#####################################################################################

load(paste0(dir,"/quant_inst_ed_eu_fixed_val.RData"))
load(paste0(dir,"/quant_author_ed_eu.RData"))
quant_author_ed_eu$pubid %>% unique %>% length # 71,502

# First match with pubid, qc_category, seqno=postion and addr_num

eu_pubids <- quant_inst_ed_eu_fixed_val %>%
  filter(country %in% eu_country) %>%
  distinct(pubid)

base_df <- quant_inst_ed_eu_fixed_val %>%
  semi_join(eu_pubids, by = "pubid") %>%
  mutate(
    suborganization_cleaned = dplyr::coalesce(
      .data[["suborganization_cleaned"]],
      .data[["suborganization_clean"]],
      .data[["suborganization"]]
    ),
    organization_cleaned = dplyr::coalesce(
      .data[["organization_cleaned"]],
      .data[["organization"]]
    )
  ) %>%
  select(pubid, qc_category, addr_num, SEQ_NO,
         organization_cleaned, suborganization_cleaned,
         city, country, pubyear) %>%
  distinct() %>%
  mutate(
    ID_all = paste(pubid, qc_category, addr_num, SEQ_NO, sep = "-")
  )

authors_matched <- quant_author_ed_eu %>%
  mutate(addr_num_for_join = dplyr::coalesce(.data[["addr_num"]], .data[["addr_num_ed"]])) %>%
  select(
    pubid, qc_category,
    addr_num = addr_num_for_join,             # base의 addr_num과 맞추기
    position, role,
    author_id_te, display_name, full_name,
    wos_standard, first_name, last_name
  ) %>%
  distinct()

authors_rest <- quant_author_ed_eu %>%
  select(
    pubid, qc_category, position, role,
    author_id_te, display_name, full_name,
    wos_standard, first_name, last_name
  ) %>%
  distinct()

quant_author_ed_eu_val_matched <- base_df %>%
  filter(!is.na(SEQ_NO)) %>%
  inner_join(
    authors_matched,
    by = c("pubid","qc_category","addr_num","SEQ_NO" = "position")
  ) %>%
  arrange(qc_category, pubid, addr_num, SEQ_NO) %>%
  mutate(matched = "matched")

unmatched_base <- base_df %>%
  anti_join(quant_author_ed_eu_val_matched %>% distinct(ID_all), by = "ID_all")

matched_positions <- quant_author_ed_eu_val_matched %>%
  distinct(pubid, qc_category, position = SEQ_NO)

quant_author_ed_eu_val_rest <- unmatched_base %>%
  left_join(
    authors_rest,
    by = c("pubid","qc_category"),
    # dplyr >= 1.1이면 many-to-many 명시(아래 인자 없으면 생략 가능)
    relationship = "many-to-many"
  ) %>%
  anti_join(matched_positions, by = c("pubid","qc_category","position")) %>%
  arrange(qc_category, pubid, addr_num, SEQ_NO) %>%
  mutate(matched = "rest")

quant_author_ed_eu_val <-
  bind_rows(quant_author_ed_eu_val_matched, quant_author_ed_eu_val_rest) %>%
  arrange(qc_category, pubid, addr_num)
rm(quant_author_ed_eu_val_matched, quant_author_ed_eu_val_rest)
save(quant_author_ed_eu_val, file=paste0(dir,"/quant_author_ed_eu_val.RData"))
write.csv(quant_author_ed_eu_val, file=paste0(dir,"/quant_author_ed_eu_val.csv"))

load(file=paste0(dir,"/quant_author_ed_eu_val.RData"))
quant_author_ed_eu_val$pubid %>% unique %>% length

###
# ! QuanTech_DataCleaning_Author.ipynb
###

quant_author_ed_eu_val_cleaned <- 
  read.csv(file=paste0("R file/quant_author_ed_eu_val_final_unified.csv"))

### Below are manual edits after several rounds of checking
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 13520744,
  "full_name"
] <- "Gisin, Nicolas"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 13520744,
  "author_id_te_cleaned"
] <- 13520752
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 19383520,
  "full_name"
] <- "Kartashov, Yaroslav V"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 19383520,
  "author_id_te_cleaned"
] <- 19383538
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 40175063,
  "full_name"
] <- "Torner, Lluis"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 40175063,
  "author_id_te_cleaned"
] <- 40175076
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 21208008,
  "full_name"
] <- "Kuebler, Harald"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 21208008,
  "author_id_te_cleaned"
] <- 21208008
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 36195038,
  "full_name"
] <- "Shaffer, James P"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 36195038,
  "author_id_te_cleaned"
] <- 36195267
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 31788773,
  "full_name"
] <- "Poppe, Andreas"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 31788773,
  "organization_cleaned"
] <- "AUSTRIAN INSTITUTE OF TECHNOLOGY (AIT)"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 31788773,
  "country"
] <- "AUSTRIA"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 31788773,
  "author_id_te_cleaned"
] <- 31788959
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 7815839,
  "full_name"
] <- "Cornil, Jerome"
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 7815839,
  "author_id_te_cleaned"
] <- 7815913
quant_author_ed_eu_val_cleaned[
  !is.na(quant_author_ed_eu_val_cleaned$author_id_te_cleaned) &
    quant_author_ed_eu_val_cleaned$author_id_te_cleaned == 22492897,
  "orgnization_cleaned"
] <- 

quant_author_ed_eu_val_cleaned %>% head
save(quant_author_ed_eu_val_cleaned, file="R file/quant_author_ed_eu_val_cleaned.RData")

############################################################################################################
#### Divide three parts
############################################################################################################

quan_lable <- read.csv(file=paste0(dir,"/qc_label.csv"), encoding = "UTF-8") 
names(quan_lable) <- c("qc_category","label")

load(file=paste0(dir,"/qc_all_val_df.RData"))
load(paste0(dir,"/qc11_val.RData")); load(paste0(dir,"/qc12_val.RData"))
load(paste0(dir,"/qc2_val.RData")); load(paste0(dir,"/qc3_val.RData")); load(paste0(dir,"/qc4_val.RData"))

part1 <- c(qc11_val,qc2_val,"qc313",qc3_val) %>% sort
part2 <- c("qc11","qc12","qc13","qc14","qc21","qc22","qc1a1","qc1a2","qc1a3",
           "qc1a4","qc1a5","qc1a6","qc421","qc422","qc423","qc424","qc43")
part3 <- c(qc11_val,qc12_val,qc2_val,qc3_val)
part4 <- c(qc4_val)

part.list <- list(part1, part2)

for(i in 1:length(part.list)){
  load(paste0(dir,"/quant_inst_ed_eu_fixed_val.RData"))
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
  quant_inst_ed_eu_fixed_val$org_sub <- 
    paste(quant_inst_ed_eu_fixed_val$organization_cleaned,"-",quant_inst_ed_eu_fixed_val$suborganization)
  quant_inst_ed_eu_fixed_val %<>% 
    mutate(qc_category=ifelse(qc_category=="qc313","qc312",qc_category)) 
  save(quant_inst_ed_eu_fixed_val, 
       file=paste0(dir,"/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
  write.csv(quant_inst_ed_eu_fixed_val, 
            file=paste0(dir,"/part",i,"_quant_inst_ed_eu_fixed_val.csv"))
  
  load(file=paste0(dir,"/quant_pub_ed_val.RData"))
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
  save(quant_pub_ed_eu_val, file=paste0(dir,"/part",i,"_quant_pub_ed_eu_val.RData"))
  write.csv(quant_pub_ed_eu_val, file=paste0(dir,"/part",i,"_quant_pub_ed_eu_val.csv"))
  rm(quant_pub_ed_val, quant_pub_ed_eu_val)

  load(file="R file/quant_author_ed_eu_val_cleaned.RData")
  load(file=paste0(dir,"/quant_pub_ed_val.RData"))
  if (i ==2){
    quant_author_ed_eu_val_cleaned <- quant_author_ed_eu_val_cleaned %>%
      left_join(quant_pub_ed_val %>% select(pubid,qc_category) %>% unique) %>%
      mutate(type=substr(qc_category,1,4)) %>%
      mutate(qc_category=ifelse(type %in% c("qc11","qc12","qc13","qc14","qc21","qc22"),
                                type,qc_category)) %>%
      filter(qc_category %in% part.list[[i]]) 
    rm(quant_pub_ed_val)
  } else{
    quant_author_ed_eu_val_cleaned <- quant_author_ed_eu_val_cleaned %>%
      left_join(quant_pub_ed_val %>% select(pubid,qc_category) %>% unique) %>%
      filter(qc_category %in% part.list[[i]]) 
    rm(quant_pub_ed_val)
  }
  quant_author_ed_eu_val_cleaned %<>% left_join(quan_lable %>% select(qc_category,label))
  quant_author_ed_eu_val_cleaned$org_sub <-
    paste(quant_author_ed_eu_val_cleaned$organization_cleaned,"-",quant_author_ed_eu_val_cleaned$suborganization_cleaned)
  quant_author_ed_eu_val_cleaned %<>%
    mutate(qc_category=ifelse(qc_category=="qc313","qc312",qc_category))
  save(quant_author_ed_eu_val_cleaned, file=paste0("R file/part",i,"_quant_author_ed_eu_val_cleaned.RData"))
  write.csv(quant_author_ed_eu_val_cleaned, file=paste0("R file/part",i,"_quant_author_ed_eu_val_cleaned.csv"))
  rm(quant_author_ed_eu_val_cleaned)
  print(i)
}

############################################################################################################
#### Quant-EU Data Descriptives
############################################################################################################

i <- 1
load(file=paste0(dir,"/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
load(file=paste0(dir,"/part",i,"_quant_pub_ed_eu_val.RData"))
load(file=paste0(dir,"/part",i,"_quant_author_ed_eu_val_cleaned.RData"))

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

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category, label) %>%
  summarize(org = length(unique(organization_cleaned))) %>% 
  data.frame %>% 
  arrange(qc_category) 

# 양자과학기술 분야별 논문 수
quant_pub_ed_eu_val %>% group_by(qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% data.frame

# 그림4. 국가별 양자과학기술 논문 수
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

# 그림 5. (전체) 국가별 양자과학기술 논문 수
quant_inst_ed_eu_fixed_val %>% 
  # filter(country %in% eu_country) %>%
  group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% # head(30) %>%
  ggplot(aes(x=reorder(country,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("국가")

# 표9. (1단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc3=substr(qc_category,1,3)) %>%
  group_by(pubyear,qc3) %>%
  filter(country %in% eu_country) %>%
  group_by(qc3,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
  group_by(qc3) %>% #filter(pub==max(pub)) %>%
  arrange(qc3) %>% slice(1:3) %>%
  data.frame
write.csv(quant_inst_ed_eu_fixed_val %>% 
            mutate(qc3=substr(qc_category,1,3)) %>%
            group_by(pubyear,qc3) %>%
            filter(country %in% eu_country) %>%
            group_by(qc3,country) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
            arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
            group_by(qc3) %>% #filter(pub==max(pub)) %>%
            arrange(qc3) %>% slice(1:3) %>%
            data.frame,
          file="Tables/(1단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가.csv")

# 표10. (2단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc4=substr(qc_category,1,4)) %>%
  group_by(pubyear,qc4) %>%
  filter(country %in% eu_country) %>%
  group_by(qc4,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
  group_by(qc4) %>% #filter(pub==max(pub)) %>%
  arrange(qc4) %>% slice(1:3) %>%
  data.frame
write.csv(quant_inst_ed_eu_fixed_val %>% 
            mutate(qc4=substr(qc_category,1,4)) %>%
            group_by(pubyear,qc4) %>%
            filter(country %in% eu_country) %>%
            group_by(qc4,country) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
            arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
            group_by(qc4) %>% #filter(pub==max(pub)) %>%
            arrange(qc4) %>% slice(1:3) %>%
            data.frame,
          file="Tables/(2단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가.csv")

# (3단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
  group_by(qc_category) %>% #filter(pub==max(pub)) %>%
  arrange(qc_category) %>% slice(1:3) %>%
  data.frame
write.csv(quant_inst_ed_eu_fixed_val %>% 
            filter(country %in% eu_country) %>%
            group_by(qc_category,country) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
            arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
            group_by(qc_category) %>% #filter(pub==max(pub)) %>%
            arrange(qc_category) %>% slice(1:3) %>%
            data.frame,
          file="Tables/(3단계) 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가.csv")

# 양자과학기술 분야별 양자과학기술 논문 생산 상위 국가
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category,country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
  group_by(qc_category) %>% filter(pub==max(pub)) %>%
  arrange(qc_category) %>% 
  data.frame
write.csv(quant_inst_ed_eu_fixed_val %>% 
            filter(country %in% eu_country) %>%
            group_by(qc_category,country) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
            arrange(desc(pub)) %>% ungroup %>% #head(30) %>%
            group_by(qc_category) %>% filter(pub==max(pub)) %>%
            arrange(qc_category) %>% 
            data.frame,
          file="Tables/양자과학기술 분야별 양자과학기술 논문 생산 상위 국가.csv")

# (유럽) 기관별 논문 수 (상위 30개)
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% head(30) %>%
  ggplot(aes(x=reorder(organization_cleaned,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(org_sub) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% head(30) %>%
  ggplot(aes(x=reorder(org_sub,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

# Organization - country list
org_country_list <- quant_inst_ed_eu_fixed_val %>% 
  group_by(organization_cleaned,country) %>% 
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub))

# (비유럽) 기관별 논문 수 (상위 30개)
'%ni%' <- Negate('%in%')
quant_inst_ed_eu_fixed_val %>% 
  filter(country %ni% eu_country) %>%
  group_by(organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% head(30) %>% 
  ggplot(aes(x=reorder(organization_cleaned,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

# 상위 한국-유럽 협력 기관
quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  group_by(organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(5)

quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  group_by(organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  ggplot(aes(x=reorder(organization_cleaned,-pub), y=pub)) + 
  geom_bar(stat="identity") + coord_flip() + 
  theme_bw() + guides(color=FALSE) +
  ylab("논문 수") + xlab("기관")

# 한국과 협력하는 유럽 연구 기관
quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  select(pubid) %>% unique() %>%
  left_join(quant_inst_ed_eu_fixed_val, by = "pubid") %>%
  filter(country != 'SOUTH KOREA' & country %in% eu_country) %>%
  group_by(country, organization_cleaned) %>%
  summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
  mutate(org_with_country = paste(organization_cleaned,country, sep = " - ")) %>%
  arrange(desc(pub)) %>% 
  select(org_with_country, pub) %>% 
  head(20) %>% 
  data.frame()
write.csv(quant_inst_ed_eu_fixed_val %>% 
            filter(country == 'SOUTH KOREA') %>%
            select(pubid) %>% unique() %>%
            left_join(quant_inst_ed_eu_fixed_val, by = "pubid") %>%
            filter(country != 'SOUTH KOREA' & country %in% eu_country) %>%
            group_by(country, organization_cleaned) %>%
            summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
            mutate(org_with_country = paste(organization_cleaned,country, sep = " - ")) %>%
            arrange(desc(pub)) %>% 
            select(org_with_country, pub) %>% 
            head(20) %>% 
            data.frame(),file="Tables/한국과 협력하는 유럽 연구 기관.csv")

# 상위 한국-유럽 협력 연구자
quant_inst_ed_eu_fixed_val %>% 
  filter(country == 'SOUTH KOREA') %>%
  select(pubid) %>% unique %>%
  left_join(quant_author_ed_eu_val_cleaned) %>%
  # inner_join(res.inst.sum) %>%
  group_by(author_id_te, full_name,organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(20)

quant_inst_ed_eu_fixed_val %>% 
  select(pubid) %>% unique %>%
  left_join(quant_author_ed_eu_val_cleaned) %>%
  # inner_join(res.inst.sum) %>%
  filter(country == 'SOUTH KOREA') %>%
  group_by(author_id_te, full_name,organization_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  arrange(desc(pub)) %>% data.frame %>% head(10)

# 표 12 상위 12개 국가의 상위 기관
top.country <- quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(country) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  group_by(country) %>% arrange(desc(pub)) %>% head(12) %>% data.frame %>%
  ungroup() %>% pull(country)

data.frame(country = top.country) %>%
  inner_join(quant_inst_ed_eu_fixed_val %>% 
               filter(country %in% top.country) %>%
               group_by(country, organization_cleaned) %>%
               summarize(pub = length(unique(pubid))) %>% ungroup() %>%
               group_by(country) %>% arrange(desc(pub)) %>% slice(1:5) %>% data.frame) %>%
  write.csv(file="Tables/표 12 상위 12개 국가의 상위 기관.csv",
            row.names=FALSE)

top.inst <- data.frame(country = top.country) %>%
  inner_join(quant_inst_ed_eu_fixed_val %>% 
               filter(country %in% top.country) %>%
               group_by(country, organization_cleaned) %>%
               summarize(pub = length(unique(pubid))) %>% ungroup() %>%
               group_by(country) %>% arrange(desc(pub)) %>% slice(1:5) %>% data.frame) %>%
  ungroup() %>% pull(organization_cleaned)

quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% top.country) %>%
  group_by(country, organization_cleaned,qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>%
  group_by(country, organization_cleaned) %>% arrange(desc(pub)) %>% 
  slice(1:6)  

# 기관별 양자과학기술 주 연구 분야
quant_inst_ed_eu_fixed_val %>% 
  filter(organization_cleaned %in% top.inst) %>%  
  select(-c("country")) %>%
  left_join(org_country_list) %>%
  # left_join(quant_author_ed_eu_val %>% select(pubid,author_id_te,full_name) %>% unique) %>%
  group_by(country,organization_cleaned,qc_category) %>% 
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(country,organization_cleaned) %>% arrange(desc(pub)) %>%
  slice(1:3) %>% data.frame

# 표 13 기관별 양자과학기술 주 연구 분야
data.frame(country = top.country) %>%
  inner_join(quant_inst_ed_eu_fixed_val %>% 
               filter(organization_cleaned %in% top.inst) %>%  
               select(-country) %>% 
               left_join(org_country_list, by = "organization_cleaned") %>% 
               group_by(country, organization_cleaned, qc_category) %>% 
               summarize(pub = n_distinct(pubid), .groups = "drop") %>% 
               group_by(country, organization_cleaned) %>% 
               slice_max(order_by = pub, n = 3, with_ties = FALSE) %>% 
               summarise(top_qc = str_c(qc_category, collapse = ", "), .groups = "drop") %>% 
               data.frame()) 

top_orgs <- quant_inst_ed_eu_fixed_val %>%
  filter(country %in% top.country) %>%
  group_by(country, organization_cleaned) %>%
  summarise(pub_total = n_distinct(pubid), .groups = "drop") %>%
  group_by(country) %>%
  slice_max(pub_total, n = 5, with_ties = FALSE) %>%
  ungroup()

data.frame(country = top.country) %>%
  inner_join(quant_inst_ed_eu_fixed_val %>%
               filter(country %in% top.country) %>%
               semi_join(top_orgs, by = c("country", "organization_cleaned")) %>%
               group_by(country, organization_cleaned, qc_category) %>%
               summarise(pub = n_distinct(pubid), .groups = "drop") %>%
               group_by(country, organization_cleaned) %>%
               slice_max(pub, n = 3, with_ties = FALSE) %>%
               summarise(qc_category = str_c(qc_category, collapse = ", "),
                         .groups = "drop"))

write.csv(data.frame(country = top.country) %>%
            inner_join(quant_inst_ed_eu_fixed_val %>%
                         filter(country %in% top.country) %>%
                         semi_join(top_orgs, by = c("country", "organization_cleaned")) %>%
                         group_by(country, organization_cleaned, qc_category) %>%
                         summarise(pub = n_distinct(pubid), .groups = "drop") %>%
                         group_by(country, organization_cleaned) %>%
                         slice_max(pub, n = 3, with_ties = FALSE) %>%
                         summarise(qc_category = str_c(qc_category, collapse = ", "),
                                   .groups = "drop")),
          file="Tables/표 13 기관별 양자과학기술 주 연구 분야.csv")

quant_inst_ed_eu_fixed_val %>% 
  filter(organization_cleaned %in% top.inst) %>%  
  select(-c("country")) %>%
  left_join(org_country_list) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% select(pubid,author_id_te,full_name) %>% unique) %>%
  group_by(country,organization_cleaned,qc_category) %>% 
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(country,organization_cleaned) %>% arrange(desc(pub)) %>%
  slice(1:3) %>% ungroup %>%
  group_by(qc_category) %>% summarize(count=n())

# 표 14 (1단계) 양자과학기술 분야별 상위 기관
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc3 = substr(qc_category, 1, 3)) %>%
  group_by(qc3, country, organization_cleaned) %>%
  summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
  mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
  arrange(qc3, desc(pub)) %>% 
  group_by(qc3) %>% 
  slice(1:3) %>% 
  select(qc3, org_with_country, pub) %>% 
  data.frame()

write.csv(quant_inst_ed_eu_fixed_val %>% 
            mutate(qc3 = substr(qc_category, 1, 3)) %>%
            group_by(qc3, country, organization_cleaned) %>%
            summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
            mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
            arrange(qc3, desc(pub)) %>% 
            group_by(qc3) %>% 
            slice(1:3) %>% 
            select(qc3, org_with_country, pub) %>% 
            data.frame(),
          file="Tables/(1단계) 양자과학기술 분야별 상위 기관.csv")

# (2단계) 양자과학기술 분야별 상위 기관
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc4 = substr(qc_category, 1, 4)) %>%
  group_by(qc4, country, organization_cleaned) %>%
  summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
  mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
  arrange(qc4, desc(pub)) %>% 
  group_by(qc4) %>% 
  slice(1:3) %>% 
  select(qc4, org_with_country, pub) %>% 
  data.frame()
write.csv(quant_inst_ed_eu_fixed_val %>% 
            mutate(qc4 = substr(qc_category, 1, 4)) %>%
            group_by(qc4, country, organization_cleaned) %>%
            summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
            mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
            arrange(qc4, desc(pub)) %>% 
            group_by(qc4) %>% 
            slice(1:3) %>% 
            select(qc4, org_with_country, pub) %>% 
            data.frame(),
          file="Tables/(2단계) 양자과학기술 분야별 상위 기관.csv")

# (3단계) 양자과학기술 분야별 상위 기관
quant_inst_ed_eu_fixed_val %>% 
  filter(country %in% eu_country) %>%
  group_by(qc_category, country, organization_cleaned) %>%
  summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
  mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
  arrange(qc_category, desc(pub)) %>% 
  group_by(qc_category) %>%
  slice(1:3) %>% 
  select(qc_category, org_with_country, pub) 

write.csv(quant_inst_ed_eu_fixed_val %>% 
            filter(country %in% eu_country) %>%
            group_by(qc_category, country, organization_cleaned) %>%
            summarise(pub = n_distinct(pubid), .groups = "drop") %>% 
            mutate(org_with_country = paste(organization_cleaned, country, sep = " - ")) %>%
            arrange(qc_category, desc(pub)) %>% 
            group_by(qc_category) %>%
            slice(1:3) %>% 
            select(qc_category, org_with_country, pub),
          file="Tables/(3단계) 양자과학기술 분야별 상위 기관.csv")

# Organization - country list
res_org_list <- quant_author_ed_eu_val_cleaned %>% 
  left_join(quant_inst_ed_eu_fixed_val %>% select(-c("country")) %>% 
              left_join(org_country_list) %>% select(pubid,organization_cleaned,country) %>% unique) %>%
  group_by(author_id_te,full_name, organization_cleaned,country) %>%
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub)) 

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
                          summarize(count=length(unique(organization_cleaned)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.org.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.org.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  #coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "bottom") +
  scale_fill_discrete(name="Type") 

# (1단계) 양자과학기술별 기관 협력 비중
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc3=substr(qc_category,1,3)) %>% 
  group_by(qc3,pubid) %>%
  summarize(org=length(unique(organization_cleaned))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.org", org!=1~"collab.org")) %>% 
  group_by(qc3,collab.d) %>%
  summarize(count=length(unique(pubid))) %>%
  ggplot(aes(x=qc3,y=count,fill=collab.d)) + geom_bar(position="dodge", stat='identity') +
  # coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "none") +
  scale_fill_discrete(name="Type") 


# (2단계) 양자과학기술별 기관 협력 비중
quant_inst_ed_eu_fixed_val %>% 
  mutate(qc4=substr(qc_category,1,4)) %>% 
  group_by(qc4,pubid) %>%
  summarize(org=length(unique(organization_cleaned))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.org", org!=1~"collab.org")) %>% 
  group_by(qc4,collab.d) %>%
  summarize(count=length(unique(pubid))) %>%
  ggplot(aes(x=qc4,y=count,fill=collab.d)) + geom_bar(position="dodge", stat='identity') +
  # coord_flip() + 
  theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "none") +
  scale_fill_discrete(name="Type") 


# (3단계) 양자과학기술별 기관 협력 비중
quant_inst_ed_eu_fixed_val %>% 
  filter(qc_category!="qc32") %>%
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(organization_cleaned))) %>% ungroup %>%
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
  summarize(org=length(unique(organization_cleaned))) %>% ungroup %>%
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
  summarize(org=length(unique(organization_cleaned))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole", org!=1~"collab")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% ungroup %>% 
  filter(collab.d=="collab") %>%
  mutate(mean.org=mean(org))

# Collaboration bar - researcher
quant_author_ed_eu_val_cleaned %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,label,qc_label) %>% summarize(pub=length(unique(pubid))) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% select(qc_category,label,pubid) %>% unique %>%
              left_join(quant_author_ed_eu_val_cleaned %>% group_by(pubid) %>%
                          summarize(count=length(unique(author_id_te)))) %>%
              filter(count > 1) %>% 
              group_by(qc_category,label) %>% summarize(pub.res.collab=length(unique(pubid)))) %>%
  tidyr::gather(variable, value, pub:pub.res.collab) %>%
  ggplot(aes(x=qc_category,y=value,fill=variable)) + geom_bar(position="dodge", stat='identity') +
  coord_flip() + theme_bw() + guides(color=TRUE) +
  ylab("논문 수") + xlab("양자과학기술 분야") + theme(legend.position = "bottom") +
  scale_fill_discrete(name="Type") 

# sole researcher vs. collab researcher
quant_author_ed_eu_val_cleaned %>% 
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

quant_author_ed_eu_val_cleaned %>% 
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

quant_author_ed_eu_val_cleaned %>% 
  mutate(qc_label = paste0(qc_category,"-",label)) %>%
  group_by(qc_category,qc_label,pubid) %>%
  summarize(org=length(unique(author_id_te))) %>% ungroup %>%
  mutate(collab.d = case_when(org==1~"sole.res", org!=1~"collab.res")) %>% 
  group_by(qc_category,qc_label,collab.d) %>%
  summarize(org=mean(org)) %>% ungroup %>% 
  filter(collab.d=="collab.res") %>%
  mutate(mean.org=mean(org))

###########################################################################
### User-defined functions
###########################################################################

### [FUNCTION] GETTING EDGELIST
# Simpler version: available for big data set

getting.edgelist.local <- function(InputDF){
  
  # InputDF <- subset(app.inv.ipc, period==unique(app.inv.ipc$period)[[t]])
  # InputDF <- subset(pat.reg.cpc, US_CA_metro_name==unique(pat.reg.cpc$US_CA_metro_name)[[i]])
  # InputDF <- org.set.w.type
  
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
save(ALL.G.p.all, file=paste0(dir,"/ALL.G.p.all_val.RData"))

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
save(summ.cen.all, file=paste0(dir,"/summ.cen.all_val.RData"))

# (국가 네트워크 – 유럽) 가중 연결 중심성 vs. 매개 중심성
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

# (국가 네트워크 – 유럽 제외) 가중 연결 중심성 vs. 매개 중심성
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

# (국가 네트워크 – 유럽 제외) 가중 연결 중심성 vs. 고유벡터 중심성
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
             size = 5) #+
# geom_label(data = subset(summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))), 
#                         Id == "ENGLAND"), 
#           aes(x = w.Deg, y = Eig), 
#           color = "darkgreen", 
#           size = 5)

write.csv(summ.cen.all %>% data.frame, file=paste0(dir,"/network_measures_all_val.csv",
          row.names=FALSE))
write.csv(ALL.EL.p.all %>% data.frame, file=paste0(dir,"/qc_edges_all_val.csv",
          row.names=FALSE))
write.csv(Node.table.all %>% data.frame, file=paste0(dir,"/qc_nodes_all_val.csv",
          row.names=FALSE))

load(file=paste0(dir,"/ALL.G.p.all_val.RData"))
qc_network.all <- ALL.G.p.all %>% 
  ggnet2(size = "degree", label=TRUE, #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) + ggtitle("all")
qc_network.all
ggsave(filename=paste0(dir,"/org_network_all_val.png"), 
       plot=qc_network.all)

# (국가 네트워크) 상위 100개 협력 네트워크
qc_network.eu <- 
  ALL.EL.total.all %>% 
  filter(Source %in% eu_country | Target %in% eu_country) %>%
  arrange(desc(weight)) %>% 
  head(100) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size=4,
         label.trim=TRUE, # node.color=highlight,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")
qc_network.eu
ggsave(filename=paste0(dir,"/org_network_eu_val.png"), 
       plot=qc_network.eu)

ALL.EL.total.all %>% 
  # filter(Source %in% eu_country | Target %in% eu_country) %>%
  arrange(desc(weight)) %>% 
  filter(Source %in% c("SOUTH KOREA") | Target %in% c("SOUTH KOREA"))
  # filter(Source %in% c("SOUTH KOREA","ENGLAND") | Target %in% c("SOUTH KOREA","ENGLAND"))


### Category Summary 
quant_inst_ed_eu_fixed_val %>% 
  group_by(qc_category,pubid) %>% 
  summarize(org=length(unique(organization_cleaned))) %>%
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

###########################################################################
### Organization-level analysis
###########################################################################

org.country.sum <- quant_inst_ed_eu_fixed_val %>% 
  group_by(organization_cleaned,country) %>% 
  summarize(country.count=length(unique(pubid))) %>% ungroup %>%
  left_join(quant_inst_ed_eu_fixed_val %>% 
              group_by(organization_cleaned,country) %>% 
              summarize(country.count=length(unique(pubid))) %>% ungroup %>%
              group_by(organization_cleaned) %>% 
              arrange(organization_cleaned,desc(country.count)) %>% 
              slice(1) %>% mutate(main.country="main")) %>%
  mutate(main.country=ifelse(main.country=="main","main","others"))

### All
# Non-weight version
# w.org.table <- quant_inst_ed_eu_fixed_val %>% 
#   group_by(pubid) %>% mutate(count=length(unique(organization_cleaned))) %>%
#   mutate(share=1/count) %>% ungroup %>%
#   filter(count!=1) %>% 
#   group_by(pubid,organization_cleaned) %>%
#   dplyr::summarise(weight=sum(share)) %>% ungroup %>%
#   select(-c("weight"))
# 
# # generating ID (1,2,3,4...) by Application ID
# org.set <- getanID(w.org.table, id.vars = "pubid")
# colnames(org.set)[colnames(org.set)==".id"] <- "compound"
# org.set$compound <- as.factor(org.set$compound)
# 
# # create CPC matrix: each row shows individual patent's list of CPCs
# org.set.w <- spread(org.set, compound, organization_cleaned)
# 
# org.ALL.EL.total.all <- getting.edgelist.local(org.set.w)
# org.ALL.EL.total.all %<>% dplyr::rename(weight=Weight)
# 
# org.ALL.EL.total.all %>% 
#   left_join(quant_inst_ed_eu_fixed_val %>% 
#               select(organization_cleaned, country) %>% unique, 
#             by=c("Source"="organization_cleaned")) %>% 
#   rename(Source.Country=country) %>%
#   left_join(quant_inst_ed_eu_fixed_val %>% 
#               select(organization_cleaned, country) %>% unique, 
#             by=c("Target"="organization_cleaned")) %>%
#   rename(Target.Country=country) 
# org.ALL.EL.total.all %>% arrange(desc(weight)) %>%
#   head(20) %>%
#   left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
#             by=c("Source"="organization_cleaned")) %>%
#   left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
#             by=c("Source"="organization_cleaned")) %>%
#   mutate(col.type = ifelse(Source.country==Target.country,"Internal","External")) %>%
#   group_by(col.type) %>% 
#   summarize(weight=mean(weight))
# 
# org.ALL.G.p.all <- graph.data.frame(org.ALL.EL.total.all, directed=FALSE)
# save(org.ALL.G.p.all, file=paste0(dir,"/org.ALL.G.p.all_val.RData"))
# 
# org.ALL.EL.p.all <-
#   data.frame(data.frame(get.edgelist(org.ALL.G.p.all)),
#              weight=round(E(org.ALL.G.p.all)$weight, 3))
# names(org.ALL.EL.p.all) <- c("Source", "Target", "weight")
# 
# org.ALL.EL.p.all <- org.ALL.EL.p.all %>% 
#   group_by(Source, Target) %>%
#   summarize_at("weight", sum)
# 
# org.ID <- sort(unique(c(org.ALL.EL.p.all$Source, org.ALL.EL.p.all$Target)))
# org.Node.table.all <- data.frame(Id=org.ID, Label=org.ID, tech=substr(org.ID, 0,1))
# 
# # Network analysis
# org.summ.cen.all <- get.centrality(org.ALL.G.p.all) %>% 
#   mutate(qc_category = "all")
# 
# org.summ.cen.all <- org.summ.cen.all %>%
#   left_join(org_country_list %>%  
#               select(-c("pub")) %>% unique,
#             by=c("Id"="organization_cleaned"))
# save(org.summ.cen.all, file=paste0(dir,"/org.summ.cen.all_val.RData"))

# (전체) 기관 간 상위 10개 협력 
org.ALL.EL.total.all %>% arrange(desc(weight)) %>%
  head(10) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
            by=c("Source"="organization_cleaned")) %>%
  left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
            by=c("Source"="organization_cleaned")) %>%
  mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
  mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
  select(Source.country,Target.country,weight)
write.csv(org.ALL.EL.total.all %>% arrange(desc(weight)) %>%
            head(10) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            select(Source.country,Target.country,weight),
          file="Tables/(전체) 기관 간 상위 10개 협력.csv")

# Validation
write.csv(org.ALL.EL.total.all %>% arrange(desc(weight)) %>% 
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country) %>% unique,
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country) %>% unique,
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            select(Source.country,Target.country,weight),
          file=paste0(dir,"/pair_org_validation.csv"), row.names=FALSE)

# Organization - country list
org_country_list <- quant_inst_ed_eu_fixed_val %>% 
  group_by(organization_cleaned,country) %>% 
  summarize(pub=length(unique(pubid))) %>%
  filter(pub==max(pub))

### Weight version
w.org.table <- quant_inst_ed_eu_fixed_val %>%
  group_by(pubid) %>% mutate(count=length(unique(organization_cleaned))) %>%
  mutate(share=1/count) %>% ungroup %>%
  filter(count!=1) %>%
  group_by(pubid,organization_cleaned) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  select(-c("weight"))

i<-1
org.w.collabo.table <- 0
for (i in 1:length(unique(w.org.table$pubid))){ # 6138
  temp <- w.org.table[w.org.table$pubid==unique(w.org.table$pubid)[[i]],]
  temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$organization_cleaned, 2)))
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
save(org.w.collabo.table, file=paste0(dir,"/org.w.collabo.table.RData"))

org.ALL.G.p.all.weight <- graph.data.frame(org.w.collabo.table, directed=FALSE)
org.summ.cen.all.weight <- get.centrality(org.ALL.G.p.all.weight) %>% 
  mutate(qc_category = "all")
org.summ.cen.all.weight <- org.summ.cen.all.weight %>%
  left_join(org_country_list %>%  
              select(-c("pub")) %>% unique,
            by=c("Id"="organization_cleaned"))
save(org.summ.cen.all.weight, file=paste0(dir,"/org.summ.cen.all.weight.RData"))

# 그림 29 (기관 네트워크 - 유럽) 가중 연결 중심성 vs. 매개 중심성
org.summ.cen.all.weight %>% 
  mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(country %in% eu_country) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# 그림 30 (기관 네트워크 - 비유럽) 가중 연결 중심성 vs. 매개 중심성
org.summ.cen.all.weight %>% 
  mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(country %ni% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweeness Centrality") + theme_bw() 

# 그림 31 (기관 네트워크 - 비유럽, 한국) 가중 연결 중심성 vs. 매개중심성
org.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  filter(country %ni% eu_country) %>% arrange(desc(w.Deg)) %>% #data.frame %>% head(20)
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

# 그림 32 (기관 네트워크 - 유럽) 가중 연결 중심성 vs. 고유 벡터 중심성
org.summ.cen.all.weight %>% 
  mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %in% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw()

# 그림 33 (기관 네트워크 - 비유럽) 가중 연결 중심성 vs. 고유 벡터 중심성
org.summ.cen.all.weight %>% 
  mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %ni% eu_country) %>% 
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text(check_overlap = TRUE) + xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

# 그림 34 (기관 네트워크 - 비유럽, 한국) 가중 연결 중심성 vs. 고유 벡터 중심성
org.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  filter(country %ni% eu_country) %>% arrange(desc(w.Deg)) %>% #data.frame %>% head(20)
  mutate(label.kr = ifelse(country=="SOUTH KOREA",Id,NA)) %>%
  ggplot(aes(x=w.Deg, y=Eig, label=label.kr)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="blue") + 
  # geom_text(color="blue") +
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Eigenvector Centrality") + theme_bw() 

write.csv(summ.cen.all %>% data.frame, file=paste0(dir,"/network_measures_all_val.csv",
          row.names=FALSE))
write.csv(ALL.EL.p.all %>% data.frame, file=paste0(dir,"/qc_edges_all_val.csv",
          row.names=FALSE))
write.csv(Node.table.all %>% data.frame, file=paste0(dir,"/qc_nodes_all_val.csv",
          row.names=FALSE))

load(file=paste0(dir,"/ALL.G.p.all_val.RData"))
org.qc_network.all <- 
  org.w.collabo.table %>%   
  arrange(desc(weight)) %>% head(100) %>%
  ggnet2(size = "degree", label=FALSE, #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) + ggtitle("all")
org.qc_network.all
ggsave(filename=paste0(dir,"/org_network_all_val.png"), 
       plot=qc_network.all)

#### 유럽 - 비유럽 비교
# 상위 500개 기관 협력 네트워크 시각화
node_info <- org.country.sum %>%
  filter(main.country == "main") %>%
  select(organization_cleaned, country) %>% unique %>%
  mutate(color = ifelse(country %in% eu_country, "blue", "red"))

# 데이터 결합 및 필터링
graph_data <- org.w.collabo.table %>% # org.ALL.EL.total.all %>% 
  left_join(node_info %>% select(organization_cleaned, country, color), 
            by = c("Source" = "organization_cleaned")) %>% 
  rename(source.country = country, source.color = color) %>%
  left_join(node_info %>% select(organization_cleaned, country, color), 
            by = c("Target" = "organization_cleaned")) %>% 
  rename(target.country = country, target.color = color) %>%
  filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(500)

# 그래프 데이터프레임 생성
net <- graph.data.frame(graph_data, directed = FALSE)

# 노드 정보 추가 (source.color를 사용)
V(net)$color <- ifelse(V(net)$name %in% node_info$organization_cleaned, 
                       node_info$color[match(V(net)$name, node_info$organization_cleaned)], 
                       "grey")

# 그림 16 상위 500개 기관 협력 네트워크 시각화
ggnet2(net, size = "degree", color = "color", label = FALSE, label.size = 1.5,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE)

# Top 100
org.qc_network.eu <- 
  org.w.collabo.table %>% # org.ALL.EL.total.all %>% 
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(organization_cleaned, country) %>% unique,
            by=c("Source"="organization_cleaned")) %>% rename(source.country=country) %>%
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(organization_cleaned, country) %>% unique,
            by=c("Target"="organization_cleaned")) %>% rename(target.country=country) %>%
  filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(50) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size =1.5,
         label.trim=TRUE,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")
org.qc_network.eu
ggsave(filename=paste0(dir, "/org_network_eu_val.png"), 
       plot=qc_network.eu)

### Network per category (top 50)
i<-1
org.qc_network.cat <- list()
for(j in 1:length(unique(quant_inst_ed_eu_fixed_val$qc_category))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category==unique(qc_category)[j]) %>%
    group_by(pubid) %>% mutate(count=length(unique(organization_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>%
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  org.w.collabo.table.temp <- 0
  for (i in 1:length(unique(w.org.table.temp$pubid))){ # 6138
    temp <- w.org.table.temp[w.org.table.temp$pubid==unique(w.org.table.temp$pubid)[[i]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$organization_cleaned, 2)))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("APPLN_ID","Source","Target","share")
    
    org.w.collabo.table.temp <- rbind(org.w.collabo.table.temp,temp.1)
  }
  org.w.collabo.table.temp <- org.w.collabo.table.temp[2:nrow(org.w.collabo.table.temp),]
  org.w.collabo.table.temp <- org.w.collabo.table.temp %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  
  org.qc_network.cat[[j]] <- 
    org.w.collabo.table.temp %>% # org.ALL.EL.total.all %>% 
    left_join(org.country.sum %>%  
                filter(main.country=="main") %>%
                select(organization_cleaned, country) %>% unique,
              by=c("Source"="organization_cleaned")) %>% rename(source.country=country) %>%
    left_join(org.country.sum %>%  
                filter(main.country=="main") %>%
                select(organization_cleaned, country) %>% unique,
              by=c("Target"="organization_cleaned")) %>% rename(target.country=country) %>%
    filter(source.country %in% eu_country | target.country %in% eu_country) %>%
    arrange(desc(weight)) %>% head(100) %>%
    graph.data.frame(directed=FALSE) %>%
    ggnet2(size = "degree", label=TRUE, label.size =1.5,
           label.trim=TRUE,
           #edge.size = "degree", 
           alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
    guides(size=FALSE) + ggtitle(unique(quant_inst_ed_eu_fixed_val$qc_category)[j])
  org.qc_network.cat[[j]]
  ggsave(filename=paste0("Tables/분야별기관협력네트워크_",unique(quant_inst_ed_eu_fixed_val$qc_category)[j],".png"), 
         plot=org.qc_network.cat[[j]])
  print(j)
}

top.inst.df <- 
  data.frame(
    top.ctr=rep(top.country,each=5),
    label=top.inst)

top.inst.df %>% head(1)
top.inst.df$top.ctr %>% unique

# 상위 100개 협력 네트워크
library(dplyr)
library(igraph)
library(GGally)
library(intergraph)
library(network)

org.qc_network.eu.list <- list()
for(i in 1:length(top.country)){
  label_nodes <- top.inst.df %>% filter(top.ctr==top.country[i]) %>%
    select(label) %>% pull()
  
  org.qc_network.eu.list[[i]] <- 
    org.w.collabo.table %>% # org.ALL.EL.total.all %>% 
    left_join(org.country.sum %>% filter(country==top.country[i]) %>%
                filter(main.country=="main") %>%
                select(organization_cleaned, country) %>% unique,
              by=c("Source"="organization_cleaned")) %>% rename(source.country=country) %>%
    left_join(org.country.sum %>% filter(country==top.country[i]) %>% 
                filter(main.country=="main") %>%
                select(organization_cleaned, country) %>% unique,
              by=c("Target"="organization_cleaned")) %>% rename(target.country=country) %>%
    filter(source.country %in% eu_country | target.country %in% eu_country) %>%
    arrange(desc(weight)) %>% head(100) %>%
    graph.data.frame(directed=FALSE) %>%
    GGally::ggnet2(size = "degree", 
           label=ifelse(V(.)$name %in% label_nodes, V(.)$name, NA),# TRUE, 
           label.size =2.5,
           label.trim=TRUE,
           #edge.size = "degree", 
           alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
    guides(size=FALSE) + ggtitle(top.country[i])
  org.qc_network.eu.list[[i]]
  ggsave(filename=paste0("Tables/ctr_org_net_",top.country[i],".png"), 
         plot=org.qc_network.eu.list[[i]])
}

org.w.collabo.table %>% # org.ALL.EL.total.all %>% 
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(organization_cleaned, country) %>% unique,
            by=c("Source"="organization_cleaned")) %>% rename(source.country=country) %>%
  left_join(org.country.sum %>%  
              filter(main.country=="main") %>%
              select(organization_cleaned, country) %>% unique,
            by=c("Target"="organization_cleaned")) %>% rename(target.country=country) %>%
  # filter(source.country %in% eu_country | target.country %in% eu_country) %>%
  arrange(desc(weight)) %>% head(50) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=TRUE, label.size =2,
         label.trim=TRUE,
         #edge.size = "degree", 
         alpha=0.5, edge.color="grey", edge.alpha = 0.5) +
  guides(size=FALSE) #+ ggtitle("Top 100 EU country-collaborations")


### 한국-유럽 양자과학기술 협력 네트워크 (상위 100 개)
node_info <- org.country.sum %>%
  filter(main.country == "main") %>%
  select(organization_cleaned, country) %>% unique %>%
  mutate(color = ifelse(country == "SOUTH KOREA", "red", 
                        ifelse(country %in% eu_country, "blue", "grey")))

graph_data <- org.w.collabo.table %>% # org.ALL.EL.total.all %>% 
  left_join(node_info %>% select(organization_cleaned, country, color), 
            by = c("Source" = "organization_cleaned")) %>% 
  rename(source.country = country, source.color = color) %>%
  left_join(node_info %>% select(organization_cleaned, country, color), 
            by = c("Target" = "organization_cleaned")) %>% 
  rename(target.country = country, target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>% head(100)

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$organization_cleaned, 
                       node_info$color[match(V(net)$name, node_info$organization_cleaned)], 
                       "grey")

# 그림 39 한국-유럽 양자과학기술 기관 협력 네트워크 시각화 (상위 100 개)
ggnet2(net, size = "degree", color = "color", label = TRUE, label.size = 2,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) 

# 양자과학기술 1단계 분야별 기관 간 상위 협력
org.summ.cen.topcol.3 <- 0
i<-1
for(i in 1:length(c("qc1","qc2","qc3"))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
    mutate(qc3=substr(qc_category,1,3)) %>%
    filter(qc3==c("qc1","qc2","qc3")[i]) %>%
    group_by(pubid) %>% mutate(count=length(organization_cleaned)) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  # generating ID (1,2,3,4...) by Application ID
  org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  org.set.temp$compound <- as.factor(org.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  org.set.w.type <- spread(org.set.temp, compound, organization_cleaned)
  
  org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  # (기술별) 기관 간 상위 3개 협력 
  org.summ.cen.topcol.3 <- 
    rbind(org.summ.cen.topcol.3,
          org.ALL.EL.total.type %>% arrange(desc(weight)) %>%
            head(3) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            mutate(qc_category=c("qc1","qc2","qc3")[i]) %>%
            select(qc_category,Source.country,Target.country,weight)) 
  print(i)
}
org.summ.cen.topcol.3 <- org.summ.cen.topcol.3[2:nrow(org.summ.cen.topcol.3),]
org.summ.cen.topcol.3 %>% arrange(qc_category)
write.csv(org.summ.cen.topcol.3 %>% arrange(qc_category),
          file=paste0(
            "Tables/양자과학기술 1단계 분야별 기관 간 상위 협력.csv"))

# 양자과학기술 2단계 분야별 기관 간 상위 협력
org.summ.cen.topcol.4 <- 0
substr(quant_inst_ed_eu_fixed_val$qc_category,1,4) %>% unique %>% sort
for(i in 1:length(c("qc11","qc12","qc13","qc14","qc21","qc22"))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
    mutate(qc4=substr(qc_category,1,4)) %>%
    filter(qc4==c("qc11","qc12","qc13","qc14","qc21","qc22")[i]) %>%
    group_by(pubid) %>% mutate(count=length(organization_cleaned )) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  # generating ID (1,2,3,4...) by Application ID
  org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  org.set.temp$compound <- as.factor(org.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  org.set.w.type <- spread(org.set.temp, compound, organization_cleaned)
  
  org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  # (기술별) 기관 간 상위 3개 협력 
  org.summ.cen.topcol.4 <- 
    rbind(org.summ.cen.topcol.4,
          org.ALL.EL.total.type %>% arrange(desc(weight)) %>%
            head(3) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            mutate(qc_category=c("qc11","qc12","qc13","qc14","qc21","qc22")[i]) %>%
            select(qc_category,Source.country,Target.country,weight)) 
  print(i)
}
org.summ.cen.topcol.4 <- org.summ.cen.topcol.4[2:nrow(org.summ.cen.topcol.4),]
org.summ.cen.topcol.4 %>% arrange(qc_category)
write.csv(org.summ.cen.topcol.4 %>% arrange(qc_category),
          file=paste0("Tables/양자과학기술 2단계 분야별 기관 간 상위 협력.csv"))

# 양자과학기술 3단계 분야별 기관 간 상위 협력
org.summ.cen.topcol <- 0
i<-16
for(i in 1:length(unique(quant_inst_ed_eu_fixed_val$qc_category))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
    filter(qc_category==unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(organization_cleaned)) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  # generating ID (1,2,3,4...) by Application ID
  org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  org.set.temp$compound <- as.factor(org.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  org.set.w.type <- spread(org.set.temp, compound, organization_cleaned)
  
  org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  # (기술별) 기관 간 상위 3개 협력 
  org.summ.cen.topcol <- 
    rbind(org.summ.cen.topcol,
          org.ALL.EL.total.type %>% arrange(desc(weight)) %>%
            head(3) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            mutate(qc_category=unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
            select(qc_category,Source.country,Target.country,weight)) 
  print(i)
}
org.summ.cen.topcol <- org.summ.cen.topcol[2:nrow(org.summ.cen.topcol),]
org.summ.cen.topcol %>% arrange(qc_category)
write.csv(org.summ.cen.topcol %>% arrange(qc_category) %>%
            filter(qc_category %in% c("qc311","qc312","qc314","qc315","qc32")),
          file=paste0("Tables/양자과학기술 3단계 분야별 기관 간 상위 협력.csv"))

# 양자과학기술 1단계 분야별 중심성 지수별 상위 기관 목록
org.summ.cen.toprank.3 <- 0
for (i in 1:length(c("qc1","qc2","qc3"))) {
  qc_pick <- c("qc1","qc2","qc3")[i]
  
  # 원본에서 이번 라운드(qc3) 대상만 추려서 기관-국가 매핑 준비
  org_country_map <- quant_inst_ed_eu_fixed_val %>%
    mutate(qc3 = substr(qc_category, 1, 3)) %>%
    filter(qc3 == qc_pick) %>%
    distinct(organization_cleaned, country)
  
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    mutate(qc3 = substr(qc_category, 1, 3)) %>%
    filter(qc3 == qc_pick) %>%
    group_by(pubid) %>% mutate(count = length(unique(organization_cleaned))) %>%  
    mutate(share = 1/count) %>% ungroup() %>%
    filter(count != 1) %>% 
    group_by(pubid, organization_cleaned) %>%
    dplyr::summarise(weight = sum(share), .groups = "drop") %>%
    select(-weight)   # 원래 코드 유지(가중치 미사용)
  
  org.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.org.table.temp$pubid))) { 
    temp <- w.org.table.temp[w.org.table.temp$pubid == unique(w.org.table.temp$pubid)[[j]], ]
    temp.1 <- data.frame(unique(temp$pubid), t(combn(temp$organization_cleaned, 2)))
    temp.1 %<>% mutate(share = 1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    org.w.collabo.table.type <- rbind(org.w.collabo.table.type, temp.1)
  }
  org.w.collabo.table.type <- org.w.collabo.table.type[2:nrow(org.w.collabo.table.type), ]
  org.w.collabo.table.type <- org.w.collabo.table.type %>% 
    group_by(Source, Target) %>%
    dplyr::summarise(weight = sum(share), .groups = "drop")
  
  org.ALL.EL.total.type <- graph.data.frame(org.w.collabo.table.type, directed = FALSE)
  
  # 중앙성 계산
  org.summ.cen.type <- get.centrality(org.ALL.EL.total.type) %>% 
    mutate(qc_category = qc_pick) %>%
    left_join(org_country_map, by = c("Id" = "organization_cleaned")) %>%
    mutate(Id_country = paste(Id, country, sep = " - "))
  
  # 여기서 국가정보 조인: Id(노드명) ~ organization_cleaned
  org.summ.cen.type <- org.summ.cen.type %>%
    left_join(org_country_map, by = c("Id" = "organization_cleaned"))
  
  # 기관명/국가를 별도 컬럼으로 보존하여 top-3 테이블 구성
  # (원래처럼 w.Deg 등에 Id를 덮어쓰지 않고 *_org / *_country로 분리)
  org.summ.cen.toprank.3 <- rbind(
    org.summ.cen.toprank.3,
    org.summ.cen.type %>%
      arrange(desc(w.Deg)) %>% head(3) %>%
      mutate(Rank = 1:n(),
             w.Deg = Id_country) %>%   # 기관+국가 합친 컬럼 사용
      select(qc_category, Rank, w.Deg) %>%
      left_join(
        org.summ.cen.type %>%
          arrange(desc(Btw)) %>% head(3) %>%
          mutate(Rank = 1:n(),
                 Btw = Id_country) %>%
          select(Rank, Btw),
        by = "Rank"
      ) %>%
      left_join(
        org.summ.cen.type %>%
          arrange(desc(Eig)) %>% head(3) %>%
          mutate(Rank = 1:n(),
                 Eig = Id_country) %>%
          select(Rank, Eig),
        by = "Rank"
      ) %>% data.frame()
  )
}
org.summ.cen.toprank.3 <- org.summ.cen.toprank.3[2:nrow(org.summ.cen.toprank.3),]
org.summ.cen.toprank.3 %>% arrange(qc_category, Rank)
write.csv(org.summ.cen.toprank.3 %>% arrange(qc_category),
          file=paste0("Tables/양자과학기술 1단계 분야별 중심성 지수별 상위 기관 목록.csv"))

# 양자과학기술 2단계 분야별 중심성 지수별 상위 기관 목록
org.summ.cen.toprank.4 <- 0
for(i in 1:length(c("qc11","qc12","qc13","qc14","qc21","qc22"))){
  cats <- c("qc11","qc12","qc13","qc14","qc21","qc22")
  
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    mutate(qc4 = substr(qc_category, 1, 4)) %>%
    filter(qc4 == cats[i]) %>%
    group_by(pubid) %>% mutate(count = length(unique(organization_cleaned))) %>%
    mutate(share = 1/count) %>% ungroup %>%
    filter(count != 1) %>% 
    # 조직-국가 쌍 유지 (중복 방지)
    group_by(pubid, organization_cleaned, country) %>%
    dplyr::summarise(weight = sum(share), .groups = "drop") %>%
    select(-weight)
  
  # 각 org의 대표 국가 매핑(가장 자주 등장하는 국가를 대표값으로)
  org_country_map <- w.org.table.temp %>%
    count(organization_cleaned, country, sort = TRUE) %>%
    group_by(organization_cleaned) %>%
    slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    dplyr::rename(Id = organization_cleaned)
  
  org.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.org.table.temp$pubid))){ 
    temp <- w.org.table.temp[w.org.table.temp$pubid == unique(w.org.table.temp$pubid)[[j]], ]
    
    # 조직-국가 목록
    orgs <- unique(temp[, c("organization_cleaned","country")])
    orgs <- orgs[order(orgs$organization_cleaned), , drop = FALSE]
    
    idx <- combn(seq_len(nrow(orgs)), 2)
    
    temp.1 <- data.frame(
      pubid          = rep(unique(temp$pubid), ncol(idx)),
      Source         = orgs$organization_cleaned[idx[1, ]],
      Target         = orgs$organization_cleaned[idx[2, ]],
      Source_country = orgs$country[idx[1, ]],
      Target_country = orgs$country[idx[2, ]]
    )
    
    temp.1$share <- 1 / nrow(temp.1)
    names(temp.1) <- c("pubid","Source","Target","Source_country","Target_country","share")
    org.w.collabo.table.type <- rbind(org.w.collabo.table.type, temp.1)
  }
  org.w.collabo.table.type <- org.w.collabo.table.type[2:nrow(org.w.collabo.table.type),]
  
  org.w.collabo.table.type <- org.w.collabo.table.type %>% 
    group_by(Source, Target, Source_country, Target_country) %>%
    dplyr::summarise(weight = sum(share), .groups = "drop")
  
  # 그래프 생성 (정점=조직명; 국가 정보는 간선 속성으로 유지)
  org.ALL.EL.total.type <- graph.data.frame(org.w.collabo.table.type, directed = FALSE)
  
  # 중심성 계산 (기존 함수 유지)
  org.summ.cen.type <- get.centrality(org.ALL.EL.total.type) %>% 
    mutate(qc_category = cats[i]) %>%
    # 정점(Id) 기준으로 대표 국가 매핑
    left_join(org_country_map, by = "Id") %>%
    dplyr::rename(country = country)
  
  # ---- Top 3 요약 (기존 형식 유지 + 국가 컬럼 추가) ----
  top_deg <- org.summ.cen.type %>% arrange(desc(w.Deg)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           w.Deg = paste0(Id, " - ", country)) %>%
    select(Rank, w.Deg)
  
  top_btw <- org.summ.cen.type %>% arrange(desc(Btw)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Btw = paste0(Id, " - ", country)) %>%
    select(Rank, Btw)
  
  top_eig <- org.summ.cen.type %>% arrange(desc(Eig)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Eig = paste0(Id, " - ", country)) %>%
    select(Rank, Eig)
  
  out_tbl <- top_deg %>%
    left_join(top_btw, by = "Rank") %>%
    left_join(top_eig, by = "Rank") %>%
    mutate(qc_category = cats[i]) %>%
    select(qc_category, Rank, w.Deg, Btw, Eig) %>%
    data.frame()
  
  org.summ.cen.toprank.4 <- rbind(org.summ.cen.toprank.4, out_tbl)
}
org.summ.cen.toprank.4 <- org.summ.cen.toprank.4[2:nrow(org.summ.cen.toprank.4),]
org.summ.cen.toprank.4 %>% arrange(qc_category, Rank)
write.csv(org.summ.cen.toprank.4 %>% arrange(qc_category),
          file=paste0("Tables/양자과학기술 2단계 분야별 중심성 지수별 상위 기관 목록.csv"))

# 양자컴퓨팅 3단계 분야별 중심성 지수별 상위 기관 목록
org.summ.cen.toprank <- 0
for(i in 1:length(unique(quant_inst_ed_eu_fixed_val$qc_category))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category == unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count = length(unique(organization_cleaned))) %>%
    mutate(share = 1/count) %>% ungroup %>%
    filter(count != 1) %>%
    group_by(pubid, organization_cleaned) %>%
    dplyr::summarise(weight = sum(share)) %>% ungroup %>%
    select(-weight)
  
  org.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.org.table.temp$pubid))) {
    temp <- w.org.table.temp[w.org.table.temp$pubid == unique(w.org.table.temp$pubid)[[j]], ]
    temp.1 <- data.frame(unique(temp$pubid), t(combn(temp$organization_cleaned, 2)))
    temp.1 %<>% mutate(share = 1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    org.w.collabo.table.type <- rbind(org.w.collabo.table.type, temp.1)
  }
  org.w.collabo.table.type <- org.w.collabo.table.type[2:nrow(org.w.collabo.table.type), ]
  org.w.collabo.table.type <- org.w.collabo.table.type %>%
    group_by(Source, Target) %>%
    dplyr::summarise(weight = sum(share), .groups = "drop")
  
  org.ALL.EL.total.type <- graph.data.frame(org.w.collabo.table.type, directed = FALSE)
  org.summ.cen.type <- get.centrality(org.ALL.EL.total.type) %>%
    mutate(qc_category = unique(quant_inst_ed_eu_fixed_val$qc_category)[i])
  
  org_country_map <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category == unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    count(organization_cleaned, country, sort = TRUE) %>%
    group_by(organization_cleaned) %>%
    slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    transmute(Id = organization_cleaned,
              country = ifelse(is.na(country) | country == "", "UNKNOWN", country))
  
  org.summ.cen.type <- org.summ.cen.type %>%
    left_join(org_country_map, by = "Id")
  
  top_deg <- org.summ.cen.type %>% arrange(desc(w.Deg)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           w.Deg = paste0(Id, " - ", country)) %>%
    select(Rank, w.Deg)
  
  top_btw <- org.summ.cen.type %>% arrange(desc(Btw)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Btw = paste0(Id, " - ", country)) %>%
    select(Rank, Btw)
  
  top_eig <- org.summ.cen.type %>% arrange(desc(Eig)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Eig = paste0(Id, " - ", country)) %>%
    select(Rank, Eig)
  
  out_tbl <- top_deg %>%
    left_join(top_btw, by = "Rank") %>%
    left_join(top_eig, by = "Rank") %>%
    mutate(qc_category = unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    select(qc_category, Rank, w.Deg, Btw, Eig) %>%
    data.frame()
  
  org.summ.cen.toprank <- rbind(org.summ.cen.toprank, out_tbl)
  
}
org.summ.cen.toprank <- org.summ.cen.toprank[2:nrow(org.summ.cen.toprank),]
org.summ.cen.toprank %>% arrange(qc_category, Rank)
write.csv(org.summ.cen.toprank %>% arrange(qc_category) %>%
            filter(qc_category %in% c("qc311","qc312","qc314","qc315","qc32")),
          file=paste0("Tables/양자과학기술 3단계 분야별 중심성 지수별 상위 기관 목록.csv"))

org.summ.cen.toprank %>% arrange(qc_category, Rank) %>%
  write.csv(file="inst_net_top_cen.csv")


###########################################################################
### Researcher-level analysis
###########################################################################

res.country.sum <- quant_author_ed_eu_val_cleaned %>% 
  group_by(author_id_te_cleaned,full_name) %>% 
  summarize(pub.count=length(unique(pubid)))

# 양자과학기술 내 논문별 평균 연구자 수
quant_author_ed_eu_val_cleaned %>% group_by(pubid) %>%
  summarize(count=length(unique(author_id_te_cleaned))) %>%
  ungroup %>% summarize(avg=mean(count),max=max(count), min=min(count)) 

# 양자과학기술 내 분야별 논문 평균 연구자 수
quant_author_ed_eu_val_cleaned %>% group_by(qc_category,pubid) %>%
  summarize(count=length(unique(author_id_te_cleaned))) %>%
  ungroup %>% 
  mutate(type=substr(qc_category,1,3)) %>%
  group_by(type) %>% summarize(count=mean(count)) %>%
  arrange(type) %>% data.frame

#### Fix Korean cases
# Filter by Korean names
quant_author_ed_eu_val_cleaned %>% filter(country=="SOUTH KOREA") %>%
  select(pubid) %>% unique

korean_surnames <- c("Kang","Moon","Kim","Lim","Lee","Oh","Song","Chong",
                     "Hong","Shin","Kwon","Park","Jeong","Jang","Cho","Eom",
                     "Chung","Jung","Jeon","Paik","Han","Cheong","Joo","Jo",
                     "Son","Yang","Im","Nha","Yoon","Sung","Chow","An","Ann",
                     "Bae","Cheung","Choi","Gong","Jee","Ko","Ra")

korea.res <- quant_author_ed_eu_val_cleaned %>%
  filter(country == "SOUTH KOREA") %>%
  select(pubid) %>% distinct() %>%
  left_join(quant_author_ed_eu_val_cleaned, by = "pubid") %>%
  filter(str_detect(full_name, str_c("\\b(", str_c(korean_surnames, collapse="|"), ")\\b")))

korea.res %>% select(author_id_te) %>% unique %>% nrow

i<-1   
kor.res.org <- 0
for(i in 1:length(unique(korea.res$author_id_te_cleaned))){
  temp <- korea.res %>% filter(author_id_te==unique(korea.res$author_id_te_cleaned)[i])
  kor.res.org <- 
    rbind(kor.res.org,
          temp %>% 
            left_join(quant_inst_ed_eu_fixed_val %>% filter(country=="SOUTH KOREA") %>%
                        select(pubid,organization_cleaned,country) %>% unique))
  print(i)
}
kor.res.org <- kor.res.org[2:nrow(kor.res.org),]
kor.res.org %>% select(author_id_te_cleaned) %>% unique %>% nrow

# 한국인 연구자
kor.res.per <- quant_author_ed_eu_val_cleaned %>% 
  filter(str_detect(full_name, str_c("\\b(", str_c(korean_surnames, collapse="|"), ")\\b")))

kor.res.per <- kor.res.per %>%
  filter(full_name %in% c("Paik, Hanhee","Kim, Na Young","Lee, Minjoo Larry","Jung, Daehwan", "Choi, D. -Y.",
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
  select(author_id_te_cleaned, full_name) %>% unique %>% nrow

kor.reg.all <- 
  rbind(kor.res.org %>% select(author_id_te_cleaned, full_name) %>% unique, 
        kor.res.per %>% select(author_id_te_cleaned, full_name) %>% unique) %>% unique

kor.reg.all <- kor.reg.all %>%
  inner_join(quant_author_ed_eu_val_cleaned)

# 상위 한국-유럽 협력 한국인 연구자
kor.reg.all %>% 
  # inner_join(res.inst.sum) %>%
  group_by(author_id_te_cleaned, full_name, organization_cleaned) %>%
  summarize(count=length(unique(pubid))) %>%
  arrange(desc(count)) %>% data.frame %>% head(10) %>%
  write.csv(file="Tables/상위 한국-유럽 협력 한국인 연구자.csv")

quant_author_ed_eu_val_cleaned %>% filter(author_id_te_cleaned==18148647) %>%
  # select(pubid) %>% unique %>% nrow
  select(pubid) %>% head(2) %>%
  # inner_join(quant_pub_ed_eu_val)
  inner_join(quant_inst_ed_eu_fixed_val)

################################################################

quant_author_ed_eu_val_cleaned %>% 
  group_by(qc_category, author_id_te_cleaned, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  slice(1) %>% data.frame

# (1단계) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val_cleaned %>% 
  mutate(qc3=substr(qc_category,1,3)) %>%
  group_by(qc3, author_id_te_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc3) %>% 
  arrange(qc3,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                       organization_cleaned, country) %>% unique) %>%
  filter(country %in% eu_country) %>% 
  slice(1:3) %>% data.frame %>% unique 
write.csv(quant_author_ed_eu_val_cleaned %>% 
            mutate(qc3=substr(qc_category,1,3)) %>%
            group_by(qc3, author_id_te_cleaned) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup %>%
            group_by(qc3) %>% 
            arrange(qc3,desc(pub)) %>% 
            # inner_join(res.inst.sum) %>% 
            inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                                 organization_cleaned, country) %>% unique) %>%
            filter(country %in% eu_country) %>% 
            slice(1:3) %>% data.frame %>% unique ,
          file="Tables/(1단계) 양자과학기술 분야별 상위 연구자.csv")

# (2단계) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val_cleaned %>% 
  mutate(qc4=substr(qc_category,1,4)) %>%
  group_by(qc4, author_id_te_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc4) %>% 
  arrange(qc4,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                       organization_cleaned, country) %>% unique) %>%
  filter(country %in% eu_country) %>% 
  slice(1:5) %>% data.frame %>% unique 
write.csv(quant_author_ed_eu_val_cleaned %>% 
            mutate(qc4=substr(qc_category,1,4)) %>%
            group_by(qc4, author_id_te_cleaned) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup %>%
            group_by(qc4) %>% 
            arrange(qc4,desc(pub)) %>% 
            # inner_join(res.inst.sum) %>% 
            inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                                 organization_cleaned, country) %>% unique) %>%
            filter(country %in% eu_country) %>% 
            slice(1:3) %>% data.frame %>% unique,
          file="Tables/(2단계) 양자과학기술 분야별 상위 연구자.csv")

# (3단계) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val_cleaned %>% 
  group_by(qc_category, author_id_te_cleaned) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                       organization_cleaned, country) %>% unique) %>%
  filter(country %in% eu_country) %>% 
  slice(1:5) %>% data.frame %>% unique 
write.csv(quant_author_ed_eu_val_cleaned %>% 
            group_by(qc_category, author_id_te_cleaned) %>%
            summarize(pub = length(unique(pubid))) %>% ungroup %>%
            group_by(qc_category) %>% 
            arrange(qc_category,desc(pub)) %>% 
            # inner_join(res.inst.sum) %>% 
            inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                                 organization_cleaned, country) %>% unique) %>%
            filter(country %in% eu_country) %>% 
            slice(1:3) %>% data.frame %>% unique ,
          file="Tables/(3단계) 양자과학기술 분야별 상위 연구자.csv")

# (비유럽) 양자과학기술 분야별 상위 연구자
quant_author_ed_eu_val_cleaned %>% 
  group_by(qc_category, author_id_te_cleaned, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                       organization_cleaned, country) %>% unique) %>%
  filter(country %ni% eu_country) %>%
  slice(1) %>% data.frame

quant_author_ed_eu_val_cleaned %>% filter(country=="SOUTH KOREA") %>% 
  select(author_id_te_cleaned) %>% unique %>% nrow

# 분야별 상위 연구자
quant_author_ed_eu_val_cleaned %>% 
  group_by(qc_category, author_id_te_cleaned, full_name) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup %>%
  group_by(qc_category) %>% 
  arrange(qc_category,desc(pub)) %>% 
  # inner_join(res.inst.sum) %>% 
  inner_join(quant_author_ed_eu_val_cleaned %>% select(author_id_te_cleaned, full_name,
                                                       organization_cleaned, country) %>% unique) %>%
  filter(country %in% eu_country) %>%
  slice(1) %>% data.frame 

##########################################
### All 
w.res.table <- quant_author_ed_eu_val_cleaned %>% 
  group_by(pubid) %>% mutate(count=length(author_id_te_cleaned)) %>%
  mutate(share=1/count) %>% ungroup %>%
  group_by(pubid,author_id_te_cleaned) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  filter(weight!=1) %>%
  select(-c("weight")) 

# generating ID (1,2,3,4...) by Application ID
res.set <- getanID(w.res.table, id.vars = "pubid")
colnames(res.set)[colnames(res.set)==".id"] <- "compound"
res.set$compound <- as.factor(res.set$compound)

# create CPC matrix: each row shows individual patent's list of CPCs
res.set.w <- spread(res.set, compound, author_id_te_cleaned)

res.ALL.EL.total.all <- getting.edgelist.local(res.set.w)
res.ALL.EL.total.all %<>% dplyr::rename(weight=Weight)

top.res.list <- res.ALL.EL.total.all %>% arrange(desc(weight)) %>% 
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name) %>% unique, 
            by=c("Source"="author_id_te_cleaned")) %>% 
  rename(Source_full_name = full_name) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name) %>% unique, 
            by=c("Target"="author_id_te_cleaned")) %>% 
  rename(Target_full_name = full_name) %>%
  head(10) %>% 
  left_join(quant_author_ed_eu_val_cleaned  %>% rename(Source.country=country, Source.inst=organization_cleaned) %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, Source.inst,Source.country),
            by=c("Source"="author_id_te_cleaned")) %>%
  left_join(quant_author_ed_eu_val_cleaned  %>% rename(Target.country=country, Target.inst=organization_cleaned) %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, Target.inst,Target.country),
            by=c("Target"="author_id_te_cleaned")) %>%
  mutate(Source.inst = paste0(Source_full_name," (",Source.inst,")")) %>%
  mutate(Target.inst = paste0(Target_full_name," (",Target.inst,")")) %>%
  unique
top.res.list %>%
  select(Source, Target, Source.inst, Target.inst, weight) %>% unique
top.res.list %>%
  select(Source, Target, Source_full_name, Target_full_name, weight)

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
  temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te_cleaned, 2)))
  # temp.1 %<>% left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X1"="Region")) %>%
  #   left_join(inv.w.collabo.table.dup.list %>% filter(APPLN_ID==unique(inv.w.collabo.table.dup.list$APPLN_ID)[[i]]) %>% select(Inventor,share),by=c("X2"="Region"))
  temp.1 %<>% mutate(share=1/nrow(temp.1),pub=length(unique(unique.temp.pubid.)))
  names(temp.1) <- c("APPLN_ID","Source","Target","share","pub")
  
  res.w.collabo.table <- rbind(res.w.collabo.table,temp.1)
  print(i)
}
res.w.collabo.table <- res.w.collabo.table[2:nrow(res.w.collabo.table),]
res.w.collabo.table <- res.w.collabo.table %>% 
  group_by(Source,Target) %>%
  dplyr::summarise(weight=sum(share),pub=sum(pub))
save(res.w.collabo.table, file="R file/res.w.collabo.table.RData")

res.ALL.G.p.all.weight <- 
  graph.data.frame(res.w.collabo.table %>% select(-c("pub")), 
                   directed=FALSE)
res.summ.cen.all.weight <- get.centrality(res.ALL.G.p.all.weight) %>% 
  mutate(qc_category = "all")
save(res.summ.cen.all.weight, file="R file/res.summ.cen.all.weight.RData")

### (전체) 연구자간 상위 협력
w.res.table %>% head
res.w.collabo.table %>% head
res.w.collabo.table %>% arrange(desc(pub)) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.numeric(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name, organization_cleaned) %>% unique, 
            by=c("Source"="author_id_te_cleaned")) %>% 
  rename(Source_full_name = full_name, Source.inst=organization_cleaned) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.numeric(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name, organization_cleaned) %>% unique, 
            by=c("Target"="author_id_te_cleaned")) %>% 
  rename(Target_full_name = full_name, Target.inst=organization_cleaned) %>%
  write.csv(file="Tables/(전체) 연구자 간 상위 10개 협력.csv")

###
# 표 38 한-유럽 연구자 간 상위 협력
res.ALL.EL.p.all %>%
  # res.w.collabo.table %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name, organization_cleaned) %>% unique, 
            by=c("Source"="author_id_te_cleaned")) %>% 
  rename(Source_full_name = full_name, Source.inst=organization_cleaned) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned, full_name, organization_cleaned) %>% unique, 
            by=c("Target"="author_id_te_cleaned")) %>% 
  rename(Target_full_name = full_name, Target.inst=organization_cleaned) %>%
  left_join(kor.reg.all %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned) %>% unique %>% mutate(Source_kor="kor"),
            by=c("Source"="author_id_te_cleaned")) %>%
  left_join(kor.reg.all %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned) %>% unique %>% mutate(Target_kor="kor"),
            by=c("Target"="author_id_te_cleaned")) %>%
  mutate(Source.inst = paste0(Source_full_name," (",Source.inst,")")) %>%
  mutate(Target.inst = paste0(Target_full_name," (",Target.inst,")")) %>%
  filter(is.na(Source_kor)==FALSE | is.na(Target_kor)==FALSE) %>%
  arrange(desc(weight)) %>% data.frame %>% 
  head(10) %>% 
  write.csv(file="Tables/한-유럽 연구자 간 상위 협력.csv")

# 표 39 한-유럽 연구자 간 상위 중심성 지수별 연구자 목록
res.summ.cen.all.weight %>%
  left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned,full_name,organization_cleaned,country) %>% unique,
            by=c("Id"="author_id_te_cleaned")) %>%
  left_join(kor.reg.all %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>% 
              select(author_id_te_cleaned) %>% unique %>% mutate(kor="kor"),
            by=c("Id"="author_id_te_cleaned")) %>% 
  mutate(res.inst = paste0(full_name," (",organization_cleaned,")")) %>%
  arrange(desc(Deg)) %>% filter(is.na(kor)==FALSE) %>%
  head(3) %>% mutate(Rank=1:n()) %>%  select(Rank, res.inst) %>% rename(w.Deg=res.inst) %>%  
  left_join(res.summ.cen.all.weight %>%
              left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                          select(author_id_te_cleaned,full_name,organization_cleaned,country) %>% unique,
                        by=c("Id"="author_id_te_cleaned")) %>%
              left_join(kor.reg.all %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>% 
                          select(author_id_te_cleaned) %>% unique %>% mutate(kor="kor"),
                        by=c("Id"="author_id_te_cleaned")) %>% 
              mutate(res.inst = paste0(full_name," (",organization_cleaned,")")) %>%
              arrange(desc(Btw)) %>% filter(is.na(kor)==FALSE) %>%
              head(3) %>% mutate(Rank=1:n()) %>%  select(Rank, res.inst) %>% rename(Btw=res.inst)) %>%
  left_join(res.summ.cen.all.weight %>%
              left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                          select(author_id_te_cleaned,full_name,organization_cleaned,country) %>% unique,
                        by=c("Id"="author_id_te_cleaned")) %>%
              left_join(kor.reg.all %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>% 
                          select(author_id_te_cleaned) %>% unique %>% mutate(kor="kor"),
                        by=c("Id"="author_id_te_cleaned")) %>% 
              mutate(res.inst = paste0(full_name," (",organization_cleaned,")")) %>%
              arrange(desc(Eig)) %>% filter(is.na(kor)==FALSE) %>%
              head(3) %>% mutate(Rank=1:n()) %>%  select(Rank, res.inst) %>% rename(Eig=res.inst)) %>%
  write.csv(file="Tables/한-유럽 연구자 간 상위 중심성 지수별 연구자 목록.csv")

# (연구자 네트워크 - 전체) 가중연결중심성 vs. 매개중심성
res.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% 
              mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
              select(author_id_te_cleaned,pubid,full_name,qc_category) %>% unique %>%
              rename(label=qc_category),
            by=c("Id"="author_id_te_cleaned")) %>%
  # filter(country %in% eu_country & main.country=="main") %>% 
  ggplot(aes(x=w.Deg, y=Btw, label=full_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point() +
  # geom_text(check_overlap = TRUE) + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

# 그림 37 (연구자 네트워크 - 유럽) 가중 연결 중심성 vs. 매개 중심성
res.summ.cen.all.weight %>% 
  mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # left_join(quant_author_ed_eu_val %>% 
  #             mutate(author_id_te=as.character(author_id_te)) %>%
  #             select(author_id_te,display_name) %>% unique,
  #           by=c("Id"="author_id_te")) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>% 
              ungroup %>% 
              select(author_id_te_cleaned,full_name,organization_cleaned,country),
            by=c("Id"="author_id_te_cleaned")) %>%
  # filter(country %in% eu_country & main.country=="main") %>%# arrange(desc(Btw)) 
  filter(country %in% eu_country) %>%# arrange(desc(Btw)) 
  mutate(label.kr = ifelse(country=="SOUTH KOREA",full_name,NA)) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=full_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="black") + 
  xlab("Weighted Degree Centrality") +
  ylab("Betweenness Centrality") + theme_bw()

# 그림 38 (연구자 네트워크 - 비유럽) 가중연결중심성 vs. 매개중심성
res.summ.cen.all.weight %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  # left_join(quant_author_ed_eu_val %>% 
  #             mutate(author_id_te=as.character(author_id_te)) %>%
  #             select(author_id_te,pubid,display_name,qc_category) %>% unique %>%
  #             rename(label=qc_category),
  #           by=c("Id"="author_id_te")) %>%
  left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>% 
              ungroup %>% 
              select(author_id_te_cleaned,full_name,organization_cleaned,country),
            by=c("Id"="author_id_te_cleaned")) %>%
  # filter(country %ni% eu_country & main.country=="main") %>% # arrange(desc(Btw))
  filter(country %ni% eu_country) %>% # arrange(desc(Btw))
  mutate(label.kr = ifelse(country=="SOUTH KOREA",full_name,NA)) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=full_name)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  geom_point(color="gray") +
  geom_text(check_overlap = TRUE,color="blue") + 
  xlab("Weighted Degree Centrality") +
  scale_x_continuous(limits = c(0, 1))+
  scale_y_continuous(limits = c(0, 1)) +
  ylab("Betweenness Centrality") + theme_bw()

### 한국 기관 연구자 네트워크
node_info <- quant_author_ed_eu_val_cleaned %>%
  # res.inst.sum %>%
  # filter(main.country == "main") %>%
  select(author_id_te_cleaned, full_name, organization_cleaned, country) %>% unique %>%
  mutate(color = ifelse(country == "SOUTH KOREA", "red",
                        ifelse(country %in% eu_country, "blue", "grey")))

top.kor.res <- res.w.collabo.table %>%
  # res.ALL.EL.p.all %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Source" = "author_id_te_cleaned")) %>%
  rename(source.res = full_name, source.country = country, 
         source.color = color) %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Target" = "author_id_te_cleaned")) %>%
  rename(target.res = full_name, target.country = country, 
         target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>%
  group_by(Source,Target,source.res,target.res,source.country,target.country,source.color,target.color) %>%
  summarize(weight=sum(weight)) %>% arrange(desc(weight)) %>%
  graph_from_data_frame(directed = FALSE) %>%
  get.centrality %>% arrange(desc(w.Deg))

graph_data <- res.w.collabo.table %>%
  # res.ALL.EL.p.all %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Source" = "author_id_te_cleaned")) %>%
  rename(source.res = full_name, source.country = country, 
         source.color = color) %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Target" = "author_id_te_cleaned")) %>%
  rename(target.res = full_name, target.country = country, 
         target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>%
  group_by(Source,Target,source.res,target.res,source.country,target.country,source.color,target.color) %>%
  summarize(weight=sum(weight)) %>% arrange(desc(weight)) %>% 
  filter(Source %in% top.kor.res$Id[1:100] & Target %in% top.kor.res$Id[1:100])

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$author_id_te,
                       node_info$color[match(V(net)$name, node_info$author_id_te)],
                       "grey")

V(net)$full_name <- ifelse(V(net)$name %in% node_info$author_id_te_cleaned,
                              node_info$full_name[match(V(net)$name, node_info$author_id_te_cleaned)],
                              V(net)$name) # 매칭 안 될 경우 기본값은 name

ggnet2(net, size = "degree", color = "color", label =  V(net)$full_name, #TRUE
       label.size = 3,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) +
  ggtitle("all")

# 그림 40 유럽 내 한국인 양자과학기술 연구자 협력 네트워크 시각화 
node_info <- quant_author_ed_eu_val_cleaned %>%
  # res.inst.sum %>%
  # filter(main.country == "main") %>%
  select(author_id_te_cleaned, full_name, organization_cleaned, country) %>% unique %>%
  mutate(color = ifelse(author_id_te_cleaned %in% kor.reg.all$author_id_te_cleaned, "red","blue"))

top.kor.res <- res.w.collabo.table %>%
  # res.ALL.EL.p.all %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Source" = "author_id_te_cleaned")) %>%
  rename(source.res = full_name, source.country = country, 
         source.color = color) %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Target" = "author_id_te_cleaned")) %>%
  rename(target.res = full_name, target.country = country, 
         target.color = color) %>%
  filter(Source %in% kor.reg.all$author_id_te_cleaned | Target %in% kor.reg.all$author_id_te_cleaned) %>%
  arrange(desc(weight)) %>%
  group_by(Source,Target,source.res,target.res,source.country,target.country,source.color,target.color) %>%
  summarize(weight=sum(weight)) %>% arrange(desc(weight)) %>%
  graph_from_data_frame(directed = FALSE) %>%
  get.centrality %>% arrange(desc(w.Deg))

graph_data <- res.w.collabo.table %>%
  # res.ALL.EL.p.all %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>% 
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Source" = "author_id_te_cleaned")) %>%
  rename(source.res = full_name, source.country = country, 
         source.color = color) %>%
  left_join(node_info %>% #mutate(author_id_te=as.character(author_id_te)) %>%
              select(author_id_te_cleaned, full_name, country, color),
            by = c("Target" = "author_id_te_cleaned")) %>%
  rename(target.res = full_name, target.country = country, 
         target.color = color) %>%
  filter(source.country == 'SOUTH KOREA' | target.country == 'SOUTH KOREA') %>%
  arrange(desc(weight)) %>%
  group_by(Source,Target,source.res,target.res,source.country,target.country,source.color,target.color) %>%
  summarize(weight=sum(weight)) %>% arrange(desc(weight)) %>% 
  filter(Source %in% top.kor.res$Id[1:100] & Target %in% top.kor.res$Id[1:100])

net <- graph_from_data_frame(d = graph_data, directed = FALSE)

V(net)$color <- ifelse(V(net)$name %in% node_info$author_id_te_cleaned,
                       node_info$color[match(V(net)$name, node_info$author_id_te_cleaned)],
                       "grey")

V(net)$full_name <- ifelse(V(net)$name %in% node_info$author_id_te_cleaned,
                              node_info$full_name[match(V(net)$name, node_info$author_id_te_cleaned)],
                              V(net)$name) # 매칭 안 될 경우 기본값은 name

# 그림 40 유럽 내 한국인 양자과학기술 연구자 협력 네트워크 시각화 (상위 100개)
ggnet2(net, size = "degree", color = "color", label =  V(net)$full_name, #TRUE
       label.size = 3,
       label.trim = TRUE, alpha = 0.5, edge.color = "grey", edge.alpha = 0.5) +
  guides(size = FALSE) +
  ggtitle("유럽 내 한국인 양자과학기술 연구자 협력 네트워크 시각화")


#########
# 한-유럽 연구자 간 상위 협력
sort(unique(quant_author_ed_eu_val$qc_category))
i<-1

# 양자과학기술 2단계 분야별 연구자 간 상위 협력
i<-1
res.ALL.EL.total.type.topcol.4 <- 0
for(i in 1:length(c("qc11","qc12","qc13","qc14","qc21","qc22"))){
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    mutate(qc4=substr(qc_category,1,4)) %>%
    filter(qc4==c("qc11","qc12","qc13","qc14","qc21","qc22")[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share),pub=1) %>% 
    ungroup #%>% filter(weight!=1) #%>% select(-c("weight")) 
  
  # generating ID (1,2,3,4...) by Application ID
  res.set.temp <- getanID(w.res.table.temp, id.vars = "pubid")
  colnames(res.set.temp)[colnames(res.set.temp)==".id"] <- "compound"
  res.set.temp$compound <- as.factor(res.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  res.set.w.type <- spread(res.set.temp, compound, author_id_te_cleaned)
  
  res.ALL.EL.total.type <- getting.edgelist.local(res.set.w.type)
  res.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  res.ALL.EL.total.type.topcol.4 <-
    rbind(res.ALL.EL.total.type.topcol.4,
          res.ALL.EL.total.type %>% arrange(desc(weight)) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Source"="author_id_te_cleaned")) %>% 
            rename(Source_full_name = full_name) %>%
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Target"="author_id_te_cleaned")) %>% 
            rename(Target_full_name = full_name) %>%
            head(3) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>% rename(Source.country=country, Source.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Source.inst,Source.country),
                      by=c("Source"="author_id_te_cleaned")) %>%
            left_join(quant_author_ed_eu_val_cleaned %>% rename(Target.country=country, Target.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Target.inst,Target.country),
                      by=c("Target"="author_id_te_cleaned")) %>%
            mutate(Source.inst = paste0(Source_full_name," (",Source.inst,")")) %>%
            mutate(Target.inst = paste0(Target_full_name," (",Target.inst,")")) %>%
            mutate(qc_category=c("qc11","qc12","qc13","qc14","qc21","qc22")[i]) %>%
            select(qc_category,Source,Target,Source.inst, Target.inst, weight, Source.country, Target.country)) %>%
    unique
  print(i)
}
res.ALL.EL.total.type.topcol.4 <- 
  res.ALL.EL.total.type.topcol.4[2:nrow(res.ALL.EL.total.type.topcol.4),]
write.csv(res.ALL.EL.total.type.topcol.4 %>% arrange(qc_category),
          file="Tables/양자과학기술 2단계 분야별 연구자 간 상위 협력.csv")

# 양자과학기술 3단계 분야별 연구자 간 상위 협력
i<-2
res.ALL.EL.total.type.topcol <- 0
for(i in 1:length(unique(quant_author_ed_eu_val_cleaned$qc_category))){
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    filter(qc_category==unique(quant_author_ed_eu_val_cleaned$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share),pub=1) %>% 
    ungroup #%>% filter(weight!=1) #%>% select(-c("weight")) 
  
  # generating ID (1,2,3,4...) by Application ID
  res.set.temp <- getanID(w.res.table.temp, id.vars = "pubid")
  colnames(res.set.temp)[colnames(res.set.temp)==".id"] <- "compound"
  res.set.temp$compound <- as.factor(res.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  res.set.w.type <- spread(res.set.temp, compound, author_id_te_cleaned)
  
  res.ALL.EL.total.type <- getting.edgelist.local(res.set.w.type)
  res.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  res.ALL.EL.total.type.topcol <-
    rbind(res.ALL.EL.total.type.topcol,
          res.ALL.EL.total.type %>% arrange(desc(weight)) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Source"="author_id_te_cleaned")) %>% 
            rename(Source_full_name = full_name) %>%
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Target"="author_id_te_cleaned")) %>% 
            rename(Target_full_name = full_name) %>%
            head(3) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>% rename(Source.country=country, Source.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Source.inst,Source.country),
                      by=c("Source"="author_id_te_cleaned")) %>%
            left_join(quant_author_ed_eu_val_cleaned  %>% rename(Target.country=country, Target.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Target.inst,Target.country),
                      by=c("Target"="author_id_te_cleaned")) %>%
            mutate(Source.inst = paste0(Source_full_name," (",Source.inst,")")) %>%
            mutate(Target.inst = paste0(Target_full_name," (",Target.inst,")")) %>%
            mutate(qc_category=unique(quant_author_ed_eu_val_cleaned$qc_category)[i]) %>%
            select(qc_category,Source,Target,Source.inst, Target.inst, weight, Source.country, Target.country)) %>%
    unique
  print(i)
}
res.ALL.EL.total.type.topcol <- 
  res.ALL.EL.total.type.topcol[2:nrow(res.ALL.EL.total.type.topcol),]
write.csv(res.ALL.EL.total.type.topcol %>% arrange(qc_category), #%>%
            # filter(qc_category %in% c("qc311","qc312","qc314","qc315","qc32")),
          file="Tables/양자과학기술 3단계 분야별 연구자 간 상위 협력.csv",
          row.names = FALSE)
res.ALL.EL.total.type.topcol %>% head
# res.ALL.EL.total.type.topcol %>% arrange(qc_category) %>%
#   write.csv(file="res_net_top_col.csv")

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

# Check author-institute collaboration difference
quant_inst_ed_eu_fixed_val %>% filter(qc_category=="qc225") %>%
  left_join(quant_author_ed_eu_val %>% filter(qc_category=="qc225")) %>%
  group_by(final_grouped_organization,pubid) %>%
  summarize(author=length(unique(author_id_te))) %>% ungroup %>%
  group_by(final_grouped_organization) %>%
  summarize(author.avg=mean(author)) %>%
  arrange(desc(author.avg)) %>%
  filter(final_grouped_organization=="LUBLIN UNIVERSITY OF TECHNOLOGY")

# 양자과학기술 2단계 분야별 중심성 지수별 상위 연구자 목록
res.summ.cen.toprank.4 <- 0
for(i in 1:length(c("qc11","qc12","qc13","qc14","qc21","qc22"))){
  ### weight version
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    mutate(qc4=substr(qc_category,1,4)) %>%
    filter(qc4==c("qc11","qc12","qc13","qc14","qc21","qc22")[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    filter(weight!=1) %>%
    select(-c("weight")) 
  
  res.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.res.table.temp$pubid))){ 
    temp <- w.res.table.temp[w.res.table.temp$pubid==unique(w.res.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te_cleaned, 2)))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    
    res.w.collabo.table.type <- rbind(res.w.collabo.table.type,temp.1)
  }
  res.w.collabo.table.type <- res.w.collabo.table.type[2:nrow(res.w.collabo.table.type),]
  res.w.collabo.table.type <- res.w.collabo.table.type %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  save(res.w.collabo.table.type, 
       file=paste0("R file/res.w.collabo.table.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],".RData"))
  
  res.ALL.EL.total.type <- graph.data.frame(res.w.collabo.table.type, directed=FALSE)
  res.summ.cen.type <- get.centrality(res.ALL.EL.total.type) %>% 
    mutate(qc_category = c("qc11","qc12","qc13","qc14","qc21","qc22")[i])
  save(res.summ.cen.type, 
       file=paste0("R file/res.summ.cen.type.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],"RData"))
  
  res.summ.cen.type <- res.summ.cen.type %>%
    left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                select(-c("qc_category","label","pubid","author_id_te","pubyear",
                          "country",'city',"org_sub","matched","match_method")) %>% unique,
              by=c("Id"="author_id_te_cleaned"))
  
  ###
  res.summ.cen.toprank.4 <-
    rbind(res.summ.cen.toprank.4,
          res.summ.cen.type %>%
            #filter(country %in% eu_country) %>%
            arrange(desc(w.Deg)) %>% head(3) %>%
            mutate(Rank=1:n()) %>% mutate(w.Deg=full_name, w.Deg.inst=organization_cleaned) %>%
            mutate(w.Deg.inst.ed = paste0(w.Deg," (",w.Deg.inst,")")) %>%
            select(qc_category, Rank, w.Deg.inst.ed) %>% 
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Btw)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Btw=full_name, Btw.inst=organization_cleaned) %>%
                        mutate(Btw.inst.ed = paste0(Btw," (",Btw.inst,")")) %>%
                        select(Rank, Btw.inst.ed)) %>%
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Eig)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Eig=full_name, Eig.inst=organization_cleaned) %>%
                        mutate(Eig.inst.ed = paste0(Eig," (",Eig.inst,")")) %>%
                        select(Rank, Eig.inst.ed)) %>% data.frame) 
}
res.summ.cen.toprank.4 <- res.summ.cen.toprank.4[2:nrow(res.summ.cen.toprank.4),]
write.csv(res.summ.cen.toprank.4 %>% arrange(qc_category),
          file="Tables/양자과학기술 2단계 분야별 중심성 지수별 상위 연구자 목록.csv")

# 양자과학기술 3단계 분야별 중심성 지수별 상위 연구자 목록
i<-2
res.summ.cen.toprank <- 0
for(i in 1:length(unique(quant_author_ed_eu_val_cleaned$qc_category))){
  ### weight version
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    filter(qc_category==unique(quant_author_ed_eu_val_cleaned$qc_category)[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    filter(weight!=1) %>%
    select(-c("weight")) 
  
  res.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.res.table.temp$pubid))){ 
    temp <- w.res.table.temp[w.res.table.temp$pubid==unique(w.res.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te_cleaned, 2)))
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
       file=paste0("R file/res.w.collabo.table.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],".RData"))
  
  res.ALL.EL.total.type <- graph.data.frame(res.w.collabo.table.type, directed=FALSE)
  res.summ.cen.type <- get.centrality(res.ALL.EL.total.type) %>% 
    mutate(qc_category = unique(quant_author_ed_eu_val_cleaned$qc_category)[i])
  save(res.summ.cen.type, 
       file=paste0("R file/res.summ.cen.type.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],"RData"))
  
  res.summ.cen.type <- res.summ.cen.type %>%
    left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                select(-c("qc_category","label","pubid","author_id_te","pubyear",
                          "country",'city',"org_sub","matched","match_method")) %>% unique,
              by=c("Id"="author_id_te_cleaned"))
  
  ###
  res.summ.cen.toprank <-
    rbind(res.summ.cen.toprank,
          res.summ.cen.type %>% #filter(country %in% eu_country) %>%
            arrange(desc(w.Deg)) %>% head(3) %>%
            mutate(Rank=1:n()) %>% mutate(w.Deg=full_name, w.Deg.inst=organization_cleaned) %>%
            mutate(w.Deg.inst.ed = paste0(w.Deg," (",w.Deg.inst,")")) %>%
            select(qc_category, Rank, w.Deg.inst.ed) %>% 
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Btw)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Btw=full_name, Btw.inst=organization_cleaned) %>%
                        mutate(Btw.inst.ed = paste0(Btw," (",Btw.inst,")")) %>%
                        select(Rank, Btw.inst.ed)) %>%
            left_join(res.summ.cen.type %>% # filter(country %in% eu_country) %>% 
                        arrange(desc(Eig)) %>% head(3) %>%
                        mutate(Rank=1:n()) %>% mutate(Eig=full_name, Eig.inst=organization_cleaned) %>%
                        mutate(Eig.inst.ed = paste0(Eig," (",Eig.inst,")")) %>%
                        select(Rank, Eig.inst.ed)) %>% data.frame) 
}
res.summ.cen.toprank <- res.summ.cen.toprank[2:nrow(res.summ.cen.toprank),]
write.csv(res.summ.cen.toprank %>% arrange(qc_category, Rank) %>%
            filter(qc_category %in% c("qc311","qc312","qc314","qc315","qc32")),
          file="Tables/양자과학기술 3단계 분야별 중심성 지수별 상위 연구자 목록.csv")

res.summ.cen.toprank %>% arrange(qc_category, Rank) %>%
  write.csv(file="res_net_top_cen.csv")


#####################################
### 기타 3 단계
#####################################
i <- 2
load(file=paste0("R file/part",i,"_quant_inst_ed_eu_fixed_val.RData"))
load(file=paste0("R file/part",i,"_quant_pub_ed_eu_val.RData"))
load(file=paste0("R file/part",i,"_quant_author_ed_eu_val_cleaned.RData"))

quant_inst_ed_eu_fixed_val$qc_category %>% unique
quant_pub_ed_eu_val$qc_category %>% unique
quant_author_ed_eu_val_cleaned$qc_category %>% unique

# 타 양자과학기술 3단계 분야별 기관 간 상위 협력
org.summ.cen.topcol.others <- 0
for(i in 1:length(c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423"))){
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>% 
    filter(qc_category==c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
    group_by(pubid) %>% mutate(count=length(organization_cleaned)) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  # generating ID (1,2,3,4...) by Application ID
  org.set.temp <- getanID(w.org.table.temp, id.vars = "pubid")
  colnames(org.set.temp)[colnames(org.set.temp)==".id"] <- "compound"
  org.set.temp$compound <- as.factor(org.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  org.set.w.type <- spread(org.set.temp, compound, organization_cleaned)
  
  org.ALL.EL.total.type <- getting.edgelist.local(org.set.w.type)
  org.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  # (기술별) 기관 간 상위 3개 협력 
  org.summ.cen.topcol.others <- 
    rbind(org.summ.cen.topcol.others,
          org.ALL.EL.total.type %>% arrange(desc(weight)) %>%
            head(3) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Source.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            left_join(org_country_list %>% select(-c("pub")) %>% rename(Target.country=country),
                      by=c("Source"="organization_cleaned")) %>%
            mutate(Source.country = paste0(Source," (",Source.country,")")) %>%
            mutate(Target.country = paste0(Target," (",Target.country,")")) %>%
            mutate(qc_category=c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
            select(qc_category,Source.country,Target.country,weight)) 
  print(i)
}
org.summ.cen.topcol.others <- org.summ.cen.topcol.others[2:nrow(org.summ.cen.topcol.others),]
org.summ.cen.topcol.others %>% arrange(qc_category)
write.csv(org.summ.cen.topcol.others %>% arrange(qc_category),# %>%
            # filter(qc_category %in% c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")),
          file="Tables/타 양자과학기술 3단계 분야별 기관 간 상위 협력.csv")

# 타 양자과학기술 3단계 분야별 중심성 지수별 상위 기관 목록
org.summ.cen.toprank.others <- 0
for(i in 1:length(c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423"))){
  ### weight version
  w.org.table.temp <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category==c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(organization_cleaned))) %>%  
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>% 
    group_by(pubid,organization_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    select(-c("weight"))
  
  org.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.org.table.temp$pubid))){ 
    temp <- w.org.table.temp[w.org.table.temp$pubid==unique(w.org.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$organization_cleaned, 2)))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    
    org.w.collabo.table.type <- rbind(org.w.collabo.table.type,temp.1)
  }
  org.w.collabo.table.type <- org.w.collabo.table.type[2:nrow(org.w.collabo.table.type),]
  org.w.collabo.table.type <- org.w.collabo.table.type %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  save(org.w.collabo.table.type, 
       file=paste0("R file/or.w.collabo.table.",c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i],".RData"))
  
  org.ALL.EL.total.type <- graph.data.frame(org.w.collabo.table.type, directed=FALSE)
  org.summ.cen.type <- get.centrality(org.ALL.EL.total.type) %>% 
    mutate(qc_category = c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i])
  save(org.summ.cen.type, 
       file=paste0("R file/org.summ.cen.type.",c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i],"RData"))
  
  org_country_map <- quant_inst_ed_eu_fixed_val %>%
    filter(qc_category == unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    count(organization_cleaned, country, sort = TRUE) %>%
    group_by(organization_cleaned) %>%
    slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    transmute(Id = organization_cleaned,
              country = ifelse(is.na(country) | country == "", "UNKNOWN", country))
  
  org.summ.cen.type <- org.summ.cen.type %>%
    left_join(org_country_map, by = "Id")
  
  top_deg <- org.summ.cen.type %>% arrange(desc(w.Deg)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           w.Deg = paste0(Id, " - ", country)) %>%
    select(Rank, w.Deg)
  
  top_btw <- org.summ.cen.type %>% arrange(desc(Btw)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Btw = paste0(Id, " - ", country)) %>%
    select(Rank, Btw)
  
  top_eig <- org.summ.cen.type %>% arrange(desc(Eig)) %>% head(3) %>%
    mutate(Rank = 1:n(),
           Eig = paste0(Id, " - ", country)) %>%
    select(Rank, Eig)
  
  out_tbl <- top_deg %>%
    left_join(top_btw, by = "Rank") %>%
    left_join(top_eig, by = "Rank") %>%
    mutate(qc_category = unique(quant_inst_ed_eu_fixed_val$qc_category)[i]) %>%
    select(qc_category, Rank, w.Deg, Btw, Eig) %>%
    data.frame()
  
  org.summ.cen.toprank.others <- 
    rbind(org.summ.cen.toprank.others, out_tbl)

}
org.summ.cen.toprank.others <- org.summ.cen.toprank.others[2:nrow(org.summ.cen.toprank.others),]
org.summ.cen.toprank.others %>% arrange(qc_category, Rank)
write.csv(org.summ.cen.toprank.others %>% arrange(qc_category), %>%
            # filter(qc_category %in% c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")),
          file="Tables/타 양자과학기술 3단계 분야별 중심성 지수별 상위 기관 목록.csv")

# 타 양자과학기술 3단계 분야별 연구자 간 상위 협력
i<-1
res.ALL.EL.total.type.topcol.others <- 0
for(i in 1:length(c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423"))){
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    filter(qc_category==c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share),pub=1) %>% 
    ungroup #%>% filter(weight!=1) #%>% select(-c("weight")) 
  
  # generating ID (1,2,3,4...) by Application ID
  res.set.temp <- getanID(w.res.table.temp, id.vars = "pubid")
  colnames(res.set.temp)[colnames(res.set.temp)==".id"] <- "compound"
  res.set.temp$compound <- as.factor(res.set.temp$compound)
  
  # create CPC matrix: each row shows individual patent's list of CPCs
  res.set.w.type <- spread(res.set.temp, compound, author_id_te_cleaned)
  
  res.ALL.EL.total.type <- getting.edgelist.local(res.set.w.type)
  res.ALL.EL.total.type %<>% dplyr::rename(weight=Weight)
  
  res.ALL.EL.total.type.topcol.others <-
    rbind(res.ALL.EL.total.type.topcol.others,
          res.ALL.EL.total.type %>% arrange(desc(weight)) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Source"="author_id_te_cleaned")) %>% 
            rename(Source_full_name = full_name) %>%
            left_join(quant_author_ed_eu_val_cleaned %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, full_name) %>% unique, 
                      by=c("Target"="author_id_te_cleaned")) %>% 
            rename(Target_full_name = full_name) %>%
            head(5) %>% 
            left_join(quant_author_ed_eu_val_cleaned %>%   
                        rename(Source.country=country, Source.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Source.inst,Source.country),
                      by=c("Source"="author_id_te_cleaned")) %>% unique %>%
            left_join(quant_author_ed_eu_val_cleaned  %>% rename(Target.country=country, Target.inst=organization_cleaned) %>% 
                        mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                        select(author_id_te_cleaned, Target.inst,Target.country),
                      by=c("Target"="author_id_te_cleaned")) %>% unique %>%
            mutate(Source.inst = paste0(Source_full_name," (",Source.inst,")")) %>%
            mutate(Target.inst = paste0(Target_full_name," (",Target.inst,")")) %>%
            mutate(qc_category=c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
            select(qc_category,Source.inst, Target.inst, weight, Source.country, Target.country)) 
  print(i)
}
res.ALL.EL.total.type.topcol.others <- 
  res.ALL.EL.total.type.topcol.others[2:nrow(res.ALL.EL.total.type.topcol.others),]
write.csv(res.ALL.EL.total.type.topcol.others %>% arrange(qc_category), # %>%
            # filter(qc_category %in% c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")),
          file="Tables/타 양자과학기술 3단계 분야별 연구자 간 상위 협력.csv")

# 타 양자과학기술 3단계 분야별 중심성 지수별 상위 연구자 목록 
i<-1
res.summ.cen.toprank.others <- 0
for(i in 1:length(c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423"))){
  ### weight version
  w.res.table.temp <- quant_author_ed_eu_val_cleaned %>% 
    filter(qc_category==c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")[i]) %>%
    group_by(pubid) %>% mutate(count=length(unique(author_id_te_cleaned))) %>%
    mutate(share=1/count) %>% ungroup %>%
    filter(count!=1) %>%
    group_by(pubid,author_id_te_cleaned) %>%
    dplyr::summarise(weight=sum(share)) %>% ungroup %>%
    filter(weight!=1) %>%
    select(-c("weight")) 
  
  res.w.collabo.table.type <- 0
  for (j in 1:length(unique(w.res.table.temp$pubid))){ 
    temp <- w.res.table.temp[w.res.table.temp$pubid==unique(w.res.table.temp$pubid)[[j]],]
    temp.1 <- data.frame(unique(temp$pubid),t(combn(temp$author_id_te_cleaned, 2)))
    temp.1 %<>% mutate(share=1/nrow(temp.1))
    names(temp.1) <- c("pubid","Source","Target","share")
    
    res.w.collabo.table.type <- rbind(res.w.collabo.table.type,temp.1)
  }
  res.w.collabo.table.type <- res.w.collabo.table.type[2:nrow(res.w.collabo.table.type),]
  res.w.collabo.table.type <- res.w.collabo.table.type %>% 
    group_by(Source,Target) %>%
    dplyr::summarise(weight=sum(share))
  save(res.w.collabo.table.type, 
       file=paste0("R file/res.w.collabo.table.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],".RData"))
  
  res.ALL.EL.total.type <- graph.data.frame(res.w.collabo.table.type, directed=FALSE)
  res.summ.cen.type <- get.centrality(res.ALL.EL.total.type) %>% 
    mutate(qc_category = c("QC1a1","QC1a2","QC1a3","QC1a4","QC1a5","QC1a6","QC421","QC422","QC423")[i])
  save(res.summ.cen.type, 
       file=paste0("R file/res.summ.cen.type.",unique(quant_author_ed_eu_val_cleaned$qc_category)[i],"RData"))
  
  res.summ.cen.type <- res.summ.cen.type %>%
    left_join(quant_author_ed_eu_val_cleaned %>% mutate(author_id_te_cleaned=as.character(author_id_te_cleaned)) %>%
                select(-c("qc_category","label","pubid","author_id_te","pubyear",
                          'city',"org_sub","matched","match_method","type")) %>% unique,
              by=c("Id"="author_id_te_cleaned"))
  
  ###
  res.summ.cen.toprank.others <-
    rbind(res.summ.cen.toprank.others,
          res.summ.cen.type %>% filter(country %in% eu_country) %>% #filter(is.na(Id)==FALSE) %>%
            arrange(desc(w.Deg)) %>% head(5) %>%
            mutate(Rank=1:n()) %>% mutate(w.Deg=full_name, w.Deg.inst=organization_cleaned) %>%
            mutate(w.Deg.inst.ed = paste0(w.Deg," (",w.Deg.inst,")")) %>%
            select(qc_category, Rank, w.Deg.inst.ed) %>% 
            left_join(res.summ.cen.type %>% filter(country %in% eu_country) %>% 
                        arrange(desc(Btw)) %>% head(5) %>%
                        mutate(Rank=1:n()) %>% mutate(Btw=full_name, Btw.inst=organization_cleaned) %>%
                        mutate(Btw.inst.ed = paste0(Btw," (",Btw.inst,")")) %>%
                        select(Rank, Btw.inst.ed)) %>%
            left_join(res.summ.cen.type %>% filter(country %in% eu_country) %>% 
                        arrange(desc(Eig)) %>% head(5) %>%
                        mutate(Rank=1:n()) %>% mutate(Eig=full_name, Eig.inst=organization_cleaned) %>%
                        mutate(Eig.inst.ed = paste0(Eig," (",Eig.inst,")")) %>%
                        select(Rank, Eig.inst.ed)) %>% data.frame) 
}
res.summ.cen.toprank.others <- res.summ.cen.toprank.others[2:nrow(res.summ.cen.toprank.others),]
write.csv(res.summ.cen.toprank.others %>% arrange(qc_category), #%>%
            # filter(qc_category %in% c("qc1a1","qc1a2","qc1a3","qc1a4","qc1a5","qc1a6","qc421","qc422","qc423")),
          file="Tables/타 양자과학기술 3단계 분야별 중심성 지수별 상위 연구자 목록.csv")

table(quant_author_ed_eu_val$qc_category)
