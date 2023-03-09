import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class MainBloc {
  static const minSymbols = 3;
  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

  final searchedSuperheroSubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded("");

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  http.Client? client;

  MainBloc({this.client}) {
    stateSubject.add(MainPageState.noFavorites);

    textSubscription =
        Rx.combineLatest2<String, List<Superhero>, MainPageStateInfo>(
      currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500)),
      FavoriteSuperheroesStorage.getInstance().observeFavoriteSuperheroes(),
      (searchText, favorites) =>
          MainPageStateInfo(searchText, favorites.isNotEmpty),
    ).listen((value) {
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        if (value.haveFavorites) {
          stateSubject.add(MainPageState.favorites);
        } else {
          stateSubject.add(MainPageState.noFavorites);
        }
      } else if (value.searchText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchForSuperheroes(value.searchText);
      }
    });
  }

  void searchForSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);
    searchSubscription = search(text).asStream().listen((searchResults) {
      if (searchResults.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        searchedSuperheroSubject.add(searchResults);
        stateSubject.add(MainPageState.searchResults);
      }
    }, onError: (error, stackTrace) {
      stateSubject.add(MainPageState.loadingError);
    });
  }

  void removeFromFavorites(final String id) {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {
      print("Removed from $event");
    }, onError: (error, stackTrace) {
      print("Error in requestSuperhero: $error, $stackTrace");
    });
  }

  void retry() {
    final currentText = currentTextSubject.value;
    searchForSuperheroes(currentText);
  }

  Stream<List<SuperheroInfo>> observeFavoriteSuperheroes() {
    return FavoriteSuperheroesStorage.getInstance().observeFavoriteSuperheroes().map(
            (superheroes) =>
            superheroes
                .map((superhero) => SuperheroInfo.fromSuperhero(superhero))
                .toList());
  }

  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() =>
      searchedSuperheroSubject;

  Future<List<SuperheroInfo>> search(final String text) async {
    final token = dotenv.env["SUPERHERO_TOKEN"];
    final response = await (client ??= http.Client())
        .get(Uri.parse("https://superheroapi.com/api/$token/search/$text"));
    if (response.statusCode >= 500 && response.statusCode < 599) {
      throw ApiException("Server error happened");
    }
    if (response.statusCode >= 400 && response.statusCode < 499) {
      throw ApiException("Client error happened");
    }

    final decoded = json.decode(response.body);

    if (decoded['response'] == 'success') {
      final List<dynamic> results = decoded['results'];
      final List<Superhero> superheroes = results
          .map((rawSuperhero) => Superhero.fromJson(rawSuperhero))
          .toList();
      final List<SuperheroInfo> found = superheroes.map((superhero) {
        return SuperheroInfo.fromSuperhero(superhero);
      }).toList();

      return found;
    } else if (decoded['response'] == 'error') {
      if (decoded['error'] == 'character with given name not found') {
        return [];
      }
      throw ApiException("Client error happened");
    }
    throw Exception("Unknown error happened");
  }

  Stream<MainPageState> observeMainPageState() => stateSubject;

  void nextState() {
    final currentState = stateSubject.value;
    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? "");
  }

  void dispose() {
    stateSubject.close();
    searchedSuperheroSubject.close();
    currentTextSubject.close();
    client?.close();
    textSubscription?.cancel();
    searchSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}

class SuperheroInfo {
  final String id;
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroInfo({
    required this.id,
    required this.name,
    required this.realName,
    required this.imageUrl,
  });

  factory SuperheroInfo.fromSuperhero(final Superhero superhero) {
    return SuperheroInfo(
      id: superhero.id,
      name: superhero.name,
      realName: superhero.biography.fullName,
      imageUrl: superhero.image.url,
    );
  }

  @override
  static const mocked = [
    SuperheroInfo(
        id: "70",
        name: "Batman",
        realName: "Bruce Wayne",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
    SuperheroInfo(
        id: "732",
        name: "Ironman",
        realName: "Tony Stark",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg"),
    SuperheroInfo(
        id: "687",
        name: "Venom",
        realName: "Eddie Brock",
        imageUrl:
            "https://www.superherodb.com/pictures2/portraits/10/100/22.jpg"),
  ];

  @override
  String toString() {
    return 'SuperheroInfo{id: $id, name: $name, realName: $realName, imageUrl: $imageUrl}';
  }
}

class MainPageStateInfo {
  final String searchText;
  final bool haveFavorites;

  const MainPageStateInfo(this.searchText, this.haveFavorites);

  @override
  String toString() {
    return 'MainPageStateInfo{searchText: $searchText, haveFavorites: $haveFavorites}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainPageStateInfo &&
          runtimeType == other.runtimeType &&
          searchText == other.searchText &&
          haveFavorites == other.haveFavorites;

  @override
  int get hashCode => searchText.hashCode ^ haveFavorites.hashCode;
}
