import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class LogService {
  static LogService? _instance;
  static LogService get instance => _instance ??= LogService._();
  
  LogService._();
  
  static const String _logFileName = 'zeeppay_logs.txt';
  static const int _maxLogSize = 5 * 1024 * 1024; // 5MB
  
  Future<File> get _logFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_logFileName');
  }

  /// Retorna o caminho completo do arquivo de log
  Future<String> getLogPath() async {
    final file = await _logFile;
    return file.path;
  }
  
  /// Registra um erro no log
  Future<void> logError(String module, String error, {Map<String, dynamic>? details}) async {
    await _writeLog('ERROR', module, error, details);
  }
  
  /// Registra uma informação no log
  Future<void> logInfo(String module, String message, {Map<String, dynamic>? details}) async {
    await _writeLog('INFO', module, message, details);
  }
  
  /// Registra um warning no log
  Future<void> logWarning(String module, String message, {Map<String, dynamic>? details}) async {
    await _writeLog('WARNING', module, message, details);
  }
  
  /// Registra um debug no log
  Future<void> logDebug(String module, String message, {Map<String, dynamic>? details}) async {
    await _writeLog('DEBUG', module, message, details);
  }
  
  Future<void> _writeLog(String level, String module, String message, Map<String, dynamic>? details) async {
    try {
      final file = await _logFile;
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      
      final logEntry = {
        'timestamp': timestamp,
        'level': level,
        'module': module,
        'message': message,
        if (details != null) 'details': details,
      };
      
      final logLine = '${jsonEncode(logEntry)}\n';
      
      // Verifica o tamanho do arquivo e rotaciona se necessário
      if (await file.exists()) {
        final fileSize = await file.length();
        if (fileSize > _maxLogSize) {
          await _rotateLog(file);
        }
      }
      
      await file.writeAsString(logLine, mode: FileMode.append);
    } catch (e) {
      // Falha silenciosa para não interromper o app
      print('Erro ao escrever log: $e');
    }
  }
  
  Future<void> _rotateLog(File currentLog) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File('${directory.path}/zeeppay_logs_backup.txt');
      
      // Remove backup antigo se existir
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
      
      // Move log atual para backup
      await currentLog.rename(backupFile.path);
      
      // Cria novo arquivo de log
      await currentLog.create();
      
      await logInfo('LogService', 'Log rotacionado - backup criado');
    } catch (e) {
      print('Erro ao rotacionar log: $e');
    }
  }
  
  /// Retorna o conteúdo dos logs
  Future<String> getLogs() async {
    try {
      final file = await _logFile;
      if (await file.exists()) {
        return await file.readAsString();
      }
      return 'Nenhum log encontrado.';
    } catch (e) {
      return 'Erro ao ler logs: $e';
    }
  }
  
  /// Retorna logs formatados para exibição
  Future<List<LogEntry>> getFormattedLogs({int? limit}) async {
    try {
      final file = await _logFile;
      if (!await file.exists()) {
        return [];
      }

      // Lê o arquivo linha por linha ao invés de carregar tudo na memória
      final logs = <LogEntry>[];
      final stream = file.openRead();
      final lines = stream.transform(utf8.decoder).transform(const LineSplitter());

      final allLines = <String>[];
      await for (final line in lines) {
        if (line.trim().isNotEmpty) {
          allLines.add(line);
        }
      }

      // Processa em ordem reversa
      for (final line in allLines.reversed) {
        try {
          final json = jsonDecode(line) as Map<String, dynamic>;
          logs.add(LogEntry.fromJson(json));

          if (limit != null && logs.length >= limit) break;
        } catch (e) {
          // Ignora linhas mal formadas
          continue;
        }
      }

      return logs;
    } catch (e) {
      return [];
    }
  }
  
  /// Limpa todos os logs
  Future<void> clearLogs() async {
    try {
      final file = await _logFile;
      if (await file.exists()) {
        await file.delete();
      }
      
      // Remove backup também
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File('${directory.path}/zeeppay_logs_backup.txt');
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
      
      await logInfo('LogService', 'Logs limpos pelo usuário');
    } catch (e) {
      print('Erro ao limpar logs: $e');
    }
  }
  
  /// Exporta logs para compartilhamento
  Future<File?> exportLogs() async {
    try {
      final file = await _logFile;
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class LogEntry {
  final DateTime timestamp;
  final String level;
  final String module;
  final String message;
  final Map<String, dynamic>? details;
  
  LogEntry({
    required this.timestamp,
    required this.level,
    required this.module,
    required this.message,
    this.details,
  });
  
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      timestamp: DateTime.parse(json['timestamp']),
      level: json['level'],
      module: json['module'],
      message: json['message'],
      details: json['details'],
    );
  }
  
  String get formattedTimestamp => DateFormat('dd/MM HH:mm:ss').format(timestamp);
  
  String get displayText => '[$level] $module: $message';
}