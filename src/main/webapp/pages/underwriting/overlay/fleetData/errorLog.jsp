<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" style="width: 618px; margin-top: 10px;">
	<div style="padding: 10px 0 10px 10px; width: 550px; height: 230px;">
		<div id="errorLogTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<div>
		<table align="center">
			<tr>
				<td><label for="txtRemarks" style="float: right; margin-right: 5px;">Remarks</label></td>
				<td colspan="3">
					<input type="text" id="txtRemarks" style="width: 400px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td><label for="txtUserId" style="float: right; margin-right: 5px;">User ID</label></td>
				<td>
					<input type="text" id="txtUserId" readonly="readonly"/>
				</td>
				<td><label for="txtDateUploaded" style="float: right; margin-right: 5px;">Date Uploaded</label></td>
				<td style="width: 1px;">
					<input type="text" id="txtDateUploaded" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="text-align: center; margin: 10px auto;">
		<input type="button" id="btnExitErrorLog" class="button" value="Return" style="width: 100px;"/>
	</div>	
</div>
<script type="text/javascript">
	try {
		
		var jsonGIPIS198ErrorLog = JSON.parse('${jsonGIPIS198ErrorLog}');
		errorLogTableModel = {
				id: "tbgErrorLog",
				url: contextPath + "/FleetUploadController?action=viewErrorLog2&refresh=1&fileName"+$F("file"),
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: 598,
					height: 205,
					onCellFocus : function(element, value, x, y, id) {
						$("txtRemarks").value = unescapeHTML2(tbgErrorLog.geniisysRows[y].remarks);
						$("txtUserId").value = tbgErrorLog.geniisysRows[y].userId;
						$("txtDateUploaded").value = dateFormat(tbgErrorLog.geniisysRows[y].lastUpdate, "mm-dd-yyyy");
						
						tbgErrorLog.keys.removeFocus(tbgErrorLog.keys._nCurrentFocus, true);
						tbgErrorLog.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						$("txtRemarks").clear();
						$("txtUserId").clear();
						$("txtDateUploaded").clear();
						
						tbgErrorLog.keys.removeFocus(tbgErrorLog.keys._nCurrentFocus, true);
						tbgErrorLog.keys.releaseKeys();
					},
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "uploadNo",
						title: "Upload No.",
						width: 100,
						align: "right",
						titleAlign: "right",
						filterOption : true
					},
					{
						id : "itemTitle",
						title: "Item",
						width: 160,
						filterOption : true,
						renderer: function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id : "motorNo",
						title: "Motor No.",
						width: 130,
						filterOption : true,
						renderer: function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id : "plateNo",
						title: "Plate No.",
						width: 130,
						filterOption : true,
						renderer: function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id : "serialNo",
						title: "Serial No.",
						width: 130,
						filterOption : true,
						renderer: function(val){
							return unescapeHTML2(val);
						}
					}
				],
				rows: jsonGIPIS198ErrorLog.rows
			};
		
		tbgErrorLog = new MyTableGrid(errorLogTableModel);
		tbgErrorLog.pager = jsonGIPIS198ErrorLog;
		tbgErrorLog.render('errorLogTable');
		tbgErrorLog.afterRender = function(){
			$("txtRemarks").clear();
			$("txtUserId").clear();
			$("txtDateUploaded").clear();
		};
		
		$("btnExitErrorLog").observe("click", function(){
			overlayErrorLog.close();
			delete overlayErrorLog;
		});
	} catch (e) {
		showErrorMessage("Error", e);
	}
</script>