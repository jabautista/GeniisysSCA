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
import java.util.Map;

import com.geniisys.gipi.entity.GIPIMCUpload;


/**
 * The Interface GIPIMCUploadDAO.
 */
public interface GIPIMCUploadDAO {

	/**
	 * Validate upload file.
	 * 
	 * @param fileName the file name
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateUploadFile(String fileName) throws SQLException;
	
	/**
	 * Sets the gipi mc upload.
	 * 
	 * @param mcUploads the new gipi mc upload
	 * @throws SQLException the sQL exception
	 */
	void setGipiMCUpload(List<GIPIMCUpload> mcUploads) throws SQLException;
	
	void setRecordsOnUpload(Map<String, Object> params) throws SQLException;
	
	List<GIPIMCUpload> getUploadedMC(String fileName) throws SQLException;
	
	Integer getNextUploadNo() throws SQLException;
	
}
