import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synth_ex/job_status.dart';
import 'package:synth_ex/view_model/midi_devices_vm.dart';

class MidiDevices extends StatefulWidget {
  const MidiDevices({super.key});

  @override
  State<MidiDevices> createState() => _MidiDevicesState();
}

class _MidiDevicesState extends State<MidiDevices> {
  final MidiDevicesViewModel _midiDevicesViewModel = MidiDevicesViewModel();

  @override
  void didChangeDependencies() {
    _midiDevicesViewModel.getAllMidiDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Midi Devices'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: ChangeNotifierProvider(
          create: (BuildContext context) => _midiDevicesViewModel,
          child: Consumer<MidiDevicesViewModel>(
            builder: (context, value, child) {
              switch (value.midiDevicesJobStatus) {
                case JobStatus.idle:
                  return Container();
                case JobStatus.running:
                  return const Text("loading...");
                case JobStatus.completed:
                  return ListView.builder(
                      itemCount: value.midiDevices.length,
                      itemBuilder: (ctx, i) {
                        return Row(
                          children: [
                            Text(value.midiDevices[i].name),
                            const Spacer(),
                            Builder(
                              builder: (_) {
                                switch (value.midiDeviceConnectJobStatus) {
                                  case JobStatus.idle:
                                  case JobStatus.completed:
                                    return TextButton(
                                      onPressed: () => value.midiDevices[i].connected
                                          ? _midiDevicesViewModel.disconnectMidiDevice(value.midiDevices[i])
                                          : _midiDevicesViewModel.connectToMidiDevice(value.midiDevices[i]),
                                      child: Text(value.midiDevices[i].connected ? 'disconnect' : 'connect'),
                                    );
                                  default:
                                    return Container();
                                }
                              },
                            ),
                          ],
                        );
                      });
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
