

import 'package:api_in/domain/entities/movies_entity.dart';

abstract class MoviesRepository {

  Future<List<Movie>>fetchMovies(String token);
  Future<void>deleteMovies(int id);
}
