##AIRCASTING PREPROCESSING
##script to tide up aircasting csv files


##directory of files
multiloader <- function(path) { 
  files <- dir(path, pattern = '\\.csv', full.names = TRUE)
  tables <- lapply(files, read.csv, header=F)
  do.call(rbind, tables)
}
mydata <- multiloader("~/Desktop/sessions")

## only one file
##mydata <- read.csv("session_4.csv",header = F)

#rename cols
colnames(mydata) <- c("timestamp","lat","lon","value")

##empty df
tidy <- data.frame(timestamp=character(),lat=double(),lon=double(),value=double(),
                   sens_mod=character(),sens_pck=character(),sens_var=character(),sens_uni=character()
                   )

##split the table according rows indicating a new variable
while (nrow(mydata) >0) {
      mydata2 <- mydata[max(grep("sensor.model",mydata$timestamp)):nrow(mydata),]
      mydata2 <- cbind(mydata2,sens_mode=mydata2[2,1],sens_pck=mydata2[2,2],sens_var=mydata2[2,3],sens_inu=mydata2[2,4])
      mydata2 <- mydata2[4:nrow(mydata2),]
      
      tidy <- rbind(tidy,mydata2)
      
      mydata <- mydata[1:max(grep("sensor.model",mydata$timestamp))-1,]

}

write.csv(tidy,file="~/Desktop/aircasting.csv")


