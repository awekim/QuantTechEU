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

### Label table
quan_lable <- read.csv(file="qc_label.csv") 

### List of files generated
# load(file="R file/quant_pub.RData")
# load(file="R file/quant_author.RData")
# load(file="R file/quant_inst.RData")
# load(file="R file/funding.RData")

### Create integrated table
load(file="R file/quant_pub.RData")
load(file="R file/quant_author.RData")
load(file="R file/quant_inst.RData")

quant_pub_ed <- quant_pub %>% 
  filter(pubyear>=1998 & pubyear<=2021) %>%
  inner_join(quant_pub %>% select(pubid) %>% unique %>%
               # inner_join(quant_author %>% filter(is.na(author_id_te)==FALSE) %>%
               #              select(pubid) %>% unique) %>%
               inner_join(quant_inst %>% filter(is.na(institution_id_te)==FALSE) %>%
                            select(pubid) %>% unique))
length(unique(quant_pub_ed$pubid)) # (without author) 4,794,879 (with author) 2,085,256
quant_pub_ed$pubyear %>% table
quant_pub_ed %>% filter(pubyear==2009) %>% head(5)
save(quant_pub_ed, file="R file/quant_pub_ed.RData")
rm(quant_pub, quant_author, quant_inst)

load(file="R file/quant_pub_ed.RData")
load(file="R file/quant_inst.RData")
quant_inst_ed <- quant_pub_ed %>% select(pubid) %>% unique %>% 
  inner_join(quant_inst)
save(quant_inst_ed, file="R file/quant_inst_ed.RData")
length(unique(quant_inst_ed$institution_id_te))
rm(quant_inst)

### Restrict to European Regions
load(file="R file/quant_pub_ed.RData")
load(file="R file/quant_inst_ed.RData")

quant_pub_ed$pubid %>% unique %>% length
quant_inst_ed$pubid %>% unique %>% length
quant_inst_ed$country %>% unique %>% length 
eu_country <- c("GREECE","SPAIN","SWEDEN","GERMANY","NETHERLAND",
                "ENGLAND","FRANCE","SCOTLAND","ITALY","HUNGARY",
                "CZECH REPUBLIC","BELGIUM","SWITZERLAND",
                "SERBIA","TURKEY","POLAND","BOSNIA & HERCEG",
                "PORTUGAL","ROMANIA","AUSTRIA","DENMARK","CYPRUS","NORWAY",
                "FINLAND","IRELAND","ICELAND","WALES","CROATIA","LUXEMBOURG",
                "NORTH IRELAND","GREENLAND","UNITED KINGDOM",
                "EUROPE","BELGIU","BULGARIA;")
data.frame(list=eu_country) %>% arrange(list)

quant_inst_ed_eu <- quant_inst_ed %>% 
  filter(country %in% eu_country) %>%
  left_join(quant_pub_ed %>% select(pubid, pubyear) %>% unique)
rm(quant_inst_ed, quant_pub_ed) # 50,278,314 -> 16,931,485

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
    organization_clean = str_replace_all(organization_clean, "UNIV ULM", "ULM UNIVERSITY")
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

quant_inst_ed_eu$pubid %>% unique %>% length # 2,272,783 -> 1,808,860
quant_inst_ed_eu$organization %>% unique %>% length # 305,998
save(quant_inst_ed_eu, file="R file/quant_inst_ed_eu.RData")
write.csv(quant_inst_ed_eu, file="R file/quant_inst_ed_eu.csv")
rm(quant_inst_eu)

####################################
#### Institution name check

# ~~~ Python Codes ~~~ 
quant_inst_ed_eu_fixed <-
  read.csv("../../05_허지수박사/quant_inst_ed_eu_fixed.csv")
save(quant_inst_ed_eu_fixed, file="R file/quant_inst_ed_eu_fixed.RData")

####################################

load(file="R file/quant_inst_ed_eu_fixed.RData")
load(file="R file/quant_pub_ed.RData")

