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

import org.json.JSONObject;
import org.json.JSONException;

import com.geniisys.common.exceptions.UploadModeException;
import com.geniisys.gipi.entity.FileEntity;


/**
 * The Interface FileEntityService.
 */
public interface FileEntityService {

	/**
	 * Write media.
	 * 
	 * @param request the request
	 * @param file the file
	 * @param quoteId the quote id
	 * @throws FileNotFoundException the file not found exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	void writeMedia(HttpServletRequest request, String file, int quoteId)
			throws FileNotFoundException, IOException;
	
	/**
	 * Write media.
	 * 
	 * @param request the request
	 * @param media the media
	 * @return the http servlet request
	 * @throws FileNotFoundException the file not found exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	HttpServletRequest writeMedia(HttpServletRequest request, List<FileEntity> media) 
			throws FileNotFoundException, IOException;
	
	/**
	 * Gets the files.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param mode the mode
	 * @return the files
	 * @throws SQLException the sQL exception
	 */
	List<FileEntity> getFiles(int parId, int itemNo, String mode)
			throws SQLException;
	
	/**
	 * Delete files.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @param mode the mode
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteFiles(int parId, int itemNo, String mode) throws SQLException;
	
	/**
	 * Delete files from disk.
	 * 
	 * @param filePath the file path
	 * @param fileNames the file names
	 * @return true, if successful
	 */
	boolean deleteFilesFromDisk(String filePath, String[] fileNames);
	
	/**
	 * Save files.
	 * 
	 * @param params the params
	 * @param mode the mode
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveFiles(Map<String, Object> params, String mode) throws SQLException;
	void writeMedia(Map<String, Object> params) throws Exception;
	
	/**
	 * Get file size
	 * 
	 * @param fileFullPath
	 * @return file size in bytes
	 * @throws IOException
	 */
	Integer getFileSize(String fileFullPath) throws IOException;
	
	/**
	 * Check if file exists
	 * 
	 * @param fileFullPath
	 * @return true or false
	 */
	boolean isFileExists(String fileFullPath);
	
	JSONObject getAttachments(HttpServletRequest request) throws SQLException, JSONException, UploadModeException;
	void saveAttachments(HttpServletRequest request, String userId) throws SQLException, JSONException, UploadModeException;
	Integer getAttachmentTotalSize(String uploadMode, Integer genericId, Integer itemNo) throws SQLException, IOException, UploadModeException;
}
