/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.pack.dao.impl
	File Name: GIPIWPackLineSublineDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 11, 2011
	Description: 
*/


package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.pack.dao.GIPIWPackLineSublineDAO;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;

public class GIPIWPackLineSublineDAOImpl extends DAOImpl implements GIPIWPackLineSublineDAO {
	private static Logger log = Logger.getLogger(GIPIWPackLineSublineDAOImpl.class);
	@SuppressWarnings("unchecked")
	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineList(String lineCd)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIWPackLineSublineList",lineCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineListByPParId(
			int packParId ,String lineCd) throws SQLException {
		log.info("GETTING LINE AND SUBLINE FOR PACK PAR ID: "+packParId);
		List<GIPIWPackLineSubline> lineSublines =this.getSqlMapClient().queryForList("getGIPIWPackLineSublineListByPParId", packParId); 
		// get the dspTag per item
		
		for(GIPIWPackLineSubline lineSubline:lineSublines){
			Map<String, Object>params = new HashMap<String, Object>();
			params.put("packLineCd", lineSubline.getPackLineCd());
			params.put("packSublineCd", lineSubline.getPackSublineCd());
			params.put("parId", lineSubline.getParId());
			params.put("lineCd", lineCd);
			lineSubline.setDspTag((String) this.getSqlMapClient().queryForObject("getGIPIWpackLineSublineDspTag", params));
		}
		return lineSublines;
	}

	@Override
	public String getGIPIWpackLineSublineDspTag(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGIPIWpackLineSublineDspTag", params);
	}

	@Override
	public void saveGIPIWPackLineSubline(Map<String, Object> params)
		throws SQLException , JSONException{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String parameter = (String) params.get("parameter");
			int packParId = Integer.parseInt((String) params.get("packParId"));
			String issCd = (String) params.get("issCd");
			String lineCd = (String) params.get("lineCd");
			String appUser = (String) params.get("appUser");
			JSONObject objParameters = new JSONObject(parameter);
			
			log.info("PREPARING DEL PARAMS");
			List<GIPIWPackLineSubline> lineSublineForDelete = this.prepareLineSublineForDelete(new JSONArray(objParameters.getString("delRows")), packParId, lineCd);
			
			log.info("PREPARING INSERT PARAMS");
			List<GIPIWPackLineSubline> lineSublineForInsert = this.prepareLineSublineForInsert(new JSONArray(objParameters.getString("addRows")), packParId, lineCd);
			
			log.info("PREPARING UPDATE PARAMS PARAMS");
			List<GIPIWPackLineSubline> lineSublineForUpdate = this.prepareLineSublineForUpdate(new JSONArray(objParameters.getString("modRows")), packParId, lineCd);
			for(GIPIWPackLineSubline test : lineSublineForUpdate){
				System.out.println(test.getPackLineCd());
			}
			
			// delete items
			if(lineSublineForDelete != null){
				//Map<String, Object>preDeleteParams = null;
				for(GIPIWPackLineSubline lineSubline : lineSublineForDelete){
					//KEYDELREC in forms
					System.out.println(lineSubline.getHasItems());
					if (lineSubline.getHasItems().equals("Y") || lineSubline.getHasPerils().equals("Y")) {
						log.info("LineSubline FOR DELETE HAS ITEMS/PERILS..");
						Map<String, Object>keyDelParams = new HashMap<String, Object>();
						keyDelParams.put("parId", lineSubline.getParId());
						keyDelParams.put("lineCd", lineCd);
						keyDelParams.put("issCd", issCd);
						keyDelParams.put("packLineCd", lineSubline.getPackLineCd());
						keyDelParams.put("packSublineCd", lineSubline.getPackSublineCd());
						keyDelParams.put("hasPerils", lineSubline.getHasPerils());
						keyDelParams.put("appUser", appUser);
						this.getSqlMapClient().insert("GIPIWPackLineSublineKeyDelRec", keyDelParams); // this has pre delete included in the procedure
					}else{
						log.info("LineSubline has no items/perils");
						Map<String, Object>packParams = new HashMap<String, Object>();
						packParams.put("parId", lineSubline.getParId());
						packParams.put("issCd", issCd);
						packParams.put("appUser", appUser);
						this.getSqlMapClient().insert("GIPIWPackLineSublineDelPack", packParams);
						// pre delete function
						/*preDeleteParams = new HashMap<String, Object>();
						log.info("EXECUTING PRE DELETE FUNCTION..");
						preDeleteParams.put("parId", lineSubline.getParId());
						preDeleteParams.put("appUser", appUser);*/
					}
					//this.getSqlMapClient().update("preDelGIPIWPackLineSubline",preDeleteParams); removed because the 
					log.info("deleting LineSubline par Id: "+lineSubline.getParId());
					params.put("parId", lineSubline.getParId());
					params.put("parStatus", 99);
					this.getSqlMapClient().queryForObject("updatePARStatus", params);
					this.getSqlMapClient().insert("delGIPIWPackLineSubline", lineSubline);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			
			// insert items
			if(lineSublineForInsert != null){
				Map<String, Object>postInsertParams = null;
				for(GIPIWPackLineSubline lineSubline : lineSublineForInsert){
					log.info("INSERTING NEW LineSubline par Id: "+lineSubline.getParId());
					this.getSqlMapClient().insert("setGIPIWPackLineSubline", lineSubline);
					
					// post insert items
					postInsertParams = new HashMap<String, Object>();
					postInsertParams.put("issCd",issCd);
					postInsertParams.put("packParId", packParId);		
					postInsertParams.put("packLineCd", lineSubline.getPackLineCd());
					postInsertParams.put("parId", lineSubline.getParId());
					postInsertParams.put("appUser", appUser);
					log.info("EXECUTING POST INSERT..");
					this.getSqlMapClient().update("postInsertGIPIWLineSubline", postInsertParams);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			//update items
			if(lineSublineForUpdate != null){
				for(GIPIWPackLineSubline lineSubline : lineSublineForUpdate){
					log.info("UPDATING LineSubline par Id: "+lineSubline.getParId());
					System.out.println(lineSubline.getRemarks());
					this.getSqlMapClient().insert("setGIPIWPackLineSubline", lineSubline);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void saveEndtGIPIWPackLineSubline(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Debug.print("Params: " + params);
			String parameter = (String) params.get("parameter");
			Integer packParId = Integer.parseInt((String) params.get("packParId"));
			String lineCd = (String) params.get("lineCd");
			String sublineCd = (String) params.get("sublineCd");
			String issCd = (String) params.get("issCd");
			Integer issueYy = Integer.parseInt((String) params.get("issueYy"));
			Integer polSeqNo = Integer.parseInt((String) params.get("polSeqNo"));
			Integer renewNo = Integer.parseInt((String) params.get("renewNo"));
			String appUser = (String) params.get("appUser");
			JSONObject objParameters = new JSONObject(parameter);
			
			List<GIPIWPackLineSubline> lineSublineForDelete = this.prepareLineSublineForDelete(new JSONArray(objParameters.getString("delRows")), packParId, lineCd);
			log.info("Length of Line-Subline For Deletion: " + lineSublineForDelete.size());
			
			List<GIPIWPackLineSubline> lineSublineForInsert = this.prepareLineSublineForInsert(new JSONArray(objParameters.getString("addRows")), packParId, lineCd);
			log.info("Length of Line-Subline For Insert: " + lineSublineForInsert.size());
			
			List<GIPIWPackLineSubline> lineSublineForUpdate = this.prepareLineSublineForUpdate(new JSONArray(objParameters.getString("modRows")), packParId, lineCd);
			log.info("Length of Line-Subline For Update: " + lineSublineForInsert.size());
			
			// Delete
			if(lineSublineForDelete != null){
				
				for(GIPIWPackLineSubline lineSubline : lineSublineForDelete){
					
					System.out.println(lineSubline.getHasItems());
					if (lineSubline.getHasItems().equals("Y") || lineSubline.getHasPerils().equals("Y")) {
						log.info("LineSubline FOR DELETE HAS ITEMS/PERILS..");
						Map<String, Object>keyDelParams = new HashMap<String, Object>();
						keyDelParams.put("parId", lineSubline.getParId());
						keyDelParams.put("lineCd", lineCd);
						keyDelParams.put("issCd", issCd);
						keyDelParams.put("packLineCd", lineSubline.getPackLineCd());
						keyDelParams.put("packSublineCd", lineSubline.getPackSublineCd());
						keyDelParams.put("hasPerils", lineSubline.getHasPerils());
						keyDelParams.put("appUser", appUser);
						System.out.println("parId" + lineSubline.getParId() + " packLineCd:" + lineSubline.getPackLineCd() + " packSublineCd:" + lineSubline.getPackSublineCd() + " hasPerils:"+lineSubline.getHasPerils());
						this.getSqlMapClient().insert("GIPIWPackLineSublineKeyDelRec", keyDelParams); // this has pre delete included in the procedure
					}else{
						log.info("LineSubline has no items/perils");
						Map<String, Object>packParams = new HashMap<String, Object>();
						packParams.put("parId", lineSubline.getParId());
						packParams.put("issCd", issCd);
						packParams.put("appUser", appUser);
						this.getSqlMapClient().insert("GIPIWPackLineSublineDelPack", packParams);
			
					}
					log.info("deleting LineSubline par Id: "+lineSubline.getParId());
					params.put("parId", lineSubline.getParId());
					params.put("parStatus", 99);
					this.getSqlMapClient().queryForObject("updatePARStatus", params);
					this.getSqlMapClient().insert("delGIPIWPackLineSubline", lineSubline);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			
			// insert Line Subline
			if(lineSublineForInsert != null){
				Map<String, Object>postInsertParams = null;
				for(GIPIWPackLineSubline lineSubline : lineSublineForInsert){
					log.info("INSERTING NEW Line_Subline  for par_id: "+lineSubline.getParId());
					this.getSqlMapClient().insert("setGIPIWPackLineSubline", lineSubline);
					
					// post insert parameters
					postInsertParams = new HashMap<String, Object>();
					postInsertParams.put("packParId", packParId);		
					postInsertParams.put("packLineCd", lineSubline.getPackLineCd());
					postInsertParams.put("packSublineCd", lineSubline.getPackSublineCd());
					postInsertParams.put("parId", lineSubline.getParId());
					postInsertParams.put("lineCd", lineCd);
					postInsertParams.put("sublineCd", sublineCd);
					postInsertParams.put("issCd", issCd);
					postInsertParams.put("issueYy", issueYy);
					postInsertParams.put("polSeqNo", polSeqNo);
					postInsertParams.put("renewNo", renewNo);
					postInsertParams.put("appUser", appUser);
					log.info("POST INSERT Params: " + postInsertParams);
					this.getSqlMapClient().update("postInsertGIPIS0094", postInsertParams);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			//update items
			if(lineSublineForUpdate != null){
				for(GIPIWPackLineSubline lineSubline : lineSublineForUpdate){
					log.info("UPDATING LineSubline for par_id: "+lineSubline.getParId());
					this.getSqlMapClient().insert("setGIPIWPackLineSubline", lineSubline);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	private List<GIPIWPackLineSubline> prepareLineSublineForInsert(JSONArray addRows, int packParId, String lineCd) throws SQLException, JSONException{
		List<GIPIWPackLineSubline> lineSublineList = new ArrayList<GIPIWPackLineSubline>();
		GIPIWPackLineSubline lineSubline= null;
		Integer parId;
		for (int i = 0; i < addRows.length(); i++) {
			lineSubline = new GIPIWPackLineSubline();
			lineSubline.setPackParId(packParId);
			log.info("retrieving ParlistParId for new lineSubline.");
			parId = (Integer) this.getSqlMapClient().queryForObject("getParlistParIdNextVal");
			log.info("NEW PAR ID: "+parId);
			lineSubline.setParId(parId);
			lineSubline.setLineCd(lineCd);
			lineSubline.setPackLineCd(addRows.getJSONObject(i).getString("packLineCd"));
			lineSubline.setPackSublineCd(addRows.getJSONObject(i).getString("packSublineCd"));
			lineSubline.setItemTag("N");
			lineSubline.setRemarks((String) (addRows.getJSONObject(i).isNull("remarks") ? null : addRows.getJSONObject(i).get("remarks")));
			//adds to list;
			lineSublineList.add(lineSubline);
		}
		return lineSublineList;
	}

	private List<GIPIWPackLineSubline> prepareLineSublineForUpdate(JSONArray modRows, int packParId, String lineCd) throws SQLException, JSONException{
		//For now the only updatable info is the REMARKS column. Just in case I prepared the whole info for update--irwin
		List<GIPIWPackLineSubline> lineSublineList = new ArrayList<GIPIWPackLineSubline>();
		GIPIWPackLineSubline lineSubline= null;
		for (int i = 0; i < modRows.length(); i++) {
			lineSubline = new GIPIWPackLineSubline();
			lineSubline.setPackParId(packParId);
			lineSubline.setParId(modRows.getJSONObject(i).getInt("parId"));
			lineSubline.setLineCd(lineCd);
			lineSubline.setPackLineCd(modRows.getJSONObject(i).getString("packLineCd"));
			lineSubline.setPackSublineCd(modRows.getJSONObject(i).getString("packSublineCd"));
			lineSubline.setItemTag("N");
			lineSubline.setRemarks((String) (modRows.getJSONObject(i).isNull("remarks") ? null : modRows.getJSONObject(i).get("remarks")));
			//adds to list;
			lineSublineList.add(lineSubline);
		}
		return lineSublineList;
	}
	private List<GIPIWPackLineSubline> prepareLineSublineForDelete(JSONArray delRows, int packParId, String lineCd) throws SQLException, JSONException{
		List<GIPIWPackLineSubline> lineSublineList = new ArrayList<GIPIWPackLineSubline>();
		GIPIWPackLineSubline lineSubline= null;
		
		for (int i = 0; i < delRows.length(); i++) {
			lineSubline = new GIPIWPackLineSubline();
			lineSubline.setParId(delRows.getJSONObject(i).getInt("parId"));
			lineSubline.setLineCd(lineCd);
			lineSubline.setPackLineCd(delRows.getJSONObject(i).getString("packLineCd"));
			lineSubline.setPackSublineCd(delRows.getJSONObject(i).getString("packSublineCd"));
			lineSubline.setHasItems(delRows.getJSONObject(i).getString("hasItems"));
			lineSubline.setHasPerils(delRows.getJSONObject(i).getString("hasPerils"));
			//adds to list;
			lineSublineList.add(lineSubline);
		}
		return lineSublineList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkIfExistGIPIWPackItemPeril(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().insert("checkIfExistGIPIWPackItemPeril", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPackLineSubline> getGIPIWPackEndtLineSublineList(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIWPackEndtLineSublineList",params);
	}

	@Override
	public void delGIPIWPackLineSublineByPackParId(Integer packParId)
			throws SQLException {
		this.getSqlMapClient().delete("delGIPIWPackLineSublineByPackParId", packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineList2(
			Integer packParId, String lineCd) throws SQLException {
		log.info("GETTING LINE AND SUBLINE FOR PACK PAR ID: "+packParId);
		List<GIPIWPackLineSubline> lineSublines =this.getSqlMapClient().queryForList("getGIPIWPackLineSublineList2", packParId); 
		// get the dspTag per item
		
		for(GIPIWPackLineSubline lineSubline:lineSublines){
			Map<String, Object>params = new HashMap<String, Object>();
			params.put("packLineCd", lineSubline.getPackLineCd());
			params.put("packSublineCd", lineSubline.getPackSublineCd());
			params.put("parId", lineSubline.getParId());
			params.put("lineCd", lineCd);
			lineSubline.setDspTag((String) this.getSqlMapClient().queryForObject("getGIPIWpackLineSublineDspTag", params));
		}
		return lineSublines;
	}

}
