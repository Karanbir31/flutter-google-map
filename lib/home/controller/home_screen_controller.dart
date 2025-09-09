import 'package:fluttergooglemap/env/app_env.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxString apikey = "NA".obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    apikey.value = Env.googleMapApiKey;
  }
}
