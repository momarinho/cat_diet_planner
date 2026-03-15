import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/suggestions/models/plan_change_audit_entry.dart';

class PlanChangeAuditService {
  static const _auditLogKey = 'plan_change_audit_log';

  List<PlanChangeAuditEntry> readAll() {
    final raw = HiveService.appSettingsBox.get(_auditLogKey);
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map(PlanChangeAuditEntry.fromMap)
        .toList(growable: false);
  }

  Future<void> append(PlanChangeAuditEntry entry) async {
    final current = readAll().map((item) => item.toMap()).toList();
    current.insert(0, entry.toMap());
    await HiveService.appSettingsBox.put(
      _auditLogKey,
      current.take(AppLimits.maxPlanAuditEntries).toList(growable: false),
    );
  }
}
