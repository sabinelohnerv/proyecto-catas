import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  final PageController controller;
  final int itemCount;

  const PageIndicator({
    Key? key,
    required this.controller,
    required this.itemCount,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updatePage);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePage);
    super.dispose();
  }

  void _updatePage() {
    if (widget.controller.page!.round() != _currentPage) {
      setState(() {
        _currentPage = widget.controller.page!.round();
      });
    }
  }

  Widget _buildDot(int index, BuildContext context) {
    bool isSelected = _currentPage == index;
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
          widget.itemCount, (index) => _buildDot(index, context)),
    );
  }
}
