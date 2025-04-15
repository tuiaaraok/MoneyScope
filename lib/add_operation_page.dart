import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:finance/date/finance_operation_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddOperationPage extends StatefulWidget {
  const AddOperationPage({super.key});

  @override
  State<AddOperationPage> createState() => _AddOperationPageState();
}

class _AddOperationPageState extends State<AddOperationPage> {
  String previousText = '';
  final TextEditingController dateController = TextEditingController();
  final TextEditingController operationCategoryController =
      TextEditingController();
  final TextEditingController sumController = TextEditingController();
  FocusNode sumNode = FocusNode();

  Box<FinanceOperationModel> financeOperationModel =
      Hive.box<FinanceOperationModel>(HiveBoxes.financeOperationModel);
  final MenuElem operationCategory = MenuElem(
    isOpen: false,
    selectedElem: "",
    listElements: [],
  );

  final MenuElem operationType = MenuElem(
    isOpen: false,
    selectedElem: "",
    listElements: ["Expenses", "Income"],
  );

  @override
  void initState() {
    super.initState();
    operationCategory.listElements
        .addAll(financeOperationModel.values.map((toElement) {
      return toElement.operationCategory;
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraint) {
            return KeyboardActions(
              config: KeyboardActionsConfig(
                keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                nextFocus: false,
                actions: [
                  KeyboardActionsItem(
                    focusNode: sumNode,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                // Добавлен SingleChildScrollView
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildAppBar(),
                        _buildOperationCategoryDropdown(),
                        _buildOperationTypeDropdown(),
                        _buildSumTextField(),
                        _buildDateTextField(),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (sumController.text.isNotEmpty &&
                                operationCategoryController.text.isNotEmpty &&
                                operationType.selectedElem.isNotEmpty &&
                                dateController.text.isNotEmpty) {
                              final dateParts = dateController.text.split('.');
                              DateTime? paymentDate;
                              if (dateParts.length == 3) {
                                paymentDate = DateTime(
                                  int.parse(dateParts[2]),
                                  int.parse(dateParts[1]),
                                  int.parse(dateParts[0]),
                                );
                              }
                              financeOperationModel.add(FinanceOperationModel(
                                  operationCategory:
                                      operationCategoryController.text,
                                  operationType: operationType.selectedElem,
                                  sum: double.tryParse(sumController.text) ?? 0,
                                  date: paymentDate ?? DateTime.now()));
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 327.w,
                            height: 47.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: const Color(0xFF514EAA),
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: GoogleFonts.kronaOne(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      width: 340.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  size: 32.w, color: const Color(0xFF4B1535))),
          Text(
            "Add operation",
            style: GoogleFonts.kronaOne(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: const Color(0xFF4B1535),
            ),
          ),
          SizedBox(width: 32.w),
        ],
      ),
    );
  }

  Widget _buildOperationCategoryDropdown() {
    return _buildDropdownSection(
      title: "Operation category",
      menu: operationCategory,
      controller: operationCategoryController,
    );
  }

  Widget _buildOperationTypeDropdown() {
    return _buildDropdownSection(
      title: "Operation type",
      menu: operationType,
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

  Widget _buildSumTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: MyTextField.textFieldIcon(
          "Sum",
          340.w,
          sumController,
          Text(
            "\$",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
          keyboard: TextInputType.number,
          myNode: sumNode),
    );
  }

  Widget _buildDateTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: MyTextField.textFieldIcon(
        "Payment date",
        340.w,
        dateController,
        SvgPicture.asset("assets/icons/calendar.svg"),
        keyboard: TextInputType.datetime,
        onChange: (text) => _validateDate(text, dateController),
      ),
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

class MenuElem {
  bool isOpen;
  String selectedElem;
  List<String> listElements;

  MenuElem({
    required this.isOpen,
    required this.selectedElem,
    required this.listElements,
  });
}
