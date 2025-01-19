import 'package:url_launcher/url_launcher.dart';

class GoogleMaps {
  GoogleMaps();

  static Future<void> openGoogleMaps(double latitude, double longitude) async {

    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final Uri uri = Uri.parse(googleMapsUrl);

    try {
      final bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri);
      } else {
        throw 'Could not open Google Maps. Please check your device settings or internet connection.';
      }
    } catch (e) {
      throw 'An error occurred while opening Google Maps: $e';
    }
  }
}
