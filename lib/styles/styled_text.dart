import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget StyledText(text) => Text(
    text,
    style: TextStyle(
        color: Colors.grey[300],
        letterSpacing: 1.0)
    );