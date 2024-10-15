import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';



import '../Widgets/weather_item.dart';
import '../constant.dart';
import 'detail.screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Constants _contsnt=Constants();

  String Location = ''; // Default Location

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location Denied");
        return; // Exit if permission is denied
      } else {
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        print("Latitude: ${currentPosition.latitude}");
        print("Longitude: ${currentPosition.longitude}");

        // Get the city name using reverse geocoding
        List placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        if (placemarks.isNotEmpty && placemarks[0].locality != null) {
          setState(() {
            Location = placemarks[0].locality.toString();
          });
          print("City: $Location");

          // Now that the location is set, fetch the weather data
          fetchWeatherData(Location);
        } else {
          print("City name not found");
        }
      }
    } catch (e) {
      setState(() {
        Location = 'Error'; // Handle error by assigning an appropriate value
      });
      print("Error occurred: $e");
    }
  }

  void fetchWeatherData(String cityName) async {
    // Your code to call the weather API using the 'cityName'
    print("Fetching weather data for $cityName");
    try{
        var searchResult= await http.get(Uri.parse(searchWeatherApi+cityName));
        final weatherData=Map<String,dynamic>.from(
          jsonDecode(searchResult.body)?? 'No Data');

        var locationData=weatherData['location'];
        var currentWeather=weatherData['current'];
        setState(() {
          Location=getShortLocationname(locationData['name']);

          var parseddata = DateTime.parse(locationData["localtime"].substring(0,10));

          var newDate = DateFormat('MMMMEEEEd').format(parseddata);
          currentDate=newDate;

          //Update Weather
          currentWeatherStatus = currentWeather["condition"]["text"];
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase()+ ".png";
          temperature=currentWeather["temp_c"].toInt();
          windSpeed=currentWeather["wind_kph"].toInt();
          humidity=currentWeather["humidity"].toInt();
          cloud=currentWeather["cloud"].toInt();

          // Forecast Data
          dailyweatherForecast=weatherData["forecast"]["forecastday"];
          hourlyweatherForecast=dailyweatherForecast[0]["hour"];
          print(dailyweatherForecast);
          bottommodalcontroll=true;

        });


        }catch(e){
          print(e.toString());
        }
  }


  static String API_KEY='6b455fd7c1ef473984a105724241209';
  String weatherIcon='heavycloud.png';
  int temperature =0;
  int windSpeed =0;
  int humidity =0;
  int cloud =0;
  String currentDate='';
 bool bottommodalcontroll=false;
 bool imageloading=false;
  List hourlyweatherForecast=[];
  List dailyweatherForecast=[];

  String currentWeatherStatus=' ';

  //Api call
  String searchWeatherApi="https://api.weatherapi.com/v1/forecast.json?key="+API_KEY+"&days=7&q=";

  static String getShortLocationname(String s){
   List<String> worlist=s.split(" ");
   if(worlist.isNotEmpty){
    if(worlist.length>1){
      return worlist[0] + " " + worlist[1];
    }else{
      return worlist[0];
    }
   }else{
     return " ";
   }
  }

      @override


  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);

     Size size=MediaQuery.of(context).size;
     final _cityController=TextEditingController();
    ScrollController scrollController = ScrollController();

    return Scaffold(

      body:
      Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(top: 70,left: 10,right: 10),
        color:_contsnt.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Container(
             padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
             height: size.height*.7,
             decoration: BoxDecoration(
               gradient: _contsnt.linearGradientBlue,
               boxShadow: [
                 BoxShadow(
                   color: _contsnt.primaryColor.withOpacity(.5),
                   spreadRadius: 5,
                   blurRadius: 7,
                   offset: const Offset(0, 3)
                 ),
               ],
               borderRadius: BorderRadius.circular(20)
             ),
             child:
             Column(
               // crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Image.asset(
                       "assets/menu.png",
                       width: 40,
                       height: 40,
                     ),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset("assets/pin.png",width: 20,color: Colors.blue,),
                         const SizedBox(width: 2,),
                         Text(Location,style: const TextStyle(
                             color: Colors.white,
                             fontSize: 16.0
                         )) ,
             IconButton(
               onPressed: () {
                 _cityController.clear();
                 showModalBottomSheet(
                   isScrollControlled: true, // Allows the modal to take full height
                   context: context,
                   builder: (BuildContext context) => SingleChildScrollView(
                     controller: scrollController,
                     child: Padding(
                       padding: EdgeInsets.only(
                         bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                       ),
                       child: Container(
                         height: size.height * .3, // Increased height to account for the keyboard
                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                         child: Column(
                           mainAxisSize: MainAxisSize.min, // Ensures column only takes up necessary space
                           children: [
                             SizedBox(
                               width: 70,
                               child: Divider(
                                 thickness: 3.5,
                                 color: _contsnt.primaryColor,
                               ),
                             ),
                             const SizedBox(height: 10),
                             TextField(
                               onChanged: (searchtext) {
                                 fetchWeatherData(searchtext);

                               },
                               controller: _cityController,
                               autofocus: true,
                               decoration: InputDecoration(
                                 prefixIcon: Icon(
                                   Icons.search,
                                   color: _contsnt.primaryColor,
                                 ),
                                 suffixIcon: GestureDetector(
                                   onTap: () => _cityController.clear(),
                                   child: Icon(
                                     Icons.close,
                                     color: _contsnt.primaryColor,
                                   ),
                                 ),
                                 hintText: "Search City e.g. London",
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                     color: _contsnt.primaryColor,
                                   ),
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 );
               },
               icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
             )
                       ],
                     ),
                     ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                       child: Image.asset("assets/profile.png",width: 40,height: 40,),
                     )
                   ],
                 ),
                 SizedBox(
                   height: 160,
                   child:
                    Image.asset(
                   "assets/" + weatherIcon,
                   fit: BoxFit.cover,
                   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                     // Show a loading spinner in case of an error
                     return Center(
                       child: CircularProgressIndicator(),
                     );
                   },
                 )
                 ),

                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child:
                       Text(
                           temperature.toString(),
                         style: TextStyle(
                           fontSize: 80,
                           fontWeight: FontWeight.bold,
                           foreground: Paint()..shader=_contsnt.shader
                         ),
                       ),
                     ),
                     Text(
                       "o",
                       style: TextStyle(
                           fontSize: 40,
                           fontWeight: FontWeight.bold,
                           foreground: Paint()..shader=_contsnt.shader
                       ),
                     ),

                   ],
                 ),
                 Text(currentWeatherStatus,style: TextStyle(
                   color: Colors.white70,
                   fontSize: 20.0
                 ),),
                 Text(currentDate,style: TextStyle(
                     color: Colors.white70,
                     fontSize: 20.0
                 ),),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: const Divider(
                     color: Colors.white70,
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 40),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       WeatherItem(value: windSpeed.toInt(), unit: "km/h", imageUrl: "assets/windspeed.png" ),
                       WeatherItem(value: humidity.toInt(), unit: "%", imageUrl: "assets/humidity.png"),
                       WeatherItem(value: cloud.toInt(), unit: "%", imageUrl: "assets/cloud.png"),

                     ],
                   ),
                 ),
               ],
             )
             ,
           ),
            Container(
              padding: EdgeInsets.only(top: 10),
              height: size.height*.20 ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Detailpage(dailyforecastweather: dailyweatherForecast,),)),
                        child: Text("Forecast",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: _contsnt.primaryColor
                        ),),
                      )

                    ],
                  ),
                  SizedBox(height: 8,),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: hourlyweatherForecast.length,  // Ensure this matches the list length
                  itemBuilder: (context, index) {
                    // Access the data safely now, as the index is within the valid range
                    String currenttime = DateFormat('HH:mm:ss').format(DateTime.now());
                    String currenthour = currenttime.substring(0, 2);
                    String forecasttime = hourlyweatherForecast[index]["time"].substring(11, 16);
                    String forecastHour = hourlyweatherForecast[index]["time"].substring(11, 13);
                    String forecastWeatherName = hourlyweatherForecast[index]["condition"]["text"];
                    String forecaseWeathericon = forecastWeatherName.replaceAll(' ', '').toLowerCase() + ".png";
                    String forecastTemperature = hourlyweatherForecast[index]["temp_c"].round().toString();
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      margin: EdgeInsets.only(right: 20),
                      width: 65,
                      decoration: BoxDecoration(
                        color: currenthour == forecastHour ? Colors.white : _contsnt.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: _contsnt.primaryColor.withOpacity(.2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            forecasttime,
                            style: TextStyle(
                              fontSize: 17,
                              color: _contsnt.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset("assets/"+forecaseWeathericon,width: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(forecastTemperature,style: TextStyle(
                              color: _contsnt.greyColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                            ),),
                              Text('0',style: TextStyle(
                                color: _contsnt.greyColor,
                                fontSize: 17,
                                fontFeatures: [
                                  FontFeature.enable('sups'),
                                ]
                                )
                              )

                            ],
                          )
                          // You can add other forecast data here
                        ],
                      ),
                    );
                  },
                ),
              )
                ],
              ),
            )



          ],
        ),
      ),
    );
  }
}

