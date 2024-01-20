import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/presentation/screens/servers_screen.dart';

import '../../data/remoteData/apis.dart';
import '../../main.dart';
import '../../data/models/ip_details.dart';
import '../../data/models/network_data.dart';
import '../widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      //refresh button

      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: CustomAppBar(text: "Info"),
              ),
              SizedBox(
                height: height * 0.8,
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        left: width * .04,
                        right: width * .04,
                        top: height * .01,
                        bottom: height * .1),
                    children: [
                      //ip
                      NetworkCard(
                          data: NetworkData(
                              title: 'IP Address',
                              subtitle: ipData.value.query,
                              icon: Icon(CupertinoIcons.location_solid,
                                  color: Colors.blue))),

                      //isp
                      NetworkCard(
                          data: NetworkData(
                              title: 'Internet Provider',
                              subtitle: ipData.value.isp,
                              icon:
                                  Icon(Icons.business, color: Colors.orange))),

                      //location
                      NetworkCard(
                          data: NetworkData(
                              title: 'Location',
                              subtitle: ipData.value.country.isEmpty
                                  ? 'Fetching ...'
                                  : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                              icon: Icon(CupertinoIcons.location,
                                  color: Colors.pink))),

                      //pin code
                      NetworkCard(
                          data: NetworkData(
                              title: 'Pin-code',
                              subtitle: ipData.value.zip,
                              icon: Icon(CupertinoIcons.location_solid,
                                  color: Colors.cyan))),

                      //timezone
                      NetworkCard(
                          data: NetworkData(
                              title: 'Timezone',
                              subtitle: ipData.value.timezone,
                              icon: Icon(CupertinoIcons.time,
                                  color: Colors.green))),
                    ]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
            backgroundColor: Colors.amber.shade800,
            onPressed: () {
              ipData.value = IPDetails.fromJson({});
              APIs.getIPDetails(ipData: ipData);
            },
            child: Icon(CupertinoIcons.refresh)),
      ),
    );
  }
}
