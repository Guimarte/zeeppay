import 'package:zeeppay/features/cashier/data/models/payments_summary_model.dart';
import 'package:zeeppay/features/cashier/data/models/purchases_summary_model.dart';

import 'cashier_store_model.dart';
import 'cashier_device_model.dart';
import 'cashier_operator_model.dart';
import 'cashier_summary_model.dart';

class CashierModel {
  String? id;
  String? status;
  CashierStoreModel? store;
  CashierDeviceModel? device;
  CashierOperatorModel? operator;
  String? openAt;
  String? closedAt;
  CashierSummaryModel? summary;

  CashierModel({
    this.id,
    this.status,
    this.store,
    this.device,
    this.operator,
    this.openAt,
    this.closedAt,
    this.summary,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      id: json['id'] as String?,
      status: json['status'] as String?,
      store: json['store'] != null
          ? CashierStoreModel.fromJson(json['store'] as Map<String, dynamic>)
          : null,
      device: json['device'] != null
          ? CashierDeviceModel.fromJson(json['device'] as Map<String, dynamic>)
          : null,
      operator: json['operator'] != null
          ? CashierOperatorModel.fromJson(
              json['operator'] as Map<String, dynamic>,
            )
          : null,
      openAt: json['openAt'] as String?,
      closedAt: json['closedAt'] as String?,
      summary: json['summary'] != null
          ? CashierSummaryModel.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'store': store?.toJson(),
      'device': device?.toJson(),
      'operator': operator?.toJson(),
      'openAt': openAt,
      'closedAt': closedAt,
      'summary': summary?.toJson(),
    };
  }
}
