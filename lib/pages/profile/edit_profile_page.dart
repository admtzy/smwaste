import 'package:flutter/material.dart';

import '../../services/account_service.dart';
import '../../services/profile_service.dart';

class EditProfilePage
    extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage>
      createState() =>
          _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  final accountService =
      AccountService();

  final profileService =
      ProfileService();

  // controller

  final namaC =
      TextEditingController();

  final alamatC =
      TextEditingController();

  final noHpC =
      TextEditingController();

  final namaUmkmC =
      TextEditingController();

  final kecamatanC =
      TextEditingController();

  final kabupatenC =
      TextEditingController();

  final danaC =
      TextEditingController();

  final shopeeC =
      TextEditingController();

  final bankC =
      TextEditingController();

  final rekeningC =
      TextEditingController();

  final pemilikRekeningC =
      TextEditingController();

  bool isLoading = true;

  String role = '';

  String kategori = 'FNB';

  String metodePencairan =
      'DANA';

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile =
        await profileService
            .getProfile();

    if (profile != null) {
      namaC.text =
          profile['nama'] ?? '';

      alamatC.text =
          profile['alamat'] ?? '';

      noHpC.text =
          profile['no_hp'] ?? '';

      namaUmkmC.text =
          profile['nama_umkm'] ?? '';

      kecamatanC.text =
          profile['kecamatan'] ??
              '';

      kabupatenC.text =
          profile['kabupaten'] ??
              '';

      danaC.text =
          profile['nomor_dana'] ??
              '';

      shopeeC.text =
          profile[
                  'nomor_shopeepay'] ??
              '';

      bankC.text =
          profile['nama_bank'] ??
              '';

      rekeningC.text =
          profile[
                  'nomor_rekening'] ??
              '';

      pemilikRekeningC.text =
          profile[
                  'nama_pemilik_rekening'] ??
              '';

      role =
          profile['role'] ?? '';

      kategori =
          profile[
                  'kategori_umkm'] ??
              'FNB';

      metodePencairan =
          profile[
                  'metode_pencairan'] ??
              'DANA';
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateProfile() async {
  try {
    await accountService.updateProfile(
      nama: namaC.text,
      alamat: alamatC.text,
      noHp: noHpC.text,
      namaUmkm: namaUmkmC.text,
      kategoriUmkm: kategori,
      kecamatan: kecamatanC.text,
      kabupaten: kabupatenC.text,
      metodePencairan: metodePencairan,
      nomorDana: danaC.text,
      nomorShopeepay: shopeeC.text,
      namaBank: bankC.text,
      nomorRekening: rekeningC.text,
      namaPemilikRekening: pemilikRekeningC.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile berhasil diupdate",
        ),
      ),
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // kalau masih ada halaman sebelumnya
    if (Navigator.canPop(context)) {
      Navigator.pop(
        context,
        true,
      );
    } else {
      // kalau tidak ada halaman sebelumnya
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}

  Future<void> deleteAccount() async {
    try {
      await accountService
          .deleteMyAccount();

      if (!mounted) return;

      Navigator.popUntil(
        context,
        (route) =>
            route.isFirst,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    alamatC.dispose();
    noHpC.dispose();

    namaUmkmC.dispose();

    kecamatanC.dispose();
    kabupatenC.dispose();

    danaC.dispose();
    shopeeC.dispose();

    bankC.dispose();
    rekeningC.dispose();
    pemilikRekeningC.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(
                      20),

              child:
                  SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller:
                          namaC,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Nama',

                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                        height: 15),

                    TextField(
                      controller:
                          alamatC,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Alamat',

                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                        height: 15),

                    TextField(
                      controller:
                          noHpC,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'No HP',

                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                        height: 15),

                    if (role ==
                        'penjual') ...[
                      TextField(
                        controller:
                            namaUmkmC,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Nama UMKM',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                          height:
                              15),

                      TextField(
                        controller:
                            kecamatanC,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Kecamatan',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                          height:
                              15),

                      TextField(
                        controller:
                            kabupatenC,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Kabupaten',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                          height:
                              15),

                      DropdownButtonFormField<
                          String>(
                        value:
                            kategori,

                        decoration:
                            const InputDecoration(
                          border:
                              OutlineInputBorder(),

                          labelText:
                              'Kategori UMKM',
                        ),

                        items: const [
                          DropdownMenuItem(
                            value:
                                'FNB',

                            child:
                                Text(
                              'FNB',
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'Industri Kreatif',

                            child:
                                Text(
                              'Industri Kreatif',
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'Fashion',

                            child:
                                Text(
                              'Fashion',
                            ),
                          ),
                        ],

                        onChanged:
                            (
                          value,
                        ) {
                          setState(
                            () {
                              kategori =
                                  value!;
                            },
                          );
                        },
                      ),

                      const SizedBox(
                          height:
                              15),

                      DropdownButtonFormField<
                          String>(
                        value:
                            metodePencairan,

                        decoration:
                            const InputDecoration(
                          border:
                              OutlineInputBorder(),

                          labelText:
                              'Metode Pencairan',
                        ),

                        items: const [
                          DropdownMenuItem(
                            value:
                                'DANA',

                            child:
                                Text(
                              'DANA',
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'ShopeePay',

                            child:
                                Text(
                              'ShopeePay',
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'Bank',

                            child:
                                Text(
                              'Bank',
                            ),
                          ),
                        ],

                        onChanged:
                            (
                          value,
                        ) {
                          setState(
                            () {
                              metodePencairan =
                                  value!;
                            },
                          );
                        },
                      ),

                      const SizedBox(
                          height:
                              15),

                      if (metodePencairan ==
                          'DANA')
                        TextField(
                          controller:
                              danaC,

                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nomor DANA',

                            border:
                                OutlineInputBorder(),
                          ),
                        ),

                      if (metodePencairan ==
                          'ShopeePay')
                        TextField(
                          controller:
                              shopeeC,

                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nomor ShopeePay',

                            border:
                                OutlineInputBorder(),
                          ),
                        ),

                      if (metodePencairan ==
                          'Bank')
                        Column(
                          children: [
                            TextField(
                              controller:
                                  bankC,

                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Nama Bank',

                                border:
                                    OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(
                                height:
                                    15),

                            TextField(
                              controller:
                                  rekeningC,

                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Nomor Rekening',

                                border:
                                    OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(
                                height:
                                    15),

                            TextField(
                              controller:
                                  pemilikRekeningC,

                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Nama Pemilik Rekening',

                                border:
                                    OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                    ],

                    const SizedBox(
                        height: 25),

                    SizedBox(
                      width:
                          double.infinity,

                      height: 50,

                      child:
                          ElevatedButton(
                        onPressed:
                            updateProfile,

                        child:
                            const Text(
                          "Update Profile",
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 15),

                    SizedBox(
                      width:
                          double.infinity,

                      height: 50,

                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                        ),

                        onPressed:
                            deleteAccount,

                        child:
                            const Text(
                          "Delete Account",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}