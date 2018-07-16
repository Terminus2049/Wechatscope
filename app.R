
library(shiny)
library(readr)

createLink <- function(link, val) {
  l = paste0('<a href="http://wechatscope.jmsc.hku.hk:8000/html?fn=', link, 
             '" target="_blank" class="btn btn-primary">查看全文</a>')
  sprintf(l,val)
}

we_ui= c("此内容因违规无法查看", "此内容被投诉且经审核涉嫌侵权，无法查看。",
         "此帐号已被屏蔽,", "该公众号已迁移", "该内容已被发布者删除")

# Define UI for data download app ----
ui <- function(input, output, session){
  
  navbarPage(
    title = 'Wechatscope',
    tabPanel('Since 2018-07-06'),
    fluidRow(
      column(4,
             selectInput("msg",
                         "censored_msg",
                         c("All", we_ui))
      )
    ),
      DT::dataTableOutput("table1")
    )
}


# Define server logic to display and download selected file ----
server <- function(input, output, session) {
  
  wechat = reactiveFileReader(10000, session, 'ceninfo.csv', read_csv)
  
  output$table1 <- DT::renderDataTable({
    
    we = unique(wechat()[,1:8])
    
    if (input$msg != "All") {
      we <- we[we$censored_msg == input$msg,]
    }
    
    we$archive = createLink(we$archive, we$archive)
    
    DT::datatable(we[, c(2,4,5:8)], escape = FALSE,
                  options = list(order = list(3, 'desc')))
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)

