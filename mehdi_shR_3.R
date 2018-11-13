library(dplyr)
library(shiny)
library(ggplot2)

library(tidyr)


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

last_data <- 2000

plotaleData <- tail(jmNoInf,last_data)

# ui
ui_foo = fluidPage(
  plotOutput(
    "plot_foo"
  ),
  plotOutput(
    "plot_foo2"
  ),
  numericInput(inputId = "income", label = "Income: ", value = NULL),
  actionButton("button_click", "Go!")
)

# server
server_foo = shinyServer(function(input, output) {
  react_vals = reactiveValues(
    # simulate some data --> initialize the reactive dataset
    df_foo = data_frame(
      percentile = seq.int(99),
      BTI = sort(rnorm(99))
    )
  )
  
  # change the data when the button changes
  observeEvent(input$button_click, {
    last_data <- input$income
    plotaleData <- tail(jmNoInf,last_data)
    
    ecdf_income = ecdf(react_vals$df_foo$BTI)
    react_vals$df_foo = rbind(react_vals$df_foo, 
                              c(percentile = ecdf_income(input$income)*100, 
                                BTI = input$income))
  })
  
  # make the plot respond to changes in the dataset
  output$plot_foo = renderPlot({
    plot(plotaleData$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")
  })

})

# run the app
shinyApp(ui = ui_foo, server = server_foo)