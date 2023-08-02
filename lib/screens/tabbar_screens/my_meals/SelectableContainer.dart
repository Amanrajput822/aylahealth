
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/styles/const.dart';

class SelectableContainer extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  SelectableContainer({
    required this.isSelected,
    required this.onTap,
  });

  @override
  _SelectableContainerState createState() => _SelectableContainerState();
}

class _SelectableContainerState extends State<SelectableContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SvgPicture.asset('assets/image/edit 1.svg',width: 18,height: 18,color: colorShadowBlue,),
    );
  }
}
