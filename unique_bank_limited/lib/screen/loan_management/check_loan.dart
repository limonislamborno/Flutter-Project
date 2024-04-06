import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckLoanWidget extends StatefulWidget {
  @override
  _CheckLoanWidgetState createState() => _CheckLoanWidgetState();
}

class _CheckLoanWidgetState extends State<CheckLoanWidget> {
  TextEditingController _accountNumberController = TextEditingController();
  Map<String, dynamic> _loanResponse = {};

  Future<void> _checkLoan() async {
    try {
      String accountNumber = _accountNumberController.text;
      final response = await http.post(
        Uri.parse('http://localhost:8086/api/loans/checkLoan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'accountNumber': accountNumber}),
      );

      setState(() {
        if (response.statusCode == 200) {
          _loanResponse = jsonDecode(response.body);
        } else {
          _loanResponse = {'error': 'Failed to check loan status'};
        }
      });
    } catch (error) {
      print('Error checking loan: $error');
      setState(() {
        _loanResponse = {'error': 'Failed to check loan status'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Loan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(labelText: 'Enter Account Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkLoan,
              child: Text('Check Loan'),
            ),
            SizedBox(height: 20),
            if (_loanResponse.isNotEmpty)
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loan Approval Status:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Loan Approved: ${_loanResponse['loanApproved'] ?? false}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Status: ${_loanResponse['status'] ?? 'Unknown'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      if (_loanResponse['loanApproved'] == true)
                        Text(
                          'Loan Details: ${_loanResponse['loanDetails'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(),
          ],
        ),
      ),
    );
  }
}
