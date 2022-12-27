import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:html' as webFile;
// import 'package:file_picker_web/file_picker_web.dart' as webPicker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_filter/images.dart';
// import 'package:shader_texts/shader_texts.dart';

class WebPage extends StatefulWidget {
  WebPage({Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  List<double> valuesList = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
  List<double> originalvaluesList = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  int imgindex = 0;
  int sliderindex = 0;
  double h = 10;
  double w = 10;
  bool _isComputer = true;
  bool _isLandscape = true;
  bool _isFullLandscape = true;
  bool _isFullPortait = true;

  List<double> sampleFloat64List = [
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
  ];

  @override
  void initState() {
    // TODO: implement initState
    try {
      // log('pll ${Platform.operatingSystem}');
      if (Platform.isAndroid || Platform.isIOS) {
        _isComputer = false;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        _isComputer = true;
      }
    } catch (e) {
      log('pll ${e}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    //  ColorFilter colorFilter =  ColorFilter.mode(Color(0x96f44336), BlendMode.darken)
    //   log("colorr ${colorFilter.}");
    if ((h / w) > 2) {
      _isLandscape = false;
      _isFullPortait = true;
    }
    if (h > w) {
      _isLandscape = false;
    }
    if ((w / h) > 1) {
      _isLandscape = true;
      _isFullLandscape = false;
    }
    if ((w / h) > 2) {
      _isFullLandscape = true;
    }
    log('constr ${w.toInt()}  / ${h.toInt()}  ');
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300, minWidth: 800),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
            _isLandscape ? landscapeCode() : portaitCode(),
            // Positioned(
            //   child: Text('Please resize window to vertical '),
            //   right: 0,
            //   bottom: 0,
            // ),
          ],
        ),
      ),
    );
  }

  _valuesMatrixLandscape() {
    return Container(
        width: w * 0.45,
        height: w * 0.45 * (0.8),
        child: GridView.builder(
            itemCount: valuesList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (c, i) {
              return Container(
                padding: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      sliderindex = i;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: sliderindex == i
                        ? Colors.blue.shade200.withAlpha(220)
                        : Colors.blue.shade100.withAlpha(180),
                    child: FittedBox(
                      child: Text(valuesList[i].toStringAsFixed(2)),
                    ),
                  ),
                ),
              );
            }));
  }

  _valuesMatrix() {
    return Container(
        width: w * 0.75,
        height: w * 0.75 * (0.8),
        child: GridView.builder(
            itemCount: valuesList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (c, i) {
              return Container(
                padding: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      sliderindex = i;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: sliderindex == i
                        ? Colors.blue.shade200.withAlpha(220)
                        : Colors.blue.shade100.withAlpha(180),
                    child: FittedBox(
                      child: Text(valuesList[i].toStringAsFixed(2)),
                    ),
                  ),
                ),
              );
            }));
  }

  _slider() {
    return Container(
      width: w * 0.95,
      height: h * 0.08,
      child: Slider(
          min: sliderindex % 5 == 4 ? 0 : -1,
          max: sliderindex % 5 == 4 ? 255 : 1,
          value: valuesList[sliderindex],
          onChanged: (d) {
            setState(() {
              valuesList[sliderindex] = double.parse(d.toStringAsFixed(3));
            });
          }),
    );
  }

  _sliderLandscape() {
    return Container(
      width: w * 0.45,
      height: h * 0.08,
      child: Slider(
          min: sliderindex % 5 == 4 ? 0 : -1,
          max: sliderindex % 5 == 4 ? 255 : 1,
          value: valuesList[sliderindex],
          onChanged: (d) {
            setState(() {
              valuesList[sliderindex] =
                  double.parse(d.toDouble().toStringAsFixed(3));
            });
          }),
    );
  }

  List<ColorFilter> modeFilters() {
    List<ColorFilter> filters = [];
    List<BlendMode> blendmodes = [
      BlendMode.darken,
      BlendMode.hue,
      BlendMode.luminosity,
      BlendMode.difference,
      BlendMode.exclusion,
      BlendMode.modulate,
      BlendMode.softLight,
    ];
    for (var color in Colors.primaries) {
      for (BlendMode blendMode in blendmodes) {
        filters.add(ColorFilter.mode(color.withAlpha(150), blendMode));
      }
    }
    return filters;
  }

  landscapeCode() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                imgindex++;
                setState(() {});
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(<double>[...valuesList]),
                child: Image.asset(
                  imgs[(imgindex + 8) % imgs.length],
                  fit: BoxFit.contain,
                  width: w * 0.45,
                  height: h * 0.8,
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                _valuesMatrixLandscape(),
                Row(
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     log('list ${valuesList},');
                    //   },
                    //   child: Text('Get Filter Code'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        log('list ${valuesList.length}, / ${sampleFloat64List.length}');
                        valuesList = List.from(originalvaluesList);

                        setState(() {});
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
                _sliderLandscape(),
                Container(
                  width: w * 0.45,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FittedBox(
                              child: SelectableText(valuesList.toString())),
                        ),
                      ),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: valuesList.toString()));
                          },
                          icon: Icon(Icons.copy))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        // Container(
        //   width: w,
        //   height: h * 0.2,
        //   color: Colors.grey,
        //   child: ListView.builder(
        //     itemCount: filters.length,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (c, i) {
        //     return Container(
        //       child: ColorFiltered(
        //         colorFilter:filters[i],
        //         child: Image.asset(
        //           imgs[(imgindex + 8) % imgs.length],
        //           fit: BoxFit.contain,
        //           width:  h * 0.2,
        //           height:  h * 0.2,
        //         ),
        //       ),
        //     );
        //   }),
        // )
      ],
    );
  }

  portaitCode() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ArtText(
          //   fontsize: 80,
          //   myFont: MyFont.acme,
          // ),
          InkWell(
            onTap: () {
              imgindex++;
              setState(() {});
            },
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(<double>[...valuesList]),
              child: Image.asset(
                imgs[(imgindex + 8) % imgs.length],
                fit: BoxFit.contain,
                width: double.infinity,
                height: h * 0.4,
              ),
            ),
          ),
          _valuesMatrix(),
          _slider(),
        ],
      ),
    );
  }

  List<ColorFilter> filters = [
    ColorFilter.matrix([
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.393,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.686,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.131,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// ------------
    ColorFilter.matrix([
      0.43,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.56,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.231,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.4126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.3152,
      0.0722,
      0,
      0,
      0.2126,
      0.2152,
      0.1722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// --------

    ColorFilter.matrix([
      0.693,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.286,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.431,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.1126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.52152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.4722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// --------

    ColorFilter.matrix([
      0.893,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.886,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.1231,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.5126,
      0.6152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// *********

// ------------
    ColorFilter.matrix([
      0.43,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.56,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.231,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.226,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.42,
      0.0722,
      0,
      0,
      0.2126,
      0.2152,
      0.1722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// --------

    ColorFilter.matrix([
      0.693,
      0.769,
      0.189,
      0,
      0,
      0.6,
      0.6,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.431,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.256,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.3152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.4722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),

// --------

    ColorFilter.matrix([
      0.83,
      0.769,
      0.4,
      0,
      0,
      0.349,
      0.886,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.1231,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    ColorFilter.matrix([
      0.46,
      0.7152,
      0.12,
      0,
      0,
      0.5126,
      0.9,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ])
  ];
}
