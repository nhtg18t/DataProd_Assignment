#######################################################################################################################
# Server.R file 
# This program obtains the values selected by the user, and does the following:
# 1. The very first display, will be a box plot of the mileage vs transmission type. 
# 2. Once the user provides the selection of the predictors, and hits the "Run Regression" button
# 3. The box plot is replaced by the matrix plot of milege and the selected parameters.
# 4. The plot will also have the correlation coefficients for the user to know if the parameters are strongly correlated
# 5. The next section of the code, runs the regression for the chosen parameter and reports the adjusted Rsquared value
# 6. In addition the regression summary of the coefficients is reported in a table form.
#######################################################################################################################

library(shiny)
# Section of Code, that requires one time execution.
# Setting the required libraries and data set.
library(ggplot2)
library(gridExtra)
data(mtcars)
library(GGally)

mtcars$am<- as.factor(mtcars$am)
levels(mtcars$am)<- c("Auto","Man")

shinyServer(
      function(input, output,session) {
            output$Index <- renderPrint({input$ColIndex})
           
#Display the graph : Plot Box plot as the initial plot, else plot matrix plot with correlation coefficient.
          output$GPlot <- renderPlot({
  
                  input$goButton
                  if(input$goButton == 0){boxplot(mpg ~ am, data = mtcars, col = c("blue", "red"),
                                                  xlab = "Transmission", ylab = "Miles per Gallon", 
                                                  main = "MPG by Transmission Type")}
                  else{
                        if( is.null(input$ColIndex)) {boxplot(mpg ~ am, data = mtcars, col = c("blue", "red"),
                                                              xlab = "Transmission", ylab = "Miles per Gallon", 
                                                              main = "MPG by Transmission Type")
                              return()
                              }
                        isolate(
                        ggpairs(mtcars,columns =c(1,as.integer(input$ColIndex)), colour="am",
                        lower=list(continuous="smooth"),params=c(method="loess"))
                        )}
                  })
# Now the regression
            Predictors <- reactive({(paste(names(mtcars[as.integer(input$ColIndex)]),collapse=" + "))})


             CreateRegression<- reactive({
                   lm(as.formula(paste("mtcars$mpg"," ~ mtcars$am + ",Predictors())),data=mtcars)
                   
                   })
# Now report summary of the coefficients of the regression, and pass back for display.
            output$RegressionTable <- renderTable({
                  input$goButton
                  if(input$goButton == 0) {print(data.frame(Warning="Please select Predictors for Regression Output"))}
                  else {
                        if( is.null(input$ColIndex)) return()
                        isolate(summary(CreateRegression())$coefficients)
                  }
            })

# Now report Adjusted R Squared of the fit, and pass back for display.
            output$RSq <- renderText({
            input$goButton
            if(input$goButton > 0){
                  if( is.null(input$ColIndex)) return()
                  isolate(round(summary(CreateRegression())$adj.r.squared*100,2))
                  
            }
            })

           
        
       }
)


