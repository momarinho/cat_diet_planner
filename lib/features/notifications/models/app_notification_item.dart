import 'package:flutter/foundation.dart';

enum AppNotificationType { mealReminder, backupReminder, weightAlert }

@immutable
class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.routeName,
    this.routeArguments,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? routeName;
  final Object? routeArguments;

  AppNotificationItem copyWith({
    String? id,
    AppNotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? routeName,
    Object? routeArguments,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      routeName: routeName ?? this.routeName,
      routeArguments: routeArguments ?? this.routeArguments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'routeName': routeName,
    };
  }

  static AppNotificationItem? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return null;

    final id = map['id']?.toString();
    final typeRaw = map['type']?.toString();
    final title = map['title']?.toString();
    final message = map['message']?.toString();
    final createdAtRaw = map['createdAt']?.toString();
    final createdAt = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw);
    AppNotificationType? type;
    for (final value in AppNotificationType.values) {
      if (value.name == typeRaw) {
        type = value;
        break;
      }
    }

    if (id == null ||
        type == null ||
        title == null ||
        message == null ||
        createdAt == null) {
      return null;
    }

    return AppNotificationItem(
      id: id,
      type: type,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: map['isRead'] as bool? ?? false,
      routeName: map['routeName']?.toString(),
    );
  }
}
