import 'dart:ui';
  
import 'package:delivery_template/models/delivercar.dart';
import 'package:delivery_template/ressources/getDeliverCarApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:delivery_owner/model/order.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDeliverCarProduct extends StatefulWidget {
  final order;
  //AddDeliverCarProduct({  this.delivery});
  // Function(String, Map<String, dynamic>) callback;
  // final Map<String, dynamic> params;
  AddDeliverCarProduct({this.order});

  @override
  _AddDeliverCarProductState createState() => _AddDeliverCarProductState();
}

class ItemDeliverCar {
  const ItemDeliverCar(this.name, this.id);
  final String name;
  final int id;
}

ItemDeliverCar selectedDeliverCar;
List<ItemDeliverCar> delivercars = <ItemDeliverCar>[
  const ItemDeliverCar('Selectionnez', 0),
  const ItemDeliverCar('Produit Endommagé', 1),
  const ItemDeliverCar('Produit Durcis', 2),
  const ItemDeliverCar('Produit Incomplet', 3),
  const ItemDeliverCar('Produit avec prise lente', 4),
  const ItemDeliverCar('Produit avec prise trop rapide', 5),
  const ItemDeliverCar('Produit avec résistance faible', 6),
  const ItemDeliverCar('Produit peu éconmique', 7),
];

class _AddDeliverCarProductState extends State<AddDeliverCarProduct>
    with TickerProviderStateMixin {
  // late OrderPPCModel orderppc;
  final qtyController = TextEditingController();
  ///////////////////////////////////////////////////////////////////////////////

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  final _formKeybookstep2 = GlobalKey<FormState>();
  bool visible = false;
  bool visibledelivercarchoice = false;
  GetDeliverCar getDeliverCar = GetDeliverCar();
  DeliverCarModel dc = DeliverCarModel(); 

  _sendFeedback() async {
   
    
    
    setState(() {
      visible = true;
    });
    print('begin execute $dc');
    var resp = await getDeliverCar.postDeliverCar(dc);


    if (resp) {
    //  setState(() {
        visible = false;
     // });

      await Fluttertoast.showToast(
          msg:
              'Votre feedback a bien été envoyé, nous vous repondrons d\'ici peu!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

          Navigator.of(context).pop();
      // return;
    } else {
      await Fluttertoast.showToast(
          msg: 'Une erreur s\'est produite, vérifiez votre connexion',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        visible = false;
      });
    }
    //return;
  }

  @override
  void initState() {
    // _myF = getDeliverCar.fetchAllOrderPPCItem(widget.order.id);
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
    final _height = MediaQuery.of(context).size.height;
    final _fixedPadding = _height * 0.025;

    final validateBtn = Container(
      margin: EdgeInsets.only(top: 15.0, left: 25, right: 25),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: Colors.white),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Navigator.pop(context);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => AddDeliverCarProduct()));

          if (selectedDeliverCar != null) {
            _sendFeedback();
          } else {
            await Fluttertoast.showToast(
                msg: 'Vous n\avez rien selectionné',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'ENVOYER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
      ),
    );

    final forminput = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Form(
        key: _formKeybookstep2,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    left: _fixedPadding,
                    right: _fixedPadding,
                    bottom: _fixedPadding),
                child: delivercarWidget()),

            Visibility(
                visible: visibledelivercarchoice,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(' Quantité posant problème',
                            style: TextStyle(
                                color: Colors.black, fontSize: 13.0))))),
            //  PhoneNumber TextFormFields
            Visibility(
                visible: visibledelivercarchoice,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: _fixedPadding,
                        right: _fixedPadding,
                        bottom: _fixedPadding),
                    child: Card(
                      shape: new RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black54),
                          borderRadius: new BorderRadius.circular(40.0)),
                      shadowColor: Colors.black,
                      borderOnForeground: true,
                      child: Row(
                        children: <Widget>[
                          Text('  qté' + ' ',
                              style: TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.w700)),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: qtyController,
                              //  autofocus: true,
                              keyboardType: TextInputType.number,
                              key: Key('EnterPhone-TextFormField'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorMaxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
            // inputtclientField,
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: visible,
                child: Center(
                    child: Column(children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.red,
                    strokeWidth: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Envoie en cours ...',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  )
                ]))),
            validateBtn,
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
        body: Container(
            // margin: EdgeInsets.only(top: 20),
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'FeedBack - Produit         ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            )),
        forminput
      ],
    )));
  }

  Widget delivercarWidget() {
    return Container(
        // width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.only(
          top: 3,
          left: 0,
          right: 0,
        ),
        // padding: EdgeInsets.only(),
        child: Center(
            child:Card(
                shape: new RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black54),
                    borderRadius: new BorderRadius.circular(40.0)),
                shadowColor: Colors.black,
                borderOnForeground: true,
                child: Align(
                alignment: Alignment.topRight,
                child: DropdownButton<ItemDeliverCar>(
                  iconSize: 24,
                  elevation: 8,
                  isExpanded: true,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                  ),
                   underline: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  hint: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.trip_origin,
                          color: Colors.black, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Selectionnez',
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ],
                  ),
                  value: selectedDeliverCar,
                  onChanged: (ItemDeliverCar value) {
                    setState(() {
                      selectedDeliverCar = value;

                      // switch (value.id) {
                      //   case 2:
                      //     dcProduct = DeliverCarProduct.durcis(
                      //         EvaluationProduct.durcis, 0);
                      //     break;
                      //   case 1:
                      //     dcProduct = DeliverCarProduct.endommage(
                      //         EvaluationProduct.endommage, 0);
                      //     break;
                      //   case 3:
                      //     dcProduct = DeliverCarProduct.incomplete(
                      //         EvaluationProduct.incomplete, 0);

                      //     break;
                      //   case 4:
                      //     dcProduct = DeliverCarProduct.quality(
                      //         EvaluationProductQuality.priselente);

                      //     break;
                      //   case 5:
                      //     dcProduct = DeliverCarProduct.quality(
                      //         EvaluationProductQuality.prisetroprapide);
                      //     break;
                      //   case 6:
                      //     dcProduct = DeliverCarProduct.quality(
                      //         EvaluationProductQuality.resistancefaible);
                      //     break;
                      //   case 7:
                      //     dcProduct = DeliverCarProduct.quality(
                      //         EvaluationProductQuality.paseconomique);
                      //     break;
                      //   default:
                      // }

                      if (0 < value.id && value.id < 4) {
                        visibledelivercarchoice = true;
                      } else {
                        visibledelivercarchoice = false;
                      }
                      // madelivercar = value.name;
                    });
                  },
                  items: delivercars.map((ItemDeliverCar delivercar) {
                    return DropdownMenuItem<ItemDeliverCar>(
                      value: delivercar,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.trip_origin,
                              color: Colors.black, size: 25),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            delivercar.name,
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )))));
  }
}
