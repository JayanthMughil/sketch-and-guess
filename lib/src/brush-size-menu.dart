import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';

class SizeMenu extends StatelessWidget {
  final constraints;
  final double brushSize;
  final setSize;
  final List<double> brushSizes = [5.0, 10.0, 15.0, 20.0, 25.0];

  SizeMenu(this.constraints, this.brushSize, this.setSize);

  @override
  Widget build(Object context) {
    return MenuButton(
      child: Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        alignment: Alignment.center,
        child: Icon(
          Icons.brush,
          size: 30,
        ),
      ), //
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      topDivider: true, // Widget displayed as the button
      items: brushSizes, // List of your items
      itemBuilder: (value) => Container(
        width: constraints.heightConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: brushSize == value ? Colors.grey[300] : Colors.white,
        alignment: Alignment.center,
        child: Icon(
          Icons.circle,
          size: value,
        ),
      ), // Widget dis
      divider: Container(
        height: 0,
        color: Colors.grey,
      ), // played for each item
      toggledChild: Container(
        color: Colors.white,
        child: Container(
          width: constraints.widthConstraints().maxWidth,
          height: constraints.heightConstraints().maxHeight,
          alignment: Alignment.center,
          child: Icon(
            Icons.brush,
            size: 30,
          ),
        ), // Widget displayed as the button,
      ),
      onItemSelected: setSize,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white),
      onMenuButtonToggle: (isToggle) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
      },
    );
  }
}
