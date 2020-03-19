#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readxl)
mots <- read_excel("data/mots.xlsx")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    r <- reactiveValues(afficherReponse = FALSE)
    choixMode <- reactive({
        r$afficherReponse <- FALSE
        switch(input$question,
               "Français -> Pinyin" = c(4),
               "Pinyin -> Français" = c(3),
               "Chinois -> Français" = c(2))
    })
    randomVals <- eventReactive(input$nouveauMot, {
        r$afficherReponse <- FALSE
        sample.int(nrow(mots), size = 1)
    }, ignoreNULL = FALSE)
    
    output$reponse <- renderText({
        reponse <- paste0("<br>Le mot à trouver était :<br>",
                          "<font size=\"",input$size,"px\">",
                          paste(mots[randomVals(),-1],collapse = " = "),
                          "</font>")
        if(r$afficherReponse){
            reponse
        }else{
            ""
        }
    }) 
    randomVals <- eventReactive(input$nouveauMot, {
        r$afficherReponse <- FALSE
        sample.int(nrow(mots), size = 1)
    }, ignoreNULL = FALSE)
    observeEvent(input$reponse, {
        r$afficherReponse <- TRUE
    })
    output$motADeviner <- renderText({ 
        #paste0("test", mot_hasard)
        paste0("Le mot à deviner est :<br>",
               "<font size=\"",input$size,"px\">",
              as.character(mots[randomVals(), choixMode()]),
              "</font><br><br><br><br>")
    })

})