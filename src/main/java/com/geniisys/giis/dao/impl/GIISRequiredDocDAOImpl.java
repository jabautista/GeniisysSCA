package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISRequiredDocDAO;
import com.geniisys.giis.entity.GIISRequiredDoc;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIISRequiredDocDAOImpl implements GIISRequiredDocDAO {
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISRequiredDocDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISRequiredDoc(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			List<GIISRequiredDoc> setRequiredDoc = (List<GIISRequiredDoc>) params.get("setRequiredDoc");
			List<GIISRequiredDoc> delRequiredDoc = (List<GIISRequiredDoc>) params.get("delRequiredDoc");
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			
			log.info("Saving GIISRequiredDoc...");
			for(GIISRequiredDoc requiredDoc : delRequiredDoc){
				log.info("Validating document before deleting...");
				// pre-delete validation added by Kris 05.23.2013
				Map<String, Object> params1 = new HashMap<String, Object>();
				params1.put("docCd", requiredDoc.getDocCd());
				params1.put("lineCd", requiredDoc.getLineCd());
				params1.put("checkBoth", "TRUE");
				System.out.println("params for pre-delte validation: "+params1);
				
				this.sqlMapClient.update("validateOnDeleteReqdDoc", params1);
				// end of pre-delete validation
						
				this.sqlMapClient.delete("delGIISRequiredDoc", requiredDoc);
			}
			log.info(delRequiredDoc.size() + " GIISRequiredDoc deleted.");
			
			for(GIISRequiredDoc requiredDoc : setRequiredDoc){
				this.sqlMapClient.insert("setGIISRequiredDoc", requiredDoc);
			}
			log.info(setRequiredDoc.size() + " GIISRequiredDoc inserted.");
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("End of saving GIISRequiredDoc.");
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getCurrenDocCdList(Map<String, Object> params) throws SQLException {
		List<String> reqdDocCdList = null;
		
		log.info("Retrieving current list of docCd...");
		System.out.println("params: "+params);
		reqdDocCdList = this.getSqlMapClient().queryForList("getCurrentReqdDocList", params);
		log.info("Retrieving current list of WcCd done.");
		
		System.out.println("docCdList retrieved: "+reqdDocCdList);
		return reqdDocCdList;		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss035(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRequiredDoc> delList = (List<GIISRequiredDoc>) params.get("delRows");
			for(GIISRequiredDoc d: delList){
				d.setLineCd(StringFormatter.unescapeHTML2(d.getLineCd()));
				d.setSublineCd(StringFormatter.unescapeHTML2(d.getSublineCd()));
				d.setDocCd(StringFormatter.unescapeHTML2(d.getDocCd()));
				this.sqlMapClient.update("delRequiredDocs", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRequiredDoc> setList = (List<GIISRequiredDoc>) params.get("setRows");
			for(GIISRequiredDoc s: setList){
				this.sqlMapClient.update("setRequiredDocs", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public String valDeleteRec(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteRequiredDocs", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRequiredDocs", params);		
	}
	
	public Map<String, Object> validateGiiss035Line(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss035Line", params);
		return params;
	}
	
	public Map<String, Object> validateGiiss035Subline(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss035Subline", params);
		return params;
	}
	
}
