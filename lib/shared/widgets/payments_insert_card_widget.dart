import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/payments/presentation/widgets/custom_back_button_widget.dart';

class InsertCardWidget extends StatefulWidget {
  final Bloc bloc;
  final Function() function;
  const InsertCardWidget({
    super.key,
    required this.bloc,
    required this.function,
  });

  @override
  State<InsertCardWidget> createState() => InsertCardWidgetState();
}

class InsertCardWidgetState extends State<InsertCardWidget>
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
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder(
                    bloc: widget.bloc,
                    builder: (context, state) {
                      return CustomBackButtonWidget(
                        backButton: () {
                          context.pop();
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
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
                        'Transação com cartão',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Por favor passe o cartão no leitor',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () async {
                          widget.function();
                        },
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
