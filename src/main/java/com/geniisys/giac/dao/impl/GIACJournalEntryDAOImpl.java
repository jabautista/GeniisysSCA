package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACJournalEntryDAO;
import com.geniisys.giac.entity.GIACJournalEntry;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author steven
 * @date 03.18.2013
 */
public class GIACJournalEntryDAOImpl implements GIACJournalEntryDAO {
	
	private static Logger log = Logger.getLogger(GIACJournalEntryDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACJournalEntry> getJournalEntries(Map<String, Object> params)
			throws SQLException {
		List<GIACJournalEntry> journalEntries = new ArrayList<GIACJournalEntry>();
		journalEntries = this.getSqlMapClient().queryForList((String) params.get("ACTION"),params);
		return journalEntries;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object getNewJournalEntries(Map<String, Object> params)
			throws SQLException {
		List<GIACJournalEntry> newJournalEntries = new ArrayList<GIACJournalEntry>();
		newJournalEntries = this.getSqlMapClient().queryForList("createJournalEntries",params);
		return newJournalEntries;
	}

	@Override
	public String checkORInfo(String tranId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkORInfo",tranId);
	}

	@Override
	public String getGIACParamValue(String paramName) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGIACParamValue",paramName);
	}
	
	@Override
	public String getPbranchCd(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPbranchCd",userId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> setGiacAcctrans(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			List<Map<String, Object>> setGiacAcctrans = (List<Map<String, Object>>) params.get("setGiacAcctrans");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			if(setGiacAcctrans != null){
				for(Map<String, Object> giacJournalEntry: setGiacAcctrans){
					log.info("Saving Enter Journal Entries. Tran ID:" + giacJournalEntry.get("tranId"));
					this.getSqlMapClient().insert("setGIACS003GiacAcctrans", giacJournalEntry);
				}
				log.info("DAO - Enter Journal Entries inserted.");
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return setGiacAcctrans;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getJVTranType(String jvTranTag) throws SQLException {
		List<Map<String, Object>> jvTranTypeList = new ArrayList<Map<String,Object>>();
		jvTranTypeList.add((Map<String, Object>) getSqlMapClient().queryForObject("getJVTranType",jvTranTag));
		return jvTranTypeList;
	}

	@Override
	public String validateTranDate(Map<String, Object> params) throws SQLException {
		return (String) getSqlMapClient().queryForObject("getClosedTag",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object printOpt(Integer tranId) throws SQLException {
		List<Map<String, Object>> printOptList = new ArrayList<Map<String, Object>>();
		printOptList = this.getSqlMapClient().queryForList("printOpt",tranId);
		return printOptList;
	}

	@Override
	public String checkUserPerIssCdAcctg(Map<String, Object> params)
			throws SQLException {
		return (String) getSqlMapClient().queryForObject("giacs003CheckUserPerIssCdAcctg",params);
	}

	@Override
	public String checkCommPayts(String tranId) throws SQLException {
		return (String) getSqlMapClient().queryForObject("giacs003CheckCommPayts",tranId);
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> saveCancelOpt(Map<String, Object> cancelOptParams)
			throws SQLException, Exception{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> setCancelOpt = (List<Map<String, Object>>) cancelOptParams.get("setCancelOpt");
			if (setCancelOpt != null) {
				for (Map<String, Object> cancelOpt : setCancelOpt) {
					log.info("Saving  Cancel JV. Tran ID:" + cancelOpt.get("tranId"));
					this.getSqlMapClient().insert("saveCancelOpt", cancelOpt);
					log.info("DAO - Record had been Cancelled.");
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return setCancelOpt;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String getDetailModule(String tranId) throws SQLException {
		return (String) getSqlMapClient().queryForObject("getDetailModule",tranId);
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> showDVInfo(Map<String, Object> dvInfoParams)
			throws SQLException, Exception {
			List<Map<String, Object>> dvInfoList = (List<Map<String, Object>>) dvInfoParams.get("dvInfoParams");
			if (dvInfoList != null) {
				for (Map<String, Object> dvInfo : dvInfoList) {
					System.out.println("Tran ID: " + dvInfo.get("tranId"));
					this.getSqlMapClient().queryForList("showDVInfo", dvInfo);
				}
			}
			return dvInfoList;
	}

	@Override
	public String validateJVCancel(String tranId) throws SQLException, Exception {
		return (String) this.getSqlMapClient().queryForObject("validateJVCancel", tranId);
	}
}
