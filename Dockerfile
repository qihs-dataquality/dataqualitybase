FROM ghcr.io/r-lib/rig/r
RUN rig default next
# FROM runiverse/base:latest # can finish, but slow
# FROM rstudio/r-base:4.4.0-bookworm # not much faster
# FROM rocker/verse:latest
# FROM r-base:4.4.0
# FROM rocker/r-ver:4.3.3 # fast
# FROM rocker/r-ver:latest # ===:4.4.0 slow, but why?

# FROM rocker/verse:latest-daily # fast

## From https://github.com/exercism/r-test-runner/issues/59:
## ((https://github.com/rocker-org/rocker/issues/412 -- maybe, we observe some regression in R v4.4.0))
#ENV OMP_NUM_THREADS=1
#ENV OPENBLAS_NUM_THREADS=1

RUN mkdir '/R_libs'

RUN rig default oldrel
RUN mkdir '/R_libs/'$(rig default)
RUN echo 'R_LIBS_SITE='$(Rscript --vanilla -e 'cat(c(file.path("", "R_libs", system("rig default", intern=TRUE)), .Library.site), sep = ":")') >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Renviron"))')

RUN rig default next
RUN mkdir '/R_libs/'$(rig default)
RUN echo 'R_LIBS_SITE='$(Rscript --vanilla -e 'cat(c(file.path("", "R_libs", system("rig default", intern=TRUE)), .Library.site), sep = ":")') >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Renviron"))')

RUN rig default release
RUN mkdir '/R_libs/'$(rig default)
RUN echo 'R_LIBS_SITE='$(Rscript --vanilla -e 'cat(c(file.path("", "R_libs", system("rig default", intern=TRUE)), .Library.site), sep = ":")') >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Renviron"))')

RUN rig default devel
RUN mkdir '/R_libs/'$(rig default)
RUN echo 'R_LIBS_SITE='$(Rscript --vanilla -e 'cat(c(file.path("", "R_libs", system("rig default", intern=TRUE)), .Library.site), sep = ":")') >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Renviron"))')

RUN rig default next

COPY deps.sh /home/rstudio/deps.sh
RUN bash /home/rstudio/deps.sh
RUN rm /home/rstudio/deps.sh

COPY settings.R /home/rstudio/settings.R

COPY deps.R /home/rstudio/deps.R

RUN rig default next
RUN Rscript /home/rstudio/deps.R

RUN rig default devel
RUN Rscript /home/rstudio/deps.R || true

RUN rig default oldrel
RUN Rscript /home/rstudio/deps.R

RUN rig default release
RUN Rscript /home/rstudio/deps.R

RUN rig default next

RUN rm /home/rstudio/deps.R

COPY pkg_deps.R /home/rstudio/pkg_deps.R

RUN rig default next
RUN Rscript /home/rstudio/pkg_deps.R

RUN rig default devel
RUN Rscript /home/rstudio/pkg_deps.R || true

RUN rig default oldrel
RUN Rscript /home/rstudio/pkg_deps.R

RUN rig default release
RUN Rscript /home/rstudio/pkg_deps.R

RUN rig default next

RUN rm /home/rstudio/pkg_deps.R

RUN echo 'r = getOption("repos")' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
RUN echo 'r["CRAN"] = "https://cloud.r-project.org/"' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
RUN echo 'options(repos = r)' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
# RUN echo 'bspm::enable()' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))') # TODO: Make optional
