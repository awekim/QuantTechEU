#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project2 - Data Prep 02. Data Exploration
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

dir <- "I:/Data_for_practice/Rfiles/QuanTech"

### Label table
# Sys.setlocale("LC_ALL","Korean") # 언어 다시 한글로
quan_lable <- read.csv(file=paste0(dir,"/qc_label.csv"), 
                       encoding = "UTF-8") 
names(quan_lable) <- c("qc_category","label")

load(file=paste0(dir,"/quant_pub.RData"))
load(file=paste0(dir,"/quant_author.RData"))
load(file=paste0(dir,"/quant_inst.RData"))

length(unique(quant_pub$pubid)) # 186,141
length(unique(quant_author$pubid)) # 186,141
length(unique(quant_inst$pubid)) # 186,141

quant_pub_ed <- quant_pub %>% 
  inner_join(quant_pub %>% select(pubid) %>% unique %>%
               inner_join(quant_author %>% filter(is.na(author_id_te)==FALSE) %>%
                            select(pubid) %>% unique) %>%
               inner_join(quant_inst %>% filter(is.na(institution_id_te)==FALSE) %>%
                            select(pubid) %>% unique))
length(unique(quant_pub_ed$pubid)) # (without author) 4,794,879 (with author) 2,085,256
# (without author) 295,127 (with author) 295,127
# (all) 143,892 -> 154,103 -> 184,774
quant_pub_ed$pubyear %>% table
quant_pub_ed %>% filter(pubyear==2009) %>% head(5)
save(quant_pub_ed, file=paste0(dir,"/quant_pub_ed.RData"))
rm(quant_pub, quant_author, quant_inst)

load(file=paste0(dir,"/quant_pub_ed.RData"))
load(file=paste0(dir,"/quant_inst.RData"))
quant_inst_ed <- quant_pub_ed %>% select(pubid) %>% unique %>% 
  inner_join(quant_inst)
save(quant_inst_ed, file=paste0(dir,"/quant_inst_ed.RData"))
length(unique(quant_inst_ed$pubid)) # 143,892 -> 154,103 -> 184,774
length(unique(quant_inst_ed$institution_id_te)) # 1,303,620 -> 494,643 -> 530,423 -> 604,294
rm(quant_inst)

### Restrict to European Regions
load(file=paste0(dir,"/quant_pub_ed.RData"))
load(file=paste0(dir,"/quant_inst_ed.RData"))

quant_pub_ed$pubid %>% unique %>% length
quant_inst_ed$pubid %>% unique %>% length
quant_inst_ed$country %>% unique %>% length 
quant_inst_ed$country %>% unique %>% sort 
quant_inst_ed %>% group_by(country) %>%
  summarize(count=length(unique(pubid))) %>%
  arrange(desc(count))
# eu_country <- c("GREECE","SPAIN","SWEDEN","GERMANY","NETHERLAND",
#                 "ENGLAND","FRANCE","SCOTLAND","ITALY","HUNGARY",
#                 "CZECH REPUBLIC","BELGIUM","SWITZERLAND",
#                 "SERBIA","TURKEY","POLAND","BOSNIA & HERCEG",
#                 "PORTUGAL","ROMANIA","AUSTRIA","DENMARK","CYPRUS","NORWAY",
#                 "FINLAND","WALES","CROATIA","LUXEMBOURG",
#                 "NORTH IRELAND","GREENLAND","UNITED KINGDOM",
#                 "EUROPE","BELGIUM","BULGARIA")
eu_country <- 
  c("AUSTRIA","BELGIUM","BULGARIA","CROATIA","CYPRUS","CZECH REPUBLIC","DENMARK",
    "ENGLAND","ESTONIA","FINLAND","FINLAND","FRANCE","GERMANY","GREECE","HUNGARY",
    "ICELAND","IRELAND","ISRAEL","ITALY","LATVIA","LITHUANIA","LUXEMBOURG","MALTA",
    "NETHERLANDS","NORWAY","NORTH IRELAND",
    "POLAND","PORTUGAL","ROMANIA","SCOTLAND","SLOVAKIA","SLOVENIA",      
    "SPAIN","SWEDEN","SWITZERLAND","WALES")

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
quant_inst_ed_eu$pubid %>% unique %>% length # 55,582 -> 58,453 -> 59,076 -> 70,456
rm(quant_inst_ed, quant_pub_ed) # 50,278,314 -> 16,931,485

