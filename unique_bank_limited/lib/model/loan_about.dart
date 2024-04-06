// loan_about.dart

class LoanAbout {
  final int id;
  final double loanAmount;
  final String customerName;
  final String loanType;

  LoanAbout({
    required this.id,
    required this.loanAmount,
    required this.customerName,
    required this.loanType,
  });

  factory LoanAbout.fromJson(Map<String, dynamic> json) {
    return LoanAbout(
      id: json['id'],
      loanAmount: json['loanAmount'].toDouble(),
      customerName: json['customerName'],
      loanType: json['loanType'],
    );
  }
}
