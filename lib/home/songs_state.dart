import 'package:flutter/material.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/rank_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';

class SongsState {

  PlayListItemModel? playListItem;
  RankListItemModel? rankListItem;

  List<SongListItem> songs = [];
  List<SongRankModel> ranks = [];
  int selectedIndex = -1;

  int offset = 0;

  ScrollController scrollController = ScrollController();
  bool haveMore = true;
}