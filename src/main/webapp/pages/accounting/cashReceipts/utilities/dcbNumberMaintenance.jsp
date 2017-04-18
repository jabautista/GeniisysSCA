<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="dcbNoMaintenanceDiv" name="dcbNoMaintenanceDiv" style="margin-top: 3px;" changeTagAttr="true">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Daily Collection Batch Number Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadDCBMaintForm" name="reloadDCBMaintForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="dcbNoMaintenanceHeaderDiv" style="float: left; width: 100%">
		<div class="sectionDiv" id="branchInfoDiv">
			<div style="margin-top: 10px; width: 100%;">
				<table align="center" border="0">
					<tr>
						<td class="rightAligned">Company</td>
						<td class="leftAligned" width="40%">
							<input type="hidden" id="dcbFundCd" name="dcbFundCd" value="${fundCd}" />
							<input type="hidden" id="dcbBranchCd" name="dcbBranchCd" value="${branchCd}" />
							<input type="text" id="txtCompany" name="txtCompany" value="${txtCompany}" readonly="readonly" style="width: 300px;" />
						</td>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned" width="40%">
							<input type="text" id="txtBranch" name="txtBranch" value="${txtBranch}" readonly="readonly" style="width: 270px; float: left;" />
							<div style="float: left; margin-left: 2px; float: left;">
								<img id="searchDCBNo" name="searchDCBNo" alt="Go" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv" id="dcbNoMaintDiv" name="dcbNoMaintDiv" style="height: 460px;">
			<div style="padding: 10px;">
				<div id="dcbMaintTable" style="position:relative; height: 230px; margin-left: 4%; margin-top: 0px; margin-bottom: 10px; float: left"></div>
			</div>
			<div id="dcbStatusDiv" style="position: absolute; margin-left: 700px; margin-top: 50px; border: 1px solid black;">
				<label style="margin-left: 62px;">DCB Status</label> <br />
				<input type="hidden" id="curDCBFlag" name="curDCBFlag" value="" />
				<div id="statusRadioBtnDiv" align="left" style="margin-top: 10px;  float: right; margin-right: 50px;">
					<label id="labelOpen"><input type="radio" id="selectOpen" name="optDCBFlag" value="O" style="margin-left: 15px; margin-top: 5px;"/> Open </label><br/>
					<label id="labelClosePrnt"><input type="radio" id="selectClosePrnt" name="optDCBFlag" value="X" style="margin-left: 15px; margin-top: 5px;"/> Closed for Printing </label><br/>
					<label id="labelTempClosed"><input type="radio" id="selectTempClosed" name="optDCBFlag" value="T" style="margin-left: 15px; margin-top: 5px;" /> Temporarily Closed </label><br/>
					<label id="labelClosed"><input type="radio" id="selectClosed" name="optDCBFlag" value="C" style="margin-left: 15px; margin-top: 5px; margin-bottom: 15px;" /> Closed </label><br/>
				</div>
			</div>
			<div id="dcbMaintFormDiv" changetagattr="true" style="width: 100%; margin: 10px 0px 5px 0px;padding-top: 250px;" changeTagAttr="true">
					<table align="center" width="55%">
						<tr>
							<td class="rightAligned" width="20%">DCB Date</td>
							<td class="leftAligned" width="30%">
							<input type="hidden" id="dcbFlag"/>
								<span class="required" style="float: left; border: solid 1px gray; height: 21px; margin-right: 3px;">
										<input style="float: left; border: none; margin-top: 0px; width: 115px;" id="dcbDate" name="dcbDate" type="text" value="${gipiQuote.inceptDate}" readonly="readonly" class="required" tabindex=101 ignoreDelKey="1"/>
										<img id="hrefDCBDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dcbDate'),this, null);" class="hover" alt="DCB Date" tabindex=102/>
								</span>
							</td>
							<td class="rightAligned" width="20%">DCB No.</td>
							<td class="leftAligned" width="30%"><input class="rightAligned" type="text" id="dcbNumber" name="dcbNumber" readonly="readonly" tabindex=104/></td>
						</tr>
						<tr>
							<td class="rightAligned">DCB Year</td>
							<td class="leftAligned"><input type="text" id="dcbYear" name="dcbYear" readonly="readonly" tabindex=103/></td> 
							<td class="rightAligned">DCB Status</td>
							<td class="leftAligned"><input type="text" id="dcbStatus" name="dcbStatus" readonly="readonly" tabindex=105/></td>
						<tr>
							<td class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<span style="width: 98.5%; float: left; border: solid 1px gray; height: 21px; margin-right: 3px;resize: none;">
									<textarea id="dcbRemarks" name="dcbRemarks" style="height: 13px; border: none; width: 93%;" tabindex=106 maxlength="4000"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditDCBRemarks" id="editDCBRemarksText" tabindex=107/>
								</span>
							</td>
						</tr>
					</table>	
			</div>
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" tabindex=108/>
				<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" tabindex=109/>
			</div>
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" id="btnOpen" name="btnOpen" value="Open" style="width: 115px;" tabindex=110/>
				<input type="button" class="button" id="btnClose"  name="btnClose"	value="Close for Printing" style="width: 115px;" tabindex=111/>
			</div>		
		</div>
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%;" changeTagAttr="true">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" tabindex=112/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save" tabindex=113/>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIACS333");
	setDocumentTitle("Daily Collection Batch Number Maintenance");
	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	objACGlobal.fundCd = "${fundCd}";
	allowTranForClosedMonthSw = '${allowTranSw}';	
	
	$("curDCBFlag").value = '${curDCBFlag}';
	var dcbFlag = $("curDCBFlag").value;
	var dcbSelectedIndex;
	var addedDcb = []; //collect all newly added DCB by MAC 01/14/2013
	var origRemarks = ""; //carlo SR 5360 02-22-2017
	disableButton("btnDelete");
	setLabelTitle("labelOpen", "Open");
	setLabelTitle("labelClosePrnt", "Closed for Printing");
	setLabelTitle("labelTempClosed", "Temporarily Closed");
	setLabelTitle("labelClosed", "Closed");
	try {
		var objDCBNos = new Object();
		var objDCBInfo=[];
		objDCBNos.objDCBTableGrid = JSON.parse('${dcbNoTableGrid}'.replace(/\\/g, '\\\\'));
		objDCBNos.objDCBNumbers = objDCBNos.objDCBTableGrid.rows || [];
		
		var tableModel = {
			url: contextPath+"/GIACDCBNoMaintController?action=refreshDCBNos&fundCd="+encodeURIComponent($F("dcbFundCd"))
				+"&branchCd="+encodeURIComponent($F("dcbBranchCd"))+"&dcbFlag="+dcbFlag,
			options:{
				title: '',
				width: '620px',
				onCellFocus: function(element, value, x, y, id) {
					var mtgId = dcbGrid._mtgId;
					dcbSelectedIndex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						dcbSelectedIndex = y;
					}
					var obj =dcbGrid.geniisysRows[y];
					populateDCBInfo(obj);
					formatterUtil(null,"hrefDCBDate");
					changeWidth($("dcbDate"),"130px");
					enableButton("btnDelete");
					dcbGrid.keys.releaseKeys();
					origRemarks = nvl(obj.remarks, "");//carlo SR 5360 02-22-2017
				},
				onCellBlur: function(element, value, x, y, id) {
					observeChangeTagInTableGrid(dcbGrid);
				},
				onRemoveRowFocus: function() {
					dcbSelectedIndex = -1;
					populateDCBInfo(null);
					formatterUtil("hrefDCBDate", null);
					changeWidth($("dcbDate"),"115px");
					disableButton("btnDelete");
					dcbGrid.keys.releaseKeys();
				},
				onSort: function(){
					dcbSelectedIndex = -1;
					populateDCBInfo(null);
					formatterUtil("hrefDCBDate", null);
					disableButton("btnDelete");
					changeWidth($("dcbDate"),"115px");
				},
				postPager: function () {
					dcbSelectedIndex = -1;
					populateDCBInfo(null);
					formatterUtil("hrefDCBDate", null);
					disableButton("btnDelete");
					changeWidth($("dcbDate"),"115px");
				},
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onRefresh: function(){
						dcbGrid.keys.removeFocus(dcbGrid.keys._nCurrentFocus, true);
						dcbGrid.keys.releaseKeys();
						formatterUtil("hrefDCBDate", null);
						disableButton("btnDelete");
						changeWidth($("dcbDate"),"115px");
						populateDCBInfo(null);
					},
					onFilter: function(){
						dcbGrid.keys.removeFocus(dcbGrid.keys._nCurrentFocus, true);
						dcbGrid.keys.releaseKeys();
						formatterUtil("hrefDCBDate", null);
						disableButton("btnDelete");
						changeWidth($("dcbDate"),"115px");
						populateDCBInfo(null);
					}
				}
			},
			columnModel: [
			    {	id: 'recordStatus', 	
	 			    title: '',
	 			    width: '0',
	 			   	visible: false,
				    editor: 'checkbox' 					
			    },
			    {	id: 'divCtrId',
					width: '0',
					visible: false
			    },
			    {	id: 'fundCd',
					width: '0',
					visible: false
			    },
			    {	id: 'branchCd',
				    width: '0',	
					visible: false
			    },
			    {	id: 'dcbFlag',
					width: '0',
					visible: false
			    },
			    { 	id: 'tranDate',
					title: 'DCB Date',
					width: '120px',
					sortable: true,
					align: 'center',
					type: 'date',
					format: 'mm-dd-yyyy',
					editableOnAdd: true,
					titleAlign: 'center',
					filterOption : true
			    },
			    {	id: 'dcbYear',
					title: 'DCB Year',
					width: '70px',
					align: 'center',
					editable: false,
					filterOption : true
			    },
			    {	id: 'dcbNo',
					title: 'DCB No.',
					width: '70px',
					align: 'right',
					editable: false,
					filterOption : true
			    },
			    {	id: 'dcbStatus',
				    title: 'DCB Status',
				    width: '110px',
				    align: 'left',
				    editable: false,
				    filterOption : true
			    },
			    {
					id: 'remarks',
					title: 'Remarks',
					width: '210px',
					align: 'left',
					editable: false,
					filterOption : true,
					maxlength: 4000
			    },
			    {	id: 'userId',
					width: '0',
					visible: false
			    }
			],
			rows: objDCBNos.objDCBNumbers
		};

		dcbGrid = new MyTableGrid(tableModel);
		dcbGrid.pager = objDCBNos.objDCBTableGrid;
		dcbGrid.render('dcbMaintTable');
		dcbGrid.afterRender = function(){
								objDCBInfo=dcbGrid.geniisysRows;
							  };
	} catch (e) {
		showErrorMessage("dcbNumberMaintenance.jsp",e);
	}

	function setDCBFlagRadio() {
		try {
			changeTag = 0; //carlo SR 5360 02-22-2017
			dcbFlag = $("curDCBFlag").value;
			if(dcbFlag=="O") {
				$("selectOpen").checked = true;
				disableButton($("btnOpen"));
				enableButton($("btnClose"));
			} else if(dcbFlag=="X") {
				$("selectClosePrnt").checked = true;
				disableButton($("btnClose"));
			} else if(dcbFlag=="T") {
				$("selectTempClosed").checked = true;
				disableButton($("btnOpen"));
				disableButton($("btnClose"));
			} else if(dcbFlag=="C") {
				$("selectClosed").checked = true;
				disableButton($("btnClose"));
				disableButton($("btnOpen"));
			}
		} catch(e) {
			showErrorMessage("setDCBFlagRadio", e);
		}
	}

	setDCBFlagRadio();

	function checkIfORAttached(row) {
		try {
			var allow = true;
			var mesg = "";
			new Ajax.Request(contextPath+"/GIACDCBNoMaintController?action=checkIfORAttached", {
				method: "POST",
				parameters: {
					dcbNo: 		row.dcbNo,
					fundCd: 	row.fundCd,
					branchCd: 	row.branchCd,
					tranDate: 	dateFormat(row.tranDate, "mm-dd-yyyy")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					mesg = response.responseText;
				}
			});	
			if(mesg != "SUCCESS") {
				showMessageBox(mesg, imgMessage.ERROR);
				dcbGrid.unselectRows();
				allow = false;
			} 
			return allow;
		} catch(e) {
			showErrorMessage("checkIfORAttached", e);
		}
	}
	
	function getClosedTag(row) { // added by steven 4.25.2012
		try {
			var allow = true;
			var mesg = "";
			new Ajax.Request(contextPath+"/GIACDCBNoMaintController?action=getClosedTag", {
				method: "POST",
				parameters: {
					fundCd: 	row.fundCd,
					branchCd: 	row.branchCd,
					tranDate: 	dateFormat(row.tranDate, "mm/dd/yyyy"),
					month:		dateFormat(row.tranDate, "mmmm"),
					year:		dateFormat(row.tranDate, "yyyy")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					mesg = response.responseText;
					if(mesg != "SUCCESS") {
						showWaitingMessageBox(mesg, imgMessage.ERROR, function(){
							$("dcbDate").value="";
							$("dcbYear").value="";
							$("dcbStatus").value="";
							$("dcbNumber").value="";
							$("dcbRemarks").value="";
						});
						allow = false;
					} 
					return allow;
				}
			});	
		} catch(e) {
			showErrorMessage("getClosedTag", e);
		}
	}
	
	function formatModifiedRowDates(row) {
		try {
			var valid = true;
			for(var i=0; i<row.length; i++) {
				if(row[i].tranDate != "") {
					var dcbDate = dateFormat(row[i].tranDate, "mm-dd-yyyy");
					row[i].tranDate = dcbDate;
				} else {
					valid = false;
				}
			}
			if(valid) {
				return row;
			} else {
				return '[]';
			}
		} catch(e) {
			showErrorMessage("formatModifiedRowDates", e);
		}
	}
	
	function tagDCBOpen() {
		try {
			dcbGrid.setValueAt('O', dcbGrid.getColumnIndex('dcbFlag'), dcbSelectedIndex, true);
			dcbGrid.setValueAt('Open', dcbGrid.getColumnIndex('dcbStatus'), dcbSelectedIndex, true);
			dcbGrid.setValueAt(userId, dcbGrid.getColumnIndex('userId'), dcbSelectedIndex, true);
			dcbGrid.modifiedRows.push(dcbGrid.getRow(dcbSelectedIndex));

			var objParameters = new Object();
			objParameters.setRows = formatModifiedRowDates(dcbGrid.getModifiedRows());
			objParameters.delRows = "[]";

			saveDCBInfo(objParameters, "Selected DCB has been opened.");
		} catch(e) {
			showErrorMessage("tagDCBOpen", e);
		}
	}

	function tagDCBClose() {
		try {
			dcbGrid.setValueAt('X', dcbGrid.getColumnIndex('dcbFlag'), dcbSelectedIndex, true);
			dcbGrid.setValueAt('Closed for Printing ', dcbGrid.getColumnIndex('dcbStatus'), dcbSelectedIndex, true);
			dcbGrid.setValueAt(userId, dcbGrid.getColumnIndex('userId'), dcbSelectedIndex, true);
			dcbGrid.modifiedRows.push(dcbGrid.getRow(dcbSelectedIndex));

			var objParameters = new Object();
			objParameters.setRows = formatModifiedRowDates(dcbGrid.getModifiedRows());
			objParameters.delRows = "[]";

			saveDCBInfo(objParameters, "Selected DCB has been closed for printing");
		} catch(e) {
			showErrorMessage("tagDCBClose", e); 
		}
	}

	function setDCBObject(val){ //added by steven 3.21.2012
		try{
			var obj = new Object;
			obj.fundCd = $("dcbFundCd").value;
			obj.branchCd = $("dcbBranchCd").value;
			if (val==1) {
				obj.dcbFlag = "O";
			} else {
				obj.dcbFlag = $("dcbFlag").value;
			}
			obj.tranDate = $("dcbDate").value;
			obj.dcbYear = $("dcbYear").value;
			obj.dcbNo = $("dcbNumber").value;
			obj.dcbStatus = $("dcbStatus").value;
			obj.remarks = escapeHTML2($F("dcbRemarks"));
			obj.userId = userId;
			return obj;
		} catch(e){
			showErrorMessage("setDCBObject()", e);
		}
	} 
	function addDCBInfo(){ //added by steven 3.21.2012
		try{
			var val=1;
			var newObj = {};
			if ($("dcbDate").value == "") {
				showMessageBox("Required fields must be entered.", imgMessage.ERROR);
				$("dcbDate").focus();
			}else if($("btnAdd").value == "Update"){
				newObj = setDCBObject(2); //carlo SR 5360 02-17-2016
				for(var i = 0; i<objDCBInfo.length; i++){
					if ((objDCBInfo[i].dcbNo == newObj.dcbNo)&& (objDCBInfo[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						objDCBInfo.splice(i, 1, newObj);
						dcbGrid.updateVisibleRowOnly(newObj, dcbGrid.getCurrentPosition()[1]);
						changeWidth($("dcbDate"),"115px");
						formatterUtil("hrefDCBDate", null);
						disableButton("btnDelete");
						if(escapeHTML2($F("dcbRemarks"))!= origRemarks){
							changeTag = 1;
						}else{
							changeTag = 0;
						}
					}
				}
				
			//}else if (getClosedTag(newObj)){
			}else {
				newObj = setDCBObject(val); //carlo SR 5360 02-17-2016
				newObj.recordStatus = 0;
				objDCBInfo.push(newObj);
				dcbGrid.addBottomRow(newObj);
				addedDcb.push(newObj); //collect all newly added DCB by MAC 01/14/2013.
				changeTag = 1;
			}
			dcbSelectedIndex = -1;
			populateDCBInfo(null);
		} catch(e){
			showErrorMessage("addCarrier()", e);
		}
	}
	function deleteDCBInfo(){ //added by steven 3.21.2012
		try{
			var val =2;
			var delObj = setDCBObject(val);
			changeWidth($("dcbDate"),"115px");
			if (checkIfORAttached(delObj)){
				for(var i = 0; i<objDCBInfo.length; i++){
					if ((objDCBInfo[i].dcbNo == delObj.dcbNo)&& (objDCBInfo[i].recordStatus != -1)){
						delObj.recordStatus = -1;
						objDCBInfo.splice(i, 1, delObj);
						addedDcb.splice(addedDcb.indexOf(delObj), 1); //remove deleted DCB number in addedDcb variable by MAC 101/14/2013.
						dcbGrid.deleteVisibleRowOnly(dcbGrid.getCurrentPosition()[1]);
					}
				}
			}
			formatterUtil("hrefDCBDate", null);
			disableButton("btnDelete");
			changeTag = 1;
			populateDCBInfo(null);
			dcbSelectedIndex = -1;
		} catch(e){
			showErrorMessage("deleteCarrier()", e);
		}
	}
	function saveDCBInfo(objParameters, mesg)	{ //added by steven 3.21.2012
		try{
			new Ajax.Request(contextPath+"/GIACDCBNoMaintController?action=saveDCBNoMaint", {
				method: "POST",
				asynchronous: true,
				parameters:{
					parameters: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox(mesg, imgMessage.SUCCESS, function(){
							dcbGrid.keys.removeFocus(dcbGrid.keys._nCurrentFocus, true);
							dcbGrid.keys.releaseKeys();
							dcbGrid._refreshList();
							changeTag=0;
							populateDCBInfo(null);
							//lastAction();
							lastAction = "";
							addedDcb = []; 
						});
					}	
				}
			});
		} catch(e){
			showErrorMessage("saveDCBInfo()", e);
		}
	}
	
	function verifyAddedRows() {
		var addedRows = dcbGrid.getNewRowsAdded();
		var valid = true;
		for(var i=0; i<addedRows.length; i++) {
			if(addedRows[i].tranDate == "") {
				valid = false;
			}
		}
		if(valid) {
			return addedRows;
		} else {
			return '[]';
		}
	}
	
	function populateDCBInfo(obj){ //added by steven 3.21.2012
		$('btnAdd').value  = (obj) == null ? "Add" : "Update";
  		$("dcbFlag").value    = (obj) == null ? "" : nvl(obj.dcbFlag,"");
		$("dcbDate").value    = (obj) == null ? "" : unescapeHTML2(nvl(dateFormat(obj.tranDate, "mm-dd-yyyy"),""));
 		$("dcbYear").value    = (obj) == null ? "" : nvl(obj.dcbYear,"");
 		$("dcbNumber").value      = (obj) == null ? "" : nvl(obj.dcbNo,"");
 		$("dcbStatus").value    = (obj) == null ? "" : unescapeHTML2(nvl(obj.dcbStatus,""));
 		$("dcbRemarks").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.remarks,""));
	}
	
	function changeWidth(id,dWidth) { //added by steven 3.21.2012
		dStyle =id;
		dStyle.style.width=dWidth;
	}
	
	function formatterUtil(toShow,toHide) { //added by steven 3.21.2012
		if (toShow!=null){
			$(toShow).show();
		}
		if (toHide!=null) {
			$(toHide).hide();
		}
	}
	
	function validateFilterInput(){
		if($F("mtgKeyword1") <= 0 || isNaN($F("mtgKeyword1")) || checkDecimal()){
			return true;
		}
		return false;
	}
	
	function checkDecimal(){
		for(var i = 0; i < $("mtgKeyword1").value.length; i++){
			if ($("mtgKeyword1").value.charAt(i)=='.'){
				  return true;
			}
		}
		return false;
	}
	
	function setLabelTitle(id,title) {  //added by steven 3.22.2012
			lbl =$(id);
			lbl.writeAttribute("title", title);
	}
	
 	function onSelectBranch(row){ //added by steven 3.22.2012
		$("txtBranch").value = row.branchCd +" - "+ row.branchName;
		$("dcbBranchCd").value = row.branchCd;
		loadFilteredDCBNoMaintenance($F("dcbFundCd"), $F("dcbBranchCd"), dcbFlag, $F("txtCompany"), $F("txtBranch"), "Yes");
 	}
	
 	function saveInfo() {
 		try {
 			var objParameters = new Object();
 			objParameters.setRows  = getAddedAndModifiedJSONObjects(objDCBInfo);
 			objParameters.delRows  = getDeletedJSONObjects(objDCBInfo);
 			saveDCBInfo(objParameters,objCommonMessage.SUCCESS);
		} catch (e) {
			showErrorMessage("saveInfo()", e);
		}
 		
	}
 	
 	function getMaxDcbNumber() { //added to get the maximum DCB Number based on Fund Code, Branch Code, and DCB Year by MAC 01/11/2013
 		var maxDcbNo = 0;
 		try {
			new Ajax.Request(contextPath+"/GIACDCBNoMaintController?action=getMaxDcbNumber", {
				method: "POST",
				parameters: {
					fundCd: 	$F("dcbFundCd"),
					branchCd: 	$F("dcbBranchCd"),
					dcbDate:	$F("dcbDate")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					maxDcbNo = response.responseText;
				}
			});	
			return maxDcbNo;
		} catch(e) {
			showErrorMessage("getMaxDcbNumber", e);
		}
	}
 	
 	initializeChangeTagBehavior(saveInfo);
	
	/* observe... */
	
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveInfo();
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						changeTag = 0;
					}, "");
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	$("searchDCBNo").observe("click", function(){ 
		dcbGrid.keys.releaseKeys();
		//show confirmation message if there are changes not yet saved by MAC 01/14/2013.
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveInfo();
						showGIAC333BranchLOV(onSelectBranch);	
					}, function(){
						showGIAC333BranchLOV(onSelectBranch);	
						changeTag = 0;
					}, "");
		}else{
			showGIAC333BranchLOV(onSelectBranch);	
		}	
	});  
	
	$("btnClose").observe("click", function() {
		if(dcbSelectedIndex == null || dcbSelectedIndex == -1) {    
			showMessageBox("Please select a DCB. ");
		} else {
			showConfirmBox("Confirm", "Are you sure to tag this DCB as closed for printing?", "Yes", "No", tagDCBClose, "");
		}
	});

	$("btnOpen").observe("click", function() {
		if(dcbSelectedIndex == null || dcbSelectedIndex == -1) {
			showMessageBox("Please select a DCB. ");
		} else {
			showConfirmBox("Confirm", "Are you sure to open this DCB?", "Yes", "No", tagDCBOpen, "");
		}
	});

	$("reloadDCBMaintForm").observe("click",  function() {//steven 3.21.2012
		if(changeTag > 0) {
			showConfirmBox("Reload Daily Collection Batch Number Maintenance.", "Reloading form will disregard all changes. Proceed?", "Yes", "No", function(){
																																						loadFilteredDCBNoMaintenance("", "", "", "", "", "No");
																																						dcbGrid.keys.releaseKeys(); 
																																						changeTag = 0;
																																					} , "");
		}else{
			loadFilteredDCBNoMaintenance("", "", "", "", "", "No");
			dcbGrid.keys.releaseKeys(); 
			changeTag = 0;
		}	
	});

	$("btnAdd").observe("click", addDCBInfo);
	
	$("btnDelete").observe("click", function(){
		deleteDCBInfo();
	});
	
	$("btnSave").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); //changed message by carlo SR 5360 02-17-2016
		} else {
			if($("btnAdd").value=='Update'){
				showMessageBox("You have changes in Daily Collection Batch Number Maintenance portion. Press Update button first to apply changes otherwise unselect the record to clear changes.", imgMessage.ERROR);
			}else {
				saveInfo();
			}
		}
	});

	$("home").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("home").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveInfo();
						goToModule("/GIISUserController?action=goToHome", "Home", null);
					}, function(){
						goToModule("/GIISUserController?action=goToHome", "Home", null);
						changeTag = 0;
					}, "");
		}else{
			goToModule("/GIISUserController?action=goToHome", "Home", null);
		}
	});
	
	$("btnCancel").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancel").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveInfo();
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						changeTag = 0;
					}, "");
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	$("editDCBRemarksText").observe("click", function (){
			showOverlayEditor("dcbRemarks", 4000, $("dcbRemarks").hasAttribute("readonly"));
	});
	
