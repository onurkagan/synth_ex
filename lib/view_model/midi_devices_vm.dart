import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:synth_ex/job_status.dart';

class MidiDevicesViewModel with ChangeNotifier {
  List<MidiDevice> midiDevices = [];
  JobStatus midiDevicesJobStatus = JobStatus.idle;
  JobStatus midiDeviceConnectJobStatus = JobStatus.idle;

  _fetchMididDevices() async {
    // fetch all midi devices
    List<MidiDevice>? devices = await MidiCommand().devices;

    // sort devices
    if (devices != null) devices.sort((a, b) => a.name.compareTo(b.name));

    // set midi devices
    midiDevices = devices ?? [];
  }

  getAllMidiDevices() async {
    // change & notify midi devices job status => running
    midiDevicesJobStatus = JobStatus.running;
    notifyListeners();

    // fetch all midi devices
    await _fetchMididDevices();

    // change & notify midi devices job status => completed
    midiDevicesJobStatus = JobStatus.completed;

    // notify ui
    notifyListeners();
  }

  connectToMidiDevice(MidiDevice device) async {
    // start device connection
    await MidiCommand().connectToDevice(device);

    // refetch midi devices
    await _fetchMididDevices();

    // change midi devices connection job status => completed
    midiDeviceConnectJobStatus = JobStatus.completed;

    // notify ui
    notifyListeners();
  }

  disconnectMidiDevice(MidiDevice device) async {
    // start device connection
    MidiCommand().disconnectDevice(device);

    // refetch midi devices
    await _fetchMididDevices();

    // change midi devices connection job status => completed
    midiDeviceConnectJobStatus = JobStatus.completed;

    // notify ui
    notifyListeners();
  }
}
