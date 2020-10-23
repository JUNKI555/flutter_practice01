import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      leading: const Icon(Icons.auto_awesome, color: Colors.green),
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Future<void> _setSuggestions() async {
    setState(() {
      _saved.clear();
      _suggestions.clear();
      final newWordPairs = generateWordPairs().take(10);
      _suggestions.addAll(newWordPairs);
    });
  }

  Widget _buildSuggestions() {
    return RefreshIndicator(
      onRefresh: _setSuggestions,
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 20,
          itemBuilder: (context, i) {
            // 奇数行で区切り線
            if (i.isOdd) {
              return const Divider(color: Colors.red);
            }

            // 区切り線の分を排除したいので2で除算
            final index = i ~/ 2;

            // 偶数行ならListTileを描画
            return _buildRow(_suggestions[index]);
          }),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final devided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: devided),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
