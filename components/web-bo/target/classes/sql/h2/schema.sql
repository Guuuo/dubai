drop table if exists dubai_task;
drop table if exists dubai_user;

create table dubai_user (
	id bigint generated by default as identity,
  login_name VARCHAR(64) NOT NULL unique,
  nice_name VARCHAR(64) DEFAULT '' NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL,
  salt VARCHAR(64) NOT NULL,
  roles VARCHAR(255) NOT NULL,
  register_date timestamp not null,
  status_code INT DEFAULT 0 NOT NULL,
  act_key VARCHAR(60) DEFAULT '' NOT NULL,
  act_key_gen_date timestamp not null,
  act_date timestamp not null,
	primary key (id)
);