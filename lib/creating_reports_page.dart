import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finance/add_operation_page.dart';
import 'package:finance/date/finance_operation_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CreatingReportsPage extends StatefulWidget {
  const CreatingReportsPage({super.key});

  @override
  State<CreatingReportsPage> createState() => _CreatingReportsPageState();
}

class _CreatingReportsPageState extends State<CreatingReportsPage> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String previousText = "";
  bool openStatistics = false;
  MenuElem reportType = MenuElem(
      isOpen: false,
      selectedElem: "Select type",
      listElements: ["Income", "Expenses"]);
  List<FinanceOperationModel> allOperations = []; // Заполните это из Hive
  Map<String, dynamic>? statistics;

  void generateReport() {
    if (startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        reportType.selectedElem == "Select type") {
      return;
    }

    try {
      final startDate =
          DateFormat('dd.MM.yyyy').parse(startDateController.text);
      final endDate = DateFormat('dd.MM.yyyy').parse(endDateController.text);

      final filtered = getFilteredOperations(
        allOperations,
        startDate,
        endDate,
        reportType.selectedElem,
      );

      setState(() {
        statistics = calculateStatistics(filtered);
        openStatistics = true;
      });
    } catch (e) {
      // Обработка ошибок парсинга даты
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid date format')),
      );
    }
  }

  Map<String, dynamic> calculateStatistics(
      List<FinanceOperationModel> operations) {
    double total = operations.fold(0, (sum, operation) => sum + operation.sum);

    // Группировка по категориям
    Map<String, double> categories = {};
    for (var operation in operations) {
      categories[operation.operationCategory] =
          (categories[operation.operationCategory] ?? 0) + operation.sum;
    }

    return {
      'total': total,
      'categories': categories,
    };
  }

  List<FinanceOperationModel> getFilteredOperations(
    List<FinanceOperationModel> allOperations,
    DateTime startDate,
    DateTime endDate,
    String operationType,
  ) {
    return allOperations.where((operation) {
      final isTypeMatch = operation.operationType == operationType;
      final isDateInRange = (operation.date.isAfter(startDate) ||
              operation.date.isAtSameMomentAs(startDate)) &&
          (operation.date.isBefore(endDate) ||
              operation.date.isAtSameMomentAs(endDate));
      return isTypeMatch && isDateInRange;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadOperations();
  }

  Future<void> loadOperations() async {
    final box = await Hive.openBox<FinanceOperationModel>(
        HiveBoxes.financeOperationModel);
    setState(() {
      allOperations = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 340.w,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateTextField(
                          startDateController, 160.w, "Period", "Start date"),
                      _buildDateTextField(
                          endDateController, 160.w, "", "End date"),
                    ],
                  ),
                  _buildClientDropdown(),
                  SizedBox(
                    height: 43.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      generateReport();
                    },
                    child: Container(
                      width: 209.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          color: const Color(0xFFD7493C)),
                      child: Center(
                        child: Text(
                          "Create a report",
                          style: GoogleFonts.kronaOne(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 72.h,
                  ),
                  if (openStatistics && statistics != null)
                    Container(
                      width: 340.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4.h),
                            color: Colors.black.withValues(alpha: 0.25),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Statistics Report",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: SizedBox(
                              width: 296.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total ${reportType.selectedElem}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${statistics!['total'].toStringAsFixed(2)}\$",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "${reportType.selectedElem} Sources",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: SizedBox(
                              width: 303.w,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120.w,
                                    height: 120.h,
                                    child: CustomPaint(
                                      painter: PieChartPainter(
                                        values: (statistics!['categories']
                                                as Map<String, double>)
                                            .values
                                            .toList(),
                                        colors: List.generate(
                                          statistics!['categories'].length,
                                          (i) => getColor(i),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var entry
                                          in (statistics!['categories']
                                                  as Map<String, double>)
                                              .entries)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20.w,
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  color: getColor(
                                                      statistics!['categories']
                                                          .keys
                                                          .toList()
                                                          .indexOf(entry.key)),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "${entry.key}: ${entry.value.toStringAsFixed(2)}\$",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientDropdown() {
    return _buildDropdownSection(
      title: "Report type",
      menu: reportType,
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildDropdown(menu: menu, controller: controller),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Container(
      height: 46.h,
      width: 340.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          onChanged: (value) {
            setState(() {
              if (controller != null) {
                controller.text = value.toString();
              }
              menu.selectedElem = value.toString();
            });
          },
          onMenuStateChange: (isOpen) {
            setState(() {
              menu.isOpen = isOpen;
            });
          },
          customButton: Row(
            children: [
              Expanded(
                child: controller != null
                    ? TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontSize: 18.sp,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.sp,
                        ),
                      )
                    : Text(
                        menu.selectedElem,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
              Icon(
                menu.isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 30.h,
              ),
            ],
          ),
          items: menu.listElements.map((item) {
            return DropdownMenuItem(
              value: item,
              child: SizedBox(
                width: 355.w,
                height: 50.h,
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                ),
              ),
            );
          }).toList(),
          dropdownStyleData: DropdownStyleData(
            width: 361.w,
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            offset: Offset(-15.w, 0),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: List.filled(menu.listElements.length, 50.h),
            padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController dateController, double width,
      String title, String hint) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: MyTextField.textFieldIcon(title, width, dateController,
          SvgPicture.asset("assets/icons/calendar.svg"),
          keyboard: TextInputType.datetime,
          onChange: (text) => _validateDate(text, dateController),
          hint: hint),
    );
  }

  void _validateDate(String text, TextEditingController controller) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';

    for (int i = 0; i < sanitizedText.length && i < 8; i++) {
      formattedText += sanitizedText[i];
      if (i == 1 || i == 3) {
        formattedText += '.';
      }
    }

    List<String> parts = formattedText.split('.');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      int? month = int.tryParse(parts[1]);
      if (month != null && month > 12) {
        formattedText = formattedText.substring(0, 2);
      }
    }

    controller.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = controller.text;
  }
}

Widget _buildAppBar(BuildContext context) {
  return SizedBox(
    width: 340.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 32.w),
        Text(
          "Creating reports",
          style: GoogleFonts.kronaOne(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            color: const Color(0xFF4B1535),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            "assets/icons/menu.svg",
            width: 32.w,
          ),
        )
      ],
    ),
  );
}

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final total = values.reduce((a, b) => a + b);

    double startAngle = -pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = 2 * pi * (values[i] / total);
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 20
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Color getColor(int index) {
  switch (index % 90) {
    case 0:
      return const Color(0xFF514EAA); // Синий
    case 1:
      return const Color(0xFFF44336); // Красный
    case 2:
      return const Color(0xFFFD5B71); // Розовый
    case 3:
      return const Color(0xFF9B51E0); // Фиолетовый

    case 4:
      return const Color(0xFFFFA656); // Оранжевый
    case 5:
      return const Color(0xFF07E092); // Зеленый

    case 6:
      return const Color(0xFFFFD700); // Яркий желтый
    case 7:
      return const Color(0xFF4CAF50); // Зеленый (другой оттенок)
    case 8:
      return const Color(0xFF00BCD4); // Голубой
    case 9:
      return const Color(0xFFE91E63); // Розовый (другой оттенок)

    // Вариации базовых цветов (10-29)
    case 10:
      return const Color(0xFFFFF176); // Светло-желтый
    case 11:
      return const Color(0xFFFF8A80); // Светло-розовый
    case 12:
      return const Color(0xFFB39DDB); // Светло-фиолетовый
    case 13:
      return const Color(0xFF64B5F6); // Светло-синий
    case 14:
      return const Color(0xFFFFCC80); // Светло-оранжевый
    case 15:
      return const Color(0xFF80E27E); // Светло-зеленый
    case 16:
      return const Color(0xFFEF9A9A); // Светло-красный
    case 17:
      return const Color(0xFFA5D6A7); // Светло-зеленый (другой оттенок)
    case 18:
      return const Color(0xFF80DEEA); // Светло-голубой
    case 19:
      return const Color(0xFFF48FB1); // Светло-розовый (другой оттенок)
    case 20:
      return const Color(0xFFFFEB3B); // Желтый (яркий)
    case 21:
      return const Color(0xFFF06292); // Розовый (яркий)
    case 22:
      return const Color(0xFF7E57C2); // Фиолетовый (яркий)
    case 23:
      return const Color(0xFF42A5F5); // Синий (яркий)
    case 24:
      return const Color(0xFFFFB74D); // Оранжевый (яркий)
    case 25:
      return const Color(0xFF66BB6A); // Зеленый (яркий)
    case 26:
      return const Color(0xFFEF5350); // Красный (яркий)
    case 27:
      return const Color(0xFF81C784); // Зеленый (яркий, другой оттенок)
    case 28:
      return const Color(0xFF26C6DA); // Голубой (яркий)
    case 29:
      return const Color(0xFFEC407A); // Розовый (яркий, другой оттенок)

    // Дополнительные цвета (30-49)
    case 30:
      return const Color(0xFFFFF59D); // Пастельно-желтый
    case 31:
      return const Color(0xFFFF80AB); // Пастельно-розовый
    case 32:
      return const Color(0xFF9575CD); // Пастельно-фиолетовый
    case 33:
      return const Color(0xFF90CAF9); // Пастельно-синий
    case 34:
      return const Color(0xFFFFCCBC); // Пастельно-оранжевый
    case 35:
      return const Color(0xFFA5D6A7); // Пастельно-зеленый
    case 36:
      return const Color(0xFFEF9A9A); // Пастельно-красный
    case 37:
      return const Color(0xFFC8E6C9); // Пастельно-зеленый (другой оттенок)
    case 38:
      return const Color(0xFFB2EBF2); // Пастельно-голубой
    case 39:
      return const Color(0xFFF8BBD0); // Пастельно-розовый (другой оттенок)
    case 40:
      return const Color(0xFFFFEE58); // Яркий желтый (средний)
    case 41:
      return const Color(0xFFF48FB1); // Яркий розовый (средний)
    case 42:
      return const Color(0xFF673AB7); // Темно-фиолетовый
    case 43:
      return const Color(0xFF1E88E5); // Темно-синий
    case 44:
      return const Color(0xFFFF9800); // Темно-оранжевый
    case 45:
      return const Color(0xFF43A047); // Темно-зеленый
    case 46:
      return const Color(0xFFE53935); // Темно-красный
    case 47:
      return const Color(0xFF66BB6A); // Темно-зеленый (другой оттенок)
    case 48:
      return const Color(0xFF00ACC1); // Темно-голубой
    case 49:
      return const Color(0xFFD81B60); // Темно-розовый

    // Еще больше цветов (50-69)
    case 50:
      return const Color(0xFFFFFDE7); // Очень светлый желтый
    case 51:
      return const Color(0xFFFFF0F5); // Очень светлый розовый
    case 52:
      return const Color(0xFFEDE7F6); // Очень светлый фиолетовый
    case 53:
      return const Color(0xFFE3F2FD); // Очень светлый синий
    case 54:
      return const Color(0xFFFFF3E0); // Очень светлый оранжевый
    case 55:
      return const Color(0xFFE8F5E9); // Очень светлый зеленый
    case 56:
      return const Color(0xFFFFEBEE); // Очень светлый красный
    case 57:
      return const Color(0xFFF1F8E9); // Очень светлый зеленый (другой оттенок)
    case 58:
      return const Color(0xFFE0F7FA); // Очень светлый голубой
    case 59:
      return const Color(0xFFFCE4EC); // Очень светлый розовый (другой оттенок)
    case 60:
      return const Color(0xFFFFF9C4); // Светло-желтый (мягкий)
    case 61:
      return const Color(0xFFFFE4E1); // Светло-розовый (мягкий)
    case 62:
      return const Color(0xFFD1C4E9); // Светло-фиолетовый (мягкий)
    case 63:
      return const Color(0xFFBBDEFB); // Светло-синий (мягкий)
    case 64:
      return const Color(0xFFFFE0B2); // Светло-оранжевый (мягкий)
    case 65:
      return const Color(0xFFC8E6C9); // Светло-зеленый (мягкий)
    case 66:
      return const Color(0xFFFFCDD2); // Светло-красный (мягкий)
    case 67:
      return const Color(0xFFDCEDC8); // Светло-зеленый (мягкий, другой оттенок)
    case 68:
      return const Color(0xFFB2EBF2); // Светло-голубой (мягкий)
    case 69:
      return const Color(0xFFF8BBD0); // Светло-розовый (мягкий, другой оттенок)

    // Последние цвета (70-99)
    case 70:
      return const Color(0xFFFFFF00); // Чистый желтый
    case 71:
      return const Color(0xFFFF69B4); // Яркий розовый
    case 72:
      return const Color(0xFF8A2BE2); // Сине-фиолетовый
    case 73:
      return const Color(0xFF0000FF); // Чистый синий
    case 74:
      return const Color(0xFFFF8C00); // Темно-оранжевый
    case 75:
      return const Color(0xFF008000); // Чистый зеленый
    case 76:
      return const Color(0xFFFF0000); // Чистый красный
    case 77:
      return const Color(0xFF00FF00); // Лаймовый
    case 78:
      return const Color(0xFF00FFFF); // Аквамарин
    case 79:
      return const Color(0xFFFF00FF); // Пурпурный
    case 80:
      return const Color(0xFFF0E68C); // Хаки
    case 81:
      return const Color(0xFFDDA0DD); // Сливовый
    case 82:
      return const Color(0xFFADD8E6); // Светло-голубой
    case 83:
      return const Color(0xFFFA8072); // Лососевый
    case 84:
      return const Color(0xFF20B2AA); // Светло-морской
    case 85:
      return const Color(0xFF87CEEB); // Небесно-голубой
    case 86:
      return const Color(0xFF778899); // Серо-голубой
    case 87:
      return const Color(0xFFB0C4DE); // Светло-стальной
    case 88:
      return const Color(0xFFF4A460); // Песочный
    case 89:
      return const Color(0xFF2E8B57); // Морской зеленый
    case 90:
      return const Color(0xFF6A5ACD); // Сланцево-синий
    default:
      return const Color(0xFF000000); // Черный
  }
}
