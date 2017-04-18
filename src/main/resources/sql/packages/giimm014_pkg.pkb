CREATE OR REPLACE PACKAGE BODY CPI.giimm014_pkg
AS
   FUNCTION get_pack_quote_lov (
      p_line_cd        gipi_pack_quote.line_cd%TYPE,
      p_subline_cd     gipi_pack_quote.subline_cd%TYPE,
      p_iss_cd         gipi_pack_quote.iss_cd%TYPE,
      p_quotation_yy   gipi_pack_quote.quotation_yy%TYPE,
      p_quotation_no   gipi_pack_quote.quotation_no%TYPE,
      p_proposal_no    gipi_pack_quote.proposal_no%TYPE,
      p_assd_name      gipi_pack_quote.assd_name%TYPE,
      p_user_id        giis_users.user_id%TYPE --added by steven 05.17.2013
   )
      RETURN get_pack_quote_lov_tab PIPELINED
   IS
      v_list   get_pack_quote_lov_type;
   BEGIN
      FOR i IN
         (SELECT line_cd, subline_cd, iss_cd, quotation_yy, quotation_no,
                 proposal_no, status, assd_no, assd_name,
                 TO_CHAR (incept_date, 'MM-dd-YYYY') incept_date,
                 TO_CHAR (expiry_date, 'MM-dd-YYYY') expiry_date,
                 TO_CHAR (accept_dt, 'MM-dd-YYYY') accept_date,
                 (expiry_date - incept_date) days, pack_quote_id,
                 (   line_cd
                  || '-'
                  || subline_cd
                  || '-'
                  || iss_cd
                  || '-'
                  || quotation_yy
                  || '-'
                  || LTRIM(TO_CHAR(quotation_no,'0999999'))
                  || '-'
                  || LTRIM(TO_CHAR(proposal_no,'099'))
                 ) pack_quotation
            FROM gipi_pack_quote
           WHERE line_cd = NVL (p_line_cd, line_cd)
             AND subline_cd = NVL (p_subline_cd, subline_cd)
             AND iss_cd = NVL (p_iss_cd, iss_cd)
             AND quotation_yy = NVL (p_quotation_yy, quotation_yy)
             AND quotation_no = NVL (p_quotation_no, quotation_no)
             AND proposal_no = NVL (p_proposal_no, proposal_no)
             AND check_user_per_iss_cd2 (NVL (p_line_cd, line_cd), NVL (p_iss_cd, iss_cd), 'GIIMM014', p_user_id) = 1 --added steven 05.17.2013
             AND UPPER (NVL (assd_name, '*')) LIKE UPPER (NVL (p_assd_name, DECODE (assd_name, NULL, '*', assd_name)))
         )
         
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.quotation_yy := i.quotation_yy;
         v_list.quotation_no := i.quotation_no;
         v_list.proposal_no := i.proposal_no;
         v_list.status := i.status;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.accept_date := i.accept_date;
         v_list.days := i.days;
         v_list.pack_quote_id := i.pack_quote_id;
         v_list.pack_quotation := i.pack_quotation;
         v_list.assd_name := i.assd_name;

         BEGIN
            FOR b IN (SELECT UPPER (rv_meaning) rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_domain = 'GIPI_QUOTE.STATUS'
                         AND rv_low_value = i.status)
            LOOP
               v_list.dsp_mean_status := b.rv_meaning;
            END LOOP;
         END;

         BEGIN
            v_list.client := i.assd_no || ' - ' || i.assd_name;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_pack_quote_lov;

   FUNCTION get_giimm014_quotation_no (
      p_pack_quote_id   VARCHAR2
   )
      RETURN get_quotation_no_tab PIPELINED
   IS
      v_list   get_quotation_no_type;
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                       quotation_no, proposal_no, quote_id
                  FROM gipi_quote
                 WHERE pack_quote_id = TO_NUMBER(p_pack_quote_id))
      LOOP
         BEGIN
            v_list.dv_quote :=
                  i.line_cd
               || ' - '
               || i.subline_cd
               || ' - '
               || i.iss_cd
               || ' - '
               || i.quotation_yy
               || ' - '
               || TO_CHAR (i.quotation_no, '0999999')
               || ' - '
               || TO_CHAR (i.proposal_no, '099');
               
            v_list.quote_id := i.quote_id;   --marco - 07.07.2014
            v_list.line_cd := i.line_cd;     --
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_giimm014_quotation_no;
END;
/


