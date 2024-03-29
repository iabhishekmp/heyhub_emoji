import 'package:flutter/material.dart';
import 'package:heyhub_emoji/heyhub_emoji.dart';

void main() async {
  //? this is necessary !!
  WidgetsFlutterBinding.ensureInitialized();
  await HeyhubEmoji.init(GithubInfra());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeyHub Emoji',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> messages = [];
  final _controller = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  Future<void> _sendMsg() async {
    final msg = _controller.text;
    if (msg.isEmpty) return;
    setState(() => messages.add(msg));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Heyhub Emoji'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('No Messages'))
                : SingleChildScrollView(
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: messages.map(Text.new).toList(),
                      ),
                    ),
                  ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  _textFieldFocusNode.unfocus();
                  final emoji = await HeyhubEmoji.showEmojiDialog(context);
                  if (emoji != null) {
                    _controller.text = _controller.text + emoji;
                  }
                  _textFieldFocusNode.requestFocus();
                },
                icon: const Icon(Icons.emoji_emotions),
              ),
              Expanded(
                child: TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Type new message'),
                  focusNode: _textFieldFocusNode,
                  controller: _controller,
                ),
              ),
              IconButton(
                onPressed: _sendMsg,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
