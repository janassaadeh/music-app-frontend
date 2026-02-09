import 'package:flutter/material.dart';

class AlbumCover extends StatelessWidget {
  final String albumCover;
  final double albumCoverSize;

  const AlbumCover({
    required this.albumCover,
    required this.albumCoverSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        width: albumCoverSize,
        height: albumCoverSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(albumCover, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
