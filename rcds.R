Sys.setlocale("LC_ALL","Russian")
library(ecmwfr)
library(keyring)
library(lubridate)
library(ncdf4)
library(sf)
setwd(paste0('C:', Sys.getenv("HOMEPATH"), '\\Rprojects\\rcds\\'))
UID <- '' # ваш UID из личного кабинета на https://cds.climate.copernicus.eu
API_key <- '' # ваш API key из личного кабинета на https://cds.climate.copernicus.eu
wf_set_key(UID, API_key, 'cds') # установка UID и API key
rm(API_key)

# экстент
shp_file <- st_read('shp/protva_basin.shp')
coords <- st_bbox(shp_file)
coords <- c(coords[4], coords[1], coords[2], coords[3]) # координаты Север/Запад/Юг/Восток

#время
f.years <- seq(2003, 2005, 1)
f.months <- sprintf("%02d", seq(1, 12, 1))
f.days <- sprintf("%02d", seq(1, 31, 1))
f.hours <- c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00",
             "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
             "18:00", "19:00", "20:00", "21:00", "22:00", "23:00")

r <- list() # пустой список для параметров запроса к CDS

vars <- c('2m_temperature','total_precipitation','2m_dewpoint_temperature')
# цикл по одам
for(y in f.years){
    r[['product_type']] = "reanalysis" # тип продукта
    r[['format']] = "netcdf" # формат GRIB или netCDF
    r[['year']] = as.character(y) # год из цикла
    # r[['variable']] = d # переменная из цикла
    r[['variable']] = vars
    r[['area']] = coords # координаты Север/Запад/Юг/Восток
    r[['month']] = f.months # запрашиваемые месяцы, генерируется последовательность строковых чисел с "0" перед единицами
    r[['day']] = f.days # запрашиваемые дни, генерируется последовательность строковых чисел с "0" перед единицами
    r[['time']] = f.hours # часы
    r[['dataset_short_name']] = "reanalysis-era5-single-levels" # набор данных с сайта ()
    r[['target']] = paste0("era5_", y, "_Jan-Dec", ".nc")
    print(r)
    ncfile <- wf_request(user = UID,
                         request = r,
                         transfer = TRUE,
                         path = getwd(),
                         verbose = TRUE)
  }
# }

# пример запроса
request <- list(
  product_type = "reanalysis",
  format = "netcdf",
  variable = "2m_temperature",
  year = "2019",
  area = "56/96/51/107",
  month = c("01", "02", "03", "04", "05", "06", "07"),
  day = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"),
  time = c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"),
  dataset_short_name = "reanalysis-era5-single-levels",
  target = "era5_2019_Jan-Jul_t2.nc"
)

ncfile <- wf_request(user = "10804",
                     request = request,   
                     transfer = TRUE,  
                     path = getwd(),
                     verbose = TRUE)
