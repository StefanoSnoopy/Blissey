-- settings
select @period := concat(date(now() - interval 15 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 15 minute)) DIV 900) * 900));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 900) * 900));
select @rpl  := 15;

-- process data
insert ignore into stats_worker (datetime,rpl,controller_worker,device_worker,numRep,loc_time,loc_count,loc_success,mons_seen,mons_enc)
select
@period,
@rpl,
controller_worker,
max(device_worker),
sum(numRep),
sum(loc_time),
sum(loc_count),
sum(loc_success),
sum(mons_seen),
sum(mons_enc)

from stats_worker

where
datetime >= @period and
datetime < @stop and
rpl = 5

group by controller_worker
;
