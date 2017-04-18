CREATE OR REPLACE PACKAGE BODY CPI.GIACS213_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.04.2013
     ** Referenced By:  GIACS213 - Plate Number Inquiry (Direct Premium Collections)
     **/
     
    FUNCTION get_vehicle_list(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type,
        p_user_id       GIPI_POLBASIC.USER_ID%type
    ) RETURN vehicle_tab PIPELINED
    AS
        rec     vehicle_type;
    BEGIN
        FOR i IN (SELECT * 
                    FROM GIPI_VEHICLE
                   WHERE policy_id IN (SELECT b.policy_id
                                         FROM gipi_polbasic a, gipi_vehicle b
                                        WHERE a.policy_id = b.policy_id
                                          AND a.assd_no   = /*NVL(p_assd_no,a.assd_no)*/ p_assd_no 
                                          AND a.iss_cd =  DECODE(check_user_per_iss_cd_acctg2(NULL,iss_cd,'GIACS213',NVL (p_user_id,USER)), 1, iss_cd,NULL))
        )
        LOOP
            rec.policy_id   := i.policy_id;
            rec.item_no     := i.item_no;
            rec.plate_no    := i.plate_no;
            rec.dsp_line_cd     := null;
            rec.dsp_subline_cd  := null; 
            rec.dsp_iss_cd      := null;
            rec.dsp_issue_yy    := null; 
            rec.dsp_pol_seq_no  := null;
            rec.dsp_endt_seq_no := null; 
            rec.dsp_endt_type   := null; 
            rec.dsp_prem_seq_no := null; 
            rec.dsp_assd_no     := null; 
            rec.dsp_assd_name   := null;  
            
            BEGIN
                FOR j IN  ( SELECT B250.LINE_CD, B250.SUBLINE_CD, B250.ISS_CD, B250.ISSUE_YY, B250.POL_SEQ_NO,
                                   B250.ENDT_SEQ_NO, B250.ENDT_TYPE, b140.prem_seq_no, b250.assd_no, a020.assd_name,
                                   B140.ISS_CD bill_iss_cd
                              FROM gipi_invoice b140,
                                   gipi_polbasic b250,
                                   giis_assured a020
                             WHERE b250.policy_id = b140.policy_id
                               AND a020.assd_no   = b250.assd_no
                               AND B250.POLICY_ID = i.POLICY_ID)
                LOOP
                    rec.dsp_line_cd     := j.line_cd;
                    rec.dsp_subline_cd  := j.subline_cd; 
                    rec.dsp_iss_cd      := j.iss_cd;
                    rec.dsp_issue_yy    := j.issue_yy; 
                    rec.dsp_pol_seq_no  := j.pol_seq_no;
                    rec.dsp_endt_seq_no := j.endt_seq_no; 
                    rec.dsp_endt_type   := j.endt_type; 
                    rec.dsp_bill_no     := j.bill_iss_cd || ' - ' || LPAD(j.prem_seq_no, 8, 0);
                    rec.dsp_prem_seq_no := j.prem_seq_no;
                    rec.dsp_bill_iss_cd := j.bill_iss_cd; 
                    rec.dsp_assd_no     := j.assd_no; 
                    rec.dsp_assd_name   := j.assd_name; 
                    
                    EXIT;
                END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.dsp_line_cd     := null;
                    rec.dsp_subline_cd  := null; 
                    rec.dsp_iss_cd      := null;
                    rec.dsp_issue_yy    := null; 
                    rec.dsp_pol_seq_no  := null;
                    rec.dsp_endt_seq_no := null; 
                    rec.dsp_endt_type   := null; 
                    rec.dsp_prem_seq_no := null; 
                    rec.dsp_bill_iss_cd := null;
                    rec.dsp_assd_no     := null; 
                    rec.dsp_assd_name   := null;                    
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END get_vehicle_list;


    FUNCTION count_vehicles_insured(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type
    ) RETURN NUMBER
    AS
        v_count     NUMBER := 0;
    BEGIN
        select count(d.plate_no)
          into v_count
          from gipi_polbasic a, gipi_invoice b, gipi_item c,
               gipi_vehicle d, giis_assured e
         where a.policy_id = b.policy_id
           and a.iss_cd    = b.iss_cd
           and a.policy_id = c.policy_id
           and c.policy_id = d.policy_id
           and c.item_no   = d.item_no
           and a.assd_no   = e.assd_no
          and e.assd_no   = P_ASSD_NO;
          
        RETURN v_count;
        
    END count_vehicles_insured;
    
END GIACS213_PKG;
/


