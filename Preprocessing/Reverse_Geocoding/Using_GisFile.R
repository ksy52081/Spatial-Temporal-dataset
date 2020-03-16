#install.packages("data.table")
#install.packages("dplyr")
#install.packages("sp")
#install.packages("proj4")
#install.packages("rgeos")
#install.packages("maptools")

library(data.table)
library(dplyr)
library(sp)
library(proj4)
library(rgeos)
library(maptools)


# reading data
yellow14_Dec<-fread("D:/ChromeDownload/NYcap/yellow_tripdata_2014-12.csv",header=TRUE,sep=',')


columnlist<-names(yellow14_Dec)

## cut off column
yellow14_Dec<-yellow14_Dec[,c('vendor_id','pickup_datetime','dropoff_datetime','passenger_count','trip_distance','pickup_longitude','pickup_latitude','dropoff_longitude','dropoff_latitude','payment_type','fare_amount','surcharge','mta_tax','tip_amount','tolls_amount','total_amount')]

# preprocessing condition
yellow14_Dec <- filter(yellow14_Dec, trip_distance>0 & fare_amount>0 & passenger_count>0 & pickup_longitude> -80 & pickup_longitude< -71 & pickup_latitude>40 & pickup_latitude<47 & dropoff_longitude> -80 & dropoff_longitude< -71 & dropoff_latitude>40 & dropoff_latitude<71)
yellow14_Dec<- as.data.table(yellow14_Dec)
   

### loading nyc polygon shp
#https://dmckeage2.carto.com/tables/zip_code_040114/public/map
CRS_wgs84<-CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
yellow14_Dec_sp<-SpatialPointsDataFrame(yellow14_Dec[,.(pickup_longitude, pickup_latitude)], yellow14_Dec, proj4string=CRS_wgs84)
nyc_poly<-readShapePoly("D:/ChromeDownload/NYcap/NEWZIPCODE/ZIP_CODE_040114.shp",proj4string=CRS_wgs84)

#spatial join between the taxi trip records and the borough of NYC.
yellow14_Dec_spatial_join<-over(yellow14_Dec_sp, nyc_poly)

## WE DON'T NEED EVERYTHING 
names(yellow14_Dec_spatial_join)
yellow14_Dec_spatial_join<-yellow14_Dec_spatial_join[,c('bldgzip', 'po_name',  'population', 'area', 'state','county', 'zipcode','cty_fips','cartodb_id','st_fips')]

result_data<-cbind(yellow14_Dec, yellow14_Dec_spatial_join)
result_data<-as.data.table(result_data)

write.csv(result_data,"D:/ChromeDownload/NYcap/yellow14_Dec_ZipCode.csv", row.names = F)


