import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatefulWidget {
  TokenModel token ; final bool admin;
  HistoryCard({super.key,required this.token,required this.admin});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  bool showMore = false;
  Widget genderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case "male":
        return const Icon(Icons.male, color: Colors.blue, size: 28);

      case "female":
        return const Icon(Icons.female, color: Colors.pink, size: 28);

      case "transgender":
        return const Icon(Icons.transgender, color: Colors.purple, size: 28);

      default:
        return const Icon(Icons.person_outline);
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final token = widget.token;

    return widget.admin?Center(
      child: Container(
        width: w-30,height: showMore ? 280 : (widget.admin ? 200 : 160),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:Border.all(
                color:Colors.grey
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xffEDF6FD),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(
                      child: Text(widget.token.tokenNumber.toString(),style: TextStyle(
                          fontSize: 27,color: GlobalWidget.color,height: 1
                      ),),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.token.doctor.doctorName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
                      Text(widget.token.doctor.department,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12),),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xffEDF6FD),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network("https://cdn-icons-png.flaticon.com/512/4042/4042171.png"),
                      )
                    ),
                  ),
                  SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.token.user.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
                      Text("Phone : "+widget.token.user.phone.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 12),),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    child: Text(
                      showMore ? "Show Less" : "Show More",
                      style: TextStyle(
                        color: GlobalWidget.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (showMore) ...[

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.cake, size: 18),
                    const SizedBox(width: 6),
                    Text("Age : ${token.user.age}"),
                    SizedBox(width: 25,),
                    genderIcon(token.user.gender),
                    const SizedBox(width: 6),
                    Text("${token.user.gender}"),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.work, size: 18),
                    const SizedBox(width: 6),
                    Text("Occupation : ${token.user.occupation}"),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Text("Place : ${token.user.place}"),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.email, size: 18),
                    const SizedBox(width: 6),
                    Text(token.user.email),
                  ],
                ),
              ],
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.calendar_month,color: Colors.grey,),
                  Text(" Booked at : "+times(widget.token.time),
                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700,fontSize: 12),),
                  Spacer(),
                  widget.admin
                      ? ElevatedButton(
                    onPressed: widget.token.status == "completed"
                        ? null
                        : () async {

                      await FirebaseFirestore.instance
                          .collection("tokens")
                          .doc(DateTime.now().toString().split(" ").first)
                          .collection("queue")
                          .doc(widget.token.id)
                          .update({
                        "status": "completed"
                      });

                    },
                    child: const Text("Complete"),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF6FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text(
                      capitalize(widget.token.status),
                      style: TextStyle(
                        color: GlobalWidget.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ):Center(
      child: Container(
        width: w-30,height: widget.admin?180:160,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:Border.all(
                color:Colors.grey
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Color(0xffEDF6FD),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("TOKEN",style: TextStyle(color: GlobalWidget.color),),
                        Text(widget.token.tokenNumber.toString(),style: TextStyle(
                            fontSize: 27,color: GlobalWidget.color,height: 1
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.token.doctor.doctorName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16),),
                      Text(widget.token.doctor.department,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12),),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.calendar_month,color: Colors.grey,),
                  Text(time(widget.token.time),
                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700,fontSize: 12),),
                  Spacer(),
                  widget.admin
                      ? ElevatedButton(
                    onPressed: widget.token.status == "completed"
                        ? null
                        : () async {

                      await FirebaseFirestore.instance
                          .collection("tokens")
                          .doc(DateTime.now().toString().split(" ").first)
                          .collection("queue")
                          .doc(widget.token.id)
                          .update({
                        "status": "completed"
                      });

                    },
                    child: const Text("Complete"),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF6FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text(
                      capitalize(widget.token.status),
                      style: TextStyle(
                        color: GlobalWidget.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String times(int str){
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String time(int str){
    final formattedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
  }
}
