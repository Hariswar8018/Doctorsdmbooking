import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, i) {

              final user = UserModel.fromMap(
                snap.data!.docs[i].data(),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey,
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.phone.toString()),
                        trailing: genderIcon(user.gender),
                      ),
                      Row(
                        children: [
                          left("Age", user.age.toString()),
                          SizedBox(width: 15,),
                          left("Occupation", user.occupation.toString()),
                        ],
                      ),
                      left("Phone", user.phone.toString()),
                      left("Email", user.email.toString()),
                      left("Place", user.place.toString()),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
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
  Widget left(String str, String str2)=>Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("       $str : ${str2}",style: TextStyle(fontWeight: FontWeight.w500),),
  );
}