import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/content_model.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final ContentModel content;

  const VideoPlayerScreen({super.key, required this.content});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isControlsVisible = true;
  bool _isFullscreen = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedQuality = 'Auto';
  bool _subtitlesEnabled = false;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.content.videoUrl),
      );
      
      await _controller.initialize();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _showControls() {
    setState(() {
      _isControlsVisible = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...AppConstants.videoQualities.map((quality) {
              return ListTile(
                title: Text(quality),
                trailing: _selectedQuality == quality
                    ? const Icon(Icons.check, color: AppTheme.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedQuality = quality;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Quality changed to $quality'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              )
            : _hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isLoading = true;
                            });
                            _initializePlayer();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: _showControls,
                    child: Stack(
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        if (_isControlsVisible)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        if (_isControlsVisible)
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  widget.content.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: _showQualitySelector,
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_isControlsVisible)
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final currentPosition = _controller.value.position;
                                    final newPosition = currentPosition - const Duration(seconds: 10);
                                    _controller.seekTo(
                                      newPosition < Duration.zero ? Duration.zero : newPosition,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.replay_10,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _togglePlayPause,
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final currentPosition = _controller.value.position;
                                    final duration = _controller.value.duration;
                                    final newPosition = currentPosition + const Duration(seconds: 10);
                                    _controller.seekTo(
                                      newPosition > duration ? duration : newPosition,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.forward_10,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_isControlsVisible)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _formatDuration(_controller.value.position),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: _controller.value.position.inMilliseconds.toDouble(),
                                        min: 0,
                                        max: _controller.value.duration.inMilliseconds.toDouble(),
                                        onChanged: (value) {
                                          _controller.seekTo(Duration(milliseconds: value.toInt()));
                                        },
                                        activeColor: AppTheme.primaryColor,
                                        inactiveColor: Colors.white30,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_controller.value.duration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _subtitlesEnabled = !_subtitlesEnabled;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              _subtitlesEnabled
                                                  ? 'Subtitles enabled'
                                                  : 'Subtitles disabled',
                                            ),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.subtitles,
                                        color: _subtitlesEnabled ? AppTheme.primaryColor : Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _volume = _volume > 0 ? 0 : 1.0;
                                            });
                                            _controller.setVolume(_volume);
                                          },
                                          icon: Icon(
                                            _volume > 0 ? Icons.volume_up : Icons.volume_off,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Slider(
                                            value: _volume,
                                            onChanged: (value) {
                                              setState(() {
                                                _volume = value;
                                              });
                                              _controller.setVolume(value);
                                            },
                                            activeColor: AppTheme.primaryColor,
                                            inactiveColor: Colors.white30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: _toggleFullscreen,
                                      icon: Icon(
                                        _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}