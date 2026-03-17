import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
