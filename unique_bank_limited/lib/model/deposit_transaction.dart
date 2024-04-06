// class DepositTransaction {
//   final int did;
//   final String accountNumber;
//   final String firstName;
//   final String accountType;
//   final int dAmount;
//   final int customerId;
//   final DateTime depositTime;
//
//   DepositTransaction({
//     required this.did,
//     required this.accountNumber,
//     required this.firstName,
//     required this.accountType,
//     required this.dAmount,
//     required this.customerId,
//     required this.depositTime,
//   });
//
//   factory DepositTransaction.fromJson(Map<String, dynamic> json) {
//     return DepositTransaction(
//       did: json['did'],
//       accountNumber: json['accountNumber'],
//       firstName: json['firstName'],
//       accountType: json['accountType'],
//       dAmount: json['dAmount'],
//       customerId: json['customerId'],
//       depositTime: DateTime.parse(json['depositTime']),
//     );
//   }
// }
