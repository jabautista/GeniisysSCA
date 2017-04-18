CREATE OR REPLACE PACKAGE CPI.giac_colln_batch_pkg
AS
   TYPE giac_colln_batch_type IS RECORD (
      dcb_no      giac_colln_batch.dcb_no%TYPE
      --dcb_year    giac_colln_batch.dcb_year%TYPE,
      --fund_cd     giac_colln_batch.fund_cd%TYPE,
      --branch_cd   giac_colln_batch.branch_cd%TYPE,
      --tran_date   giac_colln_batch.tran_date%TYPE,
      --dcb_flag    giac_colln_batch.dcb_flag%TYPE,
      --remarks     giac_colln_batch.remarks%TYPE
   );
   
   TYPE dcb_date_lov_type IS RECORD (
         tran_date              GIAC_COLLN_BATCH.tran_date%TYPE,
      dcb_date              VARCHAR2(10),
      dcb_year              NUMBER(4)
   );
   
   TYPE dcb_no_lov_type IS RECORD (
         dcb_no              GIAC_COLLN_BATCH.dcb_no%TYPE
   );
   
   TYPE colln_batch_type IS RECORD (
      dcb_no      giac_colln_batch.dcb_no%TYPE,
      dcb_year    giac_colln_batch.dcb_year%TYPE,
      fund_cd     giac_colln_batch.fund_cd%TYPE,
      branch_cd   giac_colln_batch.branch_cd%TYPE,
      tran_date    giac_colln_batch.tran_date%TYPE,
      dcb_flag    giac_colln_batch.dcb_flag%TYPE,
      remarks     giac_colln_batch.remarks%TYPE,
      user_id     giac_colln_batch.user_id%TYPE,
      dcb_status    VARCHAR2(100)
   );

   TYPE giac_colln_batch_tab IS TABLE OF giac_colln_batch_type;
   
   TYPE dcb_date_lov_tab IS TABLE OF dcb_date_lov_type;
   
   TYPE dcb_no_lov_tab IS TABLE OF dcb_no_lov_type;
   
   TYPE colln_batch_tab IS TABLE OF colln_batch_type;

   PROCEDURE set_dcb_details (
      p_dcb_no      giac_colln_batch.dcb_no%TYPE,
      p_dcb_year    giac_colln_batch.dcb_year%TYPE,
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE,
      p_dcb_flag    giac_colln_batch.dcb_flag%TYPE,
      p_remarks     giac_colln_batch.remarks%TYPE
   );

   FUNCTION get_dcb_no (
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE
   )
      RETURN giac_colln_batch_tab PIPELINED;

   FUNCTION get_new_dcb_no (
      p_fund_cd     giac_colln_batch.fund_cd%TYPE,
      p_branch_cd   giac_colln_batch.branch_cd%TYPE,
      p_tran_date   giac_colln_batch.tran_date%TYPE
   )
      RETURN giac_colln_batch_tab PIPELINED;
      
   FUNCTION get_dcb_date_lov (p_gfun_fund_cd       GIAC_COLLN_BATCH.fund_cd%TYPE,
                                 p_gibr_branch_cd       GIAC_COLLN_BATCH.branch_cd%TYPE,
                              p_keyword               VARCHAR2)
     RETURN dcb_date_lov_tab PIPELINED;
     
   FUNCTION get_dcb_no_lov (p_gfun_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
                               p_gibr_branch_cd       GIAC_COLLN_BATCH.branch_cd%TYPE,
                            p_dcb_date               VARCHAR2,
                            p_dcb_year               GIAC_COLLN_BATCH.dcb_year%TYPE,
                            p_keyword               VARCHAR2)
     RETURN dcb_no_lov_tab PIPELINED;
     
   FUNCTION get_dcb_no_details (
       p_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
          p_branch_cd           GIAC_COLLN_BATCH.branch_cd%TYPE,
       p_dcb_flag          GIAC_COLLN_BATCH.dcb_flag%TYPE         
   ) RETURN colln_batch_tab PIPELINED;
   
   FUNCTION get_max_dcb_no(
       p_dcb_year          GIAC_COLLN_BATCH.dcb_year%TYPE,
       p_fund_cd           GIAC_COLLN_BATCH.fund_cd%TYPE,
          p_branch_cd           GIAC_COLLN_BATCH.branch_cd%TYPE
   ) RETURN NUMBER;
   
   PROCEDURE set_giac_colln_batch(
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_tran_date   GIAC_COLLN_BATCH.tran_date%TYPE,
        p_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE,
        p_remarks     GIAC_COLLN_BATCH.remarks%TYPE,
        p_user_id     GIAC_COLLN_BATCH.user_id%TYPE
   );
   
   PROCEDURE del_giac_colln_batch(
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE
   );
   
   FUNCTION check_valid_close_dcb (
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE 
   ) RETURN VARCHAR2;
   
   PROCEDURE update_dcb_for_closing (
        p_dcb_flag    GIAC_COLLN_BATCH.dcb_flag%TYPE,
        p_dcb_no      GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_dcb_year    GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_fund_cd     GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd   GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_user_id     GIIS_USERS.user_id%TYPE  
   );
   
    FUNCTION get_closed_tag(
           p_fund_cd      giac_tran_mm.fund_cd%TYPE,
          p_date       giac_acctrans.tran_date%TYPE,
        p_branch_cd giac_tran_mm.branch_cd%TYPE
    ) RETURN VARCHAR2;
    
   FUNCTION get_dcb_date_lov2 (p_gfun_fund_cd	   GIAC_COLLN_BATCH.fund_cd%TYPE,
   							  p_gibr_branch_cd	   GIAC_COLLN_BATCH.branch_cd%TYPE,
							  p_keyword			   VARCHAR2)
     RETURN dcb_date_lov_tab PIPELINED;
     
   FUNCTION get_dcb_no_lov2 (
        p_gfun_fund_cd         GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_gibr_branch_cd       GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_dcb_date             VARCHAR2,
        p_dcb_year             GIAC_COLLN_BATCH.dcb_year%TYPE,
        p_keyword              VARCHAR2
   )
     RETURN dcb_no_lov_tab PIPELINED;
END;
/
