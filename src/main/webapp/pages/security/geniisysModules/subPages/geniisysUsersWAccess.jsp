<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giisUserModulesMainDiv" name="giisUserModulesMainDiv">
	<div id="giisUserModules" name="giisUserModules">
		<div class="sectionDiv" style="width: 99%; height: 440px; margin-top: 5px; margin-left: 2px;">
			<div align="center" id="giisUserModulesInfoDiv" style="width: 99%;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Module ID</td>
						<td>
							<input id="txtModuleIdUAccess" <%-- value="${moduleId}" --%> readonly="readonly" type="text" style="width: 120px;" tabindex="601">
						</td>
						<td style="padding-left: 2px;">
							<input id="txtModuleDescUAccess" <%-- value="${moduleDesc}" --%> readonly="readonly" type="text" style="width: 425px;" tabindex="602">
						</td>
					</tr>
				</table>
			</div>
			<div id="giisUserModulesTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="giisUserModulesTable" style="height: 350px; margin-left: 0px;"></div>
			</div>
			<div align="center" id="giisUserModulesFormDiv" style="width: 99%; margin-top: 0px; margin-left: 2px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="603"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="604"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 18px;">
				<input type="button" class="button" id="btnReturn" value="Return" tabindex="605" style="width: 80px;">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var objGiisUserModules = {};
	var objCurrGiisUserModules = null;
	objGiisUserModules.giisUserModulesList = JSON.parse('${jsonGiisUserModulesList}');
	
	$("txtModuleIdUAccess").value = $F("txtModuleId");
	$("txtModuleDescUAccess").value = $F("txtModuleDesc");
	
	var giisUserModulesTable = {
			url : contextPath + "/GIISModuleController?action=showGeniisysUsersWAccess&refresh=1" + "&moduleId=" + $F("txtModuleId"),
			options : {
				width : '672px',
				height : '345px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					objCurrGiisUserModules = tbgGiisUserModules.geniisysRows[y];
					setUserFieldValues(objCurrGiisUserModules);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					setUserFieldValues(null);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						setUserFieldValues(null);
						tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
						tbgGiisUserModules.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					setUserFieldValues(null);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				},
				onSort: function(){
					setUserFieldValues(null);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				},
				onRefresh: function(){
					setUserFieldValues(null);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				},				
				prePager: function(){
					setUserFieldValues(null);
					tbgGiisUserModules.keys.removeFocus(tbgGiisUserModules.keys._nCurrentFocus, true);
					tbgGiisUserModules.keys.releaseKeys();
				}
			},
			columnModel : [
					{ 								// this column will only use for deletion
					    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					    width: '0',				    
					    visible : false			
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : "userid",
						title : "User ID",
						filterOption : true,
						width : '80px'
					},
					{
						id : 'userName',
						filterOption : true,
						title : 'User Name',
						width : '500px'				
					},
					{
						id : "accessTag",
						title : "Access Tag",
						filterOption : true,
						width : '70px'
					},
					{
						id : 'userId',
						width : '0',
						visible: false
					},
					{
						id : 'lastUpdate',
						width : '0',
						visible: false				
					}
			],
			rows : objGiisUserModules.giisUserModulesList.rows
	};
	tbgGiisUserModules = new MyTableGrid(giisUserModulesTable);
	tbgGiisUserModules.pager = objGiisUserModules.giisUserModulesList;
	tbgGiisUserModules.render("giisUserModulesTable");
	
	function setUserFieldValues(rec){
		try{
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
		} catch(e){
			showErrorMessage("setUserFieldValues", e);
		}
	}
	
	$("btnReturn").observe("click", function(){
		overlayGeniisysUserWAccess.close();
		delete overlayGeniisysUserWAccess;
	});
</script>