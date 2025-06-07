import 'package:flutter/material.dart';
import '../../resources/colors_r.dart';
import '../../resources/fonts_r.dart';
import '../../resources/shadows_r.dart';
import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';

class PickingWidget<T> extends StatefulWidget {
  const PickingWidget({
    super.key,
    required this.onChanged,
    required this.selected,
    required this.option1,
    required this.option2,
    required this.optionName,
  });

  final T selected;
  final T option1, option2;
  final void Function(T value) onChanged;
  final String Function(T value) optionName;

  @override
  State<PickingWidget<T>> createState() => _PickingWidgetState<T>();
}

class _PickingWidgetState<T> extends State<PickingWidget<T>> {
  T? selected;
  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
          width: SpacingResources.mainHalfWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsResources.onPrimary,
            border: Border.all(
              color: selected == widget.option1 ? ColorsResources.primary : ColorsResources.onPrimary,
              width: 2,
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onChanged(widget.option1);
                setState(() {
                  selected = widget.option1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            widget.optionName(widget.option1),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: FontsResources.styleMedium(
                              color: ColorsResources.blackText2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: SpacingResources.sidePadding,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
          width: SpacingResources.mainHalfWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsResources.onPrimary,
            border: Border.all(
              color: selected == widget.option2 ? ColorsResources.primary : ColorsResources.onPrimary,
              width: 2,
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onChanged(widget.option2);
                setState(() {
                  selected = widget.option2;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            widget.optionName(widget.option2),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: FontsResources.styleMedium(
                              color: ColorsResources.blackText2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
