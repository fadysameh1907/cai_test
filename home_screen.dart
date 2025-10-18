import 'package:cai_firebase/consts.dart';
import 'package:cai_firebase/screens/groups/edit_screen.dart';
import 'package:cai_firebase/screens/students/students_screen.dart';
import 'package:cai_firebase/ui_helpers.dart';
import 'package:cai_firebase/widgets/group_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot> data = [];


  getData() async {
    QuerySnapshot querySnapshot = 
    await FirebaseFirestore.instance.collection('groups')
    .where('id' , isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .get();
    data.clear();
    data.addAll(querySnapshot.docs);
 
  setState(() {});

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
            title:  Text('Home Screen'),
            subtitle: Text('${FirebaseAuth.instance.currentUser?.email}'),
        ),
      
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, 'add_group');
      },
      backgroundColor: myPrimaryColor,
      child: Icon(Icons.add,color: Colors.white,),),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: data.length,
         itemBuilder: (context, index){
          return GroupItem(
            groupName: data[index]['name'],
             studentsCount: data[index]['students_count'],
             onTap: (){
              Navigator.push(
              context,MaterialPageRoute(builder: (context)=> StudentsScreen(documentId: data[index].id)));
             },
             onLongPress: ()=> UiHelpers.showMyDialog(context: context,
              title: 'Choose Action', 
              content: 'Please Choose Action',
              onConfirm: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> EditScreen(data: data[index],)));
              },
              onCancel: () async{
                await FirebaseFirestore.instance.collection(groupCollectionName)
                .doc(data[index].id).delete();
                getData();
                }
              ),
             );
         }),
    );
  }
}
