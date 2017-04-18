DROP FUNCTION CPI.SET_EXIST_MSG_PACK;

CREATE OR REPLACE FUNCTION CPI.set_exist_msg_pack (
   p_line_cd   gipi_pack_quote.line_cd%TYPE,
   p_assd_no   gipi_pack_quote.assd_no%TYPE
)
   RETURN VARCHAR2
IS
/******************************************************************************
   NAME:       SET_EXIST_MSG_PACK
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/17/2012   Irwin Tabisora   Create Pack quotation assured check


******************************************************************************/
   v_quote_cnt       NUMBER          := 0;
   v_par_cnt         NUMBER          := 0;
   v_pol_cnt         NUMBER          := 0;
   v_alert_msg_txt   VARCHAR2 (1000) := 'SUCCESS';
BEGIN
   SELECT COUNT (*)
     INTO v_quote_cnt
     FROM gipi_pack_quote
    WHERE 1 = 1 AND line_cd = p_line_cd AND assd_no = p_assd_no;

   SELECT COUNT (*)
     INTO v_par_cnt
     FROM gipi_pack_parlist
    WHERE par_status NOT IN (98, 99, 10)
      AND line_cd = p_line_cd
      AND assd_no = p_assd_no;

   SELECT COUNT (*)
     INTO v_pol_cnt
     FROM gipi_pack_parlist
    WHERE par_status = 10 AND line_cd = p_line_cd AND assd_no = p_assd_no;

   IF v_quote_cnt <> 0 AND v_par_cnt <> 0 AND v_pol_cnt <> 0
   THEN
      v_alert_msg_txt :=
         'Assured is already existing in other Quotation/s, PAR/s and Policies.';
   ELSIF v_quote_cnt = 0 AND v_par_cnt <> 0 AND v_pol_cnt <> 0
   THEN
      v_alert_msg_txt :=
                   'Assured is already existing in other PAR/s and Policies.';
   ELSIF v_quote_cnt <> 0 AND v_par_cnt = 0 AND v_pol_cnt <> 0
   THEN
      v_alert_msg_txt :=
             'Assured is already existing in other Quotation/s and Policies.';
   ELSIF v_quote_cnt <> 0 AND v_par_cnt <> 0 AND v_pol_cnt = 0
   THEN
      v_alert_msg_txt :=
                'Assured is already existing in other Quotation/s and PAR/s.';
   ELSIF v_quote_cnt = 0 AND v_par_cnt = 0 AND v_pol_cnt <> 0
   THEN
      v_alert_msg_txt := 'Assured is already existing in Policy records.';
   ELSIF v_quote_cnt = 0 AND v_par_cnt <> 0 AND v_pol_cnt = 0
   THEN
      v_alert_msg_txt := 'Assured is already existing in PAR records.';
   ELSIF v_quote_cnt <> 0 AND v_par_cnt = 0 AND v_pol_cnt = 0
   THEN
      v_alert_msg_txt := 'Assured is already existing in another Quotation.';
   END IF;
--TEST
   RETURN (v_alert_msg_txt);
END set_exist_msg_pack;
/


