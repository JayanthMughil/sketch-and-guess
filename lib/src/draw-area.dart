import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'color-picker.dart';
import 'brush-size-menu.dart';
import 'package:my_app/globals.dart' as globals;

class DrawArea extends StatefulWidget {
  const DrawArea({Key key}) : super(key: key);

  @override
  _DrawArea createState() => _DrawArea();
}

class _DrawArea extends State<DrawArea> {
  final docRef = FirebaseFirestore.instance.collection('rooms').doc(globals.roomcode);
  DocumentReference currentPaintBrush;
  List<Offset> _points = <Offset>[];
  double brushSize = 10.0;
  Color brushColor = Colors.black;
  Color fillColor = Colors.black;
  List<CanvasPainter> brushList = [];
  bool isFill = false;
  StreamSubscription<DocumentSnapshot> streamListening;
  BuildContext drawBoxContext;

  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    currentPaintBrush = docRef.collection('paintBrushes').doc();
    currentPaintBrush.set({'points': [], 'brushColor': brushColor.value, 'brushSize': brushSize});
    super.initState();
  }

  void trackPath(DragUpdateDetails details) {
      RenderBox box = drawBoxContext.findRenderObject();
      Offset localPosition = box.globalToLocal(details.globalPosition);
      setState(() {
        _points = List.from(_points)..add(localPosition);
      });
      currentPaintBrush.update({'points': FieldValue.arrayUnion([{'x': localPosition.dx, 'y': localPosition.dy}])});
  }

  addToBrushList(DragEndDetails details) {
      setState(() {
        _points.add(null);
        List<Offset> oldPoints = List.from(_points);
        currentPaintBrush.update({'points': FieldValue.arrayUnion([{'x': null, 'y': null}])}).then((value) => {
          currentPaintBrush = docRef.collection('paintBrushes').doc(),
          currentPaintBrush.set({'points': [], 'brushColor': brushColor.value, 'brushSize': brushSize})
        });
        brushList.add(CanvasPainter(
            points: oldPoints, brushSize: brushSize, brushColor: brushColor));
        _points.clear();
      });
  }

  checkAndFillColor () {
    if (isFill) {
      setState(() {
        isFill = false;
        fillColor = Colors.black;
      });
    }
  }

  setColor(Color color) {
    currentPaintBrush.update({'brushColor': color.value}).then((value) => {
      setState(() {
        brushColor = color;
      })
    });
  }

  setFillColor(Color color) {
    setState(() {
      fillColor = color;
      isFill = true;
    });
  }

  setSize(double size) {
    currentPaintBrush.update({'brushSize': size}).then((value) => {
      setState(() {
        brushSize = size;
      })
    });
  }

  unFocusTextField () {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 2,child: Container(
      margin: EdgeInsets.all(10.0),
      constraints: BoxConstraints(minHeight: 350),
      height: 380,
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
                Expanded(child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                        alignment: Alignment.center,
                        child: SizeMenu(constraints, brushSize, setSize));
                  },
                )),
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
                      unFocusTextField();
                      showDialog(
                          context: context,
                          builder: (_) {
                            return ColorPicker(context, setColor);
                          });
                    },
                  ),
                ),
                Expanded(
                    child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.format_color_fill,
                      size: 30,
                      color: fillColor
                    ),
                    onPressed: () {
                      unFocusTextField();
                      showDialog(
                          context: context,
                          builder: (_) {
                            return ColorPicker(context, setFillColor);
                          });
                    },
                  ),
                ))
              ],
            )),
          ),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              drawBoxContext = context;
              return Scaffold(
                body: SingleChildScrollView(child: Container(
                  width: constraints.widthConstraints().maxWidth,
                  height: constraints.heightConstraints().maxHeight,
                  child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        checkAndFillColor();
                      },
                      onPanUpdate: trackPath,
                      onPanEnd: addToBrushList,
                      child: ClipRect(
                          child: CustomPaint(
                        painter: CanvasPainter(
                            points: _points,
                            brushSize: brushSize,
                            brushColor: brushColor,
                            brushList: brushList),
                      ))),
                )),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    unFocusTextField();
                      setState(() {
                        _points = [];
                        brushList = [];
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
    ));
  }
}

class CanvasPainter extends CustomPainter {
  List<Offset> points;
  double brushSize;
  Color brushColor;
  List<CanvasPainter> brushList;

  CanvasPainter(
      {this.points,
      this.brushSize,
      this.brushColor,
      this.brushList = const []});

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
