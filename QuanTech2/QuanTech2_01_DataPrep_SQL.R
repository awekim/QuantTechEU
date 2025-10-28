#######################################################################
##  Made by: Dr. Keungoui Kim
##  Title: Quantum Tech Project2 - Data Prep 01. SQL Extraction
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


