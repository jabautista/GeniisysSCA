<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="processDataListingDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Converted Files Listing</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
			<tr>
				<td>
					<label for="txtSourceCd">Source</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 100px; margin-bottom: 0;">
						<input type="text" id="txtSourceCd" ignoreDelKey="true" name="txtSourceCd" style="width: 75px; float: left;" class="withIcon allCaps required"  maxlength="4"  tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSourceCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtSourceName" style="width: 380px; float: left; height: 14px;" class="allCaps" tabindex="102"/>
					<%-- <span class="lovSpan" style="width: 380px; margin-bottom: 0;">
						<input type="text" id="txtSourceName" name="txtSourceCd" style="width: 355px; float: left;" class="withIcon allCaps" tabindex="102"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSourceName" alt="Go" style="float: right;" />
					</span> --%>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="margin-top: 2px; padding-bottom: 15px; margin-bottom: 50px;">
		
		<div style="padding: 10px 0 0 10px;">
			<div id="tableGridDiv" style="height: 300px; margin-left: auto;"></div>
		</div>
		
		<div class="sectionDiv" style="float: none; margin: auto; width: 898px; margin-top: 5px;">
			<table align="center" style="margin: 15px auto;">
				<tr>
					<td>
						<label for="txtRemarks" style="float: right;">Remarks</label>
					</td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 606px;">
							<textarea id="txtRemarks" name="txtRemarks" style="float:left; width: 570px; border: none; height: 14px; margin: 0px; resize: none;" maxlength="4000" readonly="readonly" tabindex="201"/></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td><label for="txtUserId" style="float: right;">User ID</label></td>
					<td><input type="text" id="txtUserId" style="width: 246px; float: left;" readonly="readonly" tabindex="202"/></td>
					<td><label for="txtLastUpdate" style="margin-left: 25px; float: right;">Last Update</label></td>
					<td><input type="text" id="txtLastUpdate" style="width: 246px; float: left;" readonly="readonly" tabindex="203"/></td>
				</tr>
			</table>
		</div>
		<input type="button" class="button" id="btnProcessData" value="Process Data" style="width: 150px; margin-top: 15px;" tabindex="301"/>
	</div>
