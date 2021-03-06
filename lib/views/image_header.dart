import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loading_widget.dart';

class CircularCachedNetworkImage extends StatelessWidget {
  final String url;
  final double size;

  const CircularCachedNetworkImage(
      {Key? key, required this.url, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == '') {
      return Icon(Icons.no_photography, size: size);
    }
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => const LoadingWidget(),
      errorWidget: (context, url, error) =>
          Icon(Icons.no_photography, size: size),
    );
  }
}

class ImageHeader extends StatelessWidget {
  final String bannerUrl;
  final String pictureUrl;
  final String title;
  const ImageHeader(
      {Key? key,
      required this.bannerUrl,
      required this.pictureUrl,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bannerWidget = Container();

    if (bannerUrl != "") {
      bannerWidget = CachedNetworkImage(
        imageUrl: bannerUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const LoadingWidget(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return Wrap(children: [
      Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          SizedBox(height: 80, child: bannerWidget),
          Positioned(
              top: 30,
              left: 20,
              child: Row(children: [
                CircularCachedNetworkImage(url: pictureUrl, size: 100),
              ])),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 10, bottom: 20, left: 100),
              child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center))
        ],
      )
    ]);
  }
}
