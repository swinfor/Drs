
create sequence seq_log_messages nocache ;
create sequence seq_services nocache ;
create sequence seq_servers nocache ;

CREATE TABLE ALLOWED_SERVERS(
	service_name varchar2(50) NULL,
	server_name varchar2(100) NOT NULL,
	ip_address varchar(30) not null,
	status char(1) DEFAULT 'A',
	WHO varchar2(20) NULL,
	UPDATE_DATE timestamp NULL,
 CONSTRAINT allowed_servers_pk PRIMARY KEY  
(
	service_name,
	server_name  
)
) 
;

CREATE TABLE DATABASES(
	DATABASE_NAME varchar2(20) NOT NULL,
	server_name varchar2(100) NOT NULL,
	DATABASE_TYPE NUMBER(1) DEFAULT 1,
	STATUS char(1) DEFAULT 'A',
	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL,
 CONSTRAINT DATABASES_pk PRIMARY KEY  
(
	DATABASE_NAME  ,
	server_name  
)
) 
;
CREATE TABLE SERVERS(
	server_name varchar2(100) NULL,
	server_type char(1) NULL,
	id number(6) not null,
	ip_address	varchar2(15),
    max_pool_size number(3),
	status char(1) DEFAULT 'A',
	WHO varchar2(20) NULL,
	UPDATE_DATE timestamp NULL,
 CONSTRAINT SERVERS_pk PRIMARY KEY  
(
	server_name  
)
) 
;
CREATE TABLE LOG_MESSAGES(
	id number(10) NOT NULL,
	MSG_DATE timestamp NULL,
	MSG_TYPE varchar2(15) NULL,
	MODULE_NAME varchar2(20) NULL,
	MSG_TEXT varchar2(2000) NULL,
 CONSTRAINT MESSAGES_pk PRIMARY KEY  
(
	ID  
)
) 
;
CREATE TABLE SERVICES(
	SERVICE_NAME varchar2(50) NOT NULL,
	ID NUMBER(5) not null,
	DESCRIPTION varchar2(500) not NULL,
	SERVER_NAME varchar2(100) not NULL,
	DATABASE_NAME varchar2(20) NULL,
	SERVICE_TYPE char(1) NOT NULL,
	DESTINATION varchar2(4000) not NULL,
	AVG_RESPONSE_TIME_ALERT number(7,4) default 0,
	MAX_RESPONSE_TIME_ALERT number(7,4) default 0,
	ROLE_NAME varchar2(30) null,
	SECURITY_ENABLED char(1) DEFAULT 'Y',
	RETURN_DATA_ONLY char(1) DEFAULT 'N',
	PARAMETER_TYPE char(1) DEFAULT 'H',
	ROWS_PER_REQUEST numeric(6) DEFAULT 0,
	STORED_STATISTICS CHAR(1) DEFAULT 'Y' not null,
	UPDATE_DATE timestamp NULL,
	STATUS char(1) DEFAULT 'A',
	WHO varchar2(20) NULL,
 CONSTRAINT services_pk PRIMARY KEY  
(
	SERVICE_NAME  
)
) 
;
CREATE TABLE SERVICES_PARAMETERS(
	SERVICE_NAME varchar2(50) NOT NULL,
	SEQUENCE_NUMBER number(4) NULL,
	PARAMETER_NAME varchar2(20) NULL,
	PARAMETER_DISPLAY varchar2(40) NULL,
	REQUIRED CHAR(1) DEFAULT 'Y',
	EDIT char(1) DEFAULT 'A',
	LENGTH number(5) DEFAULT 0,
	DECIMALS number(5) DEFAULT 0,
	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL,
 CONSTRAINT services_parameters_pk PRIMARY KEY  
(
	SERVICE_NAME ,
	SEQUENCE_NUMBER	
)
) 
;
CREATE TABLE USERS(
	USER_ID varchar2(20) NOT NULL,
	NAME varchar2(40) NULL,
	EMAIL varchar2(100) NULL,
	TYPE_ADMIN number(1) NULL,
	TYPE_BASIC number(1) NULL,
	TYPE_SUPERUSER number(1) NULL,
	TYPE_OPERATOR number(1) NULL,
	TYPE_SUPPORT number(1) NULL,
	TYPE_QUERY number(1) NULL,
	PASSWORD varchar2(40) NULL,
	LAST_ACCESS_DATE timestamp NULL,
	LAST_ACCESS_IP varchar2(20) NULL,
	STATUS char(1) DEFAULT 'A',
	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL,
 CONSTRAINT users_pk PRIMARY KEY  
(
	USER_ID  
)
) 
;

