readjmNoInf <- readRDS(file="jmNoInf.Rda")

last_data <- 1000
plotaleData <- tail(readjmNoInf,last_data)

#g <- ggplot(plotaleData, aes(x=corrdate, y=HR))  + geom_line()


plot(plotaleData$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")
