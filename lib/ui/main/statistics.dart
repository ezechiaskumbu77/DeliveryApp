import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ICard25.dart';
import 'package:delivery_template/ui/widgets/ICard26.dart';
import 'package:delivery_template/ui/widgets/IList1.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  final Function(String) callback;
  StatisticsScreen({Key key, this.callback}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+30),
          child: _body(),
        )
      ],
    );
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    var list = List<Widget>();

    list.add(
        ICard26(
          color: theme.colorBackgroundDialog,
          text: '35',
          text2: strings.get(24), // 'Orders',
          text3: '78',
          text4: strings.get(49), // 'km',
          text5: '\$408,44',
          text6: strings.get(83), // 'Earning',
          textStyle: theme.text18bold,
          text2Style: theme.text16,
        )
    );

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20),
      child: IList1(imageAsset: 'assets/earning.png', text: strings.get(83),        // 'Earning',
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    list.add(
        ICard25(
          bottomTexts: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
          bottomTexts2: ['5', '10', '15', '20', '25'],
          bottomTextStyle: theme.text14,

          width: windowWidth,
          height: windowWidth * 0.45,

          color: theme.colorPrimary.withOpacity(0.1),
          colorTimeIcon: theme.colorGrey,

          colorAction: theme.colorPrimary,
          actionText: strings.get(81), // 'week',
          actionText2: strings.get(82), // month
          action: theme.text12white,

          data: [233, 323, 455, 350, 202, 303, 303],
          data2: [233, 323, 455, 350, 202, 103, 303,233, 323, 455, 100, 202, 303, 505, 455, 323, 455, 350, 202, 303, 303,233, 323, 400, 350, 202, 303, 303],
          colorLine: theme.colorPrimary,
          shadowColor: Colors.white,
        )
    );
    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20),
      child: IList1(imageAsset: 'assets/statistics.png', text: strings.get(24),        // 'Orders',
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    list.add(
        ICard25(
          bottomTexts: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
          bottomTexts2: ['5', '10', '15', '20', '25'],
          bottomTextStyle: theme.text14,

          width: windowWidth,
          height: windowWidth * 0.45,

          color: theme.colorPrimary.withOpacity(0.1),
          colorTimeIcon: theme.colorGrey,

          colorAction: theme.colorPrimary,
          actionText: strings.get(81), // 'week',
          actionText2: strings.get(82), // month
          action: theme.text12white,

          data: [2, 3, 5, 2, 8, 5, 6],
          data2: [2, 3, 5, 2, 8, 5, 6, 2, 3, 5, 2, 8, 5, 6, 2, 3, 5, 2, 8, 5, 6, 2, 3, 5, 2, 3, 5, 6],
          colorLine: theme.colorPrimary,
          shadowColor: Colors.white,
        )
    );

    list.add(SizedBox(height: 100,));
    return list;
  }

}

