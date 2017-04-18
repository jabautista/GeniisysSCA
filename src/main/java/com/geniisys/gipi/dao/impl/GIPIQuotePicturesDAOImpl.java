/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIQuotePicturesDAO;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuotePicturesDAOImpl.
 */
public class GIPIQuotePicturesDAOImpl implements GIPIQuotePicturesDAO {

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

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePicturesDAO#getGIPIQuotePictures(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePictures> getGIPIQuotePictures(GIPIQuotePictures picture)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIQuotePictures", picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePicturesDAO#saveGIPIQuotePictures(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public void saveGIPIQuotePictures(GIPIQuotePictures picture)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuotePictures", picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePicturesDAO#deleteGIPIQuotePicture(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public void deleteGIPIQuotePicture(GIPIQuotePictures picture)
			throws SQLException {
		this.getSqlMapClient().delete("deleteGIPIQuotePicture", picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePicturesDAO#updateRemarks(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public void updateRemarks(GIPIQuotePictures picture) throws SQLException {
		this.getSqlMapClient().update("updateRemarks", picture);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePictures> getAllGIPIQuotePictures(Integer quoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getAllGIPIQuotePictures", quoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePictures> getAllGIPIQuotePicturesForPackQuotation(
			Integer packQuoteId) throws SQLException {
		return this.getSqlMapClient().queryForList("getAllGIPIQuotePicturesForPackQuotation", packQuoteId);
	}

	@Override
	public void deleteItemsAttachment(List<GIPIQuoteItem> delItemRows) throws SQLException {
		for (GIPIQuoteItem item : delItemRows) {
			this.getSqlMapClient().delete("deleteItemAttachments2", item);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIQuotePictures> getItemAttachments(GIPIQuoteItem item) throws SQLException {
		return this.getSqlMapClient().queryForList("getItemAttachments2", item);
	}

}
