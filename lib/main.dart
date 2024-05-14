import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'http.dart'; // Import the http.dart file

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  print('API Key Loaded: ${dotenv.env['GOOGLE_BOOKS_API_KEY']}'); // Debugging line
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Buku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookMenu(),
    );
  }
}

class BookMenu extends StatefulWidget {
  const BookMenu({Key? key}) : super(key: key);

  @override
  State<BookMenu> createState() => _BookMenuState();
}

class _BookMenuState extends State<BookMenu> {
  String searchQuery = '';
  List<dynamic> books = [];

  Future<void> fetchBooks() async {
    if (searchQuery.isEmpty) return;
    final fetchedBooks = await BookService.fetchBooks(searchQuery);
    setState(() {
      books = fetchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Buku'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari buku...',
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onSubmitted: (value) {
                fetchBooks();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final title = book['title'] as String;
                final subtitle = book['subtitle'] as String?;
                final authors = book['authors'] as List<dynamic>?;
                final thumbnailUrl = book['imageLinks']?['thumbnail'] as String?;

                return ListTile(
                  leading: thumbnailUrl != null
                      ? Image.network(thumbnailUrl)
                      : const Icon(Icons.book),
                  title: Text(title),
                  subtitle: subtitle != null ? Text(subtitle) : null,
                  onTap: () {
                    // Handle book tap event (e.g., navigate to book details page)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
