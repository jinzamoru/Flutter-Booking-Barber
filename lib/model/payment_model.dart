class PaymentModel {
  String paymentId;
  int paymentAmount;
  DateTime paymentTime;
  String bookingId;
  int paymentStatus;

  PaymentModel(
      {required this.paymentId,
      required this.paymentAmount,
      required this.bookingId,
      required this.paymentTime,
      required this.paymentStatus});
}
