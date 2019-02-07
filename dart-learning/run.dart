import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:args/args.dart';

void main(List<String> arguments) {
  // parse command line arguments
  final parser = new ArgParser();
  parser.addOption('comic');

  // store arguments in argResults
  var argResults = parser.parse(arguments);

  // if user requested a specific comic
  if (argResults['comic'] != null) {
    // load comic number
    var comicNumber = int.tryParse(argResults['comic']) ?? -1;
    loadComicByNumber(comicNumber);
  } else {
    // load latest comic
    loadLatestComic();
  }
}

// load a specific comic by it's number, or return an error if it's an invalid comic.
void loadComicByNumber(int comicNumber) {
  // comic 404 doesn't exist, along with anything less than 0
  if (comicNumber < 0 || comicNumber == 404) {
    print('Comic does not exist, try again!');
    return;
  }

  // call xkcd api and get comic information
  http.get('https://xkcd.com/$comicNumber/info.0.json').then((response) {
    // for now just print out the comic number, title, image url, and alt text
    var json = jsonDecode(response.body);
    print("#$comicNumber - ${json['title']}");
    print(json['img']);
    print(json['alt']);
  });
}

void loadLatestComic() {
  http.get('https://xkcd.com/info.0.json').then((response) {
    // for now just print out the comic number, title, image url, and alt text
    var json = jsonDecode(response.body);
    print("#${json['num']} - ${json['title']}");
    print(json['img']);
    print(json['alt']);
  });
}
