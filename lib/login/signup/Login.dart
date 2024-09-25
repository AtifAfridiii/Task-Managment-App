

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/login/signup/Sign_up.dart';
import 'package:todo/provider/Circular_Indicator.dart';
import 'package:todo/provider/visivble_passoward.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
   final TextEditingController _email =TextEditingController();
  final TextEditingController _passoward = TextEditingController();
   final formkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _email.dispose();
    _passoward.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Circular_provider>(context, listen: false);
    void Login(){
  if(formkey.currentState!.validate()){
     authProvider.setLoading(true);
 auth.signInWithEmailAndPassword(email: _email.text, password: _passoward.text).then((value) {
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Login successfull',
              message:
                  'Welcome to Todo me!',
              contentType: ContentType.warning,
            ),
          ));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
},).onError((error, stackTrace) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),
  backgroundColor: Colors.red,
  behavior: SnackBarBehavior.floating,
  ));
  
},).whenComplete(() {
      authProvider.setLoading(false);
    });;
            
    }


}


    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(31),
              const Row(
                children: [
                  Gap(11),
                  Text('Login',style: TextStyle(fontSize: 31,fontWeight: FontWeight.bold),)
                ],
              ),
              const Gap(31),
             const Align(
              alignment: AlignmentDirectional(BorderSide.strokeAlignInside, 2),
              child: Text('Email',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
              const Gap(11),
              TextFormField(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: InputDecoration(
                  
                 prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      
                    )
                  )
                ),
                validator: (value) {
                  if(value==null || value.isEmpty){
                    return 'Please enter your email';
                  }
                  return null ;
                },
              ),
              const Gap(31),
              const Align(
              alignment: AlignmentDirectional(BorderSide.strokeAlignInside, 2),
              child: Text('Passoward',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
              const Gap(11),
              Consumer<Visible_Passoward>(
                builder: (context, val, child) {
                return TextFormField(
                  obscureText: val.visibile_passoward_login,
                autocorrect: true,
                keyboardType: TextInputType.visiblePassword,
                controller: _passoward,
                decoration: InputDecoration(
                  suffixIcon:  InkWell(
                    onTap: (){
                      val.setPassoward1();
                    },
                    child: Icon(val.visibile_passoward_login? Icons.visibility_off_outlined: Icons.visibility_outlined  )),
                 prefixIcon:  Icon(Icons.lock_open),
                  hintText: 'Enter Passoward',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      
                    )
                  )
                ),
                 validator: (value) {
                  if(value==null || value.isEmpty){
                    return 'Please enter your passoward';
                  }
                  return null ;
                },
              );
  
              },) , 
               const Gap(39),
              SizedBox(
                width: 351,
                child: Consumer<Circular_provider>(builder: (context, vale, child) {
                  return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700
                  ),
                  onPressed: (){
                  Login();
                }, child: vale.isLoading? CircularProgressIndicator(color: Colors.white,):Text('Log in',style: TextStyle(color: Colors.white),));
 
                },)             ),
              const Gap(31),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                   const Text('Don\'t have an account?',style: TextStyle(fontSize: 17),),
                   InkWell(
                    onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp(),)) ; 
                    },
                    child: const Text('Sign up',style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.bold),)),
                   ]
                ),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}