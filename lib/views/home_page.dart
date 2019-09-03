import 'package:flutter/material.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

import 'package:provider/provider.dart';

import '../provider/products.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  const HomePage({Key key}) : super(key: key);

  void getProducts(ctx, value) async {
    print(value);
    await Provider.of<Products>(ctx).fetchAndSetProducts();

  }
  static const arrLent = [1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: FloatingSearchBar.builder(
          onChanged: (val) {
            getProducts(context, val);
          },
          itemCount: 1,
          itemBuilder: (ctx, i) => Center(
            child: Text('hello  '),
          ),
          decoration:
              InputDecoration.collapsed(hintText: 'Search for some items'),
          trailing: CircleAvatar(
            child: Icon(Icons.search),
          ),
        ));
  }
}
