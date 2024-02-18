import 'dart:developer';
import 'dart:isolate';

import '../data/infrastructure/infrastructure.dart';
import '../data/models/emoji_category.dart';

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
    // case [final String e, final String st]:
    //   log(
    //     'Error in Isolate !',
    //     error: e,
    //     stackTrace: StackTrace.fromString(st),
    //   );
    //   return false;
    case final List<HHEmojiCategory> emojis:
      return true;
    case final list:
      log('Error in Isolate: $list');
      return false;
  }
}
