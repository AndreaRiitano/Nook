
class Bnb {
  final String id;
  final String titolo;
  final String descrizione;
  final int prezzo;
  final double valutazione;
  final String indirizzo;
  final String citta;
  final String imageUrl;
  final double longitudine;
  final double latitudine;


  Bnb({
    required this.id,
    required this.titolo,
    required this.descrizione,
    required this.prezzo,
    required this.valutazione,
    required this.indirizzo,
    required this.citta,
    required this.imageUrl,
    required this.longitudine,
    required this.latitudine
  });


  factory Bnb.fromMap(Map<String, dynamic> map, String documentId) {
    return Bnb(
      id: documentId,
      titolo: map['titolo'] ?? 'N/A',
      descrizione: map['descrizione'] ?? '',
      prezzo: map['prezzo'] ?? 0,
      valutazione: (map['valutazione'] ?? 0.0).toDouble(),
      indirizzo: map['indirizzo'] ?? '',
      citta: map['citta'] ?? '',
      imageUrl: map['immagineUrl'] ?? '',
      longitudine: map['longitudine']??'',
      latitudine: map['latitudine'] ?? ''
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'titolo': titolo,
      'descrizione': descrizione,
      'prezzo': prezzo,
      'valutazione': valutazione,
      'indirizzo': indirizzo,
      'citta': citta,
      'imageUrl': imageUrl,
      'longitudine': longitudine,
      'latitudine': latitudine
    };
  }
}