create table ROLES (
	ROLE_NAME varchar2(30) not null,
	DESCRIPTION varchar2(500) NULL,
	STATUS char(1) DEFAULT 'A',
 	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL,
 CONSTRAINT roles_pk PRIMARY KEY  
(
	ROLE_NAME  
)
) 
;

create table ROLES_USERS (
	ROLE_NAME varchar2(30) not null,
	SERVER_NAME varchar2(100) not NULL, 	
	USER_NAME varchar2(50) not null,
	STATUS char(1) DEFAULT 'A',
 	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL,
 CONSTRAINT roles_users_pk PRIMARY KEY  
(
	ROLE_NAME,
	SERVER_NAME,
	USER_NAME
)
) 
;

create table PARAMETERS (
    ID number(1) not null,
	ADMIN_PORT_NUMBER NUMBER(6) DEFAULT 6010 not null ,
	ADMIN_SERVER_NAME VARCHAR2(100) ,
	STATISTICS_SUMMARY_INTERVAL NUMBER(2) DEFAULT 60 not NULL , 	
	STORED_STATISTICS CHAR(1) DEFAULT 'Y' not null ,
	STATISTICS_FOLDER varchar(100) Default '',
	MAXIMUM_CONNECTION_POOL number(3) default 20,
	MAXIMUM_CONNECTION_TIMEOUT number(3) default 5,
	MAXIMUM_EXECUTION_TIMEOUT number(3) default 1,
	UPDATE_DATE timestamp NULL,
	WHO varchar2(20) NULL
) 
;

create table STATISTICS (
	ID NUMBER(5) not null,
	SERVER_ID number(6) , 
	APPLICATION_SERVER_ID number(6) , 
	STATISTICS_DATE TIMESTAMP NOT NULL, 
	NUMBER_OF_TRANSACTIONS  NUMBER(10),
	AVG_RESPONSE_TIME number(7,4) default 0,
	MAX_RESPONSE_TIME number(7,4) default 0,
	ERRORS number(10) default 0
);
CREATE INDEX STATISTICS_I1 ON STATISTICS (
	ID,
	STATISTICS_DATE
);

create or replace TRIGGER t_log_messages BEFORE INSERT ON log_messages FOR EACH ROW 
BEGIN
     if inserting and :new.id is null then
         SELECT SEQ_LOG_MESSAGES.NEXTVAL INTO :NEW.id FROM DUAL;
     end if;
    :NEW.MSG_DATE:=SYSTIMESTAMP;
END;
/
create or replace TRIGGER t_services BEFORE UPDATE OR INSERT ON services FOR EACH ROW 
BEGIN
    if inserting and ( :new.id is null or :new.id = 0 ) then
	SELECT SEQ_SERVICES.NEXTVAL INTO :NEW.id FROM DUAL;
    end if;
    :NEW.UPDATE_DATE:=SYSTIMESTAMP;
END;
/

create or replace TRIGGER t_servers BEFORE UPDATE OR INSERT ON servers FOR EACH ROW 
BEGIN
    if inserting and :new.id is null then
	SELECT SEQ_SERVERS.NEXTVAL INTO :NEW.id FROM DUAL;
    end if;
    :NEW.UPDATE_DATE:=SYSTIMESTAMP;
END;
/


