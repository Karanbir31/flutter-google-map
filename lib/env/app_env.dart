import 'package:envied/envied.dart';

part 'app_env.g.dart'; // must match file name

@Envied(path: 'app_env.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GOOGLE_MAP_API_KEY')
  static final String googleMapApiKey = _Env.googleMapApiKey;
}
