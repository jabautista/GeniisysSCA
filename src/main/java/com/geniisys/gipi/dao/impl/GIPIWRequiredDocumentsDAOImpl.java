/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWRequiredDocumentsDAO;
import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;
import com.geniisys.gipi.entity.GIPIWRequiredDocuments;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWRequiredDocumentsDAOImpl.
 */
public class GIPIWRequiredDocumentsDAOImpl implements GIPIWRequiredDocumentsDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWRequiredDocuments.class);

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWRequiredDocumentsDAO#getReqDocsList(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWRequiredDocuments> getReqDocsList(Integer parId)
			throws SQLException {
		log.info("Getting required documents list...");
		return this.getSqlMapClient().queryForList("getWReqDocsList", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWRequiredDocumentsDAO#deleteWReqDoc(java.lang.Integer, java.lang.String)
	 */
	@Override
	public void deleteWReqDoc(Integer parId, String docCd) throws SQLException {
		log.info("Deleting document...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("docCd", docCd);
		this.getSqlMapClient().queryForObject("deleteWReqDoc", params);
		log.info("Successfully deleted.");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWRequiredDocumentsDAO#insertWReqDoc(java.util.Map)
	 */
	@Override
	public void insertWReqDoc(Map<String, Object> params) throws SQLException {
		log.info("Inserting document...");
		this.getSqlMapClient().insert("insertWReqDoc", params);
		log.info("Insert successful...");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWReqDocs(Map<String, Object> params)
			throws SQLException {
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Integer parId = (Integer) params.get("parId");
			
			//deleting 
			Map<String, Object> delDocs = (Map<String, Object>) params.get("delDocs");
			String[] delDocCds = (String[]) delDocs.get("delDocCds");
			if (delDocCds != null){
				for (int i=0; i<delDocCds.length; i++){
					Map<String, Object> docMap = (Map<String, Object>) delDocs.get(delDocCds[i]);
					String docCd = (String) docMap.get("docCd");
					this.deleteWReqDoc(parId, docCd);
				}
			}
			
			//inserting and updating
			Map<String, Object> insDocs = (Map<String, Object>) params.get("insDocs");
			String[] insDocCds = (String[]) insDocs.get("insDocCds");
			if (insDocCds != null){
				for (int i=0; i<insDocCds.length; i++){
					Map<String, Object> docMap = (Map<String, Object>) insDocs.get(insDocCds[i]);
					log.info("docCd in DAO: "+docMap.get("docCd"));
					this.insertWReqDoc(docMap);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	//created by agazarraga 5/11/2012 for tablegrid conversion [saving]
	public void saveGIPISReqDocs(
			Map<String, List<GIPIWRequiredDocuments>> params) throws SQLException {
		List<GIPIWRequiredDocuments> setRDList = params.get("setReqDoc");
		List<GIPIWRequiredDocuments> delRDList = params.get("delReqDoc");
		try {
			log.info("Starting transaction...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if (!delRDList.isEmpty()) {
				log.info("Deleting Required Documents...");
				for (GIPIWRequiredDocuments rd : delRDList) {
					log.info("Deleting Record: "
							+ (new JSONObject(rd)).toString());
					Map<String, Object> rec = new HashMap<String, Object>();
					rec.put("parId", rd.getParId());
					rec.put("docCd", rd.getDocCd());
					this.getSqlMapClient().delete("deleteWReqDoc", rec);
				}
				log.info("Finished deleting records.");
			}

			if (!setRDList.isEmpty()) {
				log.info("Saving Required Documents...");
				for (GIPIWRequiredDocuments wc : setRDList) {
					log.info("Saving Record: "
							+ (new JSONObject(wc)).toString());
					this.getSqlMapClient().insert("insertWReqDoc", wc);
				}
				log.info("Finished inserting/updating records.");
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Transaction commited, finished.");
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error(e.getStackTrace());
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
