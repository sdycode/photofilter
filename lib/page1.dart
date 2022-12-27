import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_filter/images.dart';
// import 'package:shader_texts/shader_texts.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
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
  int imgindex = 0;
  int sliderindex = 0;
  double h = 10;
  double w = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ArtText(fontsize: 80,myFont: MyFont.acme,),
          ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[...valuesList]),
            child: ImageFiltered(
              imageFilter: ImageFilter.matrix(Float64List.fromList([
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
              ])),
              child: Image.asset(
                imgs[imgindex + 8],
                fit: BoxFit.contain,
                width: w * 0.9,
                height: h * 0.4,
              ),
            ),
          ),
          _valuesMatrix(),
          ElevatedButton(
            onPressed: () {
              log('list ${valuesList}');
            },
            child: Text('Print'),
          ),
          _slider(),
        ],
      ),
    );
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
              valuesList[sliderindex] = d;
            });
          }),
    );
  }
}
