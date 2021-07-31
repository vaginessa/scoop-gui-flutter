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
    //TODO: Remove sample:
    const apps = {
      "7-zip": {"version": "19.00", "bucket": "main"},
      "python": {"version": "3.6.9", "bucket": "main"},
    };

    final _controller = ScrollController();

    return ScaffoldPage(
      header: PageHeader(
        title: Text("Browse apps"),
        commandBar: Button(child: Text("Refresh"), onPressed: () => {}),
      ),
      padding: EdgeInsets.only(top: 24),
      content: Container(
        decoration: BoxDecoration(
          color: FluentTheme.of(context).activeColor,
          border: Border.all(
            color: FluentTheme.of(context).inactiveBackgroundColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Scrollbar(
          controller: _controller,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ToggleButtonBar(
                  selected: index,
                  onChanged: (i) => setState(() => index = i),
                  items: [
                    CustomToggleButton(child: Text('All')),
                    CustomToggleButton(child: Text('bucket-1')),
                    CustomToggleButton(child: Text('bucket-2')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final title = apps.keys.toList()[index];
                      final app = apps[title];
                      return ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(title),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                app!["version"]!,
                                style: FluentTheme.of(context)
                                    .typography
                                    .caption
                                    ?.copyWith(
                                      color:
                                          FluentTheme.of(context).accentColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text((app["bucket"]!)),
                        trailing:
                            Button(child: Text("Install"), onPressed: () => {}),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
