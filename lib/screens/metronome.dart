import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Metronome extends StatefulWidget {
  const Metronome({super.key});
  @override
  State<Metronome> createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome> {
  int bpm = 60;
  Timer? metronomeTimer;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AssetSource _tickSound = AssetSource('sounds/test-sound.mp3');

  @override
  void initState() {
    super.initState();
    // Set up audio player with lower latency settings
    _audioPlayer.setReleaseMode(ReleaseMode.stop); // Stop after each play
    // *Preload the sound file
    _audioPlayer.setSource(_tickSound);
  }

  @override
  // Clean up resources when the widget is destroyed.
  void dispose() {
    metronomeTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void toggleMetronome() {
    if (isPlaying) {
      metronomeTimer?.cancel();
    } else {
      _startMetronomeTimer(); // Start a new timer with the current BPM
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  // Extract timer creation to a separate method for reuse
  void _startMetronomeTimer() {
    // Cancel any existing timer first
    metronomeTimer?.cancel();

    // Calculate interval in milliseconds based on BPM
    int interval = (60000 / bpm).round();

    if (kDebugMode) {
      print('Starting metronome at $bpm BPM (interval: $interval ms)');
    }

    metronomeTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      _playTick();
      if (kDebugMode) {
        print('Tick at BPM: $bpm');
      }
    });
  }

  void changeBPM(int change) {
    setState(() {
      bpm = (bpm + change).clamp(40, 240); // Update BPM value with limits

      // If currently playing, restart the timer with new BPM
      if (isPlaying) {
        _startMetronomeTimer();
      }
    });
  }

  // Play the tick sound with improved handling
  void _playTick() async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing sound before starting a new one
      await _audioPlayer.play(_tickSound); // Play the tick sound
    } catch (e) {
      if (kDebugMode) {
        print('Error playing tick sound: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Metronome'))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Bpm'),
          SizedBox(height: 10.0),
          Text(
            '$bpm',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => changeBPM(-1), child: Text('-')),
              SizedBox(width: 20.0),
              ElevatedButton(onPressed: () => changeBPM(1), child: Text('+')),
            ],
          ),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: toggleMetronome,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(isPlaying ? 'Stop' : 'Start'),
          ),
        ],
      ),
    );
  }
}
