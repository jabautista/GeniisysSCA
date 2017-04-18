package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.dao.GIACTranMmDAO;
import com.geniisys.giac.entity.GIACTranMm;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTranMmDAOImpl implements GIACTranMmDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACTranMmDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACTranMm> getClosedTransactionMonthYear(Map<String, Object> params)	throws SQLException {
		log.info("getClosedTransactionMonthYear");
		return (List<GIACTranMm>) sqlMapClient.queryForList("getClosedTransactionMonthYear", params);
	}

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

	@Override
	public String checkBookingDate(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkBookingDate", params);
	}

	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		return  (String) this.getSqlMapClient().queryForObject("getClosedTag2", params);
	}
	
	public String checkFunctionGiacs038(Map<String, Object> params) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("checkFunctionGiacs038", params);
	}
	
	public Integer getNextTranYrGiacs038(Map<String, Object> params) throws SQLException{
		return (Integer) this.getSqlMapClient().queryForObject("getNextTranYrGiacs038", params);
	}
	
	public Integer checkTranYrGiacs038(Map<String, Object> params) throws SQLException{
		return (Integer) this.getSqlMapClient().queryForObject("checkTranYrGiacs038", params);
	}
	
	public String generateTranMmGiacs038(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			

			this.getSqlMapClient().update("generateTranMmGiacs038", params);	
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "Success";
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Success" ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;	
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs038(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			
			List<GIACTranMm> setList = (List<GIACTranMm>) params.get("setRows");
			for(GIACTranMm s: setList){
				this.sqlMapClient.update("updateTranMm", s);
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

}
