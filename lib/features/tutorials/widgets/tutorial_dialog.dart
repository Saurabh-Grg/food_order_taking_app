import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

enum DialogAlignment {
  center,
  topCenter,
  bottomCenter,
}

class TutorialDialog extends StatelessWidget {
  final String content;
  final bool showSkip;
  final bool showNext;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final DialogAlignment alignment;
  final Offset? pointerOffset;

  const TutorialDialog({
    super.key,
    required this.content,
    this.showSkip = true,
    this.showNext = true,
    this.onNext,
    this.onSkip,
    this.alignment = DialogAlignment.center,
    this.pointerOffset,
  });

  @override
  Widget build(BuildContext context) {
    print('TutorialDialog: Building dialog with content: $content');
    Widget dialogContent = Container(
      width: Get.width * 0.8,
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.8,
        minWidth: 200,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.end,
            children: [
              if (showSkip)
                TextButton(
                  onPressed: onSkip,
                  child: Text('Skip'),
                ),
              if (showNext)
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (pointerOffset != null)
            CustomPaint(
              painter: ArrowPainter(
                start: Offset(Get.width / 6, Get.height / 2 - 108),
                end: pointerOffset!,
                color: Colors.black,
              ),
              size: Size(Get.width, Get.height),
            ),
          Center(
            child: Container(
              margin: EdgeInsets.all(24),
              child: dialogContent,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final double arrowSize;

  ArrowPainter({
    required this.start,
    required this.end,
    required this.color,
    this.arrowSize = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    double angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    paint.style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * math.cos(angle - math.pi / 6),
        end.dy - arrowSize * math.sin(angle - math.pi / 6),
      )
      ..lineTo(
        end.dx - arrowSize * math.cos(angle + math.pi / 6),
        end.dy - arrowSize * math.sin(angle + math.pi / 6),
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TutorialHighlight extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final bool showBorder;

  const TutorialHighlight({
    super.key,
    required this.width,
    required this.height,
    this.child,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: showBorder
            ? Border.all(
          color: Colors.black,
          width: 2,
        )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}