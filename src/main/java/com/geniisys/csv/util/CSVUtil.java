package com.geniisys.csv.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import com.geniisys.csv.CreateCSV;
import com.geniisys.framework.util.ConnectionUtil;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class CSVUtil {
	
	private static SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		CSVUtil.sqlMapClient = sqlMapClient;
	}

	public static SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public static void createCSV(Map<String, Object> params) throws SQLException, IOException, ParseException{
		String path = params.get("realPath") + "/csv\\";
		String filename = params.get("OUTPUT_REPORT_FILENAME") + ".csv";
		
		(new File(path)).mkdirs();
		
		List<String> cols = getSqlMapClient().queryForList("getCSVReportColumns", params);
		
		List<Map<String, Object>> recs = getSqlMapClient().queryForList(params.get("csvAction").toString(), params);
		
		FileWriter writer = new FileWriter(path + filename);
		
		SimpleDateFormat dt = new SimpleDateFormat("d-MMM-yyyy");
		System.out.println("csvVersion : "+params.get("csvVersion"));
		if(params.get("csvVersion") != null && params.get("csvVersion") != "" && params.get("csvVersion") == "dynamicSQL"){
			String query = null;
			System.out.println("csvAction :" + params.get("csvAction").toString());
			
			List<Map<String, Object>> dynamicQuery = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList3(getSqlMapClient().queryForList(params.get("csvAction").toString(),params));
			
			for(Map<String, Object> d : dynamicQuery) {
				System.out.println("d : "+ d);
				if (d.get("QUERY1") != null) query = StringFormatter.escapeHTMLInObject2(d.get("QUERY1")).toString();
				if (d.get("QUERY2") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY2")).toString();
				if (d.get("QUERY3") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY3")).toString();
				if (d.get("QUERY4") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY4")).toString();
				if (d.get("QUERY5") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY5")).toString();
				if (d.get("QUERY6") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY6")).toString();
				if (d.get("QUERY7") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY7")).toString();
				if (d.get("QUERY8") != null) query = query + StringFormatter.escapeHTMLInObject2(d.get("QUERY8")).toString();
				System.out.println("QUERY MAIN : "+ query);
			}
			
			Connection connection = (Connection) params.get("CONNECTION");
	
			String[] parameters = new String[6];        
	        
			parameters[0] = params.get("ip").toString() ; 
			parameters[1] = params.get("databaseName").toString();
			parameters[2] = params.get("username").toString();
			parameters[3] = params.get("password").toString();
			parameters[4] = path + filename;
			parameters[5] = query; 
	
			try {
				String temp = CreateCSV.main(parameters, connection);
				if(temp.toUpperCase().contains("ERROR")){
					// throw new Exception;
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally{
				ConnectionUtil.releaseConnection(connection);				
			}
		}else if (params.get("createCSVFromString") != null && params.get("createCSVFromString").equals("Y")) { //added by apollo cruz 07.02.2015 - to create csv from string generated in the database
			try {																							// solution for column names exceeding 30 characters which are not handled in CreateCSV.main()
				for(Map<String, Object> m : recs){
					writer.append(m.get("REC").toString());
					writer.append('\n');
				}
				writer.flush();
			} catch (IOException e) {
				e.printStackTrace();
				throw e;
			} finally {
				writer.close();
			}			
		} else {
			try {
				if(params.get("displayCols") != null && params.get("displayCols") != ""){
					List<String> displayCols = getSqlMapClient().queryForList(params.get("displayCols").toString());
					for(String d : displayCols) {
						writer.append(d);
						writer.append(',');
					}
				} else {
					for(String c : cols) {
						writer.append(c);
						writer.append(',');
					}
				}
				
				writer.append('\n');
				
				for(Map<String, Object> r : recs){				
					for(String c : cols) {
						String val = String.valueOf(r.get(c));
						
						if(val != "null") {
							String type = r.get(c).getClass().getName();
							if(type.toLowerCase().contains("date"))
								val = String.valueOf(dt.format(r.get(c)));						
						} else
							val = "";
						
						writer.append("\"" + val.replaceAll("\"", "\"\"") + "\"");
						writer.append(',');
					}
					writer.append('\n');
				}
				
				writer.flush();
			} catch (IOException e) {
				e.printStackTrace();
				throw e;
			} finally {
				writer.close();
			}
		}
	}

}
