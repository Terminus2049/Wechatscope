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

复制 `0 2 * * * cd ~/Wechatscope && R CMD BATCH wechatscope.R` 到最后一行。

## 在线查看
