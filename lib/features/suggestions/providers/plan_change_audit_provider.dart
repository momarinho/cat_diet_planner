import 'package:cat_diet_planner/features/suggestions/models/plan_change_audit_entry.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_change_audit_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planChangeAuditServiceProvider = Provider<PlanChangeAuditService>((ref) {
  return PlanChangeAuditService();
});

final planChangeAuditProvider = Provider<List<PlanChangeAuditEntry>>((ref) {
  return ref.read(planChangeAuditServiceProvider).readAll();
});
