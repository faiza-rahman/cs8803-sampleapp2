import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampple_app2/models/quote_model.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    hitQuotesApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),

        /// data show in body
        body: FutureBuilder(
          future: hitQuotesApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error Found : ${snapshot.error.toString()}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.quotes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                      ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                /// title
                                title: Text(
                                  snapshot.data!.quotes[index].quote,
                                  style: const TextStyle(
                                      fontFamily: "primary",
                                      fontSize: 12,
                                      color: Colors.black),
                                ),
                            
                          /// sub title
                          subtitle: Text(
                            snapshot.data!.quotes[index].author,
                            style: const TextStyle(
                                fontFamily: "primary",
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ));
  }

  Future<QuoteDataModel?> hitQuotesApi() async {
    String url = "https://dummyjson.com/quotes";
    Uri uri = Uri.parse(url);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      var resData = jsonDecode(res.body);
      return QuoteDataModel.myFromJson(resData);
    } else {
      return null;
    }
  }
}
