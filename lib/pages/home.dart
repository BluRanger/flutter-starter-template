import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume/helper/storage/storage.dart';
import 'package:resume/model/state.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _AddResumePageState();
}

class _AddResumePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    StateClass userState = Provider.of<StateClass>(context, listen: false);
    // UserState user = context.watch<UserState>();
    //TODO do a call and get data from mongodb for the master data and set it to state
    Storage().getObjectLocally().then((value) {
      if (value != null) {
        setState(() {
          // loads state
        });
      }
    });

    // print(user.user!.password + " " + user.user!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StateClass>(
      builder: (BuildContext context, userState, Widget? child) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
              child: Center(
                  child: Column(
            children: [Text("Hello to Home")],
          ))),
        );
      },
    );
  }
}
