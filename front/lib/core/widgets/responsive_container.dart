import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../theme/app_theme.dart';

/// Container responsive que se adapta al tamaño de pantalla
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = padding?.horizontal ?? Responsive.getHorizontalPadding(context);
    final verticalPadding = padding?.vertical ?? AppTheme.spacingLG;
    final contentMaxWidth = maxWidth ?? Responsive.getMaxContentWidth(context);

    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Wrapper para contenido centrado en web, full width en mobile
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final contentMaxWidth = maxWidth ?? Responsive.getMaxContentWidth(context);
    
    if (Responsive.isMobile(context)) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
    }

    return Center(
      child: Container(
        padding: padding,
        constraints: BoxConstraints(
          maxWidth: contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Grid responsivo que ajusta columnas automáticamente
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final int? crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing,
    this.crossAxisCount,
    this.childAspectRatio = 1.5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = crossAxisCount ?? Responsive.getGridColumns(context);
    final gridSpacing = spacing ?? Responsive.getGridSpacing(context);

    return Padding(
      padding: padding ?? EdgeInsets.all(gridSpacing),
      child: Wrap(
        spacing: gridSpacing,
        runSpacing: gridSpacing,
        children: children.map((child) {
          if (columns == 1) {
            return SizedBox(
              width: double.infinity,
              child: child,
            );
          }
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 
                   (gridSpacing * (columns + 1)) - 
                   (Responsive.shouldShowSidebar(context) ? Responsive.getSidebarWidth(context) : 0)) / 
                   columns,
            child: child,
          );
        }).toList(),
      ),
    );
  }
}

/// Layout responsive con sidebar para desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool showSidebar;

  const ResponsiveLayout({
    super.key,
    required this.sidebar,
    required this.body,
    this.bottomNavigationBar,
    this.appBar,
    this.showSidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowSidebar = showSidebar && Responsive.shouldShowSidebar(context);

    if (!shouldShowSidebar) {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: Responsive.getSidebarWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                right: BorderSide(
                  color: AppTheme.gray200,
                  width: 1,
                ),
              ),
            ),
            child: sidebar,
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                if (appBar != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.gray200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: appBar,
                  ),
                Expanded(child: body),
                if (bottomNavigationBar != null) bottomNavigationBar!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Scaffold responsivo con soporte para drawer en mobile y sidebar en desktop
class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.shouldShowSidebar(context);

    if (isDesktop && drawer != null) {
      return Row(
        children: [
          // Sidebar permanente en desktop
          Container(
            width: Responsive.getSidebarWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                right: BorderSide(
                  color: AppTheme.gray200,
                  width: 1,
                ),
              ),
            ),
            child: drawer,
          ),
          // Contenido principal
          Expanded(
            child: Scaffold(
              appBar: appBar,
              body: body,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// GridView responsivo
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.getGridColumns(context);
    final spacing = Responsive.getGridSpacing(context);

    return GridView.builder(
      padding: padding ?? EdgeInsets.all(spacing),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: Responsive.getCardAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
