/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISAssuredIndividualInformation;
import com.geniisys.common.entity.GIISGroup;
import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.PaginatedList;


/**
 * The Interface GIISAssuredFacadeService.
 */
public interface GIISAssuredFacadeService {
	
	/**
	 * Gets the gIIS assured by assd no.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured by assd no
	 * @throws SQLException the sQL exception
	 */
	public GIISAssured getGIISAssuredByAssdNo(String assdNo) throws SQLException;
	
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
	 * @param pageNo the page no
	 * @param keyword the keyword
	 * @return the assured list
	 * @throws SQLException the sQL exception
	 */
	public JSONArrayList getAssuredList(Integer pageNo, String keyword) throws SQLException;
	
	public PaginatedList getAssuredListing(Integer pageNo, String keyword) throws SQLException;
	
	/**
	 * Gets the acct of list.
	 * 
	 * @param pageNo the page no
	 * @param assdNo the assd no
	 * @param keyword the keyword
	 * @return the acct of list
	 * @throws SQLException the sQL exception
	 */
	public PaginatedList getAcctOfList(Integer pageNo,Integer assdNo, String keyword) throws SQLException;
	
	/**
	 * Save assured.
	 * 
	 * @param assured the assured
	 * @return the integer
	 * @throws SQLException the sQL exception
	 */
	Integer saveAssured(GIISAssured assured) throws SQLException;
	
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
	 * Save giis assured intm.
	 * 
	 * @param assdNo the assd no
	 * @param lineCd the line cd
	 * @param intmNo the intm no
	 * @throws SQLException the sQL exception
	 */
	void saveGIISAssuredIntm(int assdNo, String lineCd, Integer intmNo, String userId) throws SQLException;
	
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
	 * @param assdNo the assd no
	 * @param groupCd the group cd
	 * @throws SQLException the sQL exception
	 */
	void saveGIISAssuredGroup(int assdNo, int groupCd, String remarks, String userId) throws SQLException;
	
	/**
	 * Gets the gIIS assured group.
	 * 
	 * @param assdNo the assd no
	 * @return the gIIS assured group
	 * @throws SQLException the sQL exception
	 */
	List<GIISGroup> getGIISAssuredGroup(int assdNo) throws SQLException;
	
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
	
	String checkAssuredDependencies(Integer assdNo) throws SQLException;
	
	void deleteAssured(Integer assdNo) throws SQLException;
	
	/**
	 * Gets the mailing addresses for specified assd no.
	 * @param params The parameters needed to execute the query
	 * @return The updated map with the mailing addresses
	 * @throws SQLException
	 */
	Map<String, Object> getAssdMailingAddress(Map<String, Object> params) throws SQLException;
	
	List<GIISAssured> getExistingAssured(String assdName) throws SQLException;
	
	String checkRefCd(String refCd) throws SQLException;
	String checkRefCd2(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> checkAssdMobileNo(Map<String, Object> params) throws SQLException;
	
	Integer getFirstRecord() throws SQLException;
	
	List<GIISAssured> validateAssdNoGiexs006(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> validateAssdNo(Map<String, Object> params) throws SQLException;
	
	String checkAssuredExistGiiss006b(Map<String, Object>params)throws SQLException;
	String checkAssuredExistGiiss006b2(Map<String, Object>params)throws SQLException;
	String getPostQueryGiiss006b(Integer assdNo)throws SQLException;
	void deleteGiisAssured(Map<String, Object> params) throws SQLException, Exception;
	void valDeleteGroupInfo(HttpServletRequest request) throws SQLException;
	JSONObject getAssuredIntmList(HttpServletRequest request) throws SQLException, JSONException;
	String checkDfltIntm(Map<String, Object>params)throws SQLException; //benjo 09.07.2016 SR-5604
}
