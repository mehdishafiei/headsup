library(dplyr)
library(tidyr)

main <- read.csv("id-1003_heartrate_4.csv")

names(main) <- c("date1","date2", "date3", "HR")

#main$date3 <- with(main, paste(date1, date2,sep="-"))
#main <- mutate(main, frdate= as.POSIXct(date,format="%Y/%m/%D %H:%M"))

main <- unite(main, corrdate, date1, date2, date3, sep=" ", remove=TRUE)

#main <- mutate(main, frdate= as.numeric(as.POSIXct(corrdate, format="%Y-%M-%d %H:%M:%S %p")))
main <- mutate(main, frdate= as.numeric(as.POSIXct(corrdate, format="%Y-%m-%d %H:%M:%S %p")))


#print(names(main))

steps <- read.csv("id-1003_minutestepsnarrow_20171001_2017100.csv")

names(steps) <- c("date2", "step")

steps <- mutate(steps, frdate= as.numeric(as.POSIXct(date2,format="%m/%d/%Y %H:%M")))

#steps <- mutate(steps, frdate= as.POSIXct(date2,format="%m/%d/%Y %H:%M"))


print(head(main, 1))
print(head(steps,1))

jm <- left_join(main, steps)

jm <- jm %>% select(corrdate,HR,step)  

differ <- diff(jm$HR, lag = 2, differences = 1)

differ <- append(differ, c("0","0"))

jm$difference <-differ 

jm <- mutate(jm, "HRSTEP"=HR/step)



jmNoInf <- jm[!is.infinite(jm$HRSTEP),]

ppi <- 300
png("HR.png", width=6*ppi, height=6*ppi, res=ppi)
plot(jm$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")
dev.off ();

png("dHRdt.png", width=6*ppi, height=6*ppi, res=ppi)
plot(jm$difference,  type="l",xlab="timestep", ylab="d(HR)/dt ", main="")
dev.off ();



png("steps.png", width=6*ppi, height=6*ppi, res=ppi)
plot(jm$step,  type="l",xlab="timestep", ylab="steps", main="")
dev.off ();


png("HR_vs_dHR.png", width=6*ppi, height=6*ppi, res=ppi)
plot(jm$HR,abs(as.numeric(jm$difference)),  type="p",xlab="HR", ylab="d(HR)/dt (abs. value)", main="")
dev.off ();

png("HRperStep_vs_dHR.png", width=6*ppi, height=6*ppi, res=ppi)
plot(jm$HRSTEP,abs(as.numeric(jm$difference)),  type="p",xlab="HR/step", ylab="d(HR)/dt (abs. value)", main="")
dev.off ();


#install.packages("forecast")

#library(forecast)

#forecastPeriodLen <- 12
#model <- hw(jmNoInf$HR, initial ='optimal', h=(forecastPeriodLen), beta=NULL, gamma=NULL)


#arimaFit <- Arima(jmNoInf$HR,order=c(3,1,0))
arimaFit <- Arima(tail(jmNoInf$HR,200),order=c(30,1,0))



#preditedHR <- forecast(arimaFit,h=2000)

preditedHR <- forecast(arimaFit,h=40, fan = TRUE)

print(accuracy(preditedHR))

predictVec <- as.numeric(preditedHR$fitted)

library(ggplot2)

#plot(preditedHR)
#autoplot(preditedHR)

png("prediction.png", width=6*ppi, height=6*ppi, res=ppi)
plot(preditedHR, xlab = "timestep", ylab = "Heart Rate")
autoplot(preditedHR)
dev.off ();






