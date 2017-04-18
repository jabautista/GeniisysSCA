<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="riskProfileMainDiv">
	<div class="" style="float: left; width: 920px; height: 654px;" align="center">
	
		<div id="riskProfileMasterTGDiv" style="height: 205px; margin: 10px 10px 5px 10px; "></div>
		
		<div style="margin: 20px 0 1px 40px; width: 420px; height: 250px; float: left;">
			<div id="riskFieldsDiv">
				<fieldset style="height: 145px; width: 400px; margin-bottom: 2px;">
					<legend>Parameters</legend>
					<table align="center" style="margin-top: 10px;">					
						<tr>
							<td class="rightAligned">Line</td>
							<td>
								<input id="hidLineCd" type="hidden">
								<div id="lineDiv" style="border: 1px solid gray; width: 300px; height: 20px; float: left; margin-right: 7px;">
									<input id="txtLine" name="txtLine" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" value="" tabindex="101"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Subline</td>
							<td>
								<input id="hidSublineCd" type="hidden">
								<div id="sublineDiv" style="border: 1px solid gray; width: 300px; height: 20px; float: left; margin-right: 7px;">
									<input id="txtSubline" name="txtSubline" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" value="" tabindex="102"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSubline" name="searchSubline" alt="Go" style="float: right;"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Cred. Branch</td>
							<td>
								<input id="hidIssCd" type="hidden">
								<div id="branchDiv" style="border: 1px solid gray; width: 300px; height: 20px; float: left; margin-right: 7px;">
									<input id="txtIssName" name="txtIssName" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" value="" tabindex="103"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIss" name="searchIss" alt="Go" style="float: right;"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">From</td>									
							<td>
								<div id="fromDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 125px; height: 20px;">
									<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 100px; height: 13px; margin: 0px;" value="" tabindex="104"/>
									<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onclick="scwShow($('txtFromDate'),this, null);"/>
								</div>
								<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 28px;">To</label>
								<div id="toDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 125px; height: 20px;">
									<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 100px; height: 13px; margin: 0px;" value="" tabindex="105"/>
									<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onclick="scwShow($('txtToDate'),this, null);"/>
								</div>
							</td>
						</tr>
					</table>	
				</fieldset>
			</div>
			
			<div class="sectionDiv" style="width: 418px; height: 85px;">
				<table style="margin: 15px 0 0 15px;">
					<tr>
						<td>
							<input id="chkInclEndt" type="checkbox" style="float: left; " tabindex="201"><label for="chkInclEndt" style="margin: 2px 0 4px 0">Include endorsement/s beyond the given period</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkInclExp" type="checkbox" style="float: left; margin-top: 5px;" tabindex="202"><label for="chkInclExp" style="margin: 7px 0 4px 0">Include expired record/s</label>	<!-- Gzelle 04152015 SR4136,4196,4285,4271 -->
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<fieldset style="float: right; margin: 20px 40px 1px 0; width: 400px; height: 234px;">
			<legend>Range of Sum Insured</legend>
			
			<div id="riskProfileDetailTGDiv" style="width: 400px; height: 150px;"></div>	<!-- Gzelle 03252015 -->
			
			<div id="riskRangeDiv" style="width: 400px; height: 75px;">
				<table>
					<tr>
						<td>From</td>
						<td><input id="txtRangeFrom" class="money" type="text" min="-99999999999999.99" max="99999999999999.99" style="width: 140px;" tabindex="106" errorMsg="Invalid Range From. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99."></td>
						<td style="padding-left: 20px;">To</td>
						<td><input id="txtRangeTo"  class="money" type="text"  min="-99999999999999.99" max="99999999999999.99" style="width: 140px;" tabindex="107" errorMsg="Invalid Range To. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99."></td>
					</tr>
				</table>
				
				<div class="buttonsDiv">
					<input id="btnAddRange" type="button" class="button" value="Add" style="width: 85px;" tabindex="108">
					<input id="btnDeleteRange" type="button" class="button" value="Delete" style="width: 85px;" tabindex="109">
				</div>
			</div>
		</fieldset>
		
		<div id="paramDateDiv" class="sectionDiv" style="margin: 1px 0 1px 40px; width: 418px; height: 80px; float: left;">
			<table style="margin-top: 15px;" align="center">
				<tr>
					<td>
						<input value="AD" title="Acctg Entry Date" type="radio" id="acctEntDateRB" name="paramDateRG" style="margin: 2px 5px 4px 5px; float: left;" tabindex="401"><label for="acctEntDateRB" style="margin: 2px 0 4px 0">Accounting Entry Date</label>	<!-- Gzelle 04152015 SR4136,4196,4285,4271 -->
					</td>
					<td>
						<input value="ED" title="Effectivity Date" type="radio" id="effDateRB" name="paramDateRG" style="margin: 2px 5px 4px 25px; float: left;" checked="checked" tabindex="402"><label for="effDateRB" style="margin: 2px 0 4px 0">Effectivity Date</label> <!-- Gzelle 04152015 SR4136,4196,4285,4271 -->
					</td>
				</tr>
				<tr>
					<td>
						<input value="ID" title="Issue Date" type="radio" id="issueDateRB" name="paramDateRG" style="margin: 2px 5px 4px 5px; float: left;"  tabindex="403"><label for="issueDateRB" style="margin: 2px 0 4px 0">Issue Date</label>									
					</td>
					<td>
						<input value="BD" title="Booking Date" type="radio" id="bookingDateRB" name="paramDateRG" style="margin: 2px 5px 4px 25px; float: left;" tabindex="404"><label for="bookingDateRB" style="margin: 2px 0 4px 0" >Booking Date</label>									
					</td>
				</tr>
			</table>
		</div>
		
		<div id="allLineTagDiv" class="sectionDiv" style="margin: 1px 0 1px 1px; width: 418px; height: 80px; float: left;">
			<table style="margin-top: 15px;" align="center">
				<tr>
					<td>
						<input value="Y" title="By Line" type="radio" id="lineRB" name="allLineTagRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" tabindex="501"><label for="lineRB" style="margin: 2px 0 4px 0">By Line</label>									
					</td>
					<td>
						<input value="N" title="By Line and Subline" type="radio" id="sublineRB" name="allLineTagRG" style="margin: 2px 5px 4px 40px; float: left;" tabindex="502"><label for="sublineRB" style="margin: 2px 0 4px 0">By Line and Subline</label>									
					</td>
				</tr>
				<tr>
					<td>
						<input value="P" title="By Peril" type="radio" id="perilRB" name="allLineTagRG" style="margin: 2px 5px 4px 5px; float: left;" tabindex="503" ><label for="perilRB" style="margin: 2px 0 4px 0">By Peril</label>									
					</td>
					<td>
						<input value="R" title="Per Risk" type="radio" id="riskRB" name="allLineTagRG" style="margin: 2px 5px 4px 40px; float: left;" tabindex="504"><label for="riskRB" style="margin: 2px 0 4px 0">Per Risk</label>									
					</td>
				</tr>
			</table>
		</div>
		
		<div class="buttonsDiv" style="margin-top: 10px;">
			<input id="btnAddRisk" type="button" class="button" value="Add" style="width: 120px;" tabindex="601">
			<input id="btnDeleteRisk" type="button" class="button" value="Delete" style="width: 120px;" tabindex="602">
		</div>
		
		<div class="sectionDiv">
			<div id="repLayoutDiv" class="sectionDiv" style="margin: 10px 0 5px 40px; width: 250px; height: 150px;">
				<table style="margin: 20px 0 0 35px; float: left;">
					<tr>
						<td>Report Layout:</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkTreaties" style="margin: 12px 5px 4px 30px; float: left;" tabindex="701"><label for="chkTreaties" style="margin: 12px 0 4px 3px">All Treaties</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkDetails"  style="margin: 2px 5px 4px 30px; float: left;" tabindex="702"><label for="chkDetails" style="margin: 2px 0 4px 3px" >Details</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkTariff"  style="margin: 2px 5px 4px 30px; float: left;" tabindex="703" ><label for="chkTariff" style="margin: 2px 0 4px 3px" >By Tariff</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" id="printDialogFormDiv" style="margin: 10px 0 5px 1px; padding-top: 5px; width: 585px; height: 145px;" align="center">
				<table style="float: left; margin: 15px 0 0 120px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="704">
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
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="705">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" hidden="true"><label for="excelRB" style="margin: 2px 0 4px 0" tabindex="706" hidden="true">Excel</label><!-- benjo 05.22.2015 added hidden -->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0" tabindex="706">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="707">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="708">
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
			
			<div class="buttonsDiv">
				<input id="btnSave" type="button" class="button" value="Save" style="width: 120px;" tabindex="709">
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 120px;" tabindex="710">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 120px;" tabindex="711">
			</div>
		</div>
	</div>
				
</div>