insert into users (
USER_ID
,NAME
,EMAIL
,LAST_ACCESS_DATE
,LAST_ACCESS_IP
,UPDATE_DATE
,STATUS
,WHO
,TYPE_BASIC
,TYPE_SUPERUSER
,TYPE_OPERATOR
,TYPE_SUPPORT
,TYPE_QUERY
,PASSWORD
) values ( 
'ADMIN'
,'ADMINISTRATOR'
,''
,null
,null
,systimestamp
,'A'
,null
,1
,1
,1
,1
,1
,'pw8rl+hGG2IU6EJke2y4nQ=='
)
;

INSERT INTO PARAMETERS (
    ID,
	ADMIN_PORT_NUMBER ,
	STATISTICS_SUMMARY_INTERVAL , 	
	STORED_STATISTICS, 
	MAXIMUM_CONNECTION_POOL,
	MAXIMUM_CONNECTION_TIMEOUT,
	MAXIMUM_EXECUTION_TIMEOUT,
 	UPDATE_DATE ,
	WHO 
) VALUES (
1,
6010,
60,
'N',
1,
20,
5,
systimestamp,
'ADMIN'
);


commit;


--CREATE UNIQUE NON INDEX environments_hostnames_i1 ON environments_hostnames
--(
--	environment ASC,
--	host_name ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
--;

CREATE  INDEX LOG_MESSAGES_i1 ON LOG_MESSAGES
(
	MSG_DATE ASC
)
;
CREATE  INDEX LOG_MESSAGES_i2 ON LOG_MESSAGES
(
	MSG_TYPE ASC,
	MSG_DATE ASC
)
;
CREATE UNIQUE INDEX SERVICES_i2 ON SERVICES
(
	ID
)
;

ALTER TABLE DATABASES ADD  CONSTRAINT databases_fk FOREIGN KEY(SERVER_NAME)
REFERENCES servers (server_name)
;
ALTER TABLE ALLOWED_SERVERS ADD  CONSTRAINT allowed_servers_fk FOREIGN KEY(SERVER_NAME)
REFERENCES servers (server_name)
;
ALTER TABLE ROLES_USERS  ADD  CONSTRAINT role_names_fk1 FOREIGN KEY(ROLE_NAME)
REFERENCES ROLES (role_name)
;
ALTER TABLE SERVICES  ADD  CONSTRAINT services_fk1 FOREIGN KEY(SERVER_NAME)
REFERENCES SERVERS (server_name)
;
ALTER TABLE SERVICES  ADD  CONSTRAINT services_fk2 FOREIGN KEY(DATABASE_NAME, SERVER_NAME)
REFERENCES DATABASES (DATABASE_NAME, SERVER_NAME)
;
ALTER TABLE SERVICES_PARAMETERS  ADD  CONSTRAINT services_parameters_fk1 FOREIGN KEY(SERVICE_NAME)
REFERENCES SERVICES (SERVICE_NAME)
;


ALTER TABLE DATABASES ADD  CONSTRAINT databases_chk_status CHECK  ((status='A' OR status='S' OR status='D'))
;
ALTER TABLE ROLES  ADD  CONSTRAINT roles_chk_status CHECK  ((status='A' OR status='S' OR status='D'))
;
ALTER TABLE SERVERS  ADD  CONSTRAINT servers_chk_status CHECK  ((status='A' OR status='S' OR status='D'))
;
ALTER TABLE SERVERS  ADD  CONSTRAINT servers_chk_server_type CHECK  ((server_type='M' OR server_type='E' OR server_type='S' OR server_type='A'))
;
ALTER TABLE SERVICES  ADD  CONSTRAINT services_chk_status CHECK  ((status='A' OR status='S' OR status='D'))
;
ALTER TABLE USERS  ADD  CONSTRAINT users_chk_status CHECK  ((status='A' OR status='S' OR status='D'))
;
ALTER TABLE LOG_MESSAGES  ADD  CONSTRAINT MESSAGES_chk_status CHECK  ((MSG_TYPE='ERROR' OR MSG_TYPE='INFORMATION' OR MSG_TYPE='SUCCESS' OR MSG_TYPE='WARNING'))
;

