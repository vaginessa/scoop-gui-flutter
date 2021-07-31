import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as FlutterAcrylic;
import 'package:provider/provider.dart';
import 'package:scoop_gui/theme.dart';
import 'package:system_theme/system_theme.dart';

const String appTitle = 'Scoop';

late bool darkMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The platforms the plugin support (01/04/2021 - DD/MM/YYYY):
  //   - Windows
  //   - Web
  //   - Android
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows)
    await FlutterAcrylic.Acrylic.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {'/': (_) => MyHomePage()},
          theme: ThemeData(
            accentColor: appTheme.color,
            brightness: appTheme.mode == ThemeMode.system
                ? darkMode
                    ? Brightness.dark
                    : Brightness.light
                : appTheme.mode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      appBar: NavigationAppBar(
        // height: !kIsWeb ? appWindow.titleBarHeight : 31.0,
        title: () {
          if (kIsWeb) return Text(appTitle);
          return MoveWindow(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(appTitle),
            ),
          );
        }(),
        leading: Container(),
        actions: kIsWeb
            ? null
            : MoveWindow(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Spacer(), WindowButtons()],
                ),
              ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        displayMode: appTheme.displayMode,
        indicatorBuilder: ({
          required BuildContext context,
          int? index,
          required List<Offset> Function() offsets,
          required List<Size> Function() sizes,
          required Axis axis,
          required Widget child,
        }) {
          if (index == null) return child;
          assert(debugCheckHasFluentTheme(context));
          final theme = NavigationPaneTheme.of(context);
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return EndNavigationIndicator(
                index: index,
                offsets: offsets,
                sizes: sizes,
                child: child,
                color: theme.highlightColor,
                curve: theme.animationCurve ?? Curves.linear,
                axis: axis,
              );
            case NavigationIndicators.sticky:
              return NavigationPane.defaultNavigationIndicator(
                index: index,
                context: context,
                offsets: offsets,
                sizes: sizes,
                axis: axis,
                child: child,
              );
            default:
              return NavigationIndicator(
                index: index,
                offsets: offsets,
                sizes: sizes,
                child: child,
                color: theme.highlightColor,
                curve: theme.animationCurve ?? Curves.linear,
                axis: axis,
              );
          }
        },
        items: [
          // It doesn't look good when resizing from compact to open
          // PaneItemHeader(header: Text('User Interaction')),
          PaneItem(
            icon: Icon(FluentIcons.all_apps),
            title: Text('Browse apps'),
          ),
          PaneItem(icon: Icon(FluentIcons.library), title: Text('Library')),
          PaneItemSeparator(),
          PaneItem(icon: Icon(FluentIcons.repo), title: Text('Buckets')),
        ],
        autoSuggestBox: AutoSuggestBox<String>(
          controller: TextEditingController(),
          items: ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
        ),
        autoSuggestBoxReplacement: Icon(FluentIcons.search),
        footerItems: [
          PaneItemSeparator(),
          PaneItem(icon: Icon(FluentIcons.settings), title: Text('Settings')),
        ],
      ),
      content: NavigationBody(index: index, children: [
        ScaffoldPage(
          header: PageHeader(
            title: Text("Browse apps"),
            commandBar: Button(child: Text("Refresh"), onPressed: () => {}),
          ),
        ),
        ScaffoldPage(
          header: PageHeader(
            title: Text("Library"),
            commandBar: Button(child: Text("Refresh"), onPressed: () => {}),
          ),
        ),
        ScaffoldPage(
          header: PageHeader(
            title: Text("Buckets"),
            commandBar: Button(child: Text("Refresh"), onPressed: () => {}),
          ),
        ),
        ScaffoldPage(
          header: PageHeader(title: Text("Settings")),
        ),
      ]),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));
    final ThemeData theme = FluentTheme.of(context);
    final buttonColors = WindowButtonColors(
      iconNormal: theme.inactiveColor,
      iconMouseDown: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
      mouseOver: ButtonThemeData.buttonColor(
          theme.brightness, {ButtonStates.hovering}),
      mouseDown: ButtonThemeData.buttonColor(
          theme.brightness, {ButtonStates.pressing}),
    );
    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red.dark,
      iconNormal: theme.inactiveColor,
      iconMouseOver: Colors.red.basedOnLuminance(),
      iconMouseDown: Colors.red.dark.basedOnLuminance(),
    );
    return Row(children: [
      Tooltip(
        message: FluentLocalizations.of(context).minimizeWindowTooltip,
        child: MinimizeWindowButton(colors: buttonColors),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).restoreWindowTooltip,
        child: WindowButton(
          colors: buttonColors,
          iconBuilder: (context) {
            if (appWindow.isMaximized)
              return RestoreIcon(color: context.iconColor);
            return MaximizeIcon(color: context.iconColor);
          },
          onPressed: appWindow.maximizeOrRestore,
        ),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).closeWindowTooltip,
        child: CloseWindowButton(colors: closeButtonColors),
      ),
    ]);
  }
}
