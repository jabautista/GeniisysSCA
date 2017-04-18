DROP PROCEDURE CPI.GET_COMPANY_ADDRESS2;

CREATE OR REPLACE PROCEDURE CPI.GET_COMPANY_ADDRESS2 (
   p_report_id              VARCHAR2,
   p_iss_cd                 VARCHAR2,
   P_LINE_cd                varchar2,
   p_company_address1   OUT GIIS_ISSOURCE.address1%TYPE,
   p_company_address2   OUT GIIS_ISSOURCE.address2%TYPE,
   p_company_address3   OUT GIIS_ISSOURCE.address3%TYPE,
   p_tel_no             OUT GIIS_ISSOURCE.tel_no%TYPE,
   p_tin_no         	OUT GIIS_ISSOURCE.branch_tin_cd%TYPE) IS
   
/*
**  Created by		: Irwin Tabisora
**  Date Created 	: 8.29.2012
**  Description 	: Retrieves the address of the company 
**                    depending on the parameter.
**                   Added Line_cd paramater for giis_reports
*/

	v_add_source    VARCHAR2(1);

 BEGIN
	 BEGIN
		SELECT add_source 
          INTO v_add_source 
          FROM GIIS_REPORTS 
         WHERE report_id = p_report_id
		 and line_cd = p_line_cd
		 ;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
	      v_add_source :='P';
    END;
   
   --IF v_add_source = 'Y' THEN replaced by: Nica 3.13.2013
   
   /*Identify the source of the report company address(if any)
       P - Based on parameter value/ HO address
       M - Based on issuing source maintenance*/
	   
   IF v_add_source = 'P' THEN
            FOR i IN (SELECT address1, address2, address3,
                       tel_no, branch_tin_cd
                     FROM GIIS_ISSOURCE
                    WHERE iss_cd = 'HO')
      LOOP
         p_company_address1 := nvl(i.address1, ' ');
         p_company_address2 := nvl(i.address2, ' ');
         p_company_address3 := nvl(i.address3, ' ');
         p_tel_no           := nvl(i.tel_no, ' ');
         p_tin_no       	:= nvl(i.branch_tin_cd, ' ');
      END LOOP;
   ELSE
      FOR i IN (SELECT address1, address2, address3,
                       tel_no, branch_tin_cd
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd = p_iss_cd)
      LOOP
          p_company_address1 := nvl(i.address1, ' ');
         p_company_address2 := nvl(i.address2, ' ');
         p_company_address3 := nvl(i.address3, ' ');
         p_tel_no           := nvl(i.tel_no, ' ');
         p_tin_no       	:= nvl(i.branch_tin_cd, ' ');
      END LOOP;
   END IF;

END;
/


