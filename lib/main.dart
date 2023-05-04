import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image XOR'),
        ),
        body: Center(
          child: FutureBuilder<List<img.Image>>(
            future: getImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final image1 = snapshot.data![0];
                final image2 = snapshot.data![1];
                final result = img.Image(image1.width, image1.height,
                    channels: img.Channels.rgba);

                for (int y = 0; y < image1.height; y++) {
                  for (int x = 0; x < image1.width; x++) {
                    final color1 = image1.getPixel(x, y);
                    final color2 = image2.getPixel(x, y);
                    final xor = color1 ^ color2;
                    result.setPixelRgba(x, y, xor, xor, xor, 255);
                  }
                }

                final bytes = img.encodePng(result);
                return Image.memory(Uint8List.fromList(bytes));
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<img.Image>> getImages() async {
    final data1 = await rootBundle.load('assets/image4.png');
    final bytes1 = data1.buffer.asUint8List();
    final image1 = img.decodeImage(bytes1)!;

    final data2 = await rootBundle.load('assets/image_c.png');
    final bytes2 = data2.buffer.asUint8List();
    final image2 = img.decodeImage(bytes2)!;

    return [image1, image2];
  }
}
