import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexapod/views/pad_view.dart';
import 'package:dart_ping/dart_ping.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormBuilderState> _fbKey = new GlobalKey<FormBuilderState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _portKey = 'port';
  final _ipKey = 'address';

  bool socketReady = false;

  @override
  void initState() {
    super.initState();
  }

  void _ping(String addr) async {
    var p = await ping(addr, times: 2);
    p.listen((data) {
      print("hoho");
      setState(() {
        socketReady = true;
      });
    }).onError((err) {});
  }

  final errorView = (size) => new SafeArea(
        child: new Scaffold(
          //bottomNavigationBar: footer,
          body: new Container(
            child: Image.asset(
              "assets/socker-error.png",
              width: size,
            ),
            alignment: Alignment.center,
          ),
        ),
      );

  void _submit() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var values = _fbKey.currentState.value;
      var _ip = values['ip_address'] ?? "";
      var _port = values['port'] ?? 8080;

      var prefs = await _prefs;
      setState(
        () {
          prefs.setString(_portKey, _port);
          prefs.setString(_ipKey, _ip);
        },
      );

      var _addr = _ip + ":" + _port;
      _ping(_addr);

      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => !socketReady
              ? errorView((MediaQuery.of(context).size.height))
              : new PadView(title: "Pad", ip: _ip, port: _port),
        ),
      );
    } else {
      print("unvalid form");
    }
  }

  Future<Map<String, String>> _getSaveData() async {
    var prefs = await _prefs;
    var port = prefs.getString(_portKey);
    var ip = prefs.getString(_ipKey);
    var map = new Map<String, String>();
    map.putIfAbsent(_ipKey, () => ip);
    map.putIfAbsent(_portKey, () => port);
    return Future.value(map);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      backgroundColor: Color.fromRGBO(58, 80, 86, 1.0),
      title: new Text(widget.title),
    );

    final _form = (ip, port) => new FormBuilder(
          key: _fbKey,
          initialValue: {'ip_address': ip, 'port': port},
          autovalidate: true,
          child: new Column(
            children: <Widget>[
              new FormBuilderTextField(
                attribute: 'ip_address',
                decoration: new InputDecoration(
                  labelText: 'IP',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validators: [
                  FormBuilderValidators.IP(),
                ],
              ),
              new FormBuilderTextField(
                attribute: 'port',
                decoration: new InputDecoration(
                  labelText: 'Port',
                ),
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.numeric(),
                ],
              ),
            ],
          ),
        );

    return new SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar,
        body: new FutureBuilder(
          future: _getSaveData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Container();
            }
            if (snapshot.hasData && snapshot.data != null) {
              return new Column(
                children: <Widget>[
                  _form(snapshot.data[_ipKey], snapshot.data[_portKey]),
                  new SizedBox(
                    height: 20,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new MaterialButton(
                      onPressed: _submit,
                      color: Color.fromARGB(255, 207, 207, 207),
                      height: 100,
                      minWidth: 200,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: new BorderSide(
                          color: Color.fromRGBO(58, 80, 86, 1.0),
                        ),
                      ),
                      child: Image.asset(
                        'assets/startup.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return new SpinKitDoubleBounce(
                color: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }
}
