import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:province/addressInfo.dart';

import 'package:province/district.dart';
import 'package:province/province.dart';
import 'package:province/userInfo.dart';
import 'package:province/ward.dart';

class ProfileView extends StatefulWidget{
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>{
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();

  int currentStep = 0;
  UserInfo userInfo = UserInfo();
  bool isLoaded = false;

  Future<UserInfo> init() async {
    if (isLoaded) return userInfo;
    var value = await loadUserInfo();
    if (value != null){
      try {
        isLoaded = true;
        return UserInfo.fromMap(value);
      } catch (e){
        debugPrint(e.toString());
        return UserInfo();
      }
    }

    return UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    void updateStep(int value) {
      if (currentStep == 0) {
        if (step1FormKey.currentState!.validate()) {
          step1FormKey.currentState!.save();
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 1) {
        if (value > currentStep) {
          if (step2FormKey.currentState!.validate()) {
            step2FormKey.currentState!.save();
            setState(() {
              currentStep = value;
            });
          }
        } else {
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 2) {
        setState(() {
          if (value < currentStep) {
            currentStep = value;
          } else {
            saveUserInfo(userInfo).then((value) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thông báo'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('Hồ sơ người dùng đã được lưu thành công!'),
                          Text('Bạn có thể quay lại các bước để cập nhật!'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Đóng'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật hồ sơ'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false, // người dùng phải nhấn nút!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có muốn xóa thông tin đã lưu?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false); // đóng dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Đồng ý'),
                        onPressed: () {
                          // thực hiện hành động khi người dùng chon "Đồng ý"
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value != null && value == true) {
                  setState(() {
                    userInfo == UserInfo();
                  });
                  saveUserInfo(userInfo);
                }
              });
            },
            icon: const Icon(Icons.deblur_outlined),
          )
        ],
      ),
      body: FutureBuilder<UserInfo>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInfo = snapshot.data!;
            return Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        if (currentStep == 2)
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: const Text('LƯU'),
                          )
                        else
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: const Text('TIẾP'),
                          ),
                        if (currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('QUAY LẠI'),
                          ),
                      ],
                    ),
                    if (currentStep == 2)
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('ĐÓNG'),
                      )
                  ],
                );
              },
              onStepTapped: (value) {
                updateStep(value);
              },
              onStepContinue: () {
                updateStep(currentStep + 1);
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text('Cơ bản'),
                  content: Step1Form(formKey: step1FormKey, userInfo: userInfo),
                  isActive: currentStep == 0,
                ),
                Step(
                  title: const Text('Địa chỉ'),
                  content: Step2From(formKey: step2FormKey, userInfo: userInfo),
                  isActive: currentStep == 1,
                ),
                Step(
                  title: const Text('Xác nhận'),
                  content: ConfirmInfo(userInfo: userInfo),
                  isActive: currentStep == 2,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else {
            return const Center(child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  final nameCtl = TextEditingController();

  final dateCtl = TextEditingController();

  final emailCtl = TextEditingController();

  final phoneCtl = TextEditingController();

  // Hàm xác thực email bằng biểu thức chính quy
  bool isEmailValid(String email) {
    String pattern =
        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    final emailRegex = RegExp(pattern);
    return emailRegex.hasMatch(email);
  }

  // Hàm xác thực số điện thoại bằng biểu thức chính quy
  bool isMobileValid(String value) {
    String pattern = r"(^(?:[+0]9)?[0-9]{10,12}$)";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    nameCtl.text = widget.userInfo.name ?? '';
    dateCtl.text = widget.userInfo.birthDate != null
        ? DateFormat('dd/MM/yyyy').format(widget.userInfo.birthDate!)
        : '';
    emailCtl.text = widget.userInfo.email ?? '';
    phoneCtl.text = widget.userInfo.phoneNumber ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameCtl,
              decoration: const InputDecoration(labelText: 'Họ và Tên'),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập Họ và Tên';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.name = value,
            ),
            TextFormField(
              controller: dateCtl,
              decoration: const InputDecoration(
                labelText: "Ngày sinh",
                hintText: "Nhập ngày sinh",
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: widget.userInfo.birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (date != null) {
                  widget.userInfo.birthDate = date;
                  dateCtl.text = DateFormat('dd/MM/yyyy').format(date);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập ngày sinh';
                }
                try {
                  DateFormat('dd/MM/yyyy').parse(value);
                  return null;
                } catch (e) {
                  return 'Ngày sinh không hợp lệ';
                }
              },
            ),
            TextFormField(
              controller: emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                } else if (!isEmailValid(value)) {
                  return 'Định dạng email không hợp lệ';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.email = value,
            ),
            TextFormField(
              controller: phoneCtl,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                } else if (!isMobileValid(value)) {
                  return 'Định dạng số điện thoại không hợp lệ';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.phoneNumber = value,
            )
          ],
        ),
      ),
    );
  }
}

