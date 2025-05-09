FROM ghcr.io/r-lib/rig/r
ARG RIG_R_VERSION

COPY --chmod=700 c23-workaround.sh /root/c23-workaround.sh

RUN chmod +x /root/c23-workaround.sh \
    && /root/c23-workaround.sh ${RIG_R_VERSION}; #Runs only if version is next or devel

RUN mkdir '/R_libs'

RUN rig default ${RIG_R_VERSION}
RUN mkdir '/R_libs/'$(rig default)
RUN echo 'R_LIBS_SITE='$(Rscript --vanilla -e 'cat(c(file.path("", "R_libs", system("rig default", intern=TRUE)), .Library.site), sep = ":")') >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Renviron"))')

COPY deps.sh /home/rstudio/deps.sh
RUN bash /home/rstudio/deps.sh && rm /home/rstudio/deps.sh

COPY settings.R /home/rstudio/settings.R

COPY deps.R /home/rstudio/deps.R
RUN Rscript /home/rstudio/deps.R ; rm /home/rstudio/deps.R

COPY pkg_deps.R /home/rstudio/pkg_deps.R
RUN Rscript /home/rstudio/pkg_deps.R  ; rm /home/rstudio/pkg_deps.R

RUN echo 'r = getOption("repos")' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
RUN echo 'r["CRAN"] = "https://cloud.r-project.org/"' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
RUN echo 'options(repos = r)' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))')
# RUN echo 'bspm::enable()' >> $(Rscript --vanilla -e 'cat(file.path(R.home(component = "home"), "etc", "Rprofile.site"))') # TODO: Make optional
