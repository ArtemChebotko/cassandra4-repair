<!-- TOP -->
<div class="top">
  <img class="scenario-academy-logo" src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-2023.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Repair Improvements</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:aleksandr.volochnev@datastax.com">email</a> or <a href="https://dtsx.io/aleks">LinkedIn</a>.</span> 
  </div>
</div>

<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a href='command:katapod.loadPage?[{"step":"step2"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 3 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step4"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Create data inconsistency</div>

We will now perform some changes on the data (namely, deleting most rows)
with one of the two nodes turned off: the goal is to artificially create
a mismatch in the data. But beware: we have to also neutralize the
_hinted handoff_ mechanism to actually achieve data inconsistency.

✅ Bring the `Cassandra-2` node down:
```
### cassandra2
docker exec -i -t Cassandra-2 nodetool stopdaemon
```

✅ When the `Cassandra-2` node is completely offline, it will have a status of `DN` (Down, Normal)
as reported by `nodetool`:
```
### cassandra1
docker exec -i -t Cassandra-1 nodetool status
```

At this point, the cluster should have a single node up - it will still be able
to accept requests, since we will be using consistency level `LOCAL_ONE` for subsequent writes and reads.

✅ Delete all chemical elements that are _not_ a gas using the provided CQL script:
```
### cassandra1
docker cp assets/delete_nongases.cql Cassandra-1:/tmp/delete_nongases.cql

docker exec -i -t Cassandra-1 cqlsh -f /tmp/delete_nongases.cql
```

✅ See which elements are now left in the table:
```
### cassandra1
docker exec -i -t Cassandra-1 cqlsh -e "
CONSISTENCY LOCAL_ONE;
SELECT * FROM chemistry.elements;"
```

But wait! Cassandra tries hard to maintain data consistency; so,
while the rows were being deleted, the `Cassandra-1` node noticed it could not propagate
the tombstones to `Cassandra-2` and saved them all in a "hints" file, ready for
when `Cassandra-2` will be reachable again. If we want to really induce a data mismatch,
we have to delete the hints as well.

**Important note:** We are intentionally engineering a disruption in
SSTable consistency between the two nodes for demonstration purposes.
Manually tinkering with the contents of the data directories, and in particular
deleting files contained therein, is a very unwise action on a production
cluster (unless one knows very well what they are doing). DO NOT DO THIS
IN PRODUCTION as permanent data loss may ensue!

✅ Remove all hints stored by `Cassandra-1`:
```
### cassandra1
docker exec -i -t Cassandra-1 bash -c 'rm /var/lib/cassandra/hints/*.hints'
```

✅ Bring the `Cassandra-2` node back up:
```
### cassandra2
docker start Cassandra-2
docker exec -i -t Cassandra-2 bash -c 'cassandra -R'
```

Wait until Cassandra successfully started.

✅ Verify that both nodes are up and running:
```
### cassandra1
docker exec -i -t Cassandra-1 nodetool status
```

✅ Query both `Cassandra-1` and `Cassandra-2` to check if row counts match:
```
### cassandra1
docker exec -i -t Cassandra-1 cqlsh -e "
CONSISTENCY LOCAL_ONE;
SELECT COUNT(*) FROM chemistry.elements;"
```
```
### cassandra2
docker exec -i -t Cassandra-2 cqlsh -e "
CONSISTENCY LOCAL_ONE;
SELECT COUNT(*) FROM chemistry.elements;"
```

The resulting counts should be `10` and `112`, which confirms that there is a data inconsistency problem.

To summarize, we have applied some mutations to the data on a table with one node
down (and taken extra care to prevent other Cassandra self-healing mechanisms).
At this point the SSTables on the two nodes are in disagreement: `Cassandra-1`
"thinks" there are `10` rows, but `Cassandra-2` still "thinks" there are `112` rows.
It is time to perform a repair!

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step2"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"step4"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
