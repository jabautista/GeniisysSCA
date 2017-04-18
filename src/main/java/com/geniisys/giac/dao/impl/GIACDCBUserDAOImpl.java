/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACDCBUserDAO;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.gipi.dao.impl.GIPIPARListDAOImpl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACDCBUserDAOImpl implements GIACDCBUserDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPARListDAOImpl.class);
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
		
	}
	@Override
	public  GIACDCBUser getDCBCashierCd(String fundCd, String branchCd, String userId) throws SQLException {
		log.info("Get Dcb Cashier Code");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fundCd", fundCd);
		param.put("branchCd", branchCd);
		param.put("appUser", userId);
		return (GIACDCBUser) this.getSqlMapClient().queryForObject("getDCBCashierCd", param);
	}

	@Override
	public GIACDCBUser getValidUSerInfo(String fundCd, String branchCd, String userId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fundCd", fundCd);
		param.put("branchCd", branchCd);
		param.put("appUser", userId);

		return (GIACDCBUser) this.getSqlMapClient().queryForObject("getValidUserInfo", param);
	}

	@Override
	public String checkIfDcbUserExists(String userId) throws SQLException {
		log.info("Checking if user exists in DCB_USERS...");
		return (String) this.getSqlMapClient().queryForObject("checkIfDcbUserExists", userId) ;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs319(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACDCBUser> delList = (List<GIACDCBUser>) params.get("delRows");
			for(GIACDCBUser d: delList){
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("gibrFundCd", d.getGibrFundCd());
				p.put("gibrBranchCd", d.getGibrBranchCd());
				p.put("cashierCd", d.getCashierCd());
				p.put("dcbUserId", d.getDcbUserId());
				this.sqlMapClient.update("delDCBUser", p);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACDCBUser> setList = (List<GIACDCBUser>) params.get("setRows");
			for(GIACDCBUser s: setList){
				String validTag = s.getValidTag().equals("Yes") ? "Y" : "N";
				s.setValidTag(validTag);
				this.sqlMapClient.update("setDCBUser", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteDCBUser", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDCBUser", params);		
	}
}
