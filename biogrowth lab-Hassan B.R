install.packages("biogrowth")
library("biogrowth")

# Define UI
ui <- fluidPage(
  titlePanel("Microbial Growth Modeling - Modified Gompertz Model"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("logN0", 
                  "LogN0 (Initial population size, log scale):",
                  min = -2, max = 2, value = 0, step = 0.1),
      sliderInput("C", 
                  "C (Maximum population increase):",
                  min = 1, max = 10, value = 6, step = 0.1),
      sliderInput("mu", 
                  "Mu (Maximum growth rate):",
                  min = 0.1, max = 1, value = 0.2, step = 0.01),
      sliderInput("lambda", 
                  "Lambda (Lag time before growth):",
                  min = 0, max = 50, value = 20, step = 1)
    ),
    
    mainPanel(
      plotOutput("growthPlot")
    )
  )
)

# Define server
server <- function(input, output) {
  output$growthPlot <- renderPlot({
    # Define the model with user inputs
    my_model <- list(model = "modGompertz", 
                     logN0 = input$logN0, 
                     C = input$C, 
                     mu = input$mu, 
                     lambda = input$lambda)
    
    # Time points for prediction
    my_time <- seq(0, 100, length = 1000)
    
    # Generate predictions
    my_prediction <- predict_growth(my_time, my_model, environment = "constant")
    
    # Plot the growth curve
    plot(my_prediction, 
         main = "Microbial Growth Curve",
         xlab = "Time", 
         ylab = "Population (log scale)",
         col = "blue", lwd = 2)
  })
}

# Run the application
shinyApp(ui = ui, server = server)


