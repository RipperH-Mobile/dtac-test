import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtac_test/user/user_response.dart';
import 'package:dtac_test/user/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  final controller = Get.put(UserViewModel(), permanent: true);
  late Future<UserDetail> futureUser;
  late Timer timer;
  late Timer timer2;
  late int time = 60;

  late UserDetail data;

  @override
  initState() {
    // indata();
    super.initState();
    futureUser = controller.fetchUSER();
    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      setState(() {
        futureUser = controller.fetchUSER();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "รีเฟรชข้อมูลแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // location
          timeInSecForIosWeb: 2, // duration
        );
        time = 60 ;
      });
      log("IN Fetch $futureUser");
    });
    timer2 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        time = time - 1 ;
      });
      log("IN Fetch $futureUser");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User List "),
        ),
        body: FutureBuilder<UserDetail>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data!;
              return body(snapshot.data!);
            } else if (snapshot.hasError) {
              log("message : ${snapshot.error}");
              return Text('ERROR :${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: "รีเฟรชข้อมูลแล้ว",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM, // location
              timeInSecForIosWeb: 2, // duration
            );
            setState(() {
              futureUser = controller.fetchUSER();
            });

          },
          child: Container(
            height: 75,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Text(
                  "กดเพื่อรีเฟรชข้อมูล",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                 Text(
                  "รีเฟรชข้อมูลอัตโนมัติใน (${time})",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  body(UserDetail data) {
    return Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(32),
    child:SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child:
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.results?.length,
            itemBuilder: (BuildContext context, int index) {
              var item = data.results?[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      spreadRadius: .2,
                      blurRadius: 4,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 0,
                        child: ClipRRect(
                          borderRadius:  const BorderRadius.all(Radius.circular(100)),
                          child: item?.picture == null
                              ? CachedNetworkImage(
                            imageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fuser_149071&psig=AOvVaw2LfY98W4qokSnzNycj-xi5&ust=1696320274618000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCJi90szz1oEDFQAAAAAdAAAAABAE",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                              : CachedNetworkImage(
                            imageUrl: item?.picture?.large ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )),
                     Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ชื่อ : ${item?.name?.title} ${item?.name?.first} ${item?.name?.last} " , style: TextStyle(),),
                            Text("เพศ : ${item?.gender} "),
                            Text("อายุ : ${item?.dob?.age} "),
                            Text("อีเมล : ${item?.email} "),
                            Text("เบอร์ : ${item?.phone} "),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ));
  }


  @override
  void dispose() {
    Get.delete<UserViewModel>();
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }
}
