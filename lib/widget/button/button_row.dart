import 'package:flutter/material.dart';
import 'package:herbani/helper/textstyle_custom.dart';

class ButtonRow extends StatelessWidget {
  final String textBtn;
  final double widthBtn, heightBtn;
  final Color orangeColor1, orangeColor2;
  const ButtonRow(
      {Key? key,
      required this.textBtn,
      required this.orangeColor1,
      required this.orangeColor2,
      required this.widthBtn,
      required this.heightBtn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5),
      child: Container(
          height: heightBtn,
          width: widthBtn,
          padding: const EdgeInsets.symmetric(vertical: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 2),
                    blurRadius: 1,
                    spreadRadius: 1)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [orangeColor1, orangeColor2])),
          child: Text(textBtn.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyleButtonRow(context))),
    );
  }
}
