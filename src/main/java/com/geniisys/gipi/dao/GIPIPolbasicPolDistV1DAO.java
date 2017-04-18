package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIPolbasicPolDistV1;

public interface GIPIPolbasicPolDistV1DAO {
	
	List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1List(HashMap<String, Object> params) throws SQLException;

	/**
	 * Returns query details from GIPI_POLBASIC_POL_DIST_V1 for GIUWS012 (Distribution by Peril).
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1ListForPerilDist(HashMap<String, Object> params) throws SQLException;
	
	List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1ListOneRiskDist(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * Gets currency code and description for GIUWS012
	 * @param policyId
	 * @param distNo
	 * @param distSeqNo
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGiuws012Currency(Integer policyId, Integer distNo, Integer distSeqNo) throws SQLException;
	Map<String, Object> createMissingDistRec(Map<String, Object> params) throws SQLException;
}
