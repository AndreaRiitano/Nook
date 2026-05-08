import 'package:flutter/material.dart';
import 'package:nook/UI/widgets/BnbCard.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/Bnb.dart';
import 'BnbDetail.dart';
import 'package:localization/localization.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Bnb>? _risultati;
  bool _staCercando = false;
  String _ordinamentoCorrente = 'rilevanza';
  bool _mostraFallback = false;


  void _eseguiRicerca(String query) async {
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() => _staCercando = true);


    final esito = await DatabaseManager().searchBnbs(
        query: query,
        ordinamento: _ordinamentoCorrente
    );

    setState(() {
      _risultati = esito;
      _staCercando = false;
      _mostraFallback = esito.isNotEmpty && !esito.any((bnb) =>
      bnb.titolo.toLowerCase().contains(query.toLowerCase()) ||
          bnb.citta.toLowerCase().contains(query.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(),
            if (_mostraFallback) _buildFallbackBanner(),
            if (_risultati != null && _risultati!.isNotEmpty) _buildFilterBar(),
            Expanded(child: _buildAreaRisultati()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: _eseguiRicerca,
        decoration: InputDecoration(
          hintText: 'cerca_bnb'.i18n(),
          filled: true,
          fillColor: Theme.of(context).hintColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _eseguiRicerca(_searchController.text),
          ),
        ),

      ),

    );
  }

  Widget _buildAreaRisultati() {
    if (_staCercando) return const Center(child: CircularProgressIndicator());
    if (_risultati == null) return Center(child: Text('typing'.i18n(), style: Theme.of(context).textTheme.labelLarge,));
    if (_risultati!.isEmpty) return const Center(child: Text("Nessun BnB trovato."));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _risultati!.length,
      itemBuilder: (context, index) => _buildBnbCard(_risultati![index]));
  }

  Widget _buildBnbCard(Bnb bnb) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BnbDetail(bnb: bnb))),
        child: Column(
          children: [
            Image.network(bnb.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bnb.titolo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("⭐ ${bnb.valutazione}"),
                    ],
                  ),
                  Text(bnb.citta, style: TextStyle(color: Colors.grey.shade600)),
                  Text('€${bnb.prezzo} / ${'notte'.i18n()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildFallbackBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'err_no_results_fallback'.i18n(),
              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'search'.i18n(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ordina_per'.i18n(),
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold
            ),
          ),
          DropdownMenu<String>(
            initialSelection: _ordinamentoCorrente,
            enableSearch: false,
            requestFocusOnTap: false,
            textStyle: Theme.of(context).textTheme.labelLarge,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Theme.of(context).hintColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).hintColor),
              elevation: WidgetStateProperty.all(4),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'rilevanza', label: 'rilevanza'.i18n()),
              DropdownMenuEntry(value: 'prezzo_cresc', label: 'prezzo_cresc'.i18n()),
              DropdownMenuEntry(value: 'prezzo_decr', label: 'prezzo_decr'.i18n()),
              DropdownMenuEntry(value: 'migliori_voti', label: 'migliori_voti'.i18n()),
            ],
            onSelected: (String? nuovoValore) {
              if (nuovoValore != null && nuovoValore != _ordinamentoCorrente) {
                setState(() {
                  _ordinamentoCorrente = nuovoValore;
                });

                _eseguiRicerca(_searchController.text);
              }
            },
          ),
        ],
      ),
    );
  }
}