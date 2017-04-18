CREATE OR REPLACE PACKAGE BODY CPI.giis_funds_pkg
AS
  
  /*
  **  Created by   :  Emman
  **  Date Created :  03.29.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Gets the records of FUND_CD LOV
  */
  FUNCTION get_fund_cd_lov(p_keyword  	 VARCHAR2)
    RETURN fund_cd_tab PIPELINED
  IS
    v_fund_cd		   fund_cd_type;
  BEGIN
    FOR i IN (SELECT DISTINCT gibr.gfun_fund_cd fund_cd, gfun.fund_desc fund_desc 
			    FROM giis_funds gfun, giac_branches gibr 
			   WHERE gibr.gfun_fund_cd = gfun.fund_cd
			     AND (UPPER(gibr.gfun_fund_cd) LIKE UPPER(NVL(p_keyword, gibr.gfun_fund_cd))
				   OR UPPER(gfun.fund_desc) LIKE UPPER(NVL(p_keyword, gfun.fund_desc)))
			ORDER BY 2)
	LOOP
		v_fund_cd.fund_cd			   := i.fund_cd;
		v_fund_cd.fund_desc			   := i.fund_desc;
	
		PIPE ROW(v_fund_cd);
	END LOOP;
  END;

  /*
  **  Created by   :  niknok
  **  Date Created :  06.04.2012
  **  Reference By : (GIACS016 - Disbursement)
  **  Description  : Gets the records of FUND_CD LOV
  */
  FUNCTION get_fund_cd_lov2 RETURN fund_cd_tab PIPELINED
  IS
    v_fund_cd		   fund_cd_type;
  BEGIN
    FOR i IN (SELECT DISTINCT fund_cd, fund_desc
                FROM giis_funds)
	LOOP
		v_fund_cd.fund_cd			   := i.fund_cd;
		v_fund_cd.fund_desc			   := i.fund_desc;
	
		PIPE ROW(v_fund_cd);
	END LOOP;
  END;
  
  /*
  **  Created by   :  Justhel Bactung
  **  Date Created :  01.31.2013
  **  Reference By : (GIACS231 - Transaction Status)
  **  Description  : Gets the records of FUND_CD LOV
  */
  
    FUNCTION get_company_lov_list (p_fund GIIS_FUNDS.fund_desc%TYPE
    )
	RETURN get_company_lov_tab PIPELINED 
    IS
        v_list			get_company_lov_type;
    
    BEGIN
        FOR i IN (SELECT DISTINCT fund_cd, fund_desc
					FROM GIIS_FUNDS
                   WHERE UPPER(fund_desc) LIKE UPPER(NVL(p_fund, '%'))
                      OR UPPER(fund_cd) LIKE UPPER(NVL(p_fund, '%'))
                      OR UPPER(fund_cd || ' - ' || fund_desc) LIKE UPPER(NVL(p_fund, '%'))
                 )
		LOOP
			v_list.fund_cd			   := i.fund_cd;
			v_list.fund_desc		   := i.fund_desc;
		
			PIPE ROW(v_list);
		END LOOP;
	    RETURN;
    END get_company_lov_list;
   /*
  **  Created by   :  Fons
  **  Date Created :  05.08.2014
  **  Reference By : (GIACS318 - Witholding Tax Maintenance)
  **  Description  : Gets the records of FUND_CD LOV
  */
    FUNCTION get_fund_cd_lov3(
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_keyword  	 VARCHAR2
    )
        RETURN fund_cd_tab PIPELINED
    IS
        v_fund_cd		   fund_cd_type;
    BEGIN
        FOR i IN (SELECT DISTINCT gibr.gfun_fund_cd fund_cd, gfun.fund_desc fund_desc 
			    FROM giis_funds gfun, giac_branches gibr 
			   WHERE gibr.gfun_fund_cd = gfun.fund_cd
                 AND branch_cd =
                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                            branch_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                              1, branch_cd,
                              NULL
                             )
			     AND (UPPER(gibr.gfun_fund_cd) LIKE UPPER(NVL(p_keyword, gibr.gfun_fund_cd))
				   OR UPPER(gfun.fund_desc) LIKE UPPER(NVL(p_keyword, gfun.fund_desc)))
			ORDER BY 2)
	    LOOP
		    v_fund_cd.fund_cd			   := i.fund_cd;
		    v_fund_cd.fund_desc			   := i.fund_desc;
	
		    PIPE ROW(v_fund_cd);
	    END LOOP;
    END;
END giis_funds_pkg;
/


