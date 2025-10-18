import 'package:cai_firebase/consts.dart';
import 'package:cai_firebase/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;
  const EditScreen({super.key, required this.data});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  CollectionReference groups = FirebaseFirestore.instance.collection(groupCollectionName);
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _studentsCountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _groupNameController.text = widget.data['name'];
    _studentsCountController.text = '${widget.data['students_count']}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Group'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Enter Group Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Field can't be empty!";
                }
                return null;
              },
              ),
              SizedBox(height: 20,),
              TextFormField(
              controller: _studentsCountController,
              decoration: InputDecoration(
                labelText: 'Enter Group Count',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Field can't be empty!";
                }
                return null;
              },
              ),
               SizedBox(height: 30,),
               SizedBox(
                width: double.infinity,
                height: 50,
                 child: ElevatedButton(onPressed: (){ 
                  editCategory();
                  Navigator.pushReplacementNamed(context, 'home');                 
                 },
                 style: ElevatedButton.styleFrom(backgroundColor: myPrimaryColor),
                  child: Text('Edit Group',style: TextStyle(color: Colors.white,fontSize: 25),)),
               )
            ],
          )
          ),
        )
    );
  }
  Future<void> editCategory() async {
    groups.doc(widget.data.id).update({
     'name' : _groupNameController.text,
     'students_count' : int.parse(_studentsCountController.text)
    })
    .then((value)=> UiHelpers.showSnackBar(context: context, message: 'Group Edited'))
    .catchError((error)=> UiHelpers.showSnackBar(context: context, message: 'Error : $error'));
  }
}