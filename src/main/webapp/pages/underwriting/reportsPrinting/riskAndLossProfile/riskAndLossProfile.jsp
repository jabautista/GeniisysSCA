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
			<label>Risk and Loss Profile</label>
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
			
			<div id="parametersFormDiv" style="float: left; width: 100%;">
				<table align="center">
					<tr>
						<td class="rightAligned">Line</td>
						<td>
							<div id="lineCdDiv" style="float: left; width: 70px; height: 21px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtLineCd" title="Line Code" type="text" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" class="upper" tabindex="21101" lastValidValue="" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;" tabindex="21102"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtLineName" style="width: 220px; margin-top: 3x;" tabindex="21103" readonly="readonly"/>
						</td>
						<td class="rightAligned" width="120px">Policy Date From</td>
						<td>
							<div id="dateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtDateFrom" readonly="readonly" class="required" tabindex="21107" ignoreDelKey=""/>
								<img id="imgDateFrom" alt="imgDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21108"/>
							</div>
							<label style="margin-left: 31px; margin-top: 6px; float: left;">To</label>
							<div id="dateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtDateTo" readonly="readonly" tabindex="21109" class="required" ignoreDelKey=""/>
								<img id="imgDateTo" alt="imgDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21110"/>
							</div>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td>
							<div id="sublineCdDiv" style="float: left; width: 70px; height: 21px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtSublineCd" title="Subline Code" type="text" maxlength="7" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="21104" class="upper" lastValidValue="" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCdLOV" name="imgSublineCdLOV" alt="Go" style="float: right;" tabindex="21105"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtSublineName" style="width: 220px; margin-top: 3x;" tabindex="21106" readonly="readonly"/>
						</td>						
						
						<td class="rightAligned">Claim Date From</td>
						<td>
							<div id="lossDateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtLossDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtLossDateFrom" readonly="readonly" class="required" tabindex="21111" ignoreDelKey=""/>
								<img id="imgLossDateFrom" alt="imgLossDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21112"/>
							</div>
							<label style="margin-left: 31px; margin-top: 6px; float: left;">To</label>
							<div id="lossDateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;" class="required">
								<input type="text" id="txtLossDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtLossDateTo" readonly="readonly" tabindex="21113" class="required" ignoreDelKey=""/>
								<img id="imgLossDateTo" alt="imgLossDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21114"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Crediting Branch</td>
						<td>
							<div id="credBranchDiv" style="float: left; width: 70px; height: 21px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtCredBranch" title="Crediting Branch" type="text" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="21104" class="upper" lastValidValue="" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCredBranchLOV" name="imgCredBranchLOV" alt="Go" style="float: right;" tabindex="21105"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtIssName" style="width: 220px; margin-top: 3x;" tabindex="21106" readonly="readonly"/>
						</td>
						<td colspan="2" style="padding-left: 23px;">
							<input type="checkbox" id="chkIncEndt" style="float: left;"/>
							<label for="chkIncEndt">Include endorsement/s beyond the given period</label>
						</td>
					</tr>
					<tr>
						<td colspan="3">
						</td>
						<td colspan="2" style="padding-left: 23px;">
							<input type="checkbox" id="chkIncExpired" style="float: left;"/>
							<label for="chkIncExpired">Include expired records</label>
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
		
		<fieldset style="height: 40px; width: 431px; margin-right: 9px; float: right; margin-top: 5px;">
			<legend><b>Extract based on</b></legend>
			<div style="float: left; margin-top: 5px; margin-left: 40px;">
				<input type="radio" id="rdoPolicy" name="eType" style="float: left;" checked="checked" value="1" tabindex="21123" /><label for="rdoPolicy" style="margin-top: 3px;">Policy</label>
				<input type="radio" id="rdoSubline" name="eType" style="float: left; margin-left: 40px;"  value="2" tabindex="21124" /><label for="rdoSubline" style="margin-top: 3px;">Subline</label>
				<input type="radio" id="rdoPeril" name="eType" style="float: left; margin-left: 40px;" value="3" tabindex="21125" /><label for="rdoPeril" style="margin-top: 3px;">Peril</label>
				<input type="radio" id="rdoRisk" name="eType" style="float: left; margin-left: 40px;" value="4" tabindex="21126" /><label for="rdoRisk" style="margin-top: 3px;">Risk / Item</label>
				
			</div>
		</fieldset>
		
		<fieldset style="height: 321px; width: 431px; margin-left: 10px; float: left; margin-top: 5px;">
			<legend><b>Range</b></legend>
			<div id="rangeTGDiv" class="sectionDiv" style="height: 235px; width: 99%; border: none;">
			
			</div>
			<div id="rangeFormDiv" style="float: left;">
				<label style="margin-left: 23px; margin-top: 6px;">From</label>
				<input type="text" id="txtRangeFrom" style="width: 140px; margin-left: 5px; float: left; text-align: right;" class="required money4" min="-99999999999999.99" max="99999999999999.99" readonly="readonly" maxlength="21"/>
				<label style="margin-left: 33px; margin-top: 6px;">To</label>
				<input type="text" id="txtRangeTo" style="width: 140px; margin-left: 5px; float: left; text-align: right;" class="required money4" min="-99999999999999.99" max="99999999999999.99" readonly="readonly" maxlength="21"/>
				<div style="margin-top: 8px; float: left;">
					<input type="button" id="btnAdd" class="disabledButton" value="Add" style="margin-left: 150px;"/>
					<input type="button" id="btnDelete" class="disabledButton" value="Delete" />
				</div>
			</div>
		</fieldset>
		
		<fieldset style="height: 260px; width: 431px; margin-right: 9px; float: right; margin-top: 5px;">
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
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
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
						<td height="20px" width="160px"><input type="checkbox" id="chkAllTreaties" style="float: left; margin-left: 4px;" /><label for="chkAllTreaties">All Treaties</label></td>
						<td><input type="radio" id="rdoByLine" name="profileChoice" checked="checked" style="float: left;" /><label for="rdoByLine" style="margin-top: 3px;">By Line</label></td>						
					</tr>
					<tr>
						<td height="20px" colspan="1"><input type="checkbox" id="chkByTariff" style="float: left; margin-left: 4px;" /><label for="chkByTariff">By Tariff</label></td>
						<td><input type="radio" id="rdoBySubline" name="profileChoice" style="float: left;" /><label for="rdoBySubline" style="margin-top: 3px;">By Line and Subline</label></td>
					</tr>
					<tr>
						<td height="20px"><input type="checkbox" id="chkLossProfileSum" style="float: left; margin-left: 4px;" checked="checked"/><label for="chkLossProfileSum">Summary</label></td>
						<td height="20px"><input type="radio" id="rdoByPeril" name="profileChoice" style="float: left;" /><label for="rdoByPeril" style="margin-top: 3px;">By Peril</label></td>						
					</tr>
					<tr>						
						<td><input type="checkbox" id="chkLossProfileDtl" style="float: left; margin-left: 5px;" /><label for="chkLossProfileDtl">Detail</label></td>
						<td><input type="radio" id="rdoByRisk" name="profileChoice" style="float: left;" /><label for="rdoByRisk" style="margin-top: 3px;">By Risk / Item</label></td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	
	<div id="buttonsDiv" style="margin-bottom: 50px; float: left; text-align: center; width: 100%;">
		<input type="button" id="btnSave" class="button" value="Save" style="margin-top: 10px; width: 160px;"/>
		<input type="button" id="btnExtract" class="button" value="Extract" style="width: 160px;"/>
		<input type="button" id="btnPrintReport" class="button" value="Print Report" style="width: 160px;"/>
		<!-- <input type="button" id="btnViewLossProfileDtls" class="button" value="View Loss Profile Details" style="width: 160px;"/> -->
	</div>
	
	<div>
		<input type="hidden" id="hidCurExist" />
	</div>
