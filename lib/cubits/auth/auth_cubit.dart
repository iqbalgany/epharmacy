import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/remote_datasource/auth_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  late StreamSubscription<User?> _userSubscription;
  AuthCubit(this._authRemoteDatasource) : super(const AuthState());

  void _monitorAuthState() {
    _userSubscription = _authRemoteDatasource.authStatechange.listen((user) {
      if (user != null) {
        emit(
          state.copyWith(
            status: AuthStatus.success,
            user: user,
            errorMessage: null,
          ),
        );
      } else {
        emit(state.copyWith(status: AuthStatus.initial, user: null));
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authRemoteDatasource.signInWithEmailAndPassword(email, password, context)
    } on FirebaseAuthException catch (e) {
      
    }
  }
}
