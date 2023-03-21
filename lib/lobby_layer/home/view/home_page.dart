import 'package:fluttartur/lobby_layer/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app_layer/app/app.dart';
import 'package:fluttartur/lobby_layer/home/home.dart';
import 'package:data_repository/data_repository.dart';

// TODO !!! app-wide bloc with info about being in a room
// TODO przycisk do wychodzenia z gry
// TODO rozdzielic datarepo na dwie klasy roomdatarepo i ingamedatarepo

// TODO internalizacja
// TODO anonimowe logowanie, nicki
// TODO animacje
// TODO dołączanie do lobby przez kod QR

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/startpagebg.jpg",
            alignment: AlignmentDirectional.center,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Home'),
            actions: <Widget>[_LogOutButton()],
          ),
          body: BlocProvider(
            create: (_) => HomeCubit(context.read<DataRepository>()),
            child: const HomeForm(),
          ),
        ),
      ],
    );
  }
}

class _LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AppBloc>().add(const AppLogoutRequested());
      },
      child: const Text("Log out"),
    );
  }
}