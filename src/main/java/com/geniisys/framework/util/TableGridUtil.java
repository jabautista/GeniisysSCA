package com.geniisys.framework.util;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

/**
 * TableGrid class
 * @author jerome orio
 */
public class TableGridUtil{
	
	
	private static SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		TableGridUtil.sqlMapClient = sqlMapClient;
	}

	public static SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
		
	private int startRow;
	private int endRow;
	private int noOfPages;
	private int pageNo;
	private int pageSize;
	private int noOfRows;
	
	private static Logger log = Logger.getLogger(TableGridUtil.class);
	
	public TableGridUtil(){
		
	}
	
	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}

	public int getNoOfPages() {
		return noOfPages;
	}
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void setNoOfPages(Collection c) {
		this.setNoOfRows(0);
		for (Object o: c) {
			try {
				Map properties = BeanUtils.describe(o);
				Object j = properties.get("rowCount");
				this.setNoOfRows(Integer.parseInt((String) j));	
			} catch (IllegalAccessException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (NoSuchMethodException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (NumberFormatException e) {
				// will be used if object class is HashMap, to avoid having problems on BeanUtils.describe (emman 02.16.2011)
				if (o.getClass().equals(HashMap.class)) {
					Map<String, Object> obj = (HashMap<String, Object>) o;
					this.setNoOfRows(Integer.parseInt((obj.get("rowCount") == null) ? "0" : obj.get("rowCount").toString()));
				}
			}
			break;
		}
		double size = this.getNoOfRows();
		double page = this.getPageSize();
		this.noOfPages = this.getNoOfRows()/this.getPageSize();
		if(this.noOfPages<(size/page)){
			this.noOfPages++;
		}
	}
	
	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getNoOfRows() {
		return noOfRows;
	}

	public void setNoOfRows(int noOfRows) {
		this.noOfRows = noOfRows;
	}

	public TableGridUtil(int pageNo, int pageSize) {
		this.startRow = (pageSize*(pageNo-1))+1;
		this.endRow = pageSize*pageNo;
		this.pageNo = pageNo;
		this.pageSize = pageSize;
	}
	
	/**
	 * 
	 * @param mapList
	 */
	public void setNoOfPagesInMap (List<Map<String, Object>> mapList) {
		for (Map<String, Object> o: mapList) {
			this.setNoOfRows(Integer.parseInt(o.get("rowCount").toString()));	
			break;
		}
		
		double size = this.getNoOfRows();
		double page = this.getPageSize();
		this.noOfPages = this.getNoOfRows()/this.getPageSize();
		
		if(this.noOfPages<(size/page)){
			this.noOfPages++;
		}
	}
	
	/**
	 * 
	 * @param request
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	public static Map<String, Object> getTableGrid(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException {
		params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE);		
		
		params.put("from", grid.getStartRow()); 
		boolean showNoOfPage = false;// start added for the total amount SR-5416
		if(params.get("calTotal") != null && params.get("calTotal").equals("calculate")){
			Integer pageNumber = params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE;
			params.put("to", pageNumber*10); // end added for the total amount SR-5416
		}else{
			params.put("to", grid.getEndRow());
			showNoOfPage = true;
		}	
		
		log.info("Creating tableGrid - params : "+params);
		List<?> list = getSqlMapClient().queryForList((String) params.get("ACTION"), params);
		System.out.println("Total no. of records retrieved: "+list.size());
		//params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
		
		params.put("rows", new JSONArray());
		for (Object o: list) { // andrew - 01.09.2012
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		grid.setNoOfPages(list);
		if(showNoOfPage){
			params.put("pages", grid.getNoOfPages());
			params.put("total", grid.getNoOfRows());
		}
		params.remove("filter"); // andrew - workaround to handle issue in filtering double quote "
		return params;
	}
	
	/**
	 * 
	 * @param request
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	public static Map<String, Object> getTableGrid2(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException {
		params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE);		
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());		
		
		log.info("Creating tableGrid - params : "+params);
		List<?> list = getSqlMapClient().queryForList((String) params.get("ACTION"), params);
		
		params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLJavascriptInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		params.remove("filter"); // andrew - workaround to handle issue in filtering double quote "
		return params;
	}
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	public static Map<String, Object> getTableGrid(Map<String, Object> params) throws SQLException, JSONException {
		params.put("currentPage", params.get("page") == null ? 1 : Integer.parseInt((String) params.get("page")));
		params.put("sortColumn", params.get("sortColumn"));
		params.put("ascDescFlg", params.get("ascDescFlg"));
		params.put("filter", "".equals(params.get("objFilter")) || "{}".equals(params.get("objFilter")) ? null :params.get("objFilter"));
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE);		
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());		
		
		log.info("Creating tableGrid - params : "+params);
		List<?> list = getSqlMapClient().queryForList((String) params.get("ACTION"), params);
		System.out.println("Total no. of records retrieved: "+list.size());
		params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		params.remove("filter"); // andrew - workaround to handle issue in filtering double quote "
		return params;
	}
	
	// J. Diago 09.04.2013 - To prepare a table grid with records customized as parameters.
	public static Map<String, Object> getTableGridCustomTable(Map<String, Object> params) throws SQLException, JSONException {
		params.put("currentPage", params.get("page") == null ? 1 : Integer.parseInt((String) params.get("page")));
		params.put("sortColumn", params.get("sortColumn"));
		params.put("ascDescFlg", params.get("ascDescFlg"));
		params.put("filter", "".equals(params.get("objFilter")) || "{}".equals(params.get("objFilter")) ? null :params.get("objFilter"));
		
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE);		
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());		
		
		log.info("Creating tableGrid - params : " + params);
		List<?> list = (List<?>) params.get("rows");
		System.out.println("Total no. of records retrieved: " + list.size());
		params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", list.size());
		params.remove("filter");
		return params;
	}
	
	/*
	 * Created by apollo cruz - 04.10.2015
	 * To handle special characters in nested entities
	*/
	public static Map<String, Object> getTableGrid3(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException {
		params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), params.get("pageSize") != null ? (Integer) params.get("pageSize") : ApplicationWideParameters.PAGE_SIZE);		
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());		
		
		log.info("Creating tableGrid - params : "+params);
		List<?> list = getSqlMapClient().queryForList((String) params.get("ACTION"), params);
		System.out.println("Total no. of records retrieved: " + list.size());
		
		JSONArray jsonArray = new JSONArray(list);
		jsonArray = StringFormatter.escapeHTMLInJSONArray(jsonArray);
		params.put("rows", jsonArray);
		
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		params.remove("filter"); // andrew - workaround to handle issue in filtering double quote "
		return params;
	}
}
