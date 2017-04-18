/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISAssuredIndividualInformation;
import com.geniisys.common.entity.GIISGroup;
import com.geniisys.common.entity.GIISIntermediary;


/**
 * The Interface GIISAssuredDAO.
 */
public interface GIISAssuredDAO {

	/**
	 * Gets the gIIS assured by assd no.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured by assd no
	 * @throws SQLException the sQL exception
	 */
	public GIISAssured getGIISAssuredByAssdNo(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the giis assured details.
	 * 
	 * @param assdNo the assd no
	 * @return the giis assured details
	 * @throws SQLException the sQL exception
	 */
	public GIISAssured getGiisAssuredDetails(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the assured list.
	 * 
	 * @param keyword the keyword
	 * @return the assured list
	 * @throws SQLException the sQL exception
	 */
	public List<GIISAssured> getAssuredList(String keyword) throws SQLException;
	
	/**
	 * Save assured.
	 * 
	 * @param assured the assured
	 * @throws SQLException the sQL exception
	 */
	void saveAssured(GIISAssured assured) throws SQLException;
	
	/**
	 * Delete assured.
	 * 
	 * @param assured the assured
	 * @throws SQLException the sQL exception
	 */
	void deleteAssured(GIISAssured assured) throws SQLException;
	
	/**
	 * Gets the assured lov list.
	 * 
	 * @return the assured lov list
	 * @throws SQLException the sQL exception
	 */
	List<GIISAssured> getAssuredLovList() throws SQLException;
	
	/**
	 * Gets the assured no sequence.
	 * 
	 * @return the assured no sequence
	 * @throws SQLException the sQL exception
	 */
	Integer getAssuredNoSequence() throws SQLException;
	
	/**
	 * Save giis assured intm.
	 * 
	 * @param assdIntmParams the assd intm params
	 * @throws SQLException the sQL exception
	 */
	void saveGIISAssuredIntm(Map<String, Object> assdIntmParams) throws SQLException;
	
	/**
	 * Delete giis assd intm.
	 * 
	 * @param assdNo the assd no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIISAssdIntm(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the gIIS assured intm.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured intm
	 * @throws SQLException the sQL exception
	 */
	List<GIISIntermediary> getGIISAssuredIntm(Integer assdNo) throws SQLException;
	
	/**
	 * Save giis assured group.
	 * 
	 * @param assdGroupParams the assd group params
	 * @throws SQLException the sQL exception
	 */
	void saveGIISAssuredGroup(Map<String, Object> assdGroupParams) throws SQLException;
	
	/**
	 * Gets the gIIS assured group.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured group
	 * @throws SQLException the sQL exception
	 */
	List<GIISGroup> getGIISAssuredGroup(Integer assdNo) throws SQLException;
	
	/**
	 * Delete giis assd group.
	 * 
	 * @param assdNo the assd no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIISAssdGroup(Integer assdNo) throws SQLException;
	
	/**
	 * Save giis assured ind info.
	 * 
	 * @param assuredIndividualInformation the assured individual information
	 * @throws SQLException the sQL exception
	 */
	void saveGIISAssuredIndInfo(GIISAssuredIndividualInformation assuredIndividualInformation) throws SQLException;
	
	/**
	 * Gets the gIIS assured individual info.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured individual info
	 * @throws SQLException the sQL exception
	 */
	GIISAssuredIndividualInformation getGIISAssuredIndividualInfo(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the acct of list.
	 * 
	 * @param params the params
	 * @return the acct of list
	 * @throws SQLException the sQL exception
	 */
	public List<GIISAssured> getAcctOfList(Map<String, Object> params) throws SQLException;

	String checkAssuredDependencies(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the mailing addresses for specified assd no.
	 * @param params The parameters needed to execute the query
	 * @return The updated map with the mailing addresses
	 * @throws SQLException
	 */
	Map<String, Object> getAssdMailingAddress(Map<String, Object> params) throws SQLException;

	void deleteAssured(Integer assdNo) throws SQLException;
	
	void deleteGiisAssured(Map<String, Object> params) throws SQLException, Exception;
	
	public List<GIISAssured> getExistingAssured(String assdName) throws SQLException;
	
	Map<String, Object> checkAssdMobileNo(Map<String, Object> params) throws SQLException;

	public String checkRefCd(String refCd) throws SQLException;
	public String checkRefCd2(Map<String, Object> params) throws SQLException;
	
	Integer getFirstRecord() throws SQLException;

	List<GIISAssured> validateAssdNoGiexs006(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateAssdNo(Map<String, Object> params) throws SQLException;
	String checkAssuredExistGiiss006b(Map<String, Object>params)throws SQLException;
	String checkAssuredExistGiiss006b2(Map<String, Object>params)throws SQLException;
	String getPostQueryGiiss006b(Integer assdNo) throws SQLException;
	void valDeleteGroupInfo(Map<String, Object> params) throws SQLException;
	String checkDfltIntm(Map<String, Object>params)throws SQLException; //benjo 09.07.2016 SR-5604
}
