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
yellow14<-fread("D:/SY/NYcap/yellow_tripdata_2014-03.csv",header=TRUE,sep=',')  ####################
#yellow14<-head(yellow14,10000)


#class(yellow14)
#columnlist<-names(yellow14)
#sample= head(columnlist, n=10)

## cut off column
yellow14<-yellow14[,c('vendor_id','pickup_datetime','dropoff_datetime','passenger_count','trip_distance','pickup_longitude','pickup_latitude','dropoff_longitude','dropoff_latitude','payment_type','fare_amount','surcharge','mta_tax','tip_amount','tolls_amount','total_amount')]

# preprocessing condition
yellow14 <- filter(yellow14, trip_distance>0 & fare_amount>0 & passenger_count>0 & pickup_longitude> -80 & pickup_longitude< -71 & pickup_latitude>40 & pickup_latitude<47 & dropoff_longitude> -80 & dropoff_longitude< -71 & dropoff_latitude>40 & dropoff_latitude<71)
yellow14<- as.data.table(yellow14)


### loading nyc polygon shp
#https://dmckeage2.carto.com/tables/zip_code_040114/public/map
CRS_wgs84<-CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
nyc_poly<-readShapePoly("D:/SY/NYcap/NEWZIPCODE/ZIP_CODE_040114.shp",proj4string=CRS_wgs84)

### normal -> Pickup
yellow14_pickup_sp<-SpatialPointsDataFrame(yellow14[,.(pickup_longitude, pickup_latitude)], yellow14, proj4string=CRS_wgs84)
#spatial join between the taxi trip records and the borough of NYC.
yellow14_pickup_spatial_join<-over(yellow14_pickup_sp, nyc_poly)
yellow14_pickup_spatial_join<-yellow14_pickup_spatial_join[,c('bldgzip', 'po_name', 'area', 'state','county', 'zipcode','cty_fips','cartodb_id','st_fips')]
names(yellow14_pickup_spatial_join)<-c('pickup_bldgzip', 'pickup_po_name',  'pickup_area', 'pickup_state','pickup_county', 'pickup_zipcode','pickup_cty_fips','pickup_cartodb_id','pickup_st_fips')


### pickup -> dropoff
yellow14_dropoff_sp<-SpatialPointsDataFrame(yellow14[,.(dropoff_longitude, dropoff_latitude)], yellow14, proj4string=CRS_wgs84)
#spatial join between the taxi trip records and the borough of NYC.
yellow14_dropoff_spatial_join<-over(yellow14_dropoff_sp, nyc_poly)
yellow14_dropoff_spatial_join<-yellow14_dropoff_spatial_join[,c('bldgzip', 'po_name', 'area', 'state','county', 'zipcode','cty_fips','cartodb_id','st_fips')]
names(yellow14_dropoff_spatial_join)<-c('dropoff_bldgzip', 'dropoff_po_name',  'dropoff_area', 'dropoff_state','dropoff_county', 'dropoff_zipcode','dropoff_cty_fips','dropoff_cartodb_id','dropoff_st_fips')



result_step1<-cbind(yellow14, yellow14_pickup_spatial_join)
result_step1<-as.data.table(result_step1)

result_data<-cbind(result_step1, yellow14_dropoff_spatial_join)
result_data<-as.data.table(result_data)

write.csv(result_data,"D:/SY/NYcap/yellow14_Mar_ZipCode_Ver2.csv", row.names = F)

