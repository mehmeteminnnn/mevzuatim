import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEVZUATIM',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gönderi
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gönderi Başlığı
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    title: const Text(
                      "Mert Kaya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("Mali Müşavir - Editör\n1 hafta"),
                  ),
                  const SizedBox(height: 16),
                  // Gönderi İçeriği
                  const Text(
                    "Bugünkü habere göre; Aile ve Sosyal Hizmetler Bakanlığı tarafından yapılan açıklamada, 16 yaş altı çocukların sosyal medya kullanımının sınırlandırılacağı ve platformların bu konuda daha fazla sorumluluk alması gerektiği belirtildi.\n\nAmacın, küçük çocukların zararlı içeriklerden korunması olduğu belirtilmiş. Benzer uygulamalar dünyanın farklı ülkelerinde de deneniyor. Bu konuda sizin görüşünüzü öğrenmek istiyorum. Düşünceniz seçenekler arasında yoksa, yorum olarak yazabilirsiniz. Gelsin o zaman bu akşamın anketi 🚀",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Etkileşim Butonları
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.comment_outlined),
                        label: const Text("Yorum Yap"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            // Yorumlar Bölümü
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Yorumlar (10)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Yorum Listesi
                  _buildComment(
                    "Osman Bahar",
                    "Gümrük Müşaviri - Editör",
                    "Ne zamandır beklediğim bir haberdi. Böyle gelişmelerin olduğunu görmek geleceğe daha umutlu bakmamı sağlıyor.",
                    "1 gün önce",
                  ),
                  const Divider(),
                  _buildComment(
                    "Ayşe Yılmaz",
                    "Avukat",
                    "Çocukların korunması için önemli bir adım. Umarım etkili bir şekilde uygulanır.",
                    "2 gün önce",
                  ),
                  const Divider(),
                  _buildComment(
                    "Mehmet Demir",
                    "Öğretmen",
                    "Eğitimci olarak bu kararı destekliyorum. Sosyal medyanın çocuklar üzerindeki olumsuz etkilerini sınıfta gözlemliyorum.",
                    "3 gün önce",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Yorum Yapma Alanı
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
                radius: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Yorum yaz...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComment(String name, String title, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
                radius: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.reply_outlined, size: 16),
                label: const Text("Yanıtla"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
