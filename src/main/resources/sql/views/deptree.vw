DROP VIEW CPI.DEPTREE;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.deptree (nested_level,
                                          TYPE,
                                          "SCHEMA",
                                          NAME,
                                          seq#
                                         )
AS
   SELECT d.nest_level, o.object_type, o.owner, o.object_name, d.seq#
     FROM deptree_temptab d, all_objects o
    WHERE d.object_id = o.object_id(+);


