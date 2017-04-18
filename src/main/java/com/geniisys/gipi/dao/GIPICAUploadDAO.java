package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIPICAUploadDAO{
	String validateUploadPropertyFloater(String fileName) throws SQLException;
	Integer getCaNextUploadNo() throws SQLException;
	void setRecordsOnUpload(Map<String, Object> params) throws SQLException;
}