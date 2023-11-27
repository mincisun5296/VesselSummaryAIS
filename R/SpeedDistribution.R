#' Plot speed histogram for a ship type
#'
#' @param AISdata Automatic Identification System (AIS) data downloaded from the U.S. Coast Guard (https://marinecadastre.gov/ais/). You can use the command: AISdata <- read.csv("AISdataname.csv", header = T) and input AISdata in the function
#' @param studyship The observed ship type; default is Cargo. Other types include Fishing, Military, Not_available, Passenger, Pleasure, Tanker, Tugboat, Others
#' @param maxLON Maximum longitude of the study area
#' @param minLON Minimum longitude of the study area
#' @param maxLAT Maximum latitude of the study area
#' @param minLAT Minimum latitude of the study area
#'
#' @return Histogram of the speed. An object of class "histogram" is a list with components. Please refer to hist
#' @export
#'
#' @examples speeddist(AISdata)
#' @examples speeddist(AISdata, 'Fishing')
#' @examples speeddist(AISdata, studyship = 'Fishing', maxLON = -90, minLON = -110, maxLAT = 30, minLAT = 20)
speeddist <- function(AISdata, studyship = 'Cargo', maxLON = -90, minLON = -110, maxLAT = 30, minLAT = 20){
  # Check studyship
  if (!(studyship %in% c('Cargo', 'Fishing', 'Military', 'Not_available', 'Passenger', 'Pleasure', 'Tanker', 'Tugboat', 'Others'))){
    stop('studyship is not recorded in the U.S. Coast Guard. Please input Cargo, Fishing, Military, Not_available, Passenger, Pleasure, Tanker, Tugboat, or Others (First letter is capital)')
  }


  #######begin########
  # Filtering: study area
  AISdata <- AISdata[AISdata$LON > minLON & AISdata$LON < maxLON
                     & AISdata$LAT > minLAT & AISdata$LAT < maxLAT, ]

  # Filtering: Build new column and specify ship types
  AISdata['shiptype'] <- 0
  AISdata['shiptype'] <- classify(AISdata$VesselType)
  AISdata <- AISdata[ AISdata$shiptype == studyship, ] # AIS data extraction for the certain type

  # Histogram of speed ##############################
  # SOG means speed over ground (extract the speed for a certain type and exclude NA)
  SOG_data <- AISdata$SOG[!is.na(AISdata$SOG)]

  # Create a histogram
  hist(SOG_data, main = paste("Histogram of SOG for", studyship),
     xlab = "Speed Over Ground (SOG) (Knots)", ylab = "Frequency of Observed Signals", col = "lightblue", border = "black")

}


