import 'package:flutter/material.dart';

import '../data/models/emoji.dart';
import '../data/models/emoji_category.dart';
import '../utils/category_extension.dart';

class EmojiDialog extends StatefulWidget {
  EmojiDialog({
    required this.emojis,
    required this.onSelect,
    required this.recentEmojis,
    super.key,
  }) : allEmojis = emojis.allEmojis;

  final List<HHEmojiCategory> emojis;
  final List<HHEmoji> recentEmojis;
  final void Function(HHEmoji emoji) onSelect;
  final List<HHEmoji> allEmojis;

  @override
  State<EmojiDialog> createState() => _EmojiDialogState();
}

class _EmojiDialogState extends State<EmojiDialog> {
  List<HHEmoji> searchedEmojis = [];

  void _handleSearch(String input) {
    searchedEmojis.clear();
    if (input.isNotEmpty) {
      for (final emoji in widget.allEmojis) {
        if (emoji.description.toLowerCase().contains(input.toLowerCase())) {
          searchedEmojis.add(emoji);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: DefaultTabController(
          length: widget.emojis.length,
          child: Column(
            children: [
              _Categories(widget.emojis),
              _SearchField(onChanged: _handleSearch),
              if (searchedEmojis.isEmpty) ...[
                _RecentEmojis(widget.recentEmojis, onSelect: widget.onSelect),
                _AllEmojis(widget.emojis, onSelect: widget.onSelect),
              ] else
                Expanded(
                  child: _EmojiGrid(
                    emojis: searchedEmojis,
                    onTap: widget.onSelect,
                    title: 'Searched',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories(this.allCategories);
  final List<HHEmojiCategory> allCategories;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.all(2),
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      tabs: allCategories.map((e) => _EmojiIcon(e.icon)).toList(),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 40,
        child: TextField(
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search Emojis',
            hintStyle: const TextStyle(
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}

class _RecentEmojis extends StatelessWidget {
  const _RecentEmojis(
    this.recentEmojis, {
    required this.onSelect,
  });

  final List<HHEmoji> recentEmojis;
  final void Function(HHEmoji) onSelect;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: _EmojiGrid(
        title: 'Recent Emojis',
        emojis: recentEmojis,
        onTap: onSelect,
      ),
    );
  }
}

class _AllEmojis extends StatelessWidget {
  const _AllEmojis(this.allCategories, {required this.onSelect});

  final List<HHEmojiCategory> allCategories;
  final void Function(HHEmoji) onSelect;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: TabBarView(
        children: allCategories.map(
          (category) {
            final allEmojis = category.allEmojis;
            return _EmojiGrid(
              title: category.name,
              emojis: allEmojis,
              onTap: onSelect,
            );
          },
        ).toList(),
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({
    required this.emojis,
    required this.onTap,
    required this.title,
  });

  final List<HHEmoji> emojis;
  final void Function(HHEmoji) onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                final emoji = emojis[index];
                return _EmojiIcon(
                  emoji.emoji,
                  onTap: () => onTap(emoji),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiIcon extends StatelessWidget {
  const _EmojiIcon(
    this.emoji, {
    this.onTap,
  });

  final String emoji;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
