
library(ggplot2)
library(shiny)

shinyUI(fluidPage(
    fluidRow(align = "center",
             h1("How much petrol does your car consume?"),
             em(h4("By Dorian, for Coursera 'Developing Data Products' course"))
    ),
    fluidRow(align = "center",
             img(src="mpg.jpg", height = 200, width = 280 )
    ),
    fluidRow(p("So time has come for you to buy a car, and you are worried about the fuel consumption of your new ride? Well, I am here to help! Prediction algorithm was created to estimate possible fuel consumption based on just few characteristics. Try to fill up as much information as you can. The app will return an approximate fuel consumption based on you input and display the result on a chart. If you have no idea what is inside of your car, you can pick at random or leave the default."),
             p("Prediction was made based on the 'mtcars' classic dataset."),
             p("The picture was originally found at ",
               a("this page", 
                 href = "http://www.ifmelranthezoo.com/tag/miles-per-gallon/"))
    ),
    fluidRow(
        column(3, 
               selectInput("cyl", label = h4("No. cylinders"), 
                           choices = list("four" = 4, "six" = 6,
                                          "eight" = 8), selected = 1)
        ),
        column(3, 
               sliderInput("hp", label = h4("Gross horsepower"),
                           min = 70, max = 350, value = 120, step = 5)
        ),
        column(3, 
               sliderInput("weight", label = h4("Weight in k Ib"),
                           min = 1.5, max = 5.5, value = 2.5, step = 0.1)
        )
        
    ),
    fluidRow(
        column(3, 
               sliderInput("qsec", label = h4("1/4 mile time (in sec)"),
                           min = 14, max = 24, value = 18.5, step = 0.1)
        ),
        column(3, 
               radioButtons("vs", label = h4("V vs Straight engine"),
                            choices = list("V shape" = 0, "Straight" = 1
                            ), selected = 1)
        ),
        column(3, 
               radioButtons("am", label = h4("Gearbox type"),
                            choices = list("automatic" = 0, "manual" = 1
                            ), selected = 1)
        )
    ),
    fluidRow(
        column(3, 
               selectInput("gears", label = h4("No. of forward gears"),
                           choices = list("3" = 3, "4" = 4,
                                          "5" = 5), selected = 5)
        ),
        column(3, 
               textInput("car", label = h4("Car model"), 
                         value = "Reliable Robin")
        ),
        
        column(3, 
               selectInput("carb", label = h4("No. of carborators"),
                           choices = list("1" = 1, "2" = 2, "3" = 3, "4" = 4,
                                          "6" = 6, "8" = 8), selected = 4)
        )
        
    ),
    fluidRow(
        column(3, 
               submitButton("Submit")
        )  
    ),
    fluidRow(
        br(),
        textOutput("text1"),
        br(),
        #tableOutput("table1"),
        textOutput("text2"),
        textOutput("text3"),
        plotOutput("mpgPlot")
    )
    
))
