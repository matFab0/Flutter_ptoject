import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/auth_service.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/text_form_fields/email_text_form_field.dart';
import 'package:project/text_form_fields/name_text_form_field.dart';
import 'package:project/text_form_fields/password_text_form_fields.dart';
import 'package:project/texts/error_text.dart';
import 'package:project/texts/success_text.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final AuthService authService = AuthService(firebaseAuth: FirebaseAuth.instance);
    
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registering'),
        ),
        body: RegisterPageBody(authService: authService,),
      ),
    );
  }
}

class RegisterPageBody extends HookWidget{
  const RegisterPageBody({
    Key? key,
    required  this.authService
    })
  : super(key: key);

 final AuthService authService;
  
  @override
  Widget build(BuildContext context) {
    bool _isButtonPressed = false;
    final email = useTextEditingController();
    final password = useTextEditingController();
    final name = useTextEditingController();
    final state = useState(_isButtonPressed);
    String _error = "";
    String _success = "";
    final errorState = useState(_error);
    final successState = useState(_success);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                NameTextFormField(
                  name: name
                ),
                const SizedBox(height: 16),
                EmailTextFormField(
                  email: email
                ),
                const SizedBox(height: 16),
                PasswordTextFormField(
                  password: password
                ),
                const SizedBox(height: 16),
                MaterialButton(
                  color: const Color(0xFF388E3C),
                  child: state.value 
                  ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ) 
                  : const Text("Sign up"),
                  textColor: Colors.white,
                  splashColor: Colors.greenAccent,
                  onPressed: () async {
                    
                    HapticFeedback.lightImpact();
                    SystemSound.play(SystemSoundType.click);
                    
                    state.value = true;
                    
                    await Future.delayed(const Duration(seconds: 1));
                    try {
                      
                      final res = await authService.signUpWithEmail(email.text, password.text);
                      
                      if(res) {
                        authService.setName(name.text);
                        name.text="";
                        email.text="";
                        password.text="";
                         Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const LoginPage()
                              ),
                            );
                            successState.value = "Successfully created an account!";
                      } else {
                        errorState.value = "Couldn't have created an account";
                      }
                    } catch(_) {
                      errorState.value = 'Unexpected error';
                  }
                  state.value = false;
                }),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                errorState.value != ""
                 ? ErrorText(error: errorState.value)
                 : const SizedBox(),
                successState.value != ""
                  ? SuccessText(success: successState.value)
                  : const SizedBox()
              ],
          ),
        ),
      ),
    );
  }
}
