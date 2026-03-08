import 'package:flutter/material.dart';

class DebouncedInkWell extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const DebouncedInkWell({super.key, required this.child, required this.onTap});

  @override
  _DebouncedInkWellState createState() => _DebouncedInkWellState();
}

class _DebouncedInkWellState extends State<DebouncedInkWell> {
  bool _canTap = true;

  void _handleTap() {
    if (!_canTap) return;

    setState(() => _canTap = false);
    widget.onTap();

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) setState(() => _canTap = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      child: widget.child,
    );
  }
}