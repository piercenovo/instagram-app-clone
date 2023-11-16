import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/core/utils/strings/image_strings.dart';
import 'package:shimmer/shimmer.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == '') {
      return Image.asset(
        tProfileDefaultImage,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              color: Colors.grey[400],
            ),
          );
        },
        errorWidget: (context, url, error) => Image.asset(
          tProfileDefaultImage,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      );
    }
  } else {
    return Image.file(
      image,
      fit: BoxFit.cover,
    );
  }
}
