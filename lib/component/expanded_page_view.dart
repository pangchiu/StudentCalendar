import 'package:app/component/size_reporting_widget.dart';
import 'package:flutter/material.dart';

class ExpandedPageView extends StatefulWidget {
  const ExpandedPageView(
      {required this.itemBuilder,
      this.itemCount,
      this.pageController,
      this.onPageChanged});

  final Function(BuildContext, int) itemBuilder;
  final int? itemCount;
  final PageController? pageController;
  final void Function(int)? onPageChanged;

  @override
  ExpandedPageViewState createState() => ExpandedPageViewState();
}

class ExpandedPageViewState extends State<ExpandedPageView> {
  late List<double> heights;
  PageController? pageController;
  int _currentPage = 0;
  bool shouldDisposePageController = false;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.itemCount!, 0.0);
    pageController = widget.pageController ?? PageController();
    if (pageController!.initialPage != _currentPage) {
      // thêm điều kiện này để điều chỉnh trang khởi tạo
      // ví du:
      // muốn cài trang bắt đầu là 10 nhưng biến currentpage là 0
      // currentpage chỉ thay đổi khi trang có sự kiện vuốt, lúc khởi tạo chưa thay đổi (vuốt),
      //  khi buld item thì chiều cao page thay đổi theo chỉ số cài đặt lúc này là tại vị trí 10
      //  hoạt ảnh lại lấy chiều cao từ currentPage nên nó sẽ ko hiển thị lịch
      _currentPage = pageController!.initialPage;
    }
    pageController!.addListener(updatePage);
    shouldDisposePageController = widget.pageController == null;
  }

  @override
  void dispose() {
    pageController!.removeListener(updatePage);
    if (shouldDisposePageController) {
      pageController!.dispose();
    }

    super.dispose();
  }

  void updatePage() {
    final _newPage = pageController!.page!.ceil();
    if (_currentPage != _newPage) {
      setState(() {
        _currentPage = _newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: heights[_currentPage], child: buildPageView());
  }

  Widget buildPageView() {
    return PageView.builder(
      onPageChanged: widget.onPageChanged,
      controller: pageController,
      itemCount: widget.itemCount,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder(context, index);
    return OverflowBox(
        minHeight: 0,
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: SizeReportingWidget(
          onSizeChange: (size) => setState(() => heights[index] = size.height),
          child: item,
        ));
  }
}
