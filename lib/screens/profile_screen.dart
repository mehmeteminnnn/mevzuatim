import 'package:flutter/material.dart';
import 'package:mevzuatim/screens/post_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEVZUATIM',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mert Kaya',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Mali Müşavir - Editör',
                          style: TextStyle(color: Colors.grey)),
                      const Text('İstanbul, Türkiye',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
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

            const Divider(),

            // Hakkında
            ListTile(
              title: const Text("Hakkında"),
              subtitle: const Text("Hakkında bilgisi burada yer alacak."),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
            ),

            const Divider(),

            // Paylaşımlar
            ListTile(
              title: const Text("Paylaşımlar"),
              subtitle: const Text("1 paylaşım"),
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
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              title: const Text("Mert Kaya"),
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
              title: const Text("İş Deneyimleri"),
              subtitle: const Text("2 iş deneyimi"),
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
              title: const Text("Gümrük Müşaviri"),
              subtitle: const Text(
                  "A Firması - Tam Zamanlı\nEkim 2015 - Halen\nAnkara, Türkiye - Ofisten"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
            ),

            ListTile(
              title: const Text("Muhasebe Stajyeri"),
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
