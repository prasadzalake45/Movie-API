

import 'package:api_in/data/data_sources/auth_remote_data_source.dart';
import 'package:api_in/data/models/user_model.dart';
import 'package:api_in/domain/entities/user_entity.dart';
import 'package:api_in/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String>register(UserEntity user) async{
    return await remoteDataSource.register(UserModel(username: user.username, password: user.password));

  }

    Future<String>login(UserEntity user) async{
    return await remoteDataSource.login(UserModel(username: user.username, password: user.password));

  }
}