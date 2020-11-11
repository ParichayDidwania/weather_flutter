import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
    home: weather()
  ));
}

class weather extends StatefulWidget {
  @override
  _weatherState createState() => _weatherState();
}

class _weatherState extends State<weather> {

  Future<WeatherClass> weather(String url) async
  {
    Response res = await get(url);
    if (res.statusCode == 200) {
      return WeatherClass.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load album');
    }

  }

  bool showProg = false;
  Future<WeatherClass> w;
  final mycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image(
              image: AssetImage('assets/stars.jpg'),
              fit: BoxFit.fill,
            ),
          ),

          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(50, 200, 50, 0),
                    child: TextField(
                      controller: mycontroller,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 3.0),)
                          ,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87, width: 3.0),),
                          hintText:'Enter a city',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontSize: 20
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 35),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      onPressed: (){
                        setState(() {
                          w = weather('http://api.openweathermap.org/data/2.5/weather?q=${mycontroller.text}&appid=b7fda66e4d6a8e0b6ff0036ef933144a');
                          showProg=true;
                        });
                        },
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1
                        ),
                      ),
                      color: Colors.black45,
                      textColor: Colors.white,

                    ),
                  ),
                  Visibility(
                    visible: showProg,
                    child: Container(
                      height: 200,
                        width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      child: Padding(
                              child: FutureBuilder<WeatherClass>(
                                future: w,
                                builder: (context,snapshot)
                                {
                                  if(snapshot.hasData)
                                  {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:[
                                        Text(
                                    snapshot.data.main.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                      fontSize: 40
                                        ),),
                                        Text(
                                            snapshot.data.desc.toString(),
                                            style:TextStyle(
                                                color: Colors.white,
                                                fontSize: 20
                                            )
                                        ),

                                        Text(
                                            'Temperature : '+snapshot.data.temp.toString() + 'K',
                                            style:TextStyle(
                                                color: Colors.white,
                                                fontSize: 20
                                            )
                                        )

                                      ]

                                    );

                                  }
                                  else
                                    {
                                      return Center(
                                        child: Text(
                                          'Enter a valid city',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),),
                                      );
                                    }

                                  return Center(child:CircularProgressIndicator());
                                },
                              ),
                              padding: EdgeInsets.all(5),
                            )
                        ),
                  ),

                ],
              ),
          ),

        ]
      ),
    );
  }
}

class WeatherClass {
  String main;
  String desc;
  double temp;

  WeatherClass({this.main,this.desc,this.temp});

  factory WeatherClass.fromJson(Map<String, dynamic> json) {
    return WeatherClass(
      main: json['weather'][0]['main'].toString(),
      desc: json['weather'][0]['description'].toString(),
      temp : json['main']['temp']
    );
  }
}


