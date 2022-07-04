class Api {
  static String host =
      "https://service-1neqmc80-1257701204.gz.apigw.tencentcs.com/release/";

  static String music = host + "music";
  static String play = host + "play";
  static String lyric = host + "lyric";
  static String playlist = host + "playlist";
  static String search = host + "search";


  static String oneWord = "https://v1.hitokoto.cn/";

  /// 歌单
  static String kugouPlayList =
      "http://mobilecdn.kugou.com/api/v3/category/special?withsong=1&sort=3&plat=0&ugc=1&page=1&categoryid=0&pagesize=20";

  /// 获取歌单所有歌曲信息
  static String songListDetail =
      "http://mobilecdn.kugou.com/api/v3/special/song?plat=0&specialid={歌单 id}&page=1&pagesize=-1&version=8352&with_res_tag=1";

  /// 网易云音乐热门歌单
  static String neteasePlayList = "http://music.googlec.cc/Home/List?ident=&search2=&sort=PlayCount&order=desc&_=1656930401519";
      // "https://googlec.cc/_next/data/c_vgN4T6QC4nrhMVmsWbY/playlist/";
      // "http://www.googlec.cc/Home/List?ident=&search2=&sort=PlayCount&order=desc&_=1646578856186";

  // http://music.googlec.cc/Home/List?ident=&search2=&sort=PlayCount&order=desc&offset=0&limit=10&_=1656930401519
  // https://googlec.cc/_next/data/c_vgN4T6QC4nrhMVmsWbY/playlist/2022-07-04/1/p.json

  /// Top500
  static String top500 =
      "http://mobilecdn.kugou.com/api/v3/rank/song?ranktype=2&rankid=58176&plat=0&page=1&pagesize=30&version=8352&with_res_tag=1";

  /// 酷狗歌曲所有排行
  static String rankList = "http://mobilecdn.kugou.com/api/v3/rank/list?apiver=4&withsong=1&showtype=2&plat=0&parentid=0&version=8352&with_res_tag=1";

  /// 获取某个排行榜下的所有的歌曲
  static String rankSongsList = "http://mobilecdn.kugou.com/api/v3/rank/song?version=8352&with_res_tag=1";
}

/**

    /// Api地址
    https://www.dazhuanlan.com/yyuansp/topics/1036920
    https://cloud.tencent.com/developer/article/1543945

    /// 网易云歌单爬虫
    https://zhuanlan.zhihu.com/p/359245832

    /// 网易云歌单
    http://www.googlec.cc/

    获取歌手所有歌曲：
    http://mobilecdn.kugou.com/api/v3/singer/song?plat=0&page=1&sorttype=2&pagesize=20&version=8352&singerid={歌手 id}&with_res_tag=1

    新碟上架：
    http://service.mobile.kugou.com/v1/yueku/recommend?plat=0&type=8&operator=2&version=8352

    获取歌曲所有排行：
    http://mobilecdn.kugou.com/api/v3/rank/list?apiver=4&withsong=1&showtype=2&plat=0&parentid=0&version=8352&with_res_tag=1
    可获取排行榜 ranktype 和 rankid 然后从下面获取排行榜所有歌曲
    http://mobilecdn.kugou.com/api/v3/rank/song?ranktype={type}&rankid={id}&plat=0&page={页数}&pagesize={单页数量}&version=8352&with_res_tag=1
 */
