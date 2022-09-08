import 'dart:convert';

import 'package:crypto_flutter/pages/details_page.dart';
import 'package:crypto_flutter/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double? _deviceHeight, _deviceWidth;
  String? _selectedCoin = "bitcoin";
  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedCoinDropDown(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/$_selectedCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());
          num _cadPrice = _data["market_data"]["current_price"]["cad"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          String _coinDesc = _data["description"]["en"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext _context) {
                      return DetailsPage(rates: _exchangeRates);
                    }));
                  },
                  child: _coinImageWidget(_data["image"]["large"])),
              _currentPriceWidget(_cadPrice),
              _percentageChangeWidget(_change24h),
              _coinDescription(_coinDesc)
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)}",
      style: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toStringAsFixed(2)} %",
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
    );
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.2),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration:
          BoxDecoration(image: DecorationImage(image: NetworkImage(_imgURL))),
    );
  }

  Widget _coinDescription(String _coinDescription) {
    return Container(
      color: Color.fromARGB(255, 58, 93, 110),
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.01, horizontal: _deviceWidth! * 0.01),
      child: Text(
        _coinDescription,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple",
      "solana"
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: Color.fromARGB(255, 63, 89, 101),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_circle_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }
}
