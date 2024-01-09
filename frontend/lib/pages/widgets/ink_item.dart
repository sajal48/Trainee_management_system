import 'package:flutter/material.dart';

class InkItem extends StatefulWidget {
  const InkItem(
      {super.key,
      required this.selectedItemIndex,
      required,
      required this.index,
  required this.icon,
      required this.text,
      required this.selecteedColor,
      required this.disabledColor});
  final int selectedItemIndex;
  final int index;
  final String text;
  final Color selecteedColor;
  final Color disabledColor;
  final IconData icon;

  @override
  State<InkItem> createState() => _InkItemState();
}

class _InkItemState extends State<InkItem> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: widget.selectedItemIndex == widget.index
            ? widget.selecteedColor
            : widget.disabledColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 228,
        height: 46,
        child: Row(
          children: [
            const SizedBox(width: 25,),
            Icon(widget.icon,color: widget.selectedItemIndex == widget.index
                ? Colors.deepPurple
                : Colors.black,),
            const SizedBox(width: 10,),
            Text(widget.text,style: TextStyle(color:widget.selectedItemIndex == widget.index
                ? Colors.deepPurple
                : Colors.black, ),),
          ],
        ),
      ),
    );
  }
}
