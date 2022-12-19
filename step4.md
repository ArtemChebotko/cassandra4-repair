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
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 4 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"finish"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Configure full query logging via cassandra.yaml</div>

Previously, you enabled full query logging for a Cassandra node using `nodetool`, but the logging will not remain enabled when the node is restarted unless you edit the `cassandra.yaml` file. In this step, you will learn how to configure some of the properties full query logging. 

✅ Open the `cassandra.yaml` file in the editor:
```
nano $HOME/apache-cassandra/conf/cassandra.yaml
```

✅ Find the line that contains `#full_query_logging_options:` and uncomment it and following lines with related configuration properties. Change `log_dir` to point to the `/tmp/fqllogs` directory. Your edited file may look like this:

<pre class="non-executable-code">
full_query_logging_options:
    log_dir: /tmp/fqllogs
    roll_cycle: HOURLY
    block: true
    max_queue_weight: 268435456 # 256 MiB
    max_log_size: 17179869184 # 16 GiB
    ## archive command is "/path/to/script.sh %path" where %path is replaced with the file being rolled:
    # archive_command:
    # max_archive_retries: 10
</pre>

Here are the configurable properties for full query logging:

- `log_dir`: Enable full query logging by setting this property to an existing directory location.
- `roll_cycle`: Sets the frequency at which log segments are rolled - DAILY, HOURLY (the default), or MINUTELY.
- `block`: Determines whether writes to the full query log will block query completion if full query logging falls behind, defaults to true.
- `max_queue_weight`: Sets the maximum size of the in-memory queue of full query logs to be written to disk before blocking occurs, defaults to 256 MiB. 
- `max_log_size`: Sets the maximum size of full query log files on disk (default 16 GiB). After this value is exceeded, the oldest log file will be deleted.
- `archive_command`: Optionally, provides a command that will be used to archive full query log files before deletion.
- `max_archive_retries`: Sets a maximum number of times a failed archive command will be retried (defaults to 10).

For the new configuration settings in `cassandra.yaml` to take effect, you will need to save the file and restart Cassandra.

In this step, you learned how to enable full query logging in the `cassandra.yaml` file and explored the configurable properties of full query logging. 

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"finish"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>

