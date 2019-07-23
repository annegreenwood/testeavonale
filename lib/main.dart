import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testeavonale/detail_page.dart';
import 'package:testeavonale/model/product.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts(http.Client client) async {
  var endpoint = "http://www.edsonfreire.com.br/email_anne.php?";
  final response = await client.get(endpoint+'api=1');

  final Map parsed = json.decode(response.body);
  // if(response.body.mensagem){

  // }
  print(parsed);
  //return compute(parseProducts, response.body);
}

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Produtos Avonale';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(105, 105, 105, 1)
      ),
      body: Padding(
        child: FutureBuilder<List<Product>>(
          future: fetchProducts(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ProductsList(products: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;

  ProductsList({Key key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      200.0,
                ),
                color: Color.fromRGBO(209, 224, 224, 0.2),
                alignment: Alignment.center,
                child: Card(
                  color: Color.fromRGBO(19,152,147, 0.7), // cor do card
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // title: Text(products[index].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(products[index].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(products[index].resume, style: TextStyle(color: Color.fromRGBO(240, 249, 255, 1))),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[                         
                            FlatButton(
                              child: const Text('Detalhes', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(product: products[index])));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}