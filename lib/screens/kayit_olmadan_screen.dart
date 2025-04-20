import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/post_detail_screen.dart';
import 'package:mevzuatim/services/firestore_service.dart';
import 'package:mevzuatim/models/blog_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mevzuatim/services/storage_service.dart';

class KayitOlmadan extends StatefulWidget {
  const KayitOlmadan({super.key});

  @override
  State<KayitOlmadan> createState() => _KayitOlmadanState();
}

class _KayitOlmadanState extends State<KayitOlmadan> {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storService = StorageService();
  List<BlogModel> _blogs = [];

  @override
  void initState() {
    super.initState();
    _loadBlogs();
  }

  Future<void> _loadBlogs() async {
    User? user = FirebaseAuth.instance.currentUser; // Kullanıcıyı kontrol et
    print(user);
    if (user == null) {
      // Kullanıcı giriş yapmamışsa hata mesajı gösterebilirsiniz
      print("Kullanıcı giriş yapmamış.");
      return;
    }

    try {
      print(user.uid);
      List<BlogModel> blogs =
          await _firestoreService.getBlogsByManset("Düşünceleriniz");
      setState(() {
        _blogs = blogs;
      });
    } catch (e) {
      print("Bloglar alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    if (_blogs.isEmpty) const CircularProgressIndicator(),
                    ..._blogs.map((blog) => _buildPost(blog)).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(BlogModel blog) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Kullanıcının fotoğrafını göstermek için CircleAvatar
                FutureBuilder<String?>(
                  future: _firestoreService.getUserIdFromEmail(blog.yazar).then(
                      (userId) => _storService.getUserPhotoByName(userId!)),
                  builder: (context, snapshot) {
                    // Yükleniyor göstergesi
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      );
                    }

                    // Hata durumunda varsayılan resim
                    if (snapshot.hasError) {
                      return const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      );
                    }

                    // Fotoğraf bulunamazsa varsayılan resim
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      );
                    }

                    // Fotoğraf URL'si alındığında göster
                    String? photoUrl = snapshot.data;

                    if (photoUrl != null) {
                      return CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(photoUrl),
                      );
                    } else {
                      // Fotoğraf yoksa varsayılanı göster
                      return const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kullanıcı adını alıyoruz
                    FutureBuilder<String?>(
                      future:
                          _firestoreService.getUserNameFromEmail(blog.yazar),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Yükleniyor göstergesi
                        } else if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text('Kullanıcı adı bulunamadı');
                        } else {
                          return Text(
                            snapshot
                                .data!, // Burada snapshot.data ile kullanıcı adını alıyoruz
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          );
                        }
                      },
                    ),
                    // Yetki bilgisini alıyoruz
                    FutureBuilder<String?>(
                      future: _firestoreService.getUserRoleFromEmail(
                          blog.yazar), // Kullanıcının yetkisini alıyoruz
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Yükleniyor göstergesi
                        } else if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text('Yetki bilgisi bulunamadı');
                        } else {
                          return Text(
                            snapshot
                                .data!, // Burada snapshot.data ile kullanıcının yetkisini alıyoruz
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  blog.tarih.toLocal().toString().substring(0, 10),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 10),
            HtmlWidget(
              blog.icerik, // HTML içeriği işleniyor
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.mode_comment_outlined,
                    color: Colors.blue.shade700, size: 16),
                const SizedBox(width: 5),
                Text(
                  "Yorum yap",
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 10),
                ),
                const Spacer(),
                FutureBuilder<int>(
                  future: _firestoreService
                      .getYorumSayisi(blog.id), // Yorum sayısını alıyoruz
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    }

                    int yorumSayisi = snapshot.data ?? 0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              postId: blog.id,
                              yorumSayisi: yorumSayisi,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "$yorumSayisi yorum",
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