</div>
<div id="process"></div>
<script type="text/javascript">
	var onLOV = false;
	sourceCd = "";
	fileNo = "";
	transactionType = "";
	atmTag = "";
	objUploading = new Object();
	
	function initGIACS602 (){
		setModuleId("GIACS602");
		setDocumentTitle("Converted Files Listing");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		$("mainNav").hide();
		$("btnToolbarPrint").hide();
		disableButton("btnProcessData");
		$("txtSourceCd").focus();
		$("editRemarks").hide();
	}
	
	function resetForm() {
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1";
		tbg._refreshList();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		onLOV = false;
		sourceCd = "";
		fileNo = "";
		setDetails(null);
		enableSearch("imgSourceCd");
		//enableSearch("imgSourceName");
		$("txtSourceCd").clear();
		$("txtSourceName").clear();
		$("txtSourceCd").readOnly = false;
		$("txtSourceName").readOnly = false;
		$("txtSourceCd").focus();
		transactionType = "";
		atmTag = "";
	}
	
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	$("editRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000, 'true');
	});
	
	var jsonProcessDataList = JSON.parse('${jsonProcessDataList}');
	perAssuredTableModel = {
			url : contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '900px',
				height: '275px',
				onCellFocus : function(element, value, x, y, id) {
					setDetails(tbg.geniisysRows[y]);	
					tbg.keys.removeFocus(tbg.keys._nCurrentFocus, true);
					tbg.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetails(null);
					tbg.keys.removeFocus(tbg.keys._nCurrentFocus, true);
					tbg.keys.releaseKeys();
				},
				onRowDoubleClick : function(y){
					setDetails(tbg.geniisysRows[y]);
					processData();
					tbg.keys.removeFocus(tbg.keys._nCurrentFocus, true);
					tbg.keys.releaseKeys();
				}
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
					id : "fileNo",
					title: "Batch No.",
					width: '100px',
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : "fileName",
					title: "Filename",
					width: '180px',
					filterOption : true
				},
				{
					id : "hashCollection",
					title: "Collection Amount",
					width: '155px',
					align : "right",
					titleAlign : "right",
					filterOption : true,
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "convertDate",
					title: "Convert Date",
					width: '130px',
					align : "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : 'formattedDate',
					renderer : function(val) {
						return dateFormat(val, "mm-dd-yyyy");
					}
				},
				{
					id : "uploadDate",
					title: "Upload Date",
					width: '130px',
					align : "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : 'formattedDate',
					renderer : function(val) {
						if(val != "")
							return dateFormat(val, "mm-dd-yyyy");
						else
							return null;
					}
				},
				{
					id : "status",
					title: "Status",
					width: '165px',
					filterOption : true
				}
				
			],
			rows: jsonProcessDataList.rows
		};
	
	tbg = new MyTableGrid(perAssuredTableModel);
	tbg.pager = jsonProcessDataList;
	tbg.render('tableGridDiv');
	tbg.afterRender = function(){
		setDetails(null);
		tbg.keys.removeFocus(tbg.keys._nCurrentFocus, true);
		tbg.keys.releaseKeys();
	};
	
	function executeQuery(){
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		tbg._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("imgSourceCd");
		//disableSearch("imgSourceName");
		onLOV = true;
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
	}
	
	function setDetails(obj) {
		if(obj != null){
			$("txtRemarks").value = obj.remarks;
			$("txtUserId").value = obj.userId;
			$("txtLastUpdate").value = obj.lastUpdate;
			transactionType = obj.transactionType;
			fileNo = obj.fileNo;
			enableButton("btnProcessData");
			$("editRemarks").show();
		} else {
			$("txtRemarks").clear();
			$("txtUserId").clear();
			$("txtLastUpdate").clear();
			disableButton("btnProcessData");
			$("editRemarks").hide();
			transactionType = "";
			fileNo = "";
		}
	}
	
	function processData() {
		if (transactionType == 1){
			if(atmTag == "Y"){
				showGiacs604();
			} else {
				showGiacs603();
			}
		} else if (transactionType == 2){	
			showGiacs607();
		} else if (transactionType == 3){	
			showGiacs608();
		} else if (transactionType == 4){ //Deo: GIACS609 conversion
			showGiacs609();
		} else if (transactionType == 5){
			showGiacs610();
		} else{
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		}
	}
	
	$("btnProcessData").observe("click", processData);
	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	function getFileSourceLOV2(searchString) {
		if(onLOV) return;
		onLOV = true;
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getFileSourceLOV2",
				searchString : sourceCd == "" ? searchString : "",
				page : 1
			},
			title : "Valid Values for Source",
			width : 480,
			height : 386,
			columnModel : [
				{
					id : "sourceCd",
					title : "Code",
					width : '90px',
				},
				{
					id : "sourceName",
					title : "Name",
					width : '270px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  sourceCd == "" ? searchString : "",
			onSelect : function(row) {
				onLOV = false;
				sourceCd = row.sourceCd;
				$("txtSourceCd").value = unescapeHTML2(row.sourceCd);
				$("txtSourceName").value = unescapeHTML2(row.sourceName);
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				atmTag = row.atmTag;
			},
			onCancel : function () {
				onLOV = false;
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtSourceCd");
				onLOV = false;
			}
		});
	}
	
	$("imgSourceCd").observe("click", function(){
		getFileSourceLOV2($("txtSourceCd").value);
	});
	
	/* $("imgSourceName").observe("click", function(){
		getFileSourceLOV2($("txtSourceName").value);
	}); */
	
	$("txtSourceCd").observe("change", function(){
		if(onLOV)
			return;
		if($F("txtSourceCd") != "") {
			getFileSourceLOV2($("txtSourceCd").value);
		} else {
			sourceCd = "";
			atmTag = "";
			$("txtSourceName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		enableToolbarButton("btnToolbarEnterQuery");
	});
	
	$("txtSourceName").observe("keypress", function(event){
		if(onLOV)
			return;
		if(event.keyCode == 13) {
			getFileSourceLOV2($("txtSourceName").value);
		} else if (event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46) {
			sourceCd = "";
			$("txtSourceCd").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		enableToolbarButton("btnToolbarEnterQuery");
	});
	
	$("btnToolbarExit").observe("click", function(){
		//$("acExit").click(); //nieko Accounting Uploading GIACS603, modify exit toolbar
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	initGIACS602();
	initializeAll();
	
	
	function showGiacs603(){
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs603",
				sourceCd: sourceCd,
				fileNo: fileNo
			},
			asynchronous: true,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					objACGlobal.callingForm = "GIACS602";
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602";
				}	
			}
		});
	}
	
	/*function showGIACS607(){	//shan 06.09.2015 : conversion of GIACS607
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			method: "POST",
			parameters:{
				action: "showGIACS607",
				sourceCd: sourceCd,
				fileNo: fileNo
			},
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				$("process").update(response.responseText);
				$("processDataListingDiv").hide();
				$("process").show();
				objACGlobal.callingForm = "GIACS602";
			}
		});
	}*/
	
	function showGiacs604(){ //john 8.27.2015 : conversion of GIACS604
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs604",
				sourceCd: sourceCd, 
				fileNo: fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					objACGlobal.callingForm = "GIACS602";
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602";
				}	
			}
		});
	}
	
		function showGiacs607(){
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGIACS607",
				sourceCd: sourceCd, 
				fileNo: fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					objACGlobal.callingForm = "GIACS602"; 
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602";
				}	
			}
		});
	}
	
	function showGiacs608(){ //john 9.21.2015 : conversion of GIACS608
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGIACS608",
				sourceCd: sourceCd, 
				fileNo: fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					objACGlobal.callingForm = "GIACS602"; 
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602";
				}	
			}
		});
	}
	
	function showGiacs610(){ //john 10.22.2015 : conversion of GIACS610
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs610",
				sourceCd: sourceCd, 
				fileNo: fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602"; //Deo [10.06.2016]
				}	
			}
		});
	}
	
	/*
	**nieko Accounting Uploading
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});*/
	
	//objUploading.showGIACS607 = showGIACS607; nieko Accounting Uploading
	
	//Deo [10.06.2016]: add start
	if (objACGlobal.callingForm == "GIACS610") {
		$("txtSourceCd").value = objGIACS610.sourceCd;
		$("txtSourceName").value = objGIACS610.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objGIACS610.sourceCd = "";
		objGIACS610.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;
	} else if (objACGlobal.callingForm == "GIACS603") {
		$("txtSourceCd").value = objGIACS603.sourceCd;
		$("txtSourceName").value = objGIACS603.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objACGlobal.callingForm2 = "";
		objGIACS603.sourceCd = "";
		objGIACS603.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;
		atmTag = 'N';
	} else if (objACGlobal.callingForm == "GIACS604") {
		$("txtSourceCd").value = objGIACS604.sourceCd;
		$("txtSourceName").value = objGIACS604.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objACGlobal.callingForm2 = "";
		objGIACS604.sourceCd = "";
		objGIACS604.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;
		atmTag = 'Y';
	} else if (objACGlobal.callingForm == "GIACS607") {
		$("txtSourceCd").value = objGIACS607.sourceCd;
		$("txtSourceName").value = objGIACS607.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objACGlobal.callingForm2 = "";
		objGIACS607.sourceCd = "";
		objGIACS607.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;	
	} else if (objACGlobal.callingForm == "GIACS608") {
		$("txtSourceCd").value = objGIACS608.sourceCd;
		$("txtSourceName").value = objGIACS608.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objACGlobal.callingForm2 = "";
		objGIACS608.sourceCd = "";
		objGIACS608.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;
	} else if (objACGlobal.callingForm == "GIACS609") { //Deo: GIACS609 conversion
		$("txtSourceCd").value = objGIACS609.sourceCd;
		$("txtSourceName").value = objGIACS609.sourceName;
		sourceCd = $F("txtSourceCd");
		objACGlobal.callingForm = "";
		objGIACS609.sourceCd = "";
		objGIACS609.sourceName = "";
		tbg.url = contextPath+"/GIACUploadingController?action=showProcessDataListing&refresh=1&sourceCd=" + $("txtSourceCd").value;
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtSourceCd").readOnly = true;
		$("txtSourceName").readOnly = true;
		disableSearch("imgSourceCd");
		onLOV = true;
	}
	
	function showGiacs609(){ //Deo: GIACS609 conversion
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs609",
				sourceCd: sourceCd, 
				fileNo: fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("processDataListingDiv").hide();
					$("process").show();
					$("acExit").show();
					objACGlobal.prevForm = "GIACS602";
				}	
			}
		});
	}
</script>