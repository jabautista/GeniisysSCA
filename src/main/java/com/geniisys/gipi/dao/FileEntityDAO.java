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

import com.geniisys.gipi.entity.FileEntity;


/**
 * The Interface FileEntityDAO.
 */
public interface FileEntityDAO {

	/**
	 * Gets the gIPIW pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return the gIPIW pictures
	 * @throws SQLException the sQL exception
	 */
	List<FileEntity> getGIPIWPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return the gIPI pictures
	 * @throws SQLException the sQL exception
	 */
	List<FileEntity> getGIPIPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIXX pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return the gIXX pictures
	 * @throws SQLException the sQL exception
	 */
	List<FileEntity> getGIXXPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Delete gipiw pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteGIPIWPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Delete gipi pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteGIPIPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Delete gixx pictures.
	 * 
	 * @param id the id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteGIXXPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Save gipiw picture.
	 * 
	 * @param file the file
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveGIPIWPicture(FileEntity file) throws SQLException;
	
	/**
	 * Save gipi picture.
	 * 
	 * @param file the file
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveGIPIPicture(FileEntity file) throws SQLException;
	
	/**
	 * Save gixx picture.
	 * 
	 * @param file the file
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveGIXXPicture(FileEntity file) throws SQLException;
	
	/**
	 * Gets the gipiInsp pictures
	 * 
	 * @param id
	 * @param itemNo
	 * @return the gipiInsp pictures
	 * @throws SQLException
	 */
	List<FileEntity> getGIPIInspPictures(int id, int itemNo) throws SQLException;
	
	/**
	 * Save gipiinsp picture
	 * 
	 * @param inspPicture
	 * @return true, if successful
	 * @throws SQLException
	 */
	boolean saveGIPIInspPicture(FileEntity inspPicture) throws SQLException;

	/**
	 * Delete gipiinsp pictures
	 * 
	 * @param inspNo
	 * @param itemNo
	 * @return true, if successful
	 * @throws SQLException
	 */
	boolean deleteGIPIInspPicture(int inspNo, int itemNo) throws SQLException;

	List<FileEntity> getGICLPictures(int id, int itemNo) throws SQLException;

	boolean saveGICLPictures(FileEntity file) throws SQLException;

	boolean deleteGICLPictures(int id, int itemNo) throws SQLException;
	
	boolean saveGIPIWPicture2(List<FileEntity> setList) throws SQLException;
	boolean deleteGIPIWPicture2(List<FileEntity> delList) throws SQLException;
	boolean saveGIPIPicture2(List<FileEntity> setList) throws SQLException;
	boolean deleteGIPIPicture2(List<FileEntity> delList) throws SQLException;
	boolean saveGICLPicture2(List<FileEntity> setList) throws SQLException;
	boolean deleteGICLPicture2(List<FileEntity> delList) throws SQLException;
	boolean saveGipiQuotePictures(List<FileEntity> setList) throws SQLException;
	boolean deleteGipiQuotePictures(List<FileEntity> delList) throws SQLException;
	boolean saveGipiInspPictures(List<FileEntity> setList) throws SQLException;
	boolean deleteGipiInspPictures2(List<FileEntity> delList) throws SQLException;
	
	/**
	 * get gipiQuotePictures
	 * @param quoteId - quoteId
	 * @param itemNo - itemNo
	 * @throws SQLException
	 */
	List<FileEntity> getGipiQuotePictures(int quoteId, int itemNo) throws SQLException;
}
