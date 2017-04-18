/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIMCUpload;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;


/**
 * The Interface GIPIMCUploadService.
 */
public interface GIPIMCUploadService {

	/**
	 * Validate upload file.
	 * 
	 * @param fileName the file name
	 * @return the string
	 * @throws SQLException the sQL exception
	 */
	String validateUploadFile(String fileName) throws SQLException;
	
	/**
	 * Read and prepare records.
	 * 
	 * @param fileName the file name
	 * @param userId the user id
	 * @param myFileName the my file name
	 * @return the list
	 * @throws InvalidUploadFeetDataException the invalid upload feet data exception
	 * @throws FileNotFoundException the file not found exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	List<GIPIMCUpload> readAndPrepareRecords(File fileName, String userId, String myFileName) throws InvalidUploadFeetDataException, FileNotFoundException, IOException;
	
	/**
	 * Sets the gipi mc upload.
	 * 
	 * @param mcUploads the new gipi mc upload
	 * @throws SQLException the sQL exception
	 */
	void setGipiMCUpload(List<GIPIMCUpload> mcUploads) throws SQLException;

	Map<String, Object> readAndPrepareFleetMC(Map<String, Object> fileParams)throws InvalidUploadFeetDataException, FileNotFoundException,
	IOException, ParseException, SQLException, IllegalAccessException, InvocationTargetException, NoSuchMethodException;
	
	void setUploadedFleet(Map<String, Object> params) throws SQLException, IllegalAccessException, InvocationTargetException, NoSuchMethodException;
	
}
