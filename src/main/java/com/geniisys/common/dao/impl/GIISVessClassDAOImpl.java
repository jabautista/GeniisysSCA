package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCargoTypeDAO;
import com.geniisys.common.dao.GIISVessClassDAO;
import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.common.entity.GIISVessClass;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISVessClassDAOImpl implements GIISVessClassDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISVessClassDAOImpl.class);
	
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
	public JSONObject showVesselClassification(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> vessClassTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonVessClass = new JSONObject(vessClassTableGrid);
		return jsonVessClass;
	}

	@Override
	public Map<String, Object> validateGIISS047VesselClass(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();			
		param.put("vessClassCd", (String) params.get("vessClassCd"));	
		param.put("result", this.sqlMapClient.queryForObject("validateGIISS047VesselClass",param));
		return param;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveVessClass(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GIISVessClass> setRows = (List<GIISVessClass>) params.get("setRows");
		List<GIISVessClass> delRows = (List<GIISVessClass>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();		
			for(GIISVessClass set : setRows){	
				this.getSqlMapClient().insert("setVessClass", set);
			}				
			
			for(GIISVessClass del : delRows){
				this.getSqlMapClient().update("delVessClass", del);
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

	@Override
	public void valDelRec(Integer vessClassCd) throws SQLException {
		this.getSqlMapClient().update("valDelVessClass", vessClassCd);
	}	
}
	