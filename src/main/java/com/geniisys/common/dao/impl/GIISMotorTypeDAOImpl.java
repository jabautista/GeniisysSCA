package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISMotorTypeDAO;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISMotorType;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMotorTypeDAOImpl implements GIISMotorTypeDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISMotorTypeDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
		
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
	public JSONObject showSubline(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> vessClassTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonMotorType = new JSONObject(vessClassTableGrid);
		return jsonMotorType;
	}
	
	@Override
	public JSONObject showMotorType(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> motorTypeTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonMotorType = new JSONObject(motorTypeTableGrid);
		return jsonMotorType;
	}
	
	@Override
	public Map<String, Object> validateGIISS055MotorType(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();			
		param.put("typeCd", (String) params.get("typeCd"));	
		param.put("sublineCd", (String) params.get("sublineCd"));	
		param.put("result", this.sqlMapClient.queryForObject("validateGIISS055MotorType",param));
		return param;
	}
	
	@Override
	public Map<String, Object> chkDeleteGIISS055MotorType(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();			
		param.put("typeCd", (String) params.get("typeCd"));	
		param.put("sublineCd", (String) params.get("sublineCd"));	
		param.put("result", this.sqlMapClient.queryForObject("chkDeleteGIISS055MotorType",param));
		return param;
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGiiss055(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GIISMotorType> setRows = (List<GIISMotorType>) params.get("setRows");
		List<GIISMotorType> delRows = (List<GIISMotorType>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISMotorType del : delRows){
				this.sqlMapClient.delete("deleteInMotorType", del);
			}
			for(GIISMotorType set : setRows){	
				this.getSqlMapClient().insert("setMotorType", set);
			}				
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}
}
