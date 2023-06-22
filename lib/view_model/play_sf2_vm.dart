import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

class PlaySF2ViewModel with ChangeNotifier {
  final String path = 'assets/sample.sf2';
  final MidiPro _midiPro = MidiPro();

  Future loadSoundfont() async => _midiPro.loadSoundfont(name: path.replaceAll('assets/', ''), sf2Path: path);

  void startMidiTracking() {
    MidiCommand().onMidiDataReceived!.listen((midiPacket) {
      // TODO: remove this line when release
      if (kDebugMode) print("MIDI DATA: ${midiPacket.data}");

      /* check midi packet has a velocity byte.
      in the midi byte list, index 2 defines note velocity.
      if the packet has no velocity byte this means note stopped.
      */
      if (midiPacket.data[2] != 0) {
        _midiPro.playMidiNote(midi: midiPacket.data[1], velocity: midiPacket.data[2]);
      } else {
        _midiPro.stopMidiNote(midi: midiPacket.data[1]);
      }
    });
  }
}
