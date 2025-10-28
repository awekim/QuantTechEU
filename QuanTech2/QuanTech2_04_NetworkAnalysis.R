#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project2 - Network Analysis
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

library('dplyr')
library('magrittr')
library('tidyr')
library('ggplot2')
library('splitstackshape')
# library('devtools')
# library('backports')
# devtools::install_github("PABalland/EconGeo", force = T)
library('EconGeo')
library('igraph')
library('data.table')
library(GGally)
library(ggplot2)

dir <- "I:/Data_for_practice/Rfiles/QuanTech"

### Label table
quan_lable <- read.csv(file=paste0(dir,"/qc_label.csv"), 
                       encoding = "UTF-8") 
names(quan_lable) <- c("qc_category","label")

### Load Data
load(file=paste0(dir,"/quant_pub_ed_eu.RData"))
quant_pub_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label))
quant_pub_ed_eu %>% group_by(pubid) %>%
  summarize(label.count=length(unique(qc_category)))

load(file=paste0(dir,"/quant_inst_ed_eu.RData"))
quant_inst_ed_eu %>% head(1)

load(file=paste0(dir,"/quant_author_ed_eu.RData"))
quant_author_ed_eu %<>% left_join(quan_lable %>% select(qc_category,label)) 

###########################################################################
### User-defined functions
###########################################################################

### [FUNCTION] GETTING EDGELIST
# Simpler version: available for big data set

