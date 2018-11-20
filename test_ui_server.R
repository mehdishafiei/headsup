## app.R ##
library(shinydashboard)

source('Data_process.R')

readjmNoInf <- readRDS(file="jmNoInf.Rda")


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

#header <- dashboardHeader(messages, notifications, title = "Heads up!")

body <-dashboardBody(
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


ui <- dashboardPage(
  dashboardHeader(messages, notifications, title = "Heads up!"),
  dashboardSidebar(
  sidebarMenu(
    menuItem("Profile", tabName = "dashboard", icon = icon("heart")),
    menuItem("Measuring Deivces", tabName = "sdevices", icon = icon("heart")),
    menuItem("Smoothing Devices", tabName = "mdevices", icon = icon("chrome")),
    menuItem("Support", tabName = "support", icon = icon("support"))
  )),
  body
)






shinyApp(ui, server)