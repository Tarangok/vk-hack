import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

int driverID = 0;

class Driver
{
  int id = 0;
  String name = "";
  String surname = "";
  String midname = "";
  int dayCountExperience = -1;
  int daysWorked = -1;
  int rating = -1;
  String gosnom = "";
  int flightNumber = -1;

  @override
  Driver(_id, _name, _surname, _midname, _dayCountExperience, _daysWorked, _rating)
  {
    id = _id;
    name = _name;
    surname = _surname;
    midname = _midname;
    dayCountExperience = _dayCountExperience;
    daysWorked = _daysWorked;
    rating = _rating;
    
  }
  void printInfo()
  {
    print(id);
    print(name);
    print(surname);
    print(midname);
    print(dayCountExperience);
    print(daysWorked);
    print(rating);
  }

  int getId()
  {
    return id;
  }

  void setGNFN(_gn, _fn)
  {
    var _id = int.parse(_gn);
    assert(_id is int);
    gosnom = _gn;
    flightNumber = _id;
  }
}

class Flight
{
  int id = -1;
  int driverId = -1;
  int passengersCount = -1;
  String dlightStartTime = "";
  int cash = -1;
  String govermentNumber = "";
  int flightNumber = -1;
  int time = 0;
  bool run = false;

  Flight(_id, _driverId, _passengersCount, _dlightStartTime, _cash, _govermentNumber, _flightNumber)
  {
    id = _id;
    driverId = _driverId;
    passengersCount = _passengersCount;
    dlightStartTime = _dlightStartTime;
    cash = _cash;
    govermentNumber = _govermentNumber;
    flightNumber = _flightNumber;
    run = true;
  }

  void printInfo()
  {
    print(id);
    print(driverId);
    print(passengersCount);
    print(dlightStartTime);
    print(cash);
    print(govermentNumber);
    print(flightNumber);
  }

  void timer() async
  {
    while (run)
    {
      Future.delayed(const Duration(milliseconds: 1000), () {
        print(time);
        time++;
      });
    }
    
  }
}

Driver driver;
Flight flight;

String _url_ = "http://10.0.31.143";

Future<bool> fetchPost1(a) async {
  final response = await http.get('http://10.0.31.143/?id='+a);
  if (response.statusCode == 200)
  {
    print(response.body);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.body == 'null')
    {
      //textError.text = "Нет такого водителя";
      return false;
    }
    else
    {
      var _id = int.parse(jsonResponse['id']);
      assert(_id is int);
      var _dayCountExperience = int.parse(jsonResponse['DayCountExperience']);
      assert(_dayCountExperience is int);
      var _daysWorked = int.parse(jsonResponse['DaysWorked']);
      assert(_daysWorked is int);
      var _rating = int.parse(jsonResponse['Rating']);
      assert(_rating is int);
      driver = new Driver(_id, jsonResponse['Name'], jsonResponse['Surname'], jsonResponse['Midname'], _dayCountExperience, _daysWorked, _rating);
      return true;
    }
    
  }
}

Future<String> fetchPost2(int a, String b, String c) async {
  print('fetchPost2');
  final response = await http.get('http://10.0.31.143/?id=\''+a.toString()+'\'&GN=\''+b+'\'&FN=\''+c+'\'');
  if (response.statusCode == 200)
  {
    print(response.body);
    //Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.body == 'null')
    {
      print('false1');
      return 'false';
    }
    else
    {
      int param = int.parse(response.body);
      var a = fetchPost3(param);
      a.then(
        (b) { 
          if (b != '')
          {
            
            print(b);
            return b;
          }
          else
          {
            
          }
        }).catchError((e) {

        }).whenComplete(() {});
      print('response.body');
      return response.body;
    }
    
  }
  else
  {
    print('false');
    return 'false';
  }
}

Future<String> fetchPost3(int a) async {
  print('fetchPost3');
  final response = await http.get('http://10.0.31.143/?flight_id='+a.toString());
  if (response.statusCode == 200)
  {
    print(response.body);
    
    //Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.body == 'null')
    {
      print('false');
      return 'false';
    }
    else
    {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      var _id = int.parse(jsonResponse['Id']);
      var _driverId = int.parse(jsonResponse['DriverId']);
      var _passengersCount = int.parse(jsonResponse['PassengersCount']);
      var _cash = int.parse(jsonResponse['Cash']);
      var _flightNumber = int.parse(jsonResponse['FlightNumber']);
      flight = new Flight(_id, _driverId, _passengersCount, jsonResponse['FlightStartTime'], _cash, jsonResponse['GovermentNumber'], _flightNumber);
      return response.body;
    }
    
  }
  else
  {
    print('false');
    return 'false';
  }
}

