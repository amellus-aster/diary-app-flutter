import 'package:flutter/material.dart';

class PulsingFab extends StatefulWidget {
  const PulsingFab({super.key});

  @override
  State<PulsingFab> createState() => _PulsingFabState();
}

class _PulsingFabState extends State<PulsingFab>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation; 
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final value = animation.value;

            return Transform.scale(
              scale: 1 + value,
              child: Opacity(
                opacity: 1 - value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            );
          },
        ),

        FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          heroTag: "write",
          onPressed: () => Navigator.pushNamed(context, '/write'),
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
