// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:freelancerr_frontend/InfoTile.dart';
import 'package:freelancerr_frontend/Job.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'User.dart';

class CustomList extends StatefulWidget {
  final User user;

  const CustomList({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  List<InfoTile> items = [];
  List<Job> jobs = [];

  @override
  void initState() {
    refreshJobs();
    super.initState();
  }

  Future refreshJobs() async {
    Uri uri = Uri.parse("http://10.0.2.2:8888/jobs/all");
    final response = await http.get(uri);
    var data = json.decode(response.body);
    //jobs = data;
    items = [];
    setState(() {
      for (var i = 0; i < data.length; i++) {
        items.add(
          InfoTile(
            title: data[i]['title'],
            image: Image.network(
              data[i]['imageLink'],
            ),
            jobId: data[i]['id'],
            userId: data[i]['userId'],
            user: widget.user,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return RefreshIndicator(
      onRefresh: refreshJobs,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InfoTile(
                title: items[index].title,
                image: items[index].image,
                jobId: items[index].jobId,
                userId: items[index].userId,
                user: widget.user,
              ),
            ],
          );
        },
      ),
    );
  }
}
