import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

abstract class IFile {
  int getSize();
  Widget render(BuildContext context);
}

class File extends StatelessWidget implements IFile {
  final String title;
  final int size;
  final IconData icon;
  const File(this.title, this.size, this.icon);

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  @override
  int getSize() {
    return size;
  }

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: Text(FileSizeConverter.bytesToString(size)),
      ),
    );
  }
}

class AudioFile extends File {
  AudioFile(String title, int size) : super(title, size, Icons.music_note);
}

class ImageFile extends File {
  ImageFile(String title, int size) : super(title, size, Icons.image);
}

class TextFile extends File {
  TextFile(String title, int size) : super(title, size, Icons.description);
}

class VideoFile extends File {
  VideoFile(String title, int size) : super(title, size, Icons.movie);
}

class Directory extends StatelessWidget implements IFile {
  final String title;
  final bool isInitiallyExpanded;

  final List<IFile> files = [];

  Directory(this.title, {this.isInitiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  void addFile(IFile file) {
    files.add(file);
  }

  @override
  int getSize() {
    var sum = 0;
    files.forEach((element) {
      sum += element.getSize();
    });
    return sum;
  }

  @override
  Widget render(BuildContext context) {
    return Theme(
        data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
        child: Padding(
          padding: context.paddingLow,
          child: ExpansionTile(
            leading: Icon(Icons.folder),
            title: Text("$title ${FileSizeConverter.bytesToString(getSize())}"),
            children: files.map((e) => e.render(context)).toList(),
            initiallyExpanded: isInitiallyExpanded,
          ),
        ));
  }
}

class FileSizeConverter {
  static String bytesToString(int bytes) {
    var sizes = ["B", "KB", "MB", "GB", "TB"];
    var len = bytes.toDouble();
    var order = 0;
    while (len >= 1024 && order++ < sizes.length - 1) {
      len /= 1024;
    }
    return "${len.toStringAsFixed(2)} ${sizes[order]}";
  }
}

class CompositView extends StatelessWidget {
  const CompositView({Key? key}) : super(key: key);

  Widget _buildMediaDirectory() {
    var musicMediaDirectory = Directory("Music");
    musicMediaDirectory.addFile(AudioFile("Darude - SandStorm.mp3", 1597538));
    musicMediaDirectory.addFile(AudioFile("Toto - Africa.mp3", 1545538));
    musicMediaDirectory.addFile(AudioFile("Bag Raiders", 5847538));
    musicMediaDirectory.addFile(AudioFile("Eye Of Tiger", 7137538));

    final moviesDirectory = Directory('Movies');

    moviesDirectory.addFile(VideoFile('The Matrix.avi', 951495532));
    moviesDirectory.addFile(VideoFile('The Matrix Reloaded.mp4', 1251495532));

    final catPicturesDirectory = Directory('Cats');
    catPicturesDirectory.addFile(ImageFile('Cat 1.jpg', 844497));
    catPicturesDirectory.addFile(ImageFile('Cat 2.jpg', 975363));
    catPicturesDirectory.addFile(ImageFile('Cat 3.png', 1975363));

    final picturesDirectory = Directory('Pictures');
    picturesDirectory.addFile(catPicturesDirectory);
    picturesDirectory.addFile(ImageFile('Not a cat.png', 2971361));

    final mediaDirectory = Directory("Media", isInitiallyExpanded: true);
    mediaDirectory.addFile(musicMediaDirectory);
    mediaDirectory.addFile(moviesDirectory);
    mediaDirectory.addFile(picturesDirectory);
    mediaDirectory.addFile(Directory('New Folder'));
    mediaDirectory.addFile(TextFile('Nothing suspicious there.txt', 430791));
    mediaDirectory.addFile(TextFile('TeamTrees.txt', 1042));

    return mediaDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: context.paddingLow,
        child: _buildMediaDirectory(),
      ),
    );
  }
}
