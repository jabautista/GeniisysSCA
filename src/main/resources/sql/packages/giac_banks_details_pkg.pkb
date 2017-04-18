CREATE OR REPLACE PACKAGE BODY CPI.giac_banks_details_pkg
AS
   FUNCTION get_bank_details
      RETURN giac_banks_details_tab PIPELINED
   IS
      v_bank   giac_banks_details_type;
   BEGIN
      FOR i IN (SELECT bank_sname, bank_name, bank_cd
                  FROM giac_banks
              ORDER BY trim(bank_name))
      LOOP
         v_bank.bank_name := i.bank_name;
         v_bank.bank_sname := i.bank_sname;
         v_bank.bank_cd := i.bank_cd;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_dcb_bank_name
      RETURN giac_banks_details_tab PIPELINED
   IS
      v_bank   giac_banks_details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT gbac.bank_cd bank_cd,
                                gban.bank_name bank_name,
                                gban.bank_sname bank_sname
                           FROM giac_bank_accounts gbac, giac_banks gban
                          WHERE gbac.bank_cd = gban.bank_cd
                            AND gbac.bank_account_flag = 'A'
                            AND gbac.opening_date < SYSDATE
                            AND NVL (gbac.closing_date, SYSDATE + 1) > SYSDATE
                       ORDER BY 2)
      LOOP
         v_bank.bank_name := i.bank_name;
         v_bank.bank_cd := i.bank_cd;
         v_bank.bank_sname := i.bank_sname;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION cf_bank_snameformula (
      p_bank_cd    GIAC_BANKS.bank_cd%TYPE,
      p_paymode    GIAC_COLLECTION_DTL.pay_mode%TYPE
   ) RETURN VARCHAR2 IS
      v_bank_name   VARCHAR2(30);
   BEGIN
     v_bank_name := null;
     BEGIN
       select BANK_SNAME
       into v_bank_name
       from GIAC_BANKS
       where BANK_CD = p_bank_cd;
          
       exception
        when NO_DATA_FOUND then 
                IF p_paymode = 'CA' THEN
                     v_bank_name := 'CASH';    
                ELSIF p_paymode = 'CMI' THEN
                     v_bank_name := 'CREDIT MEMO (I)';
                ELSE
                   v_bank_name := null;
                END IF;    
      END;      
      RETURN v_bank_name;
   END cf_bank_snameformula;
   
   /**
   * Created By: Andrew Robes
   * Date : 10.21.2011
   * Module: (GIACS090 - APDC Payment)
   * Description:  Fucntion to retrieve giac bank listing
   */
   
   FUNCTION get_giac_bank_listing(p_find_text VARCHAR2)
      RETURN giac_banks_details_tab PIPELINED
   IS
      v_bank   giac_banks_details_type;
   BEGIN
      FOR i IN (SELECT bank_sname, bank_name, bank_cd
                  FROM giac_banks
                 WHERE UPPER(bank_sname) LIKE NVL(UPPER(p_find_text), '%')
                    OR UPPER(bank_name) LIKE NVL(UPPER(p_find_text), '%')
                    OR UPPER(bank_cd) LIKE NVL(UPPER(p_find_text), '%')
              ORDER BY trim(bank_name))
      LOOP
         v_bank.bank_name := i.bank_name;
         v_bank.bank_sname := i.bank_sname;
         v_bank.bank_cd := i.bank_cd;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END;   
   FUNCTION GET_GIACS035_BANK_CD_LOV( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_CD_LOV - Start
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS035_BANK_CD_LOV_TAB PIPELINED
   IS
      V_LIST GIACS035_BANK_CD_LOV_TYPE;
   BEGIN
        FOR I IN (SELECT DISTINCT A.BANK_CD, B.BANK_NAME 
                    FROM GIAC_BANK_ACCOUNTS A, GIAC_BANKS B 
                   WHERE A.BANK_CD = B.BANK_CD 
                     AND A.BANK_ACCOUNT_FLAG = 'A' 
                     AND A.OPENING_DATE < SYSDATE 
                     AND NVL(A.CLOSING_DATE,SYSDATE+1) > SYSDATE 
                     AND B.BANK_NAME LIKE UPPER(P_SEARCH)
                ORDER BY 2
        )
        LOOP
            V_LIST.BANK_CD        := I.BANK_CD;
            V_LIST.BANK_NAME      := I.BANK_NAME;   
        
            PIPE ROW(V_LIST);
        END LOOP;        
        RETURN;   
   END; -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_CD_LOV - End         
   
END giac_banks_details_pkg;
/


