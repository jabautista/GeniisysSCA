/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuotePictures;


/**
 * The Interface GIPIQuotePicturesDAO.
 */
public interface GIPIQuotePicturesDAO {

	/**
	 * Save gipi quote pictures.
	 * 
	 * @param picture the picture
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuotePictures(GIPIQuotePictures picture) throws SQLException;
	
	/**
	 * Gets the gIPI quote pictures.
	 * 
	 * @param picture the picture
	 * @return the gIPI quote pictures
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuotePictures> getGIPIQuotePictures(GIPIQuotePictures picture) throws SQLException;
	
	/**
	 * Delete gipi quote picture.
	 * 
	 * @param picture the picture
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuotePicture(GIPIQuotePictures picture) throws SQLException;
	
	/**
	 * Update remarks.
	 * 
	 * @param picture the picture
	 * @throws SQLException the sQL exception
	 */
	void updateRemarks(GIPIQuotePictures picture) throws SQLException;
	
	/**
	 * Gets all the gipi_quote_pictures of the given quote_id
	 * @param quoteId
	 * @return
	 * @throws SQLException
	 */
	List<GIPIQuotePictures> getAllGIPIQuotePictures(Integer quoteId) throws SQLException;
	
	/**
	 * Gets all the gipi_quote_pictures of the Package Quotation
	 * @param packQuoteId
	 * @return
	 * @throws SQLException
	 */
	List<GIPIQuotePictures> getAllGIPIQuotePicturesForPackQuotation(Integer packQuoteId) throws SQLException;
	
	/**
	 *  Delete items attachment
	 *  @param delItemRows - list of item to delete
	 *  @throws SQLException
	 */
	void deleteItemsAttachment(List<GIPIQuoteItem> delItemRows) throws SQLException;
	
	/**
	 * Get item attachments
	 * @param item
	 * @return list of attachments
	 * @throws SQLException
	 */
	List<GIPIQuotePictures> getItemAttachments(GIPIQuoteItem item) throws SQLException;
}
