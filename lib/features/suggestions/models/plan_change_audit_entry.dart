class PlanChangeAuditEntry {
  const PlanChangeAuditEntry({
    required this.suggestionId,
    required this.catId,
    required this.catName,
    required this.acceptedBy,
    required this.acceptedAt,
    required this.changeSummary,
  });

  final String suggestionId;
  final String catId;
  final String catName;
  final String acceptedBy;
  final DateTime acceptedAt;
  final List<String> changeSummary;

  Map<String, dynamic> toMap() {
    return {
      'suggestionId': suggestionId,
      'catId': catId,
      'catName': catName,
      'acceptedBy': acceptedBy,
      'acceptedAt': acceptedAt.toIso8601String(),
      'changeSummary': changeSummary,
    };
  }

  factory PlanChangeAuditEntry.fromMap(Map<dynamic, dynamic> map) {
    final rawChanges = map['changeSummary'] as List?;
    return PlanChangeAuditEntry(
      suggestionId: map['suggestionId']?.toString() ?? '',
      catId: map['catId']?.toString() ?? '',
      catName: map['catName']?.toString() ?? '',
      acceptedBy: map['acceptedBy']?.toString() ?? 'unknown',
      acceptedAt:
          DateTime.tryParse(map['acceptedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      changeSummary:
          rawChanges
              ?.map((entry) => entry.toString())
              .where((entry) => entry.isNotEmpty)
              .toList(growable: false) ??
          const [],
    );
  }
}
