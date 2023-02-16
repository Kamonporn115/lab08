import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab08/pages/login.dart';
import 'package:lab08/pages/services/auth_service.dart';

import '../services/auth_service.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"), actions: [
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                LoginPage();
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
            },
            icon: const Icon(Icons.logout))
      ]),
      body: SafeArea(
          child: Form(
        key: _formkey,
        child: ListView(
          children: [
            TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Email Please!";
                  }
                  return null;
                })),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              validator: ((value) {
                if (value!.isEmpty) {
                  return "Enter Password Please ";
                }
                return null;
              }),
            ),
            TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Email Please!";
                  }
                  return null;
                })),
            TextFormField(
              controller: _telController,
              decoration: const InputDecoration(labelText: "Tel"),
              validator: ((value) {
                if (value!.isEmpty) {
                  return "Enter Password Please ";
                }
                return null;
              }),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    print("OK");
                    AuthService()
                        .registerUser(
                            _emailController.text, _passwordController.text)
                        .then((value) {
                      if (value == 1) {
                        // Add user info to Firestore
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        print(uid);
                        CollectionReference users =
                            FirebaseFirestore.instance.collection("Users");
                        users.doc(uid).set({
                          "fullname": _nameController.text,
                          "phone": _telController.text,
                        });

                        // Navigator.pop(context);
                      }
                    });
                    //   AuthService.registerUser(
                    //           _emailController.text, _passwordController.text)
                    //       .then((value) {
                    //     if (value == 1) {
                    //       Navigator.pop(context);
                    //     }
                    //   });
                    // }
                  }
                },
                child: const Text("Register")),
          ],
        ),
      )),
    );
  }
}
