import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'color-picker.dart';

class DrawArea extends StatefulWidget {
  const DrawArea({Key key}) : super(key: key);

  @override
  _DrawArea createState() => _DrawArea();
}

class _DrawArea extends State<DrawArea> {

  List<Offset> _points = <Offset>[];
  List<double> brushSizes = [5.0, 10.0, 15.0, 20.0, 25.0];
  double brushSize = 10.0;
  Color brushColor = Colors.black;
  List<CanvasPainter> brushList = [];

  void trackPath(DragUpdateDetails details) {
    setState(() {
      RenderBox box = context.findRenderObject();
      Offset localPosition = box.globalToLocal(details.globalPosition);
      _points = List.from(_points)..add(localPosition);
    });
  }

  setColor(Color color) {
    setState(() {
      List<Offset> oldPoints = List.from(_points);
      brushList.add(CanvasPainter(points: oldPoints, brushSize: brushSize, brushColor: brushColor));
      brushColor = color;
      _points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 420,
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.black))),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: LayoutBuilder (
                        builder: (context, constraints) {
                          return Container (
                              alignment: Alignment.center,
                              child: MenuButton(
                                child: Container (
                                  width: constraints.widthConstraints().maxWidth,
                                  height: constraints.heightConstraints().maxHeight,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.brush,
                                    size: 30,
                                  ),
                                ),//
                                scrollPhysics: AlwaysScrollableScrollPhysics(),
                                topDivider: true,// Widget displayed as the button
                                items: brushSizes,// List of your items
                                itemBuilder: (value) => Container(
                                    width: constraints.heightConstraints().maxWidth,
                                    height: constraints.heightConstraints().maxHeight,
                                    color: brushSize == value ? Colors.grey[300] : Colors.white,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.circle,
                                      size: value,
                                    ),
                                ),// Widget dis
                                divider: Container(
                                  height: 0,
                                  color: Colors.grey,
                                ),// played for each item
                                toggledChild: Container(
                                  color: Colors.white,
                                  child: Container (
                                    width: constraints.widthConstraints().maxWidth,
                                    height: constraints.heightConstraints().maxHeight,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.brush,
                                      size: 30,
                                    ),
                                  ),// Widget displayed as the button,
                                ),
                                onItemSelected: (value) {
                                  setState(() {
                                    List<Offset> oldPoints = List.from(_points);
                                    brushList.add(CanvasPainter(points: oldPoints, brushSize: brushSize, brushColor: brushColor));
                                    brushSize = value;
                                    _points.clear();
                                  });
                                  // Action when new item is selected
                                },
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                    color: Colors.white
                                ),
                                onMenuButtonToggle: (isToggle) {

                                },
                              )
                          );
                        },
                      )
                  ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 2.0, color: Colors.black),
                            left: BorderSide(width: 2.0, color: Colors.black))),
                    child: IconButton(
                      icon: Icon(
                        Icons.color_lens,
                        size: 30,
                        color: brushColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ColorPicker(context, setColor);
                            }
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.format_color_fill,
                        size: 30,
                      ),
                      onPressed: null,
                    ),
                  ))
                ],
              )
            ),
          ),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                body: Container(
                  width: constraints.widthConstraints().maxWidth,
                  height: constraints.heightConstraints().maxHeight,
                  child: GestureDetector(
                      onPanUpdate: trackPath,
                      onPanEnd: (DragEndDetails details) => _points.add(null),
                      child: ClipRect(
                          child: CustomPaint(
                            painter: CanvasPainter(points: _points, brushSize: brushSize,brushColor: brushColor, brushList: brushList),
                          )
                      )
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _points.clear();
                      brushList.clear();
                    });
                  },
                  child: Icon(Icons.delete_sweep),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  List<Offset> points;
  double brushSize;
  Color brushColor;
  List<CanvasPainter> brushList;

  CanvasPainter({this.points, this.brushSize,this.brushColor, this.brushList = const[]});

  @override
  void paint(Canvas canvas, Size size) {

    for (CanvasPainter painter in brushList) {
      painter.paint(canvas, size);
    }

    Paint brush = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], brush);
      }
    }

  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => oldDelegate.points != points;
}
