import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unique_bank_limited/screen/transaction/deposit_transaction_history.dart';
import 'package:unique_bank_limited/screen/fund_transfer.dart';
import 'package:unique_bank_limited/screen/loan_management/apply_loan.dart';
import 'package:unique_bank_limited/screen/loan_management/check_loan.dart';
import 'package:unique_bank_limited/screen/loan_management/loan_package_list.dart';
import 'package:unique_bank_limited/screen/profile_page.dart';
import 'package:unique_bank_limited/screen/transaction/withdraw_transaction_history.dart';
import 'package:unique_bank_limited/screen/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fromAccountNumber = '';
  String _accountNumber = '';
  String _accountName = '';
  String _email = '';
  String _currentBalance = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchAccountInfo();
    });
  }

  Future<void> _fetchAccountInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String? email = user.email;

        if (email != null) {
          final response = await http.get(Uri.parse('http://localhost:8086/api/customers/accountInfo/$email'));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            setState(() {
              _accountNumber = data['accountNumber'];
              _accountName = data['accountName'];
              _email = data['email'];
              _currentBalance = data['current_balence'];
            });
            return;
          }
          throw Exception('Failed to fetch account information: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // Function to handle logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchAccountInfo,
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerContent(
          onDrawerOpened: _fetchAccountInfo,
          accountName: _accountName,
          accountNumber: _accountNumber,
          email: _email,
          currentBalance: _currentBalance,
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: [
              // Add your image URLs here
              'https://th.bing.com/th?id=OIP.s99Ca_1Xo87QTYv1DcoVTgHaEo&w=316&h=197&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',
              'https://th.bing.com/th/id/R.bdd70330ac247b6d2bc7e17bfc259c21?rik=9tzy96NcJQFw1g&pid=ImgRaw&r=0',
              'https://th.bing.com/th/id/R.b8e9adc0b582ca0cdf83c5730cd1ff10?rik=5MsGoekkMdeRnQ&pid=ImgRaw&r=0',
            ].map((String imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Expanded(
            child: Center(
              child: Text('Welcome to the Home Page!',style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,

              ),),


            ),
          ),
        ],
      ),
    );
  }
}

class DrawerContent extends StatefulWidget {
  final VoidCallback? onDrawerOpened;
  final String accountName;
  final String accountNumber;
  final String email;
  final String currentBalance;

  const DrawerContent({
    Key? key,
    this.onDrawerOpened,
    required this.accountName,
    required this.accountNumber,
    required this.email,
    required this.currentBalance,
  }) : super(key: key);

  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  void initState() {
    super.initState();
    if (widget.onDrawerOpened != null) {
      widget.onDrawerOpened!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.accountName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Account Number: ${widget.accountNumber}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Email: ${widget.email}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.white),
                  Text(
                    '${widget.currentBalance}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(accountNumber: widget.accountNumber),
              ),
            );
          },
        ),
        ExpansionTile(
          leading: Icon(Icons.monetization_on),
          title: Text('Transaction'),
          children: [
            ListTile(
              title: Text('Fund Transfer'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FundTransferPage(fromAccountNumber: widget.accountNumber),

                  ),
                );
              },
            ),
            ListTile(
              title: Text('Payment'),
              onTap: () {
                // Handle tap on Payment
              },
            ),
            ListTile(
              title: Text('Mobile Recharge'),
              onTap: () {

                // Handle tap on Mobile Recharge
              },
            ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.history),
          title: Text('Transaction History'),
          children: [
            ListTile(
              title: Text('Deposit Transaction'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepositTransactionHistoryPage(accountNumber: widget.accountNumber),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Withdraw Transaction'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawTransactionHistoryPage(accountNumber: widget.accountNumber),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Transfer Transaction'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepositTransactionHistoryPage(accountNumber: widget.accountNumber),
                  ),
                );
              },
            ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.account_balance),
          title: Text('Loan Management'),
          children: [
            ListTile(
              title: Text('Loan Package'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoanPackageListWidget()));
              },
            ),
            ListTile(
              title: Text('Apply Loan'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoanApplicationForm()));
              },
            ),
            ListTile(
              title: Text('Loan Approval'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckLoanWidget()));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class LoanPackageListWidget extends StatefulWidget {
  @override
  State<LoanPackageListWidget> createState() => _LoanPackageListWidgetState();
}

class _LoanPackageListWidgetState extends State<LoanPackageListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Package List'),
      ),
      body: Center(
        child: Text('Loan Package List Screen'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(

    ),
  ));
}
