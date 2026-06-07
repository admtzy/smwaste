import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationPage
    extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage>
      createState() =>
          _NotificationPageState();
}

class _NotificationPageState
    extends State<
      NotificationPage
    > {
  final service =
      NotificationService();

  List data = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotif();
  }

  Future<void>
      loadNotif() async {
    data =
        await service
            .getNotifications();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
        ),
      ),

      body:
          isLoading
              ? const Center(
                child:
                    CircularProgressIndicator(),
              )
              : ListView.builder(
                itemCount:
                    data.length,

                itemBuilder:
                    (
                      context,
                      index,
                    ) {
                      final item =
                          data[index];

                      return ListTile(
                        leading:
                            const Icon(
                              Icons
                                  .notifications,
                            ),

                        title: Text(
                          item['title'],
                        ),

                        subtitle:
                            Text(
                              item['message'],
                            ),
                      );
                    },
              ),
    );
  }
}