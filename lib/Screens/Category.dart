import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/selectedIcon.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Create new Category', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                const Gap(17),
                const Text('Category name'),
                const Gap(11),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    hintText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(21),
                const Text('Category Icon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                const Gap(11),
               
               Consumer<SelectedIcon>(builder: (context, vale, child) {
                 return  ElevatedButton(
                  onPressed: _showIconPicker,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (vale.selectedIcon != null) ...[
                        Icon(vale.selectedIcon, color: Colors.black),
                        const Gap(10),
                      ],
                      Text(vale.selectedIcon == null ? 'Choose Icon' : 'Change Icon'),
                    ],
                  ),
                );
  
               },),
                const Gap(451),
                
                   Consumer<SelectedIcon>(builder: (context, valu, child) {
                     return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        valu.RemoveIcon();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                   Consumer<SelectedIcon>(builder: (context, val, child) {
                     return  FilledButton(
                      onPressed: () {
                        if (categoryController.text.isNotEmpty && val.selectedIcon != null) {
                          // Create the category and pass it back to the previous screen
                          Navigator.pop(context, {
                            'name': categoryController.text,
                            'icon': val.selectedIcon,
                          });
                          categoryController.clear();
                          val.RemoveIcon();
                        } else {
                          // Show an error message if name is empty or icon is not selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a category name and select an icon'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text('Create Category'),
                    );
 
                   },)                 ],
                );
  
                   },)
                            ],
            ),
          ),
        ),
      ),
    );
  }

  void _showIconPicker() async {
    final IconData? selectedIcon = await buildCategoryIcon(context);
    if (selectedIcon != null) {
      Provider.of<SelectedIcon>(context, listen: false).SetIcon(selectedIcon);
    }
  }
}
buildCategoryIcon(BuildContext context) {
  Random random = Random();
  List<IconData> icon = [
    CupertinoIcons.check_mark, CupertinoIcons.clear, CupertinoIcons.clock,
    CupertinoIcons.cloud, CupertinoIcons.collections, CupertinoIcons.compass,
    CupertinoIcons.create, CupertinoIcons.delete, CupertinoIcons.ellipsis,
    CupertinoIcons.envelope, CupertinoIcons.exclamationmark_triangle,
    CupertinoIcons.eye, CupertinoIcons.heart, CupertinoIcons.home,
    CupertinoIcons.info, CupertinoIcons.link, CupertinoIcons.lock,
    CupertinoIcons.map, CupertinoIcons.mic, CupertinoIcons.music_note,
    CupertinoIcons.news, CupertinoIcons.person, CupertinoIcons.phone,
    CupertinoIcons.photo, CupertinoIcons.play_arrow, CupertinoIcons.refresh,
    CupertinoIcons.search, CupertinoIcons.settings, CupertinoIcons.share,
    CupertinoIcons.star, CupertinoIcons.tag, CupertinoIcons.trash,
    CupertinoIcons.add, CupertinoIcons.add_circled, CupertinoIcons.minus,
    CupertinoIcons.minus_circled, CupertinoIcons.multiply,
    CupertinoIcons.multiply_circle, CupertinoIcons.check_mark,
    CupertinoIcons.check_mark_circled, CupertinoIcons.check_mark_circled_solid,
    CupertinoIcons.clear, CupertinoIcons.clear_circled,
    CupertinoIcons.clear_circled_solid, CupertinoIcons.clock,
    CupertinoIcons.cloud, CupertinoIcons.cloud_download,
    CupertinoIcons.cloud_upload, CupertinoIcons.collections,
    CupertinoIcons.compass, CupertinoIcons.create, CupertinoIcons.delete,
    CupertinoIcons.delete_simple, CupertinoIcons.ellipsis,
    CupertinoIcons.envelope, CupertinoIcons.exclamationmark_circle,
    CupertinoIcons.exclamationmark_circle_fill, CupertinoIcons.exclamationmark_triangle,
    CupertinoIcons.exclamationmark_triangle_fill, CupertinoIcons.eye,
    CupertinoIcons.eye_slash, CupertinoIcons.gear, CupertinoIcons.heart,
    CupertinoIcons.heart_solid, CupertinoIcons.home, CupertinoIcons.info,
    CupertinoIcons.info_circle, CupertinoIcons.info_circle_fill,
    CupertinoIcons.link, CupertinoIcons.lock, CupertinoIcons.map,
    CupertinoIcons.mic, CupertinoIcons.mic_off, CupertinoIcons.music_note,
    CupertinoIcons.news, CupertinoIcons.person, CupertinoIcons.person_solid,
    CupertinoIcons.phone, CupertinoIcons.photo, CupertinoIcons.play_arrow,
    CupertinoIcons.refresh, CupertinoIcons.search, CupertinoIcons.settings,
    CupertinoIcons.share, CupertinoIcons.star, CupertinoIcons.star_fill,
    CupertinoIcons.star_lefthalf_fill, CupertinoIcons.tag, CupertinoIcons.trash,
    CupertinoIcons.wifi, CupertinoIcons.arrow_up, CupertinoIcons.arrow_down,
    CupertinoIcons.arrow_left, CupertinoIcons.arrow_right,
    CupertinoIcons.arrow_up_left, CupertinoIcons.arrow_up_right,
  ];

  return showDialog<IconData>(
    context: context,
    builder: (context) {
      IconData? selectedIcon;
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(11),
              const Text(
                'Choose Category icon',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 251,
                child: Divider(color: Colors.black, thickness: 1),
              ),
              const Gap(17),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: MasonryGridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: icon.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GestureDetector(
                          onTap: () {
                            selectedIcon = icon[index % icon.length];
                            Navigator.of(context).pop(selectedIcon);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            height: 75,
                            color: Color.fromARGB(
                              255,
                              101 + random.nextInt(56),
                              101 + random.nextInt(56),
                              101 + random.nextInt(56),
                            ),
                            child: Center(
                              child: Icon(
                                icon[index % icon.length],
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(31),
            ],
          ),
        ),
      );
    },
  );
}
