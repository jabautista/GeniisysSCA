package com.geniisys.gipi.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIUploadTemp;
import com.geniisys.gipi.exceptions.InvalidUploadEnrolleesDataException;

public interface GIPIUploadTempService {

	List<GIPIUploadTemp> getGipiUploadTemp() throws SQLException;
	Map<String, Object> readAndPrepareRecords(File fileName, String userId, String myFileName) throws InvalidUploadEnrolleesDataException, FileNotFoundException, IOException;
	void setGipiEnrolleeUpload(Map<String,Object> enrolleeUploads) throws SQLException;
	String validateUploadFile(String fileName) throws SQLException;
	String getUploadNo(String fileName) throws SQLException;
	Map<String, Object> readAndPrepareRecords2(File fileName, String userId, String myFileName) throws InvalidUploadEnrolleesDataException, FileNotFoundException, IOException;
	Integer getUploadCount(String uploadNo) throws SQLException;
	
}
