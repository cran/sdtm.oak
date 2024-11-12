## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(sdtm.oak)

## -----------------------------------------------------------------------------
create_iso8601("2000 01 05", .format = "y m d")
create_iso8601("22:35:05", .format = "H:M:S")

## -----------------------------------------------------------------------------
create_iso8601("2000-01-05 22:35:05", .format = "y-m-d H:M:S")

## -----------------------------------------------------------------------------
create_iso8601("2000-01-05", "22:35:05", .format = c("y-m-d", "H:M:S"))

## -----------------------------------------------------------------------------
date <- c("2000-01-05", "2001-12-25", "1980-06-18", "1979-09-07")
time <- c("00:12:21", "22:35:05", "03:00:15", "07:09:00")
create_iso8601(date, time, .format = c("y-m-d", "H:M:S"))

## -----------------------------------------------------------------------------
date <- c("2000-01-05", "2001-12-25", "1980-06-18", "1979-09-07")
time <- "00:12:21"
try(create_iso8601(date, time, .format = c("y-m-d", "H:M:S")))

## -----------------------------------------------------------------------------
year <- c("99", "84", "00", "80", "79", "1944", "1953")
month_and_day <- c("jan 1", "apr 04", "mar 06", "jun 18", "sep 07", "sep 13", "sep 14")
hour <- c("12", "13", "05", "23", "16", "16", "19")
min <- c("0", "60", "59", "42", "44", "10", "13")
create_iso8601(year, month_and_day, hour, min, .format = c("y", "m d", "H", "M"))

## -----------------------------------------------------------------------------
try(create_iso8601("2000-01-05", "y-m-d"))

## -----------------------------------------------------------------------------
create_iso8601("2000-01-05", .format = "y-m-d")
create_iso8601("2000 01 05", .format = "y m d")
create_iso8601("2000/01/05", .format = "y/m/d")

## -----------------------------------------------------------------------------
create_iso8601("2000 01 05", .format = "y m d")
create_iso8601("05 01 2000", .format = "d m y")
create_iso8601("01 05, 2000", .format = "m d, y")

## -----------------------------------------------------------------------------
date <- c("2000 01 05", "2000  01 05", "2000 01  05", "2000   01   05")
create_iso8601(date, .format = "y m d")
create_iso8601(date, .format = "y  m d")
create_iso8601(date, .format = "y m  d")
create_iso8601(date, .format = "y   m   d")

## -----------------------------------------------------------------------------
create_iso8601(date, .format = "y\\s+m\\s+d")

## -----------------------------------------------------------------------------
date <- c("2000-01-05", "2001-12-25", "1980-06-18", "1979-09-07")
time <- c("00:12:21", "22:35:05", "03:00:15", "07:09:00")
create_iso8601(date, time, .format = c("y-m-d", "H:M:S"))
create_iso8601(date, time, .format = c("yyyy-mm-dd", "HH:MM:SS"))
create_iso8601(date, time, .format = c("yyyyyyyy-m-dddddd", "H:MMMMM:SSSS"))

## -----------------------------------------------------------------------------
date <- c("2000/01/01", "2000-01-02", "2000 01 03", "2000/01/04")
create_iso8601(date, .format = "y-m-d")
create_iso8601(date, .format = "y m d")
create_iso8601(date, .format = "y/m/d")
create_iso8601(date, .format = list(c("y-m-d", "y m d", "y/m/d")))

## -----------------------------------------------------------------------------
create_iso8601("07 04 2000", .format = list(c("d m y", "m d y")))
create_iso8601("07 04 2000", .format = list(c("m d y", "d m y")))

## -----------------------------------------------------------------------------
# Years: two-digit or four-digit numbers.
years <- c("0", "1", "00", "01", "15", "30", "50", "68", "69", "80", "99")
create_iso8601(years, .format = "y")

# Adjust the point where two-digits years are mapped to 2000's or 1900's.
create_iso8601(years, .format = "y", .cutoff_2000 = 20L)

# Both numeric months (two-digit only) and abbreviated months work out of the box
months <- c("0", "00", "1", "01", "Jan", "jan")
create_iso8601(months, .format = "m")

# Month days: single or two-digit numbers, anything else results in NA.
create_iso8601(c("1", "01", "001", "10", "20", "31"), .format = "d")

# Hours
create_iso8601(c("1", "01", "001", "10", "20", "31"), .format = "H")

# Minutes
create_iso8601(c("1", "01", "001", "10", "20", "60"), .format = "M")

# Seconds
create_iso8601(c("1", "01", "23.04", "001", "10", "20", "60"), .format = "S")

## -----------------------------------------------------------------------------
create_iso8601("U DEC 2019 14:00", .format = "d m y H:M")
create_iso8601("U DEC 2019 14:00", .format = "d m y H:M", .na = "U")

create_iso8601("U UNK 2019 14:00", .format = "d m y H:M")
create_iso8601("U UNK 2019 14:00", .format = "d m y H:M", .na = c("U", "UNK"))

## -----------------------------------------------------------------------------
create_iso8601("U UNK 2019 14:00", .format = "(d|U) (m|UNK) y H:M")

## -----------------------------------------------------------------------------
create_iso8601("14H00M", .format = "HHMM")
create_iso8601("14H00M", .format = "xHwM", .fmt_c = fmt_cmp(hour = "x", min = "w"))

## -----------------------------------------------------------------------------
fmt_cmp(hour = "h", min = "m")
try(create_iso8601("14H00M", .format = "hHmM", .fmt_c = fmt_cmp(hour = "h", min = "m")))

