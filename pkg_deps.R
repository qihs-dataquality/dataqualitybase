source("/home/rstudio/settings.R")
withr::with_tempdir({
  download.file(
    url =
      "https://gitlab.com/libreumg/dataquier/-/raw/master/DESCRIPTION?ref_type=heads&inline=false",
    destfile =
      "DESCRIPTION"
  )
  pak::local_install_dev_deps()
})