# check
quant_inst_ed_eu %>% filter(country=="GERMANY") %>%
  filter(pubyear >=2018) %>%
  select(pubid) %>% unique %>% nrow

quant_inst_ed_eu %>% select(pubid,institution_id_te,organization,suborganization) %>% 
  unique %>% #arrange(full_address) %>%
  filter(suborganization=="SCH NAT SCI") %>%
  select(institution_id_te) %>% unique %>%
  head(10)

quant_inst_ed_eu %>% filter(suborganization=="NULL") %>%
  select(pubid,organization,suborganization,full_address)

### suborganization을 기준으로 organization 이름 정리
shortest_org <- quant_inst_ed_eu %>%
  mutate(org_length = nchar(organization)) %>%
  group_by(pubid, suborganization) %>%
  slice_min(order_by = org_length, with_ties = FALSE) %>%
  select(pubid, suborganization, organization_ed = organization)
shortest_org %>% head

quant_inst_ed_eu <- quant_inst_ed_eu %>%
  left_join(shortest_org, by = c("pubid", "suborganization"))

# SEQ_NO might not be a good proxy for matching researchers
quant_author %>% filter(pubid==62208)
quant_inst_ed_eu %>% filter(pubid==62208)
quant_inst_ed_eu %>% select(pubid, pubyear, organization_ed, suborganization, country)

quant_inst_ed_eu$pubid %>% unique %>% length # 2,272,783 -> 1,808,860 -> 1,11,440 -> 55,582 -> 58,453 -> 59,076
quant_inst_ed_eu$organization_ed %>% unique %>% length # 305,998 -> 31,102 -> 11,224 -> 11,759 -> 20,202 -> 13,932
  
save(quant_inst_ed_eu, file=paste0(dir,"/quant_inst_ed_eu.RData"))
write.csv(quant_inst_ed_eu, file=paste0(dir,"/quant_inst_ed_eu.csv"))

# Skip Python pre-processing work

quant_pub_ed_eu <- quant_pub_ed %>% 
  inner_join(quant_inst_ed_eu %>% select(pubid) %>% unique)
save(quant_pub_ed_eu, file=paste0(dir,"/quant_pub_ed_eu.RData"))
write.csv(quant_pub_ed_eu, file=paste0(dir,"/quant_pub_ed_eu.csv"))

load(file=paste0(dir,"/quant_inst_ed_eu.RData"))
load(file=paste0(dir,"/quant_author.RData"))
quant_inst_ed_eu %>% head
quant_author %>% head

quant_author_ed_eu <- quant_author %>% 
  inner_join(quant_inst_ed_eu %>% select(pubid) %>% unique)
quant_author_ed_eu %>% filter(is.na(author_id_te))
quant_inst_ed_eu$pubid %>% unique %>% length # 55,582 -> 58,453 -> 59,076 -> 70,456 
save(quant_author_ed_eu, file=paste0(dir,"/quant_author_ed_eu.RData"))
write.csv(quant_author_ed_eu, file=paste0(dir,"/quant_author_ed_eu.csv"))
rm(quant_author, quant_author_ed_eu, quant_inst_ed_eu_fixed)

###############
# Final Data Preparation
###############
load(file=paste0(dir,"/quant_pub_ed_eu.RData"))
load(file=paste0(dir,"/quant_inst_ed_eu.RData"))
load(file=paste0(dir,"/quant_author_ed_eu.RData"))

quant_pub_ed_eu$pubid %>% unique %>% length  

quant_pub_ed_eu$qc_category %>% table

