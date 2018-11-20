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
body <- dashboardBody(
   tabItems(dashboardTab, mapTab, weatherTab),
   tags$head(
     tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
   ))

ui <- dashboardPage(header, sidebar, body, skin = "blue")

#shinyApp(ui, server)