import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

/// The picker opened by the buttons of the playground.
enum _PickerKind {
  date('Date'),
  dateTime('Date & time'),
  actions('Actions'),
  time('Time');

  const _PickerKind(this.label);

  final String label;
}

/// The screen the playground is displayed on.
enum _Screen {
  device('Device'),
  smallPhone('320×568'),
  low('Low');

  const _Screen(this.label);

  final String label;
}

/// What the picker is displayed next to.
enum _AnchorMode {
  buttons('9 buttons'),
  fullArea('Full area'),
  none('No anchor');

  const _AnchorMode(this.label);

  final String label;
}

const double _anchorMargin = 16.0;
const Size _smallPhoneSize = Size(320.0, 568.0);
const EdgeInsets _smallPhonePadding = EdgeInsets.only(top: 20.0);
const double _lowScreenHeight = 360.0;
const EdgeInsets _lowScreenPadding = EdgeInsets.only(bottom: 21.0);

const List<Alignment> _positions = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

/// A screen for checking by eye where the pickers open.
///
/// Every button opens its picker, which has to stay within the safe area
/// (highlighted in grey on the simulated screens) and the spacing, open on
/// the side of its button with more space without covering it, and only
/// cover it when it is centered on a screen too low for it.
class LayoutPlaygroundPage extends StatefulWidget {
  const LayoutPlaygroundPage({super.key});

  @override
  State<LayoutPlaygroundPage> createState() => _LayoutPlaygroundPageState();
}

class _LayoutPlaygroundPageState extends State<LayoutPlaygroundPage> {
  _PickerKind _kind = _PickerKind.date;
  _Screen _screen = _Screen.device;
  _AnchorMode _anchorMode = _AnchorMode.buttons;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Layout playground'),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SegmentedRow<_PickerKind>(
              values: _PickerKind.values,
              groupValue: _kind,
              label: (_PickerKind kind) => kind.label,
              onChanged: (_PickerKind kind) => setState(() => _kind = kind),
            ),
            _SegmentedRow<_Screen>(
              values: _Screen.values,
              groupValue: _screen,
              label: (_Screen screen) => screen.label,
              onChanged: (_Screen screen) => setState(() => _screen = screen),
            ),
            _SegmentedRow<_AnchorMode>(
              values: _AnchorMode.values,
              groupValue: _anchorMode,
              label: (_AnchorMode mode) => mode.label,
              onChanged: (_AnchorMode mode) {
                setState(() => _anchorMode = mode);
              },
            ),
            Expanded(child: _buildStage()),
          ],
        ),
      ),
    );
  }

  Widget _buildStage() {
    return switch (_screen) {
      _Screen.device => _Playground(
        kind: _kind,
        anchorMode: _anchorMode,
        useRootNavigator: true,
      ),
      _Screen.smallPhone => _SimulatedScreen(
        size: _smallPhoneSize,
        padding: _smallPhonePadding,
        settings: (_kind, _anchorMode),
      ),
      _Screen.low => _SimulatedScreen(
        size: const Size(double.infinity, _lowScreenHeight),
        padding: _lowScreenPadding,
        settings: (_kind, _anchorMode),
      ),
    };
  }
}

class _SegmentedRow<T extends Object> extends StatelessWidget {
  const _SegmentedRow({
    required this.values,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  final List<T> values;
  final T groupValue;
  final String Function(T value) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<T>(
          groupValue: groupValue,
          onValueChanged: (T? value) {
            if (value != null) onChanged(value);
          },
          children: {for (final T value in values) value: Text(label(value))},
        ),
      ),
    );
  }
}

/// Displays the playground on a screen of [size] with the unsafe [padding],
/// limited to the available space.
///
/// The pickers open in the screen's own navigator, so they are laid out
/// within it as on a real device of that size.
class _SimulatedScreen extends StatelessWidget {
  const _SimulatedScreen({
    required this.size,
    required this.padding,
    required this.settings,
  });

  final Size size;
  final EdgeInsets padding;
  final (_PickerKind, _AnchorMode) settings;

