import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

import '../heyhub_emoji.dart';
import 'data/models/emoji_category.dart';

List<HHEmojiCategory> allEmojis = [];

class HeyhubEmoji {
  HeyhubEmoji._();

  /// call this method before you want to use emojis
  /// this will fetch emojis from source
  static Future<bool> init(Infrastructure infra) async {
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
        allEmojis = emojis;
        return true;

      //? other than emojis
      case final list:
        log('Error in Isolate:\n $list');
        return false;
    }
  }

  /// opens the dialog to select the emoji
  /// returns `null` if abort else emoji as `String`
  static Future<String?> showEmojiDialog(BuildContext context) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    // return null;
    return '😂';
  }
}
