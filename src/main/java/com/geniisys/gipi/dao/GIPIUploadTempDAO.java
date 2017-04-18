package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIUploadTemp;

public interface GIPIUploadTempDAO {

	List<GIPIUploadTemp> getGipiUploadTemp() throws SQLException;
	void setGipiEnrolleeUpload(Map<String,Object> enrolleeUploads) throws SQLException;
	String validateUploadFile(String fileName) throws SQLException;
	String getUploadNo(String fileName) throws SQLException;
	Integer getUploadCount(Integer uploadNo) throws SQLException;
	
}
