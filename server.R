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
        if(input$question == "Son -> Français"){
            url <- sprintf("https://translate.google.com.vn/translate_tts?ie=UTF-8&q=%s&tl=zh-CN&client=tw-ob",
                           gsub("(\\()|(\\))", "", mots[randomVals(), 2])
                           )
            #print(getwd())
            # Define the temporary directory and download the data
            dest_path <- "www/temp.mp3"
            download.file(url ,destfile = dest_path)
        }
        switch(input$question,
               "Français -> Pinyin" = c(4),
               "Pinyin -> Français" = c(3),
               "Chinois -> Français" = c(2),
               "Son -> Français" = c(-1))
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
    
    
    observeEvent(input$playsound, {
        insertUI(selector = "#playsound",
                 where = "afterEnd",
                 ui = tags$audio(src  = "temp.mp3", type = "audio/mp3", autoplay = NA, controls = NA, style="display:none;")
        )
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
        if(choixMode() >0){
            paste0("Le mot à deviner est :<br>",
                   "<font size=\"",input$size,"px\">",
                   as.character(mots[randomVals(), choixMode()]),
                   "</font><br><br><br>")
        }else{
            ""
        }
        
    })

})
