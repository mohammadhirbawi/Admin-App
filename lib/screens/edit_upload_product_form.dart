import 'package:admin_app/consts/app_constants.dart';
import 'package:admin_app/consts/my_validators.dart';
import 'package:admin_app/services/my_app_method.dart';
import 'package:admin_app/widgets/subtitle_text.dart';
import 'package:admin_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductScreen extends StatefulWidget {
  static const routName = '/EditOrUploadProductScreen';

  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? _categoryValue;
  @override
  void initState() {
    _titleController = TextEditingController(text: "");
    _priceController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _quantityController = TextEditingController(text: "");

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  //Upload Function
  Future<void> _uploadProduct() async {
    FocusScope.of(context).unfocus();
    if (_categoryValue == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Category is empty",
        fct: () {},
      );
      return;
    }
    final isValid = _formKey.currentState!.validate();

    if (isValid) {}
  }

  //Edit Function
  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {}
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.upload),
                    label: const Text(
                      "Upload Product",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _uploadProduct();
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const TitlesTextWidget(
              label: "Upload a new product",
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                /* Image Picker Here */
                const SizedBox(
                  height: 25,
                ),
                DropdownButton(
                    hint: const Text("Select Category"),
                    value: _categoryValue,
                    items: AppConstants.categoriesDropDownList,
                    onChanged: (
                      String? value,
                    ) {
                      setState(() {
                        _categoryValue = value;
                      });
                    }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey("Title"),
                          maxLength: 80,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Product Title',
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "Please enter a valid title",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _priceController,
                                key: const ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'(\d+)?\.\d{0,2}'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  hintText: "price",
                                  prefix: SubtitleTextWidget(
                                    label: "\$",
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString: "Price is missing",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _quantityController,
                                key: const ValueKey('Quantity'),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Qty",
                                ),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString: "Quantity is missing",
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          key: const ValueKey('Description'),
                          controller: _descriptionController,
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: "Product description",
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "Description is missing",
                            );
                          },
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          ))),
    );
  }
}
