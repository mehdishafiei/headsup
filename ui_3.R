## app.R ##
library(shinydashboard)

messages <- dropdownMenu(type = "messages",
   messageItem(
     from = "Sales Dept",
     message = "Sales are steady this month."
   ),
   messageItem(
     from = "New User",
     message = "How do I register?",
     icon = icon("question"),
     time = "13:45"
   ),
   messageItem(
     from = "Support",
     message = "The new server is ready.",
     icon = icon("life-ring"),
     time = "2014-12-01"
   )
)

tasks <- dropdownMenu(type = "tasks", badgeStatus = "success",
   taskItem(value = 90, color = "green",
            "Documentation"
   ),
   taskItem(value = 17, color = "aqua",
            "Project X"
   ),
   taskItem(value = 75, color = "yellow",
            "Server deployment"
   ),
   taskItem(value = 80, color = "red",
            "Overall project"
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
header <- dashboardHeader(messages, tasks, notifications, title = "PoweredBit")

## Sidebar content
sidebar <-  dashboardSidebar(
    sidebarMenu(
      menuItem("Profile", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Pay Bills", tabName = "map", icon = icon("credit-card")),
      menuItem("Arrange and Learn", tabName = "weather", icon = icon("leanpub")),
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
     ),
     selectInput("var", 
                 label = "Choose a variable to display",
                 choices = c("Percent White", 
                             "Percent Black",
                             "Percent Hispanic", 
                             "Percent Asian"),
                 selected = "Percent White"),
     textOutput("selected_var")
   )
)


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
body <- dashboardBody(tabItems(dashboardTab, mapTab, weatherTab))

ui <- dashboardPage(header, sidebar, body, skin = "green")

shinyApp(ui, server)