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

import com.geniisys.gipi.dao.FileEntityDAO;
import com.geniisys.gipi.entity.FileEntity;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class FileEntityDAOImpl.
 */
public class FileEntityDAOImpl implements FileEntityDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolnrepDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#getGIPIWPictures(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<FileEntity> getGIPIWPictures(int id, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Par Pictures...");
		List<FileEntity> wpictures = this.getSqlMapClient().queryForList("selectGIPIWPicture", params);
		log.info("DAO - Par Pictures retrieved. size: "+wpictures.size());
		
		return wpictures;
	}

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
	 * @see com.geniisys.gipi.dao.FileEntityDAO#deleteGIPIWPictures(int, int)
	 */
	@Override
	public boolean deleteGIPIWPictures(int parId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Deleting All Par Pictures of parId: " + parId + " and itemNo: " + itemNo);
		this.getSqlMapClient().delete("deleteGIPIWPictures", params);
		log.info("DAO - Par Picture deleted.");		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#saveGIPIWPicture(com.geniisys.gipi.entity.FileEntity)
	 */
	@Override
	public boolean saveGIPIWPicture(FileEntity wpicture)
			throws SQLException {
				
		log.info("DAO - Inserting Par Picture...");
		this.getSqlMapClient().insert("saveGIPIWPicture", wpicture);
		log.info("DAO - Par Picture inserted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#deleteGIPIPictures(int, int)
	 */
	@Override
	public boolean deleteGIPIPictures(int policyId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("policyId", policyId);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Deleting All Policy Pictures of policyId: " + policyId + " and itemNo: " + itemNo);
		this.getSqlMapClient().delete("deleteGIPIPictures", params);
		log.info("DAO - Policy Picture deleted.");		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#deleteGIXXPictures(int, int)
	 */
	@Override
	public boolean deleteGIXXPictures(int extractId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("extractId", extractId);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Deleting All Extract Pictures of extractId: " + extractId + " and itemNo: " + itemNo);
		this.getSqlMapClient().delete("deleteGIXXPictures", params);
		log.info("DAO - Extract Picture deleted.");		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#getGIPIPictures(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<FileEntity> getGIPIPictures(int id, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("policyId", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Policy Pictures...");
		List<FileEntity> pictures = this.getSqlMapClient().queryForList("selectGIPIPicture", params);
		log.info("DAO - Policy Pictures retrieved. Size: " + pictures.size());
		
		return pictures;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#getGIXXPictures(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<FileEntity> getGIXXPictures(int id, int itemNo)
			throws SQLException {

		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("extractId", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Extract Pictures...");
		List<FileEntity> xpictures = this.getSqlMapClient().queryForList("selectGIXXPicture", params);
		log.info("DAO - Extract Pictures retrieved. Size: " + xpictures.size());
		
		return xpictures;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#saveGIPIPicture(com.geniisys.gipi.entity.FileEntity)
	 */
	@Override
	public boolean saveGIPIPicture(FileEntity picture) throws SQLException {
		
		log.info("DAO - Inserting Policy Picture...");
		this.getSqlMapClient().insert("saveGIPIPicture", picture);
		log.info("DAO - Policy Picture inserted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.FileEntityDAO#saveGIXXPicture(com.geniisys.gipi.entity.FileEntity)
	 */
	@Override
	public boolean saveGIXXPicture(FileEntity extractPicture) throws SQLException {

		log.info("DAO - Inserting Extract Picture...");
		this.getSqlMapClient().insert("saveGIXXPicture", extractPicture);
		log.info("DAO - Extract Picture inserted.");

		return false;
	}
	
	@SuppressWarnings("unchecked")
	public List<FileEntity> getGIPIInspPictures(int id, int itemNo)
		throws SQLException{
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("inspNo", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Inspection Pictures...");
		List<FileEntity> insppictures = this.getSqlMapClient().queryForList("selectGIPIInspPicture", params);
		log.info("DAO - Inspection Pictures retrieved. Size: " + insppictures.size());
		
		return insppictures;
	}
	
	public boolean saveGIPIInspPicture(FileEntity inspPicture) throws SQLException {

		log.info("DAO - Inserting Inspection Picture...");
		this.getSqlMapClient().insert("saveGIPIInspPicture", inspPicture);
		log.info("DAO - Inspection Picture inserted.");

		return false;
	}
	
	public boolean deleteGIPIInspPicture(int inspNo, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("inspNo", inspNo);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Deleting All Inspection Pictures of inspNo: " + inspNo + " and itemNo: " + itemNo);
		this.getSqlMapClient().delete("deleteGIPIInspPictures", params);
		log.info("DAO - Inspection Picture deleted.");		
		
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<FileEntity> getGICLPictures(int id, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Retrieving Claims item info Pictures...");
		List<FileEntity> giclPictures = this.getSqlMapClient().queryForList("selectGICLPictures", params);
		log.info("DAO - Claims item info Pictures retrieved. Size: " + giclPictures.size());
		
		return giclPictures;
	}

	@Override
	public boolean saveGICLPictures(FileEntity giclPictures) throws SQLException {
		log.info("DAO - Inserting Claims item info Picture...");
		this.getSqlMapClient().insert("saveGICLPictures", giclPictures);
		log.info("DAO - Claims item info Picture inserted.");

		return false;
	}

	@Override
	public boolean deleteGICLPictures(int id, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", id);
		params.put("itemNo", itemNo);
		
		log.info("DAO - Deleting All Claims item Pictures of claimId: " + id + " and itemNo: " + itemNo);
		this.getSqlMapClient().delete("deleteGICLPictures", params);
		log.info("DAO - Claims item Picture deleted.");		
		
		return true;
	}
	
	/* SR-5494 JET OCT-11-2016 */
	public boolean saveGIPIWPicture2(List<FileEntity> setList) throws SQLException {
		for (FileEntity attachment: setList) {
			this.getSqlMapClient().insert("saveGIPIWPicture", attachment);
		}
		
		return true;
	}
	
	public boolean deleteGIPIWPicture2(List<FileEntity> delList) throws SQLException {
		for (FileEntity attachment: delList) {
			this.getSqlMapClient().delete("deleteGIPIWPicture2", attachment);
		}
		
		return true;
	}
	
	public boolean saveGIPIPicture2(List<FileEntity> setList) throws SQLException {
		for (FileEntity attachment: setList) {
			this.getSqlMapClient().insert("saveGIPIPicture", attachment);
		}
		
		return true;
	}
	
	public boolean deleteGIPIPicture2(List<FileEntity> delList) throws SQLException {
		for (FileEntity attachment: delList) {
			this.getSqlMapClient().delete("deleteGIPIPicture2", attachment);
		}
		
		return true;
	}
	
	public boolean saveGICLPicture2(List<FileEntity> setList) throws SQLException {
		for (FileEntity attachment: setList) {
			this.getSqlMapClient().insert("saveGICLPictures", attachment);
		}
		
		return true;
	}
	
	public boolean deleteGICLPicture2(List<FileEntity> delList) throws SQLException {
		for (FileEntity attachment: delList) {
			this.getSqlMapClient().delete("deleteGICLPicture2", attachment);
		}
		
		return true;
	}
	
	public boolean saveGipiQuotePictures(List<FileEntity> setList) throws SQLException {
		for (FileEntity attachment : setList) {
			this.getSqlMapClient().insert("saveGipiQuotePictures", attachment);
		}
		return true;
	}
	
	public boolean saveGipiInspPictures(List<FileEntity> setList) throws SQLException {
		for (FileEntity attachment : setList) {
			this.getSqlMapClient().insert("saveGipiInspPictures", attachment);
		}
		return true;
	}
	
	public boolean deleteGipiQuotePictures(List<FileEntity> delList) throws SQLException {
		for (FileEntity attachment : delList) {
			this.getSqlMapClient().delete("deleteGipiQuotePictures", attachment);
		}
		return true;
	}
	
	public boolean deleteGipiInspPictures2(List<FileEntity> delList) throws SQLException {
		for (FileEntity attachment : delList) {
			this.getSqlMapClient().delete("deleteGipiInspPictures2", attachment);
		}
		return true;
	}
	
	public List<FileEntity> getGipiQuotePictures(int quoteId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		
		@SuppressWarnings("unchecked")
		List<FileEntity> gipiQuotePictures = this.getSqlMapClient().queryForList("selectGipiQuotePictures", params);
		
		return gipiQuotePictures;
	}
}
