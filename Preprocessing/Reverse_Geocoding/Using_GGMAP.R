library('ggmap')
register_google(key='')
##AIzaSyDglGuNAZE7fzqEr6er5EObrs_vDIUZGb8


----------------------------------------------------------------------
### 실제 데이터에서 주소만 알때 위도 경도 찾기)
name <-c("용두암","성산일출봉","정방폭포","중문관광단지","한라산1100고지","자귀도")

addr <-c("제주시 용두암길 15","서귀포시 성산읍 성산리","서귀포시 동홍동 299-3","서귀포시 중문동 2624-1","서귀포시 색달동 산1-2","제주시 한경면 고산리 125")

gc <- geocode(enc2utf8(addr))  ## 주소->위도경도 찾아주기

gc

df <- data.frame(name=names, lon=gc$lon, lat=gc$lat)

cen <- c(mean(df$lon),mean(df$lat))
map <- get_googlemap(center=cen, maptype="roadmap", zoom=10, size=c(640,640), marker=gc)
ggmap(map)

--------------------------------------------------------------------------


str(gc)
class(iris)
head(iris)
str(iris)

tb<-tibble(':)'='smile', ' ' = "space", '2000'="숫자"); tb

as_tibble(iris)

geocode("KAIST", "latlon")

geocode(location=enc2utf8("한국과학기술원&language=ko"),output="latlona")

geocode(location=enc2utf8("한국과학기술원&language=ko"),output="more")
## type: 주택, 기관등등,,,
## loctype : 더 세부적인 정보 제공
## 예시 : rooftop : 구체적인 geocode와 위치정보를 가진주소
## 예시 : range_interpolated : 구체적인 위치정보 없으나 주변 rooftop들의 정보로 대체



library(ggmap)
library(ggplot2)
str(quake)

df<-head(quakes,100)
cen <-c(mean(df$long), mean(df$lat))

gc <-data.frame(lon=df$long, lat=df$lat)
gc$lon<-ifelse(gc$lon>180, -(360-gc$lon), gc$lon)

get_googlemap(center=cen, maptype="roadmap", zoom=4, marker=gc) %>% ggmap()

###zoom : 3은 대륙급, 21은 빌딩급, default=10 도시급

ggmap(map)+theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())

ggmap(map)+geom_point(data=df, aes(x=long,y=lat,size=mag), alpha=0.5)
#데이터 산점도, 원의크기, 투명도

ggmap(map)+geom_point(data=quakes, aes(x=long,y=lat,col=depth), size=1)


ggmap(map)+geom_point(data=df, aes(x=long,y=lat,size=mag,col=depth), alpha=0.5)

-----------------------------------------------------------------

#지하철 2,3호선 나타내기
data <- read.csv('c:users/~~~~~~.csv', header=T)
data <- data[,c(2,3,8,9)]
colnames(data2) <-c('전철역명','호선','x좌표','y좌표')
head(data)
head(data2)

#2호선 추출
s_2 <-data2 %>% filter(호선=='2')

#상행 하행 모두 표시되어 절반만 추출한다.
N<-seq(1,44,2)
s_21 <-s_2[N,]

#투명도 조절(alpha 조건은 투명도 조절)
ggmap(seoul)+geom_point(data=s_21, aes(x=x좌표, y=y좌표), size=2.5, alpha=0.9)


#3호선
s_3 <- data2 %>% filter(호선=='3')
center <-c(mean(s_3$x좌표), mean(s_3$y좌표))
seoul <-get_map(center, zoom=10, maptype='roadmap')


##2,3,동시에 표시하기
ggmap(seoul, size=c(300,300)+ 
geom_point(data=s_2, aes(x=x좌표, y=y좌표), size=2.5, alpha=0.8, col="green", fill='white', stroke=3, shape=21)+#strok:테두리 굵기
geom_point(data=s_3, aes(x=x좌표, y=y좌표), size=2.5, alpha=0.9, col="orange" )+
geom_line(data=s_3, aes(x=x좌표, y=y좌표),linetype=1)+
geom_label(data=s_3, aes(x=x좌표, y=y좌표+0.005, label=절철역명),size=2.5)+
theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(), panel.background=element_rect(fill='green'), legend.position='right')

## theme : legend, title, 배경, axis의 line text등 부가적 요소의 변경

---------------------------------------------------------------------

주요 도시 인구 표시 (연속형 시각화)

data<- read.csv("~~~~.csv")

region <-data$지역명
lon <- data$lon
lat <-data$lat
pop <-data$population
data <-data.frame(region, lon, lat, pop)

center <-c(mean(data$lon), mean(data$lat))
map <-get_map(location=center, maptype("watercolor"),zoom=10)
m1<-ggmap(map)

#각 지역 표시하기
m1+geom_point(data=data, aes(x=lon,y=lat)

#인구별 색, 사이즈 정하기, labeling (population에 맞게 사이즈 변경, label넣기, 범례제목 변경하기)

m1+geom_point(data=data, aes(x=lon,y=lat, color=pop,size=pop)) +
geom_text(data=data, aes(x=lon, y-lat+0.05, label=region), size=3)+
scale_color_continuous(name="인구")+
scale_size_continuous(name="인구")

## 범례 설정 및 이름 정하기, scale_color/size_continuous/size_discrete : 연속형, 이산형에 따라 나뉘어짐.
---------------------------------------------------------
# 비연속형 시각화

#1. 데이터 다운로드
data<-read.csv("~~~~.csv")
head(data)
str(data)

#2. getmap : 지도 가져오기
library(ggmap)
map<-get_map("seoul",zoom=10, maptype="watercolor")
ggmap(map)

#3. data의 위도 경도 point찍기 + 학교 이름별로 색깔 변화
m2 <-ggmap(map)+geom_point(data=data, aes(x=lon, y=lat, color=학교명), size=3)

#4. label, 범례 제목 정해 넣기
m2 + geom_text(data=data, aes(x-lon+0.05, y=lat+0.05, label=학교명), size=3)+
scale_color_discrete(name="학교명") ## discrete

-------------------------------------------------------------

## 서울시 커피숍 주소 찾기
addr = []
for i in range: #input address into addr
  aaaa

add_vector=unlist(add) ##벡터화
geocode(enc2utf8(add_vector)





