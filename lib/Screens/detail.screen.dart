import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../Widgets/weather_item.dart';
import '../constant.dart';

class Detailpage extends StatefulWidget {
  final dailyforecastweather;
  const Detailpage({super.key, this.dailyforecastweather});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  @override
  Widget build(BuildContext context) {
    final Constants _constant=Constants();
    Size size=MediaQuery.of(context).size;
    var weatherData=widget.dailyforecastweather;
    // function to get weather
    Map getForecastWeather(int index){
      int maxwindspeed=weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity=weatherData[index]["day"]["avghumidity"].toInt();
      int chanceofrain=weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate=DateTime.parse(weatherData[index]["date"]);
      var forecastDate=DateFormat('EEEE, d MMMM').format(parsedDate);
      String WeatherName=weatherData[index]['day']['condition']['text'];
      String WeatherIcon=WeatherName.replaceAll(' ', '').toLowerCase()+".png";
      int minTemperature=weatherData[index]["day"]["mintemp_c"].toInt();
      int maxTemperature=weatherData[index]["day"]["maxtemp_c"].toInt();

      var forecastdata={
        'maxWindSpeed':maxwindspeed,
        'avghumidity':avgHumidity,
        'chanceofrain':chanceofrain,
        'forecastdate':forecastDate,
        'weathername':WeatherName,
        'weathericon':WeatherIcon,
        'minTemperature':minTemperature,
        'maxTemperature':maxTemperature,
      };
      return forecastdata;




    }




    return Scaffold(
      backgroundColor: _constant.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _constant.primaryColor,
        title: const Text("Forecasts"),
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child:
            Container(
              height: size.height*.75,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  )
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child:
                    Container(
                      height: 300,
                      width: size.width*.7,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5)
                              ]
                          ),                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(.1),
                                offset: Offset(0, 25),
                                blurRadius: 3,
                                spreadRadius: -10
                            )
                          ]
                      ),
                      child: Stack(

                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:5),
                            child: Image.asset("assets/"+getForecastWeather(0)['weathericon'],width: 155,height:150),
                          ),
                          Positioned(
                            top: 150,
                            left: 30,
                            child: Text(getForecastWeather(0)['weathername'],style: TextStyle(color: Colors.white,fontSize: 20),),),
                          Positioned(
                            bottom: 20,
                            left: 10,
                            child: Container(
                              width: size.width*.8,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                      value: getForecastWeather(0)['maxWindSpeed'], unit: "Km/h", imageUrl: "assets/windspeed.png"

                                  ),
                                  WeatherItem(
                                    value: getForecastWeather(0)['avghumidity'], unit: "%", imageUrl: "assets/humidity.png",

                                  ),
                                  WeatherItem(
                                    value: getForecastWeather(0)['chanceofrain'], unit: "%", imageUrl: "assets/lightrain.png",

                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getForecastWeather(0)['maxTemperature'].toString(),
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()..shader=_constant.shader
                                  ),
                                ),
                                Text('o',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()..shader=_constant.shader
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 270,left: 19,right: 19),
                    child: Container(
                      height: 490,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return
                            Card(
                              elevation: 3.0,
                              margin: EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getForecastWeather(index)['forecastdate'],
                                          style: TextStyle(
                                              color: Color(0xff6696f5),
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                        children: [
                                                          Text(
                                                            getForecastWeather(index)['minTemperature'].toString(),
                                                            style: TextStyle(
                                                              color: _constant.greyColor,
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Transform.translate(
                                                            offset: const Offset(1, -8), // Move the 'o' up
                                                            child: Text(
                                                              'o',
                                                              style: TextStyle(
                                                                color: _constant.greyColor,
                                                                fontSize: 20, // Smaller font size for the 'o'
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(width:7),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                        children: [
                                                          Text(
                                                            getForecastWeather(index)['maxTemperature'].toString(),
                                                            style: TextStyle(
                                                              color: _constant.blackColor,
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Transform.translate(
                                                            offset: const Offset(1, -8), // Move the 'o' up
                                                            child: Text(
                                                              'o',
                                                              style: TextStyle(
                                                                color: _constant.greyColor,
                                                                fontSize: 20, // Smaller font size for the 'o'
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )



                                          ],
                                        ),


                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/'+getForecastWeather(0)['weathericon'],width: 30,),
                                            SizedBox(width: 5,),
                                            Text(getForecastWeather(0)['weathername'],style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey

                                            ),)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(getForecastWeather(0)['chanceofrain'].toString()+"%",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey

                                              ),
                                            ),
                                            SizedBox(width: 5,),


                                            Image.asset('assets/lightrain.png',width: 30,),
                                          ],
                                        )


                                      ],
                                    )


                                  ],
                                ),
                              ),
                            );

                        },
              ),
            ),
          )
        ],
      ),
    )
    )
  ]
      )

    );
  }
}
