
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String bnbId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double prezzoTotale;
  final String titoloBnb;
  final String copertina;

  Booking({
    required this.id,
    required this.bnbId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.prezzoTotale,
    required this.titoloBnb,
    required this.copertina
  });

  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      bnbId: map['bnbId'] ?? '',
      userId: map['userId'] ?? '',
      checkIn: (map['checkIn'] as Timestamp).toDate(),
      checkOut: (map['checkOut'] as Timestamp).toDate(),
      prezzoTotale: (map['prezzoTotale'] ?? 0.0).toDouble(),
      titoloBnb: map['titoloBnb'] ?? 'BnB',
      copertina: map['immagineUrl']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bnbId': bnbId,
      'userId': userId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'prezzoTotale': prezzoTotale,
      'titoloBnb': titoloBnb,
    };
  }
}