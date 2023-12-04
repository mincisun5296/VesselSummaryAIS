#' Plot vessel locations
#'
#' @param AISdata Automatic Identification System (AIS) data downloaded from the U.S. Coast Guard (https://marinecadastre.gov/ais/). You can use the command: AISdata <- read.csv("AISdataname.csv", header = T) and input AISdata in the function
#' @param studyship The observed ship type; default is Cargo. Other types include Fishing, Military, Not_available, Passenger, Pleasure, Tanker, Tugboat, Others.
#' @param maxLON Maximum longitude of the study area
#' @param minLON Minimum longitude of the study area
#' @param maxLAT Maximum latitude of the study area
#' @param minLAT Minimum latitude of the study area
#'
#' @return Map of signal locations (Viewer Panel)
#' @export
#'
#' @examples plotvessel(AISdata)
#' @examples plotvessel(AISdata, 'Fishing')
#' @examples plotvessel(AISdata, studyship = 'Fishing', maxLON = -94.5, minLON = -95, maxLAT = 30, minLAT = 29)
plotvessel <- function(AISdata, studyship = 'Cargo', maxLON = -94.5, minLON = -95, maxLAT = 30, minLAT = 29){

  # Check studyship
  if (!(studyship %in% c('Cargo', 'Fishing', 'Military', 'Not_available', 'Passenger', 'Pleasure', 'Tanker', 'Tugboat', 'Others'))){
    stop('studyship is not recorded in the U.S. Coast Guard. Please input Cargo, Fishing, Military, Not_available, Passenger, Pleasure, Tanker, Tugboat, or Others (First letter is capital)')
  }


  #######begin########
  # Filtering: Specific study area
  AISdata <- AISdata[AISdata$LON > minLON & AISdata$LON < maxLON
                     & AISdata$LAT > minLAT & AISdata$LAT < maxLAT, ]

  # Filtering: Build new column and specify ship types
  AISdata['shiptype'] <- 0

  AISdata['shiptype'] <- classify(AISdata$VesselType)

  AISdata <- AISdata[ AISdata$shiptype == studyship, ] # AIS data extraction for the certain type

  # Mapping using mapview package##############################

  lng = AISdata$LON
  lat = AISdata$LAT

  # Create a data frame with the point data
  points_df = data.frame(lng, lat, studyship)

  # Convert the data frame to a spatial points data frame
  ship_signal_location = sf::st_as_sf(points_df,
                                  coords = c("lng", "lat"), crs = 4326)

  # Plot the points on a map
  mapview::mapview(ship_signal_location)

}



