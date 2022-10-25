import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:project/data/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/pages/main_page.dart';
import 'package:project/pages/register_page.dart';
import 'package:project/text_form_fields/email_text_form_field.dart';
import 'package:project/text_form_fields/password_text_form_fields.dart';
import 'package:project/texts/error_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) 
  : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final AuthService authService = AuthService(firebaseAuth: FirebaseAuth.instance);
    
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Logowanie'),
        ),
        body: LoginPageBody(authService: authService),
      ),
    );
  }
}

class LoginPageBody extends HookWidget{
  const LoginPageBody({
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
    final state = useState(_isButtonPressed);
    String _error = "";
    final errorState = useState(_error);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  : const Text("Sign in"),
                  textColor: Colors.white,
                  splashColor: Colors.greenAccent,
                  onPressed: () async {
                    
                    HapticFeedback.lightImpact();
                    SystemSound.play(SystemSoundType.click);
                    
                    state.value = true;
                    
                    await Future.delayed(const Duration(seconds: 1));
                    try {
                      
                      final res = await authService.signInWithEmail(email.text, password.text);
                      
                      switch (res) {
                        case SignInResult.success:
                          email.text="";
                          password.text="";
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const MainPage()
                              ),
                            );
                            errorState.value = "";
                          break;
                        case SignInResult.emailAlreadyInUse:
                          errorState.value = 'This email address is already in use.';
                          break;
                        case SignInResult.invalidEmail:
                          errorState.value = 'This email address is invalid.';
                          break;
                        case SignInResult.userDisabled:
                          errorState.value = 'This user has been banned.';
                          break;
                        case SignInResult.userNotFound:
                          errorState.value = 'User has not been found, please create account';
                          break;
                        case SignInResult.wrongPassword:
                          errorState.value = 'Invalid credentials.';
                          break;
                        default:
                          errorState.value = 'Unexpected error';
                          break;
                        }
                      } catch(_) {
                        errorState.value = 'Unexpected error';
                  }
                  state.value = false;
                }),
                const SizedBox(height: 16),
                MaterialButton(
                  color: const Color(0xFF388E3C),
                  child: const Text('Register'),
                  textColor: Colors.white,
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    SystemSound.play(SystemSoundType.click);
                    Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage()
                              ),
                            );
                  },
                ),
                const SizedBox(height: 16),
                errorState.value != ""
                 ? ErrorText(error: errorState.value)
                 : const SizedBox(),
              ],
          ),
        ),
      ),
    );
  }
}



