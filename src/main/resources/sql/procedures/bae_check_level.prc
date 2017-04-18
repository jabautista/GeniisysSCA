DROP PROCEDURE CPI.BAE_CHECK_LEVEL;

CREATE OR REPLACE PROCEDURE CPI.BAE_check_level
(g_level      IN     NUMBER,
 g_value      IN     NUMBER,
 g_sub_acct_1 IN OUT NUMBER,
  g_sub_acct_2 IN OUT NUMBER,
 g_sub_acct_3 IN OUT NUMBER,
 g_sub_acct_4 IN OUT NUMBER,
 g_sub_acct_5 IN OUT NUMBER,
 g_sub_acct_6 IN OUT NUMBER,
 g_sub_acct_7 IN OUT NUMBER) IS
BEGIN
  IF g_level = 0 THEN
    null;
  ELSIF g_level = 1 THEN
    g_sub_acct_1  := g_value ;
  ELSIF g_level = 2 THEN
    g_sub_acct_2  := g_value ;
  ELSIF g_level = 3 THEN
    g_sub_acct_3  := g_value ;
  ELSIF g_level = 4 THEN
    g_sub_acct_4  := g_value ;
  ELSIF g_level = 5 THEN
    g_sub_acct_5  := g_value ;
  ELSIF g_level = 6 THEN
    g_sub_acct_6  := g_value ;
  ELSIF g_level = 7 THEN
    g_sub_acct_7  := g_value ;
  END IF;
END;
/


