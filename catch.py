import sys, time
from yamcs.client import YamcsClient

instance = sys.argv[1]
out, seqs = {}, set()
st = {'size': None, 't0': None, 'bytes': 0, 'pos': 0,
      'end_seq': None, 'end_at': None, 'done': False, 'last': 0}

def dur(s): return f"{int(s)//60}m {s % 60:04.1f}s"
def bar(pct, w=28):
    n = min(w, int(pct * w / 100))
    return '[' + '#' * n + '-' * (w - n) + ']'

def on_packet(p):
    d = p.binary
    if (int.from_bytes(d[0:2], 'big') & 0x07FF) != 3: return
    if int.from_bytes(d[6:8], 'big') != 3: return
    ftype, seq, body = d[8], int.from_bytes(d[9:13], 'big'), d[13:]

    if ftype == 0:
        out.clear(); seqs.clear()
        st.update(size=int.from_bytes(body[0:4], 'big'), t0=time.time(),
                  bytes=0, pos=0, end_seq=None, end_at=None, done=False, last=0)
        n = body[4]
        print(f"START {body[5:5+n].decode(errors='replace')}  {st['size']:,} bytes", flush=True)

    elif ftype == 1:
        off = int.from_bytes(body[0:4], 'big')
        ln  = int.from_bytes(body[4:6], 'big')
        out[off] = body[6:6+ln]; seqs.add(seq)
        st['bytes'] += ln
        st['pos'] = max(st['pos'], off + ln)
        now = time.time()
        if now - st['last'] > 0.2 and st['size']:
            el   = max(now - st['t0'], 0.001)
            pct  = 100 * st['pos'] / st['size']
            rate = st['pos'] / el
            eta  = (st['size'] - st['pos']) / rate if rate else 0
            print(f"\r{bar(pct)} {pct:5.1f}%  got {st['bytes']/1e6:7.1f} of "
                  f"{st['pos']/1e6:7.1f}/{st['size']/1e6:.1f} MB  "
                  f"{rate/1024/1024:5.1f} MB/s  eta {dur(eta)}   ", end='', flush=True)
            st['last'] = now

    elif ftype == 2:
        st['end_seq'], st['end_at'] = seq, time.time()
        print(f"\nEND seq={seq}  (settling 2s...)", flush=True)

def finish():
    st['done'] = True
    offs = sorted(out)
    blob = b''.join(out[k] for k in offs)
    open('/tmp/received.bin', 'wb').write(blob)
    el = max(st['end_at'] - st['t0'], 0.001)
    print(f"wrote {len(blob):,} of {st['size']:,} bytes in {dur(el)} "
          f"({len(blob)/el/1024/1024:.1f} MB/s)", flush=True)
    lost = sorted(set(range(1, st['end_seq'])) - seqs)
    print(f"data packets: expected {st['end_seq']-1:,}  received {len(seqs):,}  lost {len(lost):,}", flush=True)
    print("  COMPLETE" if not lost else f"  first lost: {lost[:5]} ...", flush=True)

client = YamcsClient('localhost:8090')
proc = client.get_processor(instance=instance, processor='realtime')
print('waiting... Ctrl-C to stop', flush=True)
proc.create_packet_subscription(on_data=on_packet)
while True:
    time.sleep(0.2)
    if st['end_at'] and not st['done'] and time.time() - st['end_at'] > 2:
        finish()