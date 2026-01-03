import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/music_model.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final AudioService _audioService = AudioService();
  final List<MusicModel> playlist = [];

  int? playingIndex;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    loadPlaylist();

    _audioService.playerStateStream.listen((_) {
      setState(() {
        playingIndex = _audioService.currentIndex;
      });
    });

    _audioService.positionStream.listen((p) {
      setState(() => position = p);
    });

    _audioService.durationStream.listen((d) {
      if (d != null) {
        setState(() => duration = d);
      }
    });
  }

  Future<void> loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('playlist');
    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);
    setState(() {
      playlist
        ..clear()
        ..addAll(decoded.map((e) => MusicModel.fromJson(e)));
    });
  }

  Future<void> savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'playlist',
      jsonEncode(playlist.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> pickMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final savedPath = await StorageService.saveFile(file);

    setState(() {
      playlist.add(
        MusicModel(
          title: result.files.single.name.replaceAll('.mp4', ''),
          path: savedPath,
        ),
      );
    });

    await savePlaylist();
  }

  Future<void> playMusic(int index) async {
    final paths = playlist.map((m) => m.path).toList();
    await _audioService.setPlaylist(paths);
    await _audioService.playAt(index);

    setState(() => playingIndex = index);
  }

  void editMusic(int index) {
    final controller =
        TextEditingController(text: playlist[index].title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                playlist[index].title = controller.text.trim();
              });
              savePlaylist();
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteMusic(int index) async {
    await _audioService.stop();

    final file = File(playlist[index].path);
    if (await file.exists()) {
      await file.delete();
    }

    setState(() {
      playlist.removeAt(index);
      if (playingIndex == index) playingIndex = null;
    });

    await savePlaylist();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎵 NatMusic')),
      floatingActionButton: FloatingActionButton(
        onPressed: pickMusic,
        child: const Icon(Icons.upload),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (_, index) {
                final music = playlist[index];
                final isPlaying = index == playingIndex;

                return Card(
                  color:
                      isPlaying ? Colors.deepPurple.shade100 : null,
                  child: ListTile(
                    leading: Icon(
                      isPlaying && _audioService.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      size: 32,
                    ),
                    title: Text(music.title),
                    onTap: () => playMusic(index),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editMusic(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () => deleteMusic(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (playingIndex != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  Text(
                    playlist[playingIndex!].title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds
                        .toDouble()
                        .clamp(1, double.infinity),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
