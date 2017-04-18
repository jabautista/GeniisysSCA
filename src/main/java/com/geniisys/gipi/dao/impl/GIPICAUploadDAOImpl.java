package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPICAUploadDAO;
import com.geniisys.gipi.entity.GIPICAUpload;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.service.impl.GIPICAUploadServiceImpl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPICAUploadDAOImpl implements GIPICAUploadDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	private static Logger log = Logger.getLogger(GIPICAUploadServiceImpl.class);
	
	@Override
	public String validateUploadPropertyFloater(String fileName) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateUploadPropertyFloater", fileName);
	}

	@Override
	public Integer getCaNextUploadNo() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getCaNextUploadNo");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setRecordsOnUpload(Map<String, Object> params)
			throws SQLException {
		try {
			List<GIPIWItem> gipiWItem = (List<GIPIWItem>) params.get("gipiWItem");
			List<GIPIWCasualtyItem> gipiWCasualtyItem = (List<GIPIWCasualtyItem>) params.get("gipiWCasualtyItem");
			List<GIPICAUpload> gipiCAUpload = (List<GIPICAUpload>) params.get("floaterUploads"); 
			List<Map<String, Object>> gipiCAErrorLog = (List<Map<String, Object>>) params.get("errorLogs");
			List<GIPIWItemPeril> gipiWItemPeril = (List<GIPIWItemPeril>) params.get("gipiWItemPeril");
			
			Integer parId = (Integer) params.get("parId");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().delete("delGIPIMCErrorLog", (String) params.get("appUser"));
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWItem item: gipiWItem) {
				this.getSqlMapClient().insert("setGIPIWItem", item);
			}
			this.getSqlMapClient().executeBatch();
			
			Integer parStatus = (Integer) this.getSqlMapClient().queryForObject("gipis031GetParStatus", parId);
			if(gipiWItem.size() > 0 && parStatus < 4) {
				Map<String, Object> updateMap = new HashMap<String, Object>();
				updateMap.put("parId", parId);
				updateMap.put("parStatus", 4);
				updateMap.put("appUser", params.get("appUser"));
				this.getSqlMapClient().update("updatePARStatus", updateMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIWCasualtyItem casualtyItem: gipiWCasualtyItem) {
				this.getSqlMapClient().insert("setGipiWCasualtyItems", casualtyItem);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWItemPeril perilList: gipiWItemPeril) {
				this.getSqlMapClient().insert("addItemPeril", perilList);
			}
			this.getSqlMapClient().executeBatch();
			
			
			
			for (GIPICAUpload caUpload: gipiCAUpload) {
				this.getSqlMapClient().insert("setGipiAcUpload", caUpload);
			}
			this.getSqlMapClient().executeBatch();
			
			
			for(Map<String, Object> error: gipiCAErrorLog) {
				this.getSqlMapClient().insert("setGipiAcErrorLog", error);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
}