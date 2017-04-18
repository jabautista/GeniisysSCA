package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.impl.GIISClmStatDAOImpl;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLDrvrOccptnDAO;
import com.geniisys.gicl.entity.GICLDrvrOccptn;
import com.geniisys.gicl.entity.GICLReasons;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLDrvrOccptnDAOImpl implements GICLDrvrOccptnDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISClmStatDAOImpl.class);
	
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
	public JSONObject showDrvrOccptnMaintenance(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> drvrOccptnTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonDrvrOccptn = new JSONObject(drvrOccptnTableGrid);
		return jsonDrvrOccptn;
	}

	@Override
	public Map<String, Object> validateDrvrOccptnInput(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();		
		param.put("inputString", (String) params.get("inputString"));		
		param.put("result", this.sqlMapClient.queryForObject("validateDrvrOccptnInput",param));
		return param;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveDrvrOccptnMaintenance(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		List<GICLDrvrOccptn> setRows = (List<GICLDrvrOccptn>) params.get("setRows");
		List<GICLDrvrOccptn> delRows = (List<GICLDrvrOccptn>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GICLDrvrOccptn del : delRows){
				this.sqlMapClient.delete("deleteInDrvrOccptn", del);
			}
			for(GICLDrvrOccptn set : setRows){					
				this.getSqlMapClient().insert("setDrvrOccptn", set);
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
