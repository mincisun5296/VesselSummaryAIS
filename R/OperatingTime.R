#' Calculate the total operating time for each vessel and each ship type
#'
#' @param AISdata Automatic Identification System (AIS) data downloaded from the U.S. Coast Guard (https://marinecadastre.gov/ais/). You can use the command: AISdata <- read.csv("AISdataname.csv", header = T) and input AISdata in the function
#' @param activityspeed Definition of the operating speed. Default speed is 3 knot, meaning that only activity segment with over 3 knots will be considered.
#' @param maxLON Maximum longitude of the study area
#' @param minLON Minimum longitude of the study area
#' @param maxLAT Maximum latitude of the study area
#' @param minLAT Minimum latitude of the study area
#'
#' @return A list of two data frames. The first data frame is the operating time for each vessel (MMSI); the second data frame is operating time for ship types.
#' @export
#'
#' @examples operatingtime(AISdata)
#' @examples operatingtime(AISdata, activityspeed = 5)
#' @examples operatingtime(AISdata, activityspeed = 5 , maxLON = -90, minLON = -110, maxLAT = 30, minLAT = 20)
operatingtime <- function(AISdata, activityspeed = 3, maxLON = -90, minLON = -110, maxLAT = 30, minLAT = 20){

  # Filtering: study area
  AISdata <- AISdata[AISdata$LON > minLON & AISdata$LON < maxLON
                     & AISdata$LAT > minLAT & AISdata$LAT < maxLAT, ]

  # Filtering: Build new column and specify ship types
  AISdata['shiptype'] <- 0
  AISdata['shiptype'] <- classify(AISdata$VesselType)

  # Ordering the data based on MMSI and time
  AISdata <- AISdata[order(AISdata$MMSI, AISdata$BaseDateTime, decreasing = FALSE), ]

  ###############################################################
  # Calculate the segment of each activity time for each vessel
  # create a data frame with columns: "MMSI", "Activity_time", "Speed", "Shiptype"
  activity_df <- matrix(0, 1, 4)
  activity_df <-  as.data.frame(activity_df)
  names(activity_df) <- c("MMSI", "Activity_time", "Speed", "Shiptype")

  # list of unique MMSI
  MMSIlist <- unique(AISdata$MMSI)

  for (ID in MMSIlist){
    # generate an AIS data frame for a certain ship (MMSI is ID)
    specific_MMSI_AISdata <- AISdata[AISdata$MMSI == ID, ]

    signalnumber <- nrow(specific_MMSI_AISdata)

    # only more than two signals can form an activity
    if (signalnumber >=2){
      # Calculate the difference between consecutive rows of Basetime
      for (i in 1:( signalnumber- 1)){
        time1 <- specific_MMSI_AISdata[i,  'BaseDateTime']
        time2 <- specific_MMSI_AISdata[i + 1,  'BaseDateTime']
        activity_duration <- as.POSIXct(time2, format = "%Y-%m-%dT%H:%M:%S") - as.POSIXct(time1, format = "%Y-%m-%dT%H:%M:%S")

        speed1 <- specific_MMSI_AISdata[i,  'SOG']
        speed2 <- specific_MMSI_AISdata[i + 1,  'SOG']
        Avgspeed <- (speed1 + speed2) / 2

        shiptype <- specific_MMSI_AISdata[1,  'shiptype']

        # the activity is considered as operating while the speeds are more than 3
        activity_df <- rbind(activity_df, c(MMSI = ID, Activity_time = activity_duration, Speed = Avgspeed, Shiptype = shiptype))
      }
    }
  }
  activity_df <- activity_df[-1, ] # remove the first row of 0 (it was created while we do the first rows)

  # remove those speed is less than 3 knots
  activity_df <- activity_df[activity_df$Speed > activityspeed ,  ]



  #########################################################
  # calculate the total operating time for each MMSI
  MMSIlist <- unique(activity_df$MMSI)

  MMSIoutput <- matrix(0, length(MMSIlist), 3)
  MMSIoutput <- as.data.frame(MMSIoutput)
  names(MMSIoutput) <- c("MMSI", "Total_operating_time_minutes", "Shiptype")

  i <-  1
  for (ID in MMSIlist){
    totaltime <- sum(
      as.numeric(
        activity_df[activity_df$MMSI ==ID, ]$Activity_time
      )
    )
    shiptype <-  activity_df[activity_df$MMSI == ID, ]$Shiptype[1]
    MMSIoutput[i,] <- c(ID, totaltime, shiptype)
    i <- i+1
  }

  # get MMSIoutput

  ###############
  # calculate the operating time for each shiptype
  # same as above
  typelist <- unique(MMSIoutput$Shiptype)

  shiptypeoutput <- matrix(0, length(typelist), 2)
  shiptypeoutput <- as.data.frame(shiptypeoutput)
  names(shiptypeoutput) <- c("Shiptype", "Total_operating_time_minutes")

  i <-  1
  for (type in typelist){
    totaltime <- sum(
      as.numeric(
        MMSIoutput[MMSIoutput$Shiptype == type, ]$Total_operating_time_minutes
      )
    )
    shiptypeoutput[i,] <- c(type, totaltime)
    i <- i+1
  }

  # get shiptypeoutput

  output <- list(MMSIoutput, shiptypeoutput)

  return (output)

}
