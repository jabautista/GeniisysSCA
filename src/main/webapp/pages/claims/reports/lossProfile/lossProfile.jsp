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
			<label>Loss Ratio</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div style="float: left;">
		<fieldset style="width: 885px; margin-left: 10px;">
			<legend><b>Parameters</b></legend>
			<div id="parametersTGDiv" class="sectionDiv" style="height: 200px; width: 99.7%; margin-bottom: 5px; border: none;">
			
			</div>
			<table>
				<tr>
					<td class="rightAligned" width="100px">Line</td>
					<td>
						<div id="lineCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
							<input id="txtLineCd" title="Line Code" type="text" maxlength="2" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="21101">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdLOV" name="imgLineCdLOV" alt="Go" style="float: right;" tabindex="21102"/>
						</div>
					</td>
					<td>
						<input type="text" id="txtLineName" style="width: 220px; margin-top: 3x;" tabindex="21103"/>
					</td>
					<td class="rightAligned" width="140px">Subline</td>
					<td>
						<div id="sublineCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
							<input id="txtSublineCd" title="Subline Code" type="text" maxlength="7" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="21104">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCdLOV" name="imgSublineCdLOV" alt="Go" style="float: right;" tabindex="21105"/>
						</div>
					</td>
					<td>
						<input type="text" id="txtSublineName" style="width: 220px; margin-top: 3x;" tabindex="21106"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Policy Date From</td>
					<td colspan="2">
						<div id="polDateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;">
							<input type="text" id="txtPolDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtPolDateFrom" readonly="readonly" tabindex="21107"/>
							<img id="imgPolDateFrom" alt="imgPolDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21108"/>
						</div>
						<label style="margin-left: 61px; margin-top: 6px; float: left;">To</label>
						<div id="polDateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;">
							<input type="text" id="txtPolDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtPolDateTo" readonly="readonly" tabindex="21109"/>
							<img id="imgPolDateTo" alt="imgPolDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21110"/>
						</div>
					</td>
					<td class="rightAligned">Claim Date From</td>
					<td colspan="2">
						<div id="clmDateFromDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;">
							<input type="text" id="txtClmDateFrom" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtClmDateFrom" readonly="readonly" tabindex="21111"/>
							<img id="imgClmDateFrom" alt="imgClmDateFrom" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21112"/>
						</div>
						<label style="margin-left: 61px; margin-top: 6px; float: left;">To</label>
						<div id="clmDateToDiv" style="float: left; border: solid 1px gray; width: 110px; height: 20px; margin-left: 5px; margin-top: 2px;">
							<input type="text" id="txtClmDateTo" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 82px; border: none;" name="txtClmDateTo" readonly="readonly" tabindex="21113"/>
							<img id="imgClmDateTo" alt="imgClmDateTo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="21114"/>
						</div>
					</td>
				</tr>
			</table>
			<div class="sectionDiv" style="height: 50px; width: 426px; margin-left: 7px; margin-top: 10px;">
				<table style="margin-top: 2px; margin-left: 50px;">
					<tr>
						<td width="200px"><input type="radio" id="rdoAcctEntDate" value="AD" name="paramDate" style="float: left;" tabindex="21115" checked="checked" /><label for="rdoAcctEntDate" style="margin-top: 3px;">Accounting Entry Date</label></td>
						<td><input type="radio" id="rdoIssueDate" value="ID" name="paramDate" style="float: left;" tabindex="21117" /><label for="rdoIssueDate" style="margin-top: 3px;">Issue Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoEffectivity" value="ED" name="paramDate" style="float: left;" tabindex="21116" /><label for="rdoEffectivity" style="margin-top: 3px;">Effectivity Date</label></td>
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
		</fieldset>
		<fieldset style="height: 40px; width: 427px; margin-left: 10px; float: left;">
			<legend><b>Extract based on</b></legend>
			<div style="float: left; margin-top: 5px; margin-left: 61px;">
				<input type="radio" id="rdoTsi" name="extractByRg" style="float: left;" checked="checked" tabindex="21121" /><label for="rdoTsi" style="margin-top: 3px;">Total Sum Insured</label>
				<input type="radio" id="rdoLoss" name="extractByRg" style="float: left; margin-left: 82px;" tabindex="21122" /><label for="rdoLoss" style="margin-top: 3px;">Loss Amount</label>
			</div>
		</fieldset>
		<fieldset style="height: 40px; width: 431px; margin-left: 7px; float: left;">
			<legend><b>Extract Type</b></legend>
			<div style="float: left; margin-top: 5px; margin-left: 61px;">
				<input type="radio" id="rdoPolicy" name="eType" style="float: left;" checked="checked" value="1" tabindex="21123" /><label for="rdoPolicy" style="margin-top: 3px;">Policy</label>
				<input type="radio" id="rdoRisk" name="eType" style="float: left; margin-left: 70px;" value="2" tabindex="21124" /><label for="rdoRisk" style="margin-top: 3px;">Risk / Item</label>
				<input type="radio" id="rdoPeril" name="eType" style="float: left; margin-left: 70px;" value="3" tabindex="21125" /><label for="rdoPeril" style="margin-top: 3px;">Peril</label>
			</div>
		</fieldset>
		<fieldset style="height: 260px; width: 431px; margin-left: 7px; float: left;">
			<legend><b>Range</b></legend>
			<div id="rangeTGDiv" class="sectionDiv" style="height: 180px; width: 99%; border: none;">
			
			</div>
			<div style="margin-top: 8px; float: left;">
				<label style="margin-left: 23px; margin-top: 6px;">From</label><input type="text" id="txtFrom" style="width: 140px; margin-left: 5px; float: left; text-align: right;" />
				<label style="margin-left: 33px; margin-top: 6px;">To</label><input type="text" id="txtTo" style="width: 140px; margin-left: 5px; float: left; text-align: right;" />
				<div style="margin-top: 8px; float: left;">
					<input type="button" id="btnAdd" class="button" value="Add" style="margin-left: 150px;"/>
					<input type="button" id="btnDelete" class="button" value="Delete" />
				</div>
			</div>
		</fieldset>
		<fieldset style="height: 260px; width: 431px; margin-left: 6px; float: left;">
			<legend><b>Report/s</b></legend>
			<div id="printDiv" style="margin-top: 5px; margin-left: 65px; border: none; height: 130px; width: 300px; float: left;">
				<table align="center" style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="305">
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
							<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
						<td height="28px"><input type="checkbox" id="chkLossProfileSum" style="float: left; margin-left: 4px;" /><label for="chkLossProfileSum">Summary</label></td>
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
		<input type="button" id="btnViewLossRatioDtls" class="button" value="View Loss Ratio Details" style="width: 160px;"/>
	</div>
	<div>
		<input type="hidden" id="hidCurExist" />
	</div>
