import 'package:flutter/material.dart';

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

            // İş deneyimi 1
            ListTile(
              title: const Text("Gümrük Müşaviri",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "A Firması - Tam Zamanlı\nEkim 2015 - Halen\nAnkara, Türkiye - Ofisten"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // İş deneyimi düzenleme işlevi
                  _showEditExperienceDialog(context);
                },
              ),
            ),

            // İş deneyimi 2
            ListTile(
              title: const Text("Muhasebe Stajyeri",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "B Firması - Tam Zamanlı\nKasım 2012 - Aralık 2014\nAnkara, Türkiye - Ofisten"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // İş deneyimi düzenleme işlevi
                  _showEditExperienceDialog(context);
                },
              ),
            ),

            const Divider(),
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
                      DropdownMenuItem(
                        child: Text('Tam Zamanlı'),
                        value: 'Tam Zamanlı',
                      ),
                      DropdownMenuItem(
                        child: Text('Yarı Zamanlı'),
                        value: 'Yarı Zamanlı',
                      ),
                      DropdownMenuItem(
                        child: Text('Freelance'),
                        value: 'Freelance',
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

                  // Çalışma Dönemi
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Çalışma Dönemi',
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

                  // Konum
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Konum',
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () {
                // Kaydetme işlemi
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // İş deneyimi düzenleme için Bottom Sheet
  void _showEditExperienceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                Text(
                  "İş Deneyimini Düzenle",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[800]),
                ),
                const SizedBox(height: 20),

                // İş Ünvanı
                TextField(
                  decoration: InputDecoration(
                    labelText: 'İş Ünvanı',
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 12),
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
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 12),
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
                    DropdownMenuItem(
                      child: Text('Tam Zamanlı'),
                      value: 'Tam Zamanlı',
                    ),
                    DropdownMenuItem(
                      child: Text('Yarı Zamanlı'),
                      value: 'Yarı Zamanlı',
                    ),
                    DropdownMenuItem(
                      child: Text('Freelance'),
                      value: 'Freelance',
                    ),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),

                // Çalışma Dönemi

                //baslik,istihdam turu(linkedinden bak çırak hariç),sirket veya kurulus,baslama bitiş tarihi,konum
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Çalışma Dönemi',
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 12),
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

                // Konum
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Konum',
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 12),
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
                const SizedBox(height: 20),

                // Aksiyon Butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Kapatma
                      },
                      child:
                          const Text('İptal', style: TextStyle(fontSize: 16)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue, // Mavi renk
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Kaydetme işlemi
                        Navigator.of(context).pop();
                      },
                      child: const Text('Kaydet'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue, // Mavi renk
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /* // İş deneyimi düzenlemek için gösterilecek dialog
  void _showEditExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("İş Deneyimini Düzenle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                decoration: InputDecoration(
                  labelText: 'İş Ünvanı',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Şirket Adı',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Çalışma Dönemi',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Konum',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () {
                // Kaydetme işlemi
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/
}
