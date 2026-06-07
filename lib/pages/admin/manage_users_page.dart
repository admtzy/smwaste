import 'package:flutter/material.dart';

import '../../services/account_service.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() =>
      _ManageUsersPageState();
}

class _ManageUsersPageState
    extends State<ManageUsersPage> {
  final accountService = AccountService();

  List users = [];

  bool isLoading = true;

  // =========================
  // LOAD USERS
  // =========================

  Future<void> loadUsers() async {
    final data =
        await accountService.getAllUsers();

    setState(() {
      users = data;
      isLoading = false;
    });
  }

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser(
    String id,
  ) async {
    await accountService.deleteUser(id);

    await loadUsers();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "User berhasil dihapus",
        ),
      ),
    );
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kelola User",
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : users.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada user",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadUsers,

                  child: ListView.builder(
                    itemCount: users.length,

                    itemBuilder:
                        (context, index) {
                      final user =
                          users[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),

                        child: ListTile(
                          leading:
                              CircleAvatar(
                            backgroundImage:
                                user['foto_profile'] !=
                                            null &&
                                        user['foto_profile'] !=
                                            ''
                                    ? NetworkImage(
                                        user[
                                            'foto_profile'],
                                      )
                                    : null,

                            child:
                                user['foto_profile'] ==
                                            null ||
                                        user['foto_profile'] ==
                                            ''
                                    ? const Icon(
                                        Icons
                                            .person,
                                      )
                                    : null,
                          ),

                          title: Text(
                            user['nama'] ??
                                '-',
                          ),

                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                user['email'] ??
                                    '',
                              ),

                              Text(
                                "Role : ${user['role']}",
                              ),
                            ],
                          ),

                          trailing:
                              IconButton(
                            icon:
                                const Icon(
                              Icons.delete,
                              color:
                                  Colors.red,
                            ),

                            onPressed: () {
                              deleteUser(
                                user['id'],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}