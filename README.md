简悦 是一款简单免费的音乐播放器，自己写Flutter也有一段时间了，刚好最近公司的项目想在PC端重写一个，就想着用Flutter实现试一试，于是先拿这个项目来熟悉一下Flutter开发PC端，练练手，主要用于学习及个人使用，没有商业用途哈，还有很重要的一点：不支持收费音乐的播放哦。

目前可以运行在Mac、iOS、Android上，Web端本来也是可以的，但是SQLite数据存储还没有比较好的方案，就暂时放弃了，Windows没有装Win系统的电脑，所以还没跑过，不知道效果啥样，PC和手机端都做了单独的适配。UI界面和icon用Sketch来设计完成的，还支持自动切换深色/浅色模式，后端部分接口时候云函数实现，用于拉取歌单和单曲的播放链接。

主要功能：

1. 音乐播放、暂停、下一首、收藏、歌词显示。
2. 单曲或者歌单搜索播放。
3. 本地存储收藏的歌曲，并展示在收藏列表中。
4. 热门歌单。
5. 最近歌曲排行榜。
6. 深色 / 浅色模式切换。

运行环境：

```markdown
Channel stable, 2.5.2
```

PC端效果

|                             Dark                             |                            Light                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![image-20220719182826564](https://s2.loli.net/2022/07/20/xjRtCsOeKuVZcf9.png) | ![image-20220719182713602](https://s2.loli.net/2022/07/20/BF6GjActRLqPmQK.png) |
| ![image-20220719182304064](https://s2.loli.net/2022/07/20/YcOzflk7Fg56InS.png) | ![image-20220719183007520](https://s2.loli.net/2022/07/20/otd97Dvu5Kh3Umj.png) |
| ![image-20220719182328498](https://s2.loli.net/2022/07/20/1qnb4HGjRxVi3UB.png) | ![image-20220719183031533](https://s2.loli.net/2022/07/20/6SDKeVdwOQ43Ljb.png) |
| ![image-20220719182446052](https://s2.loli.net/2022/07/20/6CceQDJRxEr5PMd.png) | ![image-20220719183218870](https://s2.loli.net/2022/07/20/VUdh2qDNOwuZ81p.png) |
| ![image-20220719182521347](https://s2.loli.net/2022/07/20/qBb4ZogGfYpJQxv.png) | ![image-20220719183201305](https://s2.loli.net/2022/07/20/D4rmN83Md5qgRBu.png) |

移动端效果

|                             Dark                             |                            Light                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![391658286368_.pic](https://s2.loli.net/2022/07/20/9qHY3mylBCKn5t8.jpg) | ![381658286368_.pic](https://s2.loli.net/2022/07/20/OSeiJsYhqXzrlvw.jpg) |
| ![491658286755_.pic](https://s2.loli.net/2022/07/20/thJ8iefyn4Cbzqs.jpg) | ![481658286754_.pic](https://s2.loli.net/2022/07/20/YkLfW6nXesBQRxg.jpg) |
| ![431658286370_.pic](https://s2.loli.net/2022/07/20/NqvOGosW5cm2Bbt.jpg) | ![421658286369_.pic](https://s2.loli.net/2022/07/20/CSArugdF7wMTX3a.jpg) |
| ![441658286370_.pic](https://s2.loli.net/2022/07/20/bdBYlmLfSiDUJPM.jpg) | ![411658286369_.pic](https://s2.loli.net/2022/07/20/1Q8XqlFpAE7T2cL.jpg) |
| ![451658286370_.pic](https://s2.loli.net/2022/07/20/ubAprcSdTe6n3Va.jpg) | ![401658286368_.pic](https://s2.loli.net/2022/07/20/cyYZJeTDlzHtFPn.jpg) |
| ![471658286375_.pic](https://s2.loli.net/2022/07/20/eSNH1o3WBYqEzK5.jpg) |                                                              |

感谢：

[Meting](https://github.com/metowolf/Meting)

[NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)

[www.googlec.cc](http://www.googlec.cc/)

[v1.hitokoto.cn](https://v1.hitokoto.cn/)

微信公众号：nnxkcloud，关注后有更多有意思的内容哦！

<img src="https://s2.loli.net/2022/07/25/OZh2nqwxVdraLtR.jpg" alt="qrcode_for_gh_a83f08fc43d0_860" width="180px" />
