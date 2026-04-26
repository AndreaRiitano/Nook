import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';

class BookingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> datiPrenotazione;
  final String prenotazioneId;

  const BookingDetailScreen({super.key, required this.datiPrenotazione, required this.prenotazioneId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  int _votoSelezionato = 5;
  final TextEditingController _recensioneController = TextEditingController();
  bool _staInviando = false;
  bool _haRecensito = false;

  @override
  void initState() {
    super.initState();

    _haRecensito = widget.datiPrenotazione['haRecensito'] ?? false;
  }


  Future<void> _inviaRecensione() async {
    if (_recensioneController.text.trim().isEmpty) return;

    setState(() => _staInviando = true);

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final utenteAttuale = FirebaseAuth.instance.currentUser!;
      String nomeDaSalvare = "Viaggiatore";

      var userDoc = await FirebaseFirestore.instance.collection('utenti').doc(utenteAttuale.email).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String nome = userData['nome'] ?? '';
        String cognome = userData['cognome'] ?? '';

        if (nome.isNotEmpty || cognome.isNotEmpty) {
          nomeDaSalvare = "$nome $cognome".trim();
        }
      }


      await FirebaseFirestore.instance.collection('recensioni').add({
        'bnbId': widget.datiPrenotazione['bnbId'],
        'prenotazioneId': widget.prenotazioneId,
        'userId': userId,
        'nomeUtente': nomeDaSalvare,
        'voto': _votoSelezionato,
        'testo': _recensioneController.text.trim(),
        'data': FieldValue.serverTimestamp(),
      });


      await FirebaseFirestore.instance.collection('prenotazioni').doc(widget.prenotazioneId).update({
        'haRecensito': true,
      });

      if (mounted) {
        setState(() {
          _staInviando = false;
          _haRecensito = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('recensione_inviata'.i18n()), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Errore recensione: $e");
      if (mounted) setState(() => _staInviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime checkIn = (widget.datiPrenotazione['checkIn'] as Timestamp).toDate();
    DateTime checkOut = (widget.datiPrenotazione['checkOut'] as Timestamp).toDate();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'dettagli_prenotazione'.i18n(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RIEPILOGO
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.datiPrenotazione['immagineBnb'] ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.datiPrenotazione['titoloBnb'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${'dal'.i18n()} ${checkIn.day}/${checkIn.month}/${checkIn.year} ${'al'.i18n()} ${checkOut.day}/${checkOut.month}/${checkOut.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.payments_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${'totale_pagato'.i18n()}: €${widget.datiPrenotazione['prezzoTotale']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Divider(),
            ),

            // SEZIONE RECENSIONE
            Text('lascia_recensione'.i18n(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Controllo
            if (_haRecensito)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(child: Text('gia_recensito'.i18n(), style: TextStyle(color: Colors.green.shade800))),
                  ],
                ),
              )
            else

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 40,
                        icon: Icon(
                          index < _votoSelezionato ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _votoSelezionato = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Campo di testo
                  TextField(
                    controller: _recensioneController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'scrivi_qui'.i18n(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bottone
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _staInviando ? null : _inviaRecensione,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _staInviando
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('invia_recensione'.i18n(), style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}