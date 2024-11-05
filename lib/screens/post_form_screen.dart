import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;

  PostFormScreen({this.post});

  @override
  _PostFormScreenState createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final post = Post(id: widget.post?.id ?? 0, title: _titleController.text, body: _bodyController.text);
      if (widget.post == null) {
        // Jika postingan baru, kembalikan postingan baru ke PostListScreen
        Navigator.pop(context, post);
      } else {
        // Jika sedang edit, kembalikan data yang diperbarui
        Navigator.pop(context, post);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Tambah Post' : 'Edit Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Masukkan judul' : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Body'),
                validator: (value) => value!.isEmpty ? 'Masukkan isi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.post == null ? 'Tambah' : 'Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
