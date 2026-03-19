import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';

class GroupFeedingDashboardFilter {
  const GroupFeedingDashboardFilter._();

  static List<GroupCatSummaryRowData> apply({
    required List<GroupCatSummaryRowData> rows,
    required String query,
    required String goalFilter,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return rows
        .where((row) {
          final matchesGoal = goalFilter == 'all' || row.goalKey == goalFilter;
          final matchesSearch =
              normalizedQuery.isEmpty ||
              row.name.toLowerCase().contains(normalizedQuery);
          return matchesGoal && matchesSearch;
        })
        .toList(growable: false);
  }
}
