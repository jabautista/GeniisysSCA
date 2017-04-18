package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCommSlipDAO;
import com.geniisys.giac.entity.GIACCommSlipExt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCommSlipDAOImpl implements GIACCommSlipDAO{
	
	private static Logger log = Logger.getLogger(GIACOpTextDAOImpl.class);
	public SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACCommSlipExt> getCommSlip(Integer gaccTranId)
			throws SQLException {
		log.info("Getting Comm Slip Lists...");
		//return (List<GIACCommSlipExt>) StringFormatter.replaceQuotesInList(this.getSqlMapClient().queryForList("getCommSlipRecords", gaccTranId));
		return this.getSqlMapClient().queryForList("getCommSlipRecords", gaccTranId);
	}

	@Override
	public Map<String, Object> extractCommSlip(Map<String, Object> params) throws SQLException {
		log.info("Extracting Comm Slip...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractCommSlip", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of comm slip extraction...");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> getCommSlipPrintParams(Map<String, Object> params)
			throws SQLException {
		log.info("Getting print comm slip parameters for "+params.get("userId"));
		this.getSqlMapClient().queryForObject("getCommPrintValues", params);
		System.out.println("DAO - comm slip pref : " +params.get("commSlipPref")+" // "+params.get("commSlipNo"));
		return params;
	}

	@Override
	public void confirmCommSlipPrinted(Map<String, Object> params)
			throws SQLException {
		String prnSuccess = (String) params.get("prnSuccess");
		log.info("Updating after successful printing["+prnSuccess+"]...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(prnSuccess.equals("Y")) {
				this.getSqlMapClient().update("confirmCSPrintingGIACS154", params);
				this.getSqlMapClient().executeBatch();
			}
			Integer tranId = (Integer) params.get("tranId");
			this.getSqlMapClient().update("resetCommSlipTags", tranId);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("GIAC_COMM_SLIP_EXT updated...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void updateCommSlipTag(List<GIACCommSlipExt> commSlip)
			throws SQLException {
		log.info("Updating comm slip tags...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIACCommSlipExt cs: commSlip) {
				System.out.println("DAO test - " + cs.getCommSlipTag());
				this.getSqlMapClient().update("updateCommSlipTags", cs);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("Comm Slip Tags updated...");
			this.getSqlMapClient().endTransaction();
		}
	}

}
