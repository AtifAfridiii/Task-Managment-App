
import 'package:flutter/material.dart';

class Visible_Passoward with ChangeNotifier{

bool visibile_passoward_login = true;
get Visible_Passoward_Login => visibile_passoward_login;

bool visibile_passoward_signup1 = true;
get Visible_Passoward_Signup => visibile_passoward_signup1;

bool visibile_passoward_signup2 = true;
get Visible_Passoward_Signup2 => visibile_passoward_signup2;


void setPassoward1(  ){

visibile_passoward_login=!visibile_passoward_login;
notifyListeners();
}


void setPassoward2(){

visibile_passoward_signup1=!visibile_passoward_signup1;
notifyListeners();
}

void setPassoward3(){

visibile_passoward_signup2=!visibile_passoward_signup2;
notifyListeners();
}


}