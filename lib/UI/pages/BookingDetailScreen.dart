import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localization/localization.dart';
import 'package:nook/model/managers/DatabaseManager.dart';

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
  bool _caricamentoRecensione = false;
  bool _isEditing = false;
  Map<String, dynamic>? _recensioneEsistente;

  @override
  void initState() {
    super.initState();
    _haRecensito = widget.datiPrenotazione['haRecensito'] ?? false;

    if (_haRecensito) {
      _caricaRecensioneDalDB();
    }
  }

  @override
  void dispose() {
    _recensioneController.dispose();
    super.dispose();
  }
  Future<void> _caricaRecensioneDalDB() async {
    setState(() => _caricamentoRecensione = true);
    final recensione = await DatabaseManager().getRecensioneByPrenotazione(widget.prenotazioneId);

    if (mounted) {
      setState(() {
        _recensioneEsistente = recensione;
        _caricamentoRecensione = false;
      });
    }
  }

  Future<void> _salvaRecensione() async {
    if (_recensioneController.text.trim().isEmpty) return;
    setState(() => _staInviando = true);
    FocusScope.of(context).unfocus();

    try {
      if (_isEditing && _recensioneEsistente != null) {

        await DatabaseManager().modificaRecensione(
          recensioneId: _recensioneEsistente!['id'],
          nuovoVoto: _votoSelezionato,
          nuovoTesto: _recensioneController.text.trim(),
        );
      } else {


        await DatabaseManager().inviaRecensionePerPrenotazione(
          bnbId: widget.datiPrenotazione['bnbId'],
          prenotazioneId: widget.prenotazioneId,
          voto: _votoSelezionato,
          testo: _recensioneController.text.trim(),
        );
      }
      await _caricaRecensioneDalDB();

      if (mounted) {
        setState(() {
          _staInviando = false;
          _haRecensito = true;
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recensione salvata con successo!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Errore recensione: $e");
      if (mounted) setState(() => _staInviando = false);
    }
  }

  Future<void> _eliminaRecensione() async {
    if (_recensioneEsistente == null) return;

    bool conferma = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elimina Recensione"),
        content: const Text("Sei sicuro di voler eliminare questa recensione?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annulla")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Elimina", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!conferma) return;

    setState(() => _caricamentoRecensione = true);

    try {
      await DatabaseManager().eliminaRecensione(
          recensioneId: _recensioneEsistente!['id'],
          prenotazioneId: widget.prenotazioneId
      );

      if (mounted) {
        setState(() {
          _haRecensito = false;
          _recensioneEsistente = null;
          _caricamentoRecensione = false;
          _recensioneController.clear();
          _votoSelezionato = 5;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recensione eliminata.'), backgroundColor: Colors.grey),
        );
      }
    } catch (e) {
      print("Errore eliminazione: $e");
      if (mounted) setState(() => _caricamentoRecensione = false);
    }
  }

  void _attivaModalitaModifica() {
    if (_recensioneEsistente != null) {
      setState(() {
        _isEditing = true;
        _votoSelezionato = (_recensioneEsistente!['voto'] ?? 5).toInt();
        _recensioneController.text = _recensioneEsistente!['testo'] ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme:  IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text('dettagli_prenotazione'.i18n(), style:  TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRiepilogoPrenotazione(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 25), child: Divider()),
            Text('la_tua_recensione'.i18n(), style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 20),


            _buildAreaRecensione(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiepilogoPrenotazione() {
    DateTime checkIn = (widget.datiPrenotazione['checkIn'] as Timestamp).toDate();
    DateTime checkOut = (widget.datiPrenotazione['checkOut'] as Timestamp).toDate();
    bool haImmagine = widget.datiPrenotazione['immagineBnb'] != null && widget.datiPrenotazione['immagineBnb'].toString().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: haImmagine
              ? Image.network(
            widget.datiPrenotazione['immagineBnb'],
            width: double.infinity, height: 200, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(width: double.infinity, height: 200, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
          )
              : Container(width: double.infinity, height: 200, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
        ),
        const SizedBox(height: 20),
        Text(widget.datiPrenotazione['titoloBnb'] ?? '', style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.grey), const SizedBox(width: 8),
            Text('${'dal'.i18n()} ${checkIn.day}/${checkIn.month}/${checkIn.year} ${'al'.i18n()} ${checkOut.day}/${checkOut.month}/${checkOut.year}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }


  Widget _buildAreaRecensione() {
    if (_caricamentoRecensione) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_haRecensito && !_isEditing && _recensioneEsistente != null) {
      return _buildRecensionePubblicata();
    }

    return _buildFormRecensione();
  }


  Widget _buildRecensionePubblicata() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(5, (index) => Icon(
                    index < (_recensioneEsistente!['voto'] ?? 0) ? Icons.star : Icons.star_border, color: Colors.amber, size: 20
                )),
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: _attivaModalitaModifica),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: _eliminaRecensione),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(_recensioneEsistente!['testo'] ?? '', style:  TextStyle(fontSize: 15, height: 1.4, color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildFormRecensione() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isEditing)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Stai modificando la tua recensione", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              iconSize: 40,
              icon: Icon(index < _votoSelezionato ? Icons.star : Icons.star_border, color: Colors.amber),
              onPressed: () => setState(() => _votoSelezionato = index + 1),
            );
          }),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _recensioneController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'scrivi_qui'.i18n(),
            filled: true, fillColor: Theme.of(context).hintColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [

            if (_isEditing) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _isEditing = false),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Annulla', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 10),
            ],

            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _staInviando ? null : _salvaRecensione,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _staInviando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isEditing ? 'Aggiorna' : 'invia_recensione'.i18n(), style:  TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      ],
    );
  }
}