  @override
  Widget build(BuildContext context) {
    final (_PickerKind kind, _AnchorMode anchorMode) = settings;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size screenSize = constraints.constrain(size);
        final MediaQueryData mediaQuery = MediaQuery.of(context);

        return Center(
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.separator),
            ),
            child: ClipRect(
              child: MediaQuery(
                data: mediaQuery.copyWith(
                  size: screenSize,
                  padding: padding,
                  viewPadding: padding,
                  viewInsets: EdgeInsets.zero,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: _UnsafeAreas(padding: padding)),
                    Navigator(
                      // A fresh page for every change of the settings.
                      key: ValueKey<(_PickerKind, _AnchorMode)>(settings),
                      onGenerateRoute: (_) => PageRouteBuilder<void>(
                        pageBuilder: (_, _, _) => _Playground(
                          kind: kind,
                          anchorMode: anchorMode,
                          useRootNavigator: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UnsafeAreas extends StatelessWidget {
  const _UnsafeAreas({required this.padding});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Color color = CupertinoColors.systemGrey4.resolveFrom(context);
    BorderSide side(double width) {
      return width == 0.0
          ? BorderSide.none
          : BorderSide(color: color, width: width);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: side(padding.left),
          top: side(padding.top),
          right: side(padding.right),
          bottom: side(padding.bottom),
        ),
      ),
    );
  }
}

class _Playground extends StatelessWidget {
  const _Playground({
    required this.kind,
    required this.anchorMode,
    required this.useRootNavigator,
  });

  final _PickerKind kind;
  final _AnchorMode anchorMode;
  final bool useRootNavigator;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(_anchorMargin),
        child: switch (anchorMode) {
          _AnchorMode.buttons => Stack(
            children: [
              for (final Alignment position in _positions)
                Align(alignment: position, child: _buildButton()),
            ],
          ),
          _AnchorMode.fullArea => Builder(
            builder: (BuildContext context) => _TapArea(
              onTap: () => _showPicker(
                context,
                context.findRenderObject() as RenderBox?,
              ),
            ),
          ),
          _AnchorMode.none => Center(
            child: Builder(
              builder: (BuildContext context) => CupertinoButton.filled(
                onPressed: () => _showPicker(context, null),
                child: const Text('Open without anchor'),
              ),
            ),
          ),
        },
      ),
    );
  }

  DateTime get _minimumDateTime => DateTime(DateTime.now().year - 1);

  DateTime get _maximumDateTime => DateTime(DateTime.now().year + 1, 12, 31);

  CupertinoCalendarMode get _mode => kind == _PickerKind.date
      ? CupertinoCalendarMode.date
      : CupertinoCalendarMode.dateTime;

  List<CupertinoCalendarAction>? get _actions => kind == _PickerKind.actions
      ? const [
          CancelCupertinoCalendarAction(),
          ConfirmCupertinoCalendarAction(),
        ]
      : null;

  Widget _buildButton() {
    if (kind == _PickerKind.time) {
      return CupertinoTimePickerButton(useRootNavigator: useRootNavigator);
    }
    return CupertinoCalendarPickerButton(
      minimumDateTime: _minimumDateTime,
      maximumDateTime: _maximumDateTime,
      mode: _mode,
      timeLabel: 'Ends',
      actions: _actions,
      useRootNavigator: useRootNavigator,
    );
  }

  Future<void> _showPicker(BuildContext context, RenderBox? renderBox) async {
    if (kind == _PickerKind.time) {
      await showCupertinoTimePicker(
        context,
        widgetRenderBox: renderBox,
        useRootNavigator: useRootNavigator,
      );
      return;
    }
    await showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: _minimumDateTime,
      maximumDateTime: _maximumDateTime,
      mode: _mode,
      timeLabel: 'Ends',
      actions: _actions,
      useRootNavigator: useRootNavigator,
    );
  }
}

/// An anchor covering the whole area.
class _TapArea extends StatelessWidget {
  const _TapArea({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Tap anywhere.\nThe whole area is the anchor.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
