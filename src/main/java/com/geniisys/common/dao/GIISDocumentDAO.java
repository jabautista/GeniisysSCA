package com.geniisys.common.dao;

import java.sql.SQLException;

public interface GIISDocumentDAO {
	
	String checkDisplayGiexs006(String title) throws SQLException;
	String checkPrintPremiumDetails(String lineCd) throws SQLException;
}
