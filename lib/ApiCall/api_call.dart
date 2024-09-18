import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CallApi extends StatefulWidget {
  const CallApi({super.key});

  @override
  State<CallApi> createState() => _CallApiState();
}

class _CallApiState extends State<CallApi> {
  TextEditingController _dateController = TextEditingController();
  String _apiResponse = '';

  _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }


  Future<void> _submitDate() async {
    String selectedDate = _dateController.text;
    if (selectedDate.isEmpty) {
      setState(() {
        _apiResponse = 'Please select a date.';
      });
      return;
    }

    String apiUrl = 'https://api.nasa.gov/planetary/apod?api_key=18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng&date=2024-08-10$selectedDate';

    try {
      var response = await http.get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng&date=2024-08-10'));
      if (response.statusCode == 200) {
        setState(() {
          _apiResponse = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          _apiResponse = 'Failed to load data.';
        });
      }
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDate,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            const Text('API Response:'),
            Text(_apiResponse),
          ],
        ),
      ),
    );
  }
}
