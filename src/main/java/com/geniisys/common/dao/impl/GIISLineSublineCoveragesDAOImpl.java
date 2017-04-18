package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISLineSublineCoveragesDAO;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIISLineSublineCoveragesDAOImpl implements GIISLineSublineCoveragesDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISLineSublineCoveragesDAOImpl.class);
	
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
	public JSONObject showPackageLineSublineCoverage(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> packageLineSublineCoverageTableGrid = StringFormatter.escapeHTMLInMap(TableGridUtil
				.getTableGrid(request, params));		
		JSONObject jsonPkgLineSublineCvrg = new JSONObject(packageLineSublineCoverageTableGrid);
		return jsonPkgLineSublineCvrg;
	}
	
	@Override
	public JSONObject showPackageLineCoverage(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> packageLineCoverageTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonPkgLineCvrg = new JSONObject(packageLineCoverageTableGrid);
		return jsonPkgLineCvrg;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGiiss096(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GIISLineSublineCoverages> setRows = (List<GIISLineSublineCoverages>) params.get("setRows");
		List<GIISLineSublineCoverages> delRows = (List<GIISLineSublineCoverages>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISLineSublineCoverages del : delRows){
				this.sqlMapClient.delete("deleteInPkgLineSublineCvrg", del);
			}
			for(GIISLineSublineCoverages set : setRows){					
				this.getSqlMapClient().insert("setPkgLineSublineCvrg", set);
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
	public void valDeleteRec(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("lineCd", (String) params.get("lineCd"));
		param.put("packLineCd", (String) params.get("packLineCd"));
		param.put("packSublineCd", (String) params.get("packSublineCd"));		
		this.sqlMapClient.update("valDeleteRecPkgLineSubline",param);
	}
	
	@Override
	public void valAddRec(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("lineCd", (String) params.get("lineCd"));
		param.put("packLineCd", (String) params.get("packLineCd"));
		param.put("packSublineCd", (String) params.get("packSublineCd"));		
		this.sqlMapClient.update("valAddRecPkgLineSubline",param);
	}
}
