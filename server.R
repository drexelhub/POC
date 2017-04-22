library(shiny)
library(dplyr)
library(datasets)

crimData <- tbl_df(crimtab)
names(crimData) <- c("FingerLength", "Height", "Freq")
crimData <- mutate(crimData, FingerLength=as.numeric(FingerLength), 
                   Height=as.numeric(Height),
                   HFRatio = Height / FingerLength)

determineCaption <- function(model){
    caption <- "Frequency vs. Height:Finger Length Ratio"
    if(model == "Height")
        caption <- "Frequency vs. Height"
    else if(model == "FingerLength")
        caption <- "Frequency vs. Finger Length"
    caption
}
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
    mainCaption <- reactive({
        determineCaption(input$model)
    })
  modelHeight <- lm(as.formula("Freq ~ Height"), data=crimData)
  modelFinger <- lm(as.formula("Freq ~ FingerLength"), data=crimData)
  modelRatio <- lm(as.formula("Freq ~ HFRatio"), data=crimData)

  
  reactiveModel <- reactive({

        measure <- input$measureSystem
        height <- as.numeric(input$height)
        finger <- as.numeric(input$finger)
        
        if(measure == "inches"){
          height = height * 2.54
          finger = finger * 2.54
        }

        ratio <- height / finger
        newData <- tbl_df(data.frame(Height = height, FingerLength=finger, HFRatio=ratio))
        newData <- mutate(newData, FingerLength = as.numeric(FingerLength),
                          Height = as.numeric(Height),
                          HFRatio=as.numeric(HFRatio))
        

        
        crim_pred <- predict.lm(modelRatio, newdata =  newData)
        if(input$model == "Height"){
            crim_pred <- predict.lm(modelHeight, newdata =  newData)
        }
        else if(input$model == "FingerLength"){
            crim_pred <- predict.lm(modelFinger, newdata =  newData)
        }
        crim_percentile <- pnorm(crim_pred, mean=mean(crimData$Freq), 
                                 sd=sd(crimData$Freq))
        
        data.frame(freq = round(crim_pred,2),
                   prob = round(crim_percentile*100), 2)
  })
  
  output$frequencyResult <- renderText({
    reactiveModel()$freq
  })
  
  output$probabilityResult <- renderText({
      paste(as.character(reactiveModel()$prob),"%")
  })
  
  output$result <- renderText({
      prob <- as.character(reactiveModel()$prob)
      paste("You have a ", prob, "% Probability of Criminality")
  })
  
  output$crimPlot <- renderPlot({
      if(input$model == "Height"){
          plot(crimData$Height, crimData$Freq, xlab="Height (cm)", ylab="Frequency", main=mainCaption())
          abline(modelHeight, col="blue", lw=2)
          points(input$height, reactiveModel()$freq, col="red", pch=4)
      }
      else if(input$model == "FingerLength"){
          plot(crimData$FingerLength, crimData$Freq, xlab="Left Middle Finger Length (cm)", ylab="Frequency", main=mainCaption())
          abline(modelFinger, col="blue", lw=2)
          points(input$finger, reactiveModel()$freq, col="red", pch=4)
      }
      else{
          plot(crimData$HFRatio, crimData$Freq, xlab="Left Middle Finger Length/Height", ylab="Frequency", main=mainCaption())
          abline(modelRatio, col="blue", lw=2)
          points(as.numeric(input$height)/as.numeric(input$finger), reactiveModel()$freq, col="red", pch=4)
      }
  })
})