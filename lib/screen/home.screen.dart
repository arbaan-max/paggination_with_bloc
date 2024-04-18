import 'package:bloc_paggination/bloc/posts/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  /// Initializes the state of the widget.
  ///
  /// This method is called once when the stateful widget is inserted into the widget tree.
  /// It initializes the [scrollController] and dispatches a [GetPosts] event to the [PostsBloc]
  /// to fetch posts data with the `refresh` flag set to true.
  /// It also calls [scrollFunction] to set up a listener on the scroll controller for infinite scrolling.
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(
          const GetPosts(refresh: true),
        );
    scrollFunction();
  }

  /// Sets up a listener on the scroll controller for infinite scrolling.
  ///
  /// This method adds a listener to the [scrollController] to detect when the user has scrolled to the
  /// bottom of the list. When the user reaches the end of the list and the bloc state is not currently
  /// loading and has not reached the maximum number of posts, it dispatches a [GetPosts] event to the
  /// [PostsBloc] to fetch the next page of posts.
  scrollFunction() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !context.read<PostsBloc>().state.isLoading && !context.read<PostsBloc>().state.hasReachedMax) {
        context.read<PostsBloc>().add(const GetPosts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paggination with BLOC"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: BlocConsumer<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state.error.isNotEmpty == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final loading = state.isLoading;
            final itemsData = state.postsData;
            if (loading && itemsData.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const SizedBox(height: 80),
                      );
                    },
                  ),
                ),
              );
            } else if (!loading && itemsData.isEmpty) {
              return const Center(
                child: Text('No Items Found!'),
              );
            } else if (itemsData.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        context.read<PostsBloc>().add(const GetPosts(
                              refresh: true,
                            ));
                        return Future<void>.value();
                      },
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: itemsData.length + 1,
                          clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            if (index < itemsData.length) {
                              final data = itemsData[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Text(
                                        '${index + 1}',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      title: Text(
                                        data.title ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        data.body ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              if (loading) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            )),
                                        SizedBox(width: 5),
                                        Text("Loading..."),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox(height: 100);
                              }
                            }
                          }),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Something Went Wrong'),
            );
          },
        ),
      ),
    );
  }
}
