import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String accountNumber;

  const ProfilePage({Key? key, required this.accountNumber}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _customerData = {};

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8086/api/customers/getCustomerByAccountNumber/${widget.accountNumber}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _customerData = data;
        });
      } else {
        throw Exception('Failed to fetch customer data');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _customerData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: _customerData.entries.map((entry) {
            return Card(
              child: ListTile(
                title: Text(
                  '${entry.key}:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(entry.value.toString()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}