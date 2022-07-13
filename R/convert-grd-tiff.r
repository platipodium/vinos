# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Helmholtz-Zentrum Hereon 2021, 2022

#install.packages('raster')
#install.packages('rgdal')

# load the raster, sp, and rgdal packages
library(raster)
library(sp)
library(rgdal)

dname <- '/Users/Lemmen/projects/mossco/tex/2022/netlogo-northsea-species/R/'
fname <- '/Users/Lemmen/projects/mossco/tex/2022/netlogo-northsea-species/R/dis.20102014.winter.grd'

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
writeRaster(df_sprattus_all,paste(dname,'dis.20102014.winter.sprattus_all.tiff',sep='/'), overwrite=TRUE)

# Create a new raster with equal resolution in x and y
square <- raster(nrow=120, ncol=320, xmn=2, xmx=10, ymn=53, ymx=56)

writeRaster(resample(df_platessa_max, square, 'bilinear'),paste(dname,'dis.20102014.winter.platessa_max.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_platessa_min, square, 'bilinear'),paste(dname,'dis.20102014.winter.platessa_mix.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_merlangus_max, square, 'bilinear'),paste(dname,'dis.20102014.winter.merlangus_max.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_merlangus_min, square, 'bilinear'),paste(dname,'dis.20102014.winter.merlangus_min.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_solea_max, square, 'bilinear'),paste(dname,'dis.20102014.winter.solea_max.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_solea_min, square, 'bilinear'),paste(dname,'dis.20102014.winter.solea_min.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_sprattus_all, square, 'bilinear'),paste(dname,'dis.20102014.winter.sprattus_all.asc',sep='/'), overwrite=TRUE)
writeRaster(resample(df_crangon_all, square, 'bilinear'),paste(dname,'dis.20102014.winter.crangon_all.asc',sep='/'), overwrite=TRUE)
