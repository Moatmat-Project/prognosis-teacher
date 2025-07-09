import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';
import 'package:moatmat_teacher/Presentation/tests/views/comment_managment_view.dart';

class VideosListView extends StatefulWidget {
  const VideosListView({super.key, required this.videos});
  final List<Video> videos;

  @override
  State<VideosListView> createState() => _VideosListViewState();
}

class _VideosListViewState extends State<VideosListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      appBar: AppBar(
        title: Text('قائمة الفيديوهات'),
        backgroundColor: ColorsResources.background,
      ),
      body: widget.videos.isEmpty
          ? const Center(child: Text('لا توجد فيديوهات'))
          : ListView.separated(
              itemCount: widget.videos.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final video = widget.videos[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text('الفيديو رقم ${index + 1}'),
                    subtitle: Text("video id : ${video.id}"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsManagmentView(
                            videoId: widget.videos[index].id,
                            url: widget.videos[index].url,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
