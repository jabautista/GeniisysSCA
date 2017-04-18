package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACMemoDAO;
import com.geniisys.giac.entity.GIACMemo;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACMemoDAOImpl implements GIACMemoDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACMemoDAOImpl.class);
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public GIACMemo getDefaultMemo() throws SQLException {
		log.info("Retrieving default values of memo...");
		return (GIACMemo) this.getSqlMapClient().queryForObject("getDefaultMemo");
	}
	
	@Override
	public GIACMemo saveMemo(Map<String, Object> params) throws SQLException, Exception {
		System.out.println("PARAMS: " + params);
		GIACMemo memo = (GIACMemo) params.get("memo");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//this.getSqlMapClient().startBatch();
			
			// 1. insert memo into acctrans
			log.info("DAO - Inserting into acctrans...");
			//this.getSqlMapClient().insert("insertMemoIntoAcctrans", memo);
			this.getSqlMapClient().update("insertMemoIntoAcctrans", memo);
			System.out.println("returnd gacctranid: " + memo.getGaccTranId());
			log.info("DAO - Inserting into acctrans done.");
			
			// 2. save memo
			log.info("DAO - Inserting into giac_cm_dm...");
			this.getSqlMapClient().update("saveMemo", memo);			
			log.info("DAO - Inserting into giac_cm_dm done.");
			
			// 3. do post-forms-commit
			log.info("DAO - Post-Forms-Commit begin...");
			this.getSqlMapClient().update("doPostFormsCommitGIACS071", params);
			log.info("DAO - Post-Forms-Commit done.");
			
			//this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}finally{
			log.info("End of saving memo.");
			this.getSqlMapClient().endTransaction();
		}
		return memo;
	}
	
	
	@Override
	public Integer getNextTranId() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNextTranId");
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACMemo> getMemoList(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getMemoList", params);
	}
	
	@Override
	public GIACMemo getMemoInfo(Map<String, Object> params) throws SQLException {
		return (GIACMemo) this.getSqlMapClient().queryForObject("getGIACMemoInfo", params);
	}
	
	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getClosedTagGIACS071", params);
	}
	
	@Override
	public String cancelMemo(Map<String, Object> params) throws SQLException, Exception {
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("DAO - Cancelling memo...");
			this.getSqlMapClient().update("cancelMemo", params);
			
			System.out.println("Returned message: " + params.get("message"));
			message = (String) params.get("message");
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}finally{
			log.info("End of cancelling memo.");
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
	@Override
	public void updateMemoStatus(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("PARAMS for update memo status: " + params);
			
			log.info("DAO - Updating memo status...");
			this.getSqlMapClient().update("updateMemoStatus", params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}finally{
			log.info("End of cancelling memo.");
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String validateCurrSname(String currSname) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateCurrSname", currSname);
	}
	
	
}
