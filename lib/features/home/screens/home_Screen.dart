import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/home/bloc/square_bloc.dart';
import 'package:flutter_application_2/features/home/respositories/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController;

  bool isLoading = false;
  SquareBloc squareBloc;
  HomeRepo homeRepo;
  var spinKit;

  @override
  void initState() {
    super.initState();

    homeRepo = HomeRepo();
    scrollController = ScrollController();
    spinKit = SpinKitWave(
      color: Colors.black,
      size: 30.0,
    );
    scrollController.addListener(_pagination);
    squareBloc = SquareBloc(homeRepo);
    squareBloc.add(FetchSquares(1));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Paginated View'),
      ),
      body: BlocConsumer<SquareBloc, SquareState>(
        bloc: squareBloc,
        listener: (context, state) {
          if (state.status != SquareStatus.initial) {
            isLoading = false;
          }
        },
        builder: (context, state) {
          if (state.status == SquareStatus.success) {
            return Stack(
              children: [
                Opacity(
                  opacity: isLoading ? 0.3 : 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state?.posts?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                          child: index >= state?.posts?.length ?? 0
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  width: screenWidth * .80,
                                  height: screenhight * .25,
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      border: Border.all(color: Colors.black)),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          leading: Image.network(state
                                              .posts[index].owner.avatarUrl),
                                          title: Text(
                                            state.posts[index]?.name ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.pinkAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            state.posts[index]?.description ??
                                                '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                    },
                  ),
                ),
                Visibility(
                    visible: isLoading,
                    child: Center(
                      child: spinKit,
                    ))
              ],
            );
          } else if (state.status == SquareStatus.initial) {
            return Center(child: spinKit);
          } else {
            return Container();
          }
          return spinKit;
        },
      ),
    );
  }

  void _pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading)) {
      isLoading = true;
      setState(() {});

      print('calling api -----');
      squareBloc.add(FetchSquares(squareBloc.state.posts.length ~/ 20 + 1));
    }
  }
}
