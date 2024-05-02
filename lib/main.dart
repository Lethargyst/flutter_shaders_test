import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _initShader(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ShaderWidget(shader: snapshot.data!.fragmentShader());
        } 
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset('shaders/shader.glsl');
  }
}

class ShaderWidget extends StatefulWidget {
  final FragmentShader shader;

  const ShaderWidget({ required this.shader, super.key });

  @override
  _ShaderWidgetState createState() => _ShaderWidgetState();
}

class _ShaderWidgetState extends State<ShaderWidget> {
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(milliseconds: 100), 
      (timer) { 
        _time += 0.001;
        setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.shader
      ..setFloat(0, _time)
      ..setFloat(1, MediaQuery.of(context).size.width)
      ..setFloat(2, MediaQuery.of(context).size.height);

    return CustomPaint(painter: _ShaderPainter(widget.shader));
  }
}

class _ShaderPainter extends CustomPainter {
  final FragmentShader shader;

  _ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}