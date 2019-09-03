import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../provider/product.dart';


class Products with ChangeNotifier {
  List<Product> _items = [];
  
  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    print('fetchAndSet!');

    var url = "https://testonliant.griffins.com/?p=connect&req=UnifiedSearch&search=flamingo&fmt=JSON";

    try {
      final response = await http.get(url);
      print(response.body);
      final resData = json.decode(response.body) as Map<String, dynamic>;
      print(resData);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}