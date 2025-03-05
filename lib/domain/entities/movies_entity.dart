

class Movie{

  final int id;
  final String title;
  final String genre;
  final  String releaseDate;

  Movie({

    required this.id,
    required this.title,
    required this.genre,

    required this.releaseDate
  });


  factory Movie.fromJson(Map<String,dynamic>json){
    return Movie(
      id:json['id'],
      title: json['title'],
      genre:json['genre'],
      releaseDate: json['releaseDate'],


    );
  }

}