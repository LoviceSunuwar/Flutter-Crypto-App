import 'dart:convert';

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
      future: _http!.get("/coins/bitcoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());
          num _cadPrice = _data["market_data"]["current_price"]["cad"];
          return Text(
            _cadPrice.toString(),
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

  Widget _selectedCoinDropDown() {
    List<String> _coins = ["bitcoin"];
    List<DropdownMenuItem> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _coins.first,
      items: _items,
      onChanged: (_value) {},
      dropdownColor: Colors.green,
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_circle_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }
}
