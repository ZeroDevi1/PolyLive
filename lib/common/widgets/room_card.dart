import 'package:flutter/material.dart';

import '../models/liveroom.dart';

/// 房间卡片
class RoomCard extends StatelessWidget {
  const RoomCard({Key? key, required this.room, this.onLongPress, required this.dense}) : super(key: key);
  final RoomInfo room;
  final Function()? onLongPress;
  final bool dense;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
