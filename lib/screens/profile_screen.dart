import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/post_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mert Kaya',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Mali Müşavir - Editör',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const Text(
                        'İstanbul, Türkiye',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
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
              subtitle: const Text("Hakkında bilgisi burada yer alacak."),
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
                    label: Text(
                      "Yeni Gönderi",
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue), // Daha küçük font
                    ),
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
              title: const Text("Mert Kaya",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                "Bugünkü habere göre; Aile ve Sosyal Hizmetler Bakanlığı tarafından açıklamada, "
                "16 yaş altı çocukların sosyal medya kullanımı sınırlandırılacak...",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostDetailScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            // İş Deneyimleri
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            ListTile(
              title: const Text("Gümrük Müşaviri",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "A Firması - Tam Zamanlı\nEkim 2015 - Halen\nAnkara, Türkiye - Ofisten"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
            ),

            ListTile(
              title: const Text("Muhasebe Stajyeri",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "B Firması - Tam Zamanlı\nKasım 2012 - Aralık 2014\nAnkara, Türkiye - Ofisten"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
            ),

            const Divider(),

            // Bottom Navigation
          ],
        ),
      ),
    );
  }
}
