import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String bnbId;
  final String userId;
  final String? prenotazioneId;
  final String utenteNome;
  final double valutazione;
  final String commento;
  final DateTime data;

  Review({
    required this.id,
    required this.bnbId,
    required this.userId,
    this.prenotazioneId,
    this.utenteNome = 'Ospite',
    required this.valutazione,
    required this.commento,
    required this.data,
  });


  factory Review.fromMap(Map<String, dynamic> data, String documentId) {
    return Review(
      id: documentId,
      bnbId: data['bnbId'] ?? '',
      userId: data['userId'] ?? '',
      prenotazioneId: data['prenotazioneId'],


      valutazione: (data['voto'] ?? 0).toDouble(),


      commento: data['testo'] ?? '',

      data: (data['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'bnbId': bnbId,
      'userId': userId,
      'prenotazioneId': prenotazioneId,
      'voto': valutazione,
      'testo': commento,
      'data': FieldValue.serverTimestamp(),
    };
  }
}