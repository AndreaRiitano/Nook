import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'booking_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BnbDetail extends StatelessWidget {

  final Map<String, dynamic> bnbData;

  const BnbDetail({super.key, required this.bnbData});

  @override
  Widget build(BuildContext context) {
    print("DEBUG: L'ID del BnB è: ${bnbData['id']}");
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(
              bnbData['immagineUrl'] ?? '',
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: Text(
                          bnbData['titolo'] ?? '',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                          Text(
                            '${bnbData['valutazione']}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),


                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bnbData['indirizzo'] != null
                              ? '${bnbData['indirizzo']}, ${bnbData['citta']}'
                              : bnbData['citta'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 20),


                   Text('ospiti'.i18n(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, color: Colors.black54),
                      const SizedBox(width: 10),
                      Text('spazio'.i18n()+' ${bnbData['ospiti'] ?? 2} '+'ospiti'.i18n(), style: const TextStyle(fontSize: 16)),
                    ],
                  ),

                  //PARTE SULLA DESCRIZIONE DA RIVEDERE DOPO
                  const SizedBox(height: 30),
                   Text('descr'.i18n(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  //descrizione a caso rubata giusto per avere un'idea
                  Text(
                    'Goditi un soggiorno indimenticabile in questa splendida struttura. Posizione perfetta, interni curati nei minimi dettagli e tutto lo spazio di cui hai bisogno per rilassarti.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                  ),


                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  // RECENSIONI
                  Text('recensioni_titolo'.i18n(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  StreamBuilder<QuerySnapshot>(

                    stream: FirebaseFirestore.instance
                        .collection('recensioni')
                        .where('bnbId', isEqualTo: bnbData['id'])
                        .orderBy('data', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          'nessuna_recensione_ancora'.i18n(),
                          style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                        );
                      }

                      var listaRecensioni = snapshot.data!.docs;


                      return Column(
                        children: listaRecensioni.map((doc) {
                          var rec = doc.data() as Map<String, dynamic>;
                          return _buildRecensioneItem(rec);
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

                ],

              ),

            ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 15,
            bottom: 15 + MediaQuery.of(context).padding.bottom
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('prezzo'.i18n(), style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(
                    '€${bnbData['prezzo']} / ' +'n/'.i18n(),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => BookingScreen(
                bnbData: bnbData,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child:  Text('prenota'.i18n(), style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),

    );
  }


  Widget _buildRecensioneItem(Map<String, dynamic> rec) {

    DateTime dataRec = (rec['data'] as Timestamp).toDate();
    String dataFormattata = "${dataRec.day}/${dataRec.month}/${dataRec.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     rec['nomeUtente'] ?? "Ospite",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    dataFormattata,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),

              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (rec['voto'] ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            rec['testo'] ?? '',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}