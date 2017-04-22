library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Are You a Criminal?"),
  
  sidebarPanel(
    selectInput("model", "Model Based On:",
                list("Height" = "Height",
                     "Finger Length" = "FingerLength",
                     "Ratio Height/Finger Length" = "HFRatio")),
    
    selectInput("measureSystem", "Measurement Type:",
                list("Centimeters" = "cm",
                     "Inches" = "inches")),
    
    textInput("height", label="Height (inches or centimeters)"),
    
    textInput("finger", label="Middle Finger Length (inches or centimeters)"),
    
    h4("Results:"),
    h5("Frequency:"),
    h5(textOutput("frequencyResult")),
    h5("Probability of Criminality:"),
    h5(textOutput("probabilityResult"))
  ),
  
  mainPanel(
    
    h4("Use this application to determine your probability of criminality based on one of three models. Make your selections and enter your values on the left. The application will calculate your probability and show you the results under the Results to the left.") , 
    h4("The three models determine what measurement will be used for the prediction, your Height, your Left Middle Finger length or a ratio of the two."),
    
    h5("Use the Model Based On selector to the left to enter the predictive model you would like to use."),
    h5("Use the Measurement Type selector to the left to enter the measurement system (inches or centimeters) you will use for measurements."),
    h5("Use the text boxes to the left to enter your Height and length of your Left Middle Finger."),
    
    plotOutput("crimPlot"),
    
    h4(textOutput("result"))

  )
))