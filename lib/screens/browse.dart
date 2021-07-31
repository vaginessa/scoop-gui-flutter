import 'package:fluent_ui/fluent_ui.dart';
import 'package:scoop_gui/widgets/toggle_button_bar.dart';

class BrowsePage extends StatefulWidget {
  BrowsePage({Key? key}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text("Browse apps"),
        commandBar: Button(child: Text("Refresh"), onPressed: () => {}),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ToggleButtonBar(
              selected: index,
              onChanged: (i) => setState(() => index = i),
              items: [
                CustomToggleButton(child: Text('All')),
                CustomToggleButton(child: Text('bucket-1')),
                CustomToggleButton(child: Text('bucket-2')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
