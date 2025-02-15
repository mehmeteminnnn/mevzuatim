import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    _buildPost(),
                    _buildPost(),
                    _buildPost(),
                  ],
                ),
              ),
            ),
          ),
          // Arama ve Profil Alanı
        ],
      ),
    );
  }

  /// Postları oluşturan widget
  Widget _buildPost() {
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
                  children: const [
                    Text(
                      "Mert Kaya",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      "Mali Müşavir - Editör",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const Spacer(),
                const Text("19.12.2024",
                    style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Bugünkü habere göre; Aile ve Sosyal Hizmetler Bakanlığı tarafından yapılan açıklamada, 16 yaş altı çocukların sosyal medya kullanımı sınırlandırılacağı ve platformların bu konuda daha fazla sorumluluk alması gerektiği belirtildi.",
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
                    "10 yorum",
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 10,
                      // decoration: TextDecoration.underline,
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
            radius: 18,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
