#' Summarize the number and dimensions for each shiptype within study areas
#'
#' @param AISdata Automatic Identification System (AIS) data downloaded from the U.S. Coast Guard (https://marinecadastre.gov/ais/). You can use the command: AISdata <- read.csv("AISdataname.csv", header = T) and input AISdata in the function
#' @param maxLON Maximum longitude of the study area
#' @param minLON Minimum longitude of the study area
#' @param maxLAT Maximum latitude of the study area
#' @param minLAT Minimum latitude of the study area
#'
#' @return A data frame with the number and dimension of ships for each ship type
#' @export
#'
#' @examples summarizeship(AISdata, maxLON=-80, minLON=-100, maxLAT= 40, minLAT= 20)
#' @examples summarizeship(AISdata)
summarizeship <- function(AISdata = AISdata, maxLON = -90, minLON = -110, maxLAT = 30, minLAT = 20) {

  # build new column and specify ship types
  AISdata['shiptype'] <- 0

  #extract VesselType code to define its shiptype
  #source('R/ClassifyShip.R')

  AISdata['shiptype'] <- classify(AISdata$VesselType)

  ###############################################################
  # Specific study area
  AISdata <- AISdata[AISdata$LON > minLON & AISdata$LON < maxLON
                     & AISdata$LAT > minLAT & AISdata$LAT < maxLAT, ]

  # Get unique vessel info
  AISdata <- unique(AISdata[, c("MMSI", "shiptype", "Length", "Width")])


  ###############################################################
  # summary statistics:   ship type vs number
  # Create a table of counts for each combination of MMSI and shiptype
  ship_type_counts <- table(AISdata$shiptype)  # get type and counts

  # Convert the table to a data frame for better readability
  ship_summary <- as.data.frame(ship_type_counts)
  names(ship_summary) <- c("shiptype", "number")

  ####################################################################################
  # get average ship length and width to add on the info matrix "ship_summary"
  for (i in 1:nrow(ship_summary)){
    ship_type <- ship_summary[i, 'shiptype']

    avg_length <- mean(AISdata$Length[  # take the avg of length for a certain shiptype
      AISdata$shiptype == ship_type             # ship type
      & AISdata$Length > 0
      & !is.na(AISdata$Length)]             # exclude 0 and missing data
    )

    avg_width <- mean(AISdata$Width[  # take the avg of width for a certain shiptype
      AISdata$shiptype == ship_type             # ship type
      & AISdata$Width > 0
      & !is.na(AISdata$Width)]             # exclude 0 and missing data
    )

    ship_summary[i, 'length(meters)'] <- avg_length
    ship_summary[i, 'width(meters)'] <- avg_width

  }

  return(ship_summary)
}
