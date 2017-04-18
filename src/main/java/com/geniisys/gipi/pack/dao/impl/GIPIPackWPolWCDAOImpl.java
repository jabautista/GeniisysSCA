package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.impl.GIPIWPolicyWarrantyAndClauseDAOImpl;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.dao.GIPIPackWPolWCDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIPIPackWPolWCDAOImpl implements GIPIPackWPolWCDAO {
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolicyWarrantyAndClauseDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void saveGIPIPackWPolWC(List<GIPIWPolicyWarrantyAndClause> setRows,
			List<GIPIWPolicyWarrantyAndClause> delRows) throws Exception {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.delPackWPolWC(delRows);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			this.setPackWPolWC(setRows);
			this.getSqlMapClient().executeBatch();
						
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("GIPI_Pack_WPolWC entry successfully saved.");
		
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> checkExistWPolwcPolWc(Map<String, Object> params)
			throws SQLException {
		Debug.print("Before: " + params);
		this.getSqlMapClient().queryForObject("existWPolwcPolwc", params);
		Debug.print("After: " + params);
		return params;
	}

	
	private void setPackWPolWC(List<GIPIWPolicyWarrantyAndClause> setRows) throws SQLException{
		if(setRows != null){
			for(GIPIWPolicyWarrantyAndClause wc : setRows){
				this.getSqlMapClient().insert("saveWPolWC", wc);
				this.getSqlMapClient().insert("setGIPIPackWPolWC", wc);
			}
		}
	}
	
	private void delPackWPolWC(List<GIPIWPolicyWarrantyAndClause> delRows) throws SQLException{
		if(delRows != null){
			for(GIPIWPolicyWarrantyAndClause wc : delRows){
				Map<String, Object> wcParam = new HashMap<String, Object>();
				
				wcParam.put("lineCd", wc.getLineCd());
				wcParam.put("parId", wc.getParId());
				wcParam.put("wcCd", wc.getWcCd());
				
				this.getSqlMapClient().delete("deleteWPolWC", wcParam);
				this.getSqlMapClient().delete("delGIPIPackWPolWC", wc);
			}
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGIPIPackWPolWC2(Map<String, Object> parameters)
			throws Exception {
		List<GIPIWPolicyWarrantyAndClause> delParams =  (List<GIPIWPolicyWarrantyAndClause>) parameters.get("delParams");
		List<GIPIWPolicyWarrantyAndClause> insParams =  (List<GIPIWPolicyWarrantyAndClause>) parameters.get("insParams");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.delPackWPolWC(delParams);
			
			if(insParams != null){
				for(GIPIWPolicyWarrantyAndClause polWC: insParams){
					this.getSqlMapClient().insert("saveWPolWC", polWC);
					this.getSqlMapClient().insert("setGIPIPackWPolWC", polWC);
				}
					log.info("DAO - Pack Warranty Clause/s inserted");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("GIPI_Pack_WPolWC entry successfully saved.");
		
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	/*@Override
	public void copyPackPolWCGiuts008a(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().insert("copyPackPolWCGiuts008a", params);
	}*/
}
