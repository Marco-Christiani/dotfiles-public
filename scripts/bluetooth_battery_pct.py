#!/usr/bin/env python
"""See dmenu-options/batteries.py for a better implementation using DBus (handles non-bluetooth devices)."""
import shlex
import subprocess

import fire
import pydbus


devices = {
    'kyria': 'E5:7A:D9:51:38:3E',
    'mdr': '',
}


def _run_cmd(cmd: str, stdin=None) -> str:
    if stdin:
        from subprocess import Popen, PIPE
        p = Popen(
            shlex.split(cmd),
            stdout=PIPE,
            stdin=PIPE,
            stderr=PIPE,
            text=True
        )
        status, output = p.communicate(input=stdin)
    else:
        status, output = subprocess.getstatusoutput(cmd)  # type: ignore
    if status:  # return code should be 0
        raise RuntimeError(f'Command Failed: {cmd}\nOutput: {output}')
    return output


def _get_pct_bluetoothctl(device_name: str) -> str:
    device_name = device_name.lower()
    if device_name not in devices:
        raise ValueError(f'Invalid device selection. Known devices are: {list(devices.keys())}')
    device_addr = devices[device_name]
    raw_output = _run_cmd(f'bluetoothctl info {device_addr}')
    # Desired line looks like "\tBattery Percentage: <hex_pct> (<pct>)"
    for line in raw_output.splitlines():
        if line.strip().startswith('Battery Percentage'):
            raw_pct = line.split()[-1]
            pct = raw_pct.replace('(', '').replace(')', '')
            return f'{pct}%'
    return ''


def _get_pct_pydbus(device_name: str) -> str:
    bus = pydbus.SystemBus()
    obj_mngr = bus.get('org.bluez', '/')
    mngd_objs = obj_mngr.GetManagedObjects()
    for path, obj in mngd_objs.items():
        for k, v in obj.items():
            if v.get('Name', '').lower() == device_name:
                assert v.get('Connected', False), f'Device ({device_name}) not connected'
                device_num = k[-1]  # i.e. 'org.bluez.Device1'
                # HACK: Battery may not correspond to device number! Who knows..
                pct = obj[f'org.bluez.Battery{device_num}']['Percentage']
                return f'{pct}%'
    return ''


def _get_all_pct_pydbus() -> dict:
    """Get battery percent of all connected devices."""
    bus = pydbus.SystemBus()
    obj_mngr = bus.get('org.bluez', '/')
    mngd_objs = obj_mngr.GetManagedObjects()
    results = {}
    n_unknowns = 0
    for path, obj in mngd_objs.items():
        for k, v in obj.items():
            if v.get('Connected', False):
                device_name = v.get('Name', False)
                if not device_name:
                    device_name = f'{n_unknowns}?'
                    n_unknowns += 1
                device_num = k[-1]  # i.e. 'org.bluez.Device1'
                try:
                    # HACK: Battery may not correspond to device number! Who knows..
                    pct = obj[f'org.bluez.Battery{device_num}']['Percentage']
                    results[device_name] = f'{pct}%'
                except KeyError:
                    pass

    return results


def get_battery_percentage(*, all: bool = True, device_name: str = '', use_pydbus: bool = True):
    if all:
        return _get_all_pct_pydbus()
    if use_pydbus and device_name:
        return _get_pct_pydbus(device_name)
    return _get_pct_bluetoothctl(device_name)


if __name__ == "__main__":
    fire.Fire(get_battery_percentage)
