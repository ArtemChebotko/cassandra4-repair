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
 <a href='command:katapod.loadPage?[{"step":"intro"}]'
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 1 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step2"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Create schema and load data</div>

This lab requires a two-node cluster, that is being created for you.
The two Cassandra nodes run in Docker containers named `Cassandra-1` and `Cassandra-2`.
`Cassandra-1` belongs to datacenter `DC-West` and `Cassandra-2` belongs to datacenter `DC-East`.
The environment has two terminals, `Cassandra-1-terminal` and `Cassandra-2-terminal`, to connect and interact with the respective Cassandra nodes.


Wait until the terminals report that `Cassandra successfully started` and proceed.

✅ Verify that the cluster is up and running:
```
### cassandra1
docker exec -i -t Cassandra-1 nodetool status
```
```
### cassandra2
docker exec -i -t Cassandra-2 nodetool status
```

The output should list _two_ nodes, each in the `UN` (Up, Normal) status.

The following commands can be run on either node - we will work
on `Cassandra-1`. 

✅ Let's create a keyspace that replicates data to _both nodes_:
```
### cassandra1
docker exec -i -t Cassandra-1 cqlsh -e "
CREATE KEYSPACE IF NOT EXISTS chemistry
WITH replication = {
  'class': 'NetworkTopologyStrategy', 
  'DC-West': 1,
  'DC-East': 1 };"
```

✅ Create a table for storing the periodic table of elements:
```
### cassandra1
docker exec -i -t Cassandra-1 cqlsh -e "
CREATE TABLE chemistry.elements (
    symbol TEXT PRIMARY KEY,
    name TEXT,
    atomic_mass DECIMAL,
    atomic_number INT
);"
```

✅ Load data from the provided CSV file into the `elements` table:
```
### cassandra1
docker cp assets/elements.csv Cassandra-1:/tmp/elements.csv

docker exec -i -t Cassandra-1 cqlsh -e "
COPY chemistry.elements FROM '/tmp/elements.csv' WITH HEADER=true;"
```

✅ Query both `Cassandra-1` and `Cassandra-2` to verify that the data loading has succeeded:
```
### cassandra1
docker exec -i -t Cassandra-1 cqlsh -e "
CONSISTENCY LOCAL_ONE;
SELECT * FROM chemistry.elements LIMIT 10;
SELECT COUNT(*) FROM chemistry.elements;"
```
```
### cassandra2
docker exec -i -t Cassandra-2 cqlsh -e "
CONSISTENCY LOCAL_ONE;
SELECT * FROM chemistry.elements LIMIT 10;
SELECT COUNT(*) FROM chemistry.elements;"
```

To summarize, we have created a table and inserted about a hundred rows in it;
the table is replicated, in its entirety, on each of the two nodes
that form the cluster.

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"intro"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"step2"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
