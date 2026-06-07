class NotificationModel {
  final String id;

  final String userId;

  final String title;
  final String message;

  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],

      title: json['title'] ?? '',

      message:
          json['message'] ?? '',

      isRead:
          json['is_read'] ?? false,
    );
  }
}