import 'dart:ui'; 
import 'package:delivery_template/models/delivercar.dart';
import 'package:delivery_template/ressources/getDeliverCarApi.dart';
import 'package:delivery_template/ressources/localeDB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class DeliverCarDetails extends StatefulWidget {
  final delivercar;
 
  DeliverCarDetails({this.delivercar});

  @override
  _DeliverCarDetailsState createState() => _DeliverCarDetailsState();
}

class _DeliverCarDetailsState extends State<DeliverCarDetails>
    with TickerProviderStateMixin {
  // late OrderPPCModel orderppc;
  final qtyController = TextEditingController();
  final answerController = TextEditingController();
  ///////////////////////////////////////////////////////////////////////////////
  LocalDB db = LocalDB();
  // var _myF;
  GetDeliverCar getDeliverCar;

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  final _formKeybookstep2 = GlobalKey<FormState>();
  bool visible = false;
  var getmessageList;

  @override
  void initState() {
    getDeliverCar = GetDeliverCar();
    getmessageList = getDeliverCar.fetchHistoryByDeliverCar(widget.delivercar);
    // _myF = getOrder.fetchAllOrderPPCItem(widget.order.id);
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
       getmessageList = getDeliverCar.fetchHistoryByDeliverCar(widget.delivercar);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(children: [
            Text(
              'FeedBack',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w600),
            )
          ]),
        ),
        body: SingleChildScrollView(
            // margin: EdgeInsets.only(top: 20),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            cardDeliverCar(widget.delivercar),
            messageList( )
          ],
        )),
        //bottomSheet: AnswerView(delivercar: widget.delivercar)
        );
  }

  Widget cardDeliverCar(DeliverCarModel _data) {
    //  print(_data.order.id);
    var status = '';
    var colorstatus;
    //opened', 'in progress', 'closed
    if (_data.status == 'unusable') {
      status = 'En etat';
      colorstatus = Colors.amber;
    } else if (_data.status == 'usable') {
      colorstatus = Colors.red;
      status = 'Pas en etat';
    }  

    return ListTile(
      title: Padding(
          padding: EdgeInsets.only(bottom: 9, top: 8),
          child: Card(
            elevation: 5,
            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.car_fill ,
                         color: Colors.black ,
                         size: 30,
                      ),
                      Text('  ' + _data.marque,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w800))
                    ]),
                SizedBox(
                  height: 9,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '  Statut : ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 20.0,
                          //width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: colorstatus),
                            color: colorstatus,
                          ),
                          child: Center(
                              child: Text(
                            status,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )))
                    ]),
                SizedBox(
                  height: 5,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 8,
                      // ),
                      // Icon(Icons.timer, size: 17, color: Colors.black54),
                      Text(
                        '  Châssis : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.chassis,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                    ]),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 8,
                      // ),
                      // Icon(Icons.timer, size: 17, color: Colors.black54),
                      Text(
                        '  Année de fabrication : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.anneeDefabrication,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                    ]),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 8,
                      // ),
                      // Icon(Icons.timer, size: 17, color: Colors.black54),
                      Text(
                        '  Kilometrage : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.kilometrage,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                    ]),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 8,
                      // ),
                      // Icon(Icons.timer, size: 17, color: Colors.black54),
                      Text(
                        '  Numero de Plaque : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.numeroDePlaque,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                    ]),
                /* Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  ID:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  '  + _data.id,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),*/
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
      onTap: () {
        //  Navigator.pop(context);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => DeliverCarDetails(delivercar: _data)));
      },
    );
  }

  Widget messageList( ) {

    return FutureBuilder(
      future: getmessageList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // return Center(
          // child: Text(
          // 'Something yes ${snapshot.hasData}wrong with message: ${snapshot.error.toString()}'),
          // );
          if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Padding(
                      padding: EdgeInsets.only(bottom: 13, top: 5, left: 10, right: 13),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Aucun historique',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      )));
         
          } else {
           // print('has data ${snapshot.hasData}');
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
              ),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var historicals;
          if (snapshot.data != null) {
            historicals = snapshot.data;
            print('leng mess: '+historicals.length.toString());
            if(historicals.length==0)
            {
              return 
                Center(
                      child: Padding(
                      padding: EdgeInsets.only(bottom: 13, top: 5, left: 10, right: 13),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Aucun historique',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ))) ;

            }else{
            return Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
              child: Container(
                      child: Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                child: Center(child:  Text( ' Historique ' ,
                    style: TextStyle(
                      fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic)))),
                    SizedBox(
                      height: 8,
                    ),
                     
                    for (var _message in historicals)
                     messageItem(_message),
                    SizedBox(
                      height: 8,
                    )
                  ],
                )),
              ),
            );
          }
          }else{
            return Center(
                child: Padding(
                      padding: EdgeInsets.only(bottom: 13, top: 5, left: 10, right: 13),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Aucun historique',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      )));
          }
           
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black12,
            ),
          );
        }
      },
    );
    
  }

  Widget messageItem(_message) {

    return Padding(
        padding: EdgeInsets.only(bottom: 7, top: 7, left: 8, right: 8),
        child: Card(
          elevation: 5,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Row( 
                children:[
                    SizedBox(
                width: 9,
              ),
                  Icon(Icons.person, size: 17, color: Colors.black),
                  
                  Text(
                    '  ' + _message['delivery'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                ]
              ),
              SizedBox(
                height: 7,
              ),
              Text('     ' + _message['created'].toString().substring(0,10),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 8,
              ),
              Row( children:[
                 SizedBox(
                width: 9,
              ),
                  Icon(Icons.chat, size: 17, color: Colors.blue),
                
                  Text(
                    '    ' + _message['created'].substring(0, 10),
                    style: TextStyle(
                      fontSize: 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic))
              ]),
              SizedBox(
                height:8,
              )
            ],
          ),
        ));
  }
}

 