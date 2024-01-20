import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/config/helpers/my_text.dart';
import 'package:vpn_basic_project/presentation/screens/servers_screen.dart';

import '../../domain/controllers/home_controller.dart';
import '../../data/models/vpn_status.dart';
import 'network_test_screen.dart';
import '../../domain/services/vpn_engine.dart';
import '../widgets/count_down_timer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: height * 0.84,
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: width * 0.1,
                      horizontal: width * 0.05,
                    ),
                    height: height * 0.8,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.12),
                      border: Border.all(
                        color: Colors.white,
                        width: width * 0.01,
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 1, 30, 54),
                            Color.fromARGB(255, 1, 58, 105),
                            Color.fromARGB(255, 1, 30, 54),
                          ]),
                    ),
                    child: Column(
                      children: [
                        // App Bar
                        _buildAppBar(width),
                        SizedBox(height: height * 0.06),
                        MyTextPoppines(
                          text: _controller.vpnState.value ==
                                  VpnEngine.vpnDisconnected
                              ? 'Not Connected'
                              : _controller.vpnState
                                  .replaceAll('_', ' ')
                                  .toUpperCase(),
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.045,
                        ),
                        SizedBox(height: height * 0.005),
                        CountDownTimer(
                            startTimer: _controller.vpnState.value ==
                                VpnEngine.vpnConnected),
                        SizedBox(height: height * 0.04),
                        _buildAnimatedContainer(context),
                        SizedBox(height: height * .05),
                        StreamBuilder<VpnStatus?>(
                            initialData: VpnStatus(),
                            stream: VpnEngine.vpnStatusSnapshot(),
                            builder: (context, snapshot) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _builUploadSpeed(
                                      context,
                                      '${snapshot.data?.byteIn ?? '0 kbps'}',
                                      false),
                                  MyTextPoppines(
                                    text: "/",
                                    color: Colors.white.withOpacity(0.4),
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 0.05,
                                  ),
                                  _builUploadSpeed(
                                      context,
                                      '${snapshot.data?.byteOut ?? '0 kbps'}',
                                      true),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: width * 0.3,
                  bottom: height * 0.01,
                  child: _buildContactButton(height, width),
                )
              ],
            ),
            _buildSelectCountry(context),
          ],
        ),
      ),
    );
  }

  Row _buildAppBar(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: width * 0.07,
          backgroundColor: Color.fromARGB(166, 1, 30, 54),
          child: Icon(
            Icons.home_max,
            color: Colors.white,
            size: width * 0.07,
          ),
        ),
        MyTextPoppines(
          text: "VPN",
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.06,
        ),
        CircleAvatar(
          radius: width * 0.07,
          backgroundColor: Color.fromARGB(166, 1, 30, 54),
          child: InkWell(
            onTap: () => Get.to(() => NetworkTestScreen()),
            child: Icon(
              Icons.info_outlined,
              color: Colors.white,
              size: width * 0.07,
            ),
          ),
        ),
      ],
    );
  }

  Container _buildAnimatedContainer(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (MediaQuery.sizeOf(context).height < 650) {
      width = width * 0.7;
    }
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.amber.withOpacity(0.7),
          spreadRadius: width * .04,
          blurRadius: width * 0.6,
        ),
      ]),
      child: CircleAvatar(
        radius: width * .28,
        backgroundColor: Colors.amber.shade700,
        child: CircleAvatar(
          radius: width * .223,
          backgroundColor: Colors.amber.shade200,
          child: CircleAvatar(
            radius: width * .16,
            backgroundColor: Colors.white,
            child: LottieBuilder.asset(
              'assets/lottie/vpn.json',
              width: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _builUploadSpeed(BuildContext context, String text, bool isUplaod) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        CircleAvatar(
          radius: width * 0.05,
          backgroundColor: Color.fromARGB(138, 6, 29, 48),
          child: Icon(
            isUplaod
                ? Icons.file_upload_outlined
                : Icons.file_download_outlined,
            size: width * .05,
            color: isUplaod ? Colors.amber.shade600 : Colors.blue,
          ),
        ),
        SizedBox(height: height * 0.01),
        Row(
          children: [
            MyTextPoppines(
              text: text.replaceFirst("↓", ""),
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.045,
            ),
          ],
        ),
        MyTextPoppines(
          text: isUplaod ? "Upload Speed" : "Download Speed",
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.w600,
          fontSize: width * 0.027,
        ),
      ],
    );
  }

  Widget _buildContactButton(double height, double width) {
    return InkWell(
      onTap: () => _controller.connectToVpn(),
      child: Container(
        height: height * 0.07,
        width: width * 0.45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: width * 0.005),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber.shade300,
                Colors.amber.shade800,
                Colors.amber.shade900,
              ]),
          borderRadius: BorderRadius.circular(width * 0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade900.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 40,
            ),
          ],
        ),
        child: Center(
          child: MyTextPoppines(
            text: _controller.getButtonText,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectCountry(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      margin: EdgeInsets.only(top: height * .01),
      width: width * .85,
      height: height * .075,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.054),
        borderRadius: BorderRadius.circular(width * 0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: width * 0.03),
              CircleAvatar(
                radius: width * 0.06,
                backgroundImage: _controller.vpn.value.countryLong.isEmpty
                    ? NetworkImage(
                        "https://i.pinimg.com/736x/57/f4/24/57f424b9bce7ecdc264955cf2afa64cd.jpg",
                      ) as ImageProvider
                    : AssetImage(
                        'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
              ),
              SizedBox(width: width * 0.03),
              MyTextPoppines(
                text: _controller.vpn.value.hostname.isNotEmpty
                    ? _controller.vpn.value.countryLong
                    : "Select Country",
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: width * 0.04,
              ),
            ],
          ),
          InkWell(
            onTap: () => Get.to(() => ServerScreen()),
            child: Container(
              margin: EdgeInsets.only(right: width * 0.02),
              width: width * .09,
              height: height * .2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.amber.shade300,
                      Colors.amber.shade800,
                      Colors.amber.shade900,
                    ]),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                size: width * .04,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
