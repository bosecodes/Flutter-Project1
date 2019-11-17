import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

void main() {
  //runApp(new AppURL());
  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Title',
      home: AppURL(),
      debugShowCheckedModeBanner: true,
    );
  }
}


class AppURL extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<AppURL> {

  Location location = Location();

  Map<String, double> currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location.onLocationChanged().listen((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  // Functions to URI/URL LAUNCHING
  TextEditingController _url = new TextEditingController();
  Future _openURL(String lat, String long) async{
    print('open click');
    var url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if(await canLaunch(url))
      launch(url);
    else
      print('URL cannot be launched');
  }
  Future _launchURL(String toMailId, String subject, String body, String lat, String long) async {
    body = body + lat + ' N ' + long + ' E\nhttps://www.google.com/maps/search/?api=1&query=$lat,$long';
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future launchSMS(String tono, String body, String lat, String long) async {
    body = body + lat + " N " + long + " E\nhttps://www.google.com/maps/search/?api=1&query=$lat,$long";
    var url = 'sms:$tono?body=$body';
    // var url2 = 'https://www.google.com/maps/search/?api=1&query=52.32,4.917';
    if(await canLaunch(url)){
      launch(url);
    }
    else{
      print('COULD NOT LAUNCH $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text('Accident Detection'),
          backgroundColor: Colors.red,
        ),
        body: new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              new TextField(controller: _url,),
//              new RaisedButton(onPressed: _openURL, child: new Text('OPEN URL'),),
              new RaisedButton(onPressed: ()=> _launchURL('basusomdev100@gmail.com', 'EMERGENCY! ACCIDENT REPORTED BY RANGANATH', 'RANGANATH JUST HAD AN ACCIDENT AT THIS LOCATION:\n', currentLocation['latitude'].toString(), currentLocation['longitude'].toString()), child: new Text('Send Mail'),),
              new RaisedButton(onPressed: ()=> launchSMS('+917980471404','ACCIDENT REPORTED BY RANGANATH AT ', currentLocation["latitude"].toString(), currentLocation["longitude"].toString()), child: new Text('SEND SMS TO EMERGENCY CONTACT'),),
              currentLocation == null
                  ? CircularProgressIndicator()
                  : Text("Location:" + currentLocation["latitude"].toString() + " " + currentLocation["longitude"].toString()),
              new RaisedButton(onPressed: ()=> _openURL(currentLocation['latitude'].toString(), currentLocation['Longitude'].toString()), child: new Text('Show Location'),)
            ],
          ),
        ),
      )
    );
  }
}