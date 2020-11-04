library(shiny)
library(datasets)

mpg <- mtcars
mpg$am <- factor(mpg$am, labels = c("Automatic", "Manual"))

shinyServer(function(input, output) {
  
  fText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  ftPoint <- reactive({
    paste("mpg ~", "as.integer(", input$variable, ")")
  })
  
  fit <- reactive({
    lm(as.formula(ftPoint()), data=mpg)
  })
  
  output$caption <- renderText({
    fText()
  })
  
  output$mpgBoxPlot <- renderPlot({
    boxplot(as.formula(fText()), 
            data = mpg,
            outline = input$outliers)
  })
  
  output$fit <- renderPrint({
    summary(fit())
  })
  
  output$mpgPlot <- renderPlot({
    with(mpg, {
      plot(as.formula(ftPoint()))
      abline(fit(), col=2)
    })
  })
  
})