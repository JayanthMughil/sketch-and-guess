import 'package:flutter/material.dart';

class DrawArea extends StatefulWidget {

  const DrawArea({Key key}): super(key: key);

  @override
  _DrawArea createState() => _DrawArea();

}

class _DrawArea extends State<DrawArea> {

  List<Offset> _points = <Offset>[];

  void trackPath(DragUpdateDetails details) {
    setState(() {
      RenderBox box = context.findRenderObject();
      Offset localPosition = box.globalToLocal(details.globalPosition);
      _points = List.from(_points)..add(localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          margin: EdgeInsets.all(10.0),
          height: 370,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Column(
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.black)
                  )
                ),
                child: Row(
                  children: [],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.widthConstraints().maxWidth,
                      height: constraints.heightConstraints().maxHeight,
                      child: GestureDetector(
                          onPanUpdate: trackPath,
                          onPanEnd: (DragEndDetails details) => _points.add(null) ,
                          child: ClipRect(
                            child: CustomPaint(
                              painter: CanvasPainter(_points),
                            )
                          )
                      ),
                    );
                  },
                )
              )
            ],
          ),
        );
  }
}

class CanvasPainter extends CustomPainter {

  List<Offset> points;

  CanvasPainter(this.points);

  Paint brush = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length-1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], brush);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => oldDelegate.points != points;

}
