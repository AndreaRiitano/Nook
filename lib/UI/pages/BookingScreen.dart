import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/Bnb.dart';
import 'package:nook/model/objects/Booking.dart';

class BookingScreen extends StatefulWidget {

  final Bnb bnb;

  const BookingScreen({super.key, required this.bnb});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? _dateSelezionate;
  bool _staPrenotando = false;

  Future<void> _selezionaDate() async {
    final DateTimeRange? dateScelte = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'seleziona_date'.i18n(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  Theme.of(context).colorScheme,
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


  Future<void> _confermaPrenotazione(int prezzoTotale) async {
    setState(() { _staPrenotando = true; });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;


      Booking nuovaPrenotazione = Booking(
        id: '',
        bnbId: widget.bnb.id,
        userId: userId,
        checkIn: _dateSelezionate!.start,
        checkOut: _dateSelezionate!.end,
        prezzoTotale: prezzoTotale.toDouble(),
        titoloBnb: widget.bnb.titolo,
        copertina: widget.bnb.imageUrl
      );


      await DatabaseManager().creaPrenotazione(nuovaPrenotazione);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('prenotazione_confermata'.i18n()),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Errore prenotazione: $e");
    } finally {
      if (mounted) setState(() { _staPrenotando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {

    int notti = _dateSelezionate != null
        ? _dateSelezionate!.end.difference(_dateSelezionate!.start).inDays
        : 0;
    if (notti == 0 && _dateSelezionate != null) notti = 1;

    int prezzoTotale = widget.bnb.prezzo * (notti > 0 ? notti : 1);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme:  IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'richiesta_prenotazione'.i18n(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.bnb.imageUrl,
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
                        widget.bnb.titolo,
                        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' ${widget.bnb.valutazione}'),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 25.0), child: Divider()),

            Text('il_tuo_viaggio'.i18n(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('date'.i18n(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary)),
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
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 25.0), child: Divider()),

            Text('dettagli_prezzo'.i18n(), style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 20),

            if (_dateSelezionate == null)
              _buildInfoDate()
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('€${widget.bnb.prezzo} x $notti ${'notti_plurale'.i18n()}', style:  TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                  Text('€$prezzoTotale', style:  TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15.0), child: Divider()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('totale_eur'.i18n(), style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  Text('€$prezzoTotale', style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ]
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(prezzoTotale),
    );
  }

  Widget _buildInfoDate() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Theme.of(context).hintColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text('aggiungi_date_info'.i18n(), style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(int prezzoTotale) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: (_staPrenotando || _dateSelezionate == null)
              ? null
              : () => _confermaPrenotazione(prezzoTotale),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _staPrenotando
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('conferma_paga'.i18n(), style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}