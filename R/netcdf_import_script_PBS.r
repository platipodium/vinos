# SPDX-FileCopyrightText: 2022 Thuenen Institut
# SPDX-License-Identifier: Unlicensed
# SPDX-FileContributor: Nik Probst

# Grids to be projected on
prd.grd.low<-raster(nrow=48,ncol=104,xmn=-3,xmx=10,ymn=51,ymx=57)
prd.grd<-raster(nrow=120,ncol=260,xmn=-3,xmx=10,ymn=51,ymx=57)
crs(prd.grd.low)<-CRS("+init=epsg:4326")
crs(prd.grd)<-CRS("+init=epsg:4326")

# Import NetCDF
ncid <- nc_open("D:/SF_Projekte/MuSSeL/WP5 Distribution modelling/data/2003-2013_mossco_CAL/2003-2013_timeaverage.nc")
lon <- ncvar_get(ncid,"getmGrid3D_x")
lon[which(lon>100)]<-NA
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncid,"getmGrid3D_y")
lat[which(lat>90)]<-NA
nlat <- dim(lat)
head(lat)

# Zooplankton carbon
zoo_array <- ncvar_get(ncid,"Zooplankton_Carbon_zooC_in_water")
zoo<-data.frame(lon=lon%>%as.vector %>% round (3),
                lat=lat%>%as.vector %>% round(3),
                zoo=zoo_array %>% as.vector) %>% na.omit

zoo.sp<-SpatialPointsDataFrame(coordinates(zoo[,1:2]),data=data.frame(zoo=zoo[,3]))
zoo<-rasterize(zoo.sp,prd.grd.low,field="zoo",method="nbh")
zoo<-resample(zoo,prd.grd,method="ngb")
zoo<-mask(zoo,pdgs[[1]])

# Detritus in water
det_array <- ncvar_get(ncid,"Detritus_Carbon_detC_in_water")# %>% as.vector
det<-data.frame(lon=lon%>%as.vector %>% round (3) ,lat=lat%>%as.vector %>% round(3),det=det_array %>% as.vector) %>% na.omit
det.sp<-SpatialPointsDataFrame(coordinates(det[,1:2]),data=data.frame(det=det[,3]))
det<-rasterize(det.sp,prd.grd.low,field="det",method="nbh")
det<-resample(det,prd.grd,method="ngb")
det<-mask(det,pdgs[[1]])

# Temperature
btt_array <- ncvar_get(ncid,"temperature_in_water")# %>% as.vector
btt<-data.frame(lon=lon%>%as.vector %>% round (3) ,lat=lat%>%as.vector %>% round(3),btt=btt_array %>% as.vector) %>% na.omit
btt.sp<-SpatialPointsDataFrame(coordinates(btt[,1:2]),data=data.frame(btt=btt[,3]))
btt<-rasterize(btt.sp,prd.grd.low,field="btt",method="nbh")
btt<-resample(btt,prd.grd,method="ngb")
btt<-mask(btt,pdgs[[1]])


