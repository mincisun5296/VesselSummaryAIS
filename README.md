# R Package: VesselSummaryAIS
---
*This package provides vignettes for better illustrations.* 


## Background 

The U.S. Coast Guard has collected dynamic vessel traffic data, or Automatic Identification System (AIS) data, to ensure the safety of vessel travels in North America. Despite its public availability, the AIS data may not be intuitive to use because all the vessels' information is squeezed in a csv file. 

Therefore, this package is designed to analyze daily AIS data, providing a tool for practitioners to better understand the vessel activities and vessel compositions within a specified geographical area.

## Installation
Please install the developed package from my GitHub.
`install.packages("devtools")`
`devtools::install_github("mincisun5296/VesselSummaryAIS")`

## Introduction of AIS data 

The AIS data consists of vessel and operational information for each signal. This package includes a test data (named AISdata) for users to have a basic understanding of its structure.\
You may use the command-- `?AISdata` for more information.\

You can also use the real AIS data from the [website](https://marinecadastre.gov/ais/), unzip the file and utilize the following command to load the data:`AISdata <- read.csv("dataname.csv", header = T)`


## Functions:
### 1. Vessel Summary within a Region
The `summarizeship` function  allows user to specify the range of latitude and longitude of the study area, summarizing the number and dimensions of each ship type.\
**usage:** `summarizeship(AISdata, maxLON = -94, minLON = -96, maxLAT = 30, minLAT = 27)`

### 2. Vessel Signal Plotting
The `plotvessel` function  generates a visual representation of AIS signal locations. Note that the default ship type is Cargo, but users can input their preferred ship type as well. Other available options include Fishing, Military, Not_available,Others,Passengers,Pleasure,Tanker,and Tugboat within the function parameters.\
**usage:** `plotvessel(AISdata, studyship = 'Cargo', maxLON = -94, minLON = -96, maxLAT = 30, minLAT = 27)`

### 3. Speed Distribution
The `speeddist` function creates a histogram illustrating the speed profile of a specific ship within the designated study area. Users have the flexibility to input their preferred ship type, with the default set to Cargo.\
**usage:** `speeddist(AISdata, studyship = 'Fishing', maxLON = -94, minLON = -96, maxLAT = 30, minLAT = 27)`

### 4. Operating Time Analysis
The `operatingtime` function  analyzes the cumulative operational time of each distinct ship and ship type. Users have the flexibility to set the operational mode by specifying the speed threshold with the parameter `activityspeed`. The 
default speed is 3 knots.\
From the resulting output, the initial data frame showcases the operating time (in minutes) for each vessel, while the subsequent data frame aggregates the total time for each ship type.

*Please be aware that this function might entail a lengthy computational process as it meticulously calculates the time for each vessel. So be careful about the specified region*

**usage:**
`totaltime = operatingtime(AISdata, activityspeed = 3, maxLON = -94, minLON = -96, maxLAT = 30, minLAT = 27)`\
Operating time for each vessel:
`head(totaltime[[1]], 5)`\
Operating time for each ship type:
`head(totaltime[[2]])`
