<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="lossProfileMainDiv" class="sectionDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Loss Profile</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<div style="float: left;">
		<fieldset style="width: 885px; margin-left: 10px; margin-top: 5px;">
			<legend><b>Parameters</b></legend>
			<div id="parametersTGDiv" class="sectionDiv" style="height: 200px; width: 99.7%; margin-bottom: 5px; border: none;">
			
			</div>
			
			<div id="parametersFormDiv" style="float: left;">
				<table>
					<tr>
						<td class="rightAligned" width="100px">Line</td>
						<td>
							<div id="lineCdDiv" style="float: left; width: 70px; height: 21px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtLineCd" title="Line Code" type="text" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" class="upper" tabindex="21101" lastValidValue="" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;" tabindex="21102"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtLineName" style="width: 220px; margin-top: 3x;" tabindex="21103" readonly="readonly"/>
						</td>
						<td class="rightAligned" width="140px">Subline</td>
						<td>
							<div id="sublineCdDiv" style="float: left; width: 70px; height: 21px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtSublineCd" title="Subline Code" type="text" maxlength="7" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="21104" class="upper" lastValidValue="" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCdLOV" name="imgSublineCdLOV" alt="Go" style="float: right;" tabindex="21105"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtSublineName" style="width: 220px; margin-top: 3x;" tabindex="21106" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy Date From</td>
						<td colspan="2">
							<div id="polDateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtPolDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtPolDateFrom" readonly="readonly" class="required" tabindex="21107" ignoreDelKey=""/>
								<img id="imgPolDateFrom" alt="imgPolDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21108"/>
							</div>
							<label style="margin-left: 61px; margin-top: 6px; float: left;">To</label>
							<div id="polDateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtPolDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtPolDateTo" readonly="readonly" tabindex="21109" class="required" ignoreDelKey=""/>
								<img id="imgPolDateTo" alt="imgPolDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21110"/>
							</div>
						</td>
						<td class="rightAligned">Claim Date From</td>
						<td colspan="2">
							<div id="clmDateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtClmDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtClmDateFrom" readonly="readonly" class="required" tabindex="21111" ignoreDelKey=""/>
								<img id="imgClmDateFrom" alt="imgClmDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21112"/>
							</div>
							<label style="margin-left: 61px; margin-top: 6px; float: left;">To</label>
							<div id="clmDateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtClmDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtClmDateTo" readonly="readonly" tabindex="21113" class="required" ignoreDelKey=""/>
								<img id="imgClmDateTo" alt="imgClmDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21114"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="height: 50px; width: 426px; margin-left: 7px; margin-top: 10px;">
				<table style="margin-top: 2px; margin-left: 50px;">
					<tr>
						<td width="200px"><input type="radio" id="rdoAcctEntDate" value="AD" name="paramDate" style="float: left;" tabindex="21115" /><label for="rdoAcctEntDate" style="margin-top: 3px;">Accounting Entry Date</label></td>
						<td><input type="radio" id="rdoIssueDate" value="ID" name="paramDate" style="float: left;" tabindex="21117" /><label for="rdoIssueDate" style="margin-top: 3px;">Issue Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoEffectivity" value="ED" name="paramDate" style="float: left;" tabindex="21116" checked="checked"/><label for="rdoEffectivity" style="margin-top: 3px;">Effectivity Date</label></td>
						<td><input type="radio" id="rdoBookingDate" value="BD" name="paramDate" style="float: left;" tabindex="21118" /><label for="rdoBookingDate" style="margin-top: 3px;">Booking Date</label></td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="height: 50px; width: 426px; margin-left: 10px; margin-top: 10px;">
				<div style="float: left; margin-top: 14px; margin-left: 96px;">
					<input type="radio" id="rdoFileDate" name="claimDate" style="float: left;" checked="checked" tabindex="21119" /><label for="rdoFileDate" style="margin-top: 3px;">File Date</label>
					<input type="radio" id="rdoLossDate" name="claimDate" style="float: left; margin-left: 85px;" tabindex="21120" /><label for="rdoLossDate" style="margin-top: 3px;">Loss Date</label>
				</div>
			</div>
			
			<div style="margin: 12px 0 4px 223px; float: left;">
				<input type="button" id="btnAddMain" class="button" value="Add" style="margin-left: 150px;"/>
				<input type="button" id="btnDeleteMain" class="disabledButton" value="Delete" />
			</div>
		</fieldset>
		
		<fieldset style="height: 40px; width: 427px; margin-left: 10px; float: left; margin-top: 5px;">
			<legend><b>Extract based on</b></legend>
			<div style="float: left; margin-top: 5px; margin-left: 61px;">
				<input type="radio" id="rdoTsi" name="extractByRg" style="float: left;" checked="checked" tabindex="21121" /><label for="rdoTsi" style="margin-top: 3px;">Total Sum Insured</label>
				<input type="radio" id="rdoLoss" name="extractByRg" style="float: left; margin-left: 82px;" tabindex="21122" /><label for="rdoLoss" style="margin-top: 3px;">Loss Amount</label>
			</div>
		</fieldset>
		
		<fieldset style="height: 40px; width: 431px; margin-left: 7px; float: left; margin-top: 5px;">
			<legend><b>Extraction Type</b></legend>
			<div style="float: left; margin-top: 5px; margin-left: 61px;">
				<input type="radio" id="rdoPolicy" name="eType" style="float: left;" checked="checked" value="1" tabindex="21123" /><label for="rdoPolicy" style="margin-top: 3px;">Policy</label>
				<input type="radio" id="rdoRisk" name="eType" style="float: left; margin-left: 70px;" value="2" tabindex="21124" /><label for="rdoRisk" style="margin-top: 3px;">Risk / Item</label>
				<input type="radio" id="rdoPeril" name="eType" style="float: left; margin-left: 70px;" value="3" tabindex="21125" /><label for="rdoPeril" style="margin-top: 3px;">Peril</label>
			</div>
		</fieldset>
		
		<fieldset style="height: 260px; width: 431px; margin-left: 7px; float: left; margin-top: 5px;">
			<legend><b>Range</b></legend>
			<div id="rangeTGDiv" class="sectionDiv" style="height: 180px; width: 99%; border: none;">
			
			</div>
			<div id="rangeFormDiv" style="margin-top: 8px; float: left;">
				<label style="margin-left: 23px; margin-top: 6px;">From</label>
				<input type="text" id="txtFrom" style="width: 140px; margin-left: 5px; float: left; text-align: right;" class="required" readonly="readonly" maxlength="21"/>
				<label style="margin-left: 33px; margin-top: 6px;">To</label>
				<input type="text" id="txtTo" style="width: 140px; margin-left: 5px; float: left; text-align: right;" class="required" readonly="readonly" maxlength="21"/>
				<div style="margin-top: 8px; float: left;">
					<input type="button" id="btnAdd" class="disabledButton" value="Add" style="margin-left: 150px;"/>
					<input type="button" id="btnDelete" class="disabledButton" value="Delete" />
				</div>
			</div>
		</fieldset>
		
		<fieldset style="height: 260px; width: 431px; margin-left: 6px; float: left; margin-top: 5px;">
			<legend><b>Report/s</b></legend>
			<div id="printDiv" style="margin-top: 5px; margin-left: 65px; border: none; height: 130px; width: 300px; float: left;">
				<table align="center" style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="305" disabled="disabled">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="306" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned">
							<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
			</div>
			<div id="profileChoiceDiv" name="profileChoiceDiv" class="sectionDiv" style="height: 105px; width: 417px; margin-left: 5px;">
				<table style="margin-left: 60px; margin-top: 2px;">
					<tr>
						<td height="20px" colspan="2"><input type="checkbox" id="chkAllTreaties" style="float: left; margin-left: 4px;" /><label for="chkAllTreaties">All Treaties</label></td>
					</tr>
					<tr>
						<td width="150px" height="20px"><input type="radio" id="rdoByLine" name="profileChoice" checked="checked" style="float: left;" /><label for="rdoByLine" style="margin-top: 3px;">By Line</label></td>
						<td><input type="radio" id="rdoBySubline" name="profileChoice" style="float: left;" /><label for="rdoBySubline" style="margin-top: 3px;">By Line and Subline</label></td>
					</tr>
					<tr>
						<td height="20px"><input type="radio" id="rdoByPeril" name="profileChoice" style="float: left;" /><label for="rdoByPeril" style="margin-top: 3px;">By Peril</label></td>
						<td><input type="radio" id="rdoByRisk" name="profileChoice" style="float: left;" /><label for="rdoByRisk" style="margin-top: 3px;">By Risk / Item</label></td>
					</tr>
					<tr>
						<td height="28px"><input type="checkbox" id="chkLossProfileSum" style="float: left; margin-left: 4px;" checked="checked"/><label for="chkLossProfileSum">Summary</label></td>
						<td><input type="checkbox" id="chkLossProfileDtl" style="float: left; margin-left: 5px;" /><label for="chkLossProfileDtl">Detail</label></td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	
	<div id="buttonsDiv" style="margin-bottom: 50px; float: left;">
		<input type="button" id="btnSave" class="button" value="Save" style="margin-left: 134px; margin-top: 10px; width: 160px;"/>
		<input type="button" id="btnExtract" class="button" value="Extract" style="width: 160px;"/>
		<input type="button" id="btnPrintReport" class="button" value="Print Report" style="width: 160px;"/>
		<input type="button" id="btnViewLossProfileDtls" class="button" value="View Loss Profile Details" style="width: 160px;"/>
	</div>
	
	<div>
		<input type="hidden" id="hidCurExist" />
	</div>
