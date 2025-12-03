abstract class CashierEvent {}

class CashierEventOpenCashier extends CashierEvent {
  final String deviceId;

  CashierEventOpenCashier({required this.deviceId});
}

class CashierEventCloseCashier extends CashierEvent {
  final String deviceId;
  final String cashierSessionId;

  CashierEventCloseCashier({
    required this.deviceId,
    required this.cashierSessionId,
  });
}

class CashierEventGetCurrentSession extends CashierEvent {
  final String deviceId;

  CashierEventGetCurrentSession({required this.deviceId});
}

class CashierEventReset extends CashierEvent {}