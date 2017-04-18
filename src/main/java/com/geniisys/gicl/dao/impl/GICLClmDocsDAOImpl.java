/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLClmDocsDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 9, 2011
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmDocsDAO;
import com.geniisys.gicl.entity.GICLClmDocs;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLClmDocsDAOImpl implements GICLClmDocsDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLClmDocsDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClmDocs> getClmDocsList(Map<String, Object> params)
			throws SQLException {
		/*String[] clmDocCds = (String[]) params.get("clmDocCds");
		String query = "";
		System.out.println("lineCd:"+params.get("lineCd"));
		System.out.println("lineCd:"+params.get("sublineCd"));
		log.info("PREPARING QUERY...");
		for (int i = 0; i < clmDocCds.length; i++) {
			System.out.println(i);
			query+= (query.equals("") ? "" : ",")+"'"+clmDocCds[i]+"'"; 
		}*/
		log.info("RETRIEVING CLAIM DOCUMENTS LISTING...");
		System.out.println(params.get("findText"));
		return this.getSqlMapClient().queryForList("getClmDocsList",params);
	}
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls181(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLClmDocs> delList = (List<GICLClmDocs>) params.get("delRows");
			for(GICLClmDocs d: delList){
				d.setLineCd(StringFormatter.unescapeHTML2(d.getLineCd()));
				d.setSublineCd(StringFormatter.unescapeHTML2(d.getSublineCd()));
				this.sqlMapClient.update("delClmDocsGicls110", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLClmDocs> setList = (List<GICLClmDocs>) params.get("setRows");
			for(GICLClmDocs s: setList){
				this.sqlMapClient.update("setClmDocsGicls110", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecGicls110", params);
	}
}
