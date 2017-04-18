package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GUEAttachDAO;
import com.geniisys.gipi.entity.GUEAttach;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GUEAttachDAOImpl implements GUEAttachDAO {
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GUEAttachDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<String> setGUEAttach(Map<String, Object> params)
			throws SQLException {
		List<String> files = new ArrayList<String>();
		List<GUEAttach> attachments = (List<GUEAttach>) params.get("attachments");
						
		log.info("Saving GUE Attach...");
		for(GUEAttach attachment: attachments){
			attachment.setAppUser((String) params.get("appUser"));
			attachment.setTranId(Integer.parseInt(params.get("tranId").toString()));
			files.add(attachment.getFilePath()+"/"+attachment.getFileName());
			System.out.println(attachment.getFilePath()+"/"+attachment.getFileName());
			this.sqlMapClient.delete("setGUEAttach", attachment);
		}
	
		return files;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGUEAttachments(Map<String, Object> params)
			throws SQLException {
		Integer tranId = (Integer) params.get("tranId");
		List<GUEAttach> setAttachRows = (List<GUEAttach>) params.get("setAttachRows");
		List<GUEAttach> delAttachRows = (List<GUEAttach>) params.get("delAttachRows");
		
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("Deleting GUE Attach...");
			for(GUEAttach delAttach: delAttachRows){
				this.sqlMapClient.delete("delGUEAttach", delAttach);
			}
			
			log.info("Inserting/Updating GUE Attach...");
			for(GUEAttach setAttach: setAttachRows){
				if(setAttach.getTranId() == null){
					setAttach.setTranId(tranId);
				}
				System.out.println("ITEM NO : " + setAttach.getItemNo());
				this.sqlMapClient.delete("setGUEAttach", setAttach);
			}

			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e) {
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<GUEAttach> getGUEAttachListing(Integer tranId)
		throws SQLException {
		log.info("Retrieving GUE Attach...");
		List<GUEAttach> attachments = this.sqlMapClient.queryForList("getGUEAttachListing", tranId);
					
		return attachments;
	}	
}
