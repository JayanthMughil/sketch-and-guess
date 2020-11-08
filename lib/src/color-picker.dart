import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {

  final BuildContext context;
  final setColor;

  ColorPicker(this.context, this.setColor);

  List<Widget> colorPalette () {
    List<Widget> list = [];
    List<Color> colorList = List.from(Colors.accents)..add(Colors.black);
    for (Color color in colorList) {
      list.add(
        InkWell(
          onTap: () {
            setColor(color);
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 2.0), //(x,y)
                    blurRadius: 3.0,
                  )
                ]
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
       child: SimpleDialog(
        title: Text("Color Picker"),
        titlePadding: EdgeInsets.only(left: 93, top: 20),
        elevation: 7,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colorPalette()
            )
          )
        ],
      )
    );
  }

}