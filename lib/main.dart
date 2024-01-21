import 'package:filmhunt/Movie.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FilmHunt());
}



class FilmHunt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Hunt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [
    Movie(
      name: 'Monster House',
      year: 2022,
      popularity: 8.5,
      imdbRating: 7.9,
      poster: 'https://th.bing.com/th?id=OIP.1umjRUVLTbPQCPVU_q1HPgHaK-&w=205&h=304&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    ),
    Movie(
      name: 'Special 26',
      year: 2021,
      popularity: 7.8,
      imdbRating: 8.2,
      poster: 'https://th.bing.com/th?id=OIP.-6TGwYgfzcuBNWDjjEOpHQHaKs&w=207&h=300&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    ),
    Movie(
      name: 'Justice League',
      year: 2023,
      popularity: 9.0,
      imdbRating: 8.5,
      poster: 'https://th.bing.com/th?id=OIP.c3VjSn9aWHYI-JidQavqcgHaK-&w=205&h=304&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    ),
  ];

  String _selectedSortCriteria = 'Date'; // Default sorting criteria

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Hunt'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(movies),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sort By:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedSortCriteria,
                  onChanged: (value) {
                    setState(() {
                      _selectedSortCriteria = value!;
                      _sortMovies();
                    });
                  },
                  items: ['Date', 'Popularity', 'Rating']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: MovieList(movies: movies),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Initiating search
          showSearch(
            context: context,
            delegate: MovieSearchDelegate(movies),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }

  void _sortMovies() {
    switch (_selectedSortCriteria) {
      case 'Date':
        movies.sort((a, b) => a.year.compareTo(b.year));
        break;
      case 'Popularity':
        movies.sort((a, b) => a.popularity.compareTo(b.popularity));
        break;
      case 'Rating':
        movies.sort((a, b) => a.imdbRating.compareTo(b.imdbRating));
        break;
    }
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(movies[index].name),
          subtitle: Text('Year: ${movies[index].year}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movie: movies[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(movie.poster, height: 200.0),
          SizedBox(height: 20.0),
          Text('Year: ${movie.year}'),
          Text('Popularity: ${movie.popularity}'),
          Text('IMDb Rating: ${movie.imdbRating}'),
        ],
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<Movie> {
  final List<Movie> movies;

  MovieSearchDelegate(this.movies);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 
Movie(
      name: 'Movie 1',
      year: 2022,
      popularity: 8.5,
      imdbRating: 7.9,
      poster: 'https://th.bing.com/th?id=OIP.1umjRUVLTbPQCPVU_q1HPgHaK-&w=205&h=304&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
    ));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final suggestionList = movies.where(
      (movie) => movie.name.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    return MovieList(movies: suggestionList);
  }
}