</div>
<script type="text/javascript">
	try{
		var objGIPIS902 = {};
		selectedIndex = -1;
		var selectedRecord = null;
		var selectedRangeIndex = -1;
		var selectedRangeRecord = null;
		var extractParams = {};
		var reportId;
		var reportTitle;
		
		var objVar = {};
		objVar.vExt = "N";
		
		function initializeGIPIS902(){
			initializeAll();
			initializeAccordion();
			initializeAllMoneyFields();
			makeInputFieldUpperCase();
			setModuleId("GIPIS902");
			setDocumentTitle("Risk and Loss Profile");
			changeTag = 0;
			changeExtractBasedOn("Y");
			$("txtLineCd").focus();
			setPrintFields(false);
		}
		
		try{
			objGIPIS902.gipiRiskLossProfileTableGrid = JSON.parse('${jsonGipiRiskLossProfile}');
			objGIPIS902.objLossProfileParam = []; 
			
			var riskLossProfileTableModel = {
				url:contextPath+"/GIPIRiskLossProfileController?action=showGIPIS902&refresh=1",
				options:{
					id: 1,
					width: 884,
					height: 177,
					hideColumnChildTitle: true,
					toolbar : {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							riskLossProfileTableGrid.keys.removeFocus(riskLossProfileTableGrid.keys._nCurrentFocus, true);
							riskLossProfileTableGrid.keys.releaseKeys();
						}
					},
					beforeClick: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						}
					},
					onCellFocus: function(element, value, x, y, id){
						selectedIndex = y;						
						setRiskLossProfileFields(riskLossProfileTableGrid.geniisysRows[y]);
						riskLossProfileTableGrid.keys.removeFocus(riskLossProfileTableGrid.keys._nCurrentFocus, true);
						riskLossProfileTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						selectedIndex = -1;
						setRiskLossProfileFields(null);						
						riskLossProfileTableGrid.keys.removeFocus(riskLossProfileTableGrid.keys._nCurrentFocus, true);
						riskLossProfileTableGrid.keys.releaseKeys();
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
						riskLossProfileTableGrid.onRemoveRowFocus();
					},
					onRefresh: function(){
						riskLossProfileTableGrid.onRemoveRowFocus();
					},				
					prePager: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return false;
						}
						riskLossProfileTableGrid.onRemoveRowFocus();
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
			 		{   id: "recordStatus",
					    title: "",
					    width: "0px",
					    visible: false,
					    editor: "checkbox" 			
					},
					{	id: "divCtrId",
						width: "0px",
						visible: false
					},
					{	
						id: "lineCd lineName",
						title: "Line",
						children : [
							{
								id: "lineCd",
								title: "Line Code",
								width: 30,
								filterOption: true
							},
							{
								id: "lineName",
								title: "Line Name",
								width: 110,
								filterOption: true
							}
						]
					},
					{	
						id: "sublineCd sublineName",
						title: "Subline",
						children : [
							{
								id: "sublineCd",
								title: "Subline Code",
								width: 50,
								filterOption: true
							},
							{
								id: "sublineName",
								title: "Subline Name",
								width: 110,
								filterOption: true
							}
						]
					},	
					{	
						id: "credBranch issName",
						title: "Crediting Branch",
						children : [
							{
								id: "credBranch",
								title: "Cred. Branch Code",
								width: 30,
								filterOption: true
							},
							{
								id: "issName",
								title: "Cred. Branch Name",
								width: 110,
								filterOption: true
							}
						]
					},	
					{	id: "dateFrom",
						title: "Policy Date From",
						width: 100,
						align: "center",
						filterOption : true,
						filterOptionType : "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{	id: "dateTo",
						title: "Policy Date To",
						width: 100,
						align: "center",
						filterOption : true,
						filterOptionType : "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{	id: "lossDateFrom",
						title: "Claim Date From",
						width: 100,
						align: "center",
						filterOption : true,
						filterOptionType : "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{	id: "lossDateTo",
						title: "Claim Date To",
						width: 100,
						align: "center",
						filterOption : true,
						filterOptionType : "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
				],
				rows: objGIPIS902.gipiRiskLossProfileTableGrid.rows
			};
			riskLossProfileTableGrid = new MyTableGrid(riskLossProfileTableModel);
			riskLossProfileTableGrid.pager = objGIPIS902.gipiRiskLossProfileTableGrid;
			riskLossProfileTableGrid._mtgId = 1;
			riskLossProfileTableGrid.render("parametersTGDiv");
		}catch(e){
			showErrorMessage("parameters tablegrid", e);
		}
		
		try{
			var riskLossProfileRangeModel = {
				url:contextPath+"/GIPIRiskLossProfileController?action=getGipiRiskLossProfileRange",
				options:{
					id: 2,
					width: 430,
					height: 200,
					onCellFocus: function(element, value, x, y, id){
						selectedRangeRecord = riskLossProfileRangeTableGrid.geniisysRows[y];
						selectedRangeIndex = y;
						setRangeFields(riskLossProfileRangeTableGrid.geniisysRows[y]);
						riskLossProfileRangeTableGrid.keys.removeFocus(riskLossProfileRangeTableGrid.keys._nCurrentFocus, true);
						riskLossProfileRangeTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						selectedRangeRecord = null;
						selectedRangeIndex = -1;
						setRangeFields(null);
						riskLossProfileRangeTableGrid.keys.removeFocus(riskLossProfileRangeTableGrid.keys._nCurrentFocus, true);
						riskLossProfileRangeTableGrid.keys.releaseKeys();
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
						riskLossProfileRangeTableGrid.onRemoveRowFocus();
					},
					onRefresh: function(){
						riskLossProfileRangeTableGrid.onRemoveRowFocus();
					},				
					prePager: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return false;
						}
						riskLossProfileRangeTableGrid.onRemoveRowFocus();
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
						width: 200,
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						filterOption: true,
						filterOptionType: 'number',
						sortable : false
					},
					{	id: 'rangeTo',
						title: 'To',
						width: 200,
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						filterOption: true,
						filterOptionType: 'number',
						sortable : false
					}
				],
				rows: []
			};
			riskLossProfileRangeTableGrid = new MyTableGrid(riskLossProfileRangeModel);
			riskLossProfileRangeTableGrid.pager = {};
			riskLossProfileRangeTableGrid._mtgId = 2;
			riskLossProfileRangeTableGrid.render('rangeTGDiv');
			riskLossProfileRangeTableGrid.afterRender = function(){
				if(riskLossProfileRangeTableGrid.geniisysRows.length > 0){	
					var rec = riskLossProfileRangeTableGrid.geniisysRows[0];
					minRangeFrom = rec.minRangeFrom == "" || rec.minRangeFrom == null ? "0.00" : formatToNthDecimal(rec.minRangeFrom, 2);
					maxRangeTo = rec.maxRangeTo == "" || rec.maxRangeTo == null ? "0.00" : formatToNthDecimal(rec.maxRangeTo, 2);
					recCount = rec.recCount;
				} else {
					minRangeFrom = "";
					maxRangeTo = "";
					recCount = "";
				}
				setRangeFields(null);
				riskLossProfileRangeTableGrid.keys.removeFocus(riskLossProfileRangeTableGrid.keys._nCurrentFocus, true);
				riskLossProfileRangeTableGrid.keys.releaseKeys();
			};
		}catch(e){
			showErrorMessage("Range tablegrid", e);
		}
		
		function setRec(rec){
			try {
				var obj = (rec == null ? {} : rec);
				
				obj.lineCd = $F("txtLineCd");
				obj.lineName = $F("txtLineName");
				obj.sublineCd = $F("txtSublineCd");				
				obj.sublineName = $F("txtSublineName");
				obj.credBranch = $F("txtCredBranch");				
				obj.issName = $F("txtIssName");
				obj.dateFrom = $F("txtDateFrom");
				obj.dateTo = $F("txtDateTo");
				obj.lossDateFrom = $F("txtLossDateFrom");
				obj.lossDateTo = $F("txtLossDateTo");
				obj.noOfRange = rec == null ? 0 : rec.noOfRange;
				obj.userId = userId;
				
				if($("rdoPolicy").checked) {
					obj.allLineTag = "Y";
				} else if ($("rdoSubline").checked) {
					obj.allLineTag = "N";
				} else if ($("rdoPeril").checked) {
					obj.allLineTag = "P";
				} else if ($("rdoRisk").checked) {
					obj.allLineTag = "R";
				}
				
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
						riskLossProfileTableGrid.addBottomRow(rec);
						
						var index = riskLossProfileTableGrid.geniisysRows.length - 1;
						riskLossProfileTableGrid.selectRow(index);
						setRiskLossProfileFields(riskLossProfileTableGrid.geniisysRows[index]);
						selectedIndex = index;
					} else {
						riskLossProfileTableGrid.updateVisibleRowOnly(rec, selectedIndex, false);
						riskLossProfileTableGrid.onRemoveRowFocus();
					}
					
					changeTag = 1;
					riskLossProfileTableGrid.keys.removeFocus(riskLossProfileTableGrid.keys._nCurrentFocus, true);
					riskLossProfileTableGrid.keys.releaseKeys();
					setPrintFields(false);
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
			riskLossProfileTableGrid.deleteRow(selectedIndex);
			changeTag = 1;
			riskLossProfileTableGrid.onRemoveRowFocus();
			setPrintFields(false);
		}
		
		function valAddRange(){
			if(checkAllRequiredFieldsInDiv("rangeFormDiv")){
				var rangeFrom = unformatCurrencyValue($F("txtRangeFrom"));
				var rangeTo = unformatCurrencyValue($F("txtRangeTo"));
				
				if(rangeFrom > rangeTo) {
					showMessageBox("Range From should be less than Range To.", "");
					return;
				}
				
				for(var i = 0; i < riskLossProfileRangeTableGrid.geniisysRows.length; i++){
					var row = riskLossProfileRangeTableGrid.geniisysRows[i];

					if(row.recordStatus != -1 && (selectedRangeIndex != -1 && selectedRangeIndex != i)){
						if((parseFloat(rangeFrom) <= parseFloat(row.rangeFrom) && parseFloat(rangeTo) >= parseFloat(row.rangeFrom)) ||
						   (parseFloat(rangeFrom) <= parseFloat(row.rangeTo) && parseFloat(rangeTo) >= parseFloat(row.rangeTo))){
							showMessageBox("Sum Insured Range must not be within the existing range.", "E");
							return;
						}
					} else if(row.recordStatus != -1){
						if((parseFloat(rangeFrom) >= parseFloat(row.rangeFrom) && parseFloat(rangeFrom) <= parseFloat(row.rangeTo)) ||
								(parseFloat(rangeTo) >= parseFloat(row.rangeFrom) && parseFloat(rangeTo) <= parseFloat(row.rangeTo))){
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
				obj.credBranch = selectedRecord.credBranch;
				obj.dateFrom = selectedRecord.dateFrom;
				obj.dateTo = selectedRecord.dateTo;
				obj.lossDateFrom = selectedRecord.lossDateFrom;
				obj.lossDateTo = selectedRecord.lossDateTo;
				obj.rangeFrom = rec == null ? unformatRangeCurrencyValue($F("txtRangeFrom")) : nvl(unformatRangeCurrencyValue($F("txtRangeFrom")), rec.rangeFrom);
				obj.rangeTo = rec == null ? unformatRangeCurrencyValue($F("txtRangeTo")) : nvl(unformatRangeCurrencyValue($F("txtRangeTo")), rec.rangeTo);				 
				obj.userId = userId;
				obj.allLineTag = selectedRecord.allLineTag;
				maxRangeTo = unformatCurrency("txtRangeTo");
				
				riskLossProfileTableGrid.geniisysRows[selectedIndex].recordStatus = 1;
				
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
					riskLossProfileRangeTableGrid.addBottomRow(rec);
					selectedRecord.noOfRange += 1;
				} else {
					riskLossProfileRangeTableGrid.updateVisibleRowOnly(rec, selectedRangeIndex, false);
				}
				
				changeTag = 1;
				setPrintFields(false);
				riskLossProfileRangeTableGrid.onRemoveRowFocus();
			} catch(e){
				showErrorMessage("addRange", e);
			}
		}
		
		function deleteRange(){
			changeTagFunc = validateSaveProfile;
			selectedRangeRecord.recordStatus = -1;
			riskLossProfileRangeTableGrid.deleteRow(selectedRangeIndex);
			selectedRecord.noOfRange -= 1;
			riskLossProfileTableGrid.geniisysRows[selectedIndex].recordStatus = 1;
			changeTag = 1;
			setPrintFields(false);
			setRangeFields(null);
		}
		
		function showGipis902LineLOV(){
			try {
				LOV.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getGipis902LineLov",
						filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%"
					},
					title : "List of Lines",
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
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						
						if($("txtLineCd").getAttribute("lastValidValue") != $F("txtLineCd")){
							$("txtSublineCd").clear();
							$("txtSublineName").clear();
							$("txtSublineCd").setAttribute("lastValidValue", "");
							$("txtSublineName").setAttribute("lastValidValue", "");
						}
						
						$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
						$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onCancel: function(){
						$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
						$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onUndefinedRow: function(){
						showMessageBox("No record selected.", "I");
						$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
						$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onShow: function(){
						$(this.id+"_txtLOVFindText").focus();
					}
				});
			} catch (e) {
				showErrorMessage("showGipis902LineLOV", e);
			}
		}
		
		function showGipis902SublineLOV(){
			try {
				LOV.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getGipis902SublineLov",
						lineCd : $F("txtLineCd"),
						filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%"
					},
					title : "List of Sublines",
					width : 370,
					height : 386,
					draggable : true,
					showNotice: true,
					autoSelectOneRecord: true,
					filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%",
					columnModel : [ {
						id : "sublineCd",
						title : "Subline Code",
						width : '90px',
					}, 
					{
						id : "sublineName",
						title : "Subline Name",
						width : '193px'
					},
					{
						id : "lineCd",
						title : "Line Code",
						width : '70px'
					},
					],
					onSelect : function(row) {
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
						$("txtSublineName").setAttribute("lastValidValue", $F("txtSublineName"));
						
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);						
						$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
						$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onCancel: function(){
						$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
						$("txtSublineName").value = $("txtSublineName").getAttribute("lastValidValue");
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onUndefinedRow: function(){
						showMessageBox("No record selected.", "I");
						$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
						$("txtSublineName").value = $("txtSublineName").getAttribute("lastValidValue");
						
						if($F("txtLineCd") != "FI" && $F("txtLineCd") != "MC") {
							$("rdoPolicy").checked = true;
							$("rdoRisk").disabled = true;
						} else {
							$("rdoRisk").disabled = false;
						}
					},
					onShow: function(){
						$(this.id+"_txtLOVFindText").focus();
					}
				});
			} catch (e) {
				showErrorMessage("showGipis902SublineLOV", e);
			}
		}
		
		function showGipis902IssLOV(){
			try {
				LOV.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getGipis902IssLov",
						filterText: $F("txtCredBranch") != $("txtCredBranch").getAttribute("lastValidValue") ? nvl($F("txtCredBranch"), "%") : "%"
					},
					title : "List of Crediting Branch",
					width : 370,
					height : 386,
					draggable : true,
					showNotice: true,
					autoSelectOneRecord: true,
					filterText: $F("txtCredBranch") != $("txtCredBranch").getAttribute("lastValidValue") ? nvl($F("txtCredBranch"), "%") : "%",
					columnModel : [ {
						id : "issCd",
						title : "Cred. Branch Code",
						width : '120px',
					}, 
					{
						id : "issName",
						title : "Cred. Branch Name",
						width : '235px'
					},
					],
					onSelect : function(row) {
						$("txtCredBranch").value = unescapeHTML2(row.issCd);
						$("txtIssName").value = unescapeHTML2(row.issName);
						
						$("txtCredBranch").setAttribute("lastValidValue", $F("txtCredBranch"));
						$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
					},
					onCancel: function(){
						$("txtCredBranch").value = $("txtCredBranch").getAttribute("lastValidValue");
						$("txtIssName").value = $("txtIssName").getAttribute("lastValidValue");
					},
					onUndefinedRow: function(){
						showMessageBox("No record selected.", "I");
						$("txtCredBranch").value = $("txtCredBranch").getAttribute("lastValidValue");
						$("txtIssName").value = $("txtIssName").getAttribute("lastValidValue");
					},
					onShow: function(){
						$(this.id+"_txtLOVFindText").focus();
					}
				});
			} catch (e) {
				showErrorMessage("showGipis902IssLOV", e);
			}
		}
		
		function validateSaveProfile(){
			var noOfRange = riskLossProfileRangeTableGrid.geniisysRows.filter(function(obj){return obj.recordStatus != -1;}).length;
			
			if(noOfRange == 0 && (selectedRecord != null && selectedRecord.noOfRange == 0)){
				customShowMessageBox("Range must have at least one record.", "E", "txtRangeFrom");
				return;
			}
			
			if(selectedRecord == null){
				saveProfile("update");
			}else{
				var lineCd = nvl(selectedRecord.lineCd, "");
				
				if(lineCd != ""){
					saveProfile("new");
				}else {
					showConfirmBox("", "Saving without specified line will update all records. Do you want to continue?", "Cancel", "Ok",
						null,
						function(){
							saveProfile("new");
						},
					"");
				}
			}
		}
		
		function saveProfile(type){
			try{				
				var setParamRows = getAddedAndModifiedJSONObjects(riskLossProfileTableGrid.geniisysRows);
				var delParamRows = getDeletedJSONObjects(riskLossProfileTableGrid.geniisysRows);
				var setRangeRows = getJSONObjects(riskLossProfileRangeTableGrid.geniisysRows);
				var delRangeRows = getDeletedJSONObjects(riskLossProfileRangeTableGrid.geniisysRows);				
				
				new Ajax.Request(contextPath+"/GIPIRiskLossProfileController",{
					parameters: {
						action: "saveGIPIS902",
						setParamRows: prepareJsonAsParameter(setParamRows),
						delParamRows: prepareJsonAsParameter(delParamRows), 
						setRangeRows: prepareJsonAsParameter(setRangeRows),
						delRangeRows: prepareJsonAsParameter(delRangeRows),
						lineCd: $F("txtLineCd"),
						sublineCd: $F("txtSublineCd"),
						type: type
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Saving.. Please wait.."),
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							changeTag = 0;
							changeTagFunc = "";
							showGIPIS902();							
						}
					}
				});
			}catch(e){
				showErrorMessage("saveProfile", e);
			}
		}
		
		function extractLossProfile(){
			try{
				new Ajax.Request(contextPath+"/GIPIRiskLossProfileController?action=extractGIPIS902",{
					parameters: {
						lineCd : selectedRecord.lineCd,
						sublineCd : selectedRecord.sublineCd == null ? "" : selectedRecord.sublineCd,
						dateFrom : selectedRecord.dateFrom,
						dateTo : selectedRecord.dateTo,	
						paramDate : getParamDate(),
						allLineTag : selectedRecord.allLineTag,
						byTarf : $("chkByTariff").checked ? "Y" : "N",
						credBranch : selectedRecord.credBranch == null ? "" : selectedRecord.credBranch,
						incExpired : $("chkIncExpired").checked ? "Y" : "N",
						incEndt : $("chkIncEndt").checked ? "Y" : "N",
						lossDateFrom : selectedRecord.lossDateFrom,
						lossDateTo : selectedRecord.lossDateTo,
						claimDate : $("rdoFileDate").checked == true ? "FD" : "LD"
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Extracting.. Please wait.."),
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							showWaitingMessageBox("Extraction finished.", "S", function(){
								
							});
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
					//$("rdoExcel").disable();
					$("rdoCsv").disable();
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					//$("rdoExcel").enable();
					$("rdoCsv").enable();
				} else {
					$("rdoPdf").disable();
					//$("rdoExcel").disable();
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
		
		$("txtRangeFrom").observe("focus", function(){
			if ($("btnDelete").hasClassName('disabledButton') && $("btnAdd").hasClassName('disabledButton')) return false;	//Gzelle 09112015 SR4136

			if($F("btnAdd") == "Add"){
				if (maxRangeTo >= $("txtRangeTo").getAttribute("max")) {
					$("txtRangeFrom").readOnly = true;
					$("txtRangeTo").readOnly = true;
				}else {
					$("txtRangeFrom").value = maxRangeTo == "" || maxRangeTo == null ? "0.00" : roundNumber((parseFloat(maxRangeTo) + .01), 2);
				}
			}
		});
		
		$("txtRangeFrom").observe("change", function(){
			if(isNaN(unformatCurrencyValue($F("txtRangeFrom"))) || parseFloat(unformatCurrencyValue($F("txtRangeFrom"))) < 0
					|| parseFloat(unformatCurrencyValue($F("txtRangeFrom"))) > parseFloat("99999999999999.99")){
					showWaitingMessageBox("Invalid Range From. Valid value should be from 0.00 to 99,999,999,999,999.99.", "I", function(){
						$("txtRangeFrom").clear();
						$("txtRangeFrom").focus();
					});
				
			}else{
				if($F("txtRangeTo") != ""){
					if(parseFloat(unformatCurrencyValue($F("txtRangeFrom"))) > parseFloat(unformatCurrencyValue($F("txtRangeTo")))){
						showWaitingMessageBox("Starting Sum Insured Range must be less than Ending Sum Insured Range.", "E", function(){
							$("txtRangeFrom").clear();
							$("txtRangeFrom").focus();
						});
						
						return false;
					}	
				}
				$("txtRangeFrom").value = formatCurrency($F("txtRangeFrom"));
				if(($("btnAdd").value == "Add") && ($F("txtRangeFrom") != "")){
					$("txtRangeTo").value = "99,999,999,999,999.99";	
				}
			}
		});
		
		$("txtRangeTo").observe("focus", function(){ 
			if (this.value == "" && maxRangeTo != $("txtRangeTo").getAttribute("max")){
				$("txtRangeTo").value = $("txtRangeTo").getAttribute("max");
			}	
		});
		
		$("txtRangeTo").observe("change", function(){
			if(isNaN(unformatCurrencyValue($F("txtRangeTo")) || parseFloat(unformatCurrencyValue($F("txtRangeTo"))) > parseFloat("99999999999999.99"))
					|| parseFloat(unformatCurrencyValue($F("txtRangeTo"))) < 0){
					showWaitingMessageBox("Invalid Range To. Valid value should be from 0.00 to 99,999,999,999,999.99.", "I", function(){
						$("txtRangeTo").clear();
						$("txtRangeTo").focus();
					});				
			}else{
				if($F("txtRangeFrom") != ""){
					if(parseFloat(unformatCurrencyValue($F("txtRangeFrom"))) > parseFloat(unformatCurrencyValue($F("txtRangeTo")))){
						showWaitingMessageBox("Ending Sum Insured Range must be greater than Starting Sum Insured Range.", "E", function(){
							$("txtRangeTo").clear();
							$("txtRangeTo").focus();
						});
						
						return false;
					}	
				}
				$("txtRangeTo").value = formatCurrency($F("txtRangeTo"));
			}
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
			extractLossProfile();
		}); 
		toggleRequiredFields("screen");
		
		$("btnAddMain").observe("click", addRec);
		$("btnAdd").observe("click", valAddRange);
		$("btnDelete").observe("click", deleteRange);
		$("btnDeleteMain").observe("click", deleteRec);
		observeSaveForm("btnSave", validateSaveProfile); 
		
		$("imgDateFrom").observe("click", function(){
			if(!this.disabled)
				scwShow($("txtDateFrom"), this, null);
		});
		
		$("imgDateTo").observe("click", function(){
			if(!this.disabled)
				scwShow($("txtDateTo"), this, null);
		});
		
		$("imgLossDateFrom").observe("click", function(){
			if(!this.disabled)
				scwShow($("txtLossDateFrom"), this, null);
		});
		
		$("imgLossDateTo").observe("click", function(){
			if(!this.disabled)
				scwShow($("txtLossDateTo"), this, null);
		});
		
		$("txtDateFrom").observe("focus", function(){
			var dateFrom = Date.parse($F("txtDateFrom"));
			var dateTo = Date.parse($F("txtDateTo"));
			
			if(dateFrom > dateTo && dateTo != null && dateFrom != null) {
				showWaitingMessageBox("Policy Date From should not be later than Policy Date To.", "I", function(){
					$("txtDateFrom").clear();
				});				
			} else {
				if($F("txtLossDateFrom") == "")
					$("txtLossDateFrom").value = this.value;
			}
		});
		
		$("txtDateTo").observe("focus", function(){
			var dateFrom = Date.parse($F("txtDateFrom"));
			var dateTo = Date.parse($F("txtDateTo"));
			
			if(dateFrom > dateTo && dateTo != null && dateFrom != null) {
				showWaitingMessageBox("Policy Date From should not be later than Policy Date To.", "I", function(){
					$("txtDateTo").clear();
				});				
			} else {
				if($F("txtLossDateTo") == "")
					$("txtLossDateTo").value = this.value;
			}
		});
		
		$("txtLossDateFrom").observe("focus", function(){
			var dateFrom = Date.parse($F("txtLossDateFrom"));
			var dateTo = Date.parse($F("txtLossDateTo"));
			
			if(dateFrom > dateTo && dateTo != null && dateFrom != null) {
				showWaitingMessageBox("Claim Date From should not be later than Claim Date To.", "I", function(){
					$("txtLossDateFrom").clear();
				});				
			}
		});
		
		$("txtLossDateTo").observe("focus", function(){
			var dateFrom = Date.parse($F("txtLossDateFrom"));
			var dateTo = Date.parse($F("txtLossDateTo"));
			
			if(dateFrom > dateTo && dateTo != null && dateFrom != null) {
				showWaitingMessageBox("Claim Date From should not be later than Claim Date To.", "I", function(){
					$("txtLossDateTo").clear();
				});				
			}
		});
		
		$("imgLineCdLOV").observe("click", showGipis902LineLOV);
		
		$("txtLineCd").observe("change", function(){
			if($F("txtLineCd") == ""){
				$("txtLineName").value = "";
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
				
				$("txtLineCd").setAttribute("lastValidValue", "");
				$("txtLineName").setAttribute("lastValidValue", "");
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").setAttribute("lastValidValue", "");
			}else{
				showGipis902LineLOV();
			}
		});
		
		$("imgSublineCdLOV").observe("click", showGipis902SublineLOV);
		
		$("txtSublineCd").observe("change", function(){
			if($F("txtSublineCd") == ""){
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").setAttribute("lastValidValue", "");
			}else{
				showGipis902SublineLOV();
			}
		});
		
		$("imgCredBranchLOV").observe("click", showGipis902IssLOV);
		
		$("txtCredBranch").observe("change", function(){
			if($F("txtCredBranch") == ""){
				$("txtIssName").value = "";
				$("txtCredBranch").setAttribute("lastValidValue", "");
				$("txtIssName").setAttribute("lastValidValue", "");
			}else{
				showGipis902IssLOV();
			}
		});
		
		function unescapeHTMLInObject(obj){
			for(var rec in obj){				
				obj[rec] = typeof obj[rec] == "string" ? unescapeHTML2(obj[rec]) : obj[rec]; 
			}			
			return obj;
		}
		
		function setRiskLossProfileFields(obj){
			if(obj != null) {
				selectedRecord = obj;
				obj = unescapeHTMLInObject(obj);
				
				$("txtLineCd").value = obj.lineCd;
				$("txtLineName").value = obj.lineName;
				$("txtSublineCd").value = obj.sublineCd;
				$("txtSublineName").value = obj.sublineName;
				$("txtCredBranch").value = obj.credBranch;
				$("txtIssName").value = obj.issName;
				$("txtDateFrom").value = dateFormat(obj.dateFrom, "mm-dd-yyyy");
				$("txtDateTo").value = dateFormat(obj.dateTo, "mm-dd-yyyy");
				$("txtLossDateFrom").value = dateFormat(obj.lossDateFrom, "mm-dd-yyyy");
				$("txtLossDateTo").value = dateFormat(obj.lossDateTo, "mm-dd-yyyy");				
				
				changeExtractBasedOn(obj.allLineTag);
				
				if(obj.lineCd != "FI" && obj.lineCd != "MC") {
					$("rdoRisk").checked = false;
					$("rdoRisk").disabled = true;
				} else {
					$("rdoRisk").disabled = false;
				}
				
				$("btnAddMain").value = "Update";
				enableButton("btnDeleteMain");
				
				riskLossProfileRangeTableGrid.url = contextPath+"/GIPIRiskLossProfileController?action=getGipiRiskLossProfileRange"
						+ "&lineCd=" + encodeURIComponent($F("txtLineCd"))
						+ "&sublineCd=" + encodeURIComponent($F("txtSublineCd"));
				riskLossProfileRangeTableGrid._refreshList();
				
				enableButton("btnAdd");
				$("txtRangeFrom").readOnly = false;
				$("txtRangeTo").readOnly = false;
				
				disableSearch("imgLineCdLOV");
				disableSearch("imgSublineCdLOV");
				disableSearch("imgCredBranchLOV");
				$("txtLineCd").readOnly = true;
				$("txtSublineCd").readOnly = true;
				$("txtCredBranch").readOnly = true;
				
				setPrintFields(true);
			} else {
				selectedRecord = null;
				$("txtLineCd").clear();
				$("txtLineName").clear();
				$("txtSublineCd").clear();
				$("txtSublineName").clear();
				$("txtCredBranch").clear();
				$("txtIssName").clear();
				$("txtDateFrom").clear();
				$("txtDateTo").clear();
				$("txtLossDateFrom").clear();
				$("txtLossDateTo").clear();
				
				$("txtSublineCd").removeClassName("required");
				$("sublineCdDiv").removeClassName("required");
				$("rdoPolicy").checked = true;
				
				$("btnAddMain").value = "Add";
				disableButton("btnDeleteMain");
				
				riskLossProfileRangeTableGrid.url = contextPath+"/GIPIRiskLossProfileController?action=getGipiRiskLossProfileRange";
				riskLossProfileRangeTableGrid._refreshList();
				
				disableButton("btnAdd");
				$("txtRangeFrom").readOnly = true;
				$("txtRangeTo").readOnly = true;
				
				enableSearch("imgLineCdLOV");
				enableSearch("imgCredBranchLOV");
				$("txtLineCd").readOnly = false;
				$("txtCredBranch").readOnly = false;
				
				setPrintFields(false);
			}
		}
		
		function setRangeFields(obj){
			if (obj != null) {
				$("txtRangeFrom").value = formatCurrency(obj.rangeFrom);
				$("txtRangeTo").value = formatCurrency(obj.rangeTo);
	/* 			$("txtRangeFrom").readOnly = true;
				$("txtRangeTo").readOnly = true;
				disableButton("btnAdd"); */
				enableButton("btnDelete");
				
				if (obj.recordStatus == "0") {
					$("txtRangeFrom").readOnly = false;
					$("txtRangeTo").readOnly = false;
					enableButton("btnAdd");
					$("btnAdd").value = "Update";
				}else{  
					$("txtRangeFrom").readOnly = true;
					$("txtRangeTo").readOnly = true;
					disableButton("btnAdd");
					$("btnAdd").value = "Add";					
				}
				
			} else {
				$("txtRangeFrom").clear();
				$("txtRangeTo").clear();
				disableButton("btnAdd");
				disableButton("btnDelete");
				
				if(selectedIndex != -1){
					$("txtRangeFrom").readOnly = false;
					$("txtRangeTo").readOnly = false;
					enableButton("btnAdd");
				}
			}
		}
		
		function exitPage(){
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
		
		function cancelGipis902(){
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
		
		observeReloadForm("reloadForm", showGIPIS902);
		$("btnExit").observe("click", cancelGipis902);
		
		$("rdoPolicy").observe("click", function(){
			changeExtractBasedOn("Y");
		});
		
		$("rdoSubline").observe("click", function(){
			changeExtractBasedOn("N");
		});
		
		$("rdoPeril").observe("click", function(){
			changeExtractBasedOn("P");
		});
		
		$("rdoRisk").observe("click", function(){
			changeExtractBasedOn("R");
		});
		
		function changeExtractBasedOn(allLineTag){
			if(allLineTag == "Y") {					
				$("rdoPolicy").checked = true;					
				$("txtSublineCd").readOnly = true;
				disableSearch("imgSublineCdLOV");
				$("txtSublineCd").removeClassName("required");
				$("sublineCdDiv").removeClassName("required");					
			} else {
				$("txtSublineCd").readOnly = false;
				enableSearch("imgSublineCdLOV");
				
				if(allLineTag == "N"){
					$("rdoSubline").checked = true;
					$("txtSublineCd").addClassName("required");
					$("sublineCdDiv").addClassName("required");
				} else if (allLineTag == "P"){
					$("rdoPeril").checked = true;
					$("txtSublineCd").removeClassName("required");
					$("sublineCdDiv").removeClassName("required");
				} else if (allLineTag == "R"){
					$("rdoRisk").checked = true;
					$("txtSublineCd").removeClassName("required");
					$("sublineCdDiv").removeClassName("required");
				}					
			}
		}
		
		function getJSONObjects(objArray) {
			var tempObjArray = new Array();
			if(objArray != null){
				for (var i = 0; i<objArray.length; i++){
					if(parseInt(nvl(objArray[i].recordStatus, 0)) != -1){
						
						if(nvl(objArray[i].recordStatus, 0) == 0)
							tempObjArray.push(setRange(objArray[i]));
						else
							tempObjArray.push(objArray[i]);
					}		
				}
			}
			
			return tempObjArray;
		}
		
		function setPrintFields(enabled){
			if(enabled) {
				enableButton("btnPrintReport");
				
				$("rdoByLine").disabled = false;
				$("rdoBySubline").disabled = false;
				$("rdoByPeril").disabled = false;
				$("rdoByRisk").disabled = false;
				
				$("chkAllTreaties").disabled = false;
				$("chkByTariff").disabled = false;
				
				$("chkLossProfileSum").checked = false;
				$("chkLossProfileDtl").checked = false;
				$("chkLossProfileSum").disabled = false;
				$("chkLossProfileDtl").disabled = false;
				$("rdoByLine").checked = true;
				
				if(selectedRecord.allLineTag == "Y" || selectedRecord.allLineTag == "N") {
					$("rdoByLine").disabled = false;
					$("rdoBySubline").disabled = false;
					$("rdoByPeril").disabled = true;
					$("rdoByRisk").disabled = true;
				} else if(selectedRecord.allLineTag == "R") {
					$("rdoByRisk").checked = true;
					$("rdoByLine").disabled = true;
					$("rdoBySubline").disabled = true;
					$("rdoByPeril").disabled = true;
					$("rdoByRisk").disabled = false;
				} else if(selectedRecord.allLineTag == "P") {
					$("rdoByPeril").checked = true;
					$("rdoByLine").disabled = true;
					$("rdoBySubline").disabled = true;
					$("rdoByPeril").disabled = false;
					$("rdoByRisk").disabled = true;
				}
				
				$("selDestination").enable();
				
			} else {
				disableButton("btnPrintReport");
				
				$("chkAllTreaties").checked = false;
				$("chkByTariff").checked = false;
				$("chkLossProfileSum").checked = false;
				$("chkLossProfileDtl").checked = false;
				
				$("chkAllTreaties").disabled = true;
				$("chkByTariff").disabled = true;
				$("chkLossProfileSum").disabled = true;
				$("chkLossProfileDtl").disabled = true;
				
				$("rdoByLine").disabled = true;
				$("rdoBySubline").disabled = true;
				$("rdoByPeril").disabled = true;
				$("rdoByRisk").disabled = true;
				
				$("rdoByLine").checked = false;
				$("rdoBySubline").checked = false;
				$("rdoByPeril").checked = false;
				$("rdoByRisk").checked = false;
				
				
				toggleRequiredFields("screen");
				$("selDestination").selectedIndex = 0;
				$("selDestination").disable();
			}
		}
		
		function getReportId(){			
			if($("chkLossProfileSum").checked){
				
				if($("chkAllTreaties").checked){
					if($("rdoByLine").checked){
						reportId = "GIPIR902A";
						reportTitle = "Risk and Loss Profile - Summary";
					} else if ($("rdoByPeril").checked) {
						reportId = "GIPIR902C";
						reportTitle = "Risk and Loss Profile - Peril";
					} else if ($("rdoByRisk").checked) {
						reportId = "GIPIR902E";
						reportTitle = "Risk and Loss Profile - Per Risk";
					} else {
						reportId = "GIPIR902D";
						reportTitle = "Risk and Loss Profile - Line and Subline";
					}
				} else {
					if($("rdoByLine").checked){
						reportId = "GIPIR902A";
						reportTitle = "Risk and Loss Profile - Summary";
					} else if ($("rdoByPeril").checked) {
						reportId = "GIPIR902C";
						reportTitle = "Risk and Loss Profile - Peril";
					} else if ($("rdoByRisk").checked) {
						if($F("txtLineCd") == "FI"){
							reportId = "GIPIR902E";
							reportTitle = "Risk and Loss Profile - Per Risk";
						} else if ($F("txtLineCd") == "MC") {
							reportId = "GIPIR902F";
							reportTitle = "Risk and Loss Profile - Per Item";
						}
					} else {
						reportId = "GIPIR902D";
						reportTitle = "Risk and Loss Profile - Line and Subline";
					}
				}
				
			}
			
			if($("chkLossProfileDtl").checked) {
				reportId = "GIPIR902B";
				reportTitle = "Risk and Loss Profile - Detailed";
			}
		}
		
		$("chkLossProfileDtl").observe("change", function(){
			if($("chkLossProfileDtl").checked){
				$("chkLossProfileSum").checked = false;
				$("chkByTariff").checked = false;
				$("chkAllTreaties").checked = false;
			}
		});
		
		$("chkLossProfileSum").observe("change", function(){
			if($("chkLossProfileSum").checked){
				$("chkLossProfileDtl").checked = false;
				$("chkByTariff").checked = false;
				$("chkAllTreaties").checked = false;
			}
		});
		
		$("chkByTariff").observe("change", function(){
			if($("chkByTariff").checked){
				$("chkLossProfileSum").checked = false;
				$("chkLossProfileDtl").checked = false;
				$("chkAllTreaties").checked = false;
			}
		});
		
		$("chkAllTreaties").observe("change", function(){
			if($("chkAllTreaties").checked){
				$("chkLossProfileSum").checked = false;
				$("chkLossProfileDtl").checked = false;
				$("chkByTariff").checked = false;
			}
		});
		
		function getReportParameters(){
			var content = "&lineCd=" + $F("txtLineCd")
			+ "&sublineCd=" + $F("txtSublineCd")
			+ "&dateFrom=" + $F("txtDateFrom")
			+ "&dateTo=" + $F("txtDateTo")
			+ "&lossDateFrom=" + $F("txtLossDateFrom")
			+ "&lossDateTo=" + $F("txtLossDateTo")
			+ "&allLineTag=" + selectedRecord.allLineTag;
			
			if($("rdoFileDate").checked)
				content += "&claimDate=Claim File Date";
			else
				content += "&claimDate=Claim Loss Date";
			
			if($("rdoAcctEntDate").checked)
				content += "&paramDate=Accounting Entry Date";
			else if ($("rdoIssueDate").checked)
				content += "&paramDate=Issue Date";
			else if ($("rdoEffectivity").checked)
				content += "&paramDate=Effectivity Date";
			else
				content += "&paramDate=Booking Date";
			
			if($("rdoPdf").checked)
				content += "&fileType=PDF";
			else
				content += "&fileType=XLS";
			
			return content;
		}
		
		function printReport(){
			if(!$("chkLossProfileDtl").checked && !$("chkLossProfileSum").checked && !$("chkByTariff").checked && !$("chkAllTreaties").checked){
				showMessageBox("Please choose a report to print - Summary or Detail.", "I");
			} else if($("chkByTariff").checked){
				showMessageBox("There is no available report yet for the print options you have chosen.", "I");
			} else if($("chkAllTreaties").checked){
				showMessageBox("There is no available report yet for the print options you have chosen.", "I");
			} else {
				getReportId();
				
				var content = contextPath + "/UWProductionReportPrintController?action=print" + reportId
				+ "&txtNoOfCopies=" + $F("txtNoOfCopies")
				+ "&printerName=" + $F("selPrinter")
				+ "&destination=" + $F("selDestination")
				+ "&reportId=" + reportId			
				+ "&reportTitle=" + encodeURIComponent(reportTitle)
				+ getReportParameters();
				
				printGenericReport(content, reportTitle, null);
			}
		}
		
		$("btnPrintReport").observe("click", printReport);
		
		setPrintFields(false);
		initializeGIPIS902();
	} catch (e) {
		showErrorMessage("Risk and Loss Profile", e);
	}
</script>