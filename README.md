# Wechatscope

## 每日数据存档

由于 Wechatscope(<http://wechatscope.jmsc.hku.hk/>) 项目只提供七天内的被删数据，设计定时任务每日获取近三天的数据，并去重后合并到同一数据库内。

```bash
git clone https://github.com/Terminus2049/Wechatscope.git
```

设置定时任务：

```bash
crontab -e
```

`wechatscope.R` 负责抓取最近三天的数据并合并到数据库内。可开启定时任务：

复制 `* */1 * * * cd ~/Wechatscope && R CMD BATCH wechatscope.R` 到最后一行。程序会每小时运行一次。

## 表格化

`app.R` 利用 shiny 进行表格化。

在 R 语言环境中 `shiny::runApp()`

## 在线部署并自动更新

在 Linux 服务器上安装 [shiny-server](https://github.com/rstudio/shiny-server)

```bash
cd /srv/shiny-server/
git clone https://github.com/Terminus2049/Wechatscope.git
```

同样开启定时任务：

```crontab -e```

复制 `* */1 * * * cd /srv/shiny-server/Wechatscope/  && R CMD BATCH wechatscope.R` 到定时任务中。

然后就可以在 `http://<ip>:3838/Wechatscope/` 查看。

### 注意

1. 请安装合适的 R 版本，不要使用默认的 R 版本，但也不要安装最新的 R 3.5，应安装 R 3.4。安装教程：[UBUNTU PACKAGES FOR R](https://cran.rstudio.com/bin/linux/ubuntu/README.html)

2. 下载并安装 [shiny-server](https://www.rstudio.com/products/shiny/download-server/)

3. 需要安装 R 包 `readr`、`shiny`、`httr`、`DT` 和 `data.table`，如果内存过小，会编译失败，可通过 [此教程](https://github.com/tidyverse/readr/issues/544#issuecomment-264647581) 处理。
