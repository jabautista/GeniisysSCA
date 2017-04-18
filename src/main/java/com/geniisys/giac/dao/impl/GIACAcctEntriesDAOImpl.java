package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACAcctEntriesDAO;
import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACGlAcctRefNo;	//Gzelle 11102015 KB#132 AP/AR ENH
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAcctEntriesDAOImpl implements GIACAcctEntriesDAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIACAcctEntriesDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACAcctEntries> getAcctEntries(Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving Acct Entries List...");
		List<GIACAcctEntries> acctEntries = this.sqlMapClient.queryForList("getGiacAcctEntries2", params); //change by steven 05.17.2013; from: getGiacAcctEntries  to: getGiacAcctEntries2
		log.info("DAO - " + acctEntries.size() + " Acct Entries acquired");
		return acctEntries;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getGlAcctsListing(Map<String, Object> acctEntry)
			throws SQLException {
		log.info("DAO - Retrieving chart of accounts");
		List<GIACChartOfAccts> glAccts = this.sqlMapClient.queryForList("getGlAcctListing3", acctEntry);
		log.info("DAO - " + glAccts.size() + " chart of account/s retrieved...");
		return glAccts;
	}


	@SuppressWarnings("unchecked")
	@Override
	public void saveAcctEntries(Map<String, Object> params) throws SQLException {
		try {
			List<Map<String, Object>> delParams = (List<Map<String, Object>>) params.get("delAcctEntries");
			List<GIACAcctEntries> setParam = (List<GIACAcctEntries>) params.get("addAcctEntries");
			List<GIACGlAcctRefNo> setGlAcctRefNo = (List<GIACGlAcctRefNo>) params.get("addGlAcctRefNo");	//Gzelle 11102015 KB#132 AP/AR ENH
			List<GIACGlAcctRefNo> delGlAcctRefNo = (List<GIACGlAcctRefNo>) params.get("delGlAcctRefNo");	//Gzelle 12162015 KB#132 AP/AR ENH
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("DAO - Deleting Accounting Entries...");
			Map<String, Object> dParam = new HashMap<String, Object>();
			for(int i=0; i<delParams.size(); i++) {
				dParam.clear();
				dParam.put("gaccTranId", delParams.get(i).get("gaccTranId"));
				dParam.put("acctEntryId", delParams.get(i).get("acctEntryId"));
				this.getSqlMapClient().delete("delAcctEntry", dParam);
			}
			this.getSqlMapClient().executeBatch();

			/*start - Gzelle 12162015 KB#132 AP/AR ENH*/
			log.info("DAO - Deleting " + delGlAcctRefNo.size() + " gl account ref no...");
			for(GIACGlAcctRefNo delGl: delGlAcctRefNo) {
				this.getSqlMapClient().delete("delGlAcctRefNo", delGl);
			}
			this.getSqlMapClient().executeBatch();
			/*end - Gzelle 12162015 KB#132 AP/AR ENH*/
			
			log.info("DAO - Adding " + setParam.size() + " accounting entries...");
			for(GIACAcctEntries ae: setParam) {
				this.getSqlMapClient().insert("saveAcctEntry", ae);
			}
			this.getSqlMapClient().executeBatch();
			
			/*start - Gzelle 11102015 KB#132 AP/AR ENH*/
			log.info("DAO - Checking no. of gl acct ref no records : " + setGlAcctRefNo.size() + " ...");
			if (setGlAcctRefNo.size() != 0) {
				log.info("DAO - Adding " + setGlAcctRefNo.size() + " gl account ref no...");
				for(GIACGlAcctRefNo gl: setGlAcctRefNo) {
					this.getSqlMapClient().insert("setGlAcctRefNo", gl);
				}
				this.getSqlMapClient().executeBatch();				
			}
			/*end - Gzelle 11102015 KB#132 AP/AR ENH*/
			
			this.getSqlMapClient().getCurrentConnection().commit();
			System.out.println("DAO - Accounting entries saved...");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
	}

	@SuppressWarnings("unchecked")
	@Override
	public void delAcctEntries(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> delParams = (List<Map<String, Object>>) params.get("delAcctEntries");
			log.info("DAO - Deleting Accounting Entries...");
			Map<String, Object> dParam = new HashMap<String, Object>();
			for(int i=0; i<delParams.size(); i++) {
				dParam.clear();
				dParam.put("gaccTranId", delParams.get(i).get("gaccTranId"));
				dParam.put("acctEntryId", delParams.get(i).get("acctEntryId"));
				this.getSqlMapClient().delete("delAcctEntry", dParam);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("DAO - Accounting Entries Deleted");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException {
		return this.getSqlMapClient().queryForList("getChartOfAccts");
	}

	@Override
	public Map<String, Object> closeTransaction(Map<String, Object> params) throws SQLException {
		//this.getSqlMapClient().update("updateAcctTransGiacs030", gaccTranId);\
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			int gaccTranId = (Integer) params.get("gaccTranId");
			log.info("DAO - Closing Transaction...");
			List<GIACAcctEntries> acctEntries = this.getAcctEntries(params);
			for(GIACAcctEntries ae: acctEntries) {
				this.getSqlMapClient().update("updateSeqNoGIACS030", ae);
				this.getSqlMapClient().update("updateSeqNoCMDMGIACS030", ae);
			}
			//this.getSqlMapClient().update("updateAcctTransGiacs030", params);
			this.getSqlMapClient().queryForObject("updateAcctTransGiacs030", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("DAO - Transaction " + gaccTranId + " has been closed...");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
		return params;
	}

	@Override
	public Map<String, Object> checkManualAcctEntry(Map<String, Object> params)
			throws SQLException {
		log.info("Retrieving parameters for checking manual entry...");
		this.getSqlMapClient().queryForObject("checkManualAcctEntry", params);
		return params;
	}

	@Override
	public String checkGIACS060GLTrans(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGIACS060GLTrans", params);
	}
}
