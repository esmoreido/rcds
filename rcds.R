Sys.setlocale("LC_ALL","Russian")
library(ecmwfr)
library(keyring)
library(lubridate)
library(ncdf4)
library(sf)
setwd(paste0('C:', Sys.getenv("HOMEPATH"), '\\Rprojects\\rcds\\'))
UID <- '' # ��� UID �� ������� �������� �� https://cds.climate.copernicus.eu
API_key <- '' # ��� API key �� ������� �������� �� https://cds.climate.copernicus.eu
wf_set_key(UID, API_key, 'cds') # ��������� UID � API key
rm(API_key)

# �������
shp_file <- st_read('shp/protva_basin.shp')
coords <- st_bbox(shp_file)
coords <- c(coords[4], coords[1], coords[2], coords[3]) # ���������� �����/�����/��/������

#�����
f.years <- seq(2003, 2005, 1)
f.months <- sprintf("%02d", seq(1, 12, 1))
f.days <- sprintf("%02d", seq(1, 31, 1))
f.hours <- c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00",
             "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
             "18:00", "19:00", "20:00", "21:00", "22:00", "23:00")

r <- list() # ������ ������ ��� ���������� ������� � CDS

vars <- c('2m_temperature','total_precipitation','2m_dewpoint_temperature')
# ���� �� ����
for(y in f.years){
    r[['product_type']] = "reanalysis" # ��� ��������
    r[['format']] = "netcdf" # ������ GRIB ��� netCDF
    r[['year']] = as.character(y) # ��� �� �����
    # r[['variable']] = d # ���������� �� �����
    r[['variable']] = vars
    r[['area']] = coords # ���������� �����/�����/��/������
    r[['month']] = f.months # ������������� ������, ������������ ������������������ ��������� ����� � "0" ����� ���������
    r[['day']] = f.days # ������������� ���, ������������ ������������������ ��������� ����� � "0" ����� ���������
    r[['time']] = f.hours # ����
    r[['dataset']] = "reanalysis-era5-single-levels" # ����� ������ � ����� ()
    r[['target']] = paste0("era5_", y, "_Jan-Dec", ".nc")
    print(r)
    ncfile <- wf_request(user = UID,
                         request = r,
                         transfer = TRUE,
                         path = getwd(),
                         verbose = TRUE)
  }
# }

# ������ �������
request <- list(
  product_type = "reanalysis",
  format = "netcdf",
  variable = "2m_temperature",
  year = "2019",
  area = "56/96/51/107",
  month = c("01", "02", "03", "04", "05", "06", "07"),
  day = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"),
  time = c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"),
  dataset = "reanalysis-era5-single-levels",
  target = "era5_2019_Jan-Jul_t2.nc"
)
