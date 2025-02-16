import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mevzuatim/models/blog_model.dart';
import 'package:mevzuatim/services/firestore_service.dart';


class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<BlogModel>> _blogs;

  @override
  void initState() {
    super.initState();
    // Blogları almak için fonksiyonu çağır
    _blogs = _firestoreService.getBlogsByManset('Düşünceleriniz');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloglar')),
      body: FutureBuilder<List<BlogModel>>(
        future: _blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
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
    );
  }
}
