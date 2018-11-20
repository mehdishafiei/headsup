library(shiny)
library(shinydashboard)
library(leaflet)

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

header <- dashboardHeader(messages,
                          notifications,
                          title = "Heads up!",
                          uiOutput("userpanel"))

#body <-dashboardBody(
profiledTab <- tabItem(tabName = "profileTab",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  fluidRow(
  #  box(
    column(width = 7,
      # A static infoBox
      infoBox("New Orders", 5 * 2, width=7, icon = icon("credit-card")),
      # Dynamic infoBoxes
      # infoBoxOutput("progressBox"),
      valueBoxOutput(width=7,"progressBox"),
      
      valueBoxOutput(width=7,"approvalBox")
    ),
    column(width = 4, height=10,
      tags$img(height=400, width=200, src="thermomether.png")
    )
    #) # end of  box
  ),
  fluidRow(
    h2("The mtcars data"),
    DT::dataTableOutput("mytable")
  ),
  fluidRow(
    box(title = "bins", width = 4,
        sliderInput(inputId = "bins",
                    label = "Number of bins:",
                    min = 1000,
                    max = 2000,
                    value = 1800)
    ),  # end of box
    box(plotOutput("plot1", height = 250)),
    box(
      title = "Title 6",width = 7, background = "maroon",
      "A box with a solid maroon background"
    )
  ), # end of fluidrow
  fluidRow( # IFirst the basic info and the thermo meter

            box(   
               tabBox(
                 # Title can include an icon
                 title = tagList(shiny::icon("gear"), "tabBox status"),
                 tabPanel("Tab1",
                         "Currently selected tab from first box:",
                         verbatimTextOutput("tabset1Selected")
                 ),
                 tabPanel("Tab2", "Tab content 2")
              ) # tabBox
           ), #end of box
           
           box(
              # A static infoBox
              infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
              # Dynamic infoBoxes
              # infoBoxOutput("progressBox"),
              infoBox("New Orders", 10 * 2, icon = icon("credit-card"))
           ) # end of  box
  ), # endo of fluidrow

  # Boxes need to be put in a row (or column)
  fluidRow(
      box(plotOutput("plot2", height = 250)),  
      box(
          title = "Inputs", width=7,  status = "warning", solidHeader = TRUE,
          "Box content here", br(), "More box content",
          sliderInput("slider", "Number of observations:", 1, 100, 50)
      )  # end of box
  ) # end of fluidrow
  
)  # profiledTab body

sdevicesTab <- tabItem(tabName = "sdevices",
      fluidRow(
        box(
          title = "Title 6",width = 7, background = "maroon",
          "A box with a solid maroon background"
        )
      ),
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
          )
      ),
      fluidRow( 
        leafletOutput("mymap"),
        p(),
        actionButton("recalc", "New points")
      )
)

body <- dashboardBody(tabItems(profiledTab,sdevicesTab))

sidebar <-   dashboardSidebar(
  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                    label = "Search..."),
  sidebarMenu(
    menuItem("Profile", tabName = "profileTab", icon = icon("heart")),
    menuItem("Measuring Deivces", tabName = "sdevices", icon = icon("heartbeat")),
    menuItem("Smoothing Devices", tabName = "mdevices", icon = icon("chrome")),
    menuItem("Support", tabName = "support", icon = icon("support"))
  )
)  # end of sidebar

ui <- dashboardPage(
  #dashboardHeader(messages, notifications, title = "Heads up!"),
  header,
  sidebar,
  body
)  # end od ui