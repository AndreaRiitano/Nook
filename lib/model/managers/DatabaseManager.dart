import 'package:cloud_firestore/cloud_firestore.dart';
import '../objects/Bnb.dart';
import '../objects/Booking.dart';
import '../objects/Review.dart';
import 'package:geolocator/geolocator.dart';
import '../objects/UserNook.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();




  /// Recupera tutti i BnB per la schermata Explore
  Stream<List<Bnb>> getAllBnbs() {
    return _firestore.collection('bnbs').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Bnb.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Ricerca BnB per città
  Future<List<Bnb>> searchBnbsByCity(String city) async {
    final query = await _firestore
        .collection('bnbs')
        .where('citta', isEqualTo: city)
        .get();

    return query.docs
        .map((doc) => Bnb.fromMap(doc.data(), doc.id))
        .toList();
  }



  /// Recupera le prenotazioni di uno specifico utente
  Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('prenotazioni')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }


  /// Crea una nuova prenotazione nel database
  Future<void> creaPrenotazione(Booking prenotazione) async {


    final utenteAttuale = FirebaseAuth.instance.currentUser;
    if (utenteAttuale == null) throw Exception("Errore: utente non loggato.");


    await _firestore.collection('prenotazioni').add({
      'bnbId': prenotazione.bnbId,
      'checkIn': Timestamp.fromDate(prenotazione.checkIn),
      'checkOut': Timestamp.fromDate(prenotazione.checkOut),
      'dataPrenotazione': FieldValue.serverTimestamp(),
      'haRecensito': false,
      'immagineBnb': prenotazione.copertina,
      'prezzoTotale': prenotazione.prezzoTotale,
      'stato': "confermata",
      'titoloBnb': prenotazione.titoloBnb,
      'userId': utenteAttuale.uid,
    });
  }

  /// Cancella una prenotazione
  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('prenotazioni').doc(bookingId).delete();
  }



  /// Recupera le recensioni per un bnb specifico
  Stream<List<Review>> getReviewsForBnb(String bnbId) {
    return _firestore
        .collection('recensioni')
        .where('bnbId', isEqualTo: bnbId)
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Aggiunge una nuova recensione
  Future<void> addReview(Review review) async {
    await _firestore.collection('recensioni').add(review.toMap());
  }


  /// Recupera i BnB più popolari
  Future<List<Bnb>> getPopularBnbs({int limit = 6}) async {
    final query = await _firestore
        .collection('bnbs')
        .orderBy('valutazione', descending: true)
        .limit(limit)
        .get();

    return query.docs.map((doc) => Bnb.fromMap(doc.data(), doc.id)).toList();
  }

  /// Recupera i BnB ordinati per distanza dall'utente
  Future<List<Bnb>> getNearbyBnbs(double userLat, double userLon, {int limit = 6}) async {
    final query = await _firestore.collection('bnbs').get();

    List<Bnb> allBnbs = query.docs.map((doc) => Bnb.fromMap(doc.data(), doc.id)).toList();


    allBnbs.sort((a, b) {

      double distA = Geolocator.distanceBetween(userLat, userLon, a.latitudine, a.longitudine);
      double distB = Geolocator.distanceBetween(userLat, userLon, b.latitudine, b.longitudine);
      return distA.compareTo(distB);
    });

    return allBnbs.take(limit).toList();
  }


  /// Logica di ricerca centralizzata: include ricerca testo, fallback e ordinamento
  Future<List<Bnb>> searchBnbs({
    required String query,
    required String ordinamento,
  }) async {

    final snapshot = await _firestore.collection('bnbs').get();
    List<Bnb> tuttiIBnb = snapshot.docs
        .map((doc) => Bnb.fromMap(doc.data(), doc.id))
        .toList();

    String q = query.toLowerCase().trim();

    //  Filtro per titolo o città
    List<Bnb> risultati = tuttiIBnb.where((bnb) {
      return bnb.titolo.toLowerCase().contains(q) ||
          bnb.citta.toLowerCase().contains(q);
    }).toList();

    //  Logica di Fallback (se non trova nulla, restituisce i migliori 5)
    if (risultati.isEmpty) {
      tuttiIBnb.sort((a, b) => b.valutazione.compareTo(a.valutazione));
      return tuttiIBnb.take(5).toList();
    }

    // Applicazione Ordinamento
    switch (ordinamento) {
      case 'prezzo_cresc':
        risultati.sort((a, b) => a.prezzo.compareTo(b.prezzo));
        break;
      case 'prezzo_decr':
        risultati.sort((a, b) => b.prezzo.compareTo(a.prezzo));
        break;
      case 'migliori_voti':
        risultati.sort((a, b) => b.valutazione.compareTo(a.valutazione));
        break;
    }

    return risultati;
  }


  Stream<UserNook> getUserData(String email) {
    return _firestore.collection('utenti').doc(email).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception("Utente non trovato");
      }
      return UserNook.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }


  Future<void> registerNewUser(UserNook user, String password) async {
    //  Creazione account su FirebaseAuth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    //  Salvataggio dati estesi su Firestore
    await _firestore.collection('utenti').doc(user.email).set({
      'UID': credential.user!.uid,
      'nome': user.nome,
      'cognome': user.cognome,
      'email': user.email,
      'dataDiNascita': user.dataDiNascita,
      'genere': user.genere,
      'dataCreazioneAccount': FieldValue.serverTimestamp(),
    });
  }

  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
  // --- UTENTI ---

  /// Recupera il nome e cognome di un utente cercando all'interno del campo 'userId'
  Future<String> getNomeUtenteById(String targetUserId) async {

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('utenti')
          .where('UID', isEqualTo: targetUserId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {


        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;


        String nome = data['nome'] ?? '';
        String cognome = data['cognome'] ?? '';

        if (nome.isEmpty && cognome.isEmpty) {
          return "Senza Nome";
        }

        return "$nome $cognome".trim();
      } else {
      }
    } catch (e) {
    }
    return "Utente"; // Fallback di sicurezza
  }
  /// Recupera il nome e cognome di un utente partendo dalla sua EMAIL
  Future<String> getNomeUtenteByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('utenti')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();


      if (querySnapshot.docs.isNotEmpty) {


        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;


        String nome = data['nome'] ?? '';
        String cognome = data['cognome'] ?? '';

        if (nome.isEmpty && cognome.isEmpty) {
          return "Senza Nome";
        }

        return "$nome $cognome".trim();
      } else {

      }
    } catch (e) {

    }

    return "Utente"; // Fallback se non lo trova
  }


  /// Salva una nuova recensione e aggiorna lo stato della prenotazione
  Future<void> inviaRecensionePerPrenotazione({
    required String bnbId,
    required String prenotazioneId,
    required int voto,
    required String testo,
  }) async {
    final utenteAttuale = FirebaseAuth.instance.currentUser;
    if (utenteAttuale == null) throw Exception("Utente non loggato");

    String nomeDaSalvare = "Viaggiatore";

    // Recupero il nome reale dell'utente
    try {
      var userDoc = await _firestore.collection('utenti').doc(utenteAttuale.email).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String nome = userData['nome'] ?? '';
        String cognome = userData['cognome'] ?? '';
        if (nome.isNotEmpty || cognome.isNotEmpty) {
          nomeDaSalvare = "$nome $cognome".trim();
        }
      }
    } catch (e) {
      print("Errore nel recupero dati utente: $e");

    }

    // Salvo la recensione
    await _firestore.collection('recensioni').add({
      'bnbId': bnbId,
      'prenotazioneId': prenotazioneId,
      'userId': utenteAttuale.uid,
      'nomeUtente': nomeDaSalvare,
      'voto': voto,
      'testo': testo,
      'data': FieldValue.serverTimestamp(),
    });

    //  Aggiorno la prenotazione segnando che è stata recensita
    await _firestore.collection('prenotazioni').doc(prenotazioneId).update({
      'haRecensito': true,
    });
  }

  /// Recupera lo stream delle prenotazioni dell'utente loggato, ordinate dalla più recente
  Stream<List<Map<String, dynamic>>> getLeMiePrenotazioni() {
    final uid = FirebaseAuth.instance.currentUser?.uid;


    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('prenotazioni')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {

      var lista = snapshot.docs.map((doc) {
        var dati = doc.data();
        dati['idPrenotazione'] = doc.id;
        return dati;
      }).toList();


      lista.sort((a, b) {
        var dataA = a['dataPrenotazione'] as Timestamp?;
        var dataB = b['dataPrenotazione'] as Timestamp?;
        if (dataA == null || dataB == null) return 0;
        return dataB.compareTo(dataA);
      });

      return lista;
    });
  }

  /// Recupera la recensione specifica di una prenotazione
  Future<Map<String, dynamic>?> getRecensioneByPrenotazione(String prenotazioneId) async {
    try {
      var snapshot = await _firestore
          .collection('recensioni')
          .where('prenotazioneId', isEqualTo: prenotazioneId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var dati = snapshot.docs.first.data();
        dati['id'] = snapshot.docs.first.id;
        return dati;
      }
    } catch (e) {
      print("Errore nel recupero della recensione: $e");
    }
    return null;
  }

  /// Aggiorna una recensione esistente
  Future<void> modificaRecensione({
    required String recensioneId,
    required int nuovoVoto,
    required String nuovoTesto,
  }) async {
    await _firestore.collection('recensioni').doc(recensioneId).update({
      'voto': nuovoVoto,
      'testo': nuovoTesto,
      'data': FieldValue.serverTimestamp(),
    });
  }

  /// Elimina una recensione e sblocca di nuovo la prenotazione
  Future<void> eliminaRecensione({
    required String recensioneId,
    required String prenotazioneId,
  }) async {
    await _firestore.collection('recensioni').doc(recensioneId).delete();

    await _firestore.collection('prenotazioni').doc(prenotazioneId).update({
      'haRecensito': false,
    });
  }
}