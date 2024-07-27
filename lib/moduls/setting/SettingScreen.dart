import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:info_popup/info_popup.dart';
import 'package:noter/models/user.dart';
import '../../bloc/user/user_bloc.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool editing = false;
  double sizeBoxGap = 30;

  @override
  Widget build(BuildContext context) {
    UserAccount user = context.read<UserBloc>().user;
    TextEditingController
    nameController = TextEditingController(text: user.name),
        emailController = TextEditingController(text: user.email),
        locationController = TextEditingController(text: user.location),
        languageController = TextEditingController(text: user.language);
    return Column(
      children: [
        SizedBox(
          height: sizeBoxGap,
        ),
        editing?
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(
                height: sizeBoxGap,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(
               height: sizeBoxGap,
              ),
              Text(
                'Gender: ${user.gender}',
              ),
              SizedBox(
               height: sizeBoxGap,
              ),
              Text(
               'Birthday: ${user.birthday.year}-${user.birthday.month}-${user.birthday.day}',
              ),
              SizedBox(
                height: sizeBoxGap,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              SizedBox(
               height: sizeBoxGap,
              ),
              TextFormField(
                controller: languageController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Language',
                ),
              ),
            ],
          ):
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name}',
            ),
            SizedBox(
              height: sizeBoxGap,
            ),
            Text(
              'Email: ${user.email}',
            ),
            SizedBox(
              height: sizeBoxGap,
            ),
            Text(
              'Gender: ${user.gender}',
            ),
            SizedBox(
              height: sizeBoxGap,
            ),
            Text(
              'Birthday: ${user.birthday.year}-${user.birthday.month}-${user.birthday.day}',
            ),
            SizedBox(
              height: sizeBoxGap,
            ),
            Text(
              'Location: ${user.location}',
            ),
            SizedBox(
              height: sizeBoxGap,
            ),
            Text(
              'Language: ${user.language}',
            ),

          ],
        ),
        SizedBox(
          height: sizeBoxGap,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: (){
                  editing = true;
                  setState(() {

                  });
                },
                child: Text(
                    'Edit Profile'
                )
            ),
            TextButton(
                onPressed: (){
                  editing = false;
                  user.name = nameController.text;
                  user.email = emailController.text;
                  user.location = locationController.text;
                  user.language = languageController.text;
                  context.read<UserBloc>().add(UserEventUpdate(user.email, user.name, user.location, user.language));
                  setState(() {

                  });
                },
                child: Text(
                    'Save Changes'
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InfoPopupWidget(
              child: TextButton(
                  onPressed: (){
                    context.read<UserBloc>().add(UserEventResetPassword(user.email));
                  },
                  child: Text(
                      'Reset Password'
                  )
              ),
              customContent: (){
                return Text('Check your email and click on the link to reset your password');
              },
            ),
            TextButton(
                onPressed: (){
                  context.read<UserBloc>().add(UserEventLogout(user.email));
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                    'Logout'
                )
            ),
            InfoPopupWidget(
              child: TextButton(
                  onPressed: (){
                    context.read<UserBloc>().add(UserEventDelete(user.email));
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                      'Delete Account'
                  )
              ),
              customContent: (){
                return Text('Are you sure you want to delete your account? This action is not reversible!');
              },
            ),
          ],
        ),
        SizedBox(
          height: 35
        ),
        Text(
            'Send me your feedback and suggestions. Contact Info: \n'
                'Email: sabdo6177@gmail.com \n'
                'WhatsApp: +20 1018625142'
        )
      ],
    );
  }
}
