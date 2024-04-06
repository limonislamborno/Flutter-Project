import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepositTransactionHistoryPage extends StatefulWidget {
  final String accountNumber;

  const DepositTransactionHistoryPage({Key? key, required this.accountNumber}) : super(key: key);

  @override
  _DepositTransactionHistoryPageState createState() => _DepositTransactionHistoryPageState();
}

class _DepositTransactionHistoryPageState extends State<DepositTransactionHistoryPage> {
  List<dynamic> _transactionHistory = [];
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Default dates: 30 days ago as start date and today as end date
    _startDate = DateTime.now().subtract(Duration(days: 30));
    _endDate = DateTime.now();
    _fetchTransactionHistory();
  }

  Future<void> _fetchTransactionHistory() async {
    try {
      // Fetch deposit transaction history from backend API
      final response = await http.get(Uri.parse('http://localhost:8086/api/deposit/transaction-history?accountNumber=${widget.accountNumber}&startDate=$_startDate&endDate=$_endDate'));

      if (response.statusCode == 200) {
        setState(() {
          _transactionHistory = json.decode(response.body);
        });
        return;
      } else {
        throw Exception('Failed to fetch transaction history: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error gracefully (e.g., display a snackbar or toast message)
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _fetchTransactionHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Transaction History'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey[50],
            padding: EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDateButton('Start Date', _startDate, true),
                  _buildDateButton('End Date', _endDate, false),
                ],
              ),
            ),
          ),
          Expanded(
            child: _transactionHistory.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _transactionHistory.length,
              itemBuilder: (context, index) {
                final transaction = _transactionHistory[index];
                return _buildTransactionCard(transaction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label + ': ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              date.toString().substring(0, 10),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          'Amount: ${transaction['dAmount']}',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          'Date: ${transaction['depositTime']}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
