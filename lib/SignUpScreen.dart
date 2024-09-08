import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SignInScreen.dart'; // Ensure this is the correct path to your SignInScreen file
import "package:intl/intl.dart";


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _username = '';
  String _sportEvent = '100M'; // Default value
  String _competitionDuration = '1 month'; // Default value
  String _age = '';
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  String _StartingDay ="";
  String _eventType ="Running";

  DateTime? _selectedDate;
  final _dateController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Store additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _username,
          'sportEvent': _sportEvent,
          'competitionDuration': _competitionDuration,
          'age': _age,
          'email': _email,
          'Startingday':_StartingDay,
          'event type':_eventType,
        });

        // Navigate to the sign-in screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            _errorMessage = 'The email address is already in use by another account.';
          });
        } else {
          setState(() {
            _errorMessage = 'An unknown error occurred. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Event Type'),
                value: _eventType,
                items: [
                  'Running', 'Jumping', 'Trowing'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _eventType = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a Event Type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventType = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sport Event'),
                value: _sportEvent,
                items: [
                  '100M', '200M', '400M', '800M', '1500M', '5000M', 'Long Jump', 'High Jump'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _sportEvent = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a sport event';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sportEvent = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Competition Duration'),
                value: _competitionDuration,
                items: [
                  '1 month', '3 months', '6 months', 'A year'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _competitionDuration = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a competition duration';
                  }
                  return null;
                },
                onSaved: (value) {
                  _competitionDuration = value!;
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),


    TextFormField(
      controller: _dateController,
      decoration: InputDecoration(labelText: 'Enter When you start your Workout'),
      readOnly: true, // Make the text field read-only
      onTap: () async {
        // Show the date picker when the text field is tapped
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) {
        if (_selectedDate == null) {
          return 'Enter your Workout Starting Day';
        }
        return null;
      },
      onSaved: (value) {
        _StartingDay = _selectedDate.toString();
      },
    ),

    TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
