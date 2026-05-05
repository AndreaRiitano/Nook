import 'package:flutter/material.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/Bnb.dart';
import 'package:nook/model/behavior/GeoLocatorBehavior.dart';
import 'package:localization/localization.dart';
import 'package:nook/UI/widgets/BnbCard.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String? _miaCittaAttuale;
  bool _ricercaPosizione = true;
  double? _miaLatitudine;
  double? _miaLongitudine;

  @override
  void initState() {
    super.initState();
    _trovaPosizioneUtente();
  }

  Future<void> _trovaPosizioneUtente() async {
    try {

      final datiPosizione = await GeoLocatorBehavior().getFullLocation();

      setState(() {
        _miaLatitudine = datiPosizione['lat'];
        _miaLongitudine = datiPosizione['lon'];
        _miaCittaAttuale = datiPosizione['citta'];
        _ricercaPosizione = false;
      });

    } catch (e) {

      debugPrint("Errore localizzazione: $e");
      setState(() => _ricercaPosizione = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('explore'.i18n(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),

            _buildTitoloSezione('pop'.i18n()),
            _buildCaroselloPopolari(),

            _buildTitoloSezione('near'.i18n()),
            if (_ricercaPosizione)
              const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()))
            else if (_miaCittaAttuale == null)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Attiva il GPS per vedere i BnB vicini!'),
              )
            else
              _buildCaroselloVicinanza(),
          ],
        ),
      ),
    );
  }


  Widget _buildCaroselloPopolari() {
    return SizedBox(
      height: 240,
      child: FutureBuilder<List<Bnb>>(
        future: DatabaseManager().getPopularBnbs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return _buildListViewBnb(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildCaroselloVicinanza() {
    return SizedBox(
      height: 240,
      child: FutureBuilder<List<Bnb>>(
        future: DatabaseManager().getNearbyBnbs(_miaLatitudine!, _miaLongitudine!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return _buildListViewBnb(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildListViewBnb(List<Bnb> lista) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lista.length,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      itemBuilder: (context, index) => BnbCard(bnb: lista[index]),
    );
  }

  Widget _buildTitoloSezione(String titolo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(titolo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }
}