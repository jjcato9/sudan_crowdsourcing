#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

## load in packages and data here
library(ggplot2)
library(maps)
library(tidyverse)
library(plotly)


#data <- read.csv('')


# Define UI ----
ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("service", h3("Select Services"), 
                         choices = list("All" = "All",
                                        "Cardiothoracics",
                                        "Oral & Maxillofacial Surgery",
                                        "ENT",
                                        "Trauma & Orthopaedics",
                                        "General Surgery",
                                        "Plastic Surgery",
                                        "Paediatric Surgery",
                                        "Urology",
                                        "Vascular",
                                        "Breast",
                                        "ITU"
                         ),
                         selected = 'All'),
      checkboxGroupInput("region", h3("Select Regions"), 
                         choices = list("All" = "All",
                                        "East Midlands",
                                        "East of England",
                                        "Kent, Surrey and Sussex",
                                        "London",
                                        "North East",
                                        "North West",
                                        "South West",
                                        "Thames Valley",
                                        "Wessex",
                                        "West Midlands",
                                        "Yorkshire and the Humber",
                                        "Wales",
                                        "Scotland"),
                         selected = 'All'),
      submitButton("Submit")),
    mainPanel(
      HTML('<h5><em>A Shiny App created by Jess Caterson</em></h5>'),
      br(),
      p('This is a Shiny App designed to navigate the CST jobs listed for commencement in August to October 2023.'),
      br(),
      p('Select your preferred jobs and regions and click submit to see the jobs available fulfilling this criteria.'),
      br(),
      p('This app has been built using CST preferencing data released on 10th March 2023 (Updated from initial release c6th March).'),
      br(),
      HTML('<p>For more detail on how this app was built, you can visit my<a href = \'https://github.com/jjcato9/CST_Preferencing\'> GitHub</a> site.</p>'),
      h3('Explore The Map'),
      HTML('<p><em>Zoom in to see closer detail and hover over the circles to get job breakdown by region</em></p>'),
      textOutput('selection'),
      plotlyOutput('map'),
      h3('Jobs Matching Preferences'),
      HTML('<p><em>See a list of jobs matching your search criteria</em></p>'),
      tableOutput('table'),
      br(),
      p('Copyright Jess Caterson')
      
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  #get df with filters applied
  df <- reactive(
    {req(input$theme)
      req(input$region)
      new <- job_filter(data,input$theme)
      new <- region_filter(new,input$region)})
  
  
  
  #State number of jobs which meet criteria
  output$selection <- renderText({
    paste('There are ',nrow(df()),' jobs which meet your criteria')
  })
  
  #Map locating jobs
  output$map <- renderPlotly({
    map_builder(df())
  }
  )
  
  #DF of jobs
  output$table <- renderTable(df() %>% select(1:4))
}

# Run the app ----
shinyApp(ui = ui, server = server)