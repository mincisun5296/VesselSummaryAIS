#' AISdata
#'
#' The AISdata is created through the real AIS data of 2022-01-03 to serve as an example. Since 2012, the U.S. Coast Guard has collected dynamic vessel traffic data, or Automatic Identification System (AIS) data, to ensure the safety of vessel travels. The data can be downloaded from https://marinecadastre.gov/ais/ , and it contains 17 variables for each signal. This AISdata extract the first 99999 rows of information for testing.


#'@format A data frame with 99999 rows and 17 variables. However, please note that in the VesselSummaryAIS package, only variables of MMSI, BaseDataTime, LAT, LON, SOG, VesselType, Length, and Width are used.
#' \describe{
#' \item{MMSI}{Maritime Mobile Identity value, which is an ID of a vessel.}
#' \item{BaseDataTime}{The UTC data and time that location signal is received}
#' \item{LAT}{Latitude}
#' \item{LON}{Longitude}
#' \item{SOG}{Speed Over Ground in knots}
#' \item{COG}{Course Over Ground in degrees}
#' \item{Heading}{Heading angle in degrees}
#' \item{VesselName}{Name as shown on the station radio license }
#' \item{IMO}{International Maritime Organization Vessel number}
#' \item{CallSign}{Call sign as assigned by Federal Communications Commission}
#' \item{VesselType}{Vessel type as defined in NAIS specifications. You can use classify(VesselType) to get the ship type}
#' \item{Status}{Navigation status as defined by the COLREGS}
#' \item{Length}{Length of vessel in meters}
#' \item{Width}{Width of vessel in meters}
#' \item{Draft}{Draft depth of vessel in meters}
#' \item{Cargo}{Cargo type}
#' \item{TransceiverClass}{Class of AIS transceiver}
#' }


#' @source {Created through the AIS data of 2022-01-03 to serve as an example}
#' @examples
#' data(AISdata)

"AISdata"