quant_inst_ed_eu_fixed %>% head
quant_inst_ed_eu_fixed$organization %>% unique %>% length # 305,997
quant_inst_ed_eu_fixed$organization_clean %>% unique %>% length # 305,197
quant_inst_ed_eu_fixed$standardized_organization %>% unique %>% length # 305,329
quant_inst_ed_eu_fixed$final_standardized_organization %>% unique %>% length # 225,211

quant_pub_ed_eu <- quant_pub_ed %>% inner_join(quant_inst_ed_eu_fixed %>% select(pubid) %>% unique)
save(quant_pub_ed_eu, file="R file/quant_pub_ed_eu.RData")
write.csv(quant_pub_ed_eu, file="R file/quant_pub_ed_eu.csv")
rm(quant_pub_ed, quant_pub_ed_eu)

load(file="R file/quant_author.RData")
quant_author_ed_eu <- quant_author %>% inner_join(quant_inst_ed_eu_fixed %>% select(pubid) %>% unique)
save(quant_author_ed_eu, file="R file/quant_author_ed_eu.RData")
write.csv(quant_author_ed_eu, file="R file/quant_author_ed_eu.csv")
rm(quant_author, quant_author_ed_eu, quant_inst_ed_eu_fixed)

####################################

### Quant-EU Data Descriptives
load(file="R file/quant_pub_ed_eu.RData")
quant_pub_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 

quant_pub_ed_eu %>% head(1)

# Frequency Table
quant_pub_ed_eu %>% group_by(qc_category,label) %>%
  summarize(pub = length(unique(pubid))) %>% data.frame

# annual trend
quant_pub_ed_eu %>% group_by(pubyear) %>%
  summarize(pub = length(unique(pubid))) %>% ungroup() %>% 
  ggplot(aes(x=pubyear, y=pub, group=1)) + geom_line()

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

###




### Yearly Publication Trend
load(file="R file/quant_pub_ed_eu.RData")
load(file="R file/quant_inst_ed_eu.RData")

quant_pub_year_fig <- list()
for (i in 1:length(unique(quant_pub_ed_eu$qc_category))){
  quant_pub_year_fig[[i]] <- quant_pub_ed_eu %>%  
    filter(qc_category == unique(quant_pub_ed_eu$qc_category)[[i]]) %>%
    group_by(qc_category, pubyear) %>% summarize(pub=length(unique(pubid))) %>% ungroup %>% mutate(type="all") %>%
    rbind(quant_pub_ed_eu %>% inner_join(quant_inst_ed_eu %>% select(pubid) %>% unique) %>%
                filter(qc_category == unique(quant_pub_ed_eu$qc_category)[[i]]) %>%
                group_by(qc_category, pubyear) %>% summarize(pub=length(unique(pubid))) %>% ungroup %>% mutate(type="EU")) %>%
    ggplot(aes(x=pubyear, y= pub, group=type, color=type)) + geom_line() +
    labs(x="year", y="Number of publications", title=unique(quant_pub_ed_eu$qc_category)[[i]]) +
    theme_bw()
  quant_pub_year_fig[[i]]
  ggsave(paste0("R figure/",unique(quant_pub_ed_eu$qc_category)[[i]],"_year_pub.png"))
}
rm(quant_pub_ed_eu, quant_inst_ed_eu, quant_pub_year_fig)

### Yearly Institution Trend
load(file="R file/quant_pub_ed_eu.RData")
load(file="R file/quant_inst_ed_eu.RData")

quant_pub_ed_eu %>% head(1)

