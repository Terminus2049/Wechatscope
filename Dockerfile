# Start from an image containing R, rmarkdown stuff and shiny server
FROM rocker/shiny
 
# Install packages required by my app
RUN R -e "install.packages(c('shiny', 'readr', 'DT', 'httr', 'data.table'), repos='http://cran.rstudio.com/')"
 
 
# Remove Shiny example inherited from the base image
RUN rm -rf /srv/shiny-server/*
 
 
# Copy the source code of the app to the container 
COPY . /srv/shiny-server/
 
 
# Start the server with the container
CMD ["/usr/bin/shiny-server.sh"]
