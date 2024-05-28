import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatefulWidget {
  final GoException error;

  const NotFoundPage({super.key, required this.error});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(widget.error.toString()),
            ),
            GestureDetector(
                onTap: () {
                  context.go("/home");
                },
                child: const Text("Return home"))
          ],
        ),
      ),
    );
  }
}
