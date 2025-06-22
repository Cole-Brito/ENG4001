// lib/match_info_popup.dart
//       if (selectedPlayers.isNotEmpty) {  
//         game.waitingGroups.add(selectedPlayers);
//         game.queue.removeWhere(  
//           (u) => selectedPlayers.contains(u),
//         );   
//       }
//       } else {   
//         // If waiting room is full, form match immediately
//         final match = Match( 
//           players: [currentUser, ...selectedPlayers],
//           startTime: DateTime.now(), 
//         );
//         game.activeMatches[game.courts] = match;
//       }
//     }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/game.dart';
// import '../models/user.dart';
// import '../providers/game_provider.dart';
// import '../widgets/player_list.dart';
// import '../widgets/match_info.dart';

// class MatchInfoPopup extends StatelessWidget {
//   final Game game;
//   final User currentUser;

//   const MatchInfoPopup({
//     super.key,
//     required this.game,
//     required this.currentUser,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Match Information'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             MatchInfo(game: game, currentUser: currentUser),
//             SizedBox(height: 16),
//             PlayerList(
//               players: game.queue.where((u) => u.username != currentUser.username).toList(),
//               onPlayerSelected: (selectedPlayers) {
//                 Provider.of<GameProvider>(context, listen: false)
//                     .formMatchGroup(game, selectedPlayers);
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
// }
