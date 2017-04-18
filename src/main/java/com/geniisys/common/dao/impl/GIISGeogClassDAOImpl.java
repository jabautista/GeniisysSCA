package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISGeogClassDAO;
import com.geniisys.common.entity.GIISGeogClass;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISGeogClassDAOImpl implements GIISGeogClassDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISGeogClassDAOImpl.class);
	
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
	public JSONObject showGeographyClass(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> geogClassTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonGeogClass = new JSONObject(geogClassTableGrid);
		return jsonGeogClass;
	}
	
	@Override
	public Map<String, Object> validateGeogCdInput(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("inputString", (String) params.get("inputString"));		
		param.put("result", this.sqlMapClient.queryForObject("validateGeogCdInput",param));
		return param;
	}
	
	@Override
	public Map<String, Object> validateGeogDescInput(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("inputString", (String) params.get("inputString"));		
		param.put("result", this.sqlMapClient.queryForObject("validateGeogDescInput",param));
		return param;
	}
	
	@Override
	public Map<String, Object> validateBeforeDelete(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();			
		param.put("geogCd", (String) params.get("geogCd"));	
		param.put("result", this.sqlMapClient.queryForObject("validateBeforeDelete",param));
		return param;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGeogClass(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GIISGeogClass> setRows = (List<GIISGeogClass>) params.get("setRows");
		List<GIISGeogClass> delRows = (List<GIISGeogClass>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISGeogClass del : delRows){
				this.sqlMapClient.delete("deleteInGeogClass", del);
			}
			for(GIISGeogClass set : setRows){					
				this.getSqlMapClient().insert("setGeogClass", set);
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
