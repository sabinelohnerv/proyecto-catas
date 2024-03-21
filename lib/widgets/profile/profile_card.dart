import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.img,
    required this.title,
    required this.color,
    this.destinationScreen,
    this.isClickable = true,
  });

  final String img;
  final String title;
  final Color color;
  final Widget? destinationScreen;
  final bool isClickable;

  @override
  State<StatefulWidget> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool _isTapped = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.isClickable) {
      setState(() => _isTapped = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isClickable && widget.destinationScreen != null) {
      setState(() => _isTapped = false);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => widget.destinationScreen!));
    }
  }

  void _handleTapCancel() {
    if (widget.isClickable) {
      setState(() => _isTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: _isTapped
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100), // Más claro
                        Theme.of(context)
                            .colorScheme
                            .primary, // Color primario normal
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .background, // Fondo normal
                        Theme.of(context)
                            .colorScheme
                            .background, // Fondo normal
                      ],
                    ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/${widget.img}.png')),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 16,
                        color: _isTapped ? widget.color : Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
