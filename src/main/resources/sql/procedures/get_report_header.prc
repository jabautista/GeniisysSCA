DROP PROCEDURE CPI.GET_REPORT_HEADER;

CREATE OR REPLACE PROCEDURE CPI.get_report_header (
   p_report_id               VARCHAR2,
   p_iss_cd                  VARCHAR2,
   p_company_address   OUT   VARCHAR2,
   p_tel_no            OUT   giis_issource.tel_no%TYPE,
   p_fax_no            OUT   giis_issource.branch_fax_no%TYPE,
   p_website           OUT   giis_issource.branch_website%TYPE
)
IS
/*
**  Created by        : Robert John Virrey
**  Date Created     : 8.15.2013
**  Description     : Retrieves the address, tel_no, fax_no and website of the company
**                    depending on the parameter.
**                    Identify the source of the report company address(if any)
**                     P - Based on parameter value/ HO address
**                     M - Based on issuing source maintenance
*/
   v_add_source   VARCHAR2 (1);
BEGIN
   BEGIN
      SELECT add_source
        INTO v_add_source
        FROM giis_reports
       WHERE report_id = p_report_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add_source := 'P';
   END;

   IF v_add_source = 'P'
   THEN
      FOR i IN (SELECT (address1 || ' ' || address2 || ' ' || address3
                       ) address,
                       tel_no, branch_fax_no, branch_website
                  FROM giis_issource
                 WHERE iss_cd = giacp.v ('MAIN_BRANCH_CD'))
      LOOP
         p_company_address := i.address;
         p_tel_no := i.tel_no;
         p_fax_no := i.branch_fax_no;
         p_website := i.branch_website;
      END LOOP;
   ELSE
      FOR i IN (SELECT (address1 || ' ' || address2 || ' ' || address3
                       ) address,
                       tel_no, branch_fax_no, branch_website
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd)
      LOOP
         p_company_address := i.address;
         p_tel_no := i.tel_no;
         p_fax_no := i.branch_fax_no;
         p_website := i.branch_website;
      END LOOP;
   END IF;
END;
/


