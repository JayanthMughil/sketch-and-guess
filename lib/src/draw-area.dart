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
  List<Offset> _points = <Offset>[];
  double brushSize = 10.0;
  Color brushColor = Colors.black;
  Color fillColor = Colors.black;
  List<CanvasPainter> brushList = [];
  bool isFill = false;
  StreamSubscription<DocumentSnapshot> streamListening;
  BuildContext drawBoxContext;

  @override
  void initState() {
    /*streamListening = docRef.snapshots().listen((event) {
      var brushListLength = event.get('paintBrushes').length;
      if (brushListLength > 0) {
        setState(() {
          brushList.add(event.get('paintBrushes')[brushListLength - 1]);
        });
      }
    });*/
    docRef.get().then((docs) => {
      setState(() {
        var brushes = docs.get('paintBrushes');
        for (dynamic brush in brushes) {
          List<Offset> pts = [];
          for (dynamic point in brush['points']) {
            if (point['x'] != null && point['y'] != null) {
              pts.add(Offset(point['x'], point['y']));
            } else {
              pts.add(null);
            }
          }
          brushList.add(CanvasPainter(
              points: pts, brushSize: brush['brushSize'], brushColor: Color(brush['brushColor'])));
        }
      })
    });
    super.initState();
  }

  void trackPath(DragUpdateDetails details) {
    setState(() {
      RenderBox box = drawBoxContext.findRenderObject();
      Offset localPosition = box.globalToLocal(details.globalPosition);
      _points = List.from(_points)..add(localPosition);
    });
  }

  addToBrushList(DragEndDetails details) {
    setState(() {
      _points.add(null);
      List<Offset> oldPoints = List.from(_points);
      List<dynamic> pointsFirestore = [];
      for (Offset point in oldPoints) {
        if (point != null) {
          pointsFirestore.add({'x': point.dx, 'y': point.dy});
        } else {
          pointsFirestore.add({'x': null, 'y': null});
        }
      }
      docRef.update({'paintBrushes': FieldValue.arrayUnion([
        {'points': pointsFirestore, 'brushSize': brushSize, 'brushColor': brushColor.value}
      ])}).catchError((onError) => {
         print(onError.toString())
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
    setState(() {
      //List<Offset> oldPoints = List.from(_points);
      //brushList.add(CanvasPainter(
      //    points: oldPoints, brushSize: brushSize, brushColor: brushColor));
      brushColor = color;
      //_points.clear();
    });
  }

  setFillColor(Color color) {
    setState(() {
      //List<Offset> oldPoints = List.from(_points);
      //brushList.add(CanvasPainter(
      //    points: oldPoints, brushSize: brushSize, brushColor: brushColor));
      fillColor = color;
      isFill = true;
      //_points.clear();
    });
  }

  setSize(double size) {
    setState(() {
      //List<Offset> oldPoints = List.from(_points);
      //brushList.add(CanvasPainter(
      //    points: oldPoints, brushSize: brushSize, brushColor: brushColor));
      brushSize = size;
      //_points.clear();
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
                      docRef.update({'paintBrushes': []}).then((value) => {
                        setState(() {
                          _points = [];
                          brushList = [];
                        })
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

    print(points.length != 0 ? points[0] : "");

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], brush);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => oldDelegate.points != points;
}
