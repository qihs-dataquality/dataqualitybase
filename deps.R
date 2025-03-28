source("/home/rstudio/settings.R")
# Ensure we have the newest version of all packages
ips <- installed.packages()[, c("Package", "Version")]
print(paste0(ips[, "Package"], ": ", ips[, "Version"]))
cat("Updating all packages...\n")
update.packages(ask = FALSE, checkBuilt = TRUE)
cat("Updated all packages\n")
ips <- installed.packages()[, c("Package", "Version")]
print(paste0(ips[, "Package"], ": ", ips[, "Version"]))

install.packages("devtools")
install.packages("spelling")
install.packages("rcmdcheck")
install.packages("covr")
install.packages("qpdf")
Sys.setenv(DOWNLOAD_STATIC_LIBV8=1)
install.packages("V8")
install.packages("withr")

if (packageVersion("covr") < "3.6.4.9003") {
  locfil <- tempfile("covr", fileext = ".zip")
  download.file(
    "https://github.com/r-lib/covr/archive/refs/heads/main.zip",
    locfil
  )
  locdir <- tempfile("covr")
  unzip(locfil, exdir = locdir)
  devtools::install(pkg = file.path(locdir, "covr-main"))
}
