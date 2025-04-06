library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
load("../Rdata_saved/marz_data.RData")



ui <- fluidPage(
  titlePanel("Population by Age Group in regions of Armenia"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("marz", "Choose a Marz:", 
                  choices = c("Yerevan", "Aragatsotn", "Ararat", "Armavir", 
                              "Gegharkinik", "Lori", "Kotayk", "Shirak", 
                              "Syunik", "VayotsDzor", "Tavush", "Total_Armenia"),
                  selected = "Yerevan"),
      width = 3  # Set the sidebar width to 3 (narrower)
    ),
    
    # Place plot under the sidebar
    mainPanel(
      fluidRow(
        column(12, plotOutput("population_plot"))
      ),
      width = 9  # Set the main panel width to 9 (wider than sidebar)
    )
  )
)

# Server logic for the Shiny app
server <- function(input, output) {
  
  # Reactive expression to load the selected Marz data
  selected_data <- reactive({
    load_marz_data(input$marz)  # Load the data for the selected Marz
  })
  
  # Render the population plot
  output$population_plot <- renderPlot({
    marz_data <- selected_data()
    
    ggplot(marz_data, aes(x = Year, y = Population/1000, fill = AgeGroup)) +
      geom_bar(stat = "identity", position = "stack") +
      labs(
        title = input$marz, 
        x = element_blank(), 
        y = "Population(in thousands)", 
        fill = ""
      ) +
      theme_minimal() +
      scale_fill_brewer(palette = "Dark2") +  
      theme(
        axis.text.x = element_text(face = 'bold', size = 15),
        axis.text.y = element_text(face = 'bold', size = 15),
        plot.title = element_text(face = "bold", size = 40, hjust = 0.4),
        axis.title = element_text(face = "bold", size = 20),
        legend.position = 'bottom',
        legend.text = element_text(size = 18))
    })
}

shinyApp(ui = ui, server = server)




