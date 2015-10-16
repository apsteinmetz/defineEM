# use cluster analysis to define em
library(choroplethr)
library(choroplethrMaps)
library(countrycode)
library(dplyr)
library(ggplot2)
library(stringr)
library(reshape2)


#gapminder?

#scrape web data on some country stats
#physicians per 100k population from WHO
#HRH_26 is the physician field
data("country.regions")
urltxt<-"http://apps.who.int/gho/athena/data/xmart.csv?target=GHO/HRH_26&profile=xmart&filter=COUNTRY:*"
rawCSV<-read.csv(urltxt, header = T,stringsAsFactors = F)
doctorsRaw<-rawCSV[,c("YEAR","COUNTRY","Numeric")]
temp<-as.data.frame((dcast(doctorsRaw,YEAR~COUNTRY)))
doctors<-as.data.frame(t(na.locf(temp[,-1])))
names(doctors)<-temp[,1]
rownames(doctors)<-countrycode(rownames(doctors),"iso3c","iso2c")
doctors<-cbind(doctors,iso2c=rownames(doctors))
doctors<-inner_join(doctors,country.regions)
##################################
cTemp<-data.frame(region=doctors[,"region"],value=doctors[,"2014"],stringsAsFactors = F)
country_choropleth(cTemp)
