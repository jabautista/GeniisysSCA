CREATE OR REPLACE PACKAGE BODY CPI.giacr410_mac_pkg
AS
/*
**  Created by   :  Benjamin June Brito
**  Date Created :  12.05.2013
**  Description  :  Populate GICLR410 - Collection Letter
*/
   FUNCTION get_details (
      p_policy_id     giac_cm_dm.gacc_tran_id%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_bal_amt_due   NUMBER
   )
      RETURN details_tab PIPELINED
   AS
      det   details_type;
   BEGIN
      det.sys_date := TO_CHAR (SYSDATE, 'fmMonth DD, YYYY');

      FOR i IN (SELECT intm_name, mail_addr1, mail_addr2, mail_addr3
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no)
      LOOP
         det.intm_name := UPPER (i.intm_name);
         det.mail_addr1 := UPPER (i.mail_addr1);
         det.mail_addr2 := UPPER (i.mail_addr2);
         det.mail_addr3 := UPPER (i.mail_addr3);
      END LOOP;

      FOR x IN (SELECT subline_cd,
                          line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
                       DECODE (NVL (endt_seq_no, 0),
                               0, '',
                                  endt_iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (endt_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
                              ) endt_no,
                       incept_date, expiry_date, iss_cd
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id)
      LOOP
         det.subline_cd := x.subline_cd;
         det.policy_no := x.policy_no;
         det.endt_no := x.endt_no;
         det.incept_date := TO_CHAR (x.incept_date, 'MM/DD/YY');
         det.expiry_date := TO_CHAR (x.expiry_date, 'MM/DD/YY');

         BEGIN
            SELECT tel_no
              INTO det.tel_no
              FROM giis_issource
             WHERE iss_cd = x.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END LOOP;

      PIPE ROW (det);
   END get_details;

   FUNCTION get_cl_signatory (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN signatory_tab PIPELINED
   AS
      sig   signatory_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.signatory, a.designation, b.item_no,
                                b.label
                           FROM giis_signatory_names a,
                                giac_rep_signatory b,
                                gipi_polbasic c,
                                giac_documents d
                          WHERE c.policy_id = p_policy_id
                            AND c.line_cd = NVL (d.line_cd, c.line_cd)
                            AND c.iss_cd = NVL (d.branch_cd, c.iss_cd)
                            AND d.report_id = 'GIACR410'
                            AND b.report_id = d.report_id
                            AND a.signatory_id = b.signatory_id
                       ORDER BY b.item_no)
      LOOP
         sig.label := i.label;
         sig.signatory := i.signatory;
         sig.designation := i.designation;
         PIPE ROW (sig);
      END LOOP;

      RETURN;
   END get_cl_signatory;
END giacr410_mac_pkg;
/


