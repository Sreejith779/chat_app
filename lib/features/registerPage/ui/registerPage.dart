import 'package:chat_app/features/loginPage/ui/loginPage.dart';
import 'package:chat_app/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/texts.dart';
import '../bloc/register_bloc.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passController = TextEditingController();
    return  BlocProvider(
  create: (context) => RegisterBloc(),
  child: BlocBuilder<RegisterBloc, RegisterState>(
  builder: (context, state) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: Image.network("https://static.mineitor.com/side-right.png",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width*0.8,),
                ),
                _textFormField("Email",emailController),
                _textFormField("Name",nameController),
                _textFormField("Password",passController),
        
                InkWell(
                  onTap: ()async{
                if(formKey.currentState!.validate()){
            await  AuthService().registerUser(email: emailController.text,
                  password: passController.text,
                  name: nameController.text);
                }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.deepPurple.withOpacity(0.7),
                    ),
                    child: const Center(child: Text("Register",style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("have an account?",
                      style: Texts().Stext, ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            LoginPage()));
                      },
                      child: Text(" Login",style: Texts().Stext.copyWith(
                          color: Colors.deepPurple
                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  },
),
);
  }
  Widget _textFormField(String hintText,TextEditingController controller){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: (value){
          if(value! == null || value.isEmpty){
            return "Field can't be empty";
          }
        },
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            )
        ),
      ),
    );
  }
}
