import sys
from yamcs.client import YamcsClient

instance = sys.argv[1]
client = YamcsClient('localhost:8090')
proc = client.get_processor(instance=instance, processor='realtime')

def raw(p):
    return p.binary if hasattr(p, 'binary') else p.binary_

def on_packet(p):
    d = raw(p)
    apid = int.from_bytes(d[0:2], 'big') & 0x07FF
    print(f'apid {apid:4d}  size  {len(d):5d} {d[:16].hex()}', flush=True)

print('watching... Ctrl-C to stop', flush=True)

proc.create_packet_subscription(on_data=on_packet)
import time
while True:
    time.sleep(1)

