import 'package:flutter/material.dart';

class LoanApplicationForm extends StatefulWidget {
  @override
  _LoanApplicationFormState createState() => _LoanApplicationFormState();
}

class _LoanApplicationFormState extends State<LoanApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _personalNumber = '';
  String _gender = '';
  String _dateOfBirth = '';
  String _loanType = '';
  String _loanAmount = '';
  String _loanTerm = '';
  String _professionType = '';
  String _presentAddress = '';
  String _permanentAddress = '';
  String _stateCode = '';
  String _postcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Application Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _fullName = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation logic if needed
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Personal Number'),
                onChanged: (value) {
                  setState(() {
                    _personalNumber = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                onChanged: (value) {
                  setState(() {
                    _dateOfBirth = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Type'),
                onChanged: (value) {
                  setState(() {
                    _loanType = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _loanAmount = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Term'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _loanTerm = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Profession Type'),
                onChanged: (value) {
                  setState(() {
                    _professionType = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Present Address'),
                onChanged: (value) {
                  setState(() {
                    _presentAddress = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Permanent Address'),
                onChanged: (value) {
                  setState(() {
                    _permanentAddress = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'State Code'),
                onChanged: (value) {
                  setState(() {
                    _stateCode = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Postcode'),
                onChanged: (value) {
                  setState(() {
                    _postcode = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process form data
                    // For example, you can send the data to your backend API
                    print('Form submitted');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoanApplicationForm(),
  ));
}
