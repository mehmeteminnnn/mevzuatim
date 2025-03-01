import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mevzuatim/models/blog_model.dart';
import 'package:mevzuatim/models/blog_yorum.dart';
import 'package:mevzuatim/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:mevzuatim/services/storage_service.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final int yorumSayisi;
  PostDetailScreen(
      {super.key, required this.postId, required this.yorumSayisi});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<List<BlogYorum>> _yorumlar;
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storService = StorageService();

  @override
  void initState() {
    super.initState();
    _yorumlar =
        _firestoreService.getYorumlar(widget.postId); // Yorumları başlatıyoruz
    debugPrint("Gelen blogId: ${widget.postId}");
  }

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
            _buildPost(_firestoreService.getBlogByID(widget.postId)), // Gönderi

            // Yorumlar Bölümü
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Yorumlar (${widget.yorumSayisi})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Yorum Listesi
                  FutureBuilder<List<BlogYorum>>(
                    future: _yorumlar,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Yorumlar yüklenemedi.'));
                      }

                      final yorumlar = snapshot.data ?? [];
                      return Column(
                        children: yorumlar.map((yorum) {
                          return Column(
                            children: [
                              _buildComment(yorum.kullaniciAdi, yorum.yorum,
                                  yorum.tarih as Timestamp),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      );
                    },
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

  Widget _buildComment(String name, String comment, Timestamp time) {
    // Timestamp'i DateTime'a çeviriyoruz
    DateTime date = time.toDate();

    // DateTime'ı istediğiniz formatta string'e çeviriyoruz
    String formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(date);

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
                  ],
                ),
              ),
              Text(
                date
                    .toLocal()
                    .toString()
                    .substring(0, 10), // Formatlanmış zaman
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

  Widget _buildPost(Future<BlogModel?> blogFuture) {
    return FutureBuilder<BlogModel?>(
      future: blogFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gönderi yüklenemedi.'));
        }

        final blog = snapshot.data;
        if (blog == null) {
          return const Center(child: Text('Gönderi bulunamadı.'));
        }

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
                      future: _firestoreService
                          .getUserIdFromEmail(blog.yazar)
                          .then((userId) =>
                              _storService.getUserPhotoByName(userId!)),
                      builder: (context, snapshot) {
                        // Yükleniyor göstergesi
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          future: _firestoreService
                              .getUserNameFromEmail(blog.yazar),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('');
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Text('');
                            }
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(blog.tarih),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  blog.baslik,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                HtmlWidget(blog.icerik ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
