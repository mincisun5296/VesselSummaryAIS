#' Define the ship type given a ship code.
#'
#' @param shipcode   a code provided in the AIS data
#'
#' @return   Return a ship type, which can be Cargo, Fishing, Military, Not_available, Passenger, Pleasure, Tanker, Tugboat, and Others
#' @export
#'
#' @examples classify(70)
#' @examples classify(shipcode = 70)

# AIS data has the code of VesselType, but it's not intuitive. This function refers to
# U.S. Coast Guard to specify ship types for the AIS data
# see: 2018, AIS Vessel Type and Group Codes used by the Marine Cadastre Project (chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://coast.noaa.gov/data/marinecadastre/ais/VesselTypeCodes2018.pdf)
classify <- function(shipcode) {
  ifelse(shipcode %in% c(70, 80, 1003, 1004, 1016), 'Cargo',   # Cargo
         ifelse(shipcode %in% c(30, 1001, 1002), 'Fishing',           # Fishing
                ifelse(shipcode %in% c(35, 1021), 'Military',                # Military
                       ifelse(shipcode %in% c(0), 'Not_available',                 # Not available
                              ifelse(shipcode %in% c(60:69, 1012:1015), 'Passenger',           # Passenger
                                     ifelse(shipcode %in% c(36, 37, 1019), 'Pleasure',               # Pleasure Craft/Sailing
                                            ifelse(shipcode %in% c(80:90, 1017, 1024), 'Tanker',          # Tanker
                                                   ifelse(shipcode %in% c(21, 22, 31, 32, 52, 1023, 1025), 'Tugboat', 'Others'))))))))  # Tug Tow # Others
}
