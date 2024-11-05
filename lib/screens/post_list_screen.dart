import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'post_form_screen.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService apiService = ApiService();
  List<Post> _postsList = [];
  int _selectedIndex = 0; // Menyimpan indeks navigasi yang dipilih

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
    final posts = await apiService.getPosts();
    setState(() {
      _postsList = posts;
    });
  }

  // Fungsi untuk menghapus posting secara lokal
  void _deletePost(int id) async {
    try {
      await apiService.deletePost(id);
      setState(() {
        _postsList.removeWhere((post) => post.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus post: $e')),
      );
    }
  }

  // Fungsi untuk menambahkan postingan baru secara lokal
  void _addPost(Post post) async {
    try {
      final newPost = await apiService.createPost(post);
      setState(() {
        _postsList.insert(0, newPost);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post berhasil ditambahkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan post: $e')),
      );
    }
  }

  // Fungsi untuk memperbarui posting secara lokal
  void _updatePost(Post updatedPost) async {
    try {
      await apiService.updatePost(updatedPost.id, updatedPost);
      setState(() {
        int index = _postsList.indexWhere((post) => post.id == updatedPost.id);
        if (index != -1) {
          _postsList[index] = updatedPost;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui post: $e')),
      );
    }
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      // Jika indeks ke-1 dipilih, buka PostFormScreen
      final newPost = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostFormScreen()),
      );
      if (newPost != null) {
        _addPost(newPost); // Tambahkan postingan baru
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: _postsList.length,
        itemBuilder: (context, index) {
          final post = _postsList[index];
          return ListTile(
            title: Text(post.title),
            onTap: () async {
              final editedPost = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostFormScreen(post: post),
                ),
              );
              if (editedPost != null) {
                _updatePost(editedPost); // Perbarui data posting
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hapus Postingan'),
                      content: Text(
                          'Apakah Anda yakin ingin menghapus postingan ini?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deletePost(post.id);
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Perbarui indeks yang dipilih
          });
          _onItemTapped(index); // Panggil fungsi untuk menangani klik
        },
      ),
    );
  }
}
