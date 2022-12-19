<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Full Query Logging</span>
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

<div class="step-title">Enable full query logging via nodetool</div>

In this step, you will enable full query logging via `nodetool`.

We've already started a single node Cassandra cluster for you in the background. When the command prompt appears in the terminal, the node is initialized and ready to go.

✅ First, let's create a directory to store our full query log files:
```
mkdir /tmp/fqllogs
```

✅ Now you can connect to the node using `nodetool` and enable full query logging, using the directory we just created as the path:
```
nodetool enablefullquerylog --path /tmp/fqllogs
```

✅ To get a listing of the other options available on this command, execute the following:
```
nodetool help enablefullquerylog
```

In this step, you enabled full query logging dynamically on a running Cassandra node using `nodetool` and learned about the available options on the `enablefullquerylog` command.

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"intro"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"step2"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
