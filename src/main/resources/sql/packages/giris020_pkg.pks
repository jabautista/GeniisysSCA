CREATE OR REPLACE PACKAGE CPI.GIRIS020_PKG 
AS

    TYPE outward_ri_type IS RECORD (
        line_cd         GIRI_FRPS_OUTFACUL_PREM_V.line_cd%TYPE,
        endt_iss_cd     GIRI_FRPS_OUTFACUL_PREM_V.endt_iss_cd%TYPE,
        endt_yy         GIRI_FRPS_OUTFACUL_PREM_V.endt_yy%TYPE,
        endt_seq_no     GIRI_FRPS_OUTFACUL_PREM_V.endt_seq_no%TYPE,
        frps_yy         GIRI_FRPS_OUTFACUL_PREM_V.frps_yy%TYPE,
        frps_seq_no     GIRI_FRPS_OUTFACUL_PREM_V.frps_seq_no%TYPE,
        binder_yy       GIRI_FRPS_OUTFACUL_PREM_V.binder_yy%TYPE,
        binder_seq_no   GIRI_FRPS_OUTFACUL_PREM_V.binder_seq_no%TYPE,
        ri_cd           GIRI_FRPS_OUTFACUL_PREM_V.ri_cd%TYPE,
        binder_date_str VARCHAR2(50), 
        binder_date     GIRI_FRPS_OUTFACUL_PREM_V.binder_date%TYPE,
        net_due         GIRI_FRPS_OUTFACUL_PREM_V.net_due%TYPE,
        payments        GIRI_FRPS_OUTFACUL_PREM_V.payments%TYPE,
        balance         GIRI_FRPS_OUTFACUL_PREM_V.balance%TYPE,
        confirm_no      GIRI_FRPS_OUTFACUL_PREM_V.confirm_no%TYPE,
        confirm_date    VARCHAR2(50), 
        w_confirmation  VARCHAR2(1),
        
        policy_no       VARCHAR2(100),
        endt_no         VARCHAR2(100),
        frps_no         VARCHAR2(100),
        binder_no       VARCHAR2(100),
        assd_name       GIRI_FRPS_OUTFACUL_PREM_V.ASSD_NAME%TYPE,
        
        ri_prem_amt     GIRI_FRPS_OUTFACUL_PREM_V.ri_prem_amt%TYPE,
        ri_prem_vat     GIRI_FRPS_OUTFACUL_PREM_V.ri_prem_vat%TYPE,
        ri_comm_amt     GIRI_FRPS_OUTFACUL_PREM_V.ri_comm_amt%TYPE,
        ri_comm_vat     GIRI_FRPS_OUTFACUL_PREM_V.ri_comm_vat%TYPE
    );
    
    TYPE outward_ri_tab IS TABLE OF outward_ri_type;
    
     FUNCTION get_binder_list(
        p_ri_cd     GIRI_FRPS_OUTFACUL_PREM_V.ri_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    ) RETURN outward_ri_tab PIPELINED;
    
    
END GIRIS020_PKG;
/


