import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeoLocatorBehavior {
  /// Ottiene le coordinate GPS e converte in indirizzo testuale (Città, Provincia)
  Future<Map<String, dynamic>> getFullLocation() async {
    try {
      // Gestione dei permessi hardware
      LocationPermission permesso = await Geolocator.checkPermission();
      if (permesso == LocationPermission.denied) {
        permesso = await Geolocator.requestPermission();
        if (permesso == LocationPermission.denied) {
          throw Exception("Permesso GPS negato");
        }
      }

      // Acquisizione delle coordinate tramite sensore
      Position posizione = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      );

      //  Traduzione delle coordinate in dati geografici leggibili
      List<Placemark> indirizzi = await placemarkFromCoordinates(
          posizione.latitude,
          posizione.longitude
      );

      String cittaMostrata = "Posizione sconosciuta";
      if (indirizzi.isNotEmpty) {
        Placemark p = indirizzi.first;
        cittaMostrata = '${p.locality}, ${p.administrativeArea}';
      }

      return {
        'lat': posizione.latitude,
        'lon': posizione.longitude,
        'citta': cittaMostrata,
      };
    } catch (e) {

      rethrow;
    }
  }
}