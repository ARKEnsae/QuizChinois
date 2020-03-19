library(shiny)

ui <- fluidPage(
  tags$audio(src = "Chiquitita.mp3", type = "audio/mp3", autoplay = NA, controls = NA)
)

server <- function(input, output) {
  #tags$audio(src = "Chiquitita.mp3", type = "audio/mp3", autoplay = TRUE, controls = NA)
  # eventReactive(input$go, {
  #   tags$audio(src = "Chiquitita.mp3", type = "audio/mp3", autoplay = TRUE, controls = TRUE)
  # })
}

shinyApp(ui, server)



library(shiny)
library(shinydashboard)
library(readr)
library(tuneR)
library(seewave)

Soundfile <- read_csv("Soundfile.csv")
class(Soundfile)
ui <- dashboardPage(
  dashboardHeader(title = "Example Audio Play"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Play Audio", tabName = "playaudio", icon = icon("dashboard"))
    )),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "playaudio",
              fluidRow(
                box(title = "Controls", width = 4,
                    actionButton("playsound", label = "Play The Rebuilt Sound!"))
              )
      )
    )
  )
)

server <- function(input, output) {
  Soundwav <- Wave(left = Soundfile, samp.rate = 44100, bit = 16)
  savewav(Soundwav, filename = "www\\Soundwavexported.wav")
  
  
  observeEvent(input$playsound, {
    insertUI(selector = "#playsound",
             where = "afterEnd",
             ui = tags$audio(src = "Soundwavexported.wav", type = "audio/wav", autoplay = NA, controls = NA, style="display:none;")
    )
  })
  
}


shinyApp(ui, server)