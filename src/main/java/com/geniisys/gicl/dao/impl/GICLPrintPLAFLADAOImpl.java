package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLPrintPLAFLADAO;
import com.geniisys.gicl.entity.GICLAdvsFla;
import com.geniisys.gicl.entity.GICLAdvsPla;
import com.ibatis.sqlmap.client.SqlMapClient;
import common.Logger;

public class GICLPrintPLAFLADAOImpl implements GICLPrintPLAFLADAO{
	
	private static Logger log = Logger.getLogger(GICLPrintPLAFLADAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> queryCountLossAdvice(Map<String, Object> params) throws SQLException {
		log.info("Querying count...");
		if(params.get("currentView").equals("P")){
			this.getSqlMapClient().queryForObject("queryCountPLA", params);
		} else if(params.get("currentView").equals("F")){
			this.getSqlMapClient().queryForObject("queryCountFLA", params);
		}		
		log.info("Count queried: "+params);
		return params;
	}

	@Override
	public String tagPlaAsPrinted(Map<String, Object> allParams) throws SQLException, Exception {
		String message = "";
		@SuppressWarnings("unchecked")
		List<GICLAdvsPla> setRows = (List<GICLAdvsPla>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of updating gicl_advs_pla...");
			
			for(GICLAdvsPla set : setRows) {
				log.info("UPDATING: " + set.getPlaId() +" - "+set.getGrpSeqNo()+" - "+set.getClaimId()+" - "+set.getRiCd());
				Map<String, Object> upd = new HashMap<String, Object>();
				upd.put("printSw", set.getPrintSw());
				upd.put("shareType", set.getShareType());
				upd.put("plaHeader", set.getPlaHeader());
				upd.put("plaFooter", set.getPlaFooter());
				upd.put("plaTitle", set.getPlaTitle());
				upd.put("claimId", set.getClaimId());
				upd.put("grpSeqNo", set.getGrpSeqNo());
				upd.put("riCd", set.getRiCd());
				upd.put("plaSeqNo", set.getPlaSeqNo());
				upd.put("lineCd", set.getLineCd());
				upd.put("laYy", set.getLaYy());
				
				this.getSqlMapClient().update("tagPlaAsPrinted", upd);				
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();	
			message = "SUCCESS";
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new Exception();
		} finally {
			log.info("DAO - End of updating gicl_advs_pla.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String tagFlaAsPrinted(Map<String, Object> allParams) throws SQLException, Exception {
		String message = "";
		@SuppressWarnings("unchecked")
		List<GICLAdvsFla> setRows = (List<GICLAdvsFla>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of updating gicl_advs_fla...");
			
			for(GICLAdvsFla set : setRows) {
				log.info("UPDATING: " + set.getFlaId() +" - "+set.getGrpSeqNo()+" - "+set.getClaimId()+" - "+set.getRiCd());
				Map<String, Object> upd = new HashMap<String, Object>();
				upd.put("printSw", set.getPrintSw());
				upd.put("shareType", set.getShareType());
				upd.put("flaHeader", set.getFlaHeader());
				upd.put("flaFooter", set.getFlaFooter());
				upd.put("flaTitle", set.getFlaTitle());
				upd.put("claimId", set.getClaimId());
				upd.put("grpSeqNo", set.getGrpSeqNo());
				upd.put("riCd", set.getRiCd());
				upd.put("flaSeqNo", set.getFlaSeqNo());
				upd.put("lineCd", set.getLineCd());
				upd.put("laYy", set.getLaYy());
				
				this.getSqlMapClient().update("tagFlaAsPrinted", upd);				
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();	
			message = "SUCCESS";
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new Exception();
		} finally {
			log.info("DAO - End of updating gicl_advs_fla.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

}
