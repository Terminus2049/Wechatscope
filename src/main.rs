extern crate csv;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate reqwest;
extern crate walkdir;


use std::collections::HashSet;
use std::error::Error;
use std::fs::{create_dir_all, File};
use std::io;
use std::thread;
use std::time;

use walkdir::WalkDir;

#[derive(Debug, Serialize, Deserialize, PartialEq)]
struct Wechat {
    title: String,
    nickname: String,
    created_at: String,
    archive: String,
    censored_date: String,
    censored_msg: String,
    update_date: Option<String>,
}

fn main() -> Result<(), Box<Error>> {
    let mut archive = HashSet::new();

    // 读取历史数据
    let mut rdr = csv::Reader::from_reader(io::stdin());
    for result in rdr.deserialize() {
        let record: Wechat = result?;
        archive.insert(record.archive + ".html");
    }

    println!("已经积累 {:?} 条记录", archive.len());


    // 读取已经下载的文件
    let mut downloaded = HashSet::new();

    create_dir_all("./data/")?;

    for entry in WalkDir::new("./data/")
        .into_iter()
        .filter_map(Result::ok)
        .filter(|e| !e.file_type().is_dir())
    {
        let f_name = String::from(entry.file_name().to_string_lossy());
        downloaded.insert(f_name);
    }

    println!("已下载 {:?} 条记录", downloaded.len());


    // 获取未下载的文件
    let client = reqwest::Client::builder()
        .timeout(time::Duration::from_secs(90))
        .build()?;

    let mut count = 0;
    for i in archive {
        if !downloaded.contains(&i) {
            count += 1;
            println!("{} {:?}", count, i);
            let url = "https://wechatscope.jmsc.hku.hk/api/html?fn=".to_owned() + &i;
            let mut response = client.get(&url).send()?;
            let mut dest = File::create("./data/".to_owned() + &i)?;
            io::copy(&mut response, &mut dest)?;
            thread::sleep(time::Duration::from_secs(3));
        }
    }

    println!("新下载 {:?} 条记录", count);

    Ok(())
}
