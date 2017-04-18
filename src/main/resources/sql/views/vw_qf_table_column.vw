DROP VIEW CPI.VW_QF_TABLE_COLUMN;

/* Formatted on 2015/05/15 10:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.vw_qf_table_column (description,
                                                     query_id,
                                                     table_name,
                                                     column_name,
                                                     column_order,
                                                     datatype,
                                                     filter_type,
                                                     filter_value1,
                                                     filter_value2,
                                                     group_by,
                                                     math_operator,
                                                     order_asc_or_desc,
                                                     order_by,
                                                     order_by_order,
                                                     selected,
                                                     column_id
                                                    )
AS
   SELECT a.description, a.query_id, a.table_name, b.column_name,
          b.column_order, b.datatype, b.filter_type, b.filter_value1,
          b.filter_value2, b.group_by, b.math_operator, b.order_asc_or_desc,
          b.order_by, b.order_by_order, b.selected, b.column_id
     FROM qf_table a, qf_column b
    WHERE a.query_id = b.query_id;


