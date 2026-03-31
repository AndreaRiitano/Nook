import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'bnb_detail.dart';
import 'package:localization/localization.dart';

class Explore extends StatefulWidget {

  const Explore({super.key});

  State<Explore> createState() => _ExploreState();
}
class _ExploreState extends State<Explore>{

  //porzione per la geolocalizzazione con geolocator e geocoding
  String? _miaCittaAttuale;
  bool _ricercaPosizione = true; // Rotellina di caricamento iniziale
  //coordinate utente
  double? _miaLatitudine;
  double? _miaLongitudine;
  @override
  void initState() {
    super.initState();
    _trovaPosizioneUtente();
  }

  Future<void> _trovaPosizioneUtente() async {
    try {
      //  Controllo permessi
      LocationPermission permesso = await Geolocator.checkPermission();
      if (permesso == LocationPermission.denied) {
        permesso = await Geolocator.requestPermission();
        if (permesso == LocationPermission.denied) {
          setState(() => _ricercaPosizione = false);
          return; // Permesso negato
        }
      }

      // acquisizione coordinate
      Position posizione = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
          );

      _miaLatitudine = posizione.latitude;
      _miaLongitudine = posizione.longitude;

      // traduzione coordinate usando geocoding
      List<Placemark> indirizzi = await placemarkFromCoordinates(
          posizione.latitude, posizione.longitude);

      if (indirizzi.isNotEmpty) {
        Placemark mioIndirizzo = indirizzi.first;

        String cittaFormattata = '${mioIndirizzo.locality}, ${mioIndirizzo.administrativeArea}';

        setState(() {
          _miaCittaAttuale = cittaFormattata;
          _ricercaPosizione = false;
        });
        //DEBUG
        print("L'utente si trova a: $_miaCittaAttuale");
      }
    } catch (e) {
      print("Errore GPS: $e");
      setState(() => _ricercaPosizione = false);
    }
  }
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.only(bottom: 100), // Spazio extra in fondo per non farci finire sopra la navbar a fine scroll
        children: [
          // Intestazione della pagina
           Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'explore'.i18n(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          // 1° Carosello
          _buildTitoloSezione('pop'.i18n()),
          _buildCaroselloOrizzontale(FirebaseFirestore.instance.collection('bnbs')
              .orderBy('valutazione', descending: true)
              .limit(6)),

          // 2° Carosello
          _buildTitoloSezione('near'.i18n()),
          if (_ricercaPosizione)
            const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()))
          else if (_miaCittaAttuale == null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Attiva il GPS per vedere i BnB vicini a te!'),
            )
          else
            _buildCaroselloVicinanza(),
          // 3° Carosello
          _buildTitoloSezione('Placeholder 3'),
        //  _buildCaroselloOrizzontale(),

          //4° Carosello
          _buildTitoloSezione('Placeholder 4'),
        //  _buildCaroselloOrizzontale(),
        ],
      ),
      )
    );
  }

  // carosello con query come parametro
  Widget _buildCaroselloOrizzontale(Query query) {
    return SizedBox(
      height: 240,
      child: FutureBuilder<QuerySnapshot>(
        future: query.get(),
        builder: (context, snapshot) {

          // per far vedere la rotellina mentre carica
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // in caso di errore
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nessun BnB trovato qui.'));
          }

          // estrazione documento
          var listaBnb = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listaBnb.length,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            itemBuilder: (context, index) {

              var datiBnb = listaBnb[index].data() as Map<String, dynamic>;

              return _buildCard(context, datiBnb);
            },
          );
        },
      ),
    );
  }



  //CARD SINGOLA DEL CAROSELLO
  Widget _buildCard(BuildContext context, Map<String, dynamic> dati) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context)=>BnbDetail(bnbData: dati)
            )
        );

      },
    child: Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // FOTO
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                dati['immagineUrl'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          //  TESTI
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  dati['titolo'] ?? 'Senza titolo',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Città
                Text(
                  dati['citta'] ?? '',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Prezzo e Valutazione sulla stessa riga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '€${dati['prezzo']} / notte',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        Text(
                          '${dati['valutazione']}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildCaroselloVicinanza() {
    return SizedBox(
      height: 240,
      child: FutureBuilder<QuerySnapshot>(

        future: FirebaseFirestore.instance.collection('bnbs').get(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nessun BnB trovato.'));
          }


          var listaBnb = snapshot.data!.docs;

          // riordina in base alla distanza
          listaBnb.sort((a, b) {
            var datiA = a.data() as Map<String, dynamic>;
            var datiB = b.data() as Map<String, dynamic>;

            // in caso manchino le coordinate
            if (datiA['latitudine'] == null || datiB['latitudine'] == null) return 0;

            // calcolo distanza con A
            double distanzaA = Geolocator.distanceBetween(
                _miaLatitudine!, _miaLongitudine!,
                datiA['latitudine'], datiA['longitudine']);

            // calcolo distanza con B
            double distanzaB = Geolocator.distanceBetween(
                _miaLatitudine!, _miaLongitudine!,
                datiB['latitudine'], datiB['longitudine']);

            // Confronto distanza
            return distanzaA.compareTo(distanzaB);
          });

          var bnbPiuVicini = listaBnb.take(6).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bnbPiuVicini.length,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            itemBuilder: (context, index) {
              var datiBnb = bnbPiuVicini[index].data() as Map<String, dynamic>;

              // calcolo della distanza a schermo convertita in km
              double distanzaMetri = Geolocator.distanceBetween(
                  _miaLatitudine!, _miaLongitudine!,
                  datiBnb['latitudine'], datiBnb['longitudine']
              );
              String distanzaKm = (distanzaMetri / 1000).toStringAsFixed(1);


              datiBnb['distanza'] = '$distanzaKm km da te';

              return _buildCard(context, datiBnb);
            },
          );
        },
      ),
    );
  }

  Widget _buildTitoloSezione(String titolo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        titolo,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}