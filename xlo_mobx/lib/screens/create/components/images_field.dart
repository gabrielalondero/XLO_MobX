import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/stores/create_store.dart';

import 'image_dialog.dart';
import 'image_source_modal.dart';

class ImagesField extends StatelessWidget {
  const ImagesField({super.key, required this.createStore});

  final CreateStore createStore;

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File image) {
      createStore.images.add(image);
    }

    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          height: 120,
          child: Observer(builder: (_) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: createStore.images.length < 5
                  ? createStore.images.length + 1
                  : 5, //quantidade máxima de imagens
              itemBuilder: (_, index) {
                if (index == createStore.images.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          //se for android
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => ImageSourceModal(
                                onImageSelected: onImageSelected),
                          );
                        } else {
                          //se for IOS
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ImageSourceModal(
                                onImageSelected: onImageSelected),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_enhance,
                              size: 40,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      8,
                      8,
                      //caso for o último item, coloca um padding de 8 no right
                      index == 4 ? 8 : 0,
                      8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ImageDialog(
                            image: createStore.images[index],
                            onDelete: () => createStore.images.removeAt(index),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: createStore.images[index] is File 
                        ? FileImage(createStore.images[index])
                        : NetworkImage(createStore.images[index]) as ImageProvider,
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ),
        Observer(builder: (_){
          return createStore.imagesError != null
            ? Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.red),
                  ),
                ),
                child: Text(
                  createStore.imagesError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
            : Container();
        })
      ],
    );
  }
}
