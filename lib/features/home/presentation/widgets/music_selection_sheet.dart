import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/reels_store.dart';
import 'package:just_audio/just_audio.dart';

class MusicSelectionSheet extends StatefulWidget {
  final ReelsStore store;

  const MusicSelectionSheet({super.key, required this.store});

  @override
  State<MusicSelectionSheet> createState() => _MusicSelectionSheetState();
}

class _MusicSelectionSheetState extends State<MusicSelectionSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingUrl;

  @override
  void initState() {
    super.initState();
    widget.store.fetchSystemMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(String url) async {
    if (_playingUrl == url) {
      await _audioPlayer.stop();
      setState(() => _playingUrl = null);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      setState(() => _playingUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chọn nhạc nền',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Observer(
              builder: (_) {
                if (widget.store.isMusicLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (widget.store.systemMusicList.isEmpty) {
                  return const Center(child: Text('Không có bản nhạc nào'));
                }

                return ListView.builder(
                  itemCount: widget.store.systemMusicList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final music = widget.store.systemMusicList[index];
                    final isPlaying = _playingUrl == music.url;
                    final isSelected = widget.store.selectedMusic?.id == music.id;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () => _togglePlay(music.url),
                      ),
                      title: Text(
                        music.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: music.artist != null ? Text(music.artist!) : null,
                      trailing: isSelected 
                        ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                        : null,
                      onTap: () {
                        widget.store.selectMusic(music);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
