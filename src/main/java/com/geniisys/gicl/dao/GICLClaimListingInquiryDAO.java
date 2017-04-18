/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	gzelle
 * Create Date	:	02.15.2013
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GICLClaimListingInquiryDAO {
	
	String validateColorPerColor (Map<String, Object> params) throws SQLException;
	String validateBasicColorPerColor (Map<String, Object> params) throws SQLException;
	String validatePayeePerAdjuster (Map<String, Object> params) throws SQLException;
	String validateDistrictPerBlock (Map<String, Object> params) throws SQLException;
	String validateBlockPerBlock (Map<String, Object> params) throws SQLException;
	Map<String, Object> getBlockByDistrictNo(Map<String, Object> params) throws SQLException;
	String validateCargoClassPerCargoClass(Map<String, Object> params) throws SQLException;
	String validateCargoTypePerCargoClass(Map<String, Object> params) throws SQLException;
	Map<String, Object> fetchCorrespondingCargoTypeBasedOnClassCd(Map<String, Object> params) throws SQLException;
	List<Integer> fetchValidCargo(Map<String, Object> params) throws SQLException;
	String validateMotorshop(Map<String, Object> params) throws SQLException;
	String validateLineCdByLineName(Map<String, Object> params) throws SQLException;
	String validateLossCatDescPerLineCd(Map<String, Object> params) throws SQLException;
	Map<String, Object> fetchValidLossCatDesc(Map<String, Object> params) throws SQLException;
	List<String> fetchValidLineCd(Map<String, Object> params) throws SQLException;
	String validatePayees(Map<String,Object> params) throws SQLException;
	String validatePayeeClass(Map<String,Object> params) throws SQLException;
	String validateDocNumber(Map<String,Object> params) throws SQLException;
	String validateLawyer (Map<String, Object> params) throws SQLException;
	List<String> fetchValidThirdParty(Map<String, Object> params) throws SQLException;
	List<String> validateClassPerClass(Map<String, Object> params) throws SQLException;
	List<String> validatePayeePerClassCd(Map<String, Object> params) throws SQLException;
	String validateGICLS278Field(Map<String, Object> params) throws SQLException;
	String validateGICLS278Entries(Map<String, Object> params) throws SQLException;
	Map<String, Object> populateGicls256Totals(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls277PayeeName(Map<String, Object> params) throws SQLException;
}
