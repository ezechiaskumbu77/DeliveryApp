import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:delivery_template/models/orderPPC.dart';
import 'package:delivery_template/ressources/getOrdersApi.dart';

import 'package:delivery_template/ui/widgets/inputForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';




class ConfirmeOrder extends StatefulWidget {

  OrderPPCModel order ;
 // ShopModel shop ;
  ConfirmeOrder({Key key , this.order}) : super(key: key);
  @override
  _ConfirmeOrderState createState() => _ConfirmeOrderState();
}

class _ConfirmeOrderState extends State<ConfirmeOrder> {



  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }

  TextEditingController codeContoller = TextEditingController();

String errMsg =' ';
String _code = '';
  @override
  Widget build(BuildContext context) {



    var windowWidth = MediaQuery.of(context).size.width;
    var  windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
        child: Stack(
          children: [
            Column(
              children: [
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Icon(Icons.arrow_back_ios_sharp,size: 35,),
                    )

                    ,
                  ),
                ),


              ],
            ),

            Column(
              children: [
                SizedBox(height: 30,),
                Center(
                  child: Text(

                    'Confirmer la livraison',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
                Divider(),

                SizedBox(height: 20,),

                _buildScan(context,widget.order.id),

              //  MyCustomInputBox(label : 'Code', inputHint: 'Entrez le code de confirmation de la livraison ', txtControler: codeContoller, btntxt : 'Envoyer'),
             //   SizedBox(height: 20,),
                Text(errMsg, style: TextStyle(color: Colors.red),),
             //   SizedBox(height: 20,),
              //  btnContinuer(context,codeContoller , widget.order.id)

              ],
            )
          ],
        ),
      )





    );










  }



  Widget _buildScan(BuildContext context , String id , ) {
    return Center(
      child: Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 300,
            height: 500,
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  width: 280,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: QRBarScannerCamera(
                    onError: (context, error) => Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    qrCodeCallback: (code) async {



                      if(!(_code==code)) {
                        Loader.show(context,progressIndicator:CircularProgressIndicator());
                        _code = code ;
                        print('see theeee $code');

                        GetOrder order = GetOrder();
                        // print('see the code ${code}');
                        var resp = await  order.confirm(id, code);

                        if(resp){
                          await Loader.hide();
                          int count = 0;

                          errMsg = 'Le code n\'est pas correct';
                        //  Navigator.of(context).pop();

                        } else {
                          await Loader.hide();
                          setState(() {
                            errMsg = 'Le code n\'est pas correct';

                          });
                          // _qrCallback(code);
                        }

                      }

                    }
                  ),
                ),
                // Text(
                //   _qrInfo,
                //   style: TextStyle(color: Colors.black26),
                // ),
              ],
            ),
          )),
    );
  }




  Widget btnContinuer(BuildContext ctx ,var code, String id) {

    return ArgonButton(
      height: 50,
      roundLoadingShape: true,
      width: MediaQuery.of(ctx).size.width * 0.45,
      onTap: (startLoading, stopLoading, btnState) {
        if (btnState == ButtonState.Idle) {
          startLoading();

          Timer(const Duration(milliseconds: 1000), () async {
            print('see the code ${code.text.toString()}');
            stopLoading();
            GetOrder order = GetOrder();
               // print('see the code ${code}');
            var resp = await  order.confirm(id, code.text.toString());

            if(resp){
              int count = 0;
              Navigator.of(ctx).pop();
              stopLoading();
            } else {
              setState(() {
                errMsg = 'Le code n\'est pas correct';
                stopLoading();
              });


            }

          //  CreateService serv = CreateService();

     //  var resp = await serv.create(widget.shop);

     //  print('see the reponse' + resp.toString());







          });

        } else {
          stopLoading();
        }
      },
      child: Text(
        'Envoyer',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700),
      ),
      loader: Expanded(
        child: Container(
            padding: EdgeInsets.all(10),
            child:  SpinKitWave(
                size: 16,
                color: Colors.white, type: SpinKitWaveType.start)
        ),
      ),
      borderRadius: 5.0,
      color: Colors.blueAccent,
    );
  }
}
