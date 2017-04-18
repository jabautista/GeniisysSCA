/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao.impl
	File Name: GIACChkReleaseInfo.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 20, 2012
	Description: 
*/


package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.giac.dao.GIACChkReleaseInfoDAO;
import com.geniisys.giac.entity.GIACChkReleaseInfo;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACChkReleaseInfoDAOImpl extends DAOImpl implements GIACChkReleaseInfoDAO{
	private static Logger log = Logger.getLogger(GIACDisbVouchersDAOImpl.class);
	private SqlMapClient sqlMapClient;
	String message = "";
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public GIACChkReleaseInfo getgiacs016ChkReleaseInfo(
			Integer gaccTranId, Integer itemNo) throws SQLException {
		log.info("RETRIEVING GIAC_CHK_RELEASE_INFO");
		Map<String , Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", gaccTranId);
		params.put("itemNo", itemNo);
		return (GIACChkReleaseInfo) getSqlMapClient().queryForObject("getgiacs016ChkReleaseInfo", params);
	}
	@Override
	public String saveCheckReleaseInfo(Map<String, Object> params)
			throws SQLException {
		log.info("save check release info");
		String message = "SUCCESS";
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			this.getSqlMapClient().insert("saveCheckReleaseInfo", params);
			
			this.getSqlMapClient().executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public GIACChkReleaseInfo getGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException {
		return (GIACChkReleaseInfo) this.getSqlMapClient().queryForObject("getgiacs002ChkReleaseInfo", params);
	}

	@Override
	public String saveGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException, Exception {
		String message = "SUCCESS";
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("DAO - Start of saving check relese information...");
			this.getSqlMapClient().insert("saveGIACS002ChkReleaseInfo", params);
						
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();		
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of saving check release info.");
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
}
