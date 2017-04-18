<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>



<div id="mainNav"name="mainNav">
	<!--  <div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="updateCheckNumberExit">Exit</a></li>
		</ul>
	</div> -->
</div>
<div id="updateCheckNumberMainDiv" style="width: 920px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Update Check Number</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>	
	<div id="updateCheckNoTranHeader" class="sectionDiv" style="width: 920px; height: 50px;">
		<table id="fieldsDiv" align="center" style="padding: 12px 10px 15px 10px;">
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Company</td>
				<td>
					<input id="hidGibrGfunFundCd" type="hidden">
					<input id="hidFundDesc" type="hidden">
					<span class="lovSpan" style="width: 280px;">
						<input id="txtCompany" name="txtCompany" type="text" maxlength="50" style="width: 250px; float: left; border: none; height: 13px; margin: 0px;" tabindex="110">
						<img id="searchCompanyLOV" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />							
					</span>
				</td>
				<td class="rightAligned" style="padding: 0 7px 0 70px;">Branch</td>
				<td>
					<input id="hidGibrBranchCd" type="hidden">
					<input id="hidBranchName" type="hidden">
					<span class="lovSpan" style="width: 280px;">
						<input id="txtBranch" name="txtBranch" type="text" maxlength="20" style="width: 250px; float: left; border: none; height: 13px; margin: 0px;" tabindex="111">
						<img id="searchBranchLOV" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div id="recordsDiv" class="sectionDiv" style="width: 900px; height: 610px; padding: 20px 10px 0px 10px;">
		<div id="checkNumberTG" style="height: 310px; margin: 0 0 40px 50px;"></div>
			<table style="padding-left: 100px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Check No.</td>
					<td colspan="3">	
						<input id="txtCheckPrefSuf" class="required" type="text" readonly="readonly" style="width: 60px;" maxlength="5"/>
						<input id="txtCheckNo" class="rightAligned required integerNoNegativeUnformatted" type="text" readonly="readonly" style="width: 128px;" maxlength="10"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Payee</td>
					<td colspan="3"><input id="txtPayee" type="text" readonly="readonly" style="width: 600px;"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Particulars</td>
					<td colspan="3"><textarea id="txtParticulars" readonly="readonly" draggable="false" style="width: 600px; height: 70px; resize: none;"></textarea></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">User ID</td>
					<td><input id="txtUserId" type="text" readonly="readonly" style="width: 200px;"/></td>
					<td class="rightAligned" style="padding: 0 7px 0 110px;">Last Update</td>
					<td><input id="txtLastUpdate" type="text" readonly="readonly" style="width: 200px;"/></td>
				</tr>
			</table>
		<div class="buttonsDiv" style="margin-top: 10px;">
			<input id="btnUpdate" type="button" class="button" value="Update" style="width: 80px;" >
			<input id="btnHistory" type="button" class="button" value="History" style="width: 80px;" />
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel">
	<input type="button" class="button" id="btnSave" value="Save">
