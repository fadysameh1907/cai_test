import 'package:cai_firebase/consts.dart';
import 'package:cai_firebase/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {

}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
 
  CollectionReference groups = FirebaseFirestore.instance.collection(groupCollectionName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group'),
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
                  return 'Field can\'t be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
             TextFormField(
              controller: _groupCountController,
              decoration: InputDecoration(
                labelText: 'Enter Group Count',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Field can\'t be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    await addGroup();
                    Navigator.pushReplacementNamed(context, 'home');
                  }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myPrimaryColor
              ),
               child: Text(
                'Add Group',
                style: TextStyle(color: Colors.white),
               )),
            )
            ],
          )),
        ),
    );
  }
  
  Future<void> addGroup() async {
    return groups.
    add({
      'id' : FirebaseAuth.instance.currentUser!.uid ,
      'name' : _groupNameController.text,
      'students_count' : int.parse(_groupCountController.text)
    })
    .then((value)=> UiHelpers.showSnackBar(context: context, message: 'Group added'))
    .catchError((error)=> UiHelpers.showSnackBar(context: context, message: 'Failed to add group: $error'));

  }
}