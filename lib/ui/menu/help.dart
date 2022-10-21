import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/icard7.dart';

class HelpScreen extends StatefulWidget {
  final String title;
  HelpScreen({Key key, this.title}) : super(key: key);
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin{

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _tabIndexChanged(){
    print('Tab index is changed. New index: ${_tabController.index}');
  }
  //
  //
  //
  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_tabIndexChanged);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Stack(
        children: <Widget>[

          Container(
            width: windowWidth,
            height: windowHeight*0.2,
            child: IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient)
          ),

        Container(
            margin: EdgeInsets.only(top: windowHeight*0.2),
            height: 30,
            child: TabBar(
              indicatorColor: theme.colorPrimary,
              labelColor: Colors.black,
              tabs: [
                Text(strings.get(34),     // 'Products',
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(35),     // 'Services',
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(36),     // 'Delivery',
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(37),     // 'Misc',
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
              ],
              controller: _tabController,
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: 30+windowHeight*0.2),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[

                  Container(
                    child: ListView(
                      children: _getList(),
                    ),
                  ),

                  Container(
                    child: ListView(
                      children: _getList(),
                    ),
                  ),

                  Container(
                    child: ListView(
                      children: _getList(),
                    ),
                  ),

                  Container(
                    child: ListView(
                      children: _getList(),
                    ),
                  ),

                ],

              )  ),

        ],
      ),
    );
  }


  List<Widget> _getList(){
    var list = List<Widget>();

    list.add(Row(
      children: <Widget>[
        SizedBox(width: 20,),
        Icon(Icons.help_outline),
        SizedBox(width: 10,),
        Text(strings.get(38), style: theme.text20bold),   // 'Help & support',
      ],
    ));

    list.add(SizedBox(height: 25,));
    list.add(_item(strings.get(1), strings.get(3)));
    list.add(_item(strings.get(1), strings.get(0)));
    list.add(_item(strings.get(1), strings.get(3)));
    list.add(_item(strings.get(1), strings.get(0)));

    return list;
  }

  _item(String _title, String _body){
    return ICard7(
        color: theme.colorPrimary,
      title: _title, titleStyle: theme.text14,
      body: _body, bodyStyle: theme.text14,
    );
  }

}
