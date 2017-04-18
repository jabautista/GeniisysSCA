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
import com.geniisys.common.entity.GIISCargoType;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCargoTypeDAOImpl implements GIISCargoTypeDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISCargoTypeDAOImpl.class);
	
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
	public JSONObject showCargoClass(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> cargoClassTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonCargoClass = new JSONObject(cargoClassTableGrid);
		return jsonCargoClass;
	}
	
	@Override
	public JSONObject showCargoType(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> cargoTypeTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonCargoType = new JSONObject(cargoTypeTableGrid);
		return jsonCargoType;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveCargoType(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GIISCargoType> setRows = (List<GIISCargoType>) params.get("setRows");
		List<GIISCargoType> delRows = (List<GIISCargoType>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISCargoType del : delRows){
				this.sqlMapClient.delete("deleteInCargoType", del);
			}
			for(GIISCargoType set : setRows){					
				this.getSqlMapClient().insert("setCargoType", set);
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
	public Map<String, Object> validateCargoType(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("cargoType", (String) params.get("cargoType"));			
		param.put("result", this.sqlMapClient.queryForObject("validateCargoType",param));
		return param;
	}

	@Override
	public Map<String, Object> chkDeleteGIISS008CargoType(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();			
		param.put("cargoType", (String) params.get("cargoType"));	
		param.put("result", this.sqlMapClient.queryForObject("chkDeleteGIISS008CargoType",param));
		return param;
	}
}
