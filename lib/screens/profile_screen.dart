import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    hide ImageSource;

import 'package:image_picker/image_picker.dart';
import 'package:mevzuatim/models/job_experience_model.dart';
import 'package:mevzuatim/screens/login_screen.dart';
import 'package:mevzuatim/services/firestore_service.dart';
import 'package:mevzuatim/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginAlertDialog(context);
      });
    } else {
      _loadUserProfile();
    }
  }

  void _showLoginAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.lock_outline, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Giriş Gerekli'),
            ],
          ),
          content: const Text(
            'Bu sayfayı görüntülemek için önce giriş yapmalısınız.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Alert kapat
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen())); // Giriş sayfasına yönlendir
              },
              child: const Text(
                "Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Fotoğraf seçme işlemi
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfileImage() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final authId = currentUser.uid; // Auth ID alınıyor
      if (_selectedImage != null) {
        final isUpdated = await UserProfileService()
            .updateProfileImage(authId, _selectedImage!);
        if (isUpdated) {
          // Resim başarıyla güncellendi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil resmi güncellendi')),
          );
        } else {
          // Hata durumunda
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil resmi güncellenemedi')),
          );
        }
      }
    } else {
      // Kullanıcı oturum açmamış
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı oturum açmamış')),
      );
    }
  }

  Future<void> _loadUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      debugPrint("Kullanıcı ID: $uid");
      final service = UserProfileService();
      final profile = await service.fetchUserProfile(uid);
      setState(() {
        userProfile = profile;
      });
    } else {
      // kullanıcı giriş yapmamış
      print("Kullanıcı oturum açmamış.");
    }
  }
  /*@override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile on initialization
    //_loadBlogContent();
  }*/

  /* void _loadBlogContent() async {
    String content =
        (await FirestoreService().getLastBlogByAuthId(authId)) as String;
    setState(() {
      _blogContent = content;
    });
  }*/

  // Fetch user data from Firestore using Auth ID
  /*Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('kullanıcılar')
          .doc(user.uid) // Get user by their auth ID
          .get();

      if (userDoc.exists) {
        setState(() {
          // Assign fetched data to the state variables
          _userName =
              userDoc['kullanici adi'] ?? 'No Name'; // Field name might differ
          _userRole = userDoc['yetki'] ?? 'No Role';
          _profileImage = 'assets/profile.jpg';
        });
      } else {
        print("User document does not exist");
      }
    } else {
      print("No user logged in");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Yükleniyor...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "MEVZUATIM",
          style: TextStyle(
            color: Color(0xFF64B6AC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profil Bilgileri
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(userProfile!.profileImage),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userProfile!.username,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(userProfile!.yetki,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                      Text(userProfile!.expertise,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Fotoğraf seçme işlemi
                      await _pickImage();
                      if (_selectedImage != null) {
                        // Resmi güncelleme işlemi
                        await _updateProfileImage();
                      }
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Profil Resmi Düzenle",
                        style: TextStyle(fontSize: 10)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Hakkında
            ListTile(
              title: const Text(
                "Hakkında",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userProfile!.aboutMe),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditAboutDialog(context);
                },
              ),
            ),

            const Divider(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future:
                      FirestoreService().getBlogsByAuthor(userProfile!.mail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text("Bir hata oluştu.");
                    } else {
                      final paylasimlar = snapshot.data ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text(
                              "Paylaşımlar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${paylasimlar.length} paylaşım",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          if (paylasimlar.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Henüz paylaşım yapılmamış.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            ...paylasimlar.map((paylasim) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userProfile!.profileImage),
                                  ),
                                  title: Text(
                                    userProfile!.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: HtmlWidget(paylasim['icerik']),
                                  onTap: () {},
                                )),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),

            const Divider(),

            // İş Deneyimleri Başlık
            ListTile(
              title: const Text(
                "İş Deneyimleri",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.blue),
                    onPressed: () {
                      // İş deneyimi ekleme işlevi
                      _showAddExperienceDialog2(context,
                          flag: false); // Yeni iş deneyimi eklemek için
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: userProfile!.jobExperiences.map((experience) {
                return ListTile(
                  title: Text(
                    experience.jobTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${experience.id}${experience.companyName} - ${experience.workMode}\n${experience.startDate} - ${experience.endDate ?? "Halen"}\n${experience.city}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showAddExperienceDialog2(context,
                          existingExperience: experience,
                          id: experience.id.toString(),
                          flag: false);
                    },
                  ),
                );
              }).toList(),
            ),

            const Divider(),

            // Çıkış Yap Butonu
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Çıkış Yap"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // İş deneyimi eklemek için gösterilecek dialog
  void _showAddExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Yeni İş Deneyimi Ekle",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue[300])),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // İş Ünvanı
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'İş Ünvanı',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Şirket Adı
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Şirket Adı',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // İstihdam Türü
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'İstihdam Türü',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(child: Text('Tam Zamanlı')),
                      DropdownMenuItem(child: Text('Yarı Zamanlı')),
                      DropdownMenuItem(child: Text('Freelance')),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Kaydet"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  // İş deneyimini düzenlemek için gösterilecek dialog
  void _showEditExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("İş Deneyimi Düzenle",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue[300])),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // İş Ünvanı
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'İş Ünvanı',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Şirket Adı
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Şirket Adı',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // İstihdam Türü
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'İstihdam Türü',
                      labelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade200, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(child: Text('Tam Zamanlı')),
                      DropdownMenuItem(child: Text('Yarı Zamanlı')),
                      DropdownMenuItem(child: Text('Freelance')),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Kaydet"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  void _showEditAboutDialog(BuildContext context) {
    TextEditingController _aboutController =
        TextEditingController(text: userProfile?.aboutMe ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hakkımda Bilgisi"),
        content: TextField(
          controller: _aboutController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Kendiniz hakkında bir şeyler yazın...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAbout = _aboutController.text.trim();
              if (newAbout.isNotEmpty) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                final success =
                    await UserProfileService().updateAboutMe(uid, newAbout);

                if (success) {
                  setState(() {
                    userProfile = userProfile!.copyWith(aboutMe: newAbout);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Hakkımda bilgisi güncellendi")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Güncelleme başarısız")),
                  );
                }
              }
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  void _showAddExperienceDialog2(BuildContext context,
      {JobExperience? existingExperience, String? id, required bool flag}) {
    final jobTitleController =
        TextEditingController(text: existingExperience?.jobTitle ?? '');
    final companyNameController =
        TextEditingController(text: existingExperience?.companyName ?? '');
    final employmentTypeController =
        TextEditingController(text: existingExperience?.employmentType ?? '');
    final startDateController =
        TextEditingController(text: existingExperience?.startDate ?? '');
    final endDateController =
        TextEditingController(text: existingExperience?.endDate ?? '');
    final cityController =
        TextEditingController(text: existingExperience?.city ?? '');
    final workModeController =
        TextEditingController(text: existingExperience?.workMode ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(flag ? 'Deneyim' : 'Deneyimi Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('İş Ünvanı', jobTitleController),
                _buildTextField('Firma Adı', companyNameController),
                _buildTextField('Çalışma Türü', employmentTypeController),
                _buildTextField('Başlangıç Tarihi', startDateController,
                    hint: 'yyyy-aa-gg'),
                _buildTextField('Bitiş Tarihi (Opsiyonel)', endDateController,
                    hint: 'yyyy-aa-gg'),
                _buildTextField('Şehir', cityController),
                _buildTextField('Çalışma Düzeni', workModeController),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final uid = _auth.currentUser!.uid;
                    final isSuccess =
                        await UserProfileService().updateJobExperience(
                      id: id ?? "",
                      uid: uid,
                      jobTitle: jobTitleController.text,
                      companyName: companyNameController.text,
                      employmentType: employmentTypeController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                      city: cityController.text,
                      workMode: workModeController.text,
                    );

                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "İş deneyimi başarıyla ${flag ? 'eklendi' : 'güncellendi'}")),
                      );
                      Navigator.of(context).pop();
                      _loadUserProfile(); // Listeyi güncelle
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("İşlem başarısız")),
                      );
                    }
                  },
                  child: Text(
                    flag ? 'Kaydet' : 'Güncelle',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
