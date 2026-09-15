import sys, time
from yamcs.client import YamcsClient

pkts, st = [], {'end_at': None, 'done': False}

def on_packet(p):
    d = p.binary
    pkts.append(d)
    if len(d) > 8 and (int.from_bytes(d[0:2], 'big') & 0x07FF) == 3 and d[8] == 2:
        st['end_at'] = time.time()

def finish():
    st['done'] = True
    out, seqs, size, end_seq = {}, set(), None, None
    for d in pkts:
        if (int.from_bytes(d[0:2], 'big') & 0x07FF) != 3: continue
        if int.from_bytes(d[6:8], 'big') != 3: continue
        ftype, seq, body = d[8], int.from_bytes(d[9:13], 'big'), d[13:]
        if ftype == 0:
            size = int.from_bytes(body[0:4], 'big')
        elif ftype == 1:
            off = int.from_bytes(body[0:4], 'big')
            ln  = int.from_bytes(body[4:6], 'big')
            out[off] = body[6:6+ln]; seqs.add(seq)
        elif ftype == 2:
            end_seq = seq
    blob = b''.join(out[k] for k in sorted(out))
    open('/tmp/received.bin', 'wb').write(blob)
    lost = sorted(set(range(1, end_seq)) - seqs) if end_seq else []
    print(f"\nwrote {len(blob):,} of {size:,} bytes"
          f"   packets: expected {end_seq-1:,} got {len(seqs):,} lost {len(lost):,}", flush=True)
    print("  COMPLETE" if not lost else f"  first lost: {lost[:5]}", flush=True)

client = YamcsClient('localhost:8090')
proc = client.get_processor(instance=sys.argv[1], processor='realtime')
print('waiting... send the file now', flush=True)
proc.create_packet_subscription(on_data=on_packet)
while True:
    time.sleep(0.2)
    if st['end_at'] and not st['done'] and time.time() - st['end_at'] > 2:
        finish()