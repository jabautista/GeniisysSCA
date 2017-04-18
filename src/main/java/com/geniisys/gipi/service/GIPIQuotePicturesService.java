/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuotePictures;


/**
 * The Interface GIPIQuotePicturesService.
 */
public interface GIPIQuotePicturesService {

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
	 * Write media.
	 * 
	 * @param request the request
	 * @param media the media
	 * @return the http servlet request
	 * @throws FileNotFoundException the file not found exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	HttpServletRequest writeMedia(HttpServletRequest request, List<GIPIQuotePictures> media) throws FileNotFoundException, IOException;
	
	/**
	 * Write media.
	 * 
	 * @param request the request
	 * @param file the file
	 * @param quoteId the quote id
	 * @throws FileNotFoundException the file not found exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	void writeMedia(HttpServletRequest request, String file, int quoteId) throws FileNotFoundException, IOException;
	
	/**
	 * Delete media.
	 * 
	 * @param quoteId the quote id
	 * @throws FileNotFoundException the file not found exception
	 */
	void deleteMedia(int quoteId) throws FileNotFoundException;
	
	/**
	 * Checks if is file valid.
	 * 
	 * @param file the file
	 * @param index the index
	 * @return true, if is file valid
	 */
	boolean isFileValid(String file, int index);
	
	/**
	 * Gets the media types.
	 * 
	 * @param fileName the file name
	 * @param index the index
	 * @return the media types
	 */
	Map<Integer, String> getMediaTypes(String fileName, int index);
	
	/**
	 * Update remarks.
	 * 
	 * @param request the request
	 * @throws SQLException the sQL exception
	 */
	void updateRemarks(HttpServletRequest request) throws SQLException;
	
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
	 * Delete items attachment
	 * @param list of GIPIQuoteItem
	 * @return true if successful
	 * @throws SQLException
	 */
	boolean deleteItemsAttachment(List<GIPIQuoteItem> delItemRows) throws SQLException;
}
