import 'package:get/get.dart';

import '../../data/remoteData/apis.dart';
import '../../config/helpers/pref.dart';
import '../../data/models/vpn.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = Pref.vpnList;

  final RxBool isLoading = false.obs;

  Future<void> getVpnData() async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await APIs.getVPNServers();
    isLoading.value = false;
  }
}
