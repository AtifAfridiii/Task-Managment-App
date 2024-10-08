import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/login/signup/Login.dart';
import 'package:todo/provider/Circular_Indicator.dart';
import 'package:todo/provider/visivble_passoward.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {
   final TextEditingController _email =TextEditingController();
    final TextEditingController _passoward = TextEditingController();
    final TextEditingController _confirmpassoward = TextEditingController();
    final _formkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
     _email.dispose();
     _passoward.dispose();
     _confirmpassoward.dispose();
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Circular_provider>(context, listen: false);
    void RegisterUser(){
      if(_formkey.currentState!.validate()){
          authProvider.setLoading(true);          
                   if(_passoward.text==_confirmpassoward.text&&_email.text.endsWith('@gmail.com')){
                     auth.createUserWithEmailAndPassword(email: _email.text.toString(),
                      password:_passoward.text.toString() ).then((value) {

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Registered successfully',
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
    });
                     
                   }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password does not match or email is miss used '),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    
                    ));
                   }
                   
              

                 
                   }
   }

 
     return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(31),
              const Row(
                children: [
                  Gap(11),
                  Text('Register',style: TextStyle(fontSize: 31,fontWeight: FontWeight.bold),)
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
                  if(value==null|| value.isEmpty){
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
                builder: (context, valu, child) {
                return   TextFormField(
                  obscureText: valu.visibile_passoward_signup1,
                autocorrect: true,
                keyboardType: TextInputType.visiblePassword,
                controller: _passoward,
                decoration: InputDecoration(
                  suffixIcon:  InkWell(
                    onTap: (){
                      valu.setPassoward2();
                    },
                    child: Icon(valu.Visible_Passoward_Signup? Icons.visibility_off_outlined:Icons.visibility_outlined)),
                 prefixIcon: const Icon(Icons.lock_open),
                  hintText: 'Enter Passoward',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      
                    )
                  )
                ),
                validator: (value) {
                  if(value==null|| value.isEmpty){
                    return 'Please Enter passoward';
                  }
                  return null ;
                }
              );
 
              },)
              , const Gap(31),
              const Align(
              alignment: AlignmentDirectional(BorderSide.strokeAlignInside, 2),
              child: Text('Confirm Passoward',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
              const Gap(11),
           Consumer<Visible_Passoward>(
            builder: (context, val, child) {
             return    TextFormField(
                autocorrect: true,
                obscureText: val.visibile_passoward_signup2,
                keyboardType: TextInputType.visiblePassword,
                controller: _confirmpassoward,
                decoration: InputDecoration(
                  suffixIcon:  InkWell(
                    onTap: (){
                      val.setPassoward3();
                    },
                    child: Icon(val.visibile_passoward_signup2? Icons.visibility_off_outlined : Icons.visibility_outlined)),
                 prefixIcon: const Icon(Icons.lock_open),
                  hintText: 'Enter Passoward',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      
                    )
                  )
                ),
                validator: (value) {
                  if(value==null|| value.isEmpty){
                    return 'Please Confirm your passoward';
                }
                return null ;
                }
              );

           },)     
          ,  const Gap(39),
              SizedBox(
                width: 351,
                child:Consumer<Circular_provider>(builder: 
                (context, valie, child) {
                  return  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700
                  ),
                  onPressed: (){
                 RegisterUser();
                }, child: valie.isLoading? const CircularProgressIndicator(color: Colors.white,) : const Text('Register',style: TextStyle(color: Colors.white),));
 
                },)             ),
              const Gap(31),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                   const Text('Already have an account?',style: TextStyle(fontSize: 17),),
                   InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));
                    },
                    child: const Text('Login',style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.bold),)),
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