import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
class MatchupForm extends StatelessWidget {
  const MatchupForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _showNickDialog(context));
    return Column(
      children: [
        __AddPlayerButtonDebug(),
        Expanded(
          child: _PlayerListView(),
        ),
        _HostButtons(),
        const SizedBox(height: 16)
      ],
    );
  }
}

class __AddPlayerButtonDebug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return !kDebugMode
        ? ElevatedButton(
            onPressed: () => context.read<MatchupCubit>().add_Player_debug(),
            child: const Text('Add player'),
          )
        : ElevatedButton(
            onPressed: () => context.read<MatchupCubit>().add_AI_Player_debug(),
            child: const Text('Add AI player'),
          );
  }
}

class _PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: context.read<DataRepository>().streamPlayersList(),
      builder: (context, snapshot) {
        var players = snapshot.data;
        context.read<MatchupCubit>().playerCountChanged(players);
        return players == null
            ? const SizedBox.expand()
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ...players.map(
                    (player) => _PlayerCard(player: player),
                  ),
                ],
              );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    final hostUserId = context.read<DataRepository>().currentRoom.hostUserId;
    final userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return Card(
      child: ListTile(
        title: Text(player.nick),
        trailing: userId != hostUserId
            ? null
            : PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(AppLocalizations.of(context).remove),
                    onTap: () =>
                        context.read<MatchupCubit>().removePlayer(player),
                    // TODO !!! give the info about removal to the removed user's UI
                  ),
                ],
              ),
      ),
    );
  }
}

class _HostButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hostUserId = context.read<DataRepository>().currentRoom.hostUserId;
    final userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return userId != hostUserId
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RolesDefButton(),
              _StartGameButton(),
            ],
          );
  }
}

class _StartGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchupCubit, MatchupState>(
        buildWhen: (previous, current) =>
            previous.playersCount != current.playersCount,
        builder: (context, state) {
          return FilledButton(
            onPressed: !context.read<MatchupCubit>().isPlayerCountValid()
                ? null
                : () {
                    context.read<MatchupCubit>().initGame();
                  },
            child: Text(AppLocalizations.of(context).startGame,
                style: const TextStyle(fontSize: 20)),
          );
        });
  }
}

class _RolesDefButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => Navigator.push(context, CharactersPage.route()),
      child: Text(AppLocalizations.of(context).defineRoles),
    );
  }
}

Future<void> _showNickDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).enterYourNick),
          content: TextField(
            onChanged: (nick) => context.read<MatchupCubit>().nickChanged(nick),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).nick,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //simple validation TODO ! make validation more complex
                if (!context.read<MatchupCubit>().state.status.isValidated) {
                  return;
                }
                final user = context.read<AppBloc>().state.user;
                context.read<MatchupCubit>().writeinPlayerWithUserId(user.id);
                Navigator.of(dialogContext).pop();
                context.read<RoomCubit>().subscribeToGameStarted();
              },
              child: Text(AppLocalizations.of(context).confirm),
            )
          ],
        );
      });
}

// TODO !! add roles config popup