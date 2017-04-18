package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giac.dao.GIACSpoiledOrDAO;
import com.geniisys.giac.entity.GIACSpoiledOr;
import com.geniisys.gipi.dao.impl.GIPIWInvoiceDAOImpl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACSpoiledOrDAOImpl implements GIACSpoiledOrDAO {

	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWInvoiceDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACSpoiledOrDAO#getGIACSpoiledOrListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACSpoiledOr> getGIACSpoiledOrListing(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIACSpoiledOrListing", params);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveSpoiledOrDtls(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		try {
			List<Map<String, Object>> addedSpoiledOr = (List<Map<String, Object>>) (params.get("addedSpoiledOr"));
			List<Map<String, Object>> modifiedSpoiledOr = (List<Map<String, Object>>) (params.get("modifiedSpoiledOr"));
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//added dtls
			for(Map<String, Object> spoiledOrDtls: addedSpoiledOr){
				Debug.print("Map of inserted info: " + spoiledOrDtls);
				this.sqlMapClient.insert("saveSpoiledOrDtls", spoiledOrDtls);
				log.info("DAO - GIACSpoiledOr inserted.");
			}
			
			//updated dtls
			for(Map<String, Object> spoiledOrDtls: modifiedSpoiledOr){
				Debug.print("Map of updated info: " + spoiledOrDtls);
				this.sqlMapClient.insert("saveSpoiledOrDtls", spoiledOrDtls);
				log.info("DAO - GIACSpoiledOr updated.");
			}
		
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public String validateSpoiledOr(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("validateSpoiledOrNo", params);
	}

}
