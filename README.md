Percona Ansible Role
====================
[![Build Status](https://travis-ci.org/MetaRed/percona_ansible_role.svg?branch=master)](https://travis-ci.org/MetaRed/percona_ansible_role)
[![License: Apache](https://img.shields.io/badge/License-Apache_2.0-red.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![Ansible Role: version](https://img.shields.io/badge/Ansible Role-v0.0.3-blue.svg)](https://github.com/MetaRed/percona_ansible_role/releases/tag/v0.0.3)


Ansible role installs percona xtradb, percona server, percona client, and percona toolkit.

#### Requirements: `None`
#### Dependencies: `None`

Role Variables
--------------

`Common`: used by percona server and percona xtradb task lists.
<table>
  <tr>
    <th>Common</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>{{ percona_version }}</tt></td>
    <td>percona server version</td>
    <td><tt>5.5</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_server_version_pin }}</tt></td>
    <td>percona server version pin</td>
    <td><tt>5.5.53-rel38.5-1.trusty</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_xtradb_version_pin }}</tt></td>
    <td>percona xtradb version pin</td>
    <td><tt>5.5.41-25.12-855.trusty</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_db_user }}</tt></td>
    <td>percona system user</td>
    <td><tt>mysql</tt></td>
  </tr>
  <tr>
    <td><tt>{{ default_storage_engine }}</tt></td>
    <td>database storage engine</td>
    <td><tt>InnoDB</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_data_dir }}</tt></td>
    <td>database data directory</td>
    <td><tt>/data/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_log_dir }}</tt></td>
    <td>info log directory</td>
    <td><tt>/var/log/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_error_log }}</tt></td>
    <td>error log file</td>
    <td><tt>/var/log/mysql/mysql-error.log</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_slow_log }}</tt></td>
    <td>slow log file</td>
    <td><tt>/var/log/mysql/mysql-slow.log</tt></td>
  </tr>
  </table>

`Server`: used exclusively by percona server tasks.
<table>
  <tr>
    <th>Server</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>{{ percona_innodb_buffer_pool_size }}</tt></td>
    <td>innodb buffer pool size</td>
    <td><tt>1G</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_mysql_read_only }}</tt></td>
    <td>slave read only mode</td>
    <td><tt>FALSE</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_server_sync_binlog }}</tt></td>
    <td>whether to sync binary logs</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_mysql_server_id }}</tt></td>
    <td>unique db identifier</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_bin_log_dir }}</tt></td>
    <td>binary log directory</td>
    <td><tt>/log/data/mysql</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_bin_log }}</tt></td>
    <td>binary log file</td>
    <td><tt>/log/data/mysql/mysql-bin</tt></td>
  </tr>
  <tr>
    <td><tt>{{ percona_relay_log }}</tt></td>
    <td>relay log file</td>
    <td><tt>/log/data/mysql/mysql-relay-log</tt></td>
  </tr>
</table>

`xtradb`: used exclusively by percona xtradb tasks.
<table>
<tr>
  <th>xtradb</th>
  <th>Description</th>
  <th>Default</th>
</tr>
<tr>
  <td><tt>{{ percona_wsrep_sst_auth }}</tt></td>
  <td>cluster node credentials</td>
  <td><tt>test_user:test_pass</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_binlog_format }}</tt></td>
  <td>binary log format</td>
  <td><tt>ROW</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_locks_unsafe_for_binlog }}</tt></td>
  <td>disable gap locking</td>
  <td><tt>1</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_autoinc_lock_mode }}</tt></td>
  <td>innodb increment lock mode</td>
  <td><tt>2</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_wsrep_sst_method }}</tt></td>
  <td>galera state transfer type</td>
  <td><tt>xtrabackup</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_wsrep_cluster_name }}</tt></td>
  <td>galera cluster name</td>
  <td><tt>Yo_Cluster_Rox</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_tmp_table_size }}</tt></td>
  <td>temporary table size</td>
  <td><tt>32M</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_max_heap_table_size }}</tt></td>
  <td>heap memory size limit</td>
  <td><tt>32M</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_query_cache_type }}</tt></td>
  <td>use query caching</td>
  <td><tt>OFF</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_query_cache_size }}</tt></td>
  <td>query cache size</td>
  <td><tt>0</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_max_connections }}</tt></td>
  <td>database connection limit</td>
  <td><tt>2000</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_thread_cache_size }}</tt></td>
  <td>thread cache size</td>
  <td><tt>100</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_open_files_limit }}</tt></td>
  <td>database open file limit</td>
  <td><tt>65535</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_table_definition_cache }}</tt></td>
  <td>table cache size</td>
  <td><tt>4096</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_table_open_cache }}</tt></td>
  <td>open table number for all database threads</td>
  <td><tt>4096</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_flush_method }}</tt></td>
  <td>innodb flush method</td>
  <td><tt>O_DIRECT</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_log_files_in_group }}</tt></td>
  <td>xtradb log files in group</td>
  <td><tt>2</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_flush_log_at_trx_commit }}</tt></td>
  <td>transaction log flush setting</td>
  <td><tt>2</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_file_per_table }}</tt></td>
  <td>db file per table setting</td>
  <td><tt>ON</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_buffer_pool_size }}</tt></td>
  <td>buffer pool size</td>
  <td><tt>128M</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_log_queries_not_using_indexes }}</tt></td>
  <td>log queries not using indexes</td>
  <td><tt>1</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_slow_query_log }}</tt></td>
  <td>slow query log setting</td>
  <td><tt>1</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_transaction_isolation }}</tt></td>
  <td>transaction isolation level</td>
  <td><tt>READ-COMMITTED</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_read_io_threads }}</tt></td>
  <td>read io thread count</td>
  <td><tt>64</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_write_io_threads }}</tt></td>
  <td>write io thread count</td>
  <td><tt>64</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_wsrep_slave_threads }}</tt></td>
  <td>galera replication thread count</td>
  <td><tt>64</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_io_capacity }}</tt></td>
  <td>io operations limit</td>
  <td><tt>2000</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_flush_neighbor_pages }}</tt></td>
  <td>sequential page flush setting</td>
  <td><tt>cont</tt></td>
</tr>
<tr>
  <td><tt>{{ percona_innodb_log_file_size }}</tt></td>
  <td>transaction log file size</td>
  <td><tt>4G</tt></td>
</tr>
<tr>
</table>

Galaxy Playbook Usage
---------------------
```yaml

    - hosts: servers
      roles:
         - { role: MetaRed.percona, variable: value }
```


#### Tags
`percona`: Run both percona server and percona xtradb task lists.

`percona-server`: Run only percona server tasks.

`percona-xtradb`: Run only percona xtradb tasks.

```bash

ansible-playbook site.yml --tags=percona

```


Testing
-------

`ServerSpec`: Integration test directories


```

test/integration/percona_server
test/integration/percona_xtradb
```

Authors
-------

Authors: Richard Lopez
