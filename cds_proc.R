Sys.setlocale("LC_ALL","Russian")
library(raster)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(ncdf4)
library(mapview)
library(sf)
library(data.table)
setwd(paste0('C:', Sys.getenv("HOMEPATH"), '\\Rprojects\\rcds\\'))

shp <- st_read('shp/protva_basin.shp')

f <- list.files(pattern = '*.nc$')
f

br <- brick(f[1])
br
coords <- as.data.frame(coordinates(br[[1]]))
coords$cell <- rownames(coords)

dat <- as.data.frame(extract(br - 273.15, baikal_bas, cellnumbers=T))
names <- dat$cell
dat <- as.data.frame(t(dat[,-1]))
names(dat) <- names
dat$datetime <- rownames(dat)
dat$datetime <- as.POSIXct(strptime(dat$datetime, format="X%Y.%m.%d.%H.%M.%S"))
datm <- melt(dat, id.vars='datetime')

df <- datm %>%
  dplyr::group_by(variable, date = date(datetime)) %>%
  dplyr::summarise(temp = mean(value, na.rm = T)) 

p1 <- ggplot(df, aes(x=date, y=temp, col=variable)) + geom_line() + theme(legend.position = "none")
p1
ggsave(p1, filename = paste0('out_', unique(year(df$date)),'.png'), device='png')
