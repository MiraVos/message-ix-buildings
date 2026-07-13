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

lapply(list.files(input_path), function(f) {
  df <- read.csv(paste0(input_path, f))
  print(paste(f, "urt categories:", unique(df$urt)))
})
