library(httr)
library(data.table)


get_weixin = function(days){
  
  # The URL of the update_weixin API
  url_wxupdate = 'http://wechatscope.jmsc.hku.hk:8000/update_weixin_public?days='
  
  ceninfo = GET(url = paste0(url_wxupdate, days))
  
  rbindlist(content(ceninfo), fill=TRUE)
  
}

tryCatch({
  
  print(Sys.time())
  
  ceninfo_content = get_weixin(3)
  fname = paste0('wechat-', Sys.Date(), '.csv')
  write.csv(ceninfo_content, fname, row.names = F)

  # ceninfo.csv 记录的最早日期是 2018.07.06，并每天追加
  
  wechat = fread("ceninfo.csv")
  wechat = unique(rbind(wechat, ceninfo_content))
  write.csv(wechat, 'ceninfo.csv', row.names = F)
  
  },
  
  error = function(e){
    cat("ERROR :",conditionMessage(e), "\n")
  })
