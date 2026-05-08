import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/Bnb.dart';
import 'package:nook/model/objects/Review.dart';
import 'package:nook/UI/widgets/ReviewTile.dart';
import 'BookingScreen.dart';

class BnbDetail extends StatelessWidget {
  final Bnb bnb;

  const BnbDetail({super.key, required this.bnb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
            // Immagine di Copertina
            Image.network(
              bnb.imageUrl,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 350, color: Colors.grey, child: const Center(child: Icon(Icons.broken_image, size: 50))),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo e Valutazione
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bnb.titolo,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                          Text(
                            '${bnb.valutazione}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Indirizzo
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${bnb.indirizzo}, ${bnb.citta}',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Ospiti
                  Text('ospiti'.i18n(), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                       Icon(Icons.people_outline, color: Theme.of(context).colorScheme.onSurface),
                      const SizedBox(width: 10),
                      Text('${'spazio'.i18n()} 2 ${'ospiti'.i18n()}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Descrizione
                  Text('descr'.i18n(), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Text(
                    bnb.descrizione.isNotEmpty ? bnb.descrizione : 'Goditi un soggiorno indimenticabile...',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface, height: 1.5),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Sezione Recensioni
                  Text('recensioni_titolo'.i18n(), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),


                  StreamBuilder<List<Review>>(
                    stream: DatabaseManager().getReviewsForBnb(bnb.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            'nessuna_recensione_ancora'.i18n(),
                            style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                          ),
                        );
                      }

                      final listaRecensioni = snapshot.data!;

                      return Column(

                        children: listaRecensioni.map((rec) => ReviewTile(review: rec)).toList(),
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
      bottomNavigationBar: _buildBottomBar(context),
    );
  }


  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 15,
          bottom: 15 + MediaQuery.of(context).padding.bottom
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).hintColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('prezzo'.i18n(), style: const TextStyle(color: Colors.grey, fontSize: 14)),
              Text('€${bnb.prezzo} / ${'n/'.i18n()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(bnb: bnb),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('prenota'.i18n(), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}