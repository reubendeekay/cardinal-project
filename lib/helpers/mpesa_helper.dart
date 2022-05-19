import 'package:mpesa/mpesa.dart';

Mpesa mpesa = Mpesa(
  clientKey: "w0sP3rGGfdTVDcpuAk4ADect3pFARVNU",
  clientSecret: "6hPJz5IEtxfv1X4E",
  passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
  environment: "sandbox",
);

Future<void> mpesaPayment({String? phone, double? amount}) async {
  await mpesa.lipaNaMpesa(
      phoneNumber: phone!,
      amount: amount!,
      accountReference: 'RentScape',
      businessShortCode: "174379",
      callbackUrl: "https://my-json-server.typicode.com/");
  // .catchError((error) {});
}
