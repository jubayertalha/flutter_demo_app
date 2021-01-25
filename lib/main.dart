import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main(){

  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWord(),
    );

  }
}

class RandomWord extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new RandomWordState();

}

class RandomWordState extends State<RandomWord> {

  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerText = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    Widget _buildRow(WordPair wordPair){

      final bool alreadySaved = _saved.contains(wordPair);

      return ListTile(
        title: Text(
          wordPair.asPascalCase,
          style: _biggerText,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: (){
          setState(() {
            if(alreadySaved){
              _saved.remove(wordPair);
            } else{
              _saved.add(wordPair);
            }
          });
        },
      );
    }

    Widget _buildSuggestion (){
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context,i){
          if (i.isOdd) return Divider();
          final index = i~/2;
          if (index >= _suggestions.length) _suggestions.addAll(generateWordPairs().take(10));
          return _buildRow(_suggestions[index]);
        },
      );
    }

    void _pushSaved(){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              final Iterable<ListTile> tiles = _saved.map(
                  (WordPair wordPair){
                    return ListTile(
                      title: Text(
                        wordPair.asPascalCase,
                        style: _biggerText,
                      ),
                    );
                  }
              );
              final List<Widget> divided = ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
              ).toList();
              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved words'),
                ),
                body: ListView(children: divided,),
              );
            }
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Random Text Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestion(),
    );

  }

}
