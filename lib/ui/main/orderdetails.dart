import 'dart:ui';

import 'package:delivery_template/models/delivery.dart';
import 'package:delivery_template/models/orderItemPPC.dart';
import 'package:delivery_template/models/orderPPC.dart';
// import 'package:delivery_template/ressources/getGeoloc.dart';
import 'package:delivery_template/ressources/getOrdersApi.dart';
import 'package:delivery_template/ressources/localeDB.dart';
// import 'package:delivery_template/ui/main/confirmOrder.dart'; 
// import 'package:delivery_template/ui/widgets/ibutton2.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
// import 'package:delivery_template/model/order.dart';
// import 'package:delivery_template/ui/widgets/ICard22.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:delivery_template/main.dart';
// import '../../message_list.dart';
// import '../../token_monitor.dart';

class OrdersDetailsScreen extends StatefulWidget {
  //final Function(String, Map<String, dynamic>) callback;
  // final Map<String, dynamic> params;  this.params,
  final DeliveryModel delivery;
  OrdersDetailsScreen({ this.delivery});

  @override
  _OrdersDetailsScreenState createState() => _OrdersDetailsScreenState();
}

int _currentTabIndex = 0;

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  /*_onCallback(String id) {
    print('User tap on order card with id: $id');
    account.currentOrder = id;
    account.backRoute = 'orders';
    widget.callback('orderDetails', {});
  }*/
 

    OrderPPCModel orderppc;
  

  //
  ///////////////////////////////////////////////////////////////////////////////
  LocalDB db = LocalDB();
  var _myF;
    GetOrder getOrder;

  String idOrder = '0';
  
  double windowWidth = 0.0;
  double windowHeight = 0.0; 
 
  @override
  void initState() {
   
    getOrder = GetOrder();
    _myF = getOrder.fetchAllOrderPPCItem(widget.delivery.order.id);
    super.initState();
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  //  _myF = getOrder.fetchAllOrderPPCItem(widget.delivery.order.id);
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return  
        Scaffold(
         appBar: AppBar(elevation: 10, title: Text('Details', style:TextStyle(color:Colors.redAccent, fontSize: 20, fontWeight: FontWeight.w900 )),),
       
            body: FutureBuilder(
          future: _myF,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              // return Center(
              // child: Text(
              // 'Something yes ${snapshot.hasData}wrong with message: ${snapshot.error.toString()}'),
              // );
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*UnconstrainedBox(
                        child: Container(
                            height: windowHeight / 3,
                            width: windowWidth / 2,
                            child: Container(
                              child: Image.asset(
                                'assets/nonotify.png',
                                fit: BoxFit.contain,
                              ),
                            ))),*/
                    SizedBox(
                      height: 10,
                    ),
                    Text('Aucun produit trouvé!', // 'Not Have Orders',
                        overflow: TextOverflow.clip,
                        style: theme.text16bold),
                    SizedBox(
                      height: 10,
                    ),
                   
                  ],
                ));
              } else {
                //  print('has data ${snapshot.hasData}');
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black12,
                  ),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<OrderItemPPC> orderItemList;
              if (snapshot.data != null) {
                orderItemList = snapshot.data;
                print('see it now ' + orderItemList.length.toString());
                return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 25),
                    child: /*TabBarView(
                      controller: _tabController,
                      children: <Widget>[*/
                        Container(
                          child: _body(orderItemList),
                        ) );
              } else {
                // return Center(
                // child: Text(
                // 'Something wrong with message: ${snapshot.error.toString()}'),
                // );

                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*UnconstrainedBox(
                        child: Container(
                            height: windowHeight / 3,
                            width: windowWidth / 2,
                            child: Container(
                              child: Image.asset(
                                'assets/nonotify.png',
                                fit: BoxFit.contain,
                              ),
                            ))),*/
                    SizedBox(
                      height: 10,
                    ),
                    Text('Aucun produit trouvé!', // 'Not Have Orders',
                        overflow: TextOverflow.clip,
                        style: theme.text16bold),
                    SizedBox(
                      height: 10,
                    ),
                   
                  ],
                ));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black12,
                ),
              );
            }
          },
        )) ;
  }

  _body(  List<OrderItemPPC> orderItemList) {
     

    if (orderItemList.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: windowHeight / 3,
                  width: windowWidth / 2,
                  child: Container(
                    child: Image.asset(
                      'assets/nonotify.png',
                      fit: BoxFit.contain,
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Text((strings.get(50)), // 'Not Have Orders',
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          SizedBox(
            height: 15,
          ),
       
        ],
      ));
    } else {
      return ListView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        children: _body2(  orderItemList),
      );
    }
    
  }

  _body2( List<OrderItemPPC> orderItemList) {
    var list = <Widget>[];

    for (var _data in orderItemList) {
      
        list.add(cardOrderItem(_data));
     
    }
    return list;
  }
 
  Widget cardOrderItem(OrderItemPPC _data) {
    
    
    return ListTile(
      title: Padding(
          padding: EdgeInsets.only(bottom: 9),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   '  Produit : ',
                      //   style: TextStyle(
                      //       color: Colors.black54, fontWeight: FontWeight.w700),
                      // ),
                       Icon(Icons.poll_rounded, size: 45,),
                      Text('  ' + _data.product.name.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w900))
                    ]),
              /*  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Prix : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  Fc ' + _data.price.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w900))
                    ]),*/
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Qté : ',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.quantity.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w900))
                    ]),
                /*Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Total :',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  Fc ' + (_data.quantity*_data.price).toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w900))
                    ]),*/
                 
                //_data.accepted==true && _data.accepted!=true &&
                 
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
      onTap: () {},
    );
  }

 
}
