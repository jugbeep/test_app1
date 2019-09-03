import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String productNumber;
  final String availFlag;
  final String desc;
  final Map images;
  final String avail;
  final int minSell;
  final int sellPkg;
  final String defUom;
  final Map price;

  Product({
    this.productNumber, 
    this.avail, 
    this.availFlag,
    this.desc, 
    this.images, 
    this.minSell, 
    this.sellPkg, 
    this.defUom, 
    this.price,
  });

}