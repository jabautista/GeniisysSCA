CREATE OR REPLACE PACKAGE BODY CPI.GIRIR109_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.17.2013
     ** Referenced By:  GIRIR109 - Treaty Bordereaux Report
     **/
     
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
    AS
        v_company_name  giis_parameters.param_value_v%type;
    BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name := c.param_value_v;
        END LOOP;
        
        RETURN (v_company_name);
    END CF_COMPANY_NAME;
        
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
    AS
        v_address   VARCHAR2(500);
    BEGIN   
        SELECT param_value_v
          INTO v_address
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
         
        RETURN (v_address);
    RETURN NULL; EXCEPTION
        WHEN no_data_found THEN
            NULL;
        RETURN (v_address);
    END CF_COMPANY_ADDRESS;
        
        
    FUNCTION get_report_header(
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
    )   RETURN report_header_tab PIPELINED
    AS
        rep     report_header_type;
    BEGIN
        rep.company_name    := CF_COMPANY_NAME;
        rep.company_address := CF_COMPANY_ADDRESS;
        
        IF p_report_month IS NOT NULL AND p_report_year IS NOT NULL THEN --benjo 10.08.2015 GENQA-SR-5043 added condition
            rep.cf_paramdate    := 'FOR THE MONTH OF ' || UPPER(p_report_month) || ', ' || p_report_year;
        END IF;

        PIPE ROW(rep);         
    END;

    
    FUNCTION CF_NET_DUE(
        p_premium_amt       giac_treaty_cessions.PREMIUM_AMT%type,
        p_commission_amt    giac_treaty_cessions.COMMISSION_AMT%type,
        p_cf_funds_held     NUMBER
    ) RETURN NUMBER
    AS
        net_due     NUMBER;
    BEGIN
        net_due := (p_premium_amt - p_commission_amt) - TO_NUMBER(p_cf_funds_held);
        RETURN NVL(net_due, 0);
    END CF_NET_DUE;
    
    
    FUNCTION CF_FUNDS_HELD(
        p_line_cd       giis_line.LINE_CD%type,
        p_premium_amt   giac_treaty_cessions.PREMIUM_AMT%type
    ) RETURN NUMBER
    AS
        funds_held      NUMBER;
    BEGIN
        IF p_line_cd IN ('EN','MC','MH','MN') THEN
            funds_held := 0.00;
            RETURN (funds_held);
        ELSE
            funds_held := p_premium_amt * 0.40;
            RETURN (funds_held);
        END IF;
    RETURN NULL; END CF_FUNDS_HELD;
    
    
    FUNCTION get_treaty_bordereaux(
        p_line_name     giis_line.line_name%type,
        p_report_month  VARCHAR2,
        p_report_year   VARCHAR2
    ) RETURN treaty_bordereaux_tab PIPELINED
    AS
        rep     treaty_bordereaux_type;
    BEGIN
        FOR i IN (/*select a120.line_cd,
                           a120.line_name,
                           (gtc.line_cd || '-' || gtc.treaty_yy || '-' || gtc.share_cd) treaty_no,
                           gtc.premium_amt,
                           gtc.commission_amt
                      from giac_treaty_cessions gtc,
                           giac_treaty_cession_dtl gtcd,
                           giis_trty_peril a640,
                           giis_line a120
                     where gtc.line_cd = a120.line_cd
                       and a120.line_cd = a640.line_cd
                       and gtc.cession_id = gtcd.cession_id
                       and gtcd.peril_cd = a640.peril_cd
                       and gtc.share_cd = a640.trty_seq_no
                       and a120.line_cd != (select param_value_v
                                              from giis_parameters
                                             where param_name = 'LINE_CODE_FI')
                       and upper(a120.line_name) = nvl(upper(:p_line_name), upper(a120.line_name))   
                       and to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH') = to_char(:p_month, 'fmMONTH')
                       and to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY') = to_char(:p_year, 'YYYY')*/
                       
                    select a120.line_cd,
                           a120.line_name,
                           (gtc.line_cd || '-' || gtc.treaty_yy || '-' || gtc.share_cd) treaty_no,
                           gtc.premium_amt,
                           gtc.commission_amt
                      from giac_treaty_cessions gtc,
                           giac_treaty_cession_dtl gtcd,
                           giis_trty_peril a640,
                           giis_line a120
                     where gtc.line_cd = a120.line_cd
                       and a120.line_cd = a640.line_cd
                       and gtc.cession_id = gtcd.cession_id
                       and gtcd.peril_cd = a640.peril_cd
                       and gtc.share_cd = a640.trty_seq_no
                       and a120.line_cd != (select param_value_v
                                              from giis_parameters
                                             where param_name = 'LINE_CODE_FI')
                       and upper(a120.line_name) = nvl(upper(p_line_name), upper(a120.line_name))   
                       and to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH') = NVL(P_REPORT_MONTH, to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH')) --benjo 10.08.2015 GENQA-SR-5043 added NVL
                       and to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY') =  NVL(P_REPORT_YEAR, to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY')) --benjo 10.08.2015 GENQA-SR-5043 added NVL
                     order by a120.line_cd )
        LOOP
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.treaty_no       := i.treaty_no;
            rep.premium_amt     := i.premium_amt;
            rep.commission_amt  := i.commission_amt;    
            rep.cf_funds_held   := CF_FUNDS_HELD(i.line_cd, i.premium_amt);
            rep.cf_net_due      := CF_NET_DUE(i.premium_amt, i.commission_amt, rep.cf_funds_held);
        
            PIPE ROW(rep);
        END LOOP;
    END get_treaty_bordereaux;
    
    
    FUNCTION get_treaty_border_fire(
        p_report_month      VARCHAR2,
        p_report_year       VARCHAR2
    ) RETURN treaty_border_fire_tab PIPELINED
    AS
        rep     treaty_border_fire_type;
    BEGIN
        FOR i IN (/*select a120.line_cd,
                           a120.line_name,
                           (gtc.line_cd || '-' || gtc.treaty_yy || '-' || gtc.share_cd) treaty_no,
                           decode(a640.trty_com_rt, 35, 'FIRE AND LIGHTNING', 10, 'OTHER PERILS') fire_peril,
                           gtc.premium_amt,
                           gtc.commission_amt,
                           (gtc.premium_amt * 0.40) funds_held_fire
                      from giac_treaty_cessions gtc,
                           giac_treaty_cession_dtl gtcd,
                           giis_trty_peril a640,
                           giis_line a120
                     where gtc.line_cd = a120.line_cd
                       and a120.line_cd = a640.line_cd
                       and gtc.cession_id = gtcd.cession_id
                       and gtcd.peril_cd = a640.peril_cd
                       and gtc.share_cd = a640.trty_seq_no
                       and a120.line_cd = (select param_value_v
                                             from giis_parameters
                                            where param_name = 'LINE_CODE_FI')
                       and a640.trty_com_rt in ('10', '35')
                       --   and upper(a120.line_name) = nvl(upper(:p_line_name), upper(a120.line_name))   
                       and to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH') = to_char(:p_month, 'fmMONTH')
                       and to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY') = to_char(:p_year, 'YYYY')
                     order by 1, 2, 3, 4*/

                    select a120.line_cd,
                           a120.line_name,
                           (gtc.line_cd || '-' || gtc.treaty_yy || '-' || gtc.share_cd) treaty_no,
                           decode(a640.trty_com_rt, 35, 'FIRE AND LIGHTNING', 10, 'OTHER PERILS') fire_peril,
                           gtc.premium_amt,
                           gtc.commission_amt,
                           (gtc.premium_amt * 0.40) funds_held_fire
                      from giac_treaty_cessions gtc, 
                           giac_treaty_cession_dtl gtcd,
                           giis_trty_peril a640,
                           giis_line a120
                     where gtc.line_cd = a120.line_cd
                       and a120.line_cd = a640.line_cd
                       and gtc.cession_id = gtcd.cession_id
                       and gtcd.peril_cd = a640.peril_cd
                       and gtc.share_cd = a640.trty_seq_no
                       and a120.line_cd = (select param_value_v
                                             from giis_parameters
                                            where param_name = 'LINE_CODE_FI')
                       and a640.trty_com_rt in ('10', '35')
                       --and upper(a120.line_name) = nvl(upper(:p_line_name), upper(a120.line_name))   
                       and to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH') = NVL(P_REPORT_MONTH, to_char(to_date(gtc.cession_mm, 'MM'), 'fmMONTH')) --benjo 10.08.2015 GENQA-SR-5043 added NVL
                       and to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY') =  NVL(P_REPORT_YEAR, to_char(to_date(gtc.cession_year, 'YYYY'), 'YYYY')) --benjo 10.08.2015 GENQA-SR-5043 added NVL
                     order by 1, 2, 3, 4 )
        LOOP
            rep.line_cd         := i.line_cd;
            rep.line_name       := i.line_name;
            rep.fire_peril      := i.fire_peril;
            rep.treaty_no       := i.treaty_no;
            rep.premium_amt     := i.premium_amt;
            rep.commission_amt  := i.commission_amt;
            rep.funds_held_fire := i.funds_held_fire;
            rep.cf_net_due_fire := CF_NET_DUE(i.premium_amt, i.commission_amt, i.funds_held_fire);
        
            PIPE ROW(rep);
        END LOOP;
    END get_treaty_border_fire;
    
        
END GIRIR109_PKG;
/