Future<bool> fetchPost4(int tickCount, int cost, int flightId) async {
  final response = await http.get('http://10.0.31.143/?paymentType=Cash&ticketsCount='+tickCount.toString()+'&Cost='+cost.toString()+'&flight_id='+flightId.toString());
  if (response.statusCode == 200)
  {
    print(response.body);
    //Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.body == 'null')
    {
      print('false');
      return false;
    }
    else
    {
      print('response.body');
      return true;
    }
    
  }
  else
  {
    print('false');
    return false;
  }
}




void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => WellcomeScreen(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/login': (context) => LoginScreen(),
      '/start': (context) => StartScreen(),
      '/stop': (context) => StopScreen(),
      '/main': (context) => MainScreen(),
      '/paymentCash1': (context) => CashPaymentScreen1(),
      '/paymentCash2': (context) => CashPaymentScreen2(),
      '/paymentCash3': (context) => CashPaymentScreen3(),
      '/paymentCard': (context) => CardPaymentScreen(),
    },
  ));
}



class WellcomeScreen extends StatelessWidget {
  final textError = TextEditingController();
  static final GlobalKey<FormFieldState<String>> _formKey = GlobalKey<FormFieldState<String>>();
  String _id_ = ""; 
  @override
  Widget build(BuildContext context) {
    
    
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return Drawer(
      child: new Column(
        
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            child: Column(
              children: <Widget>[
                Image.asset('img/logo.png', width: MediaQuery.of(context).size.width/2),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Text(
                  'Добро пожаловать!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    ),
                  ),
                ),
                
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 40, 200, 0),
                  child: Text('ID водителя'),
                ),
                Container(
                  color: Color.fromARGB(0, 243, 243, 243),
                  margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: TextFormField(
                    //controller: myController,
                    key: _formKey,
                    validator: (value) {},
                    onSaved: (String val) {_id_ = val;},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Введите свой ID'
                    ),
                ),
                ),
              ],
            ),
            
          ),
          TextField(
            
            controller: textError,
            enableInteractiveSelection: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '',
              ),
            
          ),
          Expanded(
            child: SizedBox.expand(
              child:  Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                    var a = fetchPost1(_id_);
                    a.then(
                      (b) { 
                        if (b)
                        {
                          Navigator.pushNamed(context, '/login'); textError.text = "";
                        }
                        else
                        {
                          textError.text = "Водителя с таким ID несуществует";
                        }
                      }).catchError((e) {

                      }).whenComplete(() {});
                  },
                  child: Text(
                    "Войти",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}


class LoginScreen extends StatelessWidget {
  String _gn;
  String _fn;
  //final _formKey = GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _formKey = GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _formKey1 = GlobalKey<FormFieldState<String>>();
  FocusNode textSecondFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Form(
        //autovalidate: true,
        //key: _formKey,
        child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: <Widget>[
                Image.asset('img/logo2.png', width: MediaQuery.of(context).size.width/2),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                  'Введите данные:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    ),
                  ),
                ),
                
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text('Они необходими для входа в приложение'),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Text('Гос. номер'),
                ),
                Container(
                  color: Color.fromARGB(0, 243, 243, 243),
                  margin: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: TextFormField(
                    //autofocus: true,
                    //onEditingComplete: () {gnCntrl.dispose();},
                    key: _formKey,
                    validator: (value) {},
                    onSaved: (String val) {_gn = val;},
                    //controller: gnCntrl,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Введите гос. номер'
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0,20, 0, 0),
                  child: Text('Номер маршрута'),
                ),
                Container(
                  color: Color.fromARGB(0, 243, 243, 243),
                  margin: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: TextFormField(
                    key: _formKey1,     
                    //controller: fnCntrl,               
                    //onEditingComplete: () {fnCntrl.dispose();},
                    validator: (val) {},
                    onSaved: (String val) {_fn = val;},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Введите номер маршрута'
                    ),
                  ),
                ),
              ],
            )
            
          ),
          
          Expanded(
            child: SizedBox.expand(
              child:  Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    //Navigator.pushNamed(context, '/start');
                    /*if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      print('valid');
                    }
                    if (formKey1.currentState.validate()) {
                      formKey1.currentState.save();
                      print('valid');
                    }*/
                    //print(_formKey.currentState.validate());
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                    if(_formKey1.currentState.validate()) {
                      _formKey1.currentState.save();
                    }
                    var a1 = fetchPost2(driver.getId(), _gn, _fn);
                    a1.then(
                      (b) { 
                        if (b != 'false')
                        {
                          print(b);
                          flight.printInfo();
                          Navigator.pushNamed(context, '/start'); 
                        }
                        else
                        {
                          //textError.text = "Водителя с таким ID несуществует";
                        }
                      }).catchError((e) {

                      }).whenComplete(() {});
                  },
                  child: Text(
                    "Начать смену",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      )
      
    );
  }
}





