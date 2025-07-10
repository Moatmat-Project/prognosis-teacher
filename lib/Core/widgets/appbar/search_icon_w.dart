import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Presentation/students/views/my_students_v.dart';

class SearchIconWidget extends StatelessWidget {
  const SearchIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyStudentsView(),
        ));
      },
      icon: Icon(
        Icons.group,
      ),
      // const Stack(
      //   children: [
      //     Icon(
      //       Icons.group,
      //     ),
      //     Align(
      //       alignment: Alignment.topRight,
      //       child: CircleAvatar(
      //         radius: 3,
      //         backgroundColor: Colors.transparent,
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
