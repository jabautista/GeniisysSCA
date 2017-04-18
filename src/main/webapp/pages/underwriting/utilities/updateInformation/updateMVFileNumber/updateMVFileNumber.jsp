<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updateMVFileNumberMainDiv" name="updateMVFileNumberMainDiv" style="padding-bottom: 20px;">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Update MV File Number</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="billPerPolicyFormDiv">
		<table cellspacing="0" align="center" style="padding: 20px; width: 900px;">
			<tr>
				<td class="rightAligned" style="width:90px;">Policy No.</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<input class="polNoReq allCaps required" type="text" id="txtPolLineCd" name="txtPolLineCd" ignoreDelKey="1" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101">
					<input class="polNoReq allCaps required" type="text" id="txtPolSublineCd" name="txtPolSublineCd" ignoreDelKey="1" style="width: 80px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
					<input class="polNoReq allCaps required" type="text" id="txtPolIssCd" name="txtPolIssCd" ignoreDelKey="1" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
					<input class="polNoReq integerUnformatted required" lpad="2" type="text" id="txtPolIssueYy" ignoreDelKey="1" name="txtPolIssueYy" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="104" />
					<input class="polNoReq integerUnformatted required" lpad="7" type="text" id="txtPolSeqNo" ignoreDelKey="1" name="txtPolSeqNo" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="105" />
					<input class="polNoReq integerUnformatted required" lpad="2" type="text" id="txtPolRenewNo" ignoreDelKey="1" name="txtPolRenewNo" style="width: 30px; float: left;" maxlength="3" tabindex="106" />
					<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
				<td class="rightAligned" style="width:100px;">Endorsement No</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" tabindex="107"/>
					<input class="rightAligned" type="text" id="txtEndtYy" name="txtEndtYy" lpad="2" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" tabindex="108"/>
					<input class="rightAligned" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" lpad="7" style="width: 100px; float: left; margin: 2px 4px 0 0" maxlength="30" readonly="readonly" tabindex="109"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" colspan="3">
					<input class="" type="text" id="txtAssured" name="txtAssured" style="width:743px;" readonly="readonly" tabindex="110">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Incept Date</td>
				<td class="leftAligned">
					<input class="" type="text" id="txtIncDate" name="txtIncDate" style="width:225px;" readonly="readonly" tabindex="111">
				</td>
				<td class="rightAligned">Expiry Date</td>
				<td class="leftAligned">
					<input class="" type="text" id="txtExpDate" name="txtExpDate" style="width:225px;" readonly="readonly" tabindex="113">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Effectivity Date</td>
				<td class="leftAligned">
					<input class="" type="text" id="txtEffDate" name="txtEffDate" style="width:225px;" readonly="readonly" tabindex="112">
				</td>
				<td class="rightAligned">Endt Expiry Date</td>
				<td class="leftAligned">
					<input class="" type="text" id="txtEndtExpDate" name="txtEndtExpDate" style="width:225px;" readonly="readonly" tabindex="114">
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="margin-bottom: 15px;">
		<div id="tableMVFileNumber" style="padding: 5px; height: 260px;">
			<div id="tableMVFileNumberDiv" style="height: 100%;"></div>
		</div>
		<div align="center" id="detailsDiv">
			<table align="center">
				<tr>
					<td class="rightAligned">Item No.</td>
					<td class="leftAligned">
						<input type="text" id="txtItemNo" tabindex="401" style="width: 100px;" readonly="readonly" tabindex="201"/>
					</td>
					<td class="rightAligned" width="120px">MV File Number</td>
					<td class="leftAligned">
						<input type="text" id="txtMVFileNumber" tabindex="402" style="width: 400px;" readonly="readonly" maxlength="15" tabindex="202"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Item Title</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="txtItemTitle"  tabindex="402" style="width: 640px;" readonly="readonly" tabindex="203"/>
					</td>
				</tr>
			</table>
		</div>
		<div align="center" style="padding: 15px;">
			<input type="button" class="button" id="btnUpdate" value="Update" tabindex="402" style="width: 100px;" tabindex="204"/>
		</div>
	</div>
	<div align="center" style="margin-bottom: 15px;">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="402" style="width: 80px;" tabindex="301"/>
		<input type="button" class="button" id="btnSave" value="Save" tabindex="402" style="width: 80px;" tabindex="302"/>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setModuleId("GIUTS032");
	setDocumentTitle("Update MV File Number");
	resetForm();
	var row = -1;
	var objCurr = null;
	objExit = new Object();
	var changeTag = 0;
	var objUpdatedItems = [];
	
	function resetForm(){
		$("txtPolLineCd").focus();
		showTableGrid();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnUpdate");
		disableButton("btnSave");
		objParam = new Object();
		changeTag = 0;
		$$("div#billPerPolicyFormDiv input[type='text']").each(function(a) {
			a.clear();
		});
		//$("txtPolLineCd").value = "MC";
		policyFieldsSw(false);
		populateDetailsForm(null);
	}
	
	function showTableGrid(){
		try {
			mvFileNumberTableModel = {
				url : contextPath+ "/UpdateUtilitiesController?action=showUpdateMVFileNo",
				id: 1,
				options : {
					height : '250px',
					hideColumnChildTitle : true,
					validateChangesOnPrePager: false,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						objCurr = tbgUpdateMVFileNumber.geniisysRows[y];
						row = y;
						populateDetailsForm(tbgUpdateMVFileNumber.geniisysRows[y]);
						tbgUpdateMVFileNumber.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						row = -1;
						populateDetailsForm(null);
						tbgUpdateMVFileNumber.keys.releaseKeys();
					},
					onSort : function(){
						row = -1;
						populateDetailsForm(null);
						tbgUpdateMVFileNumber.keys.releaseKeys();
						reupdateRows();
					},
					postPager: function(){
						row = -1;
						populateDetailsForm(null);
						tbgUpdateMVFileNumber.keys.releaseKeys();
						reupdateRows();
					},
					/*beforeSort : function() {
						if(changeTag == 1){
							showMessageBox("Please save changes first.", "I");	
							return false;
						} else {
							return true;
						}
					},
					prePager: function(){
						if(changeTag == 1){
							showMessageBox("Please save changes first.", "I");	
							return false;
						} else {
							return true;
						}
					},*/
					onRefresh : function(){
						row = -1;
						populateDetailsForm(null);
						tbgUpdateMVFileNumber.keys.releaseKeys();
					},checkChanges: function(){
						return (changeTag == 1 ? true : false);
					},
					/*masterDetailRequireSaving: function(){
						return (changeTag == 1 ? true : false);
					},*/
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailSaveFunc: function() {
						//return (changeTag == 1 ? true : false);
						fireEvent($('btnSave'), 'click');
					},
					masterDetailNoFunc: function(){
						//return (changeTag == 1 ? true : false);
						objUpdatedItems = [];
						tbgUpdateMVFileNumber._refreshList();
						changeTag = 0;
					},
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function(){
							row = -1;
							populateDetailsForm(null);
							tbgUpdateMVFileNumber.keys.releaseKeys();
						},
						onRefresh : function(){
							row = -1;
							populateDetailsForm(null);
							tbgUpdateMVFileNumber.keys.releaseKeys();
						}
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "itemNo",
						title : "Item No.",
						align : "right",
						titleAlign: "right",
						width : '80px',
						filterOptionType: 'integerNoNegative',
						filterOption : true,
					},
					{
						id : "itemTitle",
						title : "Item Title",
						align : "left",
						titleAlign: "left",
						width : '550px',
						filterOption : true,
					},
					{
						id : "mvFileNo",
						title : "MV File Number",
						align : "left",
						titleAlign: "left",
						width : '268px',
						filterOption : true,
					}
				],
				rows : []
			};
			tbgUpdateMVFileNumber = new MyTableGrid(mvFileNumberTableModel);
			tbgUpdateMVFileNumber.render('tableMVFileNumberDiv');
		} catch (e) {
			showErrorMessage("updateMVFileNumber.jsp", e);
		}
	}
	
	function reupdateRows(){
		var g = tbgUpdateMVFileNumber.getColumnIndex("itemTitle");
		var mtgId = tbgUpdateMVFileNumber._mtgId;
				
		for (var a = 0; a < tbgUpdateMVFileNumber.geniisysRows.length; a++){
			for (var b = 0; b < objUpdatedItems.length; b++){
				if (tbgUpdateMVFileNumber.geniisysRows[a].itemNo == objUpdatedItems[b].itemNo){
					tbgUpdateMVFileNumber.geniisysRows[a].mvFileNo = objUpdatedItems[b].mvFileNo;
					tbgUpdateMVFileNumber.updateVisibleRowOnly(tbgUpdateMVFileNumber.geniisysRows[a], a);
				}
			}
		}
		//tbgUpdateMVFileNumber.modifiedRows = [];
	}
	
	function showPolicyLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
								 action   : "getGiuts032PolLOV",
								 lineCd	  : $("txtPolLineCd").value,
								 sublineCd: $("txtPolSublineCd").value,
								 issCd    : $("txtPolIssCd").value,
								 issueYy  : $("txtPolIssueYy").value,
								 polSeqNo : $("txtPolSeqNo").value,
								 renewNo  : $("txtPolRenewNo").value,
				},
				title: "List of Policy Number",
				width: 390,
				height: 392,
				hideColumnChildTitle : true,
				columnModel: [
		 			{
						id : 'policyNumber',
						title: 'Policy Number',
						align: 'right',
						width : 227,
						titleAlign : 'center',
						children : [ {
							id : 'lineCd',
							title : 'Line Code',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'sublineCd',
							title : 'Subline Code',
							width : 50,
							filterOption : true,
							editable : false
						}, {
							id : 'issCd',
							title : 'Issue Issue Code',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'issueYy',
							title : 'Issue Year',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						}, {
							id : 'polSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : 50,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
							editable : false
						},{
							id : 'renewNo',
							title : 'Renew No',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						} ]
					}, {
						id : 'endtNo',
						title: 'Endorsement Number',
						align: 'right',
						width: 130,
						titleAlign : 'center',
						children : [ {
							id : 'endtIssCd',
							title : 'endt Iss Code',
							width : 35,
							filterOption : true,
							editable : false
						},{
							id : 'endtYy',
							title : 'Endt Yy',
							type : 'number',
							align : 'right',
							width : 35,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return value==""? "": formatNumberDigits(value, 2);
							},
							editable : false
						},{
							id : 'endtSeqNo',
							title : 'Renew No',
							type : 'number',
							align : 'right',
							width : 60,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return value==""? "": formatNumberDigits(value, 7);
							},
							editable : false
						} ]
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				onSelect: function(row) {
					if(row != undefined){
						objParam.polId = unescapeHTML2(row.policyId);
						$("txtPolLineCd").value 	= unescapeHTML2(row.lineCd);
						$("txtPolSublineCd").value 	= unescapeHTML2(row.sublineCd);
						$("txtPolIssCd").value 		= unescapeHTML2(row.issCd);
						$("txtPolIssueYy").value 	= formatNumberDigits(row.issueYy,2);
						$("txtPolSeqNo").value 		= formatNumberDigits(row.polSeqNo,7);
						$("txtPolRenewNo").value 	= formatNumberDigits(row.renewNo,2);
						$("txtEndtIssCd").value 	= unescapeHTML2(row.endtIssCd);
						$("txtEndtYy").value 		= row.endtYy == null ? "" : formatNumberDigits(row.endtYy,2);
						$("txtEndtSeqNo").value 	= row.endtSeqNo == null ? "" : formatNumberDigits(row.endtSeqNo,7);
						$("txtAssured").value 		= unescapeHTML2(row.assdName);
						$("txtIncDate").value 		= dateFormat(row.incDate, "mm-dd-yyyy");
						$("txtExpDate").value 		= dateFormat(row.expDate, "mm-dd-yyyy");
						$("txtEffDate").value 		= dateFormat(row.effDate, "mm-dd-yyyy");
						$("txtEndtExpDate").value 	= row.endtExpDate == null ? "" : dateFormat(row.endtExpDate, "mm-dd-yyyy");
						policyFieldsSw(true);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtPolLineCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showPolicyLOV",e);
		}
	}
	
	function queryTable(){
		tbgUpdateMVFileNumber.url = contextPath+ "/UpdateUtilitiesController?action=showUpdateMVFileNo&refresh=1&policyId="+objParam.polId;
		tbgUpdateMVFileNumber._refreshList();
		if (tbgUpdateMVFileNumber.geniisysRows.length == 0) {
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtPolLineCd");
		}
		
		disableToolbarButton("btnToolbarExecuteQuery");
		policyFieldsSw(true);
		enableButton("btnSave");
	}
	
	function policyFieldsSw(sw){
		$("txtPolLineCd").readOnly = sw;
		$("txtPolSublineCd").readOnly = sw;
		$("txtPolIssCd").readOnly = sw;
		$("txtPolIssueYy").readOnly = sw;
		$("txtPolSeqNo").readOnly = sw;
		$("txtPolRenewNo").readOnly = sw;
		sw ? disableSearch("searchPolicyNo") : enableSearch("searchPolicyNo");
	}
	
	function populateDetailsForm(rec){
		try{
			rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			objParam.itemNo = rec == null ? "" : unescapeHTML2(rec.itemNo);
			$("txtMVFileNumber").readOnly 	= rec == null ? true : false;
			$("txtItemNo").value 			= rec == null ? "" : unescapeHTML2(rec.itemNo);
			$("txtMVFileNumber").value		= rec == null ? "" : unescapeHTML2(rec.mvFileNo);
			$("txtItemTitle").value			= rec == null ? "" : unescapeHTML2(rec.itemTitle);
		} catch(e){	
			showErrorMessage("populateDetailsForm", e);
		}
	}
	
	function saveMVFileNumberUpdate(func){
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController?action=saveGipis032MVFileNoUpdate",{
				method: "POST",
				asynchronous: false,
				parameters:{
					/*policyId: objParam.polId,
					mvFileNo: $("txtMVFileNumber").value,
					itemNo  : objParam.itemNo*/
					setRows : prepareJsonAsParameter(objUpdatedItems)
				},
				onCreate:function(){
					showNotice("Saving Update File MV Number, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							/* showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							changeTag = 0; */
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								objUpdatedItems = [];
								tbgUpdateMVFileNumber._refreshList();
								
								if(objExit.exitPage != null) {
									objExit.exitPage();
								} else if(func != null){
									func();
								}
							});
							changeTag = 0;
						}else{
							showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveMVFileNumberUpdate", e);
		}
	}
	
	$("searchPolicyNo").observe("click",function(){
		if(trim($("txtPolLineCd").value)=="" && trim($("txtPolSublineCd").value)!="" && trim($("txtPolIssCd").value)!=""){
			customShowMessageBox("Please enter Line Cd.", imgMessage.INFO, "txtPolLineCd");
		} else if(trim($("txtPolLineCd").value)==""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtPolLineCd");
			return false;
		} else {
			showPolicyLOV();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		observeChangeTag(resetForm);
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		queryTable();
	});
	
	function objInfo(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.itemNo = $F("txtItemNo");
			obj.mvFileNo = escapeHTML2($F("txtMVFileNumber"));
			obj.itemTitle = escapeHTML2($F("txtItemTitle"));
			
			return obj;
		} catch(e){
			showErrorMessage("objInfo", e);
		}
	}
	
	function updateTable(){
		var dept = objInfo(objCurr);
		tbgUpdateMVFileNumber.updateVisibleRowOnly(dept, row, false);
		tbgUpdateMVFileNumber.keys.removeFocus(tbgUpdateMVFileNumber.keys._nCurrentFocus, true);
		tbgUpdateMVFileNumber.keys.releaseKeys();
		changeTag = 1;
		populateDetailsForm(null);
		
		var exists = false;
		for (var i=0; i < objUpdatedItems.length; i++){
			if (objUpdatedItems[i].itemNo == tbgUpdateMVFileNumber.geniisysRows[row].itemNo){
				objUpdatedItems.splice(i, 1);
				exists = true;
				break;
			}
		}
		if (!exists){
			objUpdatedItems.push(tbgUpdateMVFileNumber.geniisysRows[row]);
		}
	}
	
	$("btnUpdate").observe("click", function(){
		updateTable();
		/* if(changeTag == 1){
			saveMVFileNumberUpdate();
		} else{
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		} */
	});
	
	function observeChangeTag(func) {
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						saveMVFileNumberUpdate(func);
						//func();
					}, function(){
						changeTag = 0;
						func();
					}, "");
		}else{
			func();
		}
	}
	
	$("btnSave").observe("click", function(){
		if(changeTag == 1){
			saveMVFileNumberUpdate();
		} else{
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}
	});
	
	function exit(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	$("btnToolbarExit").observe("click", function(){
		objExit.exitPage = exit;
		observeChangeTag(exit);
	});
	
	$("btnCancel").observe("click", function(){
		objExit.exitPage = exit;
		observeChangeTag(exit);
	});
	
	$("logout").stopObserving("click");
	$("logout").observe("click",function(){
		observeChangeTag(showConfLogOut);
	});
	
</script>