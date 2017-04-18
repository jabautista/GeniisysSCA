/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.dao.impl
	File Name: GIACBatchDVDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 8, 2011
	Description: 
*/


package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.giac.dao.GIACBatchDVDAO;
import com.geniisys.giac.entity.GIACBatchDV;

public class GIACBatchDVDAOImpl extends DAOImpl implements GIACBatchDVDAO {
	private static Logger log = Logger.getLogger(GIACBatchDVDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBatchDV> getSpecialCSRListing(Map<String, Object>params)
			throws SQLException {
		log.info("RETRIEVING SPECIAL CSR LISTING, USER: "+params.get("userId"));
		return this.getSqlMapClient().queryForList("getSpecialCSRListing", params);
	}

	@Override
	public void cancelGIACBatch(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("CANCELLING BATCH DV ID: "+params.get("batchDvId"));
			this.getSqlMapClient().update("cancelGIACBatch", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Map<String, Object> getGIACS086AcctEntPostQuery(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIACS086AcctEntPostQuery", params);
		return params ;
	}
	
	public Map<String, Object> getGIACS087AcctEntTotals(Map<String, Object> params) throws SQLException {
		Map<String, Object> res = new HashMap<String, Object>();
		res = (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs087AcctEntTotals", params);
		return res;
	}	
	
}