</div>
<div id="lossProfileDetailsDiv">
	<jsp:include page="/pages/claims/reports/lossProfile/lossProfileDetails/lossProfileDetails.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
try{
	initializeAll();
	initializeAccordion();
	setModuleId("GICLS211");
	setDocumentTitle("Loss Profile");
	objCC = new Object(); //cg$ctrl
	objRP = new Object(); //risk_profile1
	objVar = new Object(); //variables
	
	var changeTag = 0;
	objRP.changeTag = 0;
	objVar.vExt = "N";
	objVar.vRiskSw = "N";
	
	function whenNewFormInstance(){
		new Ajax.Request(contextPath+"/GICLLossProfileController?action=whenNewFormInstance",{
			onComplete : function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText == "Y"){
						$("hidCurExist").value = "Y";
						$("rdoByLine").checked = true;
					}
				}
			}
		});
	}
	
	whenNewFormInstance();
	
	try{
		var objLPParam = new Object();
		objLPParam.objLossProfileParamTableGrid = JSON.parse('${jsonLossProfileParam}');
		objLPParam.objLossProfileParam = objLPParam.objLossProfileParamTableGrid.rows || []; 
		
		var lossProfileParamModel = {
			url:contextPath+"/GICLLossProfileController?action=showGICLS211&refresh=1&moduleId=GICLS211",
			options:{
				id: 1,
				width: '884px',
				height: '177px',
				onCellFocus: function(element, value, x, y, id){
					var obj = lossProfileParamTableGrid.geniisysRows[y];
					populateProfileParam(obj);
					
					objRP.lineCd = lossProfileParamTableGrid.geniisysRows[y].lineCd;
					objRP.sublineCd = nvl(lossProfileParamTableGrid.geniisysRows[y].sublineCd, "");
					objRP.dspLineName =  lossProfileParamTableGrid.geniisysRows[y].dspLineName;
					objRP.dspSublineName =  lossProfileParamTableGrid.geniisysRows[y].dspSublineName;
					objRP.statusSw = "Y";
					objRP.selectedIndex = y;
					
					whenNewRecordRiskProfile();
					enableDisablePrint();
					queryRange(objRP.lineCd, objRP.sublineCd);
					
					lossProfileParamTableGrid.keys.removeFocus(lossProfileParamTableGrid.keys._nCurrentFocus, true);
					lossProfileParamTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					if(objRP.changeTag == 1){
						showMessageBox("Please save changes first in Range portion.", "I");
						$('mtgRow'+lossProfileParamTableGrid._mtgId+'_'+objRP.selectedIndex).addClassName('selectedRow');
						return false;
					}else{
						populateProfileParam(null);
						queryRange();	
					}
					
					lossProfileParamTableGrid.keys.removeFocus(lossProfileParamTableGrid.keys._nCurrentFocus, true);
					lossProfileParamTableGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					if(objRP.changeTag == 1){
						showMessageBox("Please save changes first in Range portion.", "I");
						$('mtgRow'+lossProfileParamTableGrid._mtgId+'_'+objRP.selectedIndex).addClassName('selectedRow');
						return false;
					}
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
			if(lossProfileParamTableGrid.geniisysRows[0].curExist == "N"){
				showMessageBox("Specified line does not exist in the maintenance table.", "E");
			}
			enableOrDisablePrint();
			/* if(lossProfileParamTableGrid.geniisysRows.length > 0){			
				$('mtgRow'+lossProfileParamTableGrid._mtgId+'_0').addClassName('selectedRow');
				var obj = lossProfileParamTableGrid.geniisysRows[0];
				populateProfileParam(obj);
				objRP.lineCd = lossProfileParamTableGrid.geniisysRows[0].lineCd;
				objRP.sublineCd = nvl(lossProfileParamTableGrid.geniisysRows[0].sublineCd, "");
			} */
		};
	}catch(e){
		showErrorMessage("parameters tablegrid",e);
	}
	
	function populateProfileParam(obj){
		$("txtLineCd").value = obj == null ? "" : obj.lineCd;
		$("txtLineName").value = obj == null ? "" : obj.dspLineName;
		$("txtSublineCd").value = obj == null ? "" : obj.sublineCd;
		$("txtSublineName").value = obj == null ? "" : obj.dspSublineName;
		$("txtPolDateFrom").value = obj == null ? "" : obj.dateFrom;
		$("txtPolDateTo").value = obj == null ? "" : obj.dateTo;
		$("txtClmDateFrom").value = obj == null ? "" : obj.lossDateFrom;
		$("txtClmDateTo").value = obj == null ? "" : obj.lossDateTo;
	}
	
	try{
		var objLPRange = new Object();
		objLPRange.objLossProfileRangeTableGrid = JSON.parse('${jsonRangeList}');
		objLPRange.objLossProfileRange = objLPRange.objLossProfileRangeTableGrid.rows || []; 
		
		var lossProfileRangeModel = {
			url:contextPath+"/GICLLossProfileController?action=showRange&refresh=1&lineCd="+objRP.lineCd+"&sublineCd="+objRP.sublineCd,
			options:{
				id: 2,
				width: '430px',
				height: '157px',
				onCellFocus: function(element, value, x, y, id){
					objLPRange.selectedIndex = y;
					populateRangeFields(lossProfileRangeTableGrid.geniisysRows[y]);
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					
					lossProfileRangeTableGrid.keys.removeFocus(lossProfileRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileRangeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					$("btnAdd").value = "Add";
					disableButton("btnDelete");
					
					populateRangeFields(null);
					lossProfileRangeTableGrid.keys.removeFocus(lossProfileRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileRangeTableGrid.keys.releaseKeys();
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
					geniisysClass: 'money',
					sortable: false,
					visible: true
				},
				{	id: 'rangeTo',
					title: 'To',
					width: '195px',
					align: 'right',
					geniisysClass: 'money',
					sortable: false,
					visible: true
				},
			],
			rows: objLPRange.objLossProfileRange
		};
		lossProfileRangeTableGrid = new MyTableGrid(lossProfileRangeModel);
		lossProfileRangeTableGrid.pager = objLPRange.objLossProfileRangeTableGrid;
		lossProfileRangeTableGrid._mtgId = 2;
		lossProfileRangeTableGrid.render('rangeTGDiv');
		lossProfileRangeTableGrid.afterRender = function(){
			
		};
	}catch(e){
		showErrorMessage("range tablegrid",e);
	}
	
	function populateRangeFields(obj){
		$("txtFrom").value = obj == null ? "" : formatCurrency(obj.rangeFrom);
		$("txtTo").value = obj == null ? "" : formatCurrency(obj.rangeTo);
	}
	
	function queryRange(lineCd, sublineCd){
		try{
			lossProfileRangeTableGrid.url = contextPath+"/GICLLossProfileController?action=showRange&refresh=1&lineCd="+lineCd+"&sublineCd="+sublineCd;
			lossProfileRangeTableGrid._refreshList();
		}catch(e){
			showErrorMessage("queryRange", e);
		}
	}
	
	var prevTxtFrom;
	var lastEdit;
	$("txtFrom").observe("focus", function(){
		prevTxtFrom = $F("txtFrom");
		lastEdit = "txtFrom";
	});
	$("txtFrom").observe("change", function(){
		if(isNaN($F("txtFrom"))){
			customShowMessageBox("Invalid Range From. Valid value should be from 1 to 99,999,999,999,999.99.", "I", "txtFrom");
			$("txtFrom").value = prevTxtFrom;
		}else{
			if($F("txtTo") != ""){
				if(unformatCurrencyValue($F("txtFrom")) > unformatCurrencyValue($F("txtTo"))){
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
	
	var prevTxtTo;
	$("txtTo").observe("focus", function(){
		prevTxtTo = $F("txtTo");
		lastEdit = "txtTo";
	});
	$("txtTo").observe("change", function(){
		if(isNaN($F("txtTo"))){
			customShowMessageBox("Invalid Range To. Valid value should be from 1 to 99,999,999,999,999.99.", "I", "txtTo");
			$("txtTo").value = prevTxtTo;
		}else{
			if($F("txtFrom") != ""){
				if(unformatCurrencyValue($F("txtFrom")) > unformatCurrencyValue($F("txtTo"))){
					customShowMessageBox("Ending Sum Insured Range must be greater than Starting Sum Insured Range.", "E", "txtTo");
					$("txtTo").clear();
					return false;
				}	
			}
			$("txtTo").value = formatCurrency($F("txtTo"));
		}
	});
	
	$("btnAdd").observe("click", function(){
		if($F("txtFrom") == ""){
			customShowMessageBox("From Range is required.", "I", "txtFrom");
			return false;
		}
		if($F("txtTo") == ""){
			customShowMessageBox("To Range is required.", "I", "txtTo");
			return false;
		}
		if(objLPRange.objLossProfileRange.length > 0){
			for(var i = 0; i < objLPRange.objLossProfileRange.length; i++){
				if(objLPRange.objLossProfileRange[i].recordStatus != -1){
					if((objLPRange.objLossProfileRange[i].rangeFrom <= unformatCurrencyValue($F("txtFrom"))) && (objLPRange.objLossProfileRange[i].rangeTo >= unformatCurrencyValue($F("txtFrom")))){
						if(objLPRange.selectedIndex != i){
							customShowMessageBox("Sum Insured Range must not be within the existing range.", "E", "txtFrom");
							if($("btnAdd").value == "Update"){
								$(lastEdit).clear();	
							}else{
								$("txtFrom").clear();						
							}
							return false;	
						}
					}
				}
			}
			for(var i = 0; i < objLPRange.objLossProfileRange.length; i++){
				if((objLPRange.objLossProfileRange[i].rangeFrom <= unformatCurrencyValue($F("txtTo"))) && (objLPRange.objLossProfileRange[i].rangeTo >= unformatCurrencyValue($F("txtTo")))){
					if(objLPRange.selectedIndex != i){
						customShowMessageBox("Sum Insured Range must not be within the existing range.", "E", "txtTo");
						if($("btnAdd").value == "Update"){
							$(lastEdit).clear();	
						}else{
							$("txtTo").clear();						
						}
						return false;
					}
				}
			}
		}
		var rowObj = getRangeDtls($("btnAdd").value);
		if($("btnAdd").value == "Add"){
			objLPRange.objLossProfileRange.push(rowObj);
			lossProfileRangeTableGrid.addBottomRow(rowObj);
		}else{
			objLPRange.objLossProfileRange.splice(objLPRange.selectedIndex, 1, rowObj);
			lossProfileRangeTableGrid.updateVisibleRowOnly(rowObj, objLPRange.selectedIndex);
		}
		$("btnAdd").value = "Add";
		$("txtFrom").clear();
		$("txtTo").clear();
		objLPRange.selectedIndex = null;
		changeTag = 1;
		objRP.changeTag = 1;
	});
	
	$("btnDelete").observe("click", function(){
		var rowObj = getRangeDtls("Delete");
		objLPRange.objLossProfileRange.splice(objLPRange.selectedIndex, 1, rowObj);
		lossProfileRangeTableGrid.deleteVisibleRowOnly(objLPRange.selectedIndex);
		lossProfileRangeTableGrid.onRemoveRowFocus();
		changeTag = 1;
		objRP.changeTag = 1;
	});
	
	function getRangeDtls(func){
		var obj = new Object();
		obj.rangeFrom = unformatCurrencyValue($F("txtFrom"));
		obj.rangeTo = unformatCurrencyValue($F("txtTo"));
		obj.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return obj;
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
			enableButton("btnPrintReport");
			enableButton("btnViewLossRatioDtls");
			$("chkAllTreaties").disabled = false;
			$("chkLossProfileSum").disabled = false;
			$("chkLossProfileDtl").disabled = false;
			$("rdoByLine").checked = true;
			
			toggleEType();
		}else{
			disableButton("btnPrintReport");
			disableButton("btnViewLossRatioDtls");
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
			enableButton("btnViewLossRatioDtls");
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
			disableButton("btnViewLossRatioDtls");
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
					action : "getGicls204LineLOV",
					moduleId : "GICLS211",
					issCd : ""
				},
				title : "Lines",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
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
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
				}
			});
		} catch (e) {
			showErrorMessage("showGicls211LineLOV", e);
		}
	}
	
	$("imgLineCdLOV").observe("click", showGicls211LineLOV);
	
	function showGicls211SublineLOV(){
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls211SublineLOV",
					moduleId : "GICLS211",
					lineCd : $F("txtLineCd")
				},
				title : "Sublines",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
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
				draggable : true,
				onSelect : function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
				}
			});
		} catch (e) {
			showErrorMessage("showGicls211SublineLOV", e);
		}
	}
	
	$("imgSublineCdLOV").observe("click", showGicls211SublineLOV);
	
	
	
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineName").clear();
		}
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();; 	
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $("txtSublineCd").value.toUpperCase();; 	
	});
	
	function validateLineCdGicls211(){
		if($F("txtLineCd") != ""){
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateLineCdGicls202",{
				parameters: {
					lineCd : $F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtLineCd").clear();
						$("txtLineName").clear();
						$("txtLineCd").focus();
						showGicls211LineLOV();
					}else{
						$("txtLineName").value = response.responseText;
					}
				}
			});
		}else{
			$("txtLineName").clear();
		}
	}
	
	$("txtLineCd").observe("change", validateLineCdGicls211);
	
	function doKeyUp(id){
		$(id).observe("keyup", function(){
			$(id).value = $(id).value.toUpperCase();
		});
	}
	
	doKeyUp("txtSublineCd");
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineName").clear();
		}else{
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateSublineCdGicls202",{
				parameters: {
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtSublineCd").clear();
						$("txtSublineName").clear();
						$("txtSublineCd").focus();
						showGicls211SublineLOV();
					}else{
						$("txtSublineName").value = response.responseText;
					}
				}
			});	
		}
	});

	$("imgPolDateFrom").observe("click", function(){
		scwShow($("txtPolDateFrom"),this, null);
	});
	
	$("imgPolDateTo").observe("click", function(){
		scwShow($("txtPolDateTo"),this, null);
	});
	
	$("imgClmDateFrom").observe("click", function(){
		scwShow($("txtClmDateFrom"),this, null);
	});
	
	$("imgClmDateTo").observe("click", function(){
		scwShow($("txtClmDateTo"),this, null);
	});
	
	$("txtPolDateFrom").observe("focus", function(){
		if(!$F("txtPolDateTo") == "" && !$F("txtPolDateFrom") == ""){
			if($F("txtPolDateTo") < $F("txtPolDateFrom")){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtPolDateFrom");
				$("txtPolDateFrom").clear();
			}
		}
	});
	
	$("txtPolDateFrom").observe("blur", function(){
		if($F("txtClmDateFrom") == ""){
			$("txtClmDateFrom").value = $F("txtPolDateFrom");
		}
	});
	
	$("txtPolDateTo").observe("focus", function(){
		if(!$F("txtPolDateFrom") == "" && !$F("txtPolDateTo") == ""){
			if($F("txtPolDateTo") < $F("txtPolDateFrom")){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtPolDateTo");
				$("txtPolDateTo").clear();
			}	
		}
	});
	
	$("txtPolDateTo").observe("blur", function(){
		if($F("txtClmDateTo") == ""){
			$("txtClmDateTo").value = $F("txtPolDateTo");
		}
	});
	
	$("txtClmDateFrom").observe("focus", function(){
		if(!$F("txtClmDateTo") == "" && !$F("txtClmDateFrom") == ""){
			if($F("txtClmDateTo") < $F("txtClmDateFrom")){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtClmDateFrom");
				$("txtClmDateFrom").clear();
			}
		}
	});
	
	$("txtClmDateTo").observe("focus", function(){
		if(!$F("txtClmDateFrom") == "" && !$F("txtClmDateTo") == ""){
			if($F("txtClmDateTo") < $F("txtClmDateFrom")){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtClmDateTo");
				$("txtClmDateTo").clear();
			}	
		}
	});
	
	$("btnSave").observe("click", function(){
		validateSaveProfile();
	});
	
	function validateSaveProfile(){
		if(changeTag == 1){
			if($F("txtPolDateFrom") == "" || $F("txtClmDateFrom") == ""){
				customShowMessageBox("Duration from must be entered.", "E", "txtPolDateFrom");
			}
			if($F("txtPolDateTo") == "" || $F("txtClmDateTo") == ""){
				customShowMessageBox("Duration must be entered.", "E", "txtPolDateTo");
			}
			/* if($F("txtFrom") == "" && $F("txtTo") != ""){
				customShowMessageBox("Range from must be entered.", "E", "txtFrom");
			}
			if($F("txtTo") == "" && $F("txtFrom") != ""){
				customShowMessageBox("Range to must be entered.", "E", "txtTo");
			}
			if($F("txtFrom") == "" && $F("txtTo") == ""){
				customShowMessageBox("Range for date must be entered.", "E", "txtFrom");
			} */
			if(($F("txtLineName") != "") && ($F("txtSublineName") != "")){
				saveProfile("line_subline");	
			}else if(($F("txtLineName") != "") && ($F("txtSublineName") == "")){
				showConfirmBox4("", "Save by line or by line and subline?", "By Line", "Line and Subline", "Cancel", 
								function(){
									saveProfile("line");
								}, 
								function(){
									saveProfile("lineAndSubline");
								}, "", "");
			}else if(($F("txtLineName") == "") && ($F("txtSublineName") == "")){
				showConfirmBox4("", "Save by line or by line and subline?", "By Line", "Line and Subline", "Cancel", 
						function(){
							showConfirmBox("", "Saving without specified line will update all records. Do you want to continue?", "Cancel", "Ok", "",
									function(){
										saveProfile("allByLine");
									}, "");
						}, 
						function(){
							showConfirmBox("", "Saving without specified line will update all records. Do you want to continue?", "Cancel", "Ok", "",
									function(){
										saveProfile("all_line_subline");
									}, "");
						}, "", "");
			}
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	}
	
	function saveProfile(type){
		try{
			objParameters = new Object();
			objParameters.setRange = getAddedAndModifiedJSONObjects(objLPRange.objLossProfileRange);
			objParameters.delRange = getDeletedJSONObjects(objLPRange.objLossProfileRange);
			
			objParameters.dspLineName = $F("txtLineName");
			objParameters.dspSublineName = $F("txtSublineName");
			objParameters.dateFrom = $F("txtPolDateFrom");
			objParameters.dateTo = $F("txtPolDateTo");
			objParameters.lossDateFrom = $F("txtClmDateFrom");
			objParameters.lossDateTo = $F("txtClmDateTo");
			objParameters.type = type;

			var strObjParameters = JSON.stringify(objParameters);

			new Ajax.Request(contextPath+"/GICLLossProfileController?action=saveProfile",{
				parameters: {
					parameters : strObjParameters
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Saving.. Please wait.."),
				onComplete: function(response){
					hideNotice("");
					showMessageBox("Record is saved. Please choose type of Policy date and Claim date for extraction.", "I");
					lossProfileParamTableGrid._refreshList();
					objVar.vExt = "N";
					enableOrDisablePrint();
					enableButton("btnExtract");
					changeTag = 0;
					objRP.changeTag = 0;
				}
			});
		}catch(e){
			showErrorMessage("saveInvoiceCommission", e);
		}
	}
	
	$("btnExtract").observe("click", function(){
		if(($F("txtPolDateFrom") == "") || ($F("txtPolDateTo") == "") || ($F("txtClmDateFrom") == "") || ($F("txtClmDateTo") == "")){
			showMessageBox("Please check if fields are completed and that Policy and Claim types have been chosen.", "I");
			return false;
		}
		if(changeTag == 1){
			showMessageBox("Please save changes first before extracting.", "I");
			return false;
		}
		extractLossProfile();
	});
	
	function extractLossProfile(){
		try{
			new Ajax.Request(contextPath+"/GICLLossProfileController?action=extractLossProfile",{
				parameters: {
					paramDate : getParamDate(),
					claimDate : $("rdoFileDate").checked == true ? "FD" : "LD",
					lineCd : nvl(objRP.lineCd, $F("txtLineCd")),
					sublineCd : nvl(objRP.sublineCd, $F("txtSublineCd")),
					dateFrom : $F("txtPolDateFrom"),
					dateTo : $F("txtPolDateTo"),
					lossDateFrom : $F("txtClmDateFrom"),
					lossDateTo : $F("txtClmDateTo"),
					extractByRg : $("rdoTsi").checked == true ? 1 : 2,
					eType : getEType()
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Extracting.. Please wait.."),
				onComplete: function(response){
					hideNotice("");
					var res = JSON.parse(response.responseText);
					showMessageBox(res.message);
					objVar.vExt = res.varExt;
					enableOrDisablePrint();
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
	
	$("btnPrintReport").observe("click", function(){
		validatePrint();
	});
	
	function validatePrint(){
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
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	var reports = [];
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
					
					}
				}
			});
		}else if($F("selDestination") == "file"){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
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
	
	$("btnViewLossRatioDtls").observe("click", function(){
		$("lossProfileMainDiv").hide();
		$("lossProfileDetailsDiv").show();
		
		$("txtDtlLineCd").value = $F("txtLineCd");
		$("txtDtlLineName").value = $F("txtLineName");
		$("txtDtlSublineCd").value = $F("txtSublineCd");
		$("txtDtlSublineName").value = $F("txtSublineName");
		
		fireEvent($("lossProfileSummaryTab"), "click");
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	});
	
	disableButton("btnDelete");
	observeReloadForm("reloadForm", showGICLS211);
	
	//For Print
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
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
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
	
	toggleRequiredFields("screen");
	
	$("lossProfileDetailsDiv").hide();
}catch(e){
	showErrorMessage("lossProfile page",e);
}
</script>