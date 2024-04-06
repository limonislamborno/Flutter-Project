import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FundTransferPage extends StatefulWidget {
  final String fromAccountNumber;

  const FundTransferPage({Key? key, required this.fromAccountNumber}) : super(key: key);
  @override
  State<FundTransferPage> createState() => _FundTransferPageState();
}

class _FundTransferPageState extends State<FundTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fund Transfer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FundTransferForm(fromAccountNumber: '2330014',),
      ),
    );
  }
}

class FundTransferForm extends StatefulWidget {
  final String fromAccountNumber;
  const FundTransferForm({Key? key, required this.fromAccountNumber}) : super(key: key);
  @override
  _FundTransferFormState createState() => _FundTransferFormState();
}

class _FundTransferFormState extends State<FundTransferForm> {
  @override
   void initState() {
       super.initState();
     _fetchAccountDetails(widget.fromAccountNumber);
       _performFundTransfer();// Added this line

}

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _transferAmountController = TextEditingController(); // Add TextEditingController for transfer amount

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _accountNumberController,
            decoration: InputDecoration(labelText: 'To Account Number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the account number';
              }
              return null;
            },
            onChanged: (value) {
              _fetchAccountDetails(value);
            },
          ),
          TextFormField(
            controller: _accountNameController,
            decoration: InputDecoration(labelText: 'Account Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the account name';
              }
              return null;
            },
            enabled: false,
          ),
          TextFormField(
            controller: _accountTypeController,
            decoration: InputDecoration(labelText: 'Account Type'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the account type';
              }
              return null;
            },
            enabled: false,
          ),
          TextFormField(
            controller: _transferAmountController, // Assign controller
            decoration: InputDecoration(labelText: 'Transfer Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the transfer amount';
              }
              return null;
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing Transfer')),
                );
                _performFundTransfer();

              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchAccountDetails(String accountNumber) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8086/api/customers/getAccountInfoByAccountNumber/$accountNumber'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _accountNameController.text = data['accountName'];
          _accountTypeController.text = data['accountType'];
        });
      } else {
        throw Exception('Failed to fetch account details');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error gracefully
    }
  }


  //



  void _performFundTransfer() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8086/api/transfer/submit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fromAccountNumber': widget.fromAccountNumber,
          'toAccountNumber': _accountNumberController.text,
          'transferAmount': double.parse(_transferAmountController.text),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to transfer funds: ${response.statusCode}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to transfer funds: $error')),
      );
    }
  }







}

void main() {
  runApp(MaterialApp(
    home: FundTransferPage(fromAccountNumber: '',),
  ));
}
