// import 'package:finalprojectbarber/widgets/barber_tile.dart';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import '../data_manager/data_manager.dart';
// import '../model/barber_model.dart';


// class SearchingScreen extends StatelessWidget {
//   const SearchingScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildListDelegate(
//         [
//           Consumer<DataManagerProvider>(
//             builder: (context, data, child){
//               if(data.searchList.isNotEmpty){
//                 return Column(
//                     children: data.getSearchList.map((x) {
//                    return barberTile(x as BarberModel, context);
//                     }).toList());
//               }
//               else{
//                 return const Align(
//                     alignment: Alignment.topCenter,
//                     child: Text('Result Not Found'));
//               }

//             },
//           ),
//         ]
//       )
//     );
//   }
// }
