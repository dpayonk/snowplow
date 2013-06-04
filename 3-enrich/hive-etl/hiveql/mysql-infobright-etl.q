-- Copyright (c) 2012-2013 SnowPlow Analytics Ltd. All rights reserved.
--
-- This program is licensed to you under the Apache License Version 2.0,
-- and you may not use this file except in compliance with the Apache License Version 2.0.
-- You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the Apache License Version 2.0 is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
--
-- Version:     0.0.8
-- URL:         s3://snowplow-emr-assets/hive/hiveql/mysql-infobright-etl-0.0.8.q
--
-- Authors:     Yali Sassoon, Alex Dean
-- Copyright:   Copyright (c) 2012-2013 SnowPlow Analytics Ltd
-- License:     Apache License Version 2.0

SET hive.exec.dynamic.partition=true ;
SET hive.exec.dynamic.partition.mode=nonstrict ;

ADD JAR ${SERDE_FILE} ;

CREATE EXTERNAL TABLE `extracted_logs`
ROW FORMAT SERDE 'com.snowplowanalytics.snowplow.hadoop.hive.SnowPlowEventDeserializer'
WITH SERDEPROPERTIES ('continue_on_unexpected_error' = '${CONTINUE_ON}')
LOCATION '${CLOUDFRONT_LOGS}' ;

CREATE EXTERNAL TABLE IF NOT EXISTS `events` (
app_id string,
platform string,
collector_dt string,
collector_tm string,
dvce_dt string,
dvce_tm string,
dvce_epoch bigint,
event string,
event_vendor string,
event_id string,
txn_id string,
v_tracker string,
v_collector string,
v_etl string,
user_id string,
user_ipaddress string,
user_fingerprint string,
domain_userid string,
domain_sessionidx int,
network_userid string,
page_url string,
page_title string,
page_referrer string,
page_urlscheme string,
page_urlhost string,
page_urlport int,
page_urlpath string,
page_urlquery string,
page_urlfragment string,
mkt_source string,
mkt_medium string,
mkt_term string,
mkt_content string,
mkt_campaign string,
ev_category string,
ev_action string,
ev_label string,
ev_property string,
ev_value string,
tr_orderid string,
tr_affiliation string,
tr_total string,
tr_tax string,
tr_shipping string,
tr_city string,
tr_state string,
tr_country string,
ti_orderid string,
ti_sku string,
ti_name string,
ti_category string,
ti_price string,
ti_quantity string,
pp_xoffset_min int,
pp_xoffset_max int,
pp_yoffset_min int,
pp_yoffset_max int,
useragent string,
br_name string,
br_family string,
br_version string,
br_type string,
br_renderengine string,
br_lang string,
br_features_pdf tinyint,
br_features_flash tinyint,
br_features_java tinyint,
br_features_director tinyint,
br_features_quicktime tinyint,
br_features_realplayer tinyint,
br_features_windowsmedia tinyint,
br_features_gears tinyint,
br_features_silverlight tinyint,
br_cookies tinyint,
br_colordepth string,
br_viewwidth int,
br_viewheight int,
os_name string,
os_family string,
os_manufacturer string,
os_timezone string,
dvce_type string,
dvce_ismobile tinyint,
dvce_screenwidth int,
dvce_screenheight int,
doc_charset string,
doc_width int,
doc_height int
)
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '${EVENTS_TABLE}' ;

ALTER TABLE `events` RECOVER PARTITIONS ;

INSERT INTO TABLE `events`
PARTITION (dt)
SELECT
app_id,
platform,
collector_dt,
collector_tm,
dvce_dt,
dvce_tm,
dvce_epoch,
event,
event_vendor,
event_id,
txn_id,
v_tracker,
'${COLLECTOR_FORMAT}' AS v_collector,
v_etl,
user_id,
user_ipaddress,
user_fingerprint,
domain_userid,
domain_sessionidx,
network_userid,
page_url,
page_title,
page_referrer,
page_urlscheme,
page_urlhost,
page_urlport,
page_urlpath,
page_urlquery,
page_urlfragment,
mkt_source,
mkt_medium,
mkt_term,
mkt_content,
mkt_campaign,
ev_category,
ev_action,
ev_label,
ev_property,
ev_value,
tr_orderid,
tr_affiliation,
tr_total,
tr_tax,
tr_shipping,
tr_city,
tr_state,
tr_country,
ti_orderid,
ti_sku,
ti_name,
ti_category,
ti_price,
ti_quantity,
pp_xoffset_min,
pp_xoffset_max,
pp_yoffset_min,
pp_yoffset_max,
useragent,
br_name,
br_family,
br_version,
br_type,
br_renderengine,
br_lang,
br_features_pdf,
br_features_flash,
br_features_java,
br_features_director,
br_features_quicktime,
br_features_realplayer,
br_features_windowsmedia,
br_features_gears,
br_features_silverlight,
br_cookies_bt AS br_cookies,
br_colordepth,
br_viewwidth,
br_viewheight,
os_name,
os_family,
os_manufacturer,
os_timezone,
dvce_type,
dvce_ismobile_bt AS dvce_ismobile,
dvce_screenwidth,
dvce_screenheight,
doc_charset,
doc_width,
doc_height,
dt
FROM `extracted_logs` ;