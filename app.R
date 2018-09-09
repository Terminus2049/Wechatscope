
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
    tabPanel('Since 2018-07-06',
             fluidRow(
               column(4,
                      selectInput("msg",
                                  "censored_msg",
                                  c("All", we_ui))
               )
             ),
             DT::dataTableOutput("table1")
             ),
    
    tabPanel('Account',
             includeHTML("form.html"),
             DT::dataTableOutput("table2")
             ),
    
    tabPanel('Download', downloadButton("downloadData", "Download"))
    )
}


# Define server logic to display and download selected file ----
server <- function(input, output, session) {
  
  wechat = reactiveFileReader(60000, session, 'ceninfo.csv', read_csv)
  
  output$table1 <- DT::renderDataTable({
    
    we = wechat()
    
    if (input$msg != "All") {
      we <- we[we$censored_msg == input$msg,]
    }
    
    we$archive = createLink(we$archive, we$archive)
    
    DT::datatable(we, escape = FALSE,
                  options = list(order = list(5, 'desc')))
  })
  
  output$table2 <- DT::renderDataTable({
    
    DT::datatable(unique(wechat()[,2]), options = list(paging = FALSE))
  })
  
  
  output$downloadData <- downloadHandler(
    filename = "wechatscope.csv",
    content = function(file) {
      write.csv(wechat(), file, row.names = FALSE)
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)

