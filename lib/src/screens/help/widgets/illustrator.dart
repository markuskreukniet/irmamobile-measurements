import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';
import 'package:irmamobile/src/theme/theme.dart';

class Illustrator extends StatefulWidget {
  final List<Widget> imageSet;
  final List<String> textSet;
  final double height;
  final double width;

  const Illustrator({@required this.imageSet, @required this.textSet, @required this.height, @required this.width});

  @override
  _IllustratorState createState() => _IllustratorState();
}

class _IllustratorState extends State<Illustrator> with SingleTickerProviderStateMixin {
  final _animationDuration = 250;

  double height;
  int currentPage = 0;

  final _controller = PageController();

  // getChangedPageAndMoveBar and dotsIndicator from
  // https://medium.com/aubergine-solutions/create-an-onboarding-page-indicator-in-3-minutes-in-flutter-a2bd97ceeaff
  void getChangedPageAndMoveBar(int page) {
    setState(() {
      currentPage = page % widget.imageSet.length;
    });
  }

  Widget navBar() {
    return Container(
      height: widget.height,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          if (currentPage > 0)
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(IrmaIcons.chevronLeft,
                    semanticLabel: FlutterI18n.translate(context, "disclosure.previous"),
                    color: IrmaTheme.of(context).interactionInformation),
                iconSize: 20.0,
                onPressed: () {
                  currentPage--;
                  if (_controller.hasClients) {
                    _controller.animateToPage(
                      currentPage,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          if (currentPage < widget.imageSet.length - 1)
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(IrmaIcons.chevronRight,
                    semanticLabel: FlutterI18n.translate(context, "disclosure.next"),
                    color: IrmaTheme.of(context).interactionInformation),
                iconSize: 20.0,
                onPressed: () {
                  currentPage++;
                  if (_controller.hasClients) {
                    _controller.animateToPage(
                      currentPage,
                      duration: Duration(milliseconds: _animationDuration),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget dotsIndicator({bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _animationDuration ~/ 2),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 11,
      width: 11,
      decoration: BoxDecoration(
          color: isActive ? IrmaTheme.of(context).primaryBlue : IrmaTheme.of(context).grayscale80,
          borderRadius: const BorderRadius.all(Radius.circular(11))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: widget.height,
                width: widget.width,
                child: PageView.builder(
                  itemCount: widget.imageSet.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (int page) {
                    getChangedPageAndMoveBar(page);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return widget.imageSet[index % widget.imageSet.length];
                  },
                ),
              ),
            ),
            if (widget.imageSet.length > 1) navBar(),
          ],
        ),
        SizedBox(
          height: IrmaTheme.of(context).defaultSpacing,
        ),
        Container(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            vsync: this,
            child: Container(
              width: widget.width,
              child: Text(
                widget.textSet[currentPage],
                key: ValueKey<int>(currentPage),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          height: IrmaTheme.of(context).defaultSpacing,
        ),
        Row(
          children: <Widget>[
            const Spacer(),
            for (int i = 0; i < widget.imageSet.length; i++)
              if (i == currentPage) ...[dotsIndicator(isActive: true)] else dotsIndicator(isActive: false),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: IrmaTheme.of(context).defaultSpacing,
        ),
      ],
    );
  }
}
