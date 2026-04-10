import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bnb_detail.dart';


class Search extends StatefulWidget {

  const Search({super.key});

  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search>{
  final TextEditingController _searchController = TextEditingController();

  List<DocumentSnapshot>? _risultati;
  bool _staCercando = false;
  bool _isFallback = false;

  void _eseguiRicercaLogica(String query) async {
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _staCercando = true;
      _risultati = null;
    });

    String q = query.toLowerCase().trim();
    var snapshot = await FirebaseFirestore.instance.collection('bnbs').get();
    List<DocumentSnapshot> tuttiIBnb = snapshot.docs;


    List<DocumentSnapshot> risultatiEsatti = tuttiIBnb.where((doc) {
      var bnb = doc.data() as Map<String, dynamic>;
      String titolo = (bnb['titolo'] ?? "").toString().toLowerCase();
      String citta = (bnb['citta'] ?? "").toString().toLowerCase();

      return titolo.contains(q) || citta.contains(q);
    }).toList();

    // fallback rapido dove metto i migliori se non trova niente, da cambiare
    if (risultatiEsatti.isEmpty) {
      tuttiIBnb.sort((a, b) {
        double valA = (a.data() as Map<String, dynamic>)['valutazione']?.toDouble() ?? 0.0;
        double valB = (b.data() as Map<String, dynamic>)['valutazione']?.toDouble() ?? 0.0;
        return valB.compareTo(valA);
      });

      setState(() {
        _risultati = tuttiIBnb.take(5).toList();
        _isFallback = true;
        _staCercando = false;
      });
    } else {
      setState(() {
        _risultati = risultatiEsatti;
        _isFallback = false;
        _staCercando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Column(
          children: [

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'search'.i18n(),
                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => _eseguiRicercaLogica(value),
                  decoration: InputDecoration(
                    hintText: 'cerca_bnb'.i18n(),
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.grey.shade400),
                      onPressed: () => _eseguiRicercaLogica(_searchController.text),
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: _buildAreaRisultati(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaRisultati() {
    if (_staCercando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_risultati == null) {
      return  Center(
        child: Text('typing'.i18n(), style: TextStyle(color: Colors.grey)),
      );
    }

    if (_risultati!.isEmpty) {
      return const Center(
        child: Text("Nessun BnB presente nel sistema.", style: TextStyle(color: Colors.grey)),
      );
    }

    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [

          if (_isFallback)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'fb'.i18n(),
                      style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _risultati!.length,
              itemBuilder: (context, index) {
                var bnb = _risultati![index].data() as Map<String, dynamic>;
                return _buildBnbCard(bnb);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBnbCard(Map<String, dynamic> bnb) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)=>BnbDetail(bnbData: bnb)
              )
          );
          //debuuuuuuug
          print("Apertura dettagli di: ${bnb['titolo']}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: bnb['immagineUrl'] != null
                  ? Image.network(bnb['immagineUrl'], fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 50, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bnb['titolo'] ?? 'Senza Titolo',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            (bnb['valutazione'] ?? 0.0).toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(bnb['citta'] ?? 'Città sconosciuta', style: TextStyle(color: Colors.grey.shade600)),

                  const SizedBox(height: 12),

                  Text('€${bnb['prezzo'] ?? '0'} / ${'notte'.i18n()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}