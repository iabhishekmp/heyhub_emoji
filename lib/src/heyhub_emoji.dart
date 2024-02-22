import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

import '../heyhub_emoji.dart';
import 'data/models/emoji.dart';
import 'data/models/emoji_category.dart';
import 'data/models/emoji_subcategory.dart';
import 'utils/shared_pref.dart';
import 'view/emoji_dialog.dart';

class HeyhubEmoji {
  HeyhubEmoji._();
  static List<HHEmojiCategory> _allEmojis = [];
  static List<HHEmoji> _recentEmoji = [];
  static const _recentEmojiKey = 'recentEmoji';
  static const _maxRecent = 10;

  /// call this method before you want to use emojis
  /// this will fetch emojis from source
  static Future<bool> init(Infrastructure infra) async {
    //? init shared pref
    await SharedPref.init();
    _setRecentEmojis();

    //? fetch the emojis
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      (sendport) async {
        final result = await infra.fetch();
        sendport.send(result);
      },
      receivePort.sendPort,
      paused: true,
    );
    isolate
      ..addErrorListener(receivePort.sendPort)
      ..resume(isolate.pauseCapability!);

    final result = await receivePort.first as List;
    switch (result) {
      //? emojis
      case final List<HHEmojiCategory> emojis:
        _allEmojis = emojis;
        return true;

      //? other than emojis
      case final list:
        log('Error in Isolate:\n $list');
        return false;
    }
  }

  static void _setRecentEmojis() {
    final data = SharedPref.instance.getString(_recentEmojiKey);
    if (data == null) return;
    _recentEmoji = HHEmojiSubcategory.fromJson(data).emojis;
  }

  static Future<void> _addToRecent(HHEmoji emoji) async {
    //? remove if already exist
    for (var i = 0; i < _recentEmoji.length; i++) {
      if (_recentEmoji[i].id == emoji.id) {
        _recentEmoji.removeAt(i);
      }
    }

    //? remove if list became > 10
    if (_recentEmoji.length == _maxRecent) {
      _recentEmoji.removeAt(_maxRecent - 1);
    }

    //? add emoji to list
    _recentEmoji.insert(0, emoji);
    await SharedPref.instance.setString(
      _recentEmojiKey,
      HHEmojiSubcategory(name: '', emojis: _recentEmoji).toJson(),
    );
  }

  /// opens the dialog to select the emoji
  /// returns `null` if abort else emoji as `String`
  static Future<String?> showEmojiDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return EmojiDialog(
          emojis: _allEmojis,
          recentEmojis: _recentEmoji,
          onSelect: (emoji) async {
            unawaited(_addToRecent(emoji));
            Navigator.pop(ctx, emoji.emoji);
          },
        );
      },
    );
  }
}
