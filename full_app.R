## app.R ##
library(shiny)
library(shinydashboard)

messages <- dropdownMenu(type = "messages",
   messageItem(
     from = "Heads up!",
     message = "You have had a stressful moment",
     icon = icon("heart")
   ),
   messageItem(
     from = "Heads up!",
     message = "How did you sleep?",
     icon = icon("bed"),
     time = "13:45"
   ),
   messageItem(
     from = "Support",
     message = "The new servis is ready.",
     icon = icon("life-ring  {color:#E87722}"),
     time = "2014-12-01"
   )
)



notifications <- dropdownMenu(type = "notifications",
   notificationItem(
     text = "5 new users today",
     icon("users")
   ),
   notificationItem(
     text = "12 items delivered",
     icon("truck"),
     status = "success"
   ),
   notificationItem(
     text = "Server load at 86%",
     icon = icon("exclamation-triangle"),
     status = "warning"
   )
)

## Header content 
header <- dashboardHeader(messages, notifications, title = "Heads up!")

# tasks, is out

## Sidebar content
sidebar <-  dashboardSidebar(
    sidebarMenu(
      menuItem("Profile", tabName = "dashboard", icon = icon("heart")),
      menuItem("Measuring Deivces", tabName = "sdevices", icon = icon("heart")),
      menuItem("Smoothing Devices", tabName = "mdevices", icon = icon("chrome")),
      menuItem("Support", tabName = "support", icon = icon("support"))
    )
  )

# First tab content
dashboardTab <- tabItem(tabName = "dashboard",
      fluidRow(
            box(plotOutput("plot1", height = 250)),
                          
            box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
            )
      )
)  # end of tab


# bills tab content
mapTab <- tabItem(tabName = "map",
                  fluidRow(
                    box(
                      title = "Pay Bills",
                      HTML('
                           <form action="" method="POST">
                           <script
                           src="https://checkout.stripe.com/checkout.js" class="stripe-button"
                           data-key="pk_test_qdunoptxl9KNXR5qk7WdtkVg"
                           data-amount="4000"
                           data-name="Pay Bill"
                           data-description="Monthly Bill ($40.00)"
                           >
                           </script>
                           </form>
                           ')
                    ),
                    box(h2('Pay with Bitcoin'))
                  )
        
)

# learn tab content
weatherTab <- tabItem(tabName = "weather",
  h2("Forecasted Weather")
)

# support tab content
weatherTab <- tabItem(tabName = "weather",
                      h2("Forecasted Weather")
)

## Body content
body <-   dashboardBody(
  # Boxes need to be put in a row (or column)
  fluidRow(
    box(plotOutput("plot2", height = 250)),
    box(plotOutput("plot1", height = 250)),
    box(
      title = "Controls",
      sliderInput("slider", "Number of observations:", 1, 100, 50)
    ),
    box(
      title = "bins",
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1000,
                  max = 2000,
                  value = 1800)
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = "blue")



# Define server logic required to draw a histogram ----

source('Data_process.R')

readjmNoInf <- readRDS(file="jmNoInf.Rda")

server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  }
  )
  
  output$timeseries = renderPlot({
    
    plotaleData <- tail(readjmNoInf,input$bins)
    plot(plotaleData$HR,  type="l",xlab="timestep", ylab="Heart Rate/ BPM", main="")
  })
  
  output$selected_var <- renderText({ 
    plotaleData <- tail(readjmNoInf,input$bins)
    paste("You have selected", plotaleData[10,3])
    # paste("You have selected", input$bins)
  })
  
  output$image2 <- renderImage({
    
    return(list(
      src = "dHRdt.png",
      alt = "This is a chainring"
    ))
  }, deleteFile = FALSE)
  
  
  
  
  
}


shinyApp(ui, server)