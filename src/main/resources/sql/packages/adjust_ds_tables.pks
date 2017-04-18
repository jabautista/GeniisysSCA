CREATE OR REPLACE PACKAGE CPI.adjust_ds_tables
AS

PROCEDURE adjust_perilds (p_dist_no     giuw_wperilds.dist_no%TYPE);

PROCEDURE adjust_itemds (p_dist_no      giuw_witemds.dist_no%TYPE);

PROCEDURE adjust_policyds (p_dist_no    giuw_wpolicyds.dist_no%TYPE);

PROCEDURE adjust_dist_tables (p_dist_no    giuw_wpolicyds.dist_no%TYPE);

FUNCTION validate_dist_tables (p_dist_no    giuw_wpolicyds.dist_no%TYPE) RETURN BOOLEAN;

END adjust_ds_tables;
/


