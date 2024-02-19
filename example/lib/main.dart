import 'package:flutter/material.dart';
import 'package:heyhub_emoji/heyhub_emoji.dart';

void main() async {
  await init(GithubInfra());
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

  Future<void> _sendMsg(String msg) async {
    if (msg.isEmpty) return;
    setState(() => messages.add(msg));
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
                onPressed: () {},
                icon: const Icon(Icons.emoji_emotions),
              ),
              Expanded(
                child: TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Type new message'),
                  controller: _controller,
                ),
              ),
              IconButton(
                onPressed: () {
                  _sendMsg(_controller.text);
                  _controller.clear();
                },
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
