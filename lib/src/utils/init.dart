import 'dart:developer';
import 'dart:isolate';

import '../data/infrastructure/infrastructure.dart';
import '../data/models/emoji_category.dart';

List<HHEmojiCategory> allEmojis = [];

Future<bool> init(Infrastructure infra) async {
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
