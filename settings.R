# Sys.setenv(R_LIBS_USER="/R_libs")
.libPaths(file.path("", "R_libs", system("rig default", intern=TRUE)))

r <- getOption("repos")
r["CRAN"] <- "https://cloud.r-project.org/"
options(repos = r)

install.packages("bspm")

# bspm::enable() # TODO: Make optional

# file.path(R.home(component = "home"), "etc")
