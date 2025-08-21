import 'package:flutter/material.dart';

class CardReadingWidget extends StatefulWidget {
  final VoidCallback onCancel;
  final String? message;

  const CardReadingWidget({
    super.key,
    required this.onCancel,
    this.message,
  });

  @override
  State<CardReadingWidget> createState() => _CardReadingWidgetState();
}

class _CardReadingWidgetState extends State<CardReadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    size: 64,
                    color: Colors.blue,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            widget.message ?? 'Aproxime ou insira o cartão',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aguardando leitura do cartão...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: widget.onCancel,
            icon: const Icon(Icons.cancel),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}