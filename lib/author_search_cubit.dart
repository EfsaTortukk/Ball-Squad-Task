import 'package:flutter_bloc/flutter_bloc.dart';


abstract class AuthorSearchEvent {}

abstract class AuthorSearchState {}

class Initial extends AuthorSearchState {}

class AuthorSearchCubit extends Cubit<AuthorSearchState> {
  AuthorSearchCubit() : super(Initial());

}
