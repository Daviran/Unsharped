// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'post_widget.dart';
import 'loading_widget.dart';
import './../models/post_holder.dart';

class PostsList extends StatefulWidget {
  static const int pageSize = 15;

  PostHolder? holder;
  final Future<PostHolder> Function()? holderFetcher;
  final bool displaySubredditName;

  PostsList(
      {Key? key,
      this.holderFetcher,
      this.holder,
      required this.displaySubredditName})
      : super(key: key) {
    assert(holder == null || holderFetcher == null);
    assert(holder != null || holderFetcher != null);
  }

  @override
  State<StatefulWidget> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.holderFetcher != null) {
      widget.holderFetcher!.call().then((holder) => setState(() {
            widget.holder = holder;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.holder == null) {
      return const LoadingWidget();
    }
    PostHolder sub = widget.holder as PostHolder;

    ScrollController listController = ScrollController();
    Widget list = Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
            padding: const EdgeInsets.only(right: 20),
            child: const Text("Classer par: ")),
        Container(
            padding: const EdgeInsets.only(right: 20),
            child: DropdownButton<PostSort>(
                value: sub.sortingMethod,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (PostSort? newValue) {
                  loading = true;
                  setState(() {});
                  if (newValue! != PostSort.top) {
                    sub.topSortingMethod = null;
                  }
                  sub.sortingMethod = newValue;
                  sub.refreshPosts().then((_) => setState(() {
                        loading = false;
                      }));
                },
                items: PostSort.values
                    .map<DropdownMenuItem<PostSort>>((PostSort value) {
                  return DropdownMenuItem<PostSort>(
                    value: value,
                    child: value != PostSort.top
                        ? Text(value.toString().split('.').elementAt(1))
                        : Row(children: [
                            Text(
                                value.toString().split('.').elementAt(1) + " "),
                            DropdownButton<PostTopSort>(
                              value: sub.topSortingMethod,
                              elevation: 16,
                              onChanged: (PostTopSort? newValue) {
                                sub.topSortingMethod = newValue!;
                                sub.sortingMethod = PostSort.top;
                                sub.refreshPosts().then((_) => setState(() {}));
                              },
                              items: PostTopSort.values
                                  .map<DropdownMenuItem<PostTopSort>>(
                                      (PostTopSort value) {
                                return DropdownMenuItem<PostTopSort>(
                                    value: value,
                                    child: Text(value
                                        .toString()
                                        .split('.')
                                        .elementAt(1)));
                              }).toList(),
                            )
                          ]),
                  );
                }).toList()))
      ]),
      Expanded(
          child: NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if (listController.position.atEdge) {
                  loading = true;
                  setState(() {});
                  if (listController.position.pixels == 0) {
                    sub.refreshPosts().then((_) {
                      setState(() {
                        loading = false;
                      });
                    });
                  } else {
                    sub.fetchMorePosts().then((_) {
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                }
                return true;
              },
              child: Scrollbar(
                  child: ListView(
                shrinkWrap: true,
                controller: listController,
                children: [
                  for (var post in sub.posts)
                    PostWidget(
                        post: post,
                        displaySubName: widget.displaySubredditName,
                        preview: true)
                ],
              ))))
    ]);
    return Stack(children: [
      list,
      loading
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container())
          : Container(),
      loading ? const LoadingWidget() : Container()
    ]);
  }
}
