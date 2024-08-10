// // ignore_for_file: library_private_types_in_public_api

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:finalprojectbarber/php_data/php_data.dart';
// import 'package:finalprojectbarber/theme/extention.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../data_manager/data_manager.dart';
// import '../model/barber_model.dart';
// import '../theme/text_styles.dart';
// import 'photo_view_page.dart';

// class ShowWorkingsPage extends StatefulWidget {
//   final String id;
//   const ShowWorkingsPage({
//     super.key,
//     required this.id,
//   });

//   @override
//   _ShowWorkingsPageState createState() => _ShowWorkingsPageState();
// }

// class _ShowWorkingsPageState extends State<ShowWorkingsPage> {
//   late String id = "";
//   @override
//   void initState() {
//     super.initState();
//     id = widget.id;
//   }

//   @override
//   Widget build(BuildContext context) {
//     getCertificates(id, context);
//     return Scaffold(
//       body: Consumer<DataManagerProvider>(
//         builder: (context, providerData, child) {
//           return CustomScrollView(
//             slivers: <Widget>[
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         const SizedBox(
//                           height: 40.0,
//                         ),
//                         const BackButton(
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "รูปภาพผลงาน",
//                           style: TextStyles.titleM,
//                         ),
//                       ],
//                     ).p16,
//                   ],
//                 ),
//               ),
//               SliverGrid(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 5,
//                   mainAxisSpacing: 5,
//                 ),
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     return getShowWorkingsWidgetList(
//                         providerData.getAllWorkings, index, context);
//                   },
//                   childCount: providerData.getAllWorkings.length,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// Widget getShowWorkingsWidgetList(
//     List<WorkingsModel> workingsDataList, int index, BuildContext context) {
//   return Container(
//     child: ShowWorkingsTile(workingsDataList[index], index, context),
//   );
// }

// Widget ShowWorkingsTile(WorkingsModel model, int index, BuildContext context) {
//   return Stack(
//     children: [
//       InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PhotoViewPage(
//               index: index,
//               photos: [model.workingsPhoto],
//             ),
//           ),
//         ),
//         child: Hero(
//           tag: model.workingsPhoto,
//           child: CachedNetworkImage(
//             imageUrl: "$server/uploads/${model.workingsPhoto}",
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//             placeholder: (context, url) => Container(
//               color: Colors.grey,
//             ),
//             errorWidget: (context, url, error) => Container(
//               color: Colors.red.shade400,
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
