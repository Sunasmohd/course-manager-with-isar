import 'dart:io';

import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String image;
  final String name;
  final bool isSingle;

  const CourseCard({
    super.key,
    required this.image,
    required this.name,
    this.isSingle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSingle ? 15.0 : 0,
        right: isSingle ? 15.0 : 15.0,
        bottom: 5,
      ),
      child: SizedBox(
        width: 150,
        child: Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          elevation: 1,
          color: const Color.fromARGB(255, 250, 250, 250),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image(
                  image: FileImage(File(image)),
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
