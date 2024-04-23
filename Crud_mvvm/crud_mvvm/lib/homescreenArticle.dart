import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SampleItem {
  String id;
  ValueNotifier<String> name;
  ValueNotifier<String> author;
  ValueNotifier<String> content;
  String image;  

  SampleItem(
      {String? id, required String name, String? author, String? content, this.image = ''})
      : id = id ?? generateUuid(),
        name = ValueNotifier(name),
        author = ValueNotifier(author ?? ''),
        content = ValueNotifier(content ?? '');

  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}

class SampleItemViewModel extends ChangeNotifier {
  static final _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._();
  final List<SampleItem> items = [];

  void addItem(String name, String author, String content, String image) {
    items.add(SampleItem(name: name, author: author, content: content, image: image));
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateItem(
      String id, String newName, String newauthor, String newContent, String newImage) {
    try {
      final item = items.firstWhere((item) => item.id == id);
      item.name.value = newName;
      item.author.value = newauthor;
      item.content.value = newContent;
      item.image = newImage;  
      notifyListeners();
    } catch (e) {
      debugPrint("Không tìm thấy mục với ID $id");
    }
  }
}

class SampleItemUpdate extends StatefulWidget {
  final String? initialName;
  final String? initialauthor;
  final String? initialContent;
  final String? initialImage;  

  const SampleItemUpdate(
      {Key? key, this.initialName, this.initialauthor, this.initialContent, this.initialImage})
      : super(key: key);

  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController _nameController;
  late TextEditingController _authorController;
  late TextEditingController _contentController;
  late XFile? _imageFile;  

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _authorController = TextEditingController(text: widget.initialauthor);
    _contentController = TextEditingController(text: widget.initialContent);
    _imageFile = widget.initialImage != null ? XFile(widget.initialImage!) : null;   
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile as XFile?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm mới'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop({
                'name': _nameController.text,
                'author': _authorController.text,
                'content': _contentController.text,
                'image': _imageFile?.path ?? ''
              });
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      resizeToAvoidBottomInset : false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Tác giả'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Nội dung'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_imageFile != null ? 'Chọn lại ảnh' : 'Chọn ảnh'),
            ),
            _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    height: 105,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class SampleItemWidget extends StatelessWidget {
  final SampleItem item;
  final VoidCallback? onTap;

  const SampleItemWidget({Key? key, required this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: item.name,
      builder: (context, name, child) {
        return ListTile(
          title: Text(name!),
          subtitle: Text(item.author.value),
          leading: CircleAvatar(
            backgroundImage: item.image.isNotEmpty ? FileImage(File(item.image)) : AssetImage('assets/images/flutter_logo.png') as ImageProvider,
          ),
          onTap: onTap,
          trailing: const Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}

class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item;
  const SampleItemDetailsView({Key? key, required this.item});

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel();

  void _deleteItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc muốn xóa mục này?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Bỏ qua"),
            ),
            TextButton(
              onPressed: () {
                viewModel.removeItem(widget.item.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  void _editItem(BuildContext context) {
    showModalBottomSheet<Map<String, String>?>(
      context: context,
      builder: (context) => SampleItemUpdate(
        initialName: widget.item.name.value,
        initialauthor: widget.item.author.value,
        initialContent: widget.item.content.value,
        initialImage: widget.item.image,
      ),
    ).then((value) {
      if (value != null) {
        viewModel.updateItem(
          widget.item.id,
          value['name'] ?? '',
          value['author'] ?? '',
          value['content'] ?? '',
          value['image'] ?? '',
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editItem(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteItem(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.item.name.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          widget.item.image.isNotEmpty
              ? Image.file(
                  File(widget.item.image),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  height: 250,
                )
              : SizedBox.shrink(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Tác giả: ${widget.item.author.value}',
              style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.item.content.value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class SampleItemSearchDelegate extends SearchDelegate<SampleItem> {
  final SampleItemViewModel viewModel;

  SampleItemSearchDelegate({required this.viewModel});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, SampleItem(id: '', name: '', author: '', content: '', image: ''));
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text("Vui lòng nhập tên bài báo để tìm kiếm"));
    }

    final List<SampleItem> filteredItems = viewModel.items
        .where((item) =>
            item.name.value.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          title: Text(item.name.value),
          subtitle: Text(item.author.value),
          leading: CircleAvatar(
            backgroundImage: item.image.isNotEmpty ? FileImage(File(item.image)) : AssetImage('assets/images/flutter_logo.png') as ImageProvider,
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SampleItem> suggestionList = query.isEmpty
        ? []
        : viewModel.items
            .where((item) =>
                item.name.value.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];
        return ListTile(
          title: Text(item.name.value),
          subtitle: Text(item.author.value),
          leading: CircleAvatar(
            backgroundImage: item.image.isNotEmpty ? FileImage(File(item.image)) : AssetImage('assets/images/flutter_logo.png') as ImageProvider,
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();

  Future<void> _startSearch(BuildContext context) async {
    final SampleItem? selected = await showSearch(
      context: context,
      delegate: SampleItemSearchDelegate(viewModel: viewModel),
    );
    if (selected != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SampleItemDetailsView(item: selected),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các bài báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<Map<String, String>?>(
                context: context,
                builder: (context) => const SampleItemUpdate(),
              ).then((value) {
                if (value != null) {
                  viewModel.addItem(value['name'] ?? '', value['author'] ?? '',
                      value['content'] ?? '', value['image'] ?? '');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _startSearch(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return ListView.builder(
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return SampleItemWidget(
                key: ValueKey(item.id),
                item: item,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SampleItemDetailsView(item: item),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
