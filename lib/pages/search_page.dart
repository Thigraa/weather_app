import 'package:flutter/material.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<SearchPage> {
  final searchTextController = TextEditingController();
  final latTextController = TextEditingController();
  final lngTextController = TextEditingController();
  List<GBSearchData> searchItem = [];
  Map<String, dynamic> details = {};
  bool isSearching = false;
  bool isLoading = false;

  void searchLocation(String query) async {
    setState(() {
      isSearching = true;
    });
    List<GBSearchData> data = await GeocoderBuddy.query(query);
    setState(() {
      isSearching = false;
      searchItem = data;
    });
  }

  getAddressDetails(GBLatLng pos) async {
    setState(() {
      isLoading = true;
    });
    GBData data = await GeocoderBuddy.findDetails(pos);
    setState(() {
      isLoading = false;
      details = data.toJson();
    });
    print(data.address.village);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade900,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Search Location",
                style: GoogleFonts.redHatDisplay(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w400),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: searchTextController,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      hintText: "Search Location",
                      hintStyle: GoogleFonts.redHatDisplay(fontSize: 20, color: Colors.white38, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      ))),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (searchTextController.text.isNotEmpty) {
                      searchLocation(searchTextController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Location")));
                    }
                  },
                  child: Text("Search")),
              SizedBox(
                height: 500,
                child: !isSearching
                    ? ListView.builder(
                        itemCount: searchItem.length,
                        itemBuilder: (context, index) {
                          var item = searchItem[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textColor: Colors.white,
                              onTap: () {
                                provider.latitude = item.lat;
                                provider.longitude = item.lon;
                                List displayName = item.displayName.split(",");
                                provider.city = displayName[0];
                                provider.isCalled = false;
                                Navigator.pushNamed(context, '/');
                              },
                              title: Text(item.displayName),
                            ),
                          );
                        })
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
