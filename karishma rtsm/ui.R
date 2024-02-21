## Shiny UI component for the Dashboard

my_data <- read.csv("FTSC_2020-2022.csv") %>%
  mutate(state = tolower(state)) # Ensure state names are lowercase for consistency


dashboardPage(
  
  dashboardHeader(title="Exploring the functional FTSCs in India with R & Shiny Dashboard", titleWidth = 650, 
                  tags$li(class="dropdown",tags$a(href="https://www.youtube.com/playlist?list=PL6wLL_RojB5xNOhe2OTSd-DPkMLVY9DfB", icon("youtube"), "My Channel", target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.linkedin.com/in/karishma-mathur-81828a285/" ,icon("linkedin"), "My Profile", target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://github.com/aagarw30/R-Shiny-Dashboards/tree/main/USArrestDashboard", icon("github"), "Source Code", target="_blank"))
  ),
  
  
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("Dataset", tabName = "data", icon = icon("database")),
                menuItem("Visualization", tabName = "viz", icon=icon("chart-line")),
                
                # Conditional Panel for conditional widget appearance
                # Filter should appear only for the visualization menu and selected tabs within it
                conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = c1)),
                menuItem("Choropleth Map", tabName = "map", icon=icon("map"))
                
    )
  ),
  
  
  dashboardBody(
    
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 12, 
                     tabPanel("About", icon=icon("address-card"),
                              fluidRow(
                                column(width = 8, tags$img(src="indian gov.jpg", width =600 , height = 300),
                                       tags$br() , 
                                       tags$a("Photo of Indian Government Logo on wikipedia"), align = "center"),
                                column(width = 4, tags$br() ,
                                       tags$p("This data set is collected from https://data.gov.in/ website and contains statistics on the number of functional FTSCs in each state, as of 31.12.2022.")
                                )
                              )
                              
                              
                     ), 
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted")),
                     tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"))
              )
              
      ),  
      
      # Second Tab Item
      tabItem(tabName = "viz", 
              tabBox(id="t2",  width=12, 
                     tabPanel(" Trends by State/UT", value="state",
                              fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                       tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                       
                              ),
                              withSpinner(plotlyOutput("bar"))
                     ),
                     tabPanel("Distribution", value="distro",
                              # selectInput("var", "Select the variable", choices=c("state", "cscs")),
                              withSpinner(plotlyOutput("histplot", height = "350px"))),
                                        tabPanel("Relationship among No. of Fast Track cases in 2021 and 2022", 
                                                            withSpinner(plotlyOutput("scatter")), value="relation"),
                     side = "left"
              ),
              
      ),
      
      
      # Third Tab Item
      tabItem(
        tabName = "map",
        box(      selectInput("crimetype","Select State/UT", choices = c2, selected="state", width = 250),
                  withSpinner(plotOutput("map_plot")), width = 12)
        
        
        
      )
      
    )
  )
)
