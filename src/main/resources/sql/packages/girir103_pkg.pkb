CREATE OR REPLACE PACKAGE BODY CPI.GIRIR103_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   04.30.2013
     ** Referenced By:  GIRIR103 - Assumed Premium Production (Posted)
     **/
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name        giis_parameters.param_name%type;
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name := c.param_value_v;
        END LOOP;
        
        RETURN(v_company_name);
        
    END CF_COMPANY_NAME;
    
         
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_address varchar2(500);
    BEGIN
        select param_value_v
          into v_address
          from giis_parameters 
         where param_name = 'COMPANY_ADDRESS';
        
        return(v_address);
        
    RETURN NULL; exception
        when no_data_found then null;
            return(v_address);
            
    END CF_COMPANY_ADDRESS;
    
    
    FUNCTION CF_loc_risk1(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2
    AS
        v_loc_risk1        gipi_fireitem.loc_risk1%type;
    BEGIN
        IF p_line_cd = 'FI' THEN
            FOR c IN (SELECT loc_risk1
                        FROM gipi_fireitem
                       WHERE policy_id = p_policy_id)
            LOOP
                v_loc_risk1 := c.loc_risk1;
            END LOOP;
        END IF;
        RETURN(v_loc_risk1);
    END CF_loc_risk1;
    
    
    FUNCTION CF_loc_risk2(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2
    AS
        v_loc_risk2        gipi_fireitem.loc_risk2%type;
    BEGIN
        IF p_line_cd = 'FI' THEN
            FOR c IN (SELECT loc_risk2
                        FROM gipi_fireitem
                       WHERE policy_id = p_policy_id)
            LOOP
                v_loc_risk2 := c.loc_risk2;
            END LOOP;
        END IF;
        RETURN(v_loc_risk2);
    END CF_loc_risk2;
    
    
    FUNCTION CF_loc_risk3(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2
    AS
        v_loc_risk3        gipi_fireitem.loc_risk3%type;
    BEGIN
        IF p_line_cd = 'FI' THEN
            FOR c IN (SELECT loc_risk3
                        FROM gipi_fireitem
                       WHERE policy_id = p_policy_id)
            LOOP
                v_loc_risk3 := c.loc_risk3;
            END LOOP;
        END IF;
        RETURN(v_loc_risk3);
    END CF_loc_risk3;
    
    
    FUNCTION CF_DESTN(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2
    AS
        v_destn        gipi_cargo.destn%type;
    BEGIN
        IF p_line_cd = 'MN' THEN
            FOR c IN (SELECT destn
                        FROM gipi_cargo
                       WHERE policy_id = p_policy_id)
            LOOP
                v_destn := c.destn;
            END LOOP;
        END IF;
        RETURN(v_destn);
    END CF_DESTN;
    
    
    FUNCTION CF_VESSEL_CD(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_policy_id     GIPI_POLBASIC.POLICY_ID%type
    ) RETURN VARCHAR2
    AS
        v_vessel_cd        gipi_cargo.vessel_cd%type;
    BEGIN
        IF p_line_cd = 'MN' THEN
            FOR c IN (SELECT vessel_cd 
                        FROM gipi_cargo
                       WHERE policy_id = p_policy_id)
            LOOP
                v_vessel_cd := c.vessel_cd;
            END LOOP;
        END IF;
        RETURN(v_vessel_cd);
    END CF_VESSEL_CD;
    
    
    FUNCTION CF_VESSEL_NAME(
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_vessel_cd     gipi_cargo.vessel_cd%type
    ) RETURN VARCHAR2
    AS
        v_vessel_name   giis_vessel.vessel_name%type;
    BEGIN
        IF p_line_cd = 'MN' THEN
            FOR c IN (SELECT vessel_name
                        FROM giis_vessel
                       WHERE vessel_cd = p_vessel_cd)
            LOOP
                v_vessel_name := c.vessel_name;
            END LOOP;
        END IF;
        RETURN(v_vessel_name);
    END CF_VESSEL_NAME; 
    
    
    FUNCTION get_report_details(
        p_report_month      VARCHAR2,
        p_report_year       NUMBER
    ) RETURN report_details_tab PIPELINED
    AS
        rep     report_details_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        rep.paramdate       := 'FOR THE MONTH OF ' || UPPER(p_report_month) || ', ' || UPPER(p_report_year);
        
        FOR i IN   (SELECT D.RI_POLICY_NO, C.ENDT_ISS_CD||'-'|| LTRIM(TO_CHAR(C.ENDT_YY,'09'))||'-'|| LTRIM(TO_CHAR(C.ENDT_SEQ_NO,'099999')) ENDORSEMENT_NO,
                           C.POLICY_ID, G.RI_NAME, A.LINE_CD, A.LINE_NAME, B.SUBLINE_CD,
                           B.SUBLINE_NAME, E.ASSD_NAME, D.RI_BINDER_NO, TO_CHAR(C.INCEPT_DATE,'MM-DD-YYYY') INCEPT_DATE,
                           TO_CHAR(C.EXPIRY_DATE,'MM-DD-YYYY') EXPIRY_DATE, H.ITEM_NO, I.ITEM_TITLE, H.PERIL_CD ITEM_PERIL_CD,
                           J.PERIL_NAME, H.TSI_AMT AMT_ACCEPTED, DECODE(J.PERIL_TYPE,'B',H.TSI_AMT,0) AS AMT_ACCEPTED2,
                           H.PREM_AMT GROSS_RI_PREM_AMT, H.RI_COMM_RATE RI_COMM_RT, H.RI_COMM_AMT RI_COMM_AMT,
                           H.PREM_AMT * .05 PREMIUM_TAX, H.PREM_AMT - H.RI_COMM_AMT NET_PREMIUM  
                      FROM GIIS_LINE A,
                           GIIS_SUBLINE B,
                           GIPI_POLBASIC C,
                           GIRI_INPOLBAS D,
                           GIIS_ASSURED E,
                           -- GIIN_ASSD_PROD_POL_DTL F,
                           GIIS_REINSURER G,
                           GIPI_ITMPERIL H,
                           GIPI_ITEM I,
                           GIIS_PERIL J
                     WHERE A.LINE_CD    = B.LINE_CD
                       AND B.LINE_CD    = C.LINE_CD
                       AND B.SUBLINE_CD = C.SUBLINE_CD
                       AND C.POLICY_ID  = D.POLICY_ID
                       AND D.RI_CD      = G.RI_CD
                       AND C.ASSD_NO    = E.ASSD_NO
                       --AND E.ASSD_NO  = F.ASSD_NO
                       AND D.POLICY_ID  = H.POLICY_ID
                       AND H.POLICY_ID  = I.POLICY_ID
                       AND H.ITEM_NO    = I.ITEM_NO
                       AND H.LINE_CD    = J.LINE_CD
                       AND H.PERIL_CD   = J.PERIL_CD
                       AND C.ISS_CD     = (SELECT PARAM_VALUE_V
                                              FROM GIIS_PARAMETERS
                                             WHERE PARAM_NAME = 'ISS_CD_RI')
                       AND C.SPLD_FLAG    = '1'
                       AND C.DIST_FLAG    = '3'      
                       AND UPPER(TO_CHAR(C.INCEPT_DATE,'fmMONTH')) = UPPER(NVL(p_report_month,TO_CHAR(C.INCEPT_DATE,'fmMONTH'))) --added UPPER by robert 09262013
                       AND TO_CHAR(C.INCEPT_DATE,'YYYY')    = NVL(p_report_year,TO_CHAR(C.INCEPT_DATE,'YYYY'))
                     ORDER BY C.LINE_CD, C.SUBLINE_CD, D.RI_POLICY_NO, H.ITEM_NO, H.PERIL_CD )
        LOOP
            rep.ri_policy_no        := i.ri_policy_no;
            rep.endorsement_no      := i.endorsement_no;
            rep.policy_id           := i.policy_id;
            rep.ri_name             := i.ri_name;
            rep.line_cd             := i.line_cd;
            rep.line_name           := i.line_name;
            rep.subline_cd          := i.subline_cd;
            rep.subline_name        := i.subline_name;
            rep.assd_name           := i.assd_name;
            rep.cf_loc_risk1        := CF_LOC_RISK1(i.line_cd, i.policy_id);
            rep.cf_loc_risk2        := CF_LOC_RISK2(i.line_cd, i.policy_id);
            rep.cf_loc_risk3        := CF_LOC_RISK3(i.line_cd, i.policy_id);
            rep.cf_destn            := CF_DESTN(i.line_cd, i.policy_id);
            rep.cf_vessel_cd        := CF_VESSEL_CD(i.line_cd, i.policy_id);
            rep.cf_vessel_name      := CF_VESSEL_NAME(i.line_cd, rep.cf_vessel_cd);
            rep.ri_binder_no        := i.ri_binder_no;
            rep.incept_date         := i.incept_date;
            rep.expiry_date         := i.expiry_date;
            rep.item_no             := i.item_no;
            rep.item_title          := i.item_title;
            rep.item_peril_cd       := i.item_peril_cd;
            rep.peril_name          := i.peril_name;
            rep.amt_accepted        := i.amt_accepted;
            rep.amt_accepted2       := i.amt_accepted2;
            rep.gross_ri_prem_amt   := i.gross_ri_prem_amt;
            rep.ri_comm_rt          := i.ri_comm_rt;
            rep.ri_comm_amt         := i.ri_comm_amt;
            rep.premium_tax         := i.premium_tax;
            rep.net_premium         := i.net_premium;
            
            PIPE ROW(rep);
        END LOOP;
        
    END get_report_details;

END GIRIR103_PKG;
/


