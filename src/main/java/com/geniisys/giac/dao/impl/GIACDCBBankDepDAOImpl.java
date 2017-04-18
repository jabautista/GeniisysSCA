package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACDCBBankDepDAO;
import com.geniisys.giac.entity.GIACDCBBankDep;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACDCBBankDepDAOImpl implements GIACDCBBankDepDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACDCBBankDepDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDCBBankDepDAO#getGdbdListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGdbdListTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGdbdListTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDCBBankDepDAO#populateGDBD(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> populateGDBD(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("populateGiacs035Gdbd", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveDCBForClosing(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> savedParam = new HashMap<String, Object>();
		Map<String, Object> params42; // dren 08.03.2015 : SR 0017729 - Adding Acct Entries
		
		try {
			Map<String, Object> accTransMap = (Map<String, Object>) params.get("setAccTrans");
			List<GIACDCBBankDep> addBankDep = (List<GIACDCBBankDep>) params.get("setGDBDRows");
			List<GIACDCBBankDep> delBankDep = (List<GIACDCBBankDep>) params.get("delGDBDRows");
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String isNew = (String) params.get("isNew");
			Integer tranId = 0;
			
			// saves a new record to acc trans
			//tranId = (Integer) this.getSqlMapClient().queryForObject("giacTranIdFromAccTrans", "");
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().queryForObject("saveAccTransDCBClosing", accTransMap);
			this.getSqlMapClient().executeBatch();
			System.out.println("Test tran id - "+accTransMap.get("gaccTranId"));
			if(isNew.equals("Y")) {  //moved condition - Halley 11.22.13
				tranId = (Integer) accTransMap.get("gaccTranId");
			}
			savedParam = accTransMap;
			if (accTransMap.get("mesg").equals("Y")) {  //Deo [03.02.2017]: SR-5939
			this.getSqlMapClient().startBatch();
			log.info("Deleting records from GIAC_DCB_BANK_DEP...");
			for(GIACDCBBankDep d: delBankDep) {
				this.getSqlMapClient().delete("deleteGIACDCBBankDep", d);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			log.info("Saving to GIAC_DCB_BANK_DEP");
			for(GIACDCBBankDep gdbd : addBankDep) {
				if(gdbd.getGaccTranId() < 1 && isNew.equals("Y")) {
					gdbd.setGaccTranId(tranId);
				}				
				this.getSqlMapClient().insert("setGIACDCBBankDep", gdbd);
			}
			
			this.getSqlMapClient().executeBatch();
				
			this.getSqlMapClient().startBatch();
			log.info("Updating giac_colln_batch for dcb closing...");
			this.getSqlMapClient().update("updateDCBForClosing", accTransMap);
			this.getSqlMapClient().executeBatch();
			
			String gaccBranchCd = (String) params.get("gaccBranchCd"); // dren 08.03.2015 : SR 0017729 - Adding Acct Entries - Start
			String gaccFundCd = (String) params.get("gaccFundCd");
			Integer gaccTranId = (Integer) accTransMap.get("gaccTranId");			
			String moduleName = (String) params.get("moduleName");		 
			
			params42 = new HashMap<String, Object>();
			params42.put("appUser", params.get("userId"));
			params42.put("gaccBranchCd", gaccBranchCd);
			params42.put("gaccFundCd", gaccFundCd);
			params42.put("gaccTranId", gaccTranId);
			params42.put("moduleName", moduleName);
			
			this.getSqlMapClient().startBatch();
			log.info("Saving to giac_acct_entries...");
			this.getSqlMapClient().update("aegParametersGiacs042",params42);
			this.getSqlMapClient().executeBatch(); // dren 08.03.2015 : SR 0017729 - Adding Acct Entries - End
			
			this.getSqlMapClient().getCurrentConnection().commit();
			}  //Deo [03.02.2017]: SR-5939
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return savedParam;
	}

	@Override
	public void refreshDCB(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().update("refreshDCB", params);
		}catch(SQLException e){
			throw e;
		}
	}	
}
