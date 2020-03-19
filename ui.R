#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tags$head(tags$script(src = "message-handler.js")),
    
    # Application title
    titlePanel("Révision des caractères chinois"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "question",
                        label = "Choix du mode d'interrogation",
                        choices = c("Français -> Pinyin",
                                    "Pinyin -> Français",
                                    "Chinois -> Français")),
            actionButton("nouveauMot", "Nouveau mot"),
            actionButton("reponse", "Afficher réponse"),
            sliderInput("size", "Taille du texte",
                        min = 1, max = 7, value = 3)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            htmlOutput("motADeviner"),
            htmlOutput("reponse")
        )
    )
))