// 	$("dcbRemarks").observe("keyup", function () { //added by steven 4.24.2012
// 		var charLimit = 4000;
// 		if(this.value.length <= charLimit){
// 			this.setAttribute("lastValue", this.value);
// 		}
// 		if (this.value.length > charLimit) {
// 			this.value = this.getAttribute("lastValue");
// 			this.blur();
// 	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+charLimit+') for this field.', imgMessage.INFO);
// 	    	return false;
// 	    }
// 	});
	
	$("dcbDate").observe("focus", function (){ //added by steven 3.21.2012
		var dcbDate= $("dcbDate").value;
		var dcbDateArray=[];
		dcbDateArray= dcbDate.split("-");
		
		if (dcbDate==null || dcbDate=="") {
			$("dcbYear").value="";
			$("dcbStatus").value="";
			$("dcbNumber").value="";
			$("dcbRemarks").value="";
		}else{
			var maxDCBNo=parseInt(getMaxDcbNumber());//'${dcbNo}'; used function getMaxDcbNumber to get the maximum DCB Number every change of DCB Date by MAC 01/11/2013. 
			/*comment out by MAC 01/11/2013.
			for ( var i = 0; i < objDCBInfo.length; i++) {
				if ((objDCBInfo[i].dcbNo >= maxDCBNo)&& (objDCBInfo[i].recordStatus != -1)) {
					maxDCBNo=parseInt(objDCBInfo[i].dcbNo) + 1;
				}
			}*/
			if (addedDcb.length != 0){ //alter value of maxDCBNo by setting its value based on the maximum DCB number in addedDcb variable if addedDcb is not null by MAC 01/14/2013.
				var addedDcbTemp = [];
				for (var i=0; i<addedDcb.length; i++) {
					if (addedDcb[i].dcbYear == dcbDateArray[dcbDateArray.length-1]){ //collect all records with same year as the new record.
						addedDcbTemp.push(addedDcb[i].dcbNo);
					}
				}
				if (addedDcbTemp.length != 0){
					maxDCBNo = Math.max.apply(Math, addedDcbTemp);
				}
				addedDcbTemp = [];
			}
			
			var obj = new Object;
			
			if (dcbDate != "") {
				obj.fundCd = objACGlobal.fundCd;
				obj.branchCd = $("dcbBranchCd").value;
				obj.tranDate = dcbDate;
				
				getClosedTag(obj);
			}
			
			$("dcbYear").value=dcbDateArray[dcbDateArray.length-1];
			$("dcbStatus").value="Open";
			$("dcbNumber").value=maxDCBNo + 1; //increment by 1 to generate new DCB number by MAC 01/11/2013
		}
	});
	$("dcbDate").observe("blur", function (){ //added by steven 3.22.2012
		var dcbDate= $("dcbDate").value;
		if (dcbDate==null || dcbDate=="") {
			$("dcbYear").value="";
			$("dcbStatus").value="";
			$("dcbNumber").value="";
			$("dcbRemarks").value="";
		}
	});
	
	$$("input[name='optDCBFlag']").each(function(row) { 
		$(row.id).observe("click", function() {
			if(changeTag == 1){//added by carlo SR 5360 02-22-2017 start
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							saveInfo();
							dcbFlag = row.value;
							loadFilteredDCBNoMaintenance($F("dcbFundCd"), $F("dcbBranchCd"), dcbFlag, $F("txtCompany"), $F("txtBranch"), "Yes");
							dcbGrid.keys.releaseKeys();
						}, function(){
							dcbFlag = row.value;
							loadFilteredDCBNoMaintenance($F("dcbFundCd"), $F("dcbBranchCd"), dcbFlag, $F("txtCompany"), $F("txtBranch"), "Yes");
							dcbGrid.keys.releaseKeys();
							changeTag = 0;
						}, 	"");
			}else{//end
				if(row.checked == true) {
					dcbFlag = row.value;
					loadFilteredDCBNoMaintenance($F("dcbFundCd"), $F("dcbBranchCd"), dcbFlag, $F("txtCompany"), $F("txtBranch"), "Yes");
					dcbGrid.keys.releaseKeys(); // added by steven 3.22.2012
					changeTag = 0;
				}
			}
		});
	});
	
/* 	$("mtgKeyword1").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			if($("mtgFilterBy1").value == 'dcbNo'){
				if(validateFilterInput()){
					clearFocusElementOnError("mtgKeyword1", "DCB No. must be a non-negative integer.");
				}
			}else if($("mtgFilterBy1").value == 'dcbStatus'){
				if(!validateFilterInput()){
					clearFocusElementOnError("mtgKeyword1", "DCB Status must not be an integer.");
				}
			}else if($("mtgFilterBy1").value == 'dcbYear'){
				if(validateFilterInput()){
					clearFocusElementOnError("mtgKeyword1", "DCB Year must be a non-negative integer.");
				}
			}
		}
	}); */
	
	$("mtgBtnAddFilter1").observe("click", function(){
		if($("mtgFilterBy1").value == 'dcbNo'){
			if(validateFilterInput()){
				clearFocusElementOnError("mtgKeyword1", "DCB No. must be a non-negative integer.");
			}
		}else if($("mtgFilterBy1").value == 'dcbStatus'){
			if(!validateFilterInput()){
				clearFocusElementOnError("mtgKeyword1", "DCB Status must not be an integer.");
			}
		}else if($("mtgFilterBy1").value == 'dcbYear'){
			if(validateFilterInput()){
				clearFocusElementOnError("mtgKeyword1", "DCB Year must be a non-negative integer.");
			}
		}
	});
	
	function showGIAC333BranchLOV(onSelectFunction){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACBranchLOV",
							gfunFundCd : objACGlobal.fundCd,
							moduleId :  "GIACS333",
							page : 1},
			title: "Branches",
			width: 460,
			height: 300,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '325px'
							}
						],
			draggable: true,
			onSelect: function(row){
				onSelectFunction(row);
			}
		  });
	}
	
</script>