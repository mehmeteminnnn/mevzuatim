import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/post_detail_screen.dart';
import 'package:mevzuatim/services/firestore_service.dart';
import 'package:mevzuatim/models/blog_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<BlogModel> _blogs = [];

  @override
  void initState() {
    super.initState();
    _loadBlogs(); // Blogları yükle
  }

  Future<void> _loadBlogs() async {
    try {
      List<BlogModel> blogs =
          await _firestoreService.getBlogsByManset("Düşünceleriniz");
      setState(() {
        _blogs = blogs; // Veriler alındığında state'i güncelle
      });
    } catch (e) {
      // Hata durumunda kullanıcıya mesaj gösterebilirsiniz
      print("Bloglar alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MEVZUATIM",
          style: TextStyle(
            color: Color(0xFF64B6AC), // Mavi renk
            fontSize: 20, // Daha küçük font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40, // AppBar yüksekliği azaltıldı
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSearchAndProfile(),
                    const SizedBox(height: 10),
                    // Bloglar yüklenene kadar CircularProgressIndicator göster
                    if (_blogs.isEmpty) const CircularProgressIndicator(),
                    // Bloglar geldiğinde postları göster
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

  /// Postları oluşturan widget
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
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.yazar, // Bunu dinamik yapabilirsiniz
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      "Mali Müşavir - Editör", // Bunu dinamik yapabilirsiniz
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  // Tarihi dinamik olarak al
                  blog.tarih.toLocal().toString().substring(0, 10),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              blog.ozet, // Dinamik içerik
              style: TextStyle(fontSize: 12),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostDetailScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "10 yorum", // Yorum sayısını dinamik yapabilirsiniz
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Sayfanın altına arama ve profil ekleyen widget
  Widget _buildSearchAndProfile() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18, // Yüksekliği azaltmak için radius değerini küçülttüm
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Arama Yap",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4, // Daha küçük bir padding değeri
                  horizontal:
                      10, // Horizontal padding de eklenerek hizalama sağlandı
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
