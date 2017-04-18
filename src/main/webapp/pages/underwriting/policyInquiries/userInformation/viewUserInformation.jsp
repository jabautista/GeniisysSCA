<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewUserInformationMainDiv" name="viewUserInformationMainDiv">
	<div id="viewUserInformationSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="viewUserInformationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>View User Information</label>
		</div>
	</div>
	
	<div id="userInformationTableDiv" name="userInformationTableDiv" class="sectionDiv">
		<div id="userInformationTable" name="userInformationTable" style="height:320px; margin: 10px 10px 10px 10px;"></div>
		
		<div id="userInformationDetailDiv" name="userInformationDetailDiv" style="margin: 0px 10px 10px 10px;">
			<table align="center" style="padding-left: 20px; padding-right: 20px;">
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan="5" class="leftAligned">
						<div style="border: 1px solid gray; width: 700px;">
							<textarea id="remarks" name="remarks" style="width: 620px; border: none; height: 13px; resize: none;" readonly="readonly" tabindex=101></textarea> 
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksText" tabindex="102"/>
						</div>
					</td>
				</tr>
				</table>
				<table style="margin-bottom: 10px;">
					<tr align="center">
						<td class="rightAligned" style="width:118px;">User ID</td>
						<td class="leftAligned" style="width: 53.8%">
							<input type="text" id="txtUserId" name="txtUserId" class="text" readonly="readonly" style="width: 180px;" tabindex="103"/>
						</td>
						<td class="rightAligned" >Last Update 
							<input type="text" id="txtLastUpdate" name="txtLastUpdate" class="text" style="width: 180px;" readonly="readonly" tabindex="104"/>
						</td>
					</tr>
				</table>
		</div>
		<div class="buttonsDiv" >
			<input type="button" class="button" id="btnTransaction" name="btnTransaction" value="Transaction" style="width:150px;" tabindex="201" />
			<input type="button" class="button" id="btnUserGrpAccess" name="btnUserGrpAccess" value="User Group Access" style="width:150px;" tabindex="202"/>
			<input type="button" class="button" id="btnUserHistory" name="btnUserHistory" value="User History" style="width:150px;" tabindex="203"/>
		</div>
	</div> 
</div>

<script type="text/javascript">
	setDocumentTitle("View User Information");
	setModuleId("GIPIS152");
	selectedUser = null;
	selectedUserGrp = null;
	selectedUserGrpDesc = null;
	selectedTranCd = null;
	selectedTranCdGrp = null;
	selectedGrpIssCd = null;
	objUserInfo = new Object();
	objUserInfo.selectedAccess = null;
	try{
		var row = null;
		var objCurrUser = null;
		var objUserInfoMain = [];
		objUserInfo.objUserInfoListing = JSON.parse('${jsonUserInfo}'.replace(/\\/g, '\\\\'));
		objUserInfo.userInfoList = objUserInfo.objUserInfoListing.rows || [];
		var tbgUserInfo = {
				url: contextPath+"/GIPIPolbasicController?action=showViewUserInformation&refresh=1",
			options: {
				width: '900px',
				height: '282px',
				id: 1,
				onCellFocus: function(element, value, x, y, id){
					row = y;
					objCurrUser = userInfoTableGrid.geniisysRows[y];
					populateUserInfoDetail(objCurrUser);
					userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
					userInfoTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					populateUserInfoDetail(null);
					userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
					userInfoTableGrid.keys.releaseKeys();
	            },
                onSort: function(){
                	populateUserInfoDetail(null);
                	userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
                	userInfoTableGrid.keys.releaseKeys();
                },
                prePager: function(){
                	populateUserInfoDetail(null);
                	userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
                	userInfoTableGrid.keys.releaseKeys();
                },
				onRefresh: function(){
					populateUserInfoDetail(null);
					userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
					userInfoTableGrid.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						populateUserInfoDetail(null);
						userInfoTableGrid.keys.removeFocus(userInfoTableGrid.keys._nCurrentFocus, true);
						userInfoTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
			    {   id: 'activeFlag',
				    title: 'A',
				    width: '30px',
				    editable : false,
				    align : 'center',
				    titleAlign: 'center',
					altTitle : 'Active Tag',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{	id: 'commUpdateTag',
					title: 'C',
					width: '30px',
					editable : false,
					align : 'center',
					titleAlign: 'center',
					altTitle : 'Commission Tag',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{	id: 'allUserSw',
					title: 'U',
					width: '30px',
					editable : false,
					align : 'center',
					titleAlign: 'center',
					altTitle : 'All Users Switch',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{	id: 'mgrSw',
					title: 'M',
					width: '30px',
					editable : false,
					align : 'center',
					titleAlign: 'center',
					altTitle : 'Manager Switch',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{	id: 'userId',
					title: 'User ID',
					width: '120px',
					filterOption : true
				},
				{	id: 'userName',
					title: 'User Name',
					width: '250px',
					filterOption : true
				},
				{	id: 'userGrp',
					title: 'Group',
					width: '90px',
					align : 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					titleAlign : 'right',
					renderer : function (value){
						return formatNumberDigits(value, 2);
					}
				},
				{	id: 'userGrpDesc',
					title: 'Description',
					width: '280px',
					filterOption : true
				}
				],
			rows: objUserInfo.userInfoList
		};
		
		userInfoTableGrid = new MyTableGrid(tbgUserInfo);
		userInfoTableGrid.pager = objUserInfo.objUserInfoListing;
		userInfoTableGrid.render('userInformationTable');
	}catch (e) {
		showErrorMessage("viewUserInformation", e);
	}
	
	function populateUserInfoDetail(record) {
		$("remarks").value 		 = record == null ? "" : unescapeHTML2(record.remarks);
		$("txtUserId").value 	 = record == null ? "" : record.lastUserId;
		$("txtLastUpdate").value = record == null ? "" : record.lastUpdate;
		selectedUser 			 = record == null ? "" : record.userId;
		selectedUserGrp			 = record == null ? "" : record.userGrp;
		selectedUserGrpDesc		 = record == null ? "" : record.userGrpDesc;
		selectedGrpIssCd		 = record == null ? "" : record.grpIssCd;	
	}
	
	function showUserInfoTransaction() {
		try {
			overlayTransaction = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {action : "getTranList",
								 userId : selectedUser},
				title : "Transactions",
				height : '420px',
				width : '700px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUserInfoTransaction Overlay", e);
		}
	}
	
	function showUserInfoGrpTransaction() {
		try {
			overlayTransaction = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {action : "getGrpTranList",
								 userGrp : selectedUserGrp},
				title : "Transactions",
				height : '420px',
				width : '700px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUserInfoTransaction Overlay", e);
		}
	}
	
	function showUserInfoHistory() {
		try {
			overlayHistory = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {action : "getHistoryList",
								 userId : selectedUser},
				title : "User History",
				height : '430px',
				width : '815px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUserInfoHistory Overlay", e);
		}
	}
	
	$("editRemarksText").observe("click", function () {
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"),"");
	});
	
	 $("btnTransaction").observe("click", function() {
		 objUserInfo.selectedAccess = "Transaction";
		 showUserInfoTransaction();
	});
	 
	$("btnUserGrpAccess").observe("click", function() {
		objUserInfo.selectedAccess = "UserGrpAccess";
		showUserInfoGrpTransaction();
	});
	
	$("btnUserHistory").observe("click", function() {
		showUserInfoHistory();
	});
	
	$("viewUserInformationExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
</script>