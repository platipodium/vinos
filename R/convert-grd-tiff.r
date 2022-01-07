
#install.packages('raster')
#install.packages('rgdal')

# load the raster, sp, and rgdal packages
library(raster)
library(sp)
library(rgdal)

dname <- '/Users/Lemmen/projects/mossco/2022/fish-netlogo/R'
fname <- '/Users/Lemmen/projects/mossco/2022/fish-netlogo/R/dis.20102014.winter.grd'

df_crangon_all = raster(fname, band=1)
df_merlangus_min = raster(fname, band=2)
df_merlangus_max = raster(fname, band=3)
df_platessa_min = raster(fname, band=4)
df_platessa_max = raster(fname, band=5)
df_solea_min = raster(fname, band=6)
df_solea_max = raster(fname, band=7)
df_sprattus_all = raster(fname, band=8)

writeRaster(df_crangon_all,paste(dname,'dis.20102014.winter.crangon_all.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_merlangus_min,paste(dname,'dis.20102014.winter.merlangus_min.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_merlangus_max,paste(dname,'dis.20102014.winter.merlangus_max.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_platessa_min,paste(dname,'dis.20102014.winter.platessa_min.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_platessa_max,paste(dname,'dis.20102014.winter.platessa_max.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_solea_min,paste(dname,'dis.20102014.winter.solea_min.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_solea_max,paste(dname,'dis.20102014.winter.solea_max.tiff',sep='/'), overwrite=TRUE)
writeRaster(df_sprattus_all,paste(dname,'dis.20102014.winter.sprattus_tiff.asc',sep='/'), overwrite=TRUE)

rgdal::writeGDAL(as(Converted.proj, "SpatialGridDataFrame"), 
                 paste(dname,'dis.20102014.winter.sprattus_tiff.asc',sep='/'), 
                 drivername = "AAIGrid")


