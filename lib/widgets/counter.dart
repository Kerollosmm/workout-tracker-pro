import 'package:flutter/material.dart';

/// I tried to make this widget stateless similar to
/// how the default flutter slider/checkbox works but
/// it would not update the UI via setState call when
/// user bottom sheet. Not sure if this is an issue
/// or intended but for now this widget will be stateful.
/// UPDATE:
/// Below link seems to address this issue.
/// https://github.com/flutter/flutter/issues/2115
class Counter extends StatefulWidget {
  final Function onChanged;
  final int increment;
  final int startingValue;

  const Counter({
    super.key,
    this.startingValue = 0,
    required this.onChanged,
    this.increment = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return _CounterState();
  }
}

class _CounterState extends State<Counter> with SingleTickerProviderStateMixin {
  late int value;
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    value = widget.startingValue;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _colorAnimation = ColorTween(begin: Colors.grey[100], end: Colors.blue[50])
        .animate(_controller);
  }

  void _shakeIfZero() {
    if (value == 0) {
      _controller.forward(from: 0).then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScaleTransition(
          scale: _bounceAnimation,
          child: IconButton(
            icon: Icon(Icons.remove_circle_outline,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              _controller.forward().then((_) => _controller.reverse());
              _subtract();
              _shakeIfZero();
            },
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ScaleTransition(
          scale: _bounceAnimation,
          child: IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              _controller.forward().then((_) => _controller.reverse());
              _add();
            },
          ),
        ),
      ],
    );
  }

  void _subtract() {
    // extra logic for preventing negative values
    int newValue = value - widget.increment;
    if (newValue < 0) {
      newValue = 0;
    }
    setState(() {
      value = newValue;
      widget.onChanged(value);
    });
  }

  void _add() {
    setState(() {
      value = value + widget.increment;
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
