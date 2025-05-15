import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuoteGeneration extends StatefulWidget {
  const QuoteGeneration({Key? key}) : super(key: key);

  @override
  _QuoteGenerationState createState() => _QuoteGenerationState();
}

class _QuoteGenerationState extends State<QuoteGeneration> {
  String? _quote;
  String? _author;
  bool _isLoading = false;

  Future<void> fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random?tags=books'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _quote = data['content'];
          _author = data['author'];
        });
      } else {
        setState(() {
          _quote = 'Failed to fetch quote.';
          _author = '';
        });
      }
    } catch (e) {
      setState(() {
        _quote = 'Error occurred: $e';
        _author = '';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote(); // Fetch a quote on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _quote ?? 'Click below to generate a quote',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _author != null ? '- $_author' : '',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: fetchQuote,
                    child: const Text('Generate Quote'),
                  ),
                ],
              ),
      ),
    );
  }
}
