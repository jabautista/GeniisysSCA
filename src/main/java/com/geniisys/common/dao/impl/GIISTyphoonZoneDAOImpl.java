package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISTyphoonZoneDAO;
import com.geniisys.common.entity.GIISTyphoonZone;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTyphoonZoneDAOImpl implements GIISTyphoonZoneDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISTyphoonZoneDAOImpl.class);
	
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
	public JSONObject showTyphoonZoneMaintenance(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> typhoonZoneTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonTyphoonZone = new JSONObject(typhoonZoneTableGrid);
		return jsonTyphoonZone;
	}

	@Override
	public Map<String, Object> validateTyphoonZoneInput(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("txtField", (String) params.get("txtField"));
		param.put("inputString", (String) params.get("inputString"));		
		param.put("result", this.sqlMapClient.queryForObject("validateTyphoonZoneInput",param));
		return param;
	}
	
	@Override
	public Map<String, Object> validateDeleteTyphoonZone(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("typhoonZone", (String) params.get("typhoonZone"));		
		param.put("result", this.sqlMapClient.queryForObject("validateDeleteTyphoonZone",param));
		return param;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveTyphoonZoneMaintenance(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		List<GIISTyphoonZone> setRows = (List<GIISTyphoonZone>) params.get("setRows");
		List<GIISTyphoonZone> delRows = (List<GIISTyphoonZone>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISTyphoonZone del : delRows){
				this.sqlMapClient.delete("deleteInTyphoonZone", del);
			}
			for(GIISTyphoonZone set : setRows){					
				this.getSqlMapClient().insert("setTyphoonZone", set);
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
