import 'package:chat_app/features/homePage/ui/homePage.dart';
import 'package:chat_app/features/registerPage/ui/registerPage.dart';
import 'package:chat_app/service/authService.dart';
import 'package:chat_app/util/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingActionState) {
            showDialog(
                context: context,
                builder: (context) {
                  return Container(
 width: MediaQuery.of(context).size.width*0.7,
 height: MediaQuery.of(context).size.height*0.4,
                    child: Center(child: CircularProgressIndicator()),
                  );
                });
          }
          else if(state is LoginErrorActionState){

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error")));
          }
          else if(state is LoginLoadedState){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
            HomePage()));
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.network(
                          "https://static.mineitor.com/side-right.png",
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      _textFormField("Email", emailController),
                      _textFormField("Password", passController),
                      InkWell(
                        onTap: () {
                          context.read<LoginBloc>().add(LoginInitialEvent(
                                email: emailController.text,
                                password: passController.text,
                              ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple.withOpacity(0.7),
                          ),
                          child: const Center(
                              child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: Texts().Stext,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text(
                              " Register",
                              style: Texts()
                                  .Stext
                                  .copyWith(color: Colors.deepPurple),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _textFormField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}