</div>
<div id="lossProfileDetailsDiv">
	<jsp:include page="/pages/claims/reports/lossProfile/lossProfileDetails/lossProfileDetails.jsp"></jsp:include>
</div>

<script type="text/javascript">
	var objCC = {};
	var objRP = {};
	var objVar = {};
	var objLPParam = {};
	var objLPRange = {};
	var extractParams = {};
	var reports = [];
	
	var prevTxtFrom;
	var prevTxtTo;
	var lastEdit;
	var prevDate = "";
	var dateField = "";
	var selectedRecord = null;
	var selectedIndex = -1;
	var selectedRangeRecord = null;
	var selectedRangeIndex = -1;
	
	objVar.vExt = "N";
	objVar.vRiskSw = "N";
	objVar.exitPage = null;
	objRP.gicls212Access = 0;
	
	try{
		objLPParam.objLossProfileParamTableGrid = JSON.parse('${jsonLossProfileParam}');
		objLPParam.objLossProfileParam = objLPParam.objLossProfileParamTableGrid.rows || []; 
		
		var lossProfileParamModel = {
			url:contextPath+"/GICLLossProfileController?action=showGICLS211&refresh=1&moduleId=GICLS211",
			options:{
				id: 1,
				width: '884px',
				height: '177px',
				beforeClick: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onCellFocus: function(element, value, x, y, id){
					onMainFocus(y);
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					selectedIndex = -1;
					selectedRecord = null;
					
					populateProfileParam(null);
					queryRange(null, null);	
					
					lossProfileParamTableGrid.keys.removeFocus(lossProfileParamTableGrid.keys._nCurrentFocus, true);
					lossProfileParamTableGrid.keys.releaseKeys();
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					lossProfileParamTableGrid.onRemoveRowFocus();
				},
				onRefresh: function(){
					lossProfileParamTableGrid.onRemoveRowFocus();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					lossProfileParamTableGrid.onRemoveRowFocus();
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
				}
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'dspLineName',
					title: 'Line',
					width: '180px',
					visible: true
				},
				{	id: 'dspSublineName',
					title: 'Subline',
					width: '260px',
					visible: true
				},
				{	id: 'dateFrom',
					title: 'Policy Date From',
					width: '100px',
					align: 'center',
					visible: true
				},
				{	id: 'dateTo',
					title: 'Policy Date To',
					width: '100px',
					align: 'center',
					visible: true
				},
				{	id: 'lossDateFrom',
					title: 'Claim Date From',
					width: '100px',
					align: 'center',
					visible: true
				},
				{	id: 'lossDateTo',
					title: 'Claim Date To',
					width: '100px',
					align: 'center',
					visible: true
				},
			],
			rows: objLPParam.objLossProfileParam
		};
		lossProfileParamTableGrid = new MyTableGrid(lossProfileParamModel);
		lossProfileParamTableGrid.pager = objLPParam.objLossProfileParamTableGrid;
		lossProfileParamTableGrid._mtgId = 1;
		lossProfileParamTableGrid.render('parametersTGDiv');
		lossProfileParamTableGrid.afterRender = function(){
			if(lossProfileParamTableGrid.geniisysRows.length > 0){
				if(lossProfileParamTableGrid.geniisysRows[0].curExist == "N"){
					showMessageBox("Specified line does not exist in the maintenance table.", "E");
				}
			}
			enableOrDisablePrint();
		};
	}catch(e){
		showErrorMessage("parameters tablegrid",e);
	}
	
	try{
		var lossProfileRangeModel = {
			url:contextPath+"/GICLLossProfileController?action=showRange&moduleId=GICLS211&refresh=1&lineCd="+objRP.lineCd+"&sublineCd="+objRP.sublineCd,
			options:{
				id: 2,
				width: '430px',
				height: '157px',
				onCellFocus: function(element, value, x, y, id){
					selectedRangeIndex = y;
					selectedRangeRecord = lossProfileRangeTableGrid.geniisysRows[y];
					
					objLPRange.selectedIndex = y;
					populateRangeFields(lossProfileRangeTableGrid.geniisysRows[y]);
					
					lossProfileRangeTableGrid.keys.removeFocus(lossProfileRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileRangeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					selectedRangeIndex = -1;
					selectedRangeRecord = null;
					
					populateRangeFields(null);
					lossProfileRangeTableGrid.keys.removeFocus(lossProfileRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileRangeTableGrid.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						lossProfileRangeTableGrid.onRemoveRowFocus();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					lossProfileRangeTableGrid.onRemoveRowFocus();
				},
				onRefresh: function(){
					lossProfileRangeTableGrid.onRemoveRowFocus();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					lossProfileRangeTableGrid.onRemoveRowFocus();
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
				}
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'rangeFrom',
					title: 'From',
					width: '195px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'rangeTo',
					title: 'To',
					width: '195px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'number'
				},
			],
			rows: []
		};
		lossProfileRangeTableGrid = new MyTableGrid(lossProfileRangeModel);
		lossProfileRangeTableGrid.pager = {};
		lossProfileRangeTableGrid._mtgId = 2;
		lossProfileRangeTableGrid.render('rangeTGDiv');
		lossProfileRangeTableGrid.afterRender = function(){
			lossProfileRangeTableGrid.keys.removeFocus(lossProfileRangeTableGrid.keys._nCurrentFocus, true);
			lossProfileRangeTableGrid.keys.releaseKeys();
		};
	}catch(e){
		showErrorMessage("range tablegrid",e);
	}
	
	function newFormInstance(){
		initializeAll();
		initializeAccordion();
		makeInputFieldUpperCase();
		setModuleId("GICLS211");
		setDocumentTitle("Loss Profile");
		changeTag = 0;
		objVar.formVariables = JSON.parse('${formVariables}');
		
		if(objVar.formVariables.curExist == "Y"){
			$("hidCurExist").value = "Y";
			$("rdoByLine").checked = true;
		}
		$("lossProfileDetailsDiv").hide();
	}
	
	function populateProfileParam(obj){
		$("txtLineCd").value = obj == null ? "" : obj.lineCd;
		$("txtLineName").value = obj == null ? "" : unescapeHTML2(obj.dspLineName);
		$("txtSublineCd").value = obj == null ? "" : unescapeHTML2(obj.sublineCd); //edited by gab 12.17.2015
		$("txtSublineName").value = obj == null ? "" : unescapeHTML2(obj.dspSublineName);
		$("txtPolDateFrom").value = obj == null ? "" : obj.dateFrom;
		$("txtPolDateTo").value = obj == null ? "" : obj.dateTo;
		$("txtClmDateFrom").value = obj == null ? "" : obj.lossDateFrom;
		$("txtClmDateTo").value = obj == null ? "" : obj.lossDateTo;
		
		$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
		$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
		
		obj == null ? $("btnAddMain").value = "Add" : $("btnAddMain").value = "Update";
		obj == null ? disableButton("btnDeleteMain") : enableButton("btnDeleteMain");
		obj == null ? disableButton("btnAdd") : enableButton("btnAdd");
		obj == null ? disableInputField("txtFrom") : enableInputField("txtFrom");
		obj == null ? disableInputField("txtTo") : enableInputField("txtTo");
		obj == null ? enableSearch("imgLineCdLOV") : disableSearch("imgLineCdLOV");
		obj == null ? enableSearch("imgSublineCdLOV") : disableSearch("imgSublineCdLOV");
		obj == null ? enableInputField("txtLineCd") : disableInputField("txtLineCd");
		obj == null ? enableInputField("txtSublineCd") : disableInputField("txtSublineCd");
		
		if(obj != null){
			if(objVar.formVariables.lineCdMC == obj.lineCd || objVar.formVariables.lineCdFI == obj.lineCd){
				$("rdoRisk").enable();
			}else{
				$("rdoRisk").disable();
			}
		}else{
			$("rdoRisk").enable();
		}
		
		$("btnAdd").value = "Add";
		disableButton("btnDelete");
		
		objVar.vExt = "N";
		enableOrDisablePrint();
		enableDisablePrint();
	}
	
	function populateRangeFields(obj){
		$("txtFrom").value = obj == null ? "" : formatCurrency(obj.rangeFrom);
		$("txtTo").value = obj == null ? "" : formatCurrency(obj.rangeTo);
		
		obj == null ? (selectedRecord != null ? enableButton("btnAdd") : disableButton("btnAdd")) : disableButton("btnAdd");
		obj == null ? enableInputField("txtFrom") : disableInputField("txtFrom");
		obj == null ? enableInputField("txtTo") : disableInputField("txtTo");
		obj == null ? disableButton("btnDelete") : enableButton("btnDelete");
	}
	
	function queryRange(lineCd, sublineCd){
		try{
			lossProfileRangeTableGrid.url = contextPath+"/GICLLossProfileController?action=showRange&moduleId=GICLS211&refresh=1&lineCd="+lineCd+"&sublineCd="+sublineCd;
			lossProfileRangeTableGrid._refreshList();
		}catch(e){
			showErrorMessage("queryRange", e);
		}
	}
	
	function onMainFocus(y, func){
		selectedIndex = y;
		selectedRecord = lossProfileParamTableGrid.geniisysRows[y];
		populateProfileParam(selectedRecord);
		
		objRP.lineCd = selectedRecord.lineCd;
		objRP.sublineCd = nvl(selectedRecord.sublineCd, "");
		objRP.dspLineName = selectedRecord.dspLineName;
		objRP.dspSublineName = selectedRecord.dspSublineName;
		objRP.statusSw = "Y";
		objRP.selectedIndex = y;
		objRP.gicls212Access = selectedRecord.gicls212Access;
		
		whenNewRecordRiskProfile();
		
		if(nvl(func, "") == "onAdd"){
			queryRange(null, null);
		}else{
			queryRange(objRP.lineCd, objRP.sublineCd);
		}
		
		lossProfileParamTableGrid.keys.removeFocus(lossProfileParamTableGrid.keys._nCurrentFocus, true);
		lossProfileParamTableGrid.keys.releaseKeys();
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.lineCd = $F("txtLineCd");
			obj.sublineCd = $F("txtSublineCd");
			obj.dspLineName = $F("txtLineName");
			obj.dspSublineName = $F("txtSublineName");
			obj.dateFrom = $F("txtPolDateFrom");
			obj.dateTo = $F("txtPolDateTo");
			obj.lossDateFrom = $F("txtClmDateFrom");
			obj.lossDateTo = $F("txtClmDateTo");
			obj.noOfRange = rec == null ? 0 : rec.noOfRange;
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("parametersFormDiv")){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return;
				}
				
				changeTagFunc = validateSaveProfile;
				var rec = setRec(selectedRecord);
				
				if($F("btnAddMain") == "Add"){
					lossProfileParamTableGrid.addBottomRow(rec);
					
					var index = lossProfileParamTableGrid.geniisysRows.length - 1;
					lossProfileParamTableGrid.selectRow(index);
					onMainFocus(index, "onAdd");
				} else {
					lossProfileParamTableGrid.updateVisibleRowOnly(rec, selectedIndex, false);
					lossProfileParamTableGrid.onRemoveRowFocus();
				}
				
				changeTag = 1;
				lossProfileParamTableGrid.keys.removeFocus(lossProfileParamTableGrid.keys._nCurrentFocus, true);
				lossProfileParamTableGrid.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function deleteRec(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		changeTagFunc = validateSaveProfile;
		selectedRecord.recordStatus = -1;
		lossProfileParamTableGrid.deleteRow(selectedIndex);
		changeTag = 1;
		lossProfileParamTableGrid.onRemoveRowFocus();
	}
	
	function valAddRange(){
		if(checkAllRequiredFieldsInDiv("rangeFormDiv")){
			var rangeFrom = unformatCurrencyValue($F("txtFrom"));
			var rangeTo = unformatCurrencyValue($F("txtTo"));
			
			for(var i = 0; i < lossProfileRangeTableGrid.geniisysRows.length; i++){
				var row = lossProfileRangeTableGrid.geniisysRows[i];
				
				if(row.recordStatus != -1 && (selectedRangeIndex != -1 && selectedRangeIndex != i)){
					if((parseFloat(rangeFrom) <= parseFloat(row.rangeFrom) && parseFloat(rangeTo) >= parseFloat(row.rangeFrom)) ||
					   (parseFloat(rangeFrom) <= parseFloat(row.rangeTo) && parseFloat(rangeTo) >= parseFloat(row.rangeTo))){
						showMessageBox("Sum Insured Range must not be within the existing range.", "E");
						return;
					}
				}
				
				if(row.recordStatus != -1){
					if((parseFloat(rangeFrom) <= parseFloat(row.rangeFrom) && parseFloat(rangeTo) >= parseFloat(row.rangeFrom)) ||
					   (parseFloat(rangeFrom) <= parseFloat(row.rangeTo) && parseFloat(rangeTo) >= parseFloat(row.rangeTo))){
						showMessageBox("Sum Insured Range must not be within the existing range.", "E");
						return;
					}
				}
			}
			
			addRange();
		}
	}
	
	function unformatRangeCurrencyValue(value) {
		try{
			value = nvl(value, "");
			var unformattedValue = "";	
			if (value.replace(/,/g, "") != "" && !isNaN(parseFloat(value.replace(/,/g, "")))){
				unformattedValue = value.replace(/,/g, "");
			}
			return unformattedValue;	
		}catch(e){
			showErrorMessage("unformatCurrencyValue", e);
		}	
	}
	
	function setRange(rec){
		try {
			var obj = {};
			
			obj.lineCd = selectedRecord.lineCd;
			obj.sublineCd = selectedRecord.sublineCd;
			obj.dateFrom = selectedRecord.dateFrom;
			obj.dateTo = selectedRecord.dateTo;
			obj.lossDateFrom = selectedRecord.lossDateFrom;
			obj.lossDateTo = selectedRecord.lossDateTo;
			obj.rangeFrom = unformatRangeCurrencyValue($F("txtFrom"));
			obj.rangeTo = unformatRangeCurrencyValue($F("txtTo"));
			obj.userId = userId;
			
			if(rec != null){
				obj.oldFrom = rec.rangeFrom;
				obj.oldTo = rec.rangeTo;
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setRange", e);
		}
	}
	
	function addRange(){
		try {
			var rec = setRange(selectedRangeRecord);
			changeTagFunc = validateSaveProfile;
			
			if($F("btnAdd") == "Add"){
				lossProfileRangeTableGrid.addBottomRow(rec);
				selectedRecord.noOfRange += 1;
			} else {
				lossProfileRangeTableGrid.updateVisibleRowOnly(rec, selectedRangeIndex, false);
			}
			
			changeTag = 1;
			lossProfileRangeTableGrid.onRemoveRowFocus();
		} catch(e){
			showErrorMessage("addRange", e);
		}
	}
	
	function deleteRange(){
		changeTagFunc = validateSaveProfile;
		selectedRangeRecord.recordStatus = -1;
		lossProfileRangeTableGrid.deleteRow(selectedRangeIndex);
		selectedRecord.noOfRange -= 1;
		changeTag = 1;
		populateRangeFields(null);
	}
	
	function toggleEType(){
		if($("rdoPolicy").checked){
			$("rdoByLine").disabled = false;
			$("rdoBySubline").disabled = false;
			$("rdoByPeril").disabled = true;
			$("rdoByRisk").disabled = true;
		}else if($("rdoRisk").checked){
			$("rdoByLine").disabled = false;
			$("rdoBySubline").disabled = false;
			$("rdoByPeril").disabled = true;
			$("rdoByRisk").disabled = false;
		}else{
			$("rdoByLine").disabled = false;
			$("rdoBySubline").disabled = false;
			$("rdoByPeril").disabled = false;
			$("rdoByRisk").disabled = true;
		}
	}
	
	function enableOrDisablePrint(){
		if(objVar.vExt == "Y"){
			$("selDestination").enable();
			enableButton("btnPrintReport");
			enableButton("btnViewLossProfileDtls"); // module will be accessible if user has access to GICLS211
			$("chkAllTreaties").disabled = false;
			$("chkLossProfileSum").disabled = false;
			$("chkLossProfileDtl").disabled = false;
			$("rdoByLine").checked = true;
			
			toggleEType();
		}else{
			$("selDestination").disable();
			$("selDestination").selectedIndex = 0;
			toggleRequiredFields("screen");
			
			disableButton("btnPrintReport");
			disableButton("btnViewLossProfileDtls");
			$("chkAllTreaties").disabled = true;
			$("chkLossProfileSum").disabled = true;
			$("chkLossProfileDtl").disabled = true;
			$$("input[name='profileChoice']").each(function(a){
				$(a.id).disabled = true;
			});
		}
	}
	
	function whenNewRecordRiskProfile(){
		if(objVar.vRiskSw == "Y" && objRP.lineCd == ""){
			objVar.vDelTag = "Y";
		}
		
		enableDisablePrint();
		
		objCC.nbtLine = objRP.dspLineName;
		objCC.nbtSline = objRP.dspSublineName;
	}
	
	function enableDisablePrint(){
		if((nvl(objRP.dspLineName, '1') == nvl(objCC.nbtLine, '1')) && (nvl(objRP.dspSublineName, '1') == nvl(objCC.nbtSline, '1')) && (objVar.vExt == "Y")){
			enableButton("btnPrintReport");
			if(checkUserModule("GICLS212") && objRP.gicls212Access == 1){
				enableButton("btnViewLossProfileDtls");	
			}
			$("chkAllTreaties").disabled = false;
			$("chkLossProfileSum").disabled = false;
			$("chkLossProfileDtl").disabled = false;
			$$("input[name='profileChoice']").each(function(a){
				$(a.id).disabled = false;
			});
			$("rdoByLine").checked = true;	
			
			toggleEType();
		}else{
			disableButton("btnPrintReport");
			disableButton("btnViewLossProfileDtls");
			$("chkAllTreaties").disabled = true;
			$("chkLossProfileSum").disabled = true;
			$("chkLossProfileDtl").disabled = true;
			$$("input[name='profileChoice']").each(function(a){
				$(a.id).disabled = true;
			});
		}
	}
	
	function showGicls211LineLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls211LineLOV",
					moduleId : "GICLS211",
					filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%"
				},
				title : "Lines",
				width : 370,
				height : 386,
				draggable : true,
				showNotice: true,
				autoSelectOneRecord: true,
				filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%",
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '90px',
				}, 
				{
					id : "lineName",
					title : "Line Name",
					width : '265px'
				},
				],
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
					
					$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
					$("txtSublineCd").setAttribute("lastValidValue", "");
				},
				onCancel: function(){
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls211LineLOV", e);
		}
	}
	
	function showGicls211SublineLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls211SublineLOV",
					moduleId : "GICLS211",
					lineCd : $F("txtLineCd"),
					filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%"
				},
				title : "Sublines",
				width : 370,
				height : 386,
				draggable : true,
				showNotice: true,
				autoSelectOneRecord: true,
				filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%",
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Code",
					width : '70px',
				}, 
				{
					id : "sublineName",
					title : "Subline Name",
					width : '223px'
				},
				{
					id : "lineCd",
					title : "Line Code",
					width : '60px'
				},
				],
				onSelect : function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd); //edited by gab 12.16.2015
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
				},
				onCancel: function(){
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls211SublineLOV", e);
		}
	}
	
	function validateSaveProfile(){
		var noOfRange = lossProfileRangeTableGrid.geniisysRows.filter(function(obj){return obj.recordStatus != -1;}).length;
		
		if(noOfRange == 0 && (selectedRecord != null && selectedRecord.noOfRange == 0)){
			customShowMessageBox("Range must have at least one record.", "E", "txtFrom");
			return;
		}
		
		if(selectedIndex == -1){
			saveProfile("update");
		}else{
			var lineCd = nvl(selectedRecord.lineCd, "");
			var sublineCd = nvl(selectedRecord.sublineCd, "");
			
			if(lineCd != "" && sublineCd != ""){
				saveProfile("lineSubline");
			}else if(lineCd != "" && sublineCd == ""){
				showConfirmBox4("", "Save by line or by line and subline?", "By Line", "Line and Subline", "Cancel", 
					function(){
						saveProfile("byLine");
					}, 
					function(){
						saveProfile("byLineAndSubline");
					}, null, "");
			}else if(lineCd == "" && sublineCd == ""){
				showConfirmBox4("", "Save by line or by line and subline?", "By Line", "Line and Subline", "Cancel", 
					function(){
						showConfirmBox("", "Saving without specified line will update all records. Do you want to continue?", "Cancel", "Ok",
							null,
							function(){
								saveProfile("allLines");
							}, "");
					},
					function(){
						showConfirmBox("", "Saving without specified line will update all records. Do you want to continue?", "Cancel", "Ok",
							null,
							function(){
								saveProfile("allSubLines");
							}, "");
					}, null, "");
			}
		}
	}
	
	function saveProfile(type){
		try{
			var setRows = getAddedAndModifiedJSONObjects(lossProfileParamTableGrid.geniisysRows);
			var delRows = getDeletedJSONObjects(lossProfileParamTableGrid.geniisysRows);
			var setDtlRows = getAddedAndModifiedJSONObjects(lossProfileRangeTableGrid.geniisysRows);
			var delDtlRows = getDeletedJSONObjects(lossProfileRangeTableGrid.geniisysRows);
			
			new Ajax.Request(contextPath+"/GICLLossProfileController",{
				parameters: {
					action: "saveProfile",
					setRows: prepareJsonAsParameter(setRows),
					delRows: prepareJsonAsParameter(delRows),
					setDtlRows: prepareJsonAsParameter(setDtlRows),
					delDtlRows: prepareJsonAsParameter(delDtlRows),
					type: type
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Saving.. Please wait.."),
				onComplete: function(response){
					hideNotice();
					
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						changeTag = 0;
						changeTagFunc = "";
						
						if(objVar.exitPage != null) {
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								objVar.exitPage();
							});
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								lossProfileParamTableGrid._refreshList();
								objVar.vExt = "N";
								enableOrDisablePrint();
								enableButton("btnExtract");
							});
						}	
					}
				}
			});
		}catch(e){
			showErrorMessage("saveProfile", e);
		}
	}
	
	function checkLastExtract(){
		if((extractParams.paramDate == getParamDate()) && (extractParams.claimDate == ($("rdoFileDate").checked == true ? "FD" : "LD")) &&
			(extractParams.lineCd == selectedRecord.lineCd) && (extractParams.sublineCd == selectedRecord.sublineCd) &&
			(extractParams.dateFrom == $F("txtPolDateFrom")) && (extractParams.dateTo == $F("txtPolDateTo")) &&
			(extractParams.lossDateFrom == $F("txtClmDateFrom")) && (extractParams.lossDateTo == $F("txtClmDateTo")) &&
			(extractParams.extractByRg == ($("rdoTsi").checked == true ? 1 : 2)) && (extractParams.eType == getEType())){
			showConfirmBox("", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
				extractLossProfile, null, "");
		}else{
			extractLossProfile();
		}
	}
	
	function extractLossProfile(){
		try{
			extractParams.paramDate = getParamDate();
			extractParams.claimDate = $("rdoFileDate").checked == true ? "FD" : "LD";
			extractParams.lineCd = selectedRecord.lineCd;
			extractParams.sublineCd = selectedRecord.sublineCd;
			extractParams.dateFrom = $F("txtPolDateFrom");
			extractParams.dateTo = $F("txtPolDateTo");
			extractParams.lossDateFrom = $F("txtClmDateFrom");
			extractParams.lossDateTo = $F("txtClmDateTo");
			extractParams.extractByRg = $("rdoTsi").checked == true ? 1 : 2;
			extractParams.eType = getEType();
			
			new Ajax.Request(contextPath+"/GICLLossProfileController?action=extractLossProfile",{
				parameters: {
					paramDate : extractParams.paramDate,
					claimDate : extractParams.claimDate,
					lineCd : extractParams.lineCd,
					sublineCd : extractParams.sublineCd,
					dateFrom : extractParams.dateFrom,
					dateTo : extractParams.dateTo,
					lossDateFrom : extractParams.lossDateFrom,
					lossDateTo : extractParams.lossDateTo,
					extractByRg : extractParams.extractByRg,
					eType : extractParams.eType
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting.. Please wait.."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var res = JSON.parse(response.responseText);
						showMessageBox(res.message);
						objVar.vExt = res.varExt;
						enableOrDisablePrint();
					}
				}
			});
		}catch(e){
			showErrorMessage("extractLossProfile", e);
		}
	}
	
	function getParamDate(){
		var paramDate = "";
		$$("input[name='paramDate']").each(function(a){
			if($(a.id).checked){
				paramDate = $(a.id).value;
			}
		});	
		return paramDate;
	}
	
	function getEType(){
		var eType = "";
		$$("input[name='eType']").each(function(a){
			if($(a.id).checked){
				eType = $(a.id).value;
			}
		});	
		return eType;
	}
	
	function validatePrint(){
		if(!checkAllRequiredFieldsInDiv("printDiv")){
			return;
		}
		if($F("txtPolDateFrom") == ""){
			customShowMessageBox("Policy Date From must be entered.", "I", "txtPolDateFrom");
			return false;
		}
		if($F("txtPolDateTo") == ""){
			customShowMessageBox("Policy Date To must be entered.", "I", "txtPolToFrom");
			return false;
		}
		if($("chkLossProfileSum").checked){
			if(!$("chkAllTreaties").checked){
				if($("rdoByLine").checked){
					printReport("GICLR211", "Loss Profile Report by Line");
				}else if($("rdoByPeril").checked){
					printReport("GICLR217", "LOSS PROFILE REPORT BY PERIL");
				}else if($("rdoByRisk").checked){
					if(objRP.lineCd == "FI"){
						printReport("GICLR218", "LOSS PROFILE REPORT BY RISK/ITEM");
					}
				}else{
					printReport("GICLR212", "Loss Profile Report by Line and Subline");
				}
			}else{
				if($("rdoByLine").checked){
					printReport("GICLR213", "Loss Profile Report by Line, All Treaties");
				}else if($("rdoByPeril").checked){
					printReport("GICLR217", "LOSS PROFILE REPORT BY PERIL");
				}else if($("rdoByRisk").checked){
					printReport("GICLR218", "LOSS PROFILE REPORT BY RISK/ITEM");
				}else{
					printReport("GICLR214", "Loss Profile Report by Line and Subline, All Treaties");
				}
			}
		}
		if($("chkLossProfileDtl").checked){
			if($("rdoTsi").checked){
				printReport("GICLR215", "Loss Profile Details (Total Sum Insured)");
			}else{
				printReport("GICLR216", "Loss Profile Details (Loss Amount)");
			}
		}
		//added by gab 12.16.2015
		if($("chkAllTreaties").checked){
			if($("rdoByLine").checked){
				printReport("GICLR213", "Loss Profile Report by Line, All Treaties");
			}else if($("rdoByPeril").checked){
				printReport("GICLR217", "LOSS PROFILE REPORT BY PERIL");
			}else if($("rdoByRisk").checked){
				printReport("GICLR218", "LOSS PROFILE REPORT BY RISK/ITEM");
			}else{
				printReport("GICLR214", "Loss Profile Report by Line and Subline, All Treaties");
			}
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function printReport(reportId, reportTitle){
		var content;
		content = contextPath+"/PrintLossProfileController?action=printReportGicls211&reportId="+reportId+"&printerName="+$F("selPrinter")					
				+getParamsGicls211();
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});			
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox("Printing Complete.", "S");
					}
				}
			});
		}else if("file" == $F("selDestination")){
			var fileType = "PDF";
			
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoExcel").checked)
				fileType = "XLS";
			else if ($("rdoCsv").checked)
				fileType = "CSV";
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
			         	      fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if ($("rdoCsv").checked){
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						}else 
							copyFileToLocal(response);
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
				}
			});
		}
	}
	
	function getParamsGicls211(){
		var params = "";
		params = params + "&lineCd=" + objRP.lineCd + "&sublineCd=" + objRP.sublineCd + "&startingDate=" + $F("txtPolDateFrom") + "&endingDate=" + $F("txtPolDateTo")
				 + "&lossDateFrom=" + $F("txtClmDateFrom") + "&lossDateTo=" + $F("txtClmDateTo");
		if($("rdoAcctEntDate").checked){
			params = params + "&paramDate=Accounting Entry Date"; 
		}else if($("rdoEffectivity").checked){
			params = params + "&paramDate=Effectivity Date";
		}else if($("rdoIssueDate").checked){
			params = params + "&paramDate=Issue Date";
		}else if($("rdoBookingDate").checked){
			params = params + "&paramDate=Booking Date";
		}
		if($("rdoFileDate").checked){
			params = params + "&claimDate=Claim File Date"; 
		}else{
			params = params + "&claimDate=Loss Date";
		}
		params = params + "&extract=" + ($("rdoTsi").checked ? "1" : "2");
		return params;
	}
	
	function disablePrint(){
		objVar.vExt = "N";
		extractParams = {};
		enableOrDisablePrint();
		enableDisablePrint();
	}
	
	function onDateChange(){
		if(prevDate != $F(dateField) || prevDate == ""){
			disablePrint();
		}
	}
	
	function exitPage(){
		changeTag = 0;
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}
	
	function cancelGicls211(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objVar.exitPage = exitPage;
						validateSaveProfile();
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disable();
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disable();
			}				
			
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
		}
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") == ""){
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "";
			
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}else{
			showGicls211LineLOV();
		}
	});
	
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineName").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}else{
			showGicls211SublineLOV();
		}
	});
	
	$("txtPolDateFrom").observe("focus", function(){
		if(!$F("txtPolDateTo") == "" && !$F("txtPolDateFrom") == ""){
			if(Date.parse($F("txtPolDateTo")) < Date.parse($F("txtPolDateFrom"))){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtPolDateFrom");
				$("txtPolDateFrom").clear();
			}
		}
	});
	
	$("txtPolDateFrom").observe("blur", function(){
		$("txtClmDateFrom").value = $F("txtPolDateFrom");
	});
	
	$("txtPolDateTo").observe("focus", function(){
		if(!$F("txtPolDateFrom") == "" && !$F("txtPolDateTo") == ""){
			if(Date.parse($F("txtPolDateTo")) < Date.parse($F("txtPolDateFrom"))){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtPolDateTo");
				$("txtPolDateTo").clear();
			}	
		}
	});
	
	$("txtPolDateTo").observe("blur", function(){
		$("txtClmDateTo").value = $F("txtPolDateTo");
	});
	
	$("txtClmDateFrom").observe("focus", function(){
		if(!$F("txtClmDateTo") == "" && !$F("txtClmDateFrom") == ""){
			if(Date.parse($F("txtClmDateTo")) < Date.parse($F("txtClmDateFrom"))){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtClmDateFrom");
				$("txtClmDateFrom").clear();
			}
		}
	});
	
	$("txtClmDateFrom").observe("focus", function(){
		if($F("txtClmDateFrom") != "" && $F("txtPolDateFrom") != ""){
			if(Date.parse($F("txtClmDateFrom")) < Date.parse($F("txtPolDateFrom"))){
				customShowMessageBox("The starting period of Claim must not be earlier than the starting period of Policy.", "I", "txtClmDateFrom");
				$("txtClmDateFrom").clear();
			}
		}
	});
	
	$("txtClmDateTo").observe("focus", function(){
		if(!$F("txtClmDateFrom") == "" && !$F("txtClmDateTo") == ""){
			if(Date.parse($F("txtClmDateTo")) < Date.parse($F("txtClmDateFrom"))){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtClmDateTo");
				$("txtClmDateTo").clear();
			}	
		}
	});
	
	$("txtFrom").observe("focus", function(){
		prevTxtFrom = $F("txtFrom");
		lastEdit = "txtFrom";
	});
	
	$("txtFrom").observe("change", function(){
		if(isNaN(unformatCurrencyValue($F("txtFrom"))) || parseFloat(unformatCurrencyValue($F("txtFrom"))) < 0
				|| parseFloat(unformatCurrencyValue($F("txtFrom"))) > parseFloat("99999999999999.99")){
			customShowMessageBox("Invalid Range From. Valid value should be from 0.00 to 99,999,999,999,999.99.", "I", "txtFrom");
			$("txtFrom").value = prevTxtFrom;
		}else{
			if($F("txtTo") != ""){
				if(parseFloat(unformatCurrencyValue($F("txtFrom"))) > parseFloat(unformatCurrencyValue($F("txtTo")))){
					customShowMessageBox("Starting Sum Insured Range must be less than Ending Sum Insured Range.", "E", "txtFrom");
					$("txtFrom").clear();
					return false;
				}	
			}
			$("txtFrom").value = formatCurrency($F("txtFrom"));
			if(($("btnAdd").value == "Add") && ($F("txtFrom") != "")){
				$("txtTo").value = "99,999,999,999,999.99";	
			}
		}
	});
	
	$("txtTo").observe("focus", function(){
		prevTxtTo = $F("txtTo");
		lastEdit = "txtTo";
	});
	
	$("txtTo").observe("change", function(){
		if(isNaN(unformatCurrencyValue($F("txtTo")) || parseFloat(unformatCurrencyValue($F("txtTo"))) > parseFloat("99999999999999.99"))
				|| parseFloat(unformatCurrencyValue($F("txtTo"))) < 0){
			customShowMessageBox("Invalid Range To. Valid value should be from 0.00 to 99,999,999,999,999.99.", "I", "txtTo");
			$("txtTo").value = prevTxtTo;
		}else{
			if($F("txtFrom") != ""){
				if(parseFloat(unformatCurrencyValue($F("txtFrom"))) > parseFloat(unformatCurrencyValue($F("txtTo")))){
					customShowMessageBox("Ending Sum Insured Range must be greater than Starting Sum Insured Range.", "E", "txtTo");
					$("txtTo").clear();
					return false;
				}	
			}
			$("txtTo").value = formatCurrency($F("txtTo"));
		}
	});
	
	$("btnViewLossProfileDtls").observe("click", function(){
		$("lossProfileMainDiv").hide();
		$("lossProfileDetailsDiv").show();
		
		$("txtDtlLineCd").value = $F("txtLineCd");
		$("txtDtlLineName").value = $F("txtLineName");
		$("txtDtlSublineCd").value = $F("txtSublineCd");
		$("txtDtlSublineName").value = $F("txtSublineName");
		
		setModuleId("GICLS212");
		
		fireEvent($("lossProfileSummaryTab"), "click");
	});
	
	$("btnExtract").observe("click", function(){
		if(selectedIndex == -1 || !checkAllRequiredFieldsInDiv("parametersFormDiv")){
			showMessageBox("Please check if fields are completed and that Policy and Claim types have been chosen.", "I");
			return false;
		}
		if(changeTag == 1){
			showMessageBox("Please save changes first before extracting.", "I");
			return false;
		}
		checkLastExtract();
	});
	
	$("imgPolDateFrom").observe("click", function(){
		prevDate = $F("txtPolDateFrom");
		dateField = "txtPolDateFrom";
	    scwNextAction = onDateChange.runsAfterSCW(this, null);
	    scwShow($("txtPolDateFrom"),this, null);
	});
	
	$("imgPolDateTo").observe("click", function(){
		prevDate = $F("txtPolDateTo");
		dateField = "txtPolDateTo";
	    scwNextAction = onDateChange.runsAfterSCW(this, null);
	    scwShow($("txtPolDateTo"),this, null);
	});
	
	$("imgClmDateFrom").observe("click", function(){
		prevDate = $F("txtClmDateFrom");
		dateField = "txtClmDateFrom";
	    scwNextAction = onDateChange.runsAfterSCW(this, null);
	    scwShow($("txtClmDateFrom"),this, null);
	});
	
	$("imgClmDateTo").observe("click", function(){
		prevDate = $F("txtClmDateTo");
		dateField = "txtClmDateTo";
	    scwNextAction = onDateChange.runsAfterSCW(this, null);
	    scwShow($("txtClmDateTo"),this, null);
	});
	
	$w("rdoTsi rdoLoss rdoPolicy rdoRisk rdoPeril").each(function(r){
		$(r).observe("click", function(){
			disablePrint();
		});
	});
		
	$("imgLineCdLOV").observe("click", showGicls211LineLOV);
	$("imgSublineCdLOV").observe("click", showGicls211SublineLOV);
	$("btnAddMain").observe("click", addRec);
	$("btnDeleteMain").observe("click", deleteRec);
	$("btnAdd").observe("click", valAddRange);
	$("btnDelete").observe("click", deleteRange);
	$("btnExit").observe("click", cancelGicls211);
	$("btnPrintReport").observe("click", validatePrint);
	
	newFormInstance();
	toggleRequiredFields("screen");
	observeSaveForm("btnSave", validateSaveProfile);
	observeReloadForm("reloadForm", showGICLS211);
</script>