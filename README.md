# Wechatscope

## 每日数据存档

由于 Wechatscope(<http://wechatscope.jmsc.hku.hk/>) 项目只提供七天内的被删数据，因此设计定时任务每日获取近三天的数据，并去重后合并到同一数据库内。

```bash
git clone https://github.com/Terminus2049/Wechatscope.git
```

设置定时任务：

```bash
crontab -e
```

复制 `* */1 * * * cd ~/Wechatscope && R CMD BATCH wechatscope.R` 到最后一行。程序会每小时运行一次。

## 可视化

在 R 语言环境中 `shiny::runApp()`

## 在线部署并自动更新

在 Linux 服务器上安装 [shiny-server](https://github.com/rstudio/shiny-server)

```bash
cd /srv/shiny-server/
git clone https://github.com/Terminus2049/Wechatscope.git
crontab -e
```

复制 `* */1 * * * cd /srv/shiny-server/Wechatscope/  && R CMD BATCH wechatscope.R` 到定时任务中。