library(shiny)
library(searchConsoleR)
library(googleAuthR)

gar_set_client(web_json = "client.json",
               scopes = "https://www.googleapis.com/auth/webmasters")

ui <- fluidPage(
  googleAuth_jsUI('auth', login_text = 'Login to Google'),
  tableOutput("sc_accounts")
)

server <- function(input, output, session) {
  auth <- callModule(googleAuth_js, "auth")
  
  sc_accounts <- reactive({
    req(auth())
    
    with_shiny(
      list_websites,
      shiny_access_token = auth()
    )
    
  })
  
  output$sc_accounts <- renderTable({
    sc_accounts()
  })
  
  
}

shinyApp(ui = ui, server = server)