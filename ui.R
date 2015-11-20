#######################################################################################################################
# ui.R File
#1. This file has the UI interface, and it is organized in the following way
#     The side panel has the options to select, and once selected and the user hits the "Run Regression" button
#     populates the output, namely, the Adjusted Rsq value and the Coefficients table
#
#     The main panel, has the graphs displayed.  Prior to hitting the "Run Regression" button, a box plot of the
#     mileage segregated by transmission type is plotted
#     Once the predictors are selected and run, the main panel displays a matrix plot with correlation coefficients
#######################################################################################################################
library(shiny)
shinyUI(pageWithSidebar(
      headerPanel("Motor Trend Report - Automatic vs Manual Transmission"),
      sidebarPanel(
            h3('Select Predictors for Mileage'),
             checkboxGroupInput("ColIndex", "Predictors",
                               c("# of Cylinders" =2,
                                 "Horse Power(HP)" = 4,
                                 "Gross Weight, (000 lbs)"= 6
                                 )),
            
            actionButton("goButton", "Run Regression"),
            br(),
            br(),
            h3('############'),
            
            h3('OUTPUT FROM REGRESSION'),
            
            h3('THE Adj.RSq. VALUE:'),
            strong(verbatimTextOutput("RSq")),
            
            h3('************'),
  
            h3('REGRESSION COEFFICIENTS TABLE'),
            
            strong(tableOutput('RegressionTable')),
            
            h3('#############')
      
            
      ),
      mainPanel(
            h2('Graphical User Interface for Regression Model Selection'),
            p (' This is a web page developed to demonstrate, how we can interactively select a suitable
 regression model, by selecting predictors and plotting the relationships, correlation coefficients and the
quality of regression fit - The mtcars dataset is used to demonstrate the application '),
            
            p ('The objective is to develop a regression model of mileage as a function of transmission type, vehicle gross weight
horsepower, and number of cylinders.  The transmission type is pre-selected, and the inital display will show a bar plot of the
dependence of mileage on transmission type.  The user can then toggle between the other three variables, by selecting them from the side
bar panel, and for the selection, the web page will display the matrix plot with the correlation coefficient graphically'),
            
            p (' In addition, for the chosen variable, a linear regression model will be run, and the summary of the coefficients
and the quality of fit, as provided by the adjusted R Squared value, will be displayed.'),

          
            h3('PLEASE SELECT ONE OR MORE PREDICTORS BY CHECKING THE BOX, ON THE SIDE PANEL'),
            
            
            h2('Box Plot or Plot of Predictors by Transmission Type'),
            
           plotOutput('GPlot')
           
#            h3('The table of regression coeffcients is as given below:'),
#            
#             tableOutput('RegressionTable')
            
      )
))


