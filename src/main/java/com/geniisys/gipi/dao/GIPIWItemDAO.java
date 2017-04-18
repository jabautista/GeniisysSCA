/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWItem;


/**
 * The Interface GIPIWItemDAO.
 */
public interface GIPIWItemDAO {

	/**
	 * Gets the gIPIW item.
	 * 
	 * @param parId the par id
	 * @return the gIPIW item
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWItem> getGIPIWItem(Integer parId)throws SQLException;
	
	/**
	 * Update item values.
	 * 
	 * @param tsiAmt the tsi amt
	 * @param premAmt the prem amt
	 * @param annTsiAmt the ann tsi amt
	 * @param annPremAmt the ann prem amt
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean updateItemValues(BigDecimal tsiAmt, BigDecimal premAmt, BigDecimal annTsiAmt,
			BigDecimal annPremAmt, Integer parId, Integer itemNo) throws SQLException;
	
	/**
	 * Gets the w item count.
	 * 
	 * @param parId the par id
	 * @return the w item count
	 * @throws SQLException the sQL exception
	 */
	Integer getWItemCount(Integer parId) throws SQLException;
	
	/**
	 * Update w polbas.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void updateWPolbas(Integer parId) throws SQLException;
	
	/**
	 * Gets the tsi.
	 * 
	 * @param parId the par id
	 * @return the tsi
	 * @throws SQLException the sQL exception
	 */
	void getTsi(Integer parId) throws SQLException;

	GIPIWItem getTsiPremAmt(Integer parId, Integer itemNo) throws SQLException;
	
	/**
	 * Gets the distinct item no in gipi_item that doesn't exist in gipi_witem. Used in getting the available items for Add Items procedure in the module.
	 * 
	 * @param parId The Par Id
	 * @return
	 * @throws SQLException
	 */
	List<Integer> getDistinctItemNos(int parId) throws SQLException;
	
	void delGIPIWItem(Integer parId, Integer itemNo) throws SQLException;
	
	void insertGIPIWItem(GIPIWItem item) throws SQLException;
	
	void updateGipiWPackLineSubline(Map<String, Object> params) throws SQLException;
	
	void setGIPIWItemWGroup(GIPIWItem item) throws SQLException;
	
	String validateEndtAddItem(Map<String, Object> params) throws SQLException;
	
	List<GIPIWItem> getEndtAddItemList(Map<String, Object> params) throws SQLException;
	
	void deleteItem(Integer parId, Integer itemNo) throws SQLException;
	
	void updateItemGroup(Integer parId, Integer itemGrp, Integer itemNo) throws SQLException;
	
	Map<String, Object> getPlanDetails(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipiw095NewFormInstance(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipiw096NewFormInstance(Map<String, Object> params) throws SQLException;
	
	List<GIPIWItem> getParItemMC(int parId) throws SQLException;
	List<GIPIWItem> getParItemFI(int parId) throws SQLException;
	List<GIPIWItem> getParItemEN(int parId) throws SQLException;
	List<GIPIWItem> getParItemAC(int parId) throws SQLException; 
	List<GIPIWItem> getParItemCA(int parId) throws SQLException;
	List<GIPIWItem> getParItemMN(int parId) throws SQLException;
	List<GIPIWItem> getParItemAV(int parId) throws SQLException;
	List<GIPIWItem> getParItemMH(int parId) throws SQLException;
	List<GIPIWItem> getPackParPolicyItems(int packParId) throws SQLException;
	List<GIPIWItem> getPackParPolicyItems2(Integer packParId) throws SQLException;
	
	void parItemPostFormsCommit(Map<String, Object> params) throws SQLException, JSONException;
	void endtItemPostFormsCommit(Map<String, Object> params) throws SQLException, JSONException;
	
	void savePackagePolicyItems(Map<String, Object> params) throws SQLException, JSONException;
	void saveEndtPackagePolicyItems(Map<String, Object> params) throws SQLException, JSONException;
	
	List<GIPIWItem> getPackageRecords(int packParId) throws SQLException;
	Integer checkItemExist(Integer parId) throws SQLException;
	
	Map<String, Object> gipis096ValidateItemNo(Map<String, Object> params) throws SQLException;
	void renumber(Integer parId, GIISUser USER) throws SQLException;	//modified by Gzelle 09302014
	String checkGetDefCurrRt() throws SQLException;		//added by Gzelle 10242014
}
