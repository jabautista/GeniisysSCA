package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GICLCatastrophicEventDAO {
	Map<String, Object> validateGicls057Line(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls057Catastrophy(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls057Branch(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getUserParams(Map<String, Object> params) throws SQLException;
	Integer extractOsPdPerCat(Map<String, Object> params) throws SQLException;
	Map<String, Object> valExtOsPdClmRecBefPrint(Map<String, Object> params) throws SQLException;
	void gicls056UpdateDetails(List<Map<String, Object>> list) throws SQLException, Exception;
	void saveGicls056(Map<String, Object> params) throws SQLException;
	String gicls056ValDelete(String catCd) throws SQLException;
	void gicls056UpdateDetailsAll(Map <String, Object> params) throws SQLException;
	void gicls056RemoveAll(Map <String, Object> params) throws SQLException;
	void gicls056ValAddRec(Map <String, Object> params) throws SQLException;
	String gicls056GetClaimNos(Map <String, Object> params) throws SQLException;
	String gicls056GetClaimNosList(Map <String, Object> params) throws SQLException;
	String gicls056GetClaimNosListFi(Map <String, Object> params) throws SQLException;
	Map<String, Object> gicls056GetDspAmt(Map <String, Object> params) throws SQLException;
}
