package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISIntmTypeDAO;
import com.geniisys.common.entity.GIISIntmType;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIntmTypeDAOImpl implements GIISIntmTypeDAO{
		/** The log. */
		private Logger log = Logger.getLogger(GIISIntmTypeDAOImpl.class);
		
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
		public JSONObject showIntmType(HttpServletRequest request,
				Map<String, Object> params) throws SQLException, JSONException {
			Map<String, Object> intmTypeableGrid = TableGridUtil
					.getTableGrid(request, params);
			JSONObject jsonIntmType = new JSONObject(intmTypeableGrid);
			return jsonIntmType;
		}
		
		@Override
		public Map<String, Object> valDelGIISS083IntmType(
				Map<String, Object> params) throws SQLException {
			HashMap<String, Object> param = new HashMap<String, Object>();	
			param.put("intmType", (String) params.get("intmType"));			
			param.put("result", this.sqlMapClient.queryForObject("valDelGIISS083IntmType",param));
			return param;
		}

		@SuppressWarnings("unchecked")
		@Override
		public Map<String, Object> saveIntmType(
				Map<String, Object> params) throws SQLException {
			String message = "SUCCESS";
			List<GIISIntmType> setRows = (List<GIISIntmType>) params.get("setRows");
			List<GIISIntmType> delRows = (List<GIISIntmType>) params.get("delRows");
			try {
				this.getSqlMapClient().startTransaction();
				this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				this.getSqlMapClient().startBatch();
				for(GIISIntmType del : delRows){
					this.sqlMapClient.delete("deleteInIntmType", del);
				}
				for(GIISIntmType set : setRows){					
					this.getSqlMapClient().insert("setIntmType", set);
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
		
		@SuppressWarnings("unchecked")
		public List<GIISIntmType> getIntmTypeGiiss203() throws SQLException{
			return (List<GIISIntmType>) this.sqlMapClient.queryForList("getIntmTypeGiiss203");
		}
		
		@Override
		public void valAddRec(String recId) throws SQLException {
			this.sqlMapClient.update("valAddIntmType", recId);		
		}
		
		@Override
		public void valDeleteRec(String recId) throws SQLException {
			this.sqlMapClient.update("valDeleteIntmType", recId);
		}

		@Override
		public String valUpdateIntmType(Map<String, Object> params) throws JSONException, SQLException { //Added by Jerome 08.11.2016 SR 5583
			return (String) this.getSqlMapClient().queryForObject("valUpdateIntmType", params);
		}
	}
