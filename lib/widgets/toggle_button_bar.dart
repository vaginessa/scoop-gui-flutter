import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

class ToggleButtonBar extends StatelessWidget {
  final int selected;
  final List<CustomToggleButton> items;
  final void Function(int index) onChanged;

  const ToggleButtonBar(
      {Key? key,
      required this.selected,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    this.items.asMap().forEach((key, value) {
      children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ToggleButton(
          child: value.child,
          checked: selected == key,
          onChanged: (value) => {if (value) this.onChanged(key)},
        ),
      ));
    });

    var buttonStyle = ButtonStyle(
      shape: ButtonState.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
      border: ButtonState.all(
        BorderSide(
          width: 1,
          color: FluentTheme.of(context).inactiveBackgroundColor,
        ),
      ),
      padding: ButtonState.all(
        const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
      ),
    );

    return ToggleButtonTheme(
      data: ToggleButtonThemeData(
        uncheckedButtonStyle: buttonStyle,
        checkedButtonStyle: buttonStyle.merge(ButtonStyle(
            textStyle: ButtonState.all(
              TextStyle(color: FluentTheme.of(context).accentColor),
            ),
            border: ButtonState.all(
              BorderSide(
                color: FluentTheme.of(context).accentColor,
              ),
            ))),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}

class CustomToggleButton {
  final Widget child;

  const CustomToggleButton({Key? key, required this.child});
}
