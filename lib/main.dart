import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Deezed Controller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPaused = false;
  bool isConnected = false;
  bool isSearching = false;
  var _userName = TextEditingController();

  double currentSliderValue = 2;
  String barcode;

  Future<void> _connect() async {
    barcode = await scanner.scan();
    final url = 'http://$barcode:8000/';

    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }

    print(isConnected);
  }

  Future<void> _sendInput(String input) async {
    final url = 'http://$barcode:8000/control';
    Vibration.vibrate(
      duration: 100,
      intensities: [20],
    );
    final response = await http.get(url, headers: {
      'controller': input,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isConnected = true;
      });

      if (input == 'resume') {
        setState(() {
          isPaused = !isPaused;
        });
      }
    } else {
      setState(() {
        isConnected = false;
      });
    }

    print(isConnected);
  }

  Future<void> _search(String input) async {
    final url = 'http://$barcode:8000/search';
    Vibration.vibrate(
      duration: 100,
      intensities: [20],
    );
    final response = await http.get(url, headers: {
      'controller': input,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isConnected = true;
      });

      if (input == 'resume') {
        setState(() {
          isPaused = !isPaused;
        });
      }
    } else {
      setState(() {
        isConnected = false;
      });
    }

    print(isConnected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isConnected
                    ? isSearching
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: _userName,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        _search(_userName.text);
                                        isSearching = false;
                                      },
                                    )
                                  },
                                  icon: Icon(Icons.search),
                                  color: Colors.white,
                                ),
                                prefixIcon: IconButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        isSearching = false;
                                      },
                                    )
                                  },
                                  icon: Icon(Icons.close),
                                  color: Colors.white,
                                ),
                                hintText: 'Pesquisar',
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: FlatButton.icon(
                                    onPressed: () => _sendInput('open'),
                                    icon: Icon(Icons.open_in_new),
                                    label: Text('Deezer App'),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: FlatButton.icon(
                                    onPressed: () => _sendInput('openweb'),
                                    icon: Icon(Icons.open_in_new),
                                    label: Text('Deezer Web'),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: IconButton(
                                    onPressed: () => {
                                      setState(
                                        () {
                                          isSearching = true;
                                        },
                                      )
                                    },
                                    icon: Icon(Icons.search),
                                  ))
                            ],
                          )
                    : Container(),
                SizedBox(
                  height: 70,
                ),
                isConnected
                    ? CircleAvatar(
                        foregroundColor: Colors.grey[900],
                        backgroundColor: Colors.grey[700],
                        radius: 150,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[900],
                          radius: 140,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 22,
                                ),
                                Icon(
                                  Icons.music_note,
                                  color:
                                      isConnected ? Colors.green : Colors.grey,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.repeat),
                                        onPressed: () => _sendInput('repeat')),
                                    IconButton(
                                        icon: Icon(Icons.volume_up),
                                        onPressed: () => _sendInput('volup')),
                                    IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: () => _sendInput('like')),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        onPressed: () =>
                                            _sendInput('bfrtrack')),
                                    CircleAvatar(
                                      radius: 20,
                                      child: IconButton(
                                          icon: Icon(Icons.arrow_left),
                                          onPressed: () =>
                                              _sendInput('voltar')),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      child: IconButton(
                                          icon: Icon(
                                            isPaused
                                                ? Icons.play_arrow
                                                : Icons.pause,
                                          ),
                                          onPressed: () =>
                                              _sendInput('resume')),
                                    ),
                                    CircleAvatar(
                                      radius: 20,
                                      child: IconButton(
                                          icon: Icon(Icons.arrow_right),
                                          onPressed: () =>
                                              _sendInput('avancar')),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () =>
                                            _sendInput('nxttrack')),
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(Icons.volume_down),
                                    onPressed: () => _sendInput('voldown')),
                                IconButton(
                                    icon: Icon(Icons.volume_off),
                                    onPressed: () => _sendInput('mute')),
                              ]),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                isConnected
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: Colors.grey[600],
                            thumbColor: Colors.grey[900],
                            overlayColor: Colors.grey,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 20.0),
                          ),
                          child: Slider(
                            value: currentSliderValue,
                            min: 0,
                            max: 9,
                            divisions: 9,
                            label: currentSliderValue.round().toString(),
                            onChanged: (value) {
                              setState(
                                () {
                                  currentSliderValue = value;
                                  _sendInput(value.toString());
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  height: MediaQuery.of(context).size.height / 14,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Lojhan',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
      floatingActionButton: isConnected
          ? Container()
          : FloatingActionButton.extended(
              icon: Icon(Icons.center_focus_weak),
              backgroundColor: Colors.blue,
              onPressed: () => _connect(),
              label: Text(
                  'Scan QR')), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
