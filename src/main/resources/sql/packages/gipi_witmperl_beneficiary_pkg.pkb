CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WITMPERL_BENEFICIARY_PKG
AS
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.26.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary - Peril)   
    **  Description     :Get PAR record listing for GIPI_WITMPERL_BENEFICIARY per item no      
    */    
  FUNCTION get_gipi_witmperl_benificiary(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
                                               p_item_no   GIPI_WITMPERL_BENEFICIARY.item_no%TYPE)
    RETURN gipi_witmperl_ben_tab PIPELINED IS
    v_benperil    gipi_witmperl_ben_type;    
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.beneficiary_no, a.line_cd,                a.peril_cd,
                     a.rec_flag,        a.prem_rt,                a.tsi_amt,
                     a.prem_amt,       a.ann_tsi_amt,            a.ann_prem_amt,
                     b.peril_name
                  FROM GIPI_WITMPERL_BENEFICIARY a,
                     GIIS_PERIL b
               WHERE a.par_id = p_par_id
                    AND a.item_no = p_item_no
                 AND a.peril_cd = b.peril_cd(+)
                 AND a.line_cd = b.line_cd(+)
                 ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
    LOOP
      v_benperil.par_id                  := i.par_id; 
      v_benperil.item_no                 := i.item_no;
      v_benperil.grouped_item_no         := i.grouped_item_no;
      v_benperil.beneficiary_no            := i.beneficiary_no;
      v_benperil.line_cd                  := i.line_cd;
      v_benperil.peril_cd                  := i.peril_cd;
      v_benperil.rec_flag                  := i.rec_flag;
      v_benperil.prem_rt                  := i.prem_rt;
      v_benperil.tsi_amt                  := i.tsi_amt;
      v_benperil.prem_amt                  := i.prem_amt;
      v_benperil.ann_tsi_amt              := i.ann_tsi_amt;
      v_benperil.ann_prem_amt              := i.ann_prem_amt;
      v_benperil.peril_name              := i.peril_name;
      
      PIPE ROW(v_benperil);
    END LOOP;
    RETURN; 
  END;      
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    05.27.2010    jerome orio        insert PAR record listing for GIPI_WITMPERL_BENEFICIARY per item no 
    **                                Reference By : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary - Peril)   
    **    11.10.2011    mark jm            change insert to merge statement for insert/update
    */
    PROCEDURE set_gipi_witmperl_benificiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,                         
        p_beneficiary_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE,        
        p_line_cd IN gipi_witmperl_beneficiary.line_cd%TYPE,
        p_peril_cd IN gipi_witmperl_beneficiary.peril_cd%TYPE,
        p_rec_flag IN gipi_witmperl_beneficiary.rec_flag%TYPE,
        p_prem_rt IN gipi_witmperl_beneficiary.prem_rt%TYPE,
        p_tsi_amt IN gipi_witmperl_beneficiary.tsi_amt%TYPE,
        p_prem_amt IN gipi_witmperl_beneficiary.prem_amt%TYPE,
        p_ann_tsi_amt IN gipi_witmperl_beneficiary.ann_tsi_amt%TYPE,
        p_ann_prem_amt IN gipi_witmperl_beneficiary.ann_prem_amt%TYPE)
    IS
    BEGIN
        MERGE INTO gipi_witmperl_beneficiary
        USING DUAL
        ON (par_id = p_par_id AND item_no = p_item_no AND grouped_item_no = p_grouped_item_no AND
            beneficiary_no = p_beneficiary_no AND peril_cd = p_peril_cd)
        WHEN NOT MATCHED THEN            
            INSERT (
                par_id,            item_no,        grouped_item_no,    beneficiary_no,    
                line_cd,        peril_cd,        rec_flag,            prem_rt,
                tsi_amt,        prem_amt,        ann_tsi_amt,        ann_prem_amt)
            VALUES (
                p_par_id,        p_item_no,        p_grouped_item_no,    p_beneficiary_no,
                p_line_cd,        p_peril_cd,        p_rec_flag,            p_prem_rt,
                p_tsi_amt,        p_prem_amt,        p_ann_tsi_amt,        p_ann_prem_amt)
        WHEN MATCHED THEN
            UPDATE
               SET line_cd = p_line_cd,
                   rec_flag = p_rec_flag,
                   prem_rt = p_prem_rt,
                   tsi_amt = p_tsi_amt,
                   prem_amt = p_prem_amt,
                   ann_tsi_amt = p_ann_tsi_amt,
                   ann_prem_amt = p_ann_prem_amt;
    END set_gipi_witmperl_benificiary;    
  
     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.27.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary - Peril)   
    **  Description     : delete PAR record listing for GIPI_WITMPERL_BENEFICIARY per item no      
    */    
  PROCEDURE del_gipi_witmperl_benificiary(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
                                                p_item_no   GIPI_WITMPERL_BENEFICIARY.item_no%TYPE
                                          )
                IS
  BEGIN
    DELETE GIPI_WITMPERL_BENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;    
  
  /*
    **  Created by        : Angelo Pagaduan
    **  Date Created     : 11.25.2010  
    **  Reference By     : (GIPIS065 - Accident Endt Items)   
    **  Description     :Get PAR record listing for GIPI_WITMPERL_BENEFICIARY  
    */    
  FUNCTION get_gipi_witmperl_benificiary2(p_par_id    GIPI_WITMPERL_BENEFICIARY.par_id%TYPE)
    RETURN gipi_witmperl_ben_tab PIPELINED IS
    v_benperil    gipi_witmperl_ben_type;    
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.beneficiary_no, a.line_cd,                a.peril_cd,
                     a.rec_flag,        a.prem_rt,                a.tsi_amt,
                     a.prem_amt,       a.ann_tsi_amt,            a.ann_prem_amt,
                     b.peril_name
                  FROM GIPI_WITMPERL_BENEFICIARY a,
                     GIIS_PERIL b
               WHERE a.par_id = p_par_id
                 AND a.peril_cd = b.peril_cd(+)
                 AND a.line_cd = b.line_cd(+)
                 ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
    LOOP
      v_benperil.par_id                  := i.par_id; 
      v_benperil.item_no                 := i.item_no;
      v_benperil.grouped_item_no         := i.grouped_item_no;
      v_benperil.beneficiary_no            := i.beneficiary_no;
      v_benperil.line_cd                  := i.line_cd;
      v_benperil.peril_cd                  := i.peril_cd;
      v_benperil.rec_flag                  := i.rec_flag;
      v_benperil.prem_rt                  := i.prem_rt;
      v_benperil.tsi_amt                  := i.tsi_amt;
      v_benperil.prem_amt                  := i.prem_amt;
      v_benperil.ann_tsi_amt              := i.ann_tsi_amt;
      v_benperil.ann_prem_amt              := i.ann_prem_amt;
      v_benperil.peril_name              := i.peril_name;
      
      PIPE ROW(v_benperil);
    END LOOP;
    RETURN; 
  END;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.05.2011    mark jm            retrieve records on gipi_witmperl_beneficiary based on given parameters (tablegrid varsion)      
    **    10.18.2011    mark jm            added nvl function on giis_peril.peril_name
    **    10.19.2011    mark jm            added ben_no parameter
    */
    FUNCTION get_gipi_witmperl_ben_tg(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_ben_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN gipi_witmperl_ben_tab PIPELINED
    IS
        v_benperil    gipi_witmperl_ben_type;    
    BEGIN
        FOR i IN (
            SELECT a.par_id,             a.item_no,                a.grouped_item_no,
                   a.beneficiary_no,     a.line_cd,                a.peril_cd,
                   a.rec_flag,            a.prem_rt,                a.tsi_amt,
                   a.prem_amt,            a.ann_tsi_amt,            a.ann_prem_amt,
                   b.peril_name
            FROM gipi_witmperl_beneficiary a,
                 giis_peril b
           WHERE a.par_id = p_par_id
             AND a.item_no = p_item_no
             AND a.grouped_item_no = p_grouped_item_no
             AND a.beneficiary_no = p_ben_no
             AND a.peril_cd = b.peril_cd(+)
             AND a.line_cd = b.line_cd(+)
             AND UPPER(NVL(b.peril_name, '***')) LIKE UPPER(NVL(p_peril_name, '%%'))
           ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
        LOOP
            v_benperil.par_id            := i.par_id; 
            v_benperil.item_no            := i.item_no;
            v_benperil.grouped_item_no    := i.grouped_item_no;
            v_benperil.beneficiary_no    := i.beneficiary_no;
            v_benperil.line_cd            := i.line_cd;
            v_benperil.peril_cd            := i.peril_cd;
            v_benperil.rec_flag            := i.rec_flag;
            v_benperil.prem_rt            := i.prem_rt;
            v_benperil.tsi_amt            := i.tsi_amt;
            v_benperil.prem_amt            := i.prem_amt;
            v_benperil.ann_tsi_amt        := i.ann_tsi_amt;
            v_benperil.ann_prem_amt        := i.ann_prem_amt;
            v_benperil.peril_name        := i.peril_name;

            PIPE ROW(v_benperil);
        END LOOP;
        RETURN; 
    END get_gipi_witmperl_ben_tg;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    11.10.2011    mark jm            delete records on gipi_witmperl_beneficiary based on given parameters
    */
    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_witmperl_beneficiary
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
    END del_gipi_witmperl_beneficiary;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    11.10.2011    mark jm            delete records on gipi_witmperl_beneficiary based on given parameters
    */
    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_witmperl_beneficiary
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no
           AND beneficiary_no = p_beneficiary_no;
    END del_gipi_witmperl_beneficiary;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    11.10.2011    mark jm            delete records on gipi_witmperl_beneficiary based on given parameters
    */
    PROCEDURE del_gipi_witmperl_beneficiary(
        p_par_id IN gipi_witmperl_beneficiary.par_id%TYPE,
        p_item_no IN gipi_witmperl_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_no IN gipi_witmperl_beneficiary.beneficiary_no%TYPE,
        p_peril_cd IN gipi_witmperl_beneficiary.peril_cd%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_witmperl_beneficiary
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no
           AND beneficiary_no = p_beneficiary_no
           AND peril_cd = p_peril_cd;
    END del_gipi_witmperl_beneficiary;
    
    FUNCTION get_witmperl_ben_listing(
        p_par_id            GIPI_WITMPERL_BENEFICIARY.par_id%TYPE,
        p_item_no           GIPI_WITMPERL_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   GIPI_WITMPERL_BENEFICIARY.grouped_item_no%TYPE,
        p_beneficiary_no    GIPI_WITMPERL_BENEFICIARY.beneficiary_no%TYPE,
        p_tsi_amt           GIPI_WITMPERL_BENEFICIARY.tsi_amt%TYPE,
        p_peril_name        GIIS_PERIL.peril_name%TYPE
    )
      RETURN gipi_witmperl_ben_tab PIPELINED IS
        v_itmperl           gipi_witmperl_ben_type;
    BEGIN
        FOR i IN(SELECT a.*,
                        b.peril_name
                   FROM GIPI_WITMPERL_BENEFICIARY a,
                        GIIS_PERIL b
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no
                    AND beneficiary_no = p_beneficiary_no
                    AND a.peril_cd = b.peril_cd
                    AND a.line_cd = b.line_cd
                    AND UPPER(b.peril_name) LIKE UPPER(NVL(p_peril_name, b.peril_name))
                    AND NVL(a.tsi_amt, 0) = DECODE(p_tsi_amt, NULL, NVL(a.tsi_amt, 0), p_tsi_amt))
        LOOP
            v_itmperl.par_id := i.par_id;
            v_itmperl.item_no := i.item_no;
            v_itmperl.grouped_item_no := i.grouped_item_no;
            v_itmperl.beneficiary_no := i.beneficiary_no;
            v_itmperl.line_cd := i.line_cd;
            v_itmperl.peril_cd := i.peril_cd;
            v_itmperl.rec_flag := i.rec_flag;
            v_itmperl.prem_rt := i.prem_rt;
            v_itmperl.tsi_amt := i.tsi_amt;
            v_itmperl.prem_amt := i.prem_amt;
            v_itmperl.ann_tsi_amt := i.ann_tsi_amt;
            v_itmperl.ann_prem_amt := i.ann_prem_amt;
            v_itmperl.peril_name := i.peril_name;
            PIPE ROW(v_itmperl);
        END LOOP;
        RETURN;
    END;
    
END;
/