class Step2From extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step2From({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step2From> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2From> {
  final streetCtl = TextEditingController();

  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Ward> wardList = [];

  @override
  void initState() {
    loadLocationData().then((value) => setState(() {}));
    super.initState();
  }

  /// Hàm này được sử dụng để tải dữ liệu về đơn vị hành chính từ tệp JSON và
  /// chuyển đổi nó thành các đối tượng tương úng.
  ///
  /// Nếu có lỗi xảy ra trong quá trình tải dữ liệu hoặc chuyển đối, phương thức
  /// sẽ bắt và ghi log ra màn hình debug
  ///
  /// Bắn ngoại lệ Throws [Exception]:
  ///  - Nếu có lỗi xảy ra trong quá trình tải hoặc chuyển đổi dữ liệu
  Future<void> loadLocationData() async {
    try {
      // Tải nội dung của tệp JSON từ assets
      String data =
      await rootBundle.loadString('assets/don_vi_hanh_chinh.json');
      // Chuyển đổi chuỗi JSON thành một đối tượng có kiểu dữ liệu từ điển
      Map<String, dynamic> jsonData = json.decode(data);
      // Trích xuất danh sách các tỉnh dữ liệu từ điển và chuyển đổi thành
      // danh sách các đối tượng Province
      List provinceData = jsonData['province'];
      provinceList =
          provinceData.map((json) => Province.fromMap(json)).toList();

      // Trích xuất danh sách các huyện dữ liệu từ điển và chuyển đổi thành
      // danh sách các đối tượng District
      List districtData = jsonData['district'];
      districtList =
          districtData.map((json) => District.fromMap(json)).toList();
      // Trích xuất danh sách các xã dữ liệu từ điển và chuyển đổi thành
      // danh sách các đối tượng Ward
      List wardData = jsonData['ward'];
      wardList = wardData.map((json) => Ward.fromMap(json)).toList();
    } catch (e) {
      // Ghi log ra màn hình debug nếu có lỗi ngoại lệ xảy ra
      debugPrint('Error loading location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    streetCtl.text = widget.userInfo.address?.street ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Autocomplete<Province>(
              fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                  ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.province?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tỉnh / Thành phố',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    if (widget.userInfo.address?.province == null ||
                        value!.isEmpty) {
                      return 'Vui lòng chọn một Tỉnh / Thành phố';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return provinceList;
                }
                return provinceList.where((element) {
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                if (widget.userInfo.address?.province != option) {
                  setState(() {
                    widget.userInfo.address = AddressInfo(province: option);
                  });
                }
              },
            ),
            Autocomplete<District>(
              fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                  ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.district?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Huyện / Quận',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    if (widget.userInfo.address?.district == null ||
                        value!.isEmpty) {
                      return 'Vui lòng chọn một Huyện / Quận';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return districtList.where((element) =>
                  widget.userInfo.address?.province?.id != null &&
                      element.provinceId ==
                          widget.userInfo.address?.province?.id);
                }
                return districtList.where((element) {
                  var cond1 = element.provinceId ==
                      widget.userInfo.address?.province?.id;

                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                if (widget.userInfo.address?.district != option) {
                  setState(() {
                    widget.userInfo.address?.district = option;
                    widget.userInfo.address?.ward = null;
                  });
                }
              },
            ),
            Autocomplete<Ward>(
              fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                  ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.ward?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Xã / Phường / Thị Trấn',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    if (widget.userInfo.address?.ward == null ||
                        value!.isEmpty) {
                      return 'Vui lòng chọn một Xã / Phường / Thị Trấn';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return wardList.where((element) =>
                  element.districtId ==
                      widget.userInfo.address?.district?.id);
                }
                return wardList.where((element) {
                  var cond1 = element.districtId ==
                      widget.userInfo.address?.district?.id;

                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                widget.userInfo.address?.ward = option;
              },
            ),
            TextFormField(
              controller: streetCtl,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
              onSaved: (value) {
                widget.userInfo.address?.street = value!;
              },
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmInfo extends StatelessWidget {
  final UserInfo userInfo;

  const ConfirmInfo({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem('Họ và tên:', userInfo.name),
          _buildInfoItem(
            'Ngày sinh:',
            userInfo.birthDate != null
                ? DateFormat('dd/MM/yyyy').format(userInfo.birthDate!)
                : '',
          ),
          _buildInfoItem('Email:', userInfo.email),
          _buildInfoItem('Số điện thoại:', userInfo.phoneNumber),
          _buildInfoItem('Tỉnh / Thành phố:', userInfo.address?.province?.name),
          _buildInfoItem('Huyện / Quận:', userInfo.address?.district?.name),
          _buildInfoItem(
              'Xã / Phường / Thị Trấn:', userInfo.address?.ward?.name),
          _buildInfoItem('Địa chỉ:', userInfo.address?.street),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

Future<void> saveUserInfo(UserInfo info) async {
  return await Localstore.instance
      .collection('users')
      .doc('info')
      .set(info.toMap());
}

Future<Map<String, dynamic>?> loadUserInfo() async {
  return await Localstore.instance.collection('users').doc('info').get();
}

