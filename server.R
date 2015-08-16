library(shiny)
library(caret)
library(ggplot2)
library(randomForest)

shinyServer(function(input, output) {   
    answer1 <- reactive({
        listofinput <- c(input$car, input$cyl, input$hp, input$weight, input$qsec, input$vs, input$am, input$gears)
        vs <- "V shape"
        am <- "automatic"
        if(input$vs==0){vs <- "V shape"
        }else{vs <- "straight"}
        if(input$am==0){am <- "automatic"
        }else{am <- "manual"}
        if(any(listofinput == 'NA')){
            summarytext1 <- paste("Your car is red.")
        }else{
            summarytext1 <- paste("Car chosen by you is", input$car, "that weights", 1000*input$weight, "Ib.",
                                  "Its engine is a", input$cyl, "cylinder,", input$carb, "carburetor", vs, "unit, with", input$hp, "horsepower. With its",
                                  input$gears,"forward gear",am, "gearbox it can make quarter mile in", input$qsec, "seconds.") 
        }        
    })
    output$text1 <- renderText({  
        paste(answer1())
    })
    #create df of input values and remove NA if any
    my_df1 <- reactive({
        df <- data.frame(cyl = input$cyl, hp = input$hp, wt = input$weight, qsec = input$qsec, vs = input$vs, am = input$am, gear = input$gears, carb = input$carb)
        #remove varaibles with no observation
        df <- df[,sapply(df, function(x) x != "NA")]
        df
    })
    #load model
    model <- readRDS("mpgmodel.rds")
    #calculate model RMSE (error)
    modelRMSE <- round(min(model$results[2]),2)
    
    #predict based on my model
    myprediction <- reactive({
        round(predict(model, my_df1()),2)
    })
    #factor for calculating liter per 100km
    conversionfactor <- 235.214583
    
    output$text2 <- renderText({  
        paste("Your car should ride", myprediction(), "miles on one gallon. It corresponds to", round(conversionfactor/myprediction(),1), "liters per 100 km.")
    })
    output$text3 <- renderText({  
        paste("RMSE of the prediction equals", modelRMSE,"mile per gallon.")
    })
    
    output$table1 <- renderTable({
        my_df1()
    })
    
    #move results to data frame so it can be ploted by ggplot
    resultdf <- reactive({
        df <- data.frame(car = input$car, mpg = myprediction(), RMSE = modelRMSE)      
    })
    #create a plot
    output$mpgPlot <- renderPlot(function() {
        df <- resultdf()
        myplot <- ggplot(df, aes(mpg, car)) + geom_point(aes(size = 6)) + geom_errorbarh(aes(xmin = mpg - RMSE, xmax = mpg + RMSE, height = .2, size = 4)) +
            labs(title = "Miles per gallon", x = "mpg", y = "car") + xlim(10, 32) + theme(legend.position="none")
        plot(myplot)
    })
    
})
