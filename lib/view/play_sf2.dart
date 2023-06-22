import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:synth_ex/view/midi_devices.dart';
import 'package:synth_ex/view_model/play_sf2_vm.dart';

class PlaySF2 extends StatefulWidget {
  const PlaySF2({super.key});

  @override
  State<PlaySF2> createState() => _PlaySF2State();
}

class _PlaySF2State extends State<PlaySF2> {
  final PlaySF2ViewModel _midiDevicesViewModel = PlaySF2ViewModel();

  @override
  void didChangeDependencies() async {
    // load sf2 librray
    _midiDevicesViewModel.loadSoundfont();

    // start midi tracking
    _midiDevicesViewModel.startMidiTracking();
    super.didChangeDependencies();
  }

  playMidi(MidiPacket midiPacket) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SF2 Player'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MidiDevices())),
            icon: const Icon(Icons.settings),
            label: const Text('Midi Devices'),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text('Instrument: ${_midiDevicesViewModel.path.replaceAll('assets/', '')}'),
          ],
        ),
      ),
    );
  }
}
