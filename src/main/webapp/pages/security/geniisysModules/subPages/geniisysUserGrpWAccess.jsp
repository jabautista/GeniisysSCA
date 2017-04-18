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
<div id="giisUserGrpModulesMainDiv" name="giisUserGrpModulesMainDiv">
	<div id="giisUserGrpModules" name="giisUserGrpModules">
		<div class="sectionDiv" style="width: 99%; height: 440px; margin-top: 5px; margin-left: 2px;">
			<div align="center" id="giisUserModulesInfoDiv" style="width: 99%;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Module ID</td>
						<td>
							<input id="txtModuleIdUGAccess" <%-- value="${moduleId}" --%> readonly="readonly" type="text" style="width: 120px;" tabindex="601">
						</td>
						<td style="padding-left: 2px;">
							<input id="txtModuleDescUGAccess" <%-- value="${moduleDesc}" --%> readonly="readonly" type="text" style="width: 425px;" tabindex="602">
						</td>
					</tr>
				</table>
			</div>
			<div id="giisUserGrpModulesTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="giisUserGrpModulesTable" style="height: 150px; margin-left: 0px;"></div>
			</div>
			<div id="giisUsersTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="giisUsersTable" style="height: 166px; margin-left: 0px;"></div>
			</div>
			<div align="center" id="giisUserModulesFormDiv" style="width: 99%; margin-top: 0px; margin-left: 2px;">
				<table style="margin-top: 5px;">
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 531px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; resize: none; height: 16px; width: 505px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  readonly="readonly" onkeyup="limitText(this,4000);" tabindex="603"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="604"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="605"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="606"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 18px;">
				<input type="button" class="button" id="btnReturn" value="Return" tabindex="607" style="width: 80px;">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var objGiisUserGrpModules = {};
	var objCurrGiisUserGrpModules = null;
	objGiisUserGrpModules.giisUserGrpModulesList = JSON.parse('${jsonGiisUserGrpModulesList}');
	
	$("txtModuleIdUGAccess").value = $F("txtModuleId");
	$("txtModuleDescUGAccess").value = $F("txtModuleDesc");
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	var giisUserGrpModulesTable = {
			url : contextPath + "/GIISModuleController?action=showGeniisysUserGrpWAccess&refresh=1" + "&moduleId=" + $F("txtModuleId"),
			options : {
				width : '672px',
				height : '150px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					objCurrGiisUserGrpModules = tbgGiisUserGrpModules.geniisysRows[y];
					setUserGrpFieldValues(objCurrGiisUserGrpModules);
					queryGiisUsers(objCurrGiisUserGrpModules.userGrp);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					setUserGrpFieldValues(null);
					queryGiisUsers(0);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						setUserGrpFieldValues(null);
						queryGiisUsers(0);
						tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
						tbgGiisUserGrpModules.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					setUserGrpFieldValues(null);
					queryGiisUsers(0);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
				},
				onSort: function(){
					setUserGrpFieldValues(null);
					queryGiisUsers(0);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
				},
				onRefresh: function(){
					setUserGrpFieldValues(null);
					queryGiisUsers(0);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
				},				
				prePager: function(){
					setUserGrpFieldValues(null);
					queryGiisUsers(0);
					tbgGiisUserGrpModules.keys.removeFocus(tbgGiisUserGrpModules.keys._nCurrentFocus, true);
					tbgGiisUserGrpModules.keys.releaseKeys();
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
					id : "userGrp",
					title : "User Group",
					align : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '122px'
				},
				{
					id : "userGrpDesc",
					title : "User Grp. Desc.",
					filterOption : true,
					width : '270px'
				},
				{
					id : "accessTag",
					title : "Access Tag",
					filterOption : true,
					width : '122px'
				},
				{
					id : "tranCd",
					title : "Transaction Code",
					align : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '122px'
				}
			],
			rows : objGiisUserGrpModules.giisUserGrpModulesList.rows
	};
	tbgGiisUserGrpModules = new MyTableGrid(giisUserGrpModulesTable);
	tbgGiisUserGrpModules.pager = objGiisUserGrpModules.giisUserGrpModulesList;
	tbgGiisUserGrpModules.render("giisUserGrpModulesTable");
	
	function setUserGrpFieldValues(rec){
		try{
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
		} catch(e){
			showErrorMessage("setUserGrpFieldValues", e);
		}
	}
	
	function queryGiisUsers(userGrp){
		tbgGiisUsers.url = contextPath + "/GIISModuleController?action=queryGiisUsers&refresh=1&userGrp=" + userGrp;
		tbgGiisUsers._refreshList();
	}
	
	var objGiisUsers = {};
	var objCurrGiisUsers = null;
	objGiisUsers.giisUsersList = JSON.parse('${jsonGiisUsersList}');
	
	var giisUsersTable = {
			url : contextPath + "/GIISModuleController?action=queryGiisUsers&refresh=1",
			options : {
				width : '672px',
				height : '165px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
						tbgGiisUsers.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
				},
				onSort: function(){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
				},
				onRefresh: function(){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
				},				
				prePager: function(){
					tbgGiisUsers.keys.removeFocus(tbgGiisUsers.keys._nCurrentFocus, true);
					tbgGiisUsers.keys.releaseKeys();
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
					id : "userId",
					title : "User ID",
					filterOption : true,
					width : '180px'
				},
				{
					id : "userName",
					title : "User Name",
					filterOption : true,
					width : '450px'
				}
			],
			rows : objGiisUsers.giisUsersList.rows
	};
	tbgGiisUsers = new MyTableGrid(giisUsersTable);
	tbgGiisUsers.pager = objGiisUsers.giisUsersList;
	tbgGiisUsers.render("giisUsersTable");
	
	$("btnReturn").observe("click", function(){
		overlayGeniisysUserGrpWAccess.close();
		delete overlayGeniisysUserGrpWAccess;
	});
</script>