create table if not exists log.log
(
    id int not null
        primary key
);


DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS InsertLogEntry()
BEGIN
    DECLARE currentTimestamp INT;
    SET currentTimestamp = UNIX_TIMESTAMP();

    INSERT IGNORE INTO log (id)
    VALUES (FLOOR(currentTimestamp / 600) * 600);
END $$

DELIMITER ;


drop view if exists getLog;

create view getLog AS
select `q2`.`from` AS `from`, `q2`.`to` AS `to`
from (select
          `q`.`from`                                                      AS `from`,
          coalesce(`q`.`to`, lead(`q`.`to`, 1) over ( order by `q`.`id`)) AS `to`
      from (select `sub`.`id`    AS `id`,
                   `sub`.`from`  AS `from`,
                   `sub`.`to`    AS `to`
            from (select `main`.`idj`                                                                         AS `id`,
                         date_format(from_unixtime(`main`.`start`), '%d.%m. %H:%i (%a)')                                                        AS `from`,
                         if(unix_timestamp() - `main`.`end` < 700, 'running...', date_format(from_unixtime(`main`.`end`),'%d.%m. %H:%i (%a)')) AS `to`
                  from (select `l`.`id`                                         AS `idj`,
                               if(`sub`.`before` is null, `l`.`id`, NULL)       AS `start`,
                               if(`sub2`.`after` is null, `l`.`id` + 600, NULL) AS `end`
                        from ((`log`.`log` `l` left join (select `l_before`.`id` AS `before` from `log`.`log` `l_before`) `sub`
                               on (`l`.`id` - 600 = `sub`.`before`)) left join (select `l_after`.`id` AS `after` from `log`.`log` `l_after`) `sub2`
                              on (`l`.`id` + 600 = `sub2`.`after`))
                        order by `l`.`id`) `main`
                  where `main`.`start` <> 0
                     or `main`.`end` <> 0) `sub`) `q`) `q2`
where `q2`.`from` <> 0

