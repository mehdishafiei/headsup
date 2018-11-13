library(dplyr)
library(tidyr)
library(ggplot2)  # load plot


main <- read.csv("id-1003_heartrate_4.csv")
names(main) <- c("date1","date2", "date3", "HR")
main <- unite(main, corrdate, date1, date2, date3, sep=" ", remove=TRUE)
main <- mutate(main, frdate= as.numeric(as.POSIXct(corrdate, format="%Y-%m-%d %H:%M:%S %p")))

steps <- read.csv("id-1003_minutestepsnarrow_20171001_2017100.csv")

names(steps) <- c("date2", "step")

steps <- mutate(steps, frdate= as.numeric(as.POSIXct(date2,format="%m/%d/%Y %H:%M")))

jm <- left_join(main, steps)

jm <- jm %>% select(corrdate,HR,step)  

differ <- diff(jm$HR, lag = 2, differences = 1)

differ <- append(differ, c("0","0"))

jm$difference <-differ 

jm <- mutate(jm, "HRSTEP"=HR/step)

jmNoInf <- jm[!is.infinite(jm$HRSTEP),]

# alright, that is enough for this file. 
# I want to lower the load on the remote R server to do a job everytime
# that the user changes the value. So, selecting data for plotting would be done in
# a different file
# The last job would be saving the data:

saveRDS(jmNoInf, file="jmNoInf.Rda")

#last_data <- 2000
#plotaleData <- tail(jmNoInf,last_data)

#g <- ggplot(plotaleData, aes(x=corrdate, y=HR))  + geom_line()


#plot(plotaleData$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")


#plot(g)