i<-1
quant_inst_year_fig <- list()
for (i in 1:length(unique(quant_pub_ed_eu$qc_category))){
  quant_inst_year_fig[[i]] <- quant_pub_ed_eu %>%  
    filter(qc_category == unique(quant_pub_ed_eu$qc_category)[[i]]) %>%
    select(pubid,pubyear) %>% unique %>%
    inner_join(quant_inst_ed_eu %>% filter(qc_category == unique(quant_pub_ed_eu$qc_category)[[i]])) %>%
    group_by(qc_category, pubyear) %>% summarize(institutions=length(unique(institution_id_te))) %>%
    ggplot(aes(x=pubyear, y=institutions, group=qc_category)) + geom_line() +
    labs(x="year", y="Number of institutions", title=unique(quant_pub_ed_eu$qc_category)[[i]]) +
    theme_bw()
  quant_inst_year_fig[[i]]
  ggsave(paste0("R figure/",unique(quant_pub_ed_eu$qc_category)[[i]],"_year_inst.png"))
}
rm(quant_pub_ed_eu, quant_inst_ed_eu, quant_inst_year_fig)

### Yearly Researcher Trend
# Need to be fixed 
load(file="R file/quant_pub_ed_eu.RData")
load(file="R file/quant_author_ed_eu.RData")

quant_author_ed_eu %>% filter(is.na(author_id_te)==FALSE) %>%
  nrow
quant_author_ed_eu %>% filter(is.na(author_id_te)==FALSE) %>%
  select(pubid) %>% unique %>% nrow
quant_author_ed_eu %>% nrow

quant_author_year_fig <- list()
for (i in 1:length(unique(quant_pub_ed_eu$qc_category))){
  quant_author_year_fig[[i]] <- quant_pub_ed_eu %>% 
    filter(qc_category == unique(quant_pub_ed_eu$qc_category)[[i]]) %>%
    left_join(quant_author_ed_eu %>% filter(is.na(author_id_te)==FALSE) %>%
                select(pubid,author_id_te) %>% unique) %>%
    filter(is.na(author_id_te)==FALSE) %>% 
    group_by(qc_category, pubyear) %>% summarize(authors=length(unique(author_id_te))) %>% ungroup %>%
    ggplot(aes(x=pubyear, y= authors, group=qc_category)) + geom_line() +
    labs(x="year", y="Number of authors", title=unique(quant_pub_ed_eu$qc_category)[[i]]) +
    theme_bw()
  quant_author_year_fig[[i]]
  ggsave(paste0("R figure/",unique(quant_pub_ed_eu$qc_category)[[i]],"_year_author.png"))
}
rm(quant_pub_ed_eu, quant_author_ed_eu, quant_author_year_fig)

### QC-Country Distribution
load(file="R file/quant_inst_ed_eu.RData")
load(file="R file/quant_pub_ed_eu.RData")

table(quant_pub_ed_eu$pubyear)

quant_country <- quant_inst_ed_eu %>% 
  left_join(quant_pub_ed_eu %>% select(pubid, pubyear) %>% unique) %>%
  group_by(qc_category, pubyear, country) %>%
  summarize(pub=length(unique(pubid)))
save(quant_country, file="R file/quant_country.RData")

for (i in 1:length(unique(quant_country$qc_category))){
  temp <- quant_country %>% filter(qc_category==unique(quant_country$qc_category)[[i]]) %>%
    group_by(qc_category, country) %>%
    summarize(pub=sum(pub)) %>% arrange(desc(pub))
  temp %>% ggplot(aes(x=country, y=pub)) +
    geom_bar(stat='identity') + coord_flip() +
    labs(x="Country", y="Number of publications", title=unique(temp$qc_category)) +  
    theme_bw()
  ggsave(paste0("R figure/",unique(temp$qc_category),"_country_bar.png"))
}
rm(quant_country, temp)

### QC-Institution Distribution
load(file="R file/quant_inst_eu.RData")

write.csv(quant_inst_eu %>% select(organization) %>% unique, file="R file/organization_list.csv")

quant_inst <- quant_inst_eu %>% 
  group_by(qc_category, pubyear, organization) %>%
  summarize(pub=length(unique(pubid))) 
quant_inst %>% arrange(qc_category, pubyear, desc(pub)) %>% 
  filter(pubyear >= 1998 & pubyear <2022)

# 4. [ ] 각 분야별 국가 분포
# 5. [ ] 각 분야별 지역 분포