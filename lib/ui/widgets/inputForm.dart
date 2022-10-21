import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyCustomInputBox extends StatefulWidget {
  String label;
  String inputHint;
  String btntxt;
  TextEditingController txtControler ;

  MyCustomInputBox({this.label, this.inputHint , this.txtControler , this.btntxt});
  @override
  _MyCustomInputBoxState createState() => _MyCustomInputBoxState();
}

class _MyCustomInputBoxState extends State<MyCustomInputBox> {
  bool isSubmitted = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                      padding: EdgeInsets.only(left: 20),
              child: Text(
                widget.label,
                style: TextStyle(
                // fontFamily: 'Product Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
          //
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),

            child: TextFormField(
              keyboardType:  widget.label == "Code" ?  TextInputType.number : TextInputType.text ,
              controller: widget.txtControler,
              obscureText: widget.label == 'Password' ? true : false,
              // this can be changed based on usage -
              // such as - onChanged or onFieldSubmitted
              onChanged: (value) {
                setState(() {
                  isSubmitted = true;
                });
              },
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff0962ff),
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: widget.inputHint,
                hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[350],
                    fontWeight: FontWeight.w600),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusColor: Color(0xff0962ff),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xff0962ff)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey[350],
                  ),
                ),

              ),
            ),
          ),
          //
        ],
      ),
    );
  }
}