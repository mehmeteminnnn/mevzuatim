import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mevzuatim/models/job_experience_model.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
                      /*Text(_userLocation,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),*/
                    ],
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Profili Düzenle"),
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
                onPressed: () {},
              ),
            ),

            const Divider(),

            // Paylaşımlar
            ListTile(
              title: const Text(
                "Paylaşımlar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("1 paylaşım",
                  style: TextStyle(color: Colors.blue)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add,
                        size: 14, color: Colors.blue), // Daha küçük ikon
                    label: Text("Yeni Gönderi",
                        style: TextStyle(fontSize: 12, color: Colors.blue)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8), // Daha az padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6), // Daha az yuvarlatılmış köşeler
                        side:
                            BorderSide(color: Colors.blue), // Kenarlık eklendi
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              title: Text(userProfile!.username,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                "Bugünkü habere göre; Aile ve Sosyal Hizmetler Bakanlığı tarafından açıklamada, "
                "16 yaş altı çocukların sosyal medya kullanımı sınırlandırılacak...",
              ),
              onTap: () {},
            ),

            const Divider(),

            // İş Deneyimleri Başlık
            ListTile(
              title: const Text(
                "İş Deneyimleri",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("2 iş deneyimi",
                  style: TextStyle(color: Colors.blue)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.blue),
                    onPressed: () {
                      // İş deneyimi ekleme işlevi
                      _showAddExperienceDialog(context);
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
                      '${experience.companyName} - ${experience.workMode}\n${experience.startDate} - ${experience.endDate}\n${experience.city}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      /*
                      _showEditExperienceDialog(
                          context, experience); // deneyim düzenle*/
                    },
                  ),
                );
              }).toList(),
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
}
