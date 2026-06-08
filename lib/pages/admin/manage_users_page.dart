import 'package:flutter/material.dart';

import '../../services/account_service.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final accountService = AccountService();

  List users = [];

  bool isLoading = true;

  // =========================
  // LOAD USERS
  // =========================

  Future<void> loadUsers() async {
    final data = await accountService.getAllUsers();

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "User berhasil dihapus",
        ),
      ),
    );
  }

  // Helper untuk menampilkan dialog konfirmasi hapus user
  void showDeleteDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus User', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Yakin ingin menghapus pengguna "$name" dari sistem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteUser(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF236652);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7), // Background abu-hijau sangat bersih
      appBar: AppBar(
        title: const Text(
          "Kelola User",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            )
          : users.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada user",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadUsers,
                  color: primaryGreen,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user['foto_profile'] != null && user['foto_profile'] != ''
                                  ? NetworkImage(user['foto_profile'])
                                  : null,
                              child: user['foto_profile'] == null || user['foto_profile'] == ''
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 26,
                                    )
                                  : null,
                            ),
                            title: Text(
                              user['nama'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['email'] ?? '',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      user['role'] != null ? user['role'].toString().toUpperCase() : '-',
                                      style: const TextStyle(
                                        color: primaryGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                showDeleteDialog(
                                  user['id'].toString(),
                                  user['nama'] ?? 'User',
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}