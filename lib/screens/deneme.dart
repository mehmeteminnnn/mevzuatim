import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mevzuatim/models/blog_model.dart';
import 'package:mevzuatim/services/algolia_service.dart';
import 'package:mevzuatim/services/firestore_service.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<BlogModel>> _blogs;
  final AlgoliaService _algoliaService = AlgoliaService();
  static final Algolia _algolia = Algolia.init(
    applicationId: 'BO2SLL34UL', // Algolia App ID
    apiKey: '550ba7996ccda8971e1b12be1c7499b4', // Algolia API Key
  );

  @override
  void initState() {
    super.initState();
    // Blogları almak için fonksiyonu çağır
    _blogs = _firestoreService.getBlogsByManset('Düşünceleriniz');
  }

  Future<void> _performSearch() async {
    var results = await _algoliaService.searchByContent("gü");
    var indices = await _algolia.instance.getIndices();
    print(indices.toString() + 'deneme');
    print(indices);

    print(results.toString() + "indeksler");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloglar')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _performSearch,
            child: Text('Deneme'),
          ),
          Expanded(
            child: FutureBuilder<List<BlogModel>>(
              future: _blogs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Hiç blog bulunamadı.'));
                } else {
                  // Veriler geldi, listeyi göster
                  List<BlogModel> blogs = snapshot.data!;
                  return ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(blogs[index].baslik),
                        subtitle: Text(blogs[index].manset),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
