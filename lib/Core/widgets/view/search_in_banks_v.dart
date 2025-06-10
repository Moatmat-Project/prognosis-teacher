import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import '../toucheable_tile_widget.dart';

class SearchInBanksView extends StatefulWidget {
  const SearchInBanksView({
    super.key,
    required this.banks,
    required this.onPick,
  });
  final List<Bank> banks;
  final void Function(Bank bank) onPick;
  @override
  State<SearchInBanksView> createState() => _SearchInBanksViewState();
}

class _SearchInBanksViewState extends State<SearchInBanksView> {
  late TextEditingController _controller;
  List<Bank> banks = [];
  List<Bank> search = [];
  @override
  void initState() {
    banks = widget.banks;
    //
    search = widget.banks;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = banks;
      } else {
        search = banks.where((e) {
          return e.information.title.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    //
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            controller: _controller,
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                return TouchableTileWidget(
                  title: search[index].information.title,
                  onTap: () {
                    widget.onPick(search[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
