import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/token_setup/presentation/mixin/token_setup_page_mixin.dart';

class TokenSetupPage extends StatefulWidget {
  const TokenSetupPage({super.key});

  @override
  State<TokenSetupPage> createState() => _TokenSetupPageState();
}

class _TokenSetupPageState extends State<TokenSetupPage>
    with TokenSetupPageMixin {
  final _tokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _saveTokenAndRestart() async {
    if (_tokenController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite o token de base'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await saveBaseToken(_tokenController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token salvo! Reiniciando aplicação...'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar token: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.white),
                const SizedBox(height: 32),
                const Text(
                  'Configuração Inicial',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Para continuar, você precisa inserir o token de base do sistema.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Token de Base',
                      hintText: 'Digite o token de autenticação',
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                    enabled: !_isLoading,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveTokenAndRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1565C0),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1565C0),
                              ),
                            ),
                          )
                        : const Text(
                            'Salvar e Continuar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white70, size: 20),
                      SizedBox(height: 8),
                      Text(
                        'Este token é necessário para autenticar as requisições do sistema. Entre em contato com o administrador se você não possuir esta informação.',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
