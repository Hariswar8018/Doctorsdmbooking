import 'package:flutter/material.dart';

class GlobalWidget{

  static Widget contain(double w,String str){
    return Container(
      width: w,
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xff014A8E),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(str,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          SizedBox(width: 5,),
          Icon(Icons.arrow_forward,color: Colors.white,)
        ],
      ),
    );
  }
  static Widget circular()=>Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.white,
      color: GlobalWidget.color,
    ),
  );

  static Color color = Color(0xff014A8E);
}