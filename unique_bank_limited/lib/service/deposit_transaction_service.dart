// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:unique_bank_limited/model/deposit_transaction.dart';
//
//
// class DepositTransactionService {
//   Future<List<DepositTransaction>> getDepositTransactionsByAccountNumberAndDateRange(
//       String accountNumber, DateTime startDate, DateTime endDate) async {
//     final response = await http.get(Uri.parse(
//         'http://your_backend_url/depositTransactions?accountNumber=$accountNumber&startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => DepositTransaction.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load deposit transactions');
//     }
//   }
//
//
// }