class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              height: 140,
              width: MediaQuery.of(context).size.width,
              //decoration: BoxDecoration(
                //color: const Color(0xff7c94b6),
              //),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(70, 60, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${driver.surname}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ), 
                  Container(
                    margin: EdgeInsets.fromLTRB(60, 10, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${driver.surname} ${driver.midname}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ), 
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 20.0, 0, 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ОБЩАЯ ИНФОРМАЦИЯ:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Стаж работы:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('${driver.dayCountExperience}', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Всего смен:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('${driver.daysWorked}', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Рейтинг водителя:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('${driver.rating}', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              child: Column(
                children: <Widget>[

                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.greenAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Сменить маршрут",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(

              child: Align(
                
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {                    
                    Navigator.pushNamed(context, '/stop');
                  },
                  child: Text(
                    "Начать рейс",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








class StopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              height: 140,
              width: MediaQuery.of(context).size.width,
              //decoration: BoxDecoration(
                //color: const Color(0xff7c94b6),
              //),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(70, 60, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${driver.surname}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ), 
                  Container(
                    margin: EdgeInsets.fromLTRB(60, 10, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${driver.surname} ${driver.midname}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ), 
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 20.0, 0, 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ТЕКУЩИЙ РЕЙС:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Кол-во пассажиров:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('${flight.passengersCount}', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Время с начала смены:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('${flight.time}', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20.0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text('Сумма:'),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-40.0, -15.0, 0.0),
                    alignment: Alignment.topRight,
                    child: Text('1 448 руб', style: TextStyle( fontWeight: FontWeight.bold),),
                  ),
                  
                ],
              )
            ),
            Container(
              child: Column(
                children: <Widget>[

                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.greenAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Сменить маршрут",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Align(
                
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  child: Text(
                    "Начать рейс",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 60,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    height: 100,
                    width: 150,
                    child:
                    FlatButton(
                      
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.greenAccent,
                      onPressed: () {
                        Navigator.pushNamed(context, '/paymentCash1');
                      },
                      child: Text(
                        "Наличной",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 150,
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child:
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.greenAccent,
                    
                      onPressed: () {
                        //Navigator.pushNamed(context, '/paymentCard');
                      },
                      child: Align(
                        
                        child: Text(
                          "Транспортной картой",
                          style: TextStyle(fontSize: 19.0),
                          textAlign: TextAlign.center,
                        ) 
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          )
          
        ],
      ),
    );
  }
}


class CashPaymentScreen1 extends StatelessWidget {
  static final GlobalKey<FormFieldState<String>> _formKey = GlobalKey<FormFieldState<String>>();
  TextEditingController _controller = new TextEditingController();
  Text textSum = new Text(''); 
  int tickets = 0;
  int sum = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container( 
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Оплата наличными',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Введите кол-во билетов',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(50, 100, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Стоимость',
                    ),
                    Container(
                      width: 120,
                      height: 60,
                      color: Colors.grey,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                          '21',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            backgroundColor: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      
                    ),
                    
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 100, 40, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Кол-во билетов',
                    ),
                    Container(
                      width: 120,
                      height: 60,
                      color: Colors.grey,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          key: _formKey,
                          onChanged: (value) { 
                            if (value.isEmpty) sum += 1;
                            sum = 21 * int.parse(value);
                            _controller.text = sum.toString();
                          },
                          //validator: (value) {},
                          //onSaved: (String val) {tickets = int.parse(val); },
                          onEditingComplete: () { sum = tickets*21; },
                          decoration: InputDecoration(
                            
                            counterStyle: TextStyle(
                              fontSize: 30,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                            border: InputBorder.none,
                            hintText: 'Введите',

                          ),
                        ),

                        
                      ),
                      
                    ),
                    
                  ],
                ),
              ),
              
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(50, 20, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Итого',
                    ),
                    Container(
                      width: 270,
                      height: 60,
                      color: Colors.grey,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: 
                          TextField(
                            controller: _controller,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              
                              counterStyle: TextStyle(
                                fontSize: 30,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              border: InputBorder.none,
                              hintText: '',

                            ),
                          ),
                      ),
                      
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 150, 10, 10),
              decoration: BoxDecoration(

              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                
                  onPressed: () {
                    
                    //var a = fetchPost4(tickets, sum, 13);
                    


                    Navigator.pushNamed(context, '/paymentCash2');
                  },
                  child: Align(
                    
                    child: Text(
                      "Подтвердить",
                      style: TextStyle(fontSize: 19.0),
                      textAlign: TextAlign.center,
                    ) 
                  ),
                ),
              ),
            ),
            
          ),
        ],
      )
    );
  }
}

class CashPaymentScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
          child: Image.asset(
            'img/some2.png', 
            width: MediaQuery.of(context).size.width,
          ),
        ),
        ],
        
      ),
      
    );
  }
}

class CardPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
        'Оплата по карте :3',
    );
  }
}

class CashPaymentScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Text('CashPaymentScreen3'),
    );
  }
}