import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String _ip, _port;

  void _read() async {
    var prefs = await SharedPreferences.getInstance();
    final portKey = 'port';
    _port = prefs.getString(portKey);
    final ipKey = 'address';
    _ip = prefs.getString(ipKey);
    print('setting');
    print('_host: $_ip');
    print('_port: $_port');
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  void _save() async {
    var prefs = await SharedPreferences.getInstance();
    final portKey = 'port';
    await prefs.setString(portKey, _port);
    final ipKey = 'address';
    await prefs.setString(ipKey, _ip);
    print('save: $_ip');
    print('save: $_port');
  }

  void _submit() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var values = _fbKey.currentState.value;
      _ip = values.entries
          .firstWhere((entry) => entry.key.compareTo('ip_address') == 0)
          .value;
      _port = values.entries
          .firstWhere((entry) => entry.key.compareTo('port') == 0)
          .value;
      print(_ip);
      print(_port);
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final appBar = new AppBar(
      backgroundColor: Color.fromRGBO(58, 80, 86, 1.0),
      title: new Text(widget.title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()  {
          Navigator.pop(context, '$_ip:$_port');
        }
      ),
    );

    final form = new FormBuilder(
      key: _fbKey,
      initialValue: {'ip_address': _ip, 'port': _port},
      autovalidate: true,
      child: new Column(
        children: <Widget>[
          new FormBuilderTextField(
            attribute: 'ip_address',
            decoration: InputDecoration(labelText: 'IP'),
            keyboardType: TextInputType.text,
            validators: [
              FormBuilderValidators.IP(),
            ],
          ),
          new FormBuilderTextField(
            attribute: 'port',
            decoration: InputDecoration(
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

    final submit = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: _submit,
            child: Text('Save'),
          ),
        )
      ],
    );

    final body = new Column(
      children: <Widget>[form, submit],
    );

    return new SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
