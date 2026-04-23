import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {

  final Map<String, dynamic> bnbData;

  const BookingScreen({super.key, required this.bnbData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? _dateSelezionate;
  bool _staPrenotando = false;

  // CALENDARIO
  Future<void> _selezionaDate() async {
    final DateTimeRange? dateScelte = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'seleziona_date'.i18n(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateScelte != null) {
      setState(() {
        _dateSelezionate = dateScelte;
      });
    }
  }

  //per salvare su firebase
  Future<void> _confermaPrenotazione(int prezzoTotale) async {
    setState(() { _staPrenotando = true; });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('prenotazioni').add({

        'bnbId': widget.bnbData['id'],

        'userId': userId,
        'titoloBnb': widget.bnbData['titolo'],
        'immagineBnb': widget.bnbData['immagineUrl'],
        'checkIn': _dateSelezionate!.start,
        'checkOut': _dateSelezionate!.end,
        'prezzoTotale': prezzoTotale,
        'dataPrenotazione': FieldValue.serverTimestamp(),
        'stato': 'confermata',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('prenotazione_confermata'.i18n()),
              backgroundColor: Colors.green
          ),
        );
        // doppio pop per chiudere sia checkout che dettagli
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print("Errore prenotazione: $e");
    } finally {
      if (mounted) setState(() { _staPrenotando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcolo giorni e prezzo
    int notti = _dateSelezionate != null
        ? _dateSelezionate!.end.difference(_dateSelezionate!.start).inDays
        : 0;
    if (notti == 0 && _dateSelezionate != null) notti = 1;

    int prezzoTotale = (widget.bnbData['prezzo'] as int) * (notti > 0 ? notti : 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'richiesta_prenotazione'.i18n(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RIEPILOGO
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.bnbData['immagineUrl'] ?? '',
                    width: 100,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bnbData['titolo'] ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' ${widget.bnbData['valutazione']}'),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              child: Divider(),
            ),

            // DATE
            Text('il_tuo_viaggio'.i18n(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('date'.i18n(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      _dateSelezionate == null
                          ? 'aggiungi_date_soggiorno'.i18n()
                          : '${_dateSelezionate!.start.day}/${_dateSelezionate!.start.month} - ${_dateSelezionate!.end.day}/${_dateSelezionate!.end.month}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _selezionaDate,
                  child: Text(
                    _dateSelezionate == null ? 'aggiungi'.i18n() : 'modifica'.i18n(),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              child: Divider(),
            ),

            // DETTAGLI PREZZO
            Text('dettagli_prezzo'.i18n(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            if (_dateSelezionate == null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(child: Text('aggiungi_date_info'.i18n(), style: const TextStyle(color: Colors.grey))),
                  ],
                ),
              )
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('€${widget.bnbData['prezzo']} x $notti ${'notti_plurale'.i18n()}', style: const TextStyle(fontSize: 16)),
                  Text('€$prezzoTotale', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('totale_eur'.i18n(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('€$prezzoTotale', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ]
          ],
        ),
      ),

      // BOTTONE CONFERMA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: (_staPrenotando || _dateSelezionate == null)
                ? null
                : () => _confermaPrenotazione(prezzoTotale),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _staPrenotando
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('conferma_paga'.i18n(), style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}