</div>
<script type="text/javascript">
try{
	initializeAll();	
	setModuleId("GIACS049");
	setDocumentTitle("Update Check Number");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	hideToolbarButton("btnToolbarPrint");	
	disableButton("btnUpdate");
	$("txtCompany").focus();
	var objGIACS049 = {};
	var allRec = {};
	var origCheckPrefSuf = null;
	var origCheckNo = null;
	objGIACS049.exitPage = null;
	changeTag = 0;
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	function updateCheckNumber(){ //for saving
		try{
			var objChkNos = getAddedAndModifiedJSONObjects(chkNoTG.geniisysRows);
			var strParams = prepareJsonAsParameter(objChkNos);
			
			new Ajax.Request(contextPath+"/GIACUpdateCheckNumberController",{
				parameters: {
					action:			"updateCheckNumber",
					checkNos:		strParams
				},
				onCreate: showNotice("Updating Check Number..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIACS049.exitPage != null) {
								chkNoTG.keys.releaseKeys();
								objGIACS049.exitPage();
							} else {
								chkNoTG._refreshList();
								chkNoTG.keys.releaseKeys();
							}
						});
						changeTag = 0;	
					}
				}
			});
			
		}catch(e){
			showErrorMessage("updateCheckNumber", e);
		}
	}
	
	var objChkNo = new Object();
	objChkNo.chkNoTG = JSON.parse('${chkNoTableGrid}'.replace(/\\/g, '\\\\'));
	objChkNo.chkNoObjRows = objChkNo.chkNoTG.rows || [];
	objChkNo.chkNoList = [];	//holds all the geniisys rows
	
	try{
		var chkNoTableModel = {
			url: contextPath + "/GIACUpdateCheckNumberController?action=showUpdateCheckNumberPage&refresh=1",
			options: {
				width: '800px',
				height: '310px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = chkNoTG.geniisysRows[y];
					setFieldValues(selectedRowInfo);
					chkNoTG.keys.releaseKeys();
					$("txtParticulars").selectionEnd = $("txtParticulars").value.length; //to scroll the textarea at the end
				},
				onRemoveRowFocus: function(){
					chkNoTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = null;
					setFieldValues(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				prePager: function(){
					if (changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				onSort: function(){
					chkNoTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					chkNoTG.onRemoveRowFocus();
				},		
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						chkNoTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'gaccTranId',
					width: '0px',
					visible: false
				},
				{
					id: 'gibrGfunFundCd',
					width: '0px',
					visible: false
				},
				{
					id: 'gibrBranchCd',
					width: '0px',
					visible: false
				},
				{ //added by jeffdojello 12.16.2013
					id: 'itemNo',
					width: '0px',
					visible: false
				},//-----------------------
				{
					id: 'dvPref dvNo',
					title: 'DV No.',
					width: '220px',
					titleAlign: 'center',
					children: [
							{
								id: 'dvPref',
								title: 'DV Pref Suf',
								width: 52,
								filterOption: true,
								sortable: false,
								editable: false
							},
							{
								id: 'dvNo',
								title: 'DV No',
								align: 'right',
								width: 75,
								filterOption: true,
				        	  	filterOptionType: 'integerNoNegative',
								sortable: false,
								editable: false
							},
					]
				},
				{
					id: 'checkDate',
					title: 'Check Date',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					sortable: true,
					geniisysClass: 'date',
					renderer: function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{
					id: 'documentCd branchCd lineCd docYear docMm docSeqNo',
					title: 'Payment Request No.',
					width: '300px',
					children: [
								{
									id: 'documentCd',
									title: 'Document Cd',
									width: 60,
					        	  	filterOption: true
								},
								{
									id: 'branchCd',
									title: 'Branch Cd',
									width: 50,
					        	  	filterOption: true
								},
								{
									id: 'lineCd',
									title: 'Line Cd',
									width: 50,
					        	  	filterOption: true
								},
								{
									id: 'docYear',
									title: 'Doc Year',
									width: 60,
									align: 'right',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								},
								{
									id: 'docMm',
									title: 'Doc Mm',
									width: 50,
									align: 'right',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								},
								{
									id: 'docSeqNo',
									title: 'Doc Seq No',
									width: 70,
									align: 'right',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								},
							  ]
				},
				{
					id: 'checkPrefSuf checkNo',
					title: 'Check No.',
					width: '220px',
					children: [
								{
									id: 'checkPrefSuf',
									title: 'Check Pref Suf',
									width: 70,
					        	  	filterOption: true
								},
								{
									id: 'checkNo',
									title: 'Check No',
									width: 100,
									align: 'right',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								}
							  ]
				},
				{
					id: 'chkNo',
					width: '0px',
					visible: false
				},
				{
					id: 'payee',
					width: '0px',
					visible: false
				},
				{
					id: 'particulars',
					width: '0px',
					visible: false
				},
				{
					id: 'userId',
					width: '0px',
					visible: false
				},
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				},
				{
					id: 'dspLastUpdate',
					width: '0px',
					visible: false
				}
			],
			rows: objChkNo.chkNoObjRows
		};
		
		chkNoTG = new MyTableGrid(chkNoTableModel);
		chkNoTG.pager = objChkNo.chkNoTG;
		chkNoTG.render('checkNumberTG');
		chkNoTG.afterRender = function(){
			objChkNo.chkNoList = chkNoTG.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Error in Check Number Table Grid:", e);
	}
	
	function showCompanyLOV(){
		try{
			var searchString = $F("txtCompany") == "" ? '%' : escapeHTML2($F("txtCompany").trim());
			
			LOV.show({
				controller: 	"AccountingLOVController",
				urlParameters: 	{
								action:		"getGIACS049CompanyLOV",
								gibrGfunFundCd:	$F("txtCompany")
								},
				title:	'',
				width: 400,
				height: 400,
				columnModel: [
				              {
				            	id: 'gibrGfunFundCd',
				            	title: 'Fund',
				            	width: '70px'
				              },
				              {
				            	id: 'fundDesc',
				            	title: 'Fund Desc',
				            	width: '300px'
				              }
				             ],
				draggable: true,
				autoSelectOneRecord: true,
				filterText:	searchString,
				onSelect: function(row){
					if(row != undefined){
						$("hidGibrGfunFundCd").value = row.gibrGfunFundCd;
						$("hidFundDesc").value = row.fundDesc;
						$("txtCompany").value = row.gibrGfunFundCd + " - " + row.fundDesc;
					}else{
						$("hidGibrGfunFundCd").value = "";
						$("hidFundDesc").value = "";
						$("txtCompany").value = "";
					}
					fireEvent($("txtCompany"), "blur");
				}
			});
		} catch(e){
			showErrorMessage("showCompanyLOV", e);
		}	
	}
	
	function showBranchLOV(){
		try{
			var searchString = $F("txtBranch") == "" ? '%' : escapeHTML2($F("txtBranch").trim());
			
			LOV.show({
				controller: 	"AccountingLOVController",
				urlParameters: 	{
								action:		"getGIACS049BranchLOV",
								gibrBranchCd:	$F("txtBranch")
								},
				title:	'',
				width: 400,
				height: 400,
				columnModel: [
				              {
				            	id: 'gibrBranchCd',
				            	title: 'Branch Cd',
				            	width: '100px'
				              },
				              {
				            	id: 'branchName',
				            	title: 'Branch Name',
				            	width: '270px'
				              }
				             ],
				draggable: true,
				autoSelectOneRecord: true,
				filterText: searchString,
				onSelect: function(row){
					if(row != undefined){
						$("hidGibrBranchCd").value = row.gibrBranchCd;
						$("hidBranchName").value = row.branchName;
						$("txtBranch").value = row.gibrBranchCd + " - " + row.branchName;
					}else{
						$("hidGibrBranchCd").value = "";
						$("hidBranchName").value = "";
						$("txtBranch").value = "";
					}
					fireEvent($("txtCompany"), "blur");
				}
			});
		} catch(e){
			showErrorMessage("showBranchLOV", e);
		}	
	}
	
	
	function executeQuery(){
		try{
			chkNoTG.url = contextPath+"/GIACUpdateCheckNumberController?action=showUpdateCheckNumberPage&gibrGfunFundCd="
						  +$F("hidGibrGfunFundCd")+"&gibrBranchCd="+$F("hidGibrBranchCd");
			chkNoTG._refreshList();
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtCompany").readOnly = true;
			$("txtBranch").readOnly = true;
			disableSearch("searchCompanyLOV");
			disableSearch("searchBranchLOV");
		} catch(e){
			showErrorMessage("executeQuery", e);
		}
	}
	
	
	function validateCheckPrefSuf(){
		try{
			var result = false;
			var objChkNos = getAddedAndModifiedJSONObjects(chkNoTG.geniisysRows);
			var strParams = prepareJsonAsParameter(objChkNos);
			new Ajax.Request(contextPath+"/GIACUpdateCheckNumberController",{
				parameters: {
					action:			"validateCheckPrefSuf",
					gibrGfunFundCd:	$F("hidGibrGfunFundCd"),
					gibrBranchCd:	selectedRowInfo.gibrBranchCd,
					checkPrefSuf:	$F("txtCheckPrefSuf"),
					checkNo:		$F("txtCheckNo"),
					dummySave:		strParams
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						result = true;
					}
				}
			});
			return result;
		}catch(e){
			showErrorMessage("validateCheckPrefSuf", e);
		}
	}
	
/* 	function validateCheckNo(checkNo){
		try{
			new Ajax.Request(contextPath+"/GIACUpdateCheckNumberController",{
				parameters: {
					action:			"validateCheckPrefSuf",
					gibrGfunFundCd:	$F("hidGibrGfunFundCd"),
					gibrBranchCd:	selectedRowInfo.gibrBranchCd,
					checkPrefSuf:	selectedRowInfo.checkPrefSuf,
					checkNo:		checkNo,
					chkNo:			selectedRowInfo.chkNo,
					itemNo:			selectedRowInfo.itemNo //added by jeffdojello 12.16.2013
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Validating Check No..."),
				onComplete: function(response){
					hideNotice();
					var coords = chkNoTG.getCurrentPosition();
                    var y = coords[1]*1;
                    
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						chkNoTG.setValueAt(json.checkNo, chkNoTG.getColumnIndex('checkNo', y), y);
					}else{
						chkNoTG.setValueAt(selectedRowInfo.checkNo, chkNoTG.getColumnIndex('checkNo', y), y);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateCheckNo", e);
		}
	} */
	
	function setFieldValues(row){
		$("txtCheckPrefSuf").value = row == null ? "" : unescapeHTML2(row.checkPrefSuf);
		$("txtCheckNo").value = row == null ? "" : row.checkNo;
		$("txtPayee").value = row == null ? "" : unescapeHTML2(row.payee);
		$("txtParticulars").value = row == null ? "" : unescapeHTML2(row.particulars);
		$("txtUserId").value = row == null ? "" : row.userId;
		$("txtLastUpdate").value = row == null ? "" : row.dspLastUpdate;
		objGIACS049.gaccTranId =  row == null ? null : row.gaccTranId;
		
		row == null ? $("txtCheckPrefSuf").readOnly = true : $("txtCheckPrefSuf").readOnly = false;
		row == null ? $("txtCheckNo").readOnly = true : $("txtCheckNo").readOnly = false;
		row == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
		origCheckPrefSuf = row == null ? "" : unescapeHTML2(row.checkPrefSuf);
		origCheckNo = row == null ? "" : row.checkNo;
		selectedRowInfo = row;
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.checkPrefSuf = escapeHTML2($F("txtCheckPrefSuf"));
			obj.checkNo = $F("txtCheckNo");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.dspLastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function updateRec() {
		try{
			changeTagFunc = updateCheckNumber;
			var newObj = setRec(selectedRowInfo);
			chkNoTG.updateVisibleRowOnly(newObj, selectedIndex, false); 
			/* for(var i = 0; i<allRec.length; i++){
				if ((allRec[i].gaccTranId == newObj.gaccTranId)&&(allRec[i].itemNo == newObj.itemNo)&&(allRec[i].recordStatus != -1)){
					newObj.recordStatus = 1;
					allRec.splice(i, 1, newObj);
				}
			} */
			
			changeTag = 1;
			setFieldValues(null);
			chkNoTG.keys.removeFocus(chkNoTG.keys._nCurrentFocus, true);
			chkNoTG.keys.releaseKeys();
		}catch (e) {
			showErrorMessage("updateRec",e);
		}
	}
	
	function valUpdateRec(){
		try{
			if(checkAllRequiredFieldsInDiv("recordsDiv")){
				if(origCheckPrefSuf != $F("txtCheckPrefSuf") || origCheckNo != $F("txtCheckNo")){
					if (validateCheckPrefSuf()) {
						updateRec();
					}	
				}else{
					updateRec();
				}
				
			}
		}catch (e) {
			showErrorMessage("valUpdateRec",e);
		}
	}
	
	$("txtCompany").observe("keyup", function(){
		$("txtCompany").value = $("txtCompany").value.toUpperCase();
	});
	
	$("txtCheckPrefSuf").observe("keyup", function(){
		$("txtCheckPrefSuf").value = $("txtCheckPrefSuf").value.toUpperCase();
	});
	
	$("txtCompany").observe("change", function(){
		showCompanyLOV();	
	});
	
	$("txtCompany").observe("blur", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		
		if ($F("txtCompany") != "" && $F("txtBranch") != ""){
			enableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("txtBranch").observe("keyup", function(){
		$("txtBranch").value = $("txtBranch").value.toUpperCase();
	});
	
	$("txtBranch").observe("change", function(){
		showBranchLOV();	
	});
	
	$("txtBranch").observe("blur", function(){
		fireEvent($("txtCompany"), "blur");
	});
	
	$("searchCompanyLOV").observe("click", showCompanyLOV);
	$("searchBranchLOV").observe("click", showBranchLOV);
			
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						updateCheckNumber();
						showUpdateCheckNumberPage();
					}, 
					function(){
						showUpdateCheckNumberPage();          						
					}, "");
		}else{
			showUpdateCheckNumberPage();
		}	
		chkNoTG.keys.releaseKeys();
	});
	
	$("btnUpdate").observe("click", valUpdateRec);
	$("btnSave").observe("click", updateCheckNumber);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnHistory").observe("click", function(){
		if (selectedRowInfo != null){
			chkNoTG.keys.releaseKeys();
			objOverlay = Overlay.show(contextPath+"/GIACUpdateCheckNumberController",{
					urlContent: true,
					urlParameters: {
						action:		'showCheckNoHistory',
						gaccTranId:	objGIACS049.gaccTranId,
						refresh:	1
					},
					title: 'Check No. History',
					width: 770,
					height: 300,
					draggable: true
				}
			);
		}else{
			showMessageBox("Please select a record first.", "I");
		}
	});
	
	
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	$("btnToolbarExit").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS049.exitPage = exitPage;
						updateCheckNumber();
					}, 
					function(){
						chkNoTG.onRemoveRowFocus();
						exitPage();
					}, "");
		}else{
			chkNoTG.onRemoveRowFocus();
			exitPage();
		}
	});
	
	$("btnCancel").observe("click", function(){
		fireEvent($("btnToolbarExit"), "click");
	});
	observeReloadForm("reloadForm", showUpdateCheckNumberPage);
	
}catch(e){
	showErrorMessage("Page Error:", e);
}	
</script>