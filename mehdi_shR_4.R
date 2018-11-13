library(shiny)
library(dplyr)
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



# Define UI for slider demo app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Sliders"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar to demonstrate various slider options ----
    sidebarPanel(
      
      # Input: Simple integer interval ----
      sliderInput("integer", "Integer:",
                  min = 0, max = 1000,
                  value = 500),
      
      # Input: Decimal interval with step value ----
      sliderInput("decimal", "Decimal:",
                  min = 0, max = 1,
                  value = 0.5, step = 0.1),
      
      # Input: Specification of range within an interval ----
      sliderInput("range", "Range:",
                  min = 1, max = 1000,
                  value = c(200,500)),
      
      # Input: Custom currency format for with basic animation ----
      sliderInput("format", "Custom Format:",
                  min = 0, max = 10000,
                  value = 0, step = 2500,
                  pre = "$", sep = ",",
                  animate = TRUE),
      
      # Input: Animation with custom interval (in ms) ----
      # to control speed, plus looping
      sliderInput("animation", "Looping Animation:",
                  min = 1, max = 2000,
                  value = 1, step = 10,
                  animate =
                    animationOptions(interval = 300, loop = TRUE))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Table summarizing the values entered ----
      tableOutput("values"),
      
      plotOutput(
        "plot_foo"
      )
      
    )
  )
)

# Define server logic for slider examples ----
server <- function(input, output) {
  
  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({
    
    data.frame(
      Name = c("Integer",
               "Decimal",
               "Range",
               "Custom Format",
               "Animation"),
      Value = as.character(c(input$integer,
                             input$decimal,
                             paste(input$range, collapse = " "),
                             input$format,
                             input$animation)),
      stringsAsFactors = FALSE)
    
  })
  
  # Show the values in an HTML table ----
  output$values <- renderTable({
    sliderValues()
  })
  
  # make the plot respond to changes in the dataset
  output$plot_foo = renderPlot({
    plot(plotaleData$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)