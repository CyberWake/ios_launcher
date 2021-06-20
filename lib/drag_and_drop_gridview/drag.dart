import 'package:flutter/material.dart';

class DragItem extends StatefulWidget {
  const DragItem({
    this.isDraggable = true,
    this.isDroppable = true,
    /*required*/ required this.child,
  });
  final bool isDraggable;
  final bool isDroppable;
  final Widget child;

  @override
  _DragItemState createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      child: widget.child,
    );
  }
}
