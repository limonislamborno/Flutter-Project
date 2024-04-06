import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoanPackageListWidget extends StatefulWidget {
  @override
  _LoanPackageListWidgetState createState() => _LoanPackageListWidgetState();
}

class _LoanPackageListWidgetState extends State<LoanPackageListWidget> {
  List<LoanAbout> _loanAboutList = [];

  @override
  void initState() {
    super.initState();
    _fetchLoanAboutList();
  }

  Future<void> _fetchLoanAboutList() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8086/api/loanabout/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _loanAboutList = data.map((item) => LoanAbout.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load loan package list');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Package List'),
      ),
      body: ListView.builder(
        itemCount: _loanAboutList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Loan Amount: ${_loanAboutList[index].loanAmount}'),
            subtitle: Text('Customer Name: ${_loanAboutList[index].customerName}'),
            // Add more details as needed
          );
        },
      ),
    );
  }
}

class LoanAbout {
  final int id;
  final double loanAmount;
  final String customerName;

  LoanAbout({
    required this.id,
    required this.loanAmount,
    required this.customerName,
  });

  factory LoanAbout.fromJson(Map<String, dynamic> json) {
    return LoanAbout(
      id: json['id'],
      loanAmount: json['loanAmount'].toDouble(),
      customerName: json['customerName'],
    );
  }
}
