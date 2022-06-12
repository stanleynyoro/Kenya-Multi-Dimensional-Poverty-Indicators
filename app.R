library(shiny)
library(tidyverse)
library(readxl)
pdata <- read.csv("https://raw.githubusercontent.com/stanleynyoro/Kenya-Multi-Dimensional-Poverty-Indicators/main/data.csv")

ui <- fluidPage(
    theme=shinythemes::shinytheme("cyborg"),
    titlePanel("Multidimensional Poverty Index by Region in Kenya"),
    sidebarLayout(
        sidebarPanel(
    selectInput("region","Select Region",unique(pdata$region))),
    mainPanel(
        tabsetPanel(
            tabPanel("Multidimensional Poverty Index",tableOutput("table"),
                     textOutput("text")),
            tabPanel("Contribution of dimension to poverty (%)",plotOutput("secondplot"))))
)
)
server <- function(input, output){
    
    output$secondplot<-renderPlot({
       mydata<- pdata %>%
           filter(region==input$region)
       ggplot(mydata,aes(x=dimension, y=Value)) +
            geom_col()
        
    })
    
    output$table<- renderTable({
        table1<- pdata %>%
        filter(region==input$region) %>%
            select(MPI) %>%
            head(1)
    })
    output$text<-renderText({
        paste("Multidimensional poverty index reflect population that is multidimensionally poor/ suffering from acute poverty. The data used was published and updated by 
              Oxford Poverty and Human Development Initiative in 2021. Global MPI is measured in
              over 100 countries. It tracks indicators in 10 dimensions, including health (child mortality, nutrition),
              education(years of schooling, enrollment) and living standards (water, sanitation, electricity, cooking fuel, floor, assets.
              Chart on the second tab indicates contribution of each dimension to poverty index.
              Thus dimension with highest contribution (%) indicate programmatic areas
              that could be prioritized to address poverty)")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
