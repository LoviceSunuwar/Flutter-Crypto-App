import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;

  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (_context, _index) {
              String _currency = _currencies[_index].toString().toUpperCase();
              String _exchangeRate =
                  _exchangeRates[_index].toString().toUpperCase();
              return Column(
                children: [
                  ListTile(
                    title: (Text(
                      "$_currency : $_exchangeRate",
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                  Container(
                    height: _deviceHeight * 0.002,
                    color: Colors.white,
                  )
                ],
              );
            }),
      ),
    );
  }
}
