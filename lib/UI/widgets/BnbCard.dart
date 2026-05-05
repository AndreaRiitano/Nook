import 'package:flutter/material.dart';
import 'package:nook/model/objects/Bnb.dart';
import 'package:nook/UI/pages/BnbDetail.dart';

class BnbCard extends StatelessWidget {
  final Bnb bnb;

  const BnbCard({super.key, required this.bnb});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BnbDetail(bnb: bnb))
      ),
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
                offset: const Offset(0, 5)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  bnb.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      bnb.titolo,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                  ),
                  Text(
                      bnb.citta,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '€${bnb.prezzo} / notte',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          Text(
                              '${bnb.valutazione}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
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
      ),
    );
  }
}