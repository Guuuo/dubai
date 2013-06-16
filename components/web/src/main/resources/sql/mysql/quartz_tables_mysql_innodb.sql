#
# in your quartz properties file, you'll need to set 
# org.quartz.jobstore.driverdelegateclass = org.quartz.impl.jdbcjobstore.stdjdbcdelegate
#
#
# by: ron cordell - roncordell
#  i didn't see this anywhere, so i thought i'd post it here. this is the script from quartz to create the tables in a mysql database, modified to use innodb instead of myisam.

drop table if exists qrtz_job_listeners;
drop table if exists qrtz_trigger_listeners;
drop table if exists qrtz_fired_triggers;
drop table if exists qrtz_paused_trigger_grps;
drop table if exists qrtz_scheduler_state;
drop table if exists qrtz_locks;
drop table if exists qrtz_simple_triggers;
drop table if exists qrtz_cron_triggers;
drop table if exists qrtz_blob_triggers;
drop table if exists qrtz_triggers;
drop table if exists qrtz_job_details;
drop table if exists qrtz_calendars;

create table qrtz_job_details(
job_name varchar(200) not null,
job_group varchar(200) not null,
description varchar(250) null,
job_class_name varchar(250) not null,
is_durable varchar(1) not null,
is_volatile varchar(1) not null,
is_stateful varchar(1) not null,
requests_recovery varchar(1) not null,
job_data blob null,
primary key (job_name,job_group))
engine=innodb;

create table qrtz_job_listeners (
job_name varchar(200) not null,
job_group varchar(200) not null,
job_listener varchar(200) not null,
primary key (job_name,job_group,job_listener),
index (job_name, job_group),
foreign key (job_name,job_group)
references qrtz_job_details(job_name,job_group))
engine=innodb;

create table qrtz_triggers (
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
job_name varchar(200) not null,
job_group varchar(200) not null,
is_volatile varchar(1) not null,
description varchar(250) null,
next_fire_time bigint(13) null,
prev_fire_time bigint(13) null,
priority integer null,
trigger_state varchar(16) not null,
trigger_type varchar(8) not null,
start_time bigint(13) not null,
end_time bigint(13) null,
calendar_name varchar(200) null,
misfire_instr smallint(2) null,
job_data blob null,
primary key (trigger_name,trigger_group),
index (job_name, job_group),
foreign key (job_name,job_group)
references qrtz_job_details(job_name,job_group))
engine=innodb;

create table qrtz_simple_triggers (
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
repeat_count bigint(7) not null,
repeat_interval bigint(12) not null,
times_triggered bigint(10) not null,
primary key (trigger_name,trigger_group),
index (trigger_name, trigger_group),
foreign key (trigger_name,trigger_group)
references qrtz_triggers(trigger_name,trigger_group))
engine=innodb;

create table qrtz_cron_triggers (
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
cron_expression varchar(120) not null,
time_zone_id varchar(80),
primary key (trigger_name,trigger_group),
index (trigger_name, trigger_group),
foreign key (trigger_name,trigger_group)
references qrtz_triggers(trigger_name,trigger_group))
engine=innodb;

create table qrtz_blob_triggers (
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
blob_data blob null,
primary key (trigger_name,trigger_group),
index (trigger_name, trigger_group),
foreign key (trigger_name,trigger_group)
references qrtz_triggers(trigger_name,trigger_group))
engine=innodb;

create table qrtz_trigger_listeners (
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
trigger_listener varchar(200) not null,
primary key (trigger_name,trigger_group,trigger_listener),
index (trigger_name, trigger_group),
foreign key (trigger_name,trigger_group)
references qrtz_triggers(trigger_name,trigger_group))
engine=innodb;

create table qrtz_calendars (
calendar_name varchar(200) not null,
calendar blob not null,
primary key (calendar_name))
engine=innodb;

create table qrtz_paused_trigger_grps (
trigger_group varchar(200) not null,
primary key (trigger_group))
engine=innodb;

create table qrtz_fired_triggers (
entry_id varchar(95) not null,
trigger_name varchar(200) not null,
trigger_group varchar(200) not null,
is_volatile varchar(1) not null,
instance_name varchar(200) not null,
fired_time bigint(13) not null,
priority integer not null,
state varchar(16) not null,
job_name varchar(200) null,
job_group varchar(200) null,
is_stateful varchar(1) null,
requests_recovery varchar(1) null,
primary key (entry_id))
engine=innodb;

create table qrtz_scheduler_state (
instance_name varchar(200) not null,
last_checkin_time bigint(13) not null,
checkin_interval bigint(13) not null,
primary key (instance_name))
engine=innodb;

create table qrtz_locks (
lock_name varchar(40) not null,
primary key (lock_name))
engine=innodb;

insert into qrtz_locks values('trigger_access');
insert into qrtz_locks values('job_access');
insert into qrtz_locks values('calendar_access');
insert into qrtz_locks values('state_access');
insert into qrtz_locks values('misfire_access');
commit; 
