package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACUpdateCheckNumberDAO;
import com.geniisys.giac.dao.GIACUpdateCheckStatusDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACUpdateCheckNumberDAOImpl implements GIACUpdateCheckNumberDAO{
	
private static Logger log = Logger.getLogger(GIACUpdateCheckStatusDAO.class);
	
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
	public void validateCheckPrefSuf(Map<String, Object> params)throws SQLException {	
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> checkNos = (List<Map<String, Object>>) params.get("checkNos");
			for(Map<String, Object> c: checkNos){
				c.put("appUser", params.get("appUser"));
				this.getSqlMapClient().update("updateGIACS049CheckNo", c);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("validateGIACS049CheckPrefSuf", params);
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> validateCheckNo(Map<String, Object> params)throws SQLException {	
		this.getSqlMapClient().update("validateGIACS049CheckNo", params);
		return params;
	}

	@Override
	public String updateCheckNumber(Map<String, Object> params) throws SQLException {
		String msg = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> checkNos = (List<Map<String, Object>>) params.get("checkNos");
			for(Map<String, Object> c: checkNos){
				log.info("Updating Check Number of GACC_TRAN_ID: " + c.get("gaccTranId"));
				if (!c.get("chkNo").equals(c.get("checkPrefSuf")+"-"+c.get("checkNo"))){
					c.put("appUser", params.get("appUser"));
					this.getSqlMapClient().update("updateGIACS049CheckNo", c);
					msg = (String) c.get("msg");
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return msg;
	}
	

}
