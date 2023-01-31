import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_live/app/modules/live_stream/index.dart';
import 'package:poly_live/common/utils/text_util.dart';

import '../models/live_room.dart';

/// 房间卡片
class RoomCard extends StatelessWidget {
  const RoomCard(
      {Key? key, required this.room, this.onLongPress, this.dense = false})
      : super(key: key);
  final RoomInfo room;
  final Function()? onLongPress;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onLongPress: onLongPress,
        onTap: () => onTap(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: room.liveStatus.name == 'live'
                        ? CachedNetworkImage(
                            imageUrl: room.cover,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.tv_off_rounded,
                                  size: dense ? 38 : 48,
                                ),
                                Text(
                                  'off_line'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                if (room.liveStatus == LiveStatus.live &&
                    room.watching.isNotEmpty)
                  Positioned(
                    right: dense ? 1 : 4,
                    bottom: dense ? 1 : 4,
                    child: CountChip(
                      icon: Icons.whatshot_rounded,
                      count: readableCount(room.watching),
                      dense: dense,
                    ),
                  )
              ],
            ),
            ListTile(
              dense: dense,
              minLeadingWidth: dense ? 34 : null,
              contentPadding:
                  dense ? const EdgeInsets.only(left: 8, right: 10) : null,
              horizontalTitleGap: dense ? 8 : null,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).cardColor,
                foregroundImage: room.avatar.isNotEmpty
                    ? CachedNetworkImageProvider(room.avatar)
                    : null,
                radius: dense ? 17 : null,
              ),
              title: Text(
                room.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                room.nick,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              trailing: dense
                  ? null
                  : Text(
                      room.platform.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  onTap(BuildContext context) {
    // // 跳转到LiveStreamPage
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LiveStreamPage(
        roomInfo: room,
      ),
    ));
  }
}

class CountChip extends StatelessWidget {
  const CountChip(
      {Key? key, required this.icon, required this.count, this.dense = false})
      : super(key: key);
  final IconData icon;
  final String count;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: Colors.black.withOpacity(0.4),
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(dense ? 4 : 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: dense ? 13 : 16,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              count,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: dense ? 10 : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
