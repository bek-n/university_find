import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:weather_app/Home/add_country.dart';

class HomePage extends StatefulWidget {
  final String country;
  const HomePage({super.key,  this.country='Uzbekistan'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic data;
  bool isLoading = true;

  Future<void> getInfo() async {
    isLoading = true;
    setState(() {});
    final url =
        Uri.parse('http://universities.hipolabs.com/search?country=India');
    final res = await http.get(url);
    data = jsonDecode(res.body);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => AddingCountry())));
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Icon(Icons.search_outlined),
          ),
        ),
        appBar: AppBar(
          title: Text('Universities Info'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: ((context, index) => Container(
                      margin: EdgeInsets.only(top: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        children: [
                          Text(
                            data[index]['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextButton(
                              onPressed: (() async {
                                final launchUri = Uri.parse(
                                    data[index]['web_pages']?[0] ?? '');
                                await url_launcher.launchUrl(launchUri);
                              }),
                              child: Text(
                                data[index]['web_pages']?[0] ?? '',
                                style: TextStyle(color: Colors.white),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ))));
  }
}
