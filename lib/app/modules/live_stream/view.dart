import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poly_live/common/api/live_api.dart';
import 'package:poly_live/common/models/live_room.dart';
import 'package:poly_live/common/models/live_stream.dart';
import 'package:poly_live/common/widgets/empty_view.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key, required this.roomInfo}) : super(key: key);
  final RoomInfo roomInfo;

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<LiveStream> _listStream = [];
          if (snapshot.data is Map<String, Map<String, String>>) {
            snapshot.data.forEach((key, value) {
              value.forEach((codec, url) {
                _listStream.add(LiveStream(rate: key, codec: codec, url: url));
              });
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('live_stream'.tr),
            ),
            body: _listStream.isNotEmpty
                ? ListView.builder(
                    itemCount: _listStream.length,
                    itemBuilder: (context, index) {
                      return StreamCard(
                        rate: _listStream[index].rate,
                        codec: _listStream[index].codec,
                        url: _listStream[index].url,
                      );
                    },
                  )
                : EmptyView(
                    icon: Icons.live_tv_rounded,
                    title: 'empty_search_title'.tr,
                    subtitle: 'empty_search_subtitle'.tr,
                  ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('live_stream'.tr),
            ),
            body: Center(
              child: Text('no_live_stream'.tr),
            ),
          );
        }
      },
      future: _getLiveStreamUrl(),
    );
  }

  Future<dynamic> _getLiveStreamUrl() async {
    return await LiveApi.getLiveStreamUrl(widget.roomInfo);
  }
}

class StreamCard extends StatelessWidget {
  const StreamCard(
      {Key? key, required this.rate, required this.codec, required this.url})
      : super(key: key);

  // 画质
  final String rate;
  final String codec;

  // Url
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          rate,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          codec,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        onTap: () {
          // 调用剪切板
          Clipboard.setData(ClipboardData(text: url));
          Get.snackbar('copied'.tr, url);
        },
      ),
    );
  }
}
