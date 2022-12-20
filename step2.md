<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Repair Improvements</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:aleksandr.volochnev@datastax.com">email</a> or <a href="https://dtsx.io/aleks">LinkedIn</a>.</span> 
  </div>
</div>

<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a href='command:katapod.loadPage?[{"step":"step1"}]'
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 2 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step3"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Flush data to SSTables</div>

We are about to bring the cluster to the conditions that warrant a data
repair; but first, we have to make sure all recently-inserted rows, probably
still lingering in memory (in the memtables), are flushed to disk in the
form of SSTables.

✅ Flush data on both nodes:
```
### cassandra1
docker exec -i -t Cassandra-1 nodetool flush
```
```
### cassandra2
docker exec -i -t Cassandra-2 nodetool flush
```

✅ Inspect the data directory where SSTables are flushed:
```
### cassandra1
docker exec -i -t Cassandra-1 bash -c 'ls /var/lib/cassandra/data/chemistry/elements-*/'
```
```
### cassandra2
docker exec -i -t Cassandra-2 bash -c 'ls /var/lib/cassandra/data/chemistry/elements-*/'
```

You will now see the SSTable files. Notice the files named `*-Data.db`, which contain actual data.

✅ Examine SSTable metadata:
```
### cassandra1
docker exec -i -t Cassandra-1 bash -c '/opt/cassandra/tools/bin/sstablemetadata /var/lib/cassandra/data/chemistry/elements-*/*-Data.db'
```
```
### cassandra2
docker exec -i -t Cassandra-2 bash -c '/opt/cassandra/tools/bin/sstablemetadata /var/lib/cassandra/data/chemistry/elements-*/*-Data.db'
```

Look for the repair information in the output similar to this:

<pre class="non-executable-code">
...
Repaired at: 0
Pending repair: --
...
</pre>

These newly flushed SSTables have never been repaired yet,
and are not currently in the pending-repair pool of any running repair.

To summarize, we have forced a data flush to disk to make sure our SSTable files
are up-to-date; indeed the files are there and, as expected, have
never undergone any repair operation (...yet).

Now it's time to engineer a data misalignment between the two nodes,
to later see incremental repair in action!

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step1"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