<script type="text/javascript">
try{
	
	function unformatCurrency(paramField) {
		var unformattedValue = "";
		if ($(paramField).value.replace(/,/g, "") != ""
				&& !isNaN(parseFloat($(paramField).value.replace(/,/g, "")))) {
			unformattedValue = parseFloat($(paramField).value.replace(/,/g, ""));
		}
		return unformattedValue;
	}
	
	initializeAll();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	
	changeTag = 0;
	objGIPIS901.changeTagDetail = 0;
	objGIPIS901.lineCdFi = '${lineCdFi}';
	objGIPIS901.lineCdMc = '${lineCdMc}';
	
	$("txtSubline").readOnly = true;
	disableSearch("searchSubline");
	
	//disableButton("btnExtract");	Gzelle 04152015 SR4136,4196,4285,4271
	
	disableButton("btnDeleteRisk");
	disableButton("btnAddRange");
	disableButton("btnDeleteRange");
	
	objGIPIS901.addFromUpdate = false;	//start - Gzelle 04072015
	objGIPIS901.dupRecord = false;
	curLineCd = null;
	curSublineCd = null;				
	btnVal = null;						//start Gzelle 04152015 SR4136,4196,4285,4271
	menuLineCd = null;					
	
	disableInputField("txtRangeFrom");
	disableInputField("txtRangeTo");	//end Gzelle 04152015 SR4136,4196,4285,4271
	
	var prevNxtLineTag = null;
	var updateSw = null;
	var origValues = [];
	var paramDateRB = "AD";
	var allLineTagRB = "Y";
	var extractDetails = "N";
	var printDetails = "N";
	var inclExp = "Y";
	var inclEndt = "";
	var credBranch = null;
	var paramCredBranch = null;
	
	var selectedMasterRow = null;
	var selectedMasterX = null;
	var selectedMasterY = null;
	var selectedDetailRow = null;	

	// storage of selected record values
	var prevLineCd = null;		
	var prevSublineCd = null;
	var prevAllLineTag = null;
	var prevDateFrom = null;
	var prevDateTo = null;
	
	var prevRangeFrom = null;
	var prevRangeTo = null;
	
	var addedModifiedRisk = [];
	var addedModifiedRange = [];
	
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
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
			$("csvRB").disabled = true;
		} else {
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
			if(dest == "file"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}		
		}
	}	
	
	var objRpMaster = new Object();
	objRpMaster.tableGrid = JSON.parse('${riskProfileMasterTG}'.replace(/\\/g, '\\\\'));
	objRpMaster.objRows = objRpMaster.tableGrid.rows || [];
	objRpMaster.objList = [];	// holds all the geniisys rows
	
	try{
		var rpMasterTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileMaster",
			options: {
				width: '900px',
				height: '200px',
				onCellFocus: function(element, value, x, y, id){
					if (objGIPIS901.changeTagDetail == 1){
						rpMasterTG.keys.setFocus(rpMasterTG.keys._nOldFocus);
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						selectedMasterRow = rpMasterTG.geniisysRows[y];
						selectedMasterX = x;
						selectedMasterY = y;
						rpMasterTG.keys.releaseKeys();
						populateToggleMasterFields(selectedMasterRow);
						populateToggleDetailFields(null); 
					}
				},
				onRemoveRowFocus: function(){
					if (objGIPIS901.changeTagDetail == 1){ 
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						rpMasterTG.keys.releaseKeys();
						selectedMasterRow = null;
						selectedDetailRow = null;
						populateToggleMasterFields(null);
						//populateToggleDetailFields(null);	Gzelle 04072015
					}				},
				beforeClick: function(){
					if(changeTag == 1 || objGIPIS901.changeTagDetail == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},	
				beforeSort: function(){
					if(changeTag == 1 || objGIPIS901.changeTagDetail == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						rpMasterTG.onRemoveRowFocus();
					}
				},
				prePager: function(){
					if(changeTag == 1 || objGIPIS901.changeTagDetail == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						rpMasterTG.onRemoveRowFocus();
					}
				},
                checkChanges: function(){
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 || objGIPIS901.changeTagDetail == 1? true : false);
				},
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
					id: 'lineCd',
					width: '0px',
					visible: false
				},    
				{
					id: 'sublineCd',
					width: '0px',
					visible: false
				},    
				{
					id: 'issCd',
					width: '0px',
					visible: false
				},       
				{
					id: 'allLineTag',
					width: '0px',
					visible: false
				},    
				{
					id: 'userId',
					width: '0px',
					visible: false
				},     
				{
					id: 'lineName',
					title: 'Line',
					width: '165px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},     			     
				{
					id: 'sublineName',
					title: 'Subline',
					width: '205px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},         
				{
					id: 'issName',
					title: 'Cred. Branch',
					width: '205px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},           
				{
					id: 'dateFrom',
					title: 'From',
					width: '138px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					geniisysClass: 'date',
				    renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					},
					filterOption: true,
					filterOptionType: 'formattedDate'
				},   		         
				{
					id: 'dateTo',
					title: 'To',
					width: '138px', 
					titleAlign: 'left',
					visible: true,
					sortable: true,
					geniisysClass: 'date',
				    renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					},
					filterOption: true,
					filterOptionType: 'date'
				},   
			],
			rows: objRpMaster.objRows
		};
		
		rpMasterTG = new MyTableGrid(rpMasterTableModel);
		rpMasterTG.pager = objRpMaster.tableGrid;
		rpMasterTG.render('riskProfileMasterTGDiv');
		rpMasterTG.afterRender = function(){
			objRpMaster.objList = rpMasterTG.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Risk Profile Master table grid error", e);
	}
	
	
	var objRpDetail = new Object();
	objRpDetail.tableGrid = JSON.parse('${riskProfileDetailTG}'.replace(/\\/g, '\\\\'));
	objRpDetail.objRows = objRpDetail.tableGrid.rows || [];
	objRpDetail.objList = [];	// holds all the geniisys rows
	
	try{
		var rpDetailTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail",
			options: {
				width: '400px',	//Gzelle 03252015
				height: '125px',
				onCellFocus: function(element, value, x, y, id){
					selectedDetailRow = rpDetailTG.geniisysRows[y];
					populateToggleDetailFields(selectedDetailRow);
					rpDetailTG.keys.releaseKeys(); 
				},
				onRemoveRowFocus: function(){
					rpDetailTG.keys.releaseKeys();
					selectedDetailRow = null;
					populateToggleDetailFields(selectedDetailRow);
				},
				beforeSort: function(){
					if(objGIPIS901.changeTagDetail == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						rpDetailTG.onRemoveRowFocus();
					}
				},
				prePager: function(){
					if(objGIPIS901.changeTagDetail == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						rpDetailTG.onRemoveRowFocus();
					}
				},
				onSort: function(){
					rpDetailTG.onRemoveRowFocus();
				},
				onRefresh: function(){	/*start Gzelle 09112015 SR4136*/
					rpDetailTG.onRemoveRowFocus();
				},	/*end Gzelle 09112015 SR4136*/
                checkChanges: function(){
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				masterDetail: function(){
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (objGIPIS901.changeTagDetail == 1 ? true : false);
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],					
					onFilter: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						}else{
							rpDetailTG.onRemoveRowFocus();
						}
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
					id: 'lineCd',
					width: '0px',
					visible: false
				}, 
				{
					id: 'sublineCd',
					width: '0px',
					visible: false
				},   
				{
					id: 'dateFrom',
					width: '0px',
					visible: false
				}, 
				{
					id: 'dateTo',
					width: '0px',
					visible: false
				}, 
				{
					id: 'policyCnt',
					width: '0px',
					visible: false
				}, 
				{
					id: 'netRetention',
					width: '0px',
					visible: false
				}, 
				{
					id: 'quotaShare',
					width: '0px',
					visible: false
				}, 
				{
					id: 'treaty',
					width: '0px',
					visible: false
				}, 
				{
					id: 'facultative',
					width: '0px',
					visible: false
				}, 
				{
					id: 'allLineTag',
					width: '0px',
					visible: false
				}, 
				{
					id: 'userId',
					width: '0px',
					visible: false
				}, 
				{
					id: 'masterUpdated',
					width: '0px',
					visible: false
				}, 
				{
					id: 'rangeFrom',
					title: 'From',
					width: '168px',		//Gzelle 03252015
					titleAlign: 'left',
					align: 'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'money'
				},
				{
					id: 'rangeTo',
					title: 'To',
					width: '168px',		//Gzelle 03252015
					titleAlign: 'left',
					align: 'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'money'
				}
			],
			rows: objRpDetail.objRows
		};
		
		rpDetailTG = new MyTableGrid(rpDetailTableModel);
		rpDetailTG.pager = objRpDetail.tableGrid;
		rpDetailTG.render('riskProfileDetailTGDiv');
		rpDetailTG.afterRender = function(){
			objRpDetail.objList = rpDetailTG.geniisysRows;
			objGIPIS901.rangeCount = rpDetailTG.geniisysRows.length;
			if(rpDetailTG.geniisysRows.length > 0){	//Gzelle 03302015
				var rec = rpDetailTG.geniisysRows[0];
				minRangeFrom = rec.minRangeFrom == "" || rec.minRangeFrom == null ? "0.00" : formatToNthDecimal(rec.minRangeFrom, 2);
				maxRangeTo = rec.maxRangeTo == "" || rec.maxRangeTo == null ? "0.00" : formatToNthDecimal(rec.maxRangeTo, 2);
				recCount = rec.recCount;
			} else {
				minRangeFrom = "";
				maxRangeTo = "";
				recCount = "";
			}		
		};
		
	}catch(e){
		showErrorMessage("Risk Profile Detail table grid error", e);
	}
	
	function showLineLOV(){
		var searchString = $F("txtLine") == "" ? '%' : escapeHTML2($F("txtLine").trim());
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 	"getGipis901AllLinesLOV",
				credBranch:	$F("hidIssCd").trim(),
				page : 		1
			},
			title : "List of Lines",
			width : 480,
			height : 386,
			columnModel : [ 
			 {
				id : "lineName",
				title : "Line",
				width : '345px'
			},{
				id : "lineCd",
				title : "Code",
				width : '120px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: searchString,
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("hidLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLine").value = unescapeHTML2(row.lineName);
					menuLineCd = row.menuLineCd;	//Gzelle 04152015 SR4136,4196,4285,4271
					if (allLineTagRB == "R") { 
						if (menuLineCd != objGIPIS901.lineCdFi && menuLineCd != objGIPIS901.lineCdMc){	//Gzelle 04152015 SR4136,4196,4285,4271 
							showWaitingMessageBox("Please select a FIRE or MOTOR CAR line.", "I", function() {	//Gzelle 04152015 SR4136,4196,4285,4271 
								$("hidLineCd").clear();
								$("txtLine").clear();
								$("hidSublineCd").clear();
								$("txtSubline").clear();
							});
							return false;
						}
					}
					
					if(selectedMasterRow != null && $F("txtLine") != selectedMasterRow.lineName){
						$("hidSublineCd").clear();
						$("txtSubline").clear();
						//rpMasterTG.setValueAt("Y", rpMasterTG.getColumnIndex('allLineTag'), selectedMasterY);
						//setSelectedAllLineTag(rpMasterTG.getValueAt(rpMasterTG.getColumnIndex('allLineTag'), selectedMasterY));
					}
					
					if (prevLineCd != null && prevSublineCd != null && prevAllLineTag != null) {
						if (prevLineCd != $F("hidLineCd") || prevSublineCd != $F("hidSublineCd") || prevAllLineTag != allLineTagRB) {	//Gzelle 04072015
							rpMasterTG.unselectRows();
							objGIPIS901.addFromUpdate = true;
							$("btnAddRisk").value = "Add";
							disableButton("btnDeleteRisk");
							disableButton("btnAddRange");
							curLineCd = unescapeHTML2(row.lineCd);
						} else {
							$("btnAddRisk").value = "Update";
						}				
					}
				}
			},
			onCancel: function(){
				$("txtLine").focus();
				menuLineCd = null;	//Gzelle 04152015 SR4136,4196,4285,4271
			},
			onUndefinedRow : function(){
				menuLineCd = null;	//Gzelle 04152015 SR4136,4196,4285,4271
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLine");
			} 
		});
	}
	
	function showIssLOV(){
		var searchString = $F("txtIssName") == "" ? '%' : escapeHTML2($F("txtIssName").trim());
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 	"getGipis901CredBranchLOV",
				credBranch:	$F("hidLineCd").trim(),
				page : 		1
			},
			title : "List of Crediting Branch",
			width : 480,
			height : 386,
			columnModel : [ 
			 {
				id : "issName",
				title : "Branch",
				width : '345px'
			},{
				id : "issCd",
				title : "Code",
				width : '120px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: searchString,
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("hidIssCd").value = unescapeHTML2(row.issCd);
					$("txtIssName").value = unescapeHTML2(row.issName);
				}
			},
			onCancel: function(){
				$("txtIssName").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssName");
			} 
		});
	}
	
	function populateToggleMasterFields(row){
		if (row == null){
			$("hidLineCd").clear();
			$("txtLine").clear();
			$("hidSublineCd").clear();
			$("txtSubline").clear();
			$("hidIssCd").clear();
			$("txtIssName").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();			
			$("txtLine").readOnly = false;
			$("txtIssName").readOnly = false;
			prevLineCd = null;
			prevSublineCd = null;
			prevAllLineTag = null;
			prevDateFrom = null;
			prevDateTo = null;
			enableSearch("searchIss");
			enableSearch("searchLine");
			enableDate("imgFromDate");
			enableDate("imgToDate");
			$$("input[name='allLineTagRG']").each(function(rb){
				rb.disabled = false;
			});
			$("btnAddRisk").value = "Add";
			enableButton("btnAddRisk");
			rpDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail";
			rpDetailTG._refreshList();
			//Gzelle 04132015
			$("chkInclEndt").disabled = false;
			$("chkInclExp").disabled = false;
			$$("input[name='paramDateRG']").each(function(rb){
				rb.disabled = false;
			});
			menuLineCd = null;				   //Gzelle 04152015 SR4136,4196,4285,4271
			$("chkInclExp").checked = false;   //Gzelle 04152015 SR4136,4196,4285,4271
			$("chkInclEndt").checked = false;  //Gzelle 04152015 SR4136,4196,4285,4271
			$("txtRangeFrom").clear();			
			$("txtRangeTo").clear();			
			disableButton("btnAddRange");
			disableButton("btnDeleteRisk");
			disableInputField("txtRangeFrom");
			disableInputField("txtRangeTo");  //end Gzelle 09112015 SR4136,4196,4285,4271
		}else{
			$("hidLineCd").value = unescapeHTML2(row.lineCd);
			$("txtLine").value = unescapeHTML2(row.lineName);
			$("hidSublineCd").value = unescapeHTML2(row.sublineCd);
			$("txtSubline").value = unescapeHTML2(row.sublineName);
			$("hidIssCd").value = unescapeHTML2(row.issCd);
			$("txtIssName").value = unescapeHTML2(row.issName);
			$("txtFromDate").value = dateFormat(row.dateFrom, 'mm-dd-yyyy');
			$("txtToDate").value = dateFormat(row.dateTo, 'mm-dd-yyyy');
			prevLineCd = unescapeHTML2(row.lineCd);
			prevSublineCd = unescapeHTML2(row.sublineCd);
			prevAllLineTag = row.allLineTag;
			prevDateFrom = dateFormat(row.dateFrom, 'mm-dd-yyyy');
			prevDateTo = dateFormat(row.dateTo, 'mm-dd-yyyy');
			paramCredBranch =  unescapeHTML2(row.issCd);	//start Gzelle 03252015 
			$("chkInclExp").checked = row.incExpired == "Y" ? true : false;
			$("chkInclEndt").checked = row.incEndt == "Y" ? true : false;
			inclEndt = row.incEndt;
			inclExp = row.incExpired;//end - Gzelle 03252015
			
			/*if (row.recordStatus == "0" || row.recordStatus == "1"){
				$("txtLine").readOnly = false;
				$("txtIssName").readOnly = false;
				enableSearch("searchIss");
				enableSearch("searchLine");
				enableDate("imgFromDate");
				enableDate("imgToDate"); 
				$$("input[name='allLineTagRG']").each(function(rb){
					rb.disabled = false;
				});
				$("btnAddRisk").value = "Update";
				enableButton("btnAddRisk");
				disableButton("btnAddRange");
			}else{
				$("txtLine").readOnly = true;
				$("txtIssName").readOnly = true;
				disableSearch("searchIss");
				disableSearch("searchLine");
				disableDate("imgFromDate");
				disableDate("imgToDate");
				$$("input[name='allLineTagRG']").each(function(rb){
					rb.disabled = true;
				});
			}	Gzelle 04072015*/
			
			$("btnAddRisk").value = "Update";
 			enableButton("btnAddRange");
			enableButton("btnDeleteRisk");
			
			if (row.recordStatus == "0") {
				rpDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail";
				rpDetailTG._refreshList();
			}else {
				rpDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail&lineCd="+encodeURIComponent(unescapeHTML2(row.lineCd))+"&sublineCd="+
								 encodeURIComponent(row.sublineCd)+"&dateFrom="+dateFormat(row.dateFrom, 'mm-dd-yyyy')+"&dateTo="+dateFormat(row.dateTo, 'mm-dd-yyyy')
							 	 +"&allLineTag="+row.allLineTag; 
				rpDetailTG._refreshList();				
			}
			
			setSelectedAllLineTag(row.allLineTag);
			setSelectedParamDate(row.paramDateRB);	//Gzelle 03252015 
			menuLineCd = row.menuLineCd;	//Gzelle 04152015 SR4136,4196,4285,4271
		}

		whenNewRecordInstanceMaster(row);
	}
	
	function whenNewRecordInstanceMaster(row){
		updateSw = "N";
		
		if (row == null){
			paramDateRB = "ED";	//effectivity date
			//allLineTagRB = "Y";	//By Line
			$$("input[name='paramDateRG']").each(function(rb){
				if (rb.value == paramDateRB){
					rb.checked = true;
				}else{
					rb.checked = false;
				}
			});
			
			//setSelectedAllLineTag("Y");
			$("lineRB").checked = true;
			$("txtSubline").readOnly = true;
			disableSearch("searchSubline");
			$("chkTreaties").checked = false;
			$("chkDetails").checked = false;
			$("chkTariff").checked = false;
			$("chkTariff").disabled = true;
		}else{
			if (nvl(row.allLineTag, "Y") == "Y" || nvl(row.allLineTag, "Y") == "R"){
				$("txtSubline").readOnly = true;
				disableSearch("searchSubline");
				$("chkTreaties").disabled = false;
			}else if (nvl(row.allLineTag, "Y") == "P"){
				$("txtSubline").readOnly = false;
				enableSearch("searchSubline");
				$("chkTreaties").disabled = true;
				$("chkTreaties").checked = false;
			}else {
				$("txtSubline").readOnly = false;
				enableSearch("searchSubline");
				$("chkTreaties").disabled = false;
			}
			
			if ($("btnAddRisk").value == "Add"){
				$("txtSubline").readOnly = true;
				disableSearch("searchSubline");				
			}
			
			if (objGIPIS901.lineCdFi == row.lineCd){
				$("chkTariff").disabled = false;
			}else{
				$("chkTariff").disabled = true;
			}
			
			origValues = [];
			origValues.push({lineName:		unescapeHTML2(row.lineName),
							 sublineName:	unescapeHTML2(row.sublineName),
							 dateFrom:		dateFormat(row.dateFrom, 'mm-dd-yyyy'),
							 dateTo:		dateFormat(row.dateTo, 'mm-dd-yyyy'),
							 allLineTag:	row.allLineTag,
							 paramDate:		paramDateRB});
			extractDetails = "Y";
			if (printDetails == "N"){
				extractDetails = "N";
			}
			objGIPIS901.rangeValue = 0;
			credBranch = null;
			/*$("chkInclExp").checked = inclExp == "Y" ? true : false;
			$("chkInclEndt").checked = inclEndt == "Y" ? true : false;*/
			
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:		"chkRiskExtRecords",
					lineCd:		unescapeHTML2(row.lineCd),
					sublineCd:	unescapeHTML2(row.sublineCd),
					dateFrom:	dateFormat(row.dateFrom, 'mm-dd-yyyy'),
					dateTo:		dateFormat(row.dateTo, 'mm-dd-yyyy'),
					allLineTag:	row.allLineTag,
					byTarf:		$("chkTariff").checked ? "Y" : "N"
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == 1){
							//disableButton("btnExtract");	Gzelle 04152015 SR4136,4196,4285,4271
							enableButton("btnExtract");		//Gzelle 04152015 SR4136,4196,4285,4271
						}else{
							enableButton("btnExtract");							
						}
					}
				}
			});
		}
	}
	
	function populateToggleDetailFields(row){
		if (row == null){
			$("txtRangeFrom").clear();
			$("txtRangeTo").clear();
			prevRangeFrom = null;
			prevRangeTo = null;
			$("txtRangeFrom").readOnly = false;
			$("txtRangeTo").readOnly = false;
			enableButton("btnAddRange");
			disableButton("btnDeleteRange");
			$("btnAddRange").value = "Add";				
			if ((getDeletedJSONObjects(objRpDetail.objList).length) > 0){	//Gzelle 10262015 SR4136
				disableButton("btnAddRange");
			}//Gzelle 10262015 SR4136
		}else{
			$("txtRangeFrom").value = formatCurrency(row.rangeFrom);
			$("txtRangeTo").value = formatCurrency(row.rangeTo);
			prevRangeFrom = formatCurrency(row.rangeFrom);
			prevRangeTo = formatCurrency(row.rangeTo);
			
			if (row.recordStatus == "0") {	//added rows
				$("txtRangeFrom").readOnly = false;
				$("txtRangeTo").readOnly = false;
				enableButton("btnAddRange");
				//enableButton("btnDeleteRange"); Gzelle 03302015
				$("btnAddRange").value = "Update";
			}else{  
				$("txtRangeFrom").readOnly = true;
				$("txtRangeTo").readOnly = true;
				disableButton("btnAddRange");
				//disableButton("btnDeleteRange"); Gzelle 03302015
				$("btnAddRange").value = "Add";					
			}
			
			if (recCount > 10) {		//start - Gzelle 03302015
				if ($F("mtgPageInput2") > 1) {	
					rowIndex = rpDetailTG.getCurrentPosition()[1]+1+(($F("mtgPageInput2")-1)*10);
				}
			}
			
			if (recCount <= 10) rowIndex = rpDetailTG.getCurrentPosition()[1]+1;	
			
			if(recCount != rowIndex){	
				disableButton("btnDeleteRange");
			}else{
				enableButton("btnDeleteRange");
			} 							//end Gzelle 03302015
		}
	}
	
	function setSelectedAllLineTag(compareValue){
		$$("input[name='allLineTagRG']").each(function(rb){
			if (rb.value == compareValue){ 
				allLineTagRB = rb.value;
				rb.checked = true;
			}else{
				rb.checked = false;
			}
		});	
	}

	//Gzelle 03252015
	function setSelectedParamDate(compareValue){
		$$("input[name='paramDateRG']").each(function(rb){
			if (rb.value == compareValue){ 
				paramDateRB = rb.value;
				rb.checked = true;
			}else{
				rb.checked = false;
			}
		});	
	}
	
	//Gzelle 04082015
	function getSelectedAllLineTag(){
		var tag = "";
		$$("input[name='allLineTagRG']").each(function(a){
			if($(a.id).checked){
				tag = $(a.id).value;
			}
		});	
		return tag;
	}
	
	function toggleExtractButton(){
		if (origValues[0] != undefined){
			if (nvl(origValues[0].lineName, 'XX') != nvl($F("txtLine"), 'XX') ||
					nvl(origValues[0].allLineTag, 'XX') != nvl(allLineTagRB, 'XX') ||
					nvl(origValues[0].sublineName, 'XX') != nvl($F("txtSubline"), 'XX') ||
					nvl(origValues[0].paramDate, 'XX') != nvl(paramDateRB, 'XX') || 
					($F("txtFromDate") != "" && compareDatesIgnoreTime(Date.parse(origValues[0].dateFrom), Date.parse($F("txtFromDate"))) == 0) ||
						 ($F("txtToDate") != "" && compareDatesIgnoreTime(Date.parse(origValues[0].dateTo), Date.parse($F("txtToDate"))) == 0) ){
				enableButton("btnExtract");
			}else{
				//disableButton("btnExtract");	Gzelle 04152015 SR4136,4196,4285,4271
				enableButton("btnExtract");		//Gzelle 04152015 SR4136,4196,4285,4271
			}
		}
	}
	
	function refreshMasterTable(){
		rpMasterTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileMaster&credBranch="+paramCredBranch;
		rpMasterTG._refreshList();
		rpMasterTG.onRemoveRowFocus();
		
		rpDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail"; 
		rpDetailTG._refreshList();
		rpDetailTG.onRemoveRowFocus();	//Gzelle 07292015 SR4136,4196,4285,4286,4271,4161
		allLineTagRB = "Y";
	}
	
	function setRiskObj(){
		var obj = new Object();
		obj.lineCd = $F("hidLineCd");
		obj.lineName = unescapeHTML2($F("txtLine"));
		obj.sublineCd = $F("hidSublineCd");
		obj.sublineName = unescapeHTML2($F("txtSubline"));
		obj.issCd = $F("hidIssCd");
		obj.issName = unescapeHTML2($F("txtIssName"));
		obj.dateFrom = dateFormat($F("txtFromDate"), 'mm-dd-yyyy');
		obj.dateTo = dateFormat($F("txtToDate"), 'mm-dd-yyyy');
		obj.allLineTag = allLineTagRB;
		
		obj.paramDateRB = paramDateRB;							//start - Gzelle 03232015
		obj.incEndt = nvl(inclEndt,"N");
		obj.incExpired = nvl(inclExp,"N");
		obj.credBranchParam = unescapeHTML2($F("hidIssCd"));	//end

		if (objGIPIS901.addFromUpdate) {
			obj.prevLineCd = prevLineCd;			//start - Gzelle 04072015
			obj.prevSublineCd = prevSublineCd;
			obj.prevAllLineTag = prevAllLineTag;
			curLineCd = $F("hidLineCd");
			curSublineCd = $F("hidSublineCd");		//end
		}
		
		return obj;
	}
	
	//Gzelle 03262015
	function valBeforeSave() {
		var lineCd = $F("hidLineCd");
		var sublineCd = $F("hidSublineCd");
		
		if (objGIPIS901.addFromUpdate) {
			lineCd = curLineCd;
			sublineCd = curSublineCd;
		}
		//Gzelle 04132015
		if (rpDetailTG.geniisysRows.length < 1 && !objGIPIS901.addFromUpdate) {
			showMessageBox("Range must have at least one record.", "I");
			return false;
		}
		
		new Ajax.Request(contextPath + "/GIPIGenerateStatisticalReportsController", {
			parameters : {
				action : "valBeforeSave",
			 	lineCd : lineCd,
				sublineCd : sublineCd,
				allLineTag : allLineTagRB
				},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if (response.responseText == "X") {
						showConfirmBox("Confirmation","There is/are existing risk profile set-up having the same extraction basis,"+
								"line code, and subline. Do you want to update the existing records or retain the setup of the existing records?",
								"Update", "Retain", function() {
									objGIPIS901.dupRecord = true;
									objGIPIS901.changeTagDetail = 0;
									objGIPIS901.userResponse = "Update";
									btnVal = null;
									riskSave(refreshMasterTable);		
								}, function() {	//para sa Retain
									objGIPIS901.dupRecord = true;
									objGIPIS901.changeTagDetail = 0;
									objGIPIS901.userResponse = "Retain";
									btnVal = null;
									riskSave(refreshMasterTable);
								}, "");
					} else {
						btnVal = null;
						riskSave(refreshMasterTable);
					}
				}
			}
		});
	}		
	
	//Gzelle 04072015
	function valAddRec() {
		if(checkAllRequiredFieldsInDiv("riskFieldsDiv")){
			var lineCd = $F("hidLineCd");
			var sublineCd = $F("hidSublineCd");
			var allLineTag = getSelectedAllLineTag();
			
			if(changeTag == 1){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return;
			}
			
			if (objGIPIS901.addFromUpdate) {
				lineCd = curLineCd;
				sublineCd = curSublineCd;
			}
			
			if ($F("btnAddRisk") == "Add") {
				new Ajax.Request(contextPath + "/GIPIGenerateStatisticalReportsController", {
					parameters : {
						action : "valAddUpdRec",
					 	lineCd : lineCd,
						sublineCd : sublineCd,
						allLineTag : allLineTag
						},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							if (response.responseText == "X") {
								showMessageBox("Risk Profile setup is already existing.", "I");	
								return;
							} else {
								addModifyRiskObj();
							}
						}
					}
				});
			} else {
				addModifyRiskObj();
			}
		}
	}
	
	function addModifyRiskObj(){
		try{
			/*if ($F("txtFromDate") == "" || $F("txtToDate") == ""){
				showMessageBox("Duration must be entered.", "E");
				return false;
			} else if(changeTag == 1 && $F("btnAddRisk") == "Add") {
				showMessageBox("Please save changes first before adding new record.", "I");
				return false;
			}	Gzelle 04072015*/

			/*for(var i=0; i < objRpMaster.objList.length; i++ ){
				if ((nvl(objRpMaster.objList[i].lineCd,"-") == nvl($F("hidLineCd"), "-")) && 
						(nvl(objRpMaster.objList[i].sublineCd, "-") == nvl($F("hidSublineCd"),"-")) &&
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateFrom), Date.parse($F("txtFromDate"))) == 0) && 
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateTo), Date.parse($F("txtFromDate"))) == 0) &&
						(objRpMaster.objList[i].allLineTag == allLineTagRB) &&
						(objRpMaster.objList[i].recordStatus != -1)){
					showMessageBox("Record already in the list.", "I");
					return false;
				}
			}*/
			
			var newObj = setRiskObj();
			var objParams = new Object();
			
			if ($F("btnAddRisk") == "Add"){
				objRpMaster.objList.push(newObj);
				rpMasterTG.addBottomRow(newObj);
				addedModifiedRisk.push(newObj);
				
				btnVal = "Add";	//Gzelle 04012015	para madetermine qng anu ung pinindot ng user, gagmtn sa validation sa save
				var index = rpMasterTG.geniisysRows.length - 1;
				if (!objGIPIS901.addFromUpdate) {
					rpMasterTG.selectRow(index);
					populateToggleMasterFields(rpMasterTG.geniisysRows[index]);
					selectedMasterRow = rpMasterTG.geniisysRows[index];
				}
			}else{				
				for(var i=0; i < objRpMaster.objList.length; i++ ){
					if ((nvl(unescapeHTML2(objRpMaster.objList[i].lineCd),"-") == nvl(prevLineCd, "-")) && 				//Gzelle 04152015 SR4136,4196,4285,4271
							(nvl(unescapeHTML2(objRpMaster.objList[i].sublineCd), "-") == nvl(prevSublineCd,"-")) &&	//Gzelle 04152015 SR4136,4196,4285,4271
							(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateFrom), Date.parse(prevDateFrom)) == 0) && 
							(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateTo), Date.parse(prevDateTo)) == 0) &&
							(objRpMaster.objList[i].recordStatus != -1)){
						objRpMaster.objList.splice(i, 1, newObj);
						rpMasterTG.updateVisibleRowOnly(newObj, rpMasterTG.getCurrentPosition()[1]);
						btnVal = "Update";	//Gzelle 04012015 para madetermine qng anu ung pinindot ng user, gagmtn sa validation sa save
						populateToggleMasterFields(null);
					}
				}
			}
			
			changeTag = 1;
			changeTagFunc = riskSave;
			objGIPIS901.riskObjParams.setRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objRpMaster.objList));
			objGIPIS901.riskObjParams.delRows = prepareJsonAsParameter(getDeletedJSONObjects(objRpMaster.objList));
			
			/*$$("div#riskFieldsDiv input[type='text']").each(function(txt){
				txt.clear();
			});	
			$("btnAddRisk").value = "Add";
			disableButton("btnAddRange");
			disableButton("btnDeleteRisk");
			$$("input[name='allLineTagRG']").each(function(rb){
				if(rb.value == "Y"){
					rb.checked = true;
				}else{
					rb.checked = false;
				}
			});
			
			populateToggleMasterFields(null);	commented out by Gzelle 04072015*/
			
			if (objGIPIS901.addFromUpdate) {	//Gzelle 04072015
				populateToggleMasterFields(null);
				objGIPIS901.changeTagDetail = 1;
			}else {
				objGIPIS901.changeTagDetail = 0;
			}
			$("txtRangeFrom").clear();	//Gzelle 07292015 SR4136,4196,4285,4286,4271,4161
			$("txtRangeTo").clear();	//Gzelle 07292015 SR4136,4196,4285,4286,4271,4161
		}catch(e){
			showErrorMessage("addModifyRiskObj", e);
		}
		
	}
	
	//Gzelle 04072015
	function valDelRec() {
		if(checkAllRequiredFieldsInDiv("riskFieldsDiv")){
			if(changeTag == 1){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return;
			}
			
			deleteRiskObj();
		}
	}
	
	function deleteRiskObj(){
		try{
			var delObj = setRiskObj();
			
			for(var i=0; i < objRpMaster.objList.length; i++ ){
				if ((nvl(unescapeHTML2(objRpMaster.objList[i].lineCd),"-") == nvl(prevLineCd, "-")) && 	//Gzelle 07292015 SR4136,4196,4285,4271
						(nvl(unescapeHTML2(objRpMaster.objList[i].sublineCd), "-") == nvl(prevSublineCd,"-")) &&	//Gzelle 07292015 SR4136,4196,4285,4271
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateFrom), Date.parse(prevDateFrom)) == 0) && 
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateTo), Date.parse(prevDateTo)) == 0) &&
						(objRpMaster.objList[i].recordStatus != -1)){
					delObj.recordStatus = -1;
					objRpMaster.objList.splice(i, 1, delObj);
					addedModifiedRisk.splice(addedModifiedRisk.indexOf(delObj), 1);
					rpMasterTG.deleteVisibleRowOnly(rpMasterTG.getCurrentPosition()[1]);
					rpDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getRiskProfileDetail";
					rpDetailTG._refreshList();
					btnVal = "Delete";	//Gzelle 04012015 para madetermine qng anu ung pinindot ng user, gagmtn sa validation sa save
				}
			}

			changeTag = 1;
			changeTagFunc = riskSave;
			objGIPIS901.riskObjParams.setRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objRpMaster.objList));
			objGIPIS901.riskObjParams.delRows = prepareJsonAsParameter(getDeletedJSONObjects(objRpMaster.objList));
			
			$$("div#riskFieldsDiv input[type='text']").each(function(txt){ 
				txt.clear();
			});	
			$("hidLineCd").clear();
			$("hidSublineCd").clear();
			$("hidIssCd").clear();
			$("btnAddRisk").value = "Add";
			disableButton("btnAddRange");
			disableButton("btnDeleteRisk");
		}catch(e){
			showErrorMessage("deleteRiskObj", e);
		}
	}
	
	//Gzelle 04062015 - from riskAndLossProfile
	function unformatRangeCurrencyValue(value) {
		try{
			value = nvl(value, "");
			var unformattedValue = "";	
			if (value.replace(/,/g, "") != "" && !isNaN(parseFloat(value.replace(/,/g, "")))){
				unformattedValue = value.replace(/,/g, "");
			}
			return unformattedValue;	
		}catch(e){
			showErrorMessage("unformatRangeCurrencyValue", e);
		}	
	}
	
	function setRangeObj(){
		try{
			var newObj = new Object();
			newObj.lineCd = $F("hidLineCd");
			newObj.sublineCd = $F("hidSublineCd");
			newObj.dateFrom = dateFormat($F("txtFromDate"), 'mm-dd-yyyy');
			newObj.dateTo = dateFormat($F("txtToDate"), 'mm-dd-yyyy');
			newObj.rangeFrom = unformatRangeCurrencyValue($F("txtRangeFrom"));
			newObj.rangeTo = unformatRangeCurrencyValue($F("txtRangeTo"));
			newObj.allLineTag = allLineTagRB;
			newObj.policyCnt = 0;
			newObj.netRetention = 0;
			newObj.quotaShare = 0;
			newObj.treaty = 0;
			newObj.facultative = 0;
			
			newObj.paramDateRB = paramDateRB;		//start - Gzelle 03232015
			newObj.incEndt = nvl(inclEndt,"N");
			newObj.incExpired = nvl(inclExp,"N");
			newObj.credBranchParam = unescapeHTML2($F("hidIssCd"));	//end - Gzelle 03252015
			maxRangeTo = unformatCurrency("txtRangeTo");	//Gzelle 03302015
			
			return newObj;
		}catch(e){
			showErrorMessage("setRangeObj", e);
		}		
	}
	
	
	function addModifyRangeObj(){
		try{
			var newObj = setRangeObj();
			
			if ($F("btnAddRange") == "Add"){
				objRpDetail.objList.push(newObj);
				rpDetailTG.addBottomRow(newObj);
				addedModifiedRisk.push(newObj);
			}else if ($F("btnAddRange") == "Update"){
				/* start - Gzelle 09112015 SR4136 */
				var updRangeFrom = $("mtgIC" + rpDetailTG._mtgId + '_' + rpDetailTG.getColumnIndex("rangeFrom") + ','+ rpDetailTG.getCurrentPosition()[1]).innerHTML;
				var updRangeTo = $("mtgIC" + rpDetailTG._mtgId + '_' + rpDetailTG.getColumnIndex("rangeTo") + ','+ rpDetailTG.getCurrentPosition()[1]).innerHTML;
				
				for(var i=0; i < objRpDetail.objList.length; i++ ){
					if ((objRpDetail.objList[i].rangeFrom == updRangeFrom) && (objRpDetail.objList[i].rangeTo == updRangeTo) &&
							objRpDetail.objList[i].recordStatus != -1){
						objRpDetail.objList.splice(i, 1, newObj);
						rpDetailTG.updateVisibleRowOnly(newObj, rpDetailTG.getCurrentPosition()[1]);
					}
				}
				maxRangeTo = $("mtgIC" + rpDetailTG._mtgId + '_' + rpDetailTG.getColumnIndex("rangeTo") + ','+ (parseFloat(rpDetailTG.geniisysRows.length)-1)).innerHTML;	//Gzelle 09112015 SR4136
				/* end - Gzelle 09112015 SR4136 */
			}
			
			if (selectedMasterRow != null){
				objGIPIS901.changeTagDetail = 1;
				changeTagFunc = riskSave;
				changeTag = 1;
			}
			
			objGIPIS901.riskObjParams.setRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objRpDetail.objList));
			objGIPIS901.riskObjParams.delRows = prepareJsonAsParameter(getDeletedJSONObjects(objRpDetail.objList));
			
			$("txtRangeFrom").clear();
			$("txtRangeTo").clear();
			$("btnAddRange").value = "Add";
			disableButton("btnDeleteRange");
			enableButton("btnExtract");
			//Gzelle 04132015
			disableSearch("searchIss");
			disableSearch("searchLine");
			disableSearch("searchSubline");
			disableDate("imgFromDate");
			disableDate("imgToDate");
			$("chkInclEndt").disabled = true;
			$("chkInclExp").disabled = true;
			$$("div#riskFieldsDiv input[type='text']").each(function(txt){
				txt.readOnly = true;
			});	
			$$("input[name='allLineTagRG']").each(function(rb){
				rb.disabled = true;
			});
			$$("input[name='paramDateRG']").each(function(rb){
				rb.disabled = true;
			});			
		}catch(e){
			showErrorMessage("addModifyRangeObj", e);
		}
	}
	
	function deleteRangeObj(){
		try{
			var delObj = setRangeObj();//setRiskObj(); Gzelle 03302015
			
			/*for(var i=0; i < objRpDetail.objList.length; i++ ){
			if ((objRpDetail.objList[i].rangeFrom == prevRangeFrom) && (objRpDetail.objList[i].rangeTo == prevRangeTo) &&
						objRpDetail.objList[i].recordStatus != -1){
					delObj.recordStatus = -1;
					objRpDetail.objList.splice(i, 1, delObj);
					addedModifiedRisk.splice(addedModifiedRisk.indexOf(delObj), 1);
					rpDetailTG.deleteVisibleRowOnly(rpDetailTG.getCurrentPosition()[1]);
				}
			}	commented out by Gzelle 03302015*/		

			delObj.recordStatus = -1;
			objRpDetail.objList.splice(i, 1, delObj);
			addedModifiedRisk.splice(addedModifiedRisk.indexOf(delObj), 1);
			rpDetailTG.deleteVisibleRowOnly(rpDetailTG.getCurrentPosition()[1]);			
			
			if (selectedMasterRow != null){
				objGIPIS901.changeTagDetail = 1;
				changeTagFunc = riskSave;
			}
			
			objGIPIS901.riskObjParams.setRows = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objRpDetail.objList));
			objGIPIS901.riskObjParams.delRows = prepareJsonAsParameter(getDeletedJSONObjects(objRpDetail.objList));
			$("txtRangeFrom").clear();
			$("txtRangeTo").clear();
			$("btnAddRange").value = "Add";
			disableButton("btnDeleteRange");
		}catch(e){
			showErrorMessage("deleteRangeObj", e);
		}
	}	
	
	function prepareReportParams(){
		try{
			var reportId = "";
			var reportTitle = "";
			var byTarf = $("chkTariff").checked ? "Y" : "N";
			var reportParams = "&paramDate="+paramDateRB+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&lineCd="+$F("hidLineCd")+
								"&sublineCd="+$F("hidSublineCd")+"&byTarf="+byTarf+"&allLineTag="+allLineTagRB;
			
			if($("chkDetails").checked){
				reportParams = reportParams+"&showTarf="+byTarf;
				if (allLineTagRB == "Y"){
					reportId = "GIPIR949";
					reportTitle = "DETAIL RISK PROFILE (FIRE)";
				}else if (allLineTagRB == "N"){
					reportId = "GIPIR949"; //reportId = "GIPIR949A"; benjo 05.22.2015 print GIPIR949 instead of GIPIR949A
					reportTitle = "Risk Profile (By Line and Subline)";
				} 
			}else{
				if ($("chkTreaties").checked){
					if (allLineTagRB != "Y"){
						reportParams = reportParams+"&showTarf="+byTarf;
						reportId = "GIPIR948";
						reportTitle = "RI RISK PROFILE BY LINE";
					}
				}else{
					if (allLineTagRB == "Y"){
						reportId = "GIPIR941"; //reportId = "GIPIR940"; benjo 05.22.2015 print GIPIR941 instead of GIPIR940
						reportTitle = "RISK PROFILE BY LINE AND SUBLINE";
					}else if(allLineTagRB == "P"){
						reportId = "GIPIR934";
						reportTitle = "RISK PROFILE BY PERIL";
					}else if(allLineTagRB == "R"){
						if(selectedMasterRow.lineCd == objGIPIS901.lineCdFi){
							reportId = "GIPIR949C";
						}else{
							reportId = "GIPIR949B";
						}					
						reportTitle = "RISK PROFILE (By Risk)";
					}else{
						reportId = "GIPIR941";
						reportTitle = "RISK PROFILE BY LINE";
					}
				}
			}
			
			if ($("chkDetails").checked == false && $("chkTreaties").checked){
				if (allLineTagRB == "Y"){
					getTreatyCount(reportParams);
				}else{
					printReport(reportId, reportTitle, reportParams);
				}
			}else{
				printReport(reportId, reportTitle, reportParams);
			}
			
		}catch(e){
			showErrorMessage("prepareReportParams", e);
		}
	}
	
	function getTreatyCount(reportParams){
		try{
			var reportId = "";
			
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:			"getTreatyCount",
					lineCd:			$F("hidLineCd"),
					startingDate:	$F("txtFromDate"),
					endDate:		$F("txtToDate"),
					byTarf:			$("chkTariff").checked ? "Y" : "N"
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if (response.responseText > 4){
							reportId = "GIPIR948"; //reportId = "GIPIR947B"; benjo 05.22.2015 print GIPIR948 instead of GIPIR947B
						}else{
							reportId = "GIPIR948"; //reportId = "GIPIR947"; benjo 05.22.2015 print GIPIR948 instead of GIPIR947
						}
						
						printReport(reportId, "RI RISK PROFILE BY LINE (TREATY)", reportParams);						
					}
				}
			});			
		}catch(e){
			showErrorMessage("getTreatyCount", e);
		}
	}
	
	//start Gzelle 04152015 SR4136,4196,4285,4271
	function copyFileToLocalRisk(response, subFolder, onOkFunc){ 
		subFolder = (subFolder == null || subFolder == "" ? "reports" : subFolder);
		if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
			showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
		} else {
			var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
			var mes = response.responseText;
			mes  = mes.slice(mes.indexOf(subFolder)+subFolder.length+1);
			if(message.include("SUCCESS")){
				showWaitingMessageBox("Report file generated to " + message.substring(9) + mes, "I", function(){
					if(onOkFunc != null)
						onOkFunc();
				});
			} else {
				showMessageBox(message, "E");
			}			
		}
		new Ajax.Request(contextPath + "/GIISController", {
			parameters : {
				action : "deletePrintedReport",
				url : response.responseText
			}
		});
	}	
	//end Gzelle 04152015 SR4136,4196,4285,4271
	
	function printReport(reportId, reportTitle, reportParams){
		try{
			var content = contextPath+"/UWPrintStatisticalReportsController?action=printReportsRiskProfileTab"+"&noOfCopies="
			  			  +$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+"&reportId="+reportId+
			  			  reportParams;
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				//added by clperello | 06.10.2014
				 var fileType = "PDF";
			
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV"; 
				//end here clperello | 06.10.2014	
				
				new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType}, //$("pdfRB").checked ? "PDF" : "XLS"}, commented out by clperello 
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (checkErrorOnResponse(response)){
									if (fileType == "CSV"){ //added by clperello | 06.10.2014
										copyFileToLocalRisk(response, "csv");	//Gzelle 04152015 SR4136,4196,4285,4271
										deleteCSVFileFromServer(response.responseText);
									} else 
										copyFileToLocalRisk(response);	//Gzelle 04152015 SR4136,4196,4285,4271
								}
							}
						}
					});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}	
		}catch(e){
			showErrorMessage("getTreatyCount", e);
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
	
	$$("input[name='allLineTagRG']").each(function(rb){
		rb.observe("click", function(){
			try{
				allLineTagRB = rb.value;
				
				toggleExtractButton();
				
				if (rb.value == "Y"){
					$("hidSublineCd").clear();
					$("txtSubline").clear();
					$("txtSubline").readOnly = true;
					disableSearch("searchSubline");
					$("chkTreaties").disabled = false;
					$("chkDetails").disabled = false;
					$("chkDetails").checked = false;
				}else if(rb.value == "P"){
					$("txtSubline").readOnly = false;
					enableSearch("searchSubline");
					$("chkTreaties").disabled = true;
					$("chkTreaties").checked = false;
					$("chkDetails").disabled = true;
					$("chkDetails").checked = false;
				}else if(rb.value == "R"){
					if ($F("txtLine") != "" && (menuLineCd != objGIPIS901.lineCdFi && menuLineCd != objGIPIS901.lineCdMc)){	//Gzelle 04152015 SR4136,4196,4285,4271
						showWaitingMessageBox("Please select a FIRE or MOTOR CAR line.", "I", function() {					//Gzelle 04152015 SR4136,4196,4285,4271
							$("hidLineCd").clear();
							$("txtLine").clear();
							$("hidSublineCd").clear();
							$("txtSubline").clear();
						});
					}
					$("hidSublineCd").clear();
					$("txtSubline").clear();
					$("txtSubline").readOnly = true;
					disableSearch("searchSubline");
					$("chkTreaties").disabled = false;
					$("chkDetails").disabled = true;
					$("chkDetails").checked = false;
				}else if(rb.value == "N"){
					$("txtSubline").readOnly = false; 
					enableSearch("searchSubline");
					$("chkTreaties").disabled = true;
					$("chkDetails").disabled = false;
					$("chkDetails").checked = false;
				}else{
					$("txtSubline").readOnly = false;
					enableSearch("searchSubline");
					$("chkTreaties").disabled = false;
					$("chkDetails").disabled = false;
				}
				
				if (prevLineCd != null && prevSublineCd != null && prevAllLineTag != null) {
					if (prevLineCd != $F("txtLine") || prevSublineCd != $F("hidSublineCd") || prevAllLineTag != allLineTagRB) {	//Gzelle 04072015
						rpMasterTG.unselectRows();
						objGIPIS901.addFromUpdate = true;
						$("btnAddRisk").value = "Add";
						disableButton("btnDeleteRisk");
						disableButton("btnAddRange");
					} else {
						$("btnAddRisk").value = "Update";
					}
				}
			}catch(e){
				showErrorMessage("rb.click", e);
			}
		});
	});
	
	$$("input[name='paramDateRG']").each(function(rb){
		rb.observe("click", function(){
			paramDateRB = rb.value;
			
			toggleExtractButton();
		});
	});
	
	$("chkInclEndt").observe("click", function(){	//Gzelle 03252015
		if ($("chkInclEndt").checked){
			inclEndt = "Y";
		}else{
			inclEndt = "N";
		}
	});
	
	$("chkInclExp").observe("click", function(){	//Gzelle 03252015
		if ($("chkInclExp").checked){
			inclExp = "Y";
		}else{
			inclExp = "N";
		}
	});
	
	$("chkDetails").observe("click", function(){
		if ($("chkDetails").checked){
			$("chkTreaties").checked = false;
			$("chkTreaties").disabled = true;
		}else{
			$("chkTreaties").disabled = false;
		}
		if(extractDetails == "Y"){
			enableButton("btnExtract");
		}else{
			//disableButton("btnExtract"); 	Gzelle 04152015 SR4136,4196,4285,4271
			enableButton("btnExtract");		//Gzelle 04152015 SR4136,4196,4285,4271
		}
	});
	
	$("chkTariff").observe("click", function(){
		extractDetails = "Y";
		enableButton("btnExtract");
	});
	
	$("searchLine").observe("click", showLineLOV);
	
	$("txtLine").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis901AllLinesLOV&credBranch="+$F("hidIssCd"),findText,
						"Searching Line, please wait...");
			
			if(cond == 0){
				$("hidLineCd").clear();
				this.clear();
				//showMessageBox("Invalid value for Line", imgMessage.INFO);
				showLineLOV();
			}else if(cond == 2){
				showLineLOV();
			}else{
				$("hidLineCd").value = unescapeHTML2(cond.rows[0].lineCd);
				this.value = unescapeHTML2(cond.rows[0].lineName);				
			}
		}else{
			$("hidLineCd").clear();
			$("hidSublineCd").clear();	//Gzelle 04152015 SR4136,4196,4285,4271
			$("txtSubline").clear();	//Gzelle 04152015 SR4136,4196,4285,4271
			menuLineCd = null;			//Gzelle 04152015 SR4136,4196,4285,4271
			if (prevLineCd != null && prevSublineCd != null && prevAllLineTag != null) {
				if (prevLineCd != $F("hidLineCd") || prevSublineCd != $F("hidSublineCd") || prevAllLineTag != allLineTagRB) {	//Gzelle 04072015
					rpMasterTG.unselectRows();
					objGIPIS901.addFromUpdate = true;
					$("btnAddRisk").value = "Add";
					disableButton("btnDeleteRisk");
					disableButton("btnAddRange");
					curLineCd = "";
				} else {
					$("btnAddRisk").value = "Update";
				}				
			}
		}
		
		if(selectedMasterRow != null && this.value != selectedMasterRow.lineName){
			$("hidSublineCd").clear();
			$("txtSubline").clear();
			rpMasterTG.setValueAt("Y", rpMasterTG.getColumnIndex('allLineTag'), selectedMasterY);
			setSelectedAllLineTag(rpMasterTG.getValueAt(rpMasterTG.getColumnIndex('allLineTag'), selectedMasterY));
		}
		
		if (this.value == objGIPIS901.lineCdFi){
			$("chkTariff").disabled = false;
		}else{
			$("chkTariff").disabled = true;
		}
		
		//insert
		// updateSw = "Y";
		toggleExtractButton();
	});
	
	$("txtLine").observe("blur", function(){
		if (this.value != ""){
			if (selectedMasterRow != null && this.value != selectedMasterRow.lineName){
				$("txtSubline").value = "";
			}
		}
	});
	
	$("searchIss").observe("click", showIssLOV);
	
	$("txtIssName").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis901AllLinesLOV&lineCd="+$F("hidLineCd"),findText,
						"Searching Crediting Branch, please wait...");
			
			if(cond == 0){
				$("hidIssCd").clear();
				this.clear();
				//showMessageBox("Invalid value for Crediting Branch", imgMessage.INFO);
				showIssLOV();
			}else if(cond == 2){
				showIssLOV();
			}else{
				$("hidIssCd").value = unescapeHTML2(cond.rows[0].issCd);
				this.value = unescapeHTML2(cond.rows[0].issName);				
			}
		}else{
			$("hidIssCd").clear();
		}
		
		toggleExtractButton();
		credBranch = $F("hidIssCd");
		paramCredBranch = $F("hidIssCd");
	});
	
	$("searchSubline").observe("click", function(){
		if ($F("hidLineCd") != ""){
			showSublineCdLOV2($F("hidLineCd"), "GIPIS901", function(row){
				$("hidSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtSubline").value = unescapeHTML2(row.sublineName);
				
				if (prevLineCd != null && prevSublineCd != null && prevAllLineTag != null) {
					if (prevLineCd != $F("txtLine") || prevSublineCd != $F("hidSublineCd") || prevAllLineTag != allLineTagRB) {	//Gzelle 04072015
						rpMasterTG.unselectRows();
						objGIPIS901.addFromUpdate = true;
						$("btnAddRisk").value = "Add";
						disableButton("btnDeleteRisk");
						disableButton("btnAddRange");
						curSublineCd = unescapeHTML2(row.sublineCd); 
					} else {
						$("btnAddRisk").value = "Update";
					}					
				}
			});
		}else{
			showMessageBox("List of Values contains no entries.", "E");
		}
	});
	
	$("txtSubline").observe("change", function(){
		if ($F("hidLineCd") != "" && this.value != ""){
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getSublineByLineCdLOV&lineCd="+$F("hidLineCd"),findText,
						"Searching Subline, please wait...");
			
			if(cond == 0){
				$("hidSublineCd").clear();
				this.clear();
				//showMessageBox("Invalid value for Subline", imgMessage.INFO);
				fireEvent($("searchSubline"), "click");
			}else if(cond == 2){
				showSublineCdLOV2($F("hidLineCd"), "GIPIS901", function(row){
					$("hidSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSubline").value = unescapeHTML2(row.sublineName);
				});
			}else{
				$("hidSublineCd").value = unescapeHTML2(cond.rows[0].sublineCd);
				this.value = unescapeHTML2(cond.rows[0].sublineName);				
			}
		}else{
			$("hidSublineCd").clear();
			if (prevLineCd != null && prevSublineCd != null && prevAllLineTag != null) {
				if (prevLineCd != $F("txtLine") || prevSublineCd != $F("hidSublineCd") || prevAllLineTag != allLineTagRB) {	//Gzelle 04072015
					rpMasterTG.unselectRows();
					objGIPIS901.addFromUpdate = true;
					$("btnAddRisk").value = "Add";
					disableButton("btnDeleteRisk");
					disableButton("btnAddRange");
					curSublineCd = ""; 
				} else {
					$("btnAddRisk").value = "Update";
				}					
			}
			//showMessageBox("List of Values contains no entries.", "E");
		}
		
		toggleExtractButton();
	});	
	
	$("txtFromDate").observe("blur", function(){
		checkInputDates("txtFromDate", "txtFromDate", "txtToDate");		
		toggleExtractButton();
	});

	
	$("txtToDate").observe("blur", function(){
		checkInputDates("txtToDate", "txtFromDate", "txtToDate");		
		toggleExtractButton();
	});
	
	$("txtRangeFrom").observe("focus", function(){
		/*if (this.value == ""){
			$("txtRangeFrom").value = "1.00";
		}	Gzelle 03302015*/
		if ($("btnDeleteRange").hasClassName('disabledButton') && $("btnAddRange").hasClassName('disabledButton')) return false;	//Gzelle 09112015 SR4136

		if($F("btnAddRange") == "Add"){
			if (maxRangeTo >= $("txtRangeTo").getAttribute("max")) {
				$("txtRangeFrom").readOnly = true;
				$("txtRangeTo").readOnly = true;
			}else {
				$("txtRangeFrom").value = maxRangeTo == "" || maxRangeTo == null ? "0.00" : roundNumber((parseFloat(maxRangeTo) + .01), 2);
			}
		}
	});
	
	$("txtRangeFrom").observe("change", function() {	/* start - Gzelle 09112015 SR4136 */
		var maxMaxRangeTo = $("mtgIC" + rpDetailTG._mtgId + '_' + rpDetailTG.getColumnIndex("rangeTo") + ','+ (parseFloat(rpDetailTG.geniisysRows.length)-1)).innerHTML;
		if ($F("btnAddRange") == "Add") {
			if (parseFloat($F("txtRangeFrom")) > parseFloat($F("txtRangeTo"))){
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");	
				$("txtRangeFrom").value = roundNumber(parseFloat(unformatNumber(maxMaxRangeTo)) + .01, 2);	
				return false;
			}else if (parseFloat($F("txtRangeFrom")) <= parseFloat(maxMaxRangeTo)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");	
				$("txtRangeFrom").value = roundNumber(parseFloat(unformatNumber(maxMaxRangeTo)) + .01, 2);	
				return false;
			}else if (parseFloat($F("txtRangeFrom")) > (parseFloat(maxMaxRangeTo) + .01)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");
				$("txtRangeFrom").value = roundNumber(parseFloat(unformatNumber(maxMaxRangeTo)) + .01, 2);	
				return false;
			}
		}else {
			if (parseFloat($F("txtRangeFrom")) > parseFloat($F("txtRangeTo"))){
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");	
				$("txtRangeFrom").value = formatCurrency(prevRangeFrom);
				return false;
			}else if (parseFloat($F("txtRangeFrom")) <= parseFloat(maxMaxRangeTo)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");	
				$("txtRangeFrom").value = formatCurrency(prevRangeFrom);
				return false;
			}else if (parseFloat($F("txtRangeFrom")) > (parseFloat(maxMaxRangeTo) + .01)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeFrom");
				$("txtRangeFrom").value = formatCurrency(prevRangeFrom);	
				return false;
			}
		}
	});	/* end - Gzelle 09112015 SR4136 */
	
	$("txtRangeTo").observe("focus", function(){ 
		if ($("btnDeleteRange").hasClassName('disabledButton') && $("btnAddRange").hasClassName('disabledButton')) return false;	//Gzelle 09112015 SR4136
		
		if (this.value == "" && maxRangeTo != $("txtRangeTo").getAttribute("max")){
			$("txtRangeTo").value = $("txtRangeTo").getAttribute("max");
		}
		/*if($F("btnAddRange") == "Add"){
			$("txtRangeFrom").value = maxRangeTo == "" || maxRangeTo == null ? "0.00" : roundNumber((parseFloat(maxRangeTo) + .01), 2);
		}*/		
	});
	
	$("txtRangeTo").observe("change", function() {	/* start - Gzelle 09112015 SR4136 */
		var maxMaxRangeTo = $("mtgIC" + rpDetailTG._mtgId + '_' + rpDetailTG.getColumnIndex("rangeTo") + ','+ (parseFloat(rpDetailTG.geniisysRows.length)-1)).innerHTML;
		if ($F("btnAddRange") == "Add") {
			if (parseFloat($F("txtRangeTo")) < parseFloat($F("txtRangeFrom"))){
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeTo");	
				$("txtRangeTo").value = roundNumber(parseFloat(unformatNumber($F("txtRangeFrom"))) + .01, 2);	
				return false;
			}
		}else {
			if (parseFloat($F("txtRangeTo")) >= parseFloat(maxMaxRangeTo) && rpDetailTG.getCurrentPosition()[1] != (parseFloat(rpDetailTG.geniisysRows.length)-1)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeTo");	
				$("txtRangeTo").value = formatCurrency(prevRangeTo);	
				return false;
			}else if (parseFloat($F("txtRangeTo")) >= (roundNumber(parseFloat(unformatNumber($F("txtRangeFrom"))) + .01, 2)) && rpDetailTG.getCurrentPosition()[1] != (parseFloat(rpDetailTG.geniisysRows.length)-1)) {
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeTo");	
				$("txtRangeTo").value = formatCurrency(prevRangeTo);	
				return false;
			}
			if (parseFloat($F("txtRangeTo")) < parseFloat($F("txtRangeFrom"))){
				customShowMessageBox("Sum Insured Range must not be within the existing range.", "E","txtRangeTo");	
				$("txtRangeTo").value = formatCurrency(prevRangeTo);	
				return false;
			}
		}	/* end - Gzelle 09112015 SR4136 */
	});	
	
	$("btnAddRisk").observe("click", valAddRec);	//addModifyRiskObj); Gzelle 04072015
	
	$("btnDeleteRisk").observe("click", function(){
		//deleteRiskObj(); Gzelle 04072015
		valDelRec();
	});
	
	$("btnAddRange").observe("click", function(){
		/* if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		} */
		
		if (checkAllRequiredFieldsInDiv('riskFieldsDiv')){	//Gzelle 09112015 SR4136
			if ($F("txtRangeFrom") == "" || $F("txtRangeTo") == ""){
				showMessageBox("Range must be entered.", "E");
				return false;
			}
			
			addModifyRangeObj();
			//disableButton("btnAddRisk");	//Gzelle 03202015 
			//disableButton("btnDeleteRisk");	//Gzelle 03302015 
		}		
	});
	
	$("btnDeleteRange").observe("click", function(){
		if (recCount != 1) {	//Gzelle 04062015
			deleteRangeObj();
			disableButton("btnAddRisk");	//Gzelle 03302015 
			disableButton("btnDeleteRisk");	//Gzelle 03302015 
			recCount = recCount-1;
			maxRangeTo = recCount;
		}else {
			showMessageBox("Range must have at least one record.", "I");
		}
	});
	
	$("btnSave").observe("click", function(){
		if (objGIPIS901.changeTagDetail == 0 && changeTag == 0){
			showMessageBox("There are no changes to save.", "I");
			return false;
		}
		
		if (btnVal == "Add") {	//Gzelle 04012015
			valBeforeSave();
		}else {
			riskSave(refreshMasterTable);
		}
		
		//riskSave(refreshMasterTable); 04012015
		//refreshMasterTable();
	});
	
	$("btnExtract").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('riskFieldsDiv')){
			if (changeTag == 1){
				showMessageBox("Please save changes first.", "I");
				return false;
			}
			
			var cnt = 0;
			for(var i=0; i < objRpMaster.objList.length; i++){
				if ((nvl(objRpMaster.objList[i].lineCd,"-") == nvl($F("hidLineCd"), "-")) && 
						(nvl(objRpMaster.objList[i].sublineCd, "-") == nvl($F("hidSublineCd"),"-")) &&
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateFrom), Date.parse($F("txtFromDate"))) == 0) && 
						(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateTo), Date.parse($F("txtToDate"))) == 0) &&
						(objRpMaster.objList[i].allLineTag == allLineTagRB)  &&
						(objRpMaster.objList[i].recordStatus == "") ){
					cnt++;
				}
			}
			
			if (cnt == 0){	// records not yet saved/existing
				showMessageBox("Please save changes first.", "I");
				return false;
			}
			
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController", {
				parameters: {
					action:			"extractRiskProfile",
					lineCd:			$F("hidLineCd"),
					sublineCd:		$F("hidSublineCd"),
					allLineTag:		allLineTagRB,
					paramDate:		paramDateRB,
					dateFrom:		$F("txtFromDate"),
					dateTo:			$F("txtToDate"),
					byTarf:			$("chkTariff").checked ? "Y" : "N",
					credBranch:		paramCredBranch,
					inclEndt:		inclEndt,
					inclExp:		inclExp
				},
				onCreate: showNotice("Extracting records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						showMessageBox("Extraction complete.", "I");
						extractDetails = "N";
						printDetails = "N";
						//disableButton("btnExtract");	Gzelle 04152015 SR4136,4196,4285,4271
						
						origValues = [];
						origValues.push({lineName:		unescapeHTML2($F("txtLine")),
										 sublineName:	unescapeHTML2($("txtSubline")),
										 dateFrom:		dateFormat($F("txtFromDate"), 'mm-dd-yyyy'),
										 dateTo:		dateFormat($F("txtToDate"), 'mm-dd-yyyy'),
										 allLineTag:	allLineTagRB,
										 paramDate:		paramDateRB});
						
					}
				}
			});
		}
	});
	
	$("btnPrint").observe("click", function(){
		if (selectedMasterRow == null){
			showMessageBox("Please select a record first.", "I");
			return false;
		}
		
		var cnt = 0;
		for(var i=0; i < objRpMaster.objList.length; i++){
			if ((nvl(objRpMaster.objList[i].lineCd,"-") == nvl($F("hidLineCd"), "-")) && 
					(nvl(objRpMaster.objList[i].sublineCd, "-") == nvl($F("hidSublineCd"),"-")) &&
					(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateFrom), Date.parse($F("txtFromDate"))) == 0) && 
					(compareDatesIgnoreTime(Date.parse(objRpMaster.objList[i].dateTo), Date.parse($F("txtToDate"))) == 0) &&
					(objRpMaster.objList[i].allLineTag == allLineTagRB) &&
					(objRpMaster.objList[i].recordStatus == "") ){
				cnt++;
			}
		}
		
		/*if (cnt == 0){	// records not yet saved/existing
			showMessageBox("No records to print for the provided parameters.", "I");
			return false;
		}*/
		
		if((selectedMasterRow.allLineTag == "Y" || selectedMasterRow.allLineTag == "N") && $("chkDetails").checked){
			printDetails = "Y";
		}
		
		showWaitingMessageBox("Make sure you have saved and extracted this set-up.", "I" , function(){
			prepareReportParams();
		});	
	});
	
	
	toggleRequiredFields("screen");
	
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>

