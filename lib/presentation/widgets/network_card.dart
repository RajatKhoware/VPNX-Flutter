import 'package:flutter/material.dart';

import '../../data/models/network_data.dart';

class NetworkCard extends StatelessWidget {
  final NetworkData data;

  const NetworkCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: height * .01),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: Icon(
            data.icon.icon,
            color: data.icon.color,
            size: data.icon.size ?? 28,
          ),
          title: Text(data.title),
          subtitle: Text(data.subtitle),
        ));
  }
}
