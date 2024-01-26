import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../domain/controllers/home_controller.dart';
import '../../domain/controllers/location_controller.dart';
import '../../domain/services/vpn_engine.dart';
import '../../config/helpers/my_text.dart';
import '../../config/helpers/pref.dart';
import 'home_screen.dart';

class ServerScreen extends StatelessWidget {
  ServerScreen({super.key});
  final _controller = LocationController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    if (_controller.vpnList.isEmpty) _controller.getVpnData();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * .01,
              horizontal: width * 0.03,
            ),
            child: _controller.isLoading.value
                ? _loadingWidget(context)
                : _controller.vpnList.isEmpty
                    ? _noVPNFound()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppBar(
                              text: "Server (${_controller.vpnList.length})"),
                          SizedBox(height: height * .02),
                          MyTextPoppines(
                            text: "All Server",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.045,
                          ),
                          SizedBox(height: height * .02),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _controller.vpnList.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (ctx, i) {
                                final vpn = _controller.vpnList[i];
                                final img =
                                    'assets/flags/${vpn.countryShort.toLowerCase()}.png';
                                return ServerCard(
                                    server: vpn.countryLong,
                                    locations: vpn.numVpnSessions.toString(),
                                    img: img,
                                    ms: vpn.ping,
                                    onTap: () {
                                      controller.vpn.value = vpn;
                                      Pref.vpn = vpn;
                                      Get.back();
                                      if (controller.vpnState.value ==
                                          VpnEngine.vpnConnected) {
                                        VpnEngine.stopVpn();
                                        Future.delayed(Duration(seconds: 2),
                                            () => controller.connectToVpn());
                                      } else {
                                        controller.connectToVpn();
                                      }
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              backgroundColor: Colors.amber.shade800,
              onPressed: () => _controller.getVpnData(),
              child: Icon(CupertinoIcons.refresh)),
        ),
      ),
    );
  }

  _loadingWidget(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //lottie animation
          LottieBuilder.asset('assets/lottie/loading.json', width: width * .7),
          Text(
            'Loading VPNs... 😌',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _noVPNFound() => Center(
        child: Text(
          'VPNs Not Found Try Again..!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}

class CustomAppBar extends StatelessWidget {
  final String text;
  const CustomAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: CircleAvatar(
            radius: width * 0.06,
            backgroundColor: Colors.black.withOpacity(0.1),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: width * 0.05,
            ),
          ),
        ),
        MyTextPoppines(
          text: text,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.06,
        ),
        InkWell(
          onTap: () => Get.to(() => HomeScreen()),
          child: CircleAvatar(
            radius: width * 0.06,
            backgroundColor: Colors.black.withOpacity(0.1),
            child: Icon(
              Icons.home_max,
              color: Colors.black,
              size: width * 0.05,
            ),
          ),
        ),
      ],
    );
  }
}

class ServerCard extends StatelessWidget {
  final String server;
  final String locations;
  final String img;
  final String ms;
  final VoidCallback onTap;
  const ServerCard(
      {super.key,
      required this.server,
      required this.locations,
      required this.img,
      required this.ms,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height * .09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * .04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
        ),
        //color: Colors.red,
        margin: EdgeInsets.symmetric(
          vertical: height * 0.01,
          horizontal: width * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
          horizontal: width * 0.03,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: width * .07,
                  backgroundColor: Colors.black.withOpacity(0.1),
                  child: CircleAvatar(
                    radius: width * .045,
                    backgroundImage: AssetImage(img),
                  ),
                ),
                SizedBox(width: width * .05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * .47,
                      child: MyTextPoppines(
                        text: server,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.045,
                        maxLines: 1,
                      ),
                    ),
                    MyTextPoppines(
                      text: "$locations locations",
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.025,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  CupertinoIcons.chart_bar_alt_fill,
                  color: Colors.amber.shade800,
                  size: width * .08,
                ),
                MyTextPoppines(
                  text: "$ms ms",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.035,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
