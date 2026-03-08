import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class GridVideoThumbnail extends StatefulWidget {
  final String filePath;
  @override
  final Key key;

  const GridVideoThumbnail({required this.filePath, required this.key}) : super(key: key);

  @override
  _GridVideoThumbnailState createState() => _GridVideoThumbnailState();
}

class _GridVideoThumbnailState extends State<GridVideoThumbnail> {
  Future<Uint8List?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = _getThumbnail();
  }

  Future<Uint8List?> _getThumbnail() async {
    String path = widget.filePath;

    // If it's a network file, download it to temp directory
    if (path.startsWith("http://") || path.startsWith("https://")) {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

      final response = await http.get(Uri.parse(path));
      final file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);
      path = file.path;
    }

    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              ),
              Center(child: Icon(Icons.play_circle_fill, size: 32, color: Colors.white)),
            ],
          );
        } else {
          return Container(
            color: Colors.black12,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