getting.edgelist.local <- function(InputDF){
  
  # InputDF <- subset(app.inv.ipc, period==unique(app.inv.ipc$period)[[t]])
  # InputDF <- subset(pat.reg.cpc, US_CA_metro_name==unique(pat.reg.cpc$US_CA_metro_name)[[i]])
  # InputDF <- ctr.set.w
  
  #1, Making list (Extracting unique cpc code for each observation to each list)
  from = which(colnames(InputDF)=="1")
  to = which(colnames(InputDF)==colnames(InputDF)[length(InputDF)])
  tech.list <- apply(InputDF,1,function(y) unique(y[c(from:to)]))
  
  #2. Excluding (NA code in cpc code)
  tech.list <- lapply(tech.list,function(y) y[!is.na(y)])  
  
  max.len <- max(sapply(tech.list, length))
  corrected.list <- lapply(tech.list, function(x) {c(x, rep(NA, max.len - length(x)))})
  M1 <- do.call(rbind, corrected.list) 
  rm(corrected.list, tech.list)
  
  idx <- t(combn(max.len, 2))
  
  # Add row_names and remove NAs
  edgelist <- lapply(1:nrow(idx), function(ib) M1[, c(idx[ib, 1], idx[ib, 2])] %>% 
                       data.frame %>% # mutate(row_names=row.names(.)) %>% 
                       drop_na() # filter(is.na(X1)==FALSE)
  )
  # rm(M1)
  
  edgelist <- do.call(rbind, edgelist) 
  
  # Add firm_name by merging with row_names
  edgelist %<>% mutate(share=1) %>% filter(is.na(X2)==FALSE) %>%
    #   left_join(InputDF %>% mutate(row_names=row.names(.)) %>%
    #               select(pubid,row_names,share) %>% unique, by=c("row_names")) %>% unique %>% select(-c("row_names","APPLN_ID")) %>%
    #   # mutate(X2= case_when(is.na(X2)==TRUE ~ X1, is.na(X2)==FALSE ~ X2)) %>%
    dplyr::rename(Source=X1, Target=X2, weight=share)  # Firm=FULLNAMESTD,
  
  edgelist <- edgelist[rowSums(is.na(edgelist[1:2]))==0, ]
  edgelist <- edgelist[edgelist$Source!="", ]
  edgelist <- edgelist[edgelist$Target!="", ] 
  edgelist <- edgelist[!is.na(edgelist$weight), ]
  # edgelist <- arrange(edgelist,Source,Target)
  edgelist <- edgelist %>% group_by(Source, Target) %>% summarize_at('weight', sum, na.rm=T) # Firm,  
  G <- graph.data.frame(edgelist,directed=FALSE)
  EL.DF <- data.frame(get.edgelist(G), weight=round(E(G)$weight, 3))
  names(EL.DF)<-c("Source", "Target", "Weight")
  
  return(EL.DF)
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
w.ctr.table <- quant_inst_ed_eu %>%
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
# names(ALL.G.p.all) <- unique(quant_inst_ed_eu$qc_category)[[j]]
save(ALL.G.p.all, file=paste0(dir,"/ALL.G.p.all.RData"))

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
save(summ.cen.all, file=paste0(dir,"/summ.cen.all.RData"))

summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Btw=log(Btw+1)/max(log(Btw+1))) %>%
  ggplot(aes(x=w.Deg, y=Btw, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text() + theme_bw()

summ.cen.all %>% mutate(w.Deg=log(w.Deg+1)/max(log(w.Deg+1)), Eig=log(Eig+1)/max(log(Eig+1))) %>%
  ggplot(aes(x=w.Deg, y=Eig, label=Id)) +
  geom_hline(yintercept=0.5, col="red") + geom_vline(xintercept=0.5, col="red") +
  # geom_point() + 
  geom_text() + theme_bw()

# write.csv(summ.cen.all %>% data.frame, file="R file/network_measures_all.csv",
#           row.names=FALSE)
# write.csv(ALL.EL.p.all %>% data.frame, file="R file/qc_edges_all.csv",
#           row.names=FALSE)
# write.csv(Node.table.all %>% data.frame, file="R file/qc_nodes_all.csv",
#           row.names=FALSE)

###########################################################################
### Organization-level analysis
###########################################################################

### All 
w.org.table <- quant_inst_ed_eu %>%
  group_by(pubid) %>% mutate(count=length(organization_ed)) %>%
  mutate(share=1/count) %>% ungroup %>%
  group_by(pubid,organization_ed) %>%
  dplyr::summarise(weight=sum(share)) %>% ungroup %>%
  select(-c("weight"))

# generating ID (1,2,3,4...) by Application ID
org.set <- getanID(w.org.table, id.vars = "pubid")
colnames(org.set)[colnames(org.set)==".id"] <- "compound"
org.set$compound <- as.factor(org.set$compound)

# create CPC matrix: each row shows individual patent's list of CPCs
org.set.w <- spread(org.set, compound, organization_ed)

ALL.EL.total.org.all <- getting.edgelist.local(org.set.w)
ALL.EL.total.org.all %<>% dplyr::rename(weight=Weight)

ALL.EL.total.org.all %>% arrange(desc(weight)) %>%
  head(20)
# write.csv(ALL.EL.total.org.all, file="R file/ALL.EL.total.org.all.hur.csv")

# non-weight version  
ALL.G.p.all.org <- graph.data.frame(ALL.EL.total.org.all, directed=FALSE)
save(ALL.G.p.all.org, file=paste0(dir,"/ALL.G.p.all.org.RData"))

ALL.EL.p.all.org <- data.frame(get.edgelist(ALL.G.p.all.org),
                               weight=round(E(ALL.G.p.all.org)$weight, 3))
names(ALL.EL.p.all.org) <- c("Source", "Target", "weight")

ALL.EL.p.all.org <- ALL.EL.p.all.org %>% 
  group_by(Source, Target) %>%
  summarize_at("weight", sum)

ID <- sort(unique(c(ALL.EL.p.all.org$Source, ALL.EL.p.all.org$Target)))
Node.table.all <- data.frame(Id=ID, Label=ID, tech=substr(ID, 0,1))

# Network analysis
summ.cen.all.org <- get.centrality(ALL.G.p.all.org) %>% 
  mutate(qc_category = "all")
save(summ.cen.all.org, file=paste0(dir,"/summ.cen.all.org.RData"))
summ.cen.all.org %>% arrange(desc(Deg))

ALL.EL.total.org.all %>% arrange(desc(weight)) %>%
  head(20)

ALL.EL.total.org.all %>% arrange(desc(weight)) %>% head(200) %>%
  graph.data.frame(directed=FALSE) %>%
  ggnet2(size = "degree", label=FALSE, #edge.size = "weights", 
         alpha=0.5, edge.color="grey") +
  guides(size=FALSE) 

