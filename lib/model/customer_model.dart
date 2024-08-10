class CustomerInfo {
  final String customerId;
  final String customerFirstName;
  final String customerLastName;
  final String customerEmail;
  final String customerPhone;
  final String customerPassword;

  CustomerInfo(
      {required this.customerId,
      required this.customerFirstName,
      required this.customerLastName,
      required this.customerEmail,
      required this.customerPhone,
      required this.customerPassword});
}

class LocationInfo {
  final String locationId;
  final String locationName;
  final double locationLatitude;
  final double locationLongitude;
  final String locationCusId;

  LocationInfo(
   {required this.locationId,
      required this.locationName,
      required this.locationLatitude,
      required this.locationLongitude,
      required this.locationCusId,
      }
  );
}
