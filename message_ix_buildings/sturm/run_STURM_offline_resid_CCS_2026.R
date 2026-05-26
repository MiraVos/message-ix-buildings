# Script to be run in Rstudio

library(rstudioapi)
library(tidyverse)
library(readxl)
library(conflicted) #used to indicate preference for conflicting packages
conflicts_prefer(dplyr::filter())
conflicts_prefer(dplyr::lag())

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#Paths
rcode_path <- paste(getwd(),"/model/",sep="")
data_path <- paste(getwd(),"/data/",sep="")
input_path <- paste(getwd(),"/data/input_csv_NUTS_2025_resid/",sep="")
rout_path <- paste(getwd(),"/output/",sep="")

#Source model function
#source("./model/F10_scenario_runs_MESSAGE_2100.R")
source(paste0(rcode_path, "F10_scenario_runs_MESSAGE_2100.R"))

#Source prices
prices <- read_csv(paste0(data_path,"input_prices_R12.csv"))

#Scenarios
#scenarios = c("NPi-REF","NPi-ACT","NPi-ELE","NPi-TEC","NPi-ALL","1.5C-REF","1.5C-ACT","1.5C-ELE","1.5C-TEC", "1.5C-ALL")
scenarios = c("SSP2-baseline", "SSP2-CCS-dwn", "SSP2-CCS-dwn-cutoff", "SSP2-DLS") #c("SSP2-NUTS-BLD", "SSP2-NUTS-BLD-DLS", "SSP2-NUTS-BLD-CCS-dwn", "SSP2-NUTS-BLD-CCS-dwn-uniform", "SSP2-NUTS-BLD-CCS-dwn-high","SSP2-NUTS-BLD-CCS-shr", "SSP2-NUTS-BLD-CCS-shr-uniform", "SSP2-NUTS-BLD-CCS-mov", "SSP2-NUTS-BLD-CCS-mov-uniform") 

# Regions:
#regions_eu27_3 <- read_csv(paste0(input_path,"regions_R61_nuts.csv"))$region_nuts#[sample(1:1160, 100)]#NOTE: samples 100 NUTS3 regions from set [1:1165]
#  [grep("ITA", read_csv(paste0(path_input,"regions_R61_nuts.csv"))$region_nuts)]
regions_eu27_3 <- c("C-EEU-BGR","C-EEU-CZE","C-EEU-EST","C-EEU-HRV","C-EEU-HUN","C-EEU-LTU","C-EEU-LVA","C-EEU-POL", "C-EEU-ROU","C-EEU-SVK","C-EEU-SVN","C-WEU-AUT","C-WEU-BEL","C-WEU-CYP","C-WEU-DEU","C-WEU-DNK","C-WEU-ESP","C-WEU-FIN","C-WEU-FRA","C-WEU-GRC","C-WEU-IRL","C-WEU-ITA","C-WEU-LUX","C-WEU-MLT","C-WEU-NLD","C-WEU-PRT","C-WEU-SWE") #,"C-WEU-NOR","C-WEU-GBR","C-WEU-CHE"
#regions_eu27_3 <- c("C-WEU-ITA")

for(s in scenarios){
  
  # call STURM
  sturm_scenarios <- run_scenario(run = s,
                                  sector = "resid",
                                  path_in=data_path,
                                  path_inputs=input_path,
                                  path_rcode=rcode_path,
                                  path_out=rout_path,
                                  prices=prices, #NULL
                                  file_inputs = "input_list_resid_2026_04_08_CCS.csv",
                                  #file_data_model = "data_model_resid_SSP_2023.csv",
                                  #file_scenarios = "scenarios_SSP_2023.csv",
                                  geo_level = "region_bld", # Level for analysis, "region_nuts",
                                  geo_level_aggr = "region_gea", # Level for aggregated data
                                  geo_levels = c("region_bld", "region_gea"), # Levels to keep track of
                                  geo_level_report="region_bld", # Level for reporting
                                  region_select = list("region_bld", regions_eu27_3), #NULL 
                                  yrs = seq(2020,2050,5), #seq(2020,2050,15) #seq(2020,2030,5) #c(seq(2020,2060,5),seq(2070,2100,10))
                                  input_mode = "csv",
                                  mod_arch = "stock",
                                  mod_new = "endogenous",#"external", 
                                  mod_ren = "endogenous",#"external", 
                                  report_type = c("STURM"), # Available reports: c("MESSAGE","STURM","IRP","NGFS","NAVIGATE")
                                  report_var = c("energy","material") # Available report variables: c("energy","material","vintage","dle")
                                  )

}




# 
# # write results to csv file
# write.csv(sturm_scenarios,paste("./temp/",sect,"_sturm.csv",sep=""),row.names=F)





# ##############################################
# 
# ## Run out of the function - For debugging
# 
# # Run the commands below and then the content of function "run_scenario" in the script "F10_scenario_runs_MESSAGE_2100.R"
# 
# rcode_path <- paste(getwd(),"/model/",sep="")
# data_path <- paste(getwd(),"/data/",sep="")
# input_path <- paste(getwd(),"/data/input_csv_SSP_2023_ex/",sep="")
# rout_path <- paste(getwd(),"/output/",sep="")
# 
# file_inputs <- "input_list_resid_SSP_2023_ex.csv"
# #file_scenario <- "scenarios_SSP_2023.csv"
# #file_data_model = "data_model_resid_SSP_2023.csv"
# 
# 
# #prices<-read_csv(paste0(getwd(),"/data/","input_prices_R12.csv"))
# 
# scen <- "IND_SSP2"
# 
# sect <- "resid"
# #sect <- "comm"
# 
# run = scen
# prices=prices
# path_in=data_path
# path_inputs=input_path
# path_rcode=rcode_path
# path_out=rout_path
# sector=sect
# geo_level = "region_bld" # Level for analysis
# geo_level_aggr = "region_gea" # Level for aggregation
# geo_levels <- c("region_bld", "region_gea") # Levels to keep track of
# geo_level_report="R12"
# yrs = seq(2020,2030,5)
# # yrs <- c(seq(2020,2060,5),seq(2070,2100,10))
# 
# # # Input data type: 
# # Values allowed: "RData", "csv"
# input_mode <- "csv"
# #input_mode <- "rdata"
# 
# # Running setting: # Share of buildings archetypes:
# # mod_arch = "new",  # provided for new buildings (on the margin)
# mod_arch <- "stock" # provided for the entire stock - Default
# 
# # Report types
# report_type = c("MESSAGE","STURM","NAVIGATE") # Available reports: c("MESSAGE","STURM","IRP","NGFS","NAVIGATE")
# 
# # Reporting variables
# report_var=c("energy","material") # Available report variables: c("energy","material","vintage","dle")
# 
# region_select = NULL
# 
# mod_new = "exogenous"
# mod_ren = "exogenous"
# 
# 
