<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/reInsurance/menu.jsp"/>
<div id="riAcceptanceMainDiv" style="margin-top: 5px;">
	<form id="enterRiAcceptanceForm" name="enterRiAcceptanceForm">
		<div changeTagAttr="true"> <!--Added div to separate buttonsDiv from changeTag Attribute-->
			<div id="frpsDetailsMainDiv">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
						<label>FRPS Details</label>
						<span class="refreshers" style="margin-top: 0;">
							<label name="gro" style="margin-left: 5px;">Hide</label> 
					 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
						</span>
					</div>
				</div>
				<div class="sectionDiv" id="frpsDetailsDiv">
					<table align="center">
						<tr>
							<td class="rightAligned" width="100px">FRPS No.</td>
							<td class="leftAligned" colspan="2" width="200px">
								<!--<input type="text" id="frpsNo" name="frpsNo" style="width: 120px;" readonly="readonly" />
									<input type="button" id="searchWFrpsRi" name="searchWFrpsRi" class="button" value="Search" style="width: 100px; display: none;" />
									-->
								<div style="width: 186px; float: left;" class="withIconDiv">
									<input type="text" id="frpsNo" name="frpsNo" value="" style="width: 155px;" class="withIcon" readonly="readonly">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWFrpsRi" name="searchWFrpsRi" alt="Go" />
								</div>			
								<input type="hidden" id="loadFromUWMenu" name="loadFromUWMenu" value="${fromUWMenu}" />					
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">PAR No.</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="riParNo" name="riParNo" style="width: 180px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="180px">Endorsement No.</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="riEndtNo" name="riEndtNo" style="width: 180px;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">Policy No.</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="riPolicyNo" name="riPolicyNo" style="width: 180px;" readonly="readonly" />
							</td>
							<td class="rightAligned" width="180px">Currency</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="riCurrency" name="riCurrency" style="width: 180px;" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">Total Premium</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="totalPremium" name="totalPremium" style="width: 180px;" readonly="readonly" class="money2" />
							</td>
							<td class="rightAligned" width="180px">Facultative TSI</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="facultativeTSI" name="facultativeTSI" style="width: 180px;" readonly="readonly" class="money2" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" width="100px">Total TSI</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="totalTsi" name="totalTsi" style="width: 180px;" readonly="readonly" class="money2" />
							</td>
							<td class="rightAligned" width="180px">Facultative Premium</td>
							<td class="leftAligned" width="200px">
								<input type="text" id="facultativePrem" name="facultativePrem" style="width: 180px;" readonly="readonly" class="money2" />
							</td>
						</tr>
					</table>
					
				</div>
			</div>
			
			<div id="reinsurersListMainDiv">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
						<label>List of Reinsurers</label>
						<span class="refreshers" style="margin-top: 0;">
							<label name="gro" style="margin-left: 5px;">Hide</label> 
						</span>
					</div>
				</div>
				<div id="reinsurerListDiv" class="sectionDiv">
					<input type="hidden" id="sumRiCommAmt" name="sumRiCommAmt" value="0" />
					<input type="hidden" id="sumRiPremAmt" name="sumRiPremAmt" value="0" />
					<input type="hidden" id="sumRiTsiAmt" name="sumRiTsiAmt" value="0" />
					<input type="hidden" id="sumRiPremVat" name="sumRiPremVat" value="0" />
					<input type="hidden" id="inputVatRate" name="inputVatRate" value="${inputVatRate}" />
					<input type="hidden" id="adjustPremVat" name="adjustPremVat" value="" />
					<input type="hidden" id="vStatus" name="vStatus" value="" />
					<input type="hidden" id="selectedFrpsRi" value="" />
					<input type="hidden" id="compPremVatF" name="compPremVatF" value="${compPremVatF}" /> <!-- Added by Vincent 201604-11 SR-4797-->
					<div id="wfrpsRITableGrid" style="position:relative; height: 180px; margin: 10px; margin-top: 5px; margin-bottom: 10px;"></div>
					
					<jsp:include page="/pages/underwriting/reInsurance/enterRIAcceptance/subPages/riAcceptanceAddtlInfo.jsp"></jsp:include>
					
					<div class="buttonsDiv" style="padding: 2px; margin-bottom: 10px; margin-top: 0px;">
						<input type="button" class="disabledButton" id="btnRecompute" name="btnRecompute" value="Recompute RI Premium VAT" />
						<input type="button" class="disabledButton" id="btnRecomputeRiComm" name="btnRecomputeRiComm" value="Recompute RI Commission" /><!-- Added by Vincent 201604-06 SR-4797--> 
					</div>
				</div>
			</div>	
			
			<div id="riAddtlInfoDiv">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
						<label>Additional Information</label>
						<span class="refreshers" style="margin-top: 0;">
							<label name="gro" style="margin-left: 5px;">Show</label> 
						</span>
					</div>
				</div>
				<div id="riAdditionalInfoDetails" class="sectionDiv" style="display: none;"  >
					<jsp:include page="/pages/underwriting/reInsurance/enterRIAcceptance/subPages/enterRiAcceptAddtlInfo.jsp"></jsp:include>
				</div>
			</div>
			
			<div id="riPerilListMainDiv">
				<div id="outerDiv" name="outerDiv">
					<div id="innerDiv" name="innerDiv">
						<label>RI Peril List</label>
						<span class="refreshers" style="margin-top: 0;">
							<label name="gro" style="margin-left: 5px;">Hide</label> 
						</span>
					</div>
				</div>
				<div id="riPerilListDiv" class="sectionDiv">
					<div id="frPerilTableGrid" style="position:relative; height: 180px; margin: 10px; margin-top: 5px; margin-bottom: 5px; "></div>
					<table border="0" align="center" style="margin-bottom: 5px;">
						<tr>
							<td class="rightAligned">Peril</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtPerilName" name="" value="" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI Share %</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiShrPct" name="txtRiShrPct" value="" maxlength="12" class="nthDecimal" nthDecimal="8" max="100" errorMsg="Field must be form of 990.99999999"/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI TSI Amount</td>
							<!-- <td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiTsiAmt" name="txtRiTsiAmt" value=""  maxlength="22" class="money" min="-9999999999.99" max="9999999999.99" errorMsg="Entered ri tsi amount is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99."/></td> -->
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiTsiAmt" name="txtRiTsiAmt" value=""  maxlength="22" class="money" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid RI TSI Amount. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99."/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI Premium Amt</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiPremAmt" name="txtRiPremAmt" value="" maxlength="17" class="money" min="-9999999999.99" max="9999999999.99" errorMsg="Invalid RI Premium Amt. Valid value should be from -9,999,999,999.99 to 9,999,999,999.99."/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI Commission %</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiCommRt" name="txtRiCommRt" value="" maxlength="14" class="nthDecimal" nthDecimal="9" max="100" min="0" errorMsg="Invalid RI Commission %. Value should be from 0.000000000 to 100.000000000."/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI Prem VAT</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiPremVat" name="txtRiPremVat" value="" maxlength="14" class="money" min="-9999999999.99" max="9999999999.99" errorMsg="Invalid RI Prem VAT. Valid value should be -9,999,999,999.99 to 9,999,999,999.99." readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="rightAligned">RI Prem Tax</td>
							<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtPremTax" name="txtPremTax" value="" maxlength="14" class="money" min="-9999999999.99" max="9999999999.99" errorMsg="Invalid RI Prem Tax. Valid value should be from -9,999,999,999.99 to 9,999,999,999.99." readonly="readonly"/></td>
						</tr>
						<tr>
							<td colspan="2" align="center"><input type="button" id="btnUpdatePeril" name="btnUpdatePeril" class="disabledButton" value="Update" style="width: 100px;"/></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnPost"			name="btnPost"				class="button" value="Post" style="width: 100px;"/>
		<!-- 	<input type="button" id="btnPrint"			name="btnPrint"				class="button" value="Print Binder" style="width: 100px;">  --><!-- remove by steven 1/8/2013 base on SR 0011416--> 
			<input type="button" id="btnCancel"			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 			name="btnSave" 				class="button" value="Save" style="width: 100px;" />
			<input type="button" id="btnPrint" name="btnPrint" class="disabledButton" value="Print Sample Binder" style="width: 160px;"> <!-- Apollo Cruz 07.31.2015 UW-SPECS-2015-014 -->			
		</div>
	</form>
</div>

<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setDocumentTitle("Enter RI Acceptance");
	window.scrollTo(0,0); 	
	hideNotice("");
	changeTag = 0;
	var preBinderId; //Apollo Cruz 07.31.2015 UW-SPECS-2015-014
	var vCommAmt = 0 ;
	if($F("loadFromUWMenu") == "Y") {
		$("searchWFrpsRi").show();
	} else {
		$("searchWFrpsRi").hide();
	}
	
	var autoPremVatL 				= '${autoPremVatL}';
	var compPremVatF 				= '${compPremVatF}';
	var localForeignSwitch = "";
	
	function verifyBtnRecompute(localForeignSw){
		try{
			if(compPremVatF == 'Y'){
				if (localForeignSw == 'L'){
					return 1;
				}else{
					return 0;
				}
			}else if( autoPremVatL == 'Y'){
				if (localForeignSw == 'L'){
					return 1;
				}else{
					return 0;
				}
			}
		}catch(e){
			showErrorMessage("verifyBtnRecompute",e);
		}
	}
	
	var objWFrpsRi = new Object(); 
	var objWFrperil = new Object();

	var selectedFrpsRi = null;
	var selectedFrperil = null;

	selectedFrpsRiRow = new Object();
	var selectedFrpsRiRowTemp = new Object();
	var selectedFrperilRow = new Object();
	var perilUpdated = false;
	var riPremVatOld = 0;
	var editedPerilRow = null;
	var fnlBinderId = null;
	var frPerilUpdated = false;
	
	selectedFrpsRiRow.frpsYy = 0;
	selectedFrpsRiRow.frpsSeqNo = 0;
	selectedFrpsRiRow.riSeqNo = 0;
	selectedFrpsRiRow.riCd = 0;

	var frPerilTableURL = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+selectedFrpsRiRow.frpsYy
						+"&lineCd="+selectedFrpsRiRow.lineCd+"&frpsSeqNo="+selectedFrpsRiRow.frpsSeqNo+
						"&riSeqNo="+selectedFrpsRiRow.riSeqNo+"&riCd="+selectedFrpsRiRow.riCd+
						"&distNo="+objRiFrps.distNo+"&distSeqNo="+objRiFrps.distSeqNo;
	
	objWFrpsRi.wFrpsRiTableGrid = JSON.parse('${wFrpsRiGrid}'.replace(/\\/g, '\\\\'));
	objWFrpsRi.wFrpsRi = objWFrpsRi.wFrpsRiTableGrid.rows || [];
	
	objWFrperil.frPerilTableGrid = JSON.parse('${wFrperilGrid}'.replace(/\\/g, '\\\\'));
	objWFrperil.frPeril = objWFrperil.frPerilTableGrid.rows || [];
	
	setFrpsMainInfo(objRiFrps);
	
	var sumRiCommAmt = 0;
	var sumRiPremAmt = 0;
	var sumRiTsiAmt = 0;
	var sumRiPremVat = 0;
	
	var sveRiCommAmt = 0;
	var sveRiPremAmt = 0;
	var sveRiTsiAmt = 0;
	var sveRiCommRt = 0;
	var sveRiPremVat = 0;
	var sveRiShrPct = 0;
	
	var riPremVatN = 0;
	var riPremVatO = 0;
	var isChanged = false;	//kenneth 09.07.2015 SR 0011416
	
	objGIRIS002 = {};
	
	function setFrpsMainInfo(row) {
		try {
			if(row != null) {
				$("frpsNo").value			=	row.frpsNo == null ? "" : row.frpsNo;
				$("riParNo").value			=	row.parNo	== null ? "" : row.parNo;
				$("riEndtNo").value			=	row.endtNo == null ? "" : row.endtNo;
				$("riPolicyNo").value		=	row.policyNo == null ? "" : row.policyNo;
				$("riCurrency").value		=	row.currencyDesc == null ? "" : row.currencyDesc;
				$("totalPremium").value		=	isNaN(row.premAmt) ? "" : formatCurrency(row.premAmt);
				$("facultativeTSI").value	=	isNaN(row.totFacTsi) ? "" : formatCurrency(row.totFacTsi);
				$("totalTsi").value			=	isNaN(row.tsiAmt) ? "" : formatCurrency(row.tsiAmt);
				$("facultativePrem").value  = 	isNaN(row.totFacPrem) ? "" : formatCurrency(row.totFacPrem);
			}
		} catch(e) {
			showErrorMessage("setFrpsMainInfo", e);
		}
	}
	
	function setWFrpsRiAddtlInfo(obj) {
		try {
			preBinderId = obj == null ? "" : isNaN(obj.preBinderId) ? "" : obj.preBinderId;
			$("frpsReinsurer").value 	= 	obj == null ? "" : unescapeHTML2(obj.riSname);
			$("frpsRiCommRate").value 	= 	obj == null ? "" : formatToNineDecimal(obj.riCommRt);
			$("frpsRiTsiAmt").value 		= 	obj == null ? "" : formatCurrency(obj.riTsiAmt);
			$("frpsRiCommAmt").value 	= 	obj == null ? "" : formatCurrency(obj.riCommAmt);
			$("frpsRiSharePct").value 	= 	obj == null ? "" : formatToNineDecimal(obj.riShrPct);
			$("frpsRiCommVat").value 	= 	obj == null ? "" : formatCurrency(obj.riCommVat);
			$("frpsRiPremAmt").value 	= 	obj == null ? "" : formatCurrency(obj.riPremAmt);
			$("frpsPremTax").value 		= 	obj == null ? "" : formatCurrency(obj.premTax);
			$("frpsRiPremVat").value 	= 	obj == null ? "" : formatCurrency(obj.riPremVat);
			$("frpsNetDue").value 		= 	obj == null ? "" : formatCurrency(obj.netDue);
			
			$("txtAddress1").value		=	obj == null ? "" : unescapeHTML2(obj.address1);
			$("txtAddress2").value		=	obj == null ? "" : unescapeHTML2(obj.address2);
			$("txtAddress3").value		=	obj == null ? "" : unescapeHTML2(obj.address3);
			$("txtRemarks").value		=	obj == null ? "" : unescapeHTML2(obj.remarks);
			$("txtBinder1").value		=	obj == null ? "" : unescapeHTML2(obj.bndrRemarks1);
			$("txtBinder2").value		=	obj == null ? "" : unescapeHTML2(obj.bndrRemarks2);
			$("txtBinder3").value		=	obj == null ? "" : unescapeHTML2(obj.bndrRemarks3);
			$("txtAcceptedBy").value	=	obj == null ? "" : unescapeHTML2(nvl(obj.riAcceptBy, ""));
			$("txtASNo").value			=	obj == null ? "" : nvl(obj.riAsNo, "");
			$("txtAcceptDate").value	=	obj == null ? "" : (nvl(obj.riAcceptDate, "") == "" ? "" : 
											dateFormat(obj.riAcceptDate, "mm-dd-yyyy"));
			if (obj == null){ //added by steven 1/3/2013
				disableButton("btnUpdate");
				disableButton("btnPrint");
				($$("div#addtlInfoDiv [changed=changed]")).invoke("removeAttribute", "changed");
			}else{
				enableButton("btnUpdate");
				enableButton("btnPrint");
			}
			
			if(obj != null && obj.dspFnlBinderId != null) { // for unreversed/reused binder, additional info should not be editable
				$("txtAddress1").readOnly = true;
				$("txtAddress2").readOnly = true;
				$("txtAddress3").readOnly = true;
				$("txtRemarks").readOnly = true;
				$("txtBinder1").readOnly = true;
				$("txtBinder2").readOnly = true;
				$("txtBinder3").readOnly = true;
				$("txtAcceptedBy").readOnly = true;
				$("txtASNo").readOnly = true;
				$("txtAcceptDate").readOnly = true;
				disableButton("btnUpdate");
				disableButton("btnPrint");
				disableDate("imgAcceptDate");
			} else {
				$("txtAddress1").readOnly = false;
				$("txtAddress2").readOnly = false;
				$("txtAddress3").readOnly = false;
				$("txtRemarks").readOnly = false;
				$("txtBinder1").readOnly = false;
				$("txtBinder2").readOnly = false;
				$("txtBinder3").readOnly = false;
				$("txtAcceptedBy").readOnly = false;
				$("txtASNo").readOnly = false;
				//$("txtAcceptDate").readOnly = false; //Commented out by Jerome 08.31.2016 SR 5624
				enableButton("btnUpdate");
			}
		} catch(e) {
			showErrorMessage("setWFrpsRiAddtlInfo", e);
		}
	}
	
	try {
		var wFrpsRiTable = {
			url: contextPath+"/GIRIWFrpsRiController?action=refreshWFrpsRiGrid&frpsYy="+objRiFrps.frpsYy
					+"&lineCd="+objRiFrps.lineCd+"&frpsSeqNo="+ objRiFrps.frpsSeqNo,
			options: {
				title: '',
				//width: '800px',
				height: '150px',
				//align: 'center'
				onCellFocus: function(element, value, x, y, id) {
					var mtgId = frpsRiGrid._mtgId;
					selectedFrpsRi = y;
					supplyPeril(null); // Nica 1.17.2012
					//enableButton("btnRecompute");
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedFrpsRiRow = frpsRiGrid.geniisysRows[y];
						selectedFrpsRiRowTemp = selectedFrpsRiRow;  //used to restore selectedFrpsRiRow in case peril is not updates
						fnlBinderId = selectedFrpsRiRow.dspFnlBinderId;
						setWFrpsRiAddtlInfo(selectedFrpsRiRow);
						
						wFrperilTable.url = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+selectedFrpsRiRow.frpsYy
											+"&lineCd="+selectedFrpsRiRow.lineCd+"&frpsSeqNo="+selectedFrpsRiRow.frpsSeqNo+
											"&riSeqNo="+selectedFrpsRiRow.riSeqNo+"&riCd="+selectedFrpsRiRow.riCd+
											"&distNo="+objRiFrps.distNo+"&distSeqNo="+objRiFrps.distSeqNo;
						frPerilGrid.refreshURL(wFrperilTable);
						frPerilGrid.refresh();
						
						//sumRiCommAmt = frPerilGrid.pager.sumRiCommAmt; 
						//sumRiCommAmt = frpsRiGrid.geniisysRows[y].riPremAmt * (frpsRiGrid.geniisysRows[y].riCommRt / 100); // bonok :: 06.13.2013 :: recomputed for sumRiCommAmt to get a value that is not rounded off
						sumRiCommAmt = frpsRiGrid.geniisysRows[y].riCommAmt;
						sumRiPremAmt = frPerilGrid.pager.sumRiPremAmt;
						sumRiTsiAmt = frPerilGrid.pager.sumRiTsiAmt;
						sumRiPremVat = frPerilGrid.pager.sumRiPremVat;
						if (fnlBinderId == null){
							// bonok :: 9.30.2014
							localForeignSwitch = selectedFrpsRiRow.localForeignSw;
							if (verifyBtnRecompute(localForeignSwitch) == 1){
								enableButton("btnRecompute");	
							}else{
								disableButton("btnRecompute");
							}
							enableButton("btnRecomputeRiComm"); // Vincent 201604-07 SR-4797
						}else{
							disableButton("btnRecompute");
							disableButton("btnRecomputeRiComm"); // Vincent 201604-07 SR-4797
						}	
					}
					//supplyPeril(null); //added by steven 12/13/2012 -- moved by: Nica 1.17.2012
					getAdjustPremVatParam(selectedFrpsRi.riCd);
					frpsRiGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					supplyPeril(null); //added by steven 12/13/2012
					wFrperilTable.url = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+0
								+"&lineCd="+""+"&frpsSeqNo="+0+"&riSeqNo="+0+"&riCd="+0+"&distNo="+0+"&distSeqNo="+0;
					
					frPerilGrid.refreshURL(wFrperilTable);
					frPerilGrid.refresh();
					supplyPeril(null);//niknok
					setWFrpsRiAddtlInfo(null);
					selectedFrpsRiRowTemp = null;

					sumRiCommAmt = 0;
					sumRiPremAmt = 0;
					sumRiTsiAmt = 0;
					sumRiPremVat = 0;
					disableButton("btnRecompute");
					disableButton("btnRecomputeRiComm"); // Vincent 201604-08 SR-4797
					selectedFrpsRi = null;
					fnlBinderId = null;
					isChanged = false;	//kenneth 09.07.2015 SR 0011416
				},
				onSort: function(){
					frpsRiGrid.options.onRemoveRowFocus();
				},
				prePager: function(){
					frpsRiGrid.options.onRemoveRowFocus();
				}	
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'frpsYy',
					width: '0',
					visible: false
				},
				{
					id: 'frpsSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riCd',
					width: '0',
					visible: false
				},
				{
					id: 'preBinderId',
					width: '0',
					visible: false
				},

				{
					id: 'riSname',
					title: 'Reinsurer',
					width: '100px',
					titleAlign: 'center',
					editable: false
				},
				{
					id: 'riShrPct',
					title: 'RI Share %',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'rate'
				},
				{
					id: 'riTsiAmt',
					title: 'RI TSI Amt',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riPremAmt',
					title: 'RI Prem Amt',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riPremVat',
					title: 'RI Prem Vat',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommRt',
					title: 'RI Comm %',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'rate'
				},
				{
					id: 'riCommAmt',
					title: 'RI Comm Amt',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommVat',
					title: 'RI Comm Vat',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'premTax',
					title: 'Premium Tax',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'netDue',
					title: 'Net Due',
					width: '100px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass: 'money'	
				}, 
				{
					id: 'address1',
					width: '0',
					visible: false
				},
				{
					id: 'address2',
					width: '0',
					visible: false
				},
				{
					id: 'address3',
					width: '0',
					visible: false
				},
				{
					id: 'remarks',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks1',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks2',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks3',
					width: '0',
					visible: false
				},
				{
					id: 'riAcceptBy',
					width: '0',
					visible: false
				},
				{
					id: 'riAsNo',
					width: '0',
					visible: false
				},
				{
					id: 'riAcceptDate',
					width: '0',
					visible: false
				}
			],
// 			resetChangeTag: true, remove by steven 12/13/2012
			rows: objWFrpsRi.wFrpsRi
		};

		frpsRiGrid = new MyTableGrid(wFrpsRiTable);
		frpsRiGrid.pager = objWFrpsRi.wFrpsRiTableGrid;
		frpsRiGrid.render('wfrpsRITableGrid');

	}catch(e) {
		showErrorMessage("frpsRiGrid", e);
	}

	try {
		objFrPeril = new Object();
		objFrPeril = []; //added by steven 10/09/2012
		var wFrperilTable = {
			url: frPerilTableURL,
			options: {
				title: '',
				//width: '800px',
				height: '150px',
				//align: 'center',
				onCellFocus: function(element, value, x, y, id) {
					selectedFrperil = Number(y);
					//selectedFrperilRow = frPerilGrid.geniisysRows[y];
					selectedFrperilRow = frPerilGrid.getRow(y);
					
					perilIdOnFocus = id;
					supplyPeril(selectedFrperilRow);//niknok
					
					if(!frPerilUpdated) selectedFrpsRiRow = selectedFrpsRiRowTemp;
					frPerilGrid.releaseKeys();
				}, 
				onCellBlur: function(element, value, x, y, id){
					observeChangeTagInTableGrid(frPerilGrid);
				},
				onRemoveRowFocus: function() {
					if(!frPerilUpdated) selectedFrpsRiRow = selectedFrpsRiRowTemp;
					selectedFrperil = null;
					supplyPeril(null);//niknok
					isChanged = false;	//kenneth 09.07.2015 SR 0011416
				}	
			},
			columnModel : [
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
				{	
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'frpsYy',
					width: '0',
					visible: false
				},
				{
					id: 'frpsSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riCd',
					width: '0',
					visible: false
				},
				{
					id: 'perilCd',
					width: '0',
					visible: false
				},
				{
					id: 'perilSname',
					width: '0',
					visible: false
				},
				{
					id: 'perilName',
					width: '138px',
					title: 'Peril',
					align: 'left',
					titleAlign: 'left',
					editable: false
				},
				{
					id: 'riShrPct',
					width: '120px',
					title: 'RI Share %',
					align: 'right',
					titleAlign: 'right',
					editable: false
				},
				{
					id: 'riTsiAmt',
					width: '120px',
					title: 'RI TSI Amount',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					editable: false,//niknok (fnlBinderId == null ? true : false),
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 ) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							}
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcPerilRiShrPct(editedPerilRow, y);
								calcPerilRiPremAmt(editedPerilRow, y);
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiPremAmt(editedPerilRow);	
								calcSumRiTsiAmt(editedPerilRow);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiPremAmt();
								calcFrpsRiTsiAmt();
								calcFrpsRiShrPct();
								calcFrpsRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(frpsRiGrid.getRow(y));
							}
							return result;
						}
					})
				},
				{
					id: 'riPremAmt',
					width: '120px',
					title: 'RI Premium Amt',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					editable: false,//niknok (fnlBinderId == null ? true : false), 
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 ) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							}
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								if(parseFloat(sveRiPremAmt) != parseFloat(value)) {
									getInputVatRate(editedPerilRow.riCd);
									var tempVat = unformatCurrencyValue(value)*parseFloat($F("inputVatRate"))/100;
									frPerilGrid.setValueAt(adjustPremVat(tempVat), 
											frPerilGrid.getColumnIndex('riPremVat'),y, true);
									
								}
																		
								calcPerilRiShrPct2(editedPerilRow, y);	
								calcPerilRiTsiAmt(editedPerilRow, y);	
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiPremAmt(editedPerilRow);	
								calcSumRiTsiAmt(editedPerilRow);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiPremAmt();
								calcFrpsRiTsiAmt();
								calcFrpsRiShrPct();
								calcFrpsRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(editedPerilRow);
							}
							return result;
						}
					})
				},
				{	
					id: 'riCommRt',
					width: '120px',
					title: 'RI Commission %',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'rate',
					geniisysMinValue: '0.00',
					geniisysMaxValue: '100.00',
					geniisysErrorMsg: 'Entered comm rate is invalid. Valid value is from 0.00 to 100.',
					editable: false,
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 || parseFloat(value) >= 100) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riCommRt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							} 
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommAmt2(y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(editedPerilRow);
							}
							return result;
						}
					}) 
				},
				{
					id: 'riPremVat',
					width: '120px',
					title: 'RI Prem VAT',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					editable: false,
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremVat')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							} 		
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcSumRiPremVat(editedPerilRow);
								calcFrpsRiPremVat();
							}
							return result;
						}
					})
				},
				{
					id: 'premTax',
					width: '120px',
					title: 'RI Prem Tax',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'money',
					editable: false,
					defaultValue: "0.00"
				},
				{
					id: 'riCommVat',
					width: '0',
					visible: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommAmt',
					width: '0',
					visible: false
				},
				{
					id: 'distTsi',
					width: '0',
					visible: false
				},
				{
					id: 'distPrem',
					width: '0',
					visible: false
				},
				{
					id: 'premAmt',
					width: '0',
					visible: false
				},
				{
					id: 'tsiAmt',
					width: '0',
					visible: false
				}
			],
// 			resetChangeTag: true, remove by steven 12/13/2012
			rows: objWFrperil.frPeril
		};

		frPerilGrid = new MyTableGrid(wFrperilTable);
		frPerilGrid.pager = objWFrperil.frPerilTableGrid;
		frPerilGrid.render('frPerilTableGrid');
		frPerilGrid.afterRender = function(){ //added by steven 10/09/2012
												for ( var i = 0; i < objFrPeril.length; i++) {
													for ( var j = 0; j < frPerilGrid.geniisysRows.length; j++) {
														if(objFrPeril[i].perilCd == frPerilGrid.geniisysRows[j].perilCd && objFrPeril[i].frpsSeqNo == frPerilGrid.geniisysRows[j].frpsSeqNo && objFrPeril[i].riCd == frPerilGrid.geniisysRows[j].riCd && objFrPeril[i].riSeqNo == frPerilGrid.geniisysRows[j].riSeqNo){
															frPerilGrid.setValueAt(objFrPeril[i].riShrPct, frPerilGrid.getColumnIndex('riShrPct'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].riTsiAmt, frPerilGrid.getColumnIndex('riTsiAmt'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].riPremAmt, frPerilGrid.getColumnIndex('riPremAmt'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].riCommRt, frPerilGrid.getColumnIndex('riCommRt'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].riPremVat, frPerilGrid.getColumnIndex('riPremVat'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].premTax, frPerilGrid.getColumnIndex('premTax'), j, true);
															frPerilGrid.setValueAt(objFrPeril[i].riCommAmt, frPerilGrid.getColumnIndex('riCommAmt'), j, true);
														}	
													}
												}
											};
	} catch(e) {
		showErrorMessage("setFrperilGrid", e);
	}

	observeReloadForm("reloadForm", 
			function() {
				if($F("loadFromUWMenu") == "Y") objRiFrps = new Object();
				showEnterRIAcceptancePage($F("loadFromUWMenu"));
			});

	$("searchWFrpsRi").observe("click", function() {
		showDistFrpsLOV("getGIRIDistFrpsLOV", "GIRIS002", saveRiAcceptance);
	});

	$("btnUpdate").observe("click", function() {
		if(!frPerilUpdated) {
			selectedFrpsRiRow = selectedFrpsRiRowTemp;
		}
		selectedFrpsRiRow.address1			=	escapeHTML2($F("txtAddress1"));	
		selectedFrpsRiRow.address2			=	escapeHTML2($F("txtAddress2"));	//change by steven 10/16/2012
		selectedFrpsRiRow.address3			=	escapeHTML2($F("txtAddress3"));	//change by steven 10/16/2012
		selectedFrpsRiRow.remarks			=	escapeHTML2($F("txtRemarks"));
		selectedFrpsRiRow.bndrRemarks1		=	escapeHTML2($F("txtBinder1"));
		selectedFrpsRiRow.bndrRemarks2		=	escapeHTML2($F("txtBinder2"));
		selectedFrpsRiRow.bndrRemarks3		=	escapeHTML2($F("txtBinder3"));
		selectedFrpsRiRow.riAcceptBy		=	escapeHTML2($F("txtAcceptedBy"));
		selectedFrpsRiRow.riAsNo			=	$F("txtASNo");
		selectedFrpsRiRow.riAcceptDate		=	$F("txtAcceptDate");
		frpsRiGrid.updateRowAt(selectedFrpsRiRow, selectedFrpsRi);
		setWFrpsRiAddtlInfo(null);
		frPerilGrid.empty();
		supplyPeril(null);
		changeTag = 1;
		//frpsRiGrid.modifiedRows.push(selectedFrpsRiRow);
	});
	
	$("btnCancel").observe("click", function () {	
		//if($F("loadFromUWMenu") == "Y") objRiFrps = new Object();		comment out by Gzelle 10.21.2013
		//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		if (changeTag == 1) {
			objRiFrps.cancelGIRIS002 = true;
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function() {
						saveRiAcceptance();
					}, function() {
						changeTag = 0;
						cancelFunc();
					},"","");
		}else {
			cancelFunc();
		}
	});

	function cancelFunc() {
		var lineName = "";
		if (objRiFrps.lineName == null) {
			lineName = objRiFrps.lineCd;
		}else {
			lineName = objRiFrps.lineName;
		}
		if ($F("loadFromUWMenu") == "Y") {
	 		objRiFrps = new Object();
	 		objRiFrps.loadFromGIRIS002 = "N";
	 		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	 	}else {
	 		updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+lineName,
	 		  "Getting FRPS listing, please wait...");
	 	}
	}

	function refreshRiAcceptancePage(){ // added by: Nica 10.04.2012 - to refresh page which is called after saving
		frpsRiGrid.clear();
		frpsRiGrid.refresh();
		
		wFrperilTable.url = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+0
		+"&lineCd="+""+"&frpsSeqNo="+0+"&riSeqNo="+0+"&riCd="+0+"&distNo="+0+"&distSeqNo="+0;

		frPerilGrid.refreshURL(wFrperilTable);
		frPerilGrid.refresh();
		supplyPeril(null);//niknok
		setWFrpsRiAddtlInfo(null);
		selectedFrpsRiRowTemp = null;
		
		sumRiCommAmt = 0;
		sumRiPremAmt = 0;
		sumRiTsiAmt = 0;
		sumRiPremVat = 0;
		disableButton("btnRecompute");
		disableButton("btnRecomputeRiComm"); // Vincent 201604-08 SR-4797
		selectedFrpsRi = null;
		fnlBinderId = null;
	}

	function saveRiAcceptance() {
 		try {
 			if(checkPendingRecordChanges()){		
 				var objParameters = new Object();
 	 			objParameters.setFrpsRi = frpsRiGrid.getModifiedRows();
 	 			objParameters.setFrperil = getAddedAndModifiedJSONObjects(objFrPeril); //change by steven 10/10/2012
// 	  			objParameters.setFrperil = frPerilGrid.getModifiedRows();	//comment-out by steven 10/10/2012 -it has an error on multiple saving.
 	 			var param = JSON.stringify(objParameters);
 				new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
 					method: "POST",
 					parameters: {
 						action : "saveRIAcceptace",
 						parameters: param
 					},
 					asychronous: false,
 					evalScripts: true,
 					onCreate: function() {
 						showNotice("Saving RI Acceptance");
 					},
 					onComplete: function(response) {
 						hideNotice("");
 						changeTag = 0;
 						if(checkErrorOnResponse(response)) {
 							//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS); // replaced by: Nica 10.04.2012
 							//showEnterRIAcceptancePage();
 							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
 								objFrPeril = [];
 								refreshRiAcceptancePage();
 								if (objRiFrps.cancelGIRIS002) {
 									cancelFunc();
 									objRiFrps.cancelGIRIS002 = false;
								}else if (gotoMenu == "C") {
									showCreateRiPlacementPage();
									gotoMenu = "";
								}else if (gotoMenu == "F") {
									updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
									  "Getting FRPS listing, please wait...");
									gotoMenu = "";
								}
 							});
 						} else {
 							showMessageBox(response, "e");
 						}
 					}
 				});
 			}
 		} catch(e) {
			showErrorMessage("saveRiAcceptance", e);
 		}
	}

	$("btnSave").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, 'I');
		} else {
			saveRiAcceptance();
		}
	});

	function computeNetDue() {
		try {
			/* var premAmt = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riPremAmt"), selectedFrpsRi));
			var premTax = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("premTax"), selectedFrpsRi));
			var commAmt = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riCommAmt"), selectedFrpsRi));
			var premVat = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riPremVat"), selectedFrpsRi));
			var commVat = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riCommVat"), selectedFrpsRi));
			 */
				var premAmt = parseFloat(nvl(selectedFrpsRiRow.riPremAmt,"0"));
				var premTax = parseFloat(nvl(selectedFrpsRiRow.premTax,"0"));
				var commAmt = parseFloat(nvl(selectedFrpsRiRow.riCommAmt,"0"));
				var premVat = parseFloat(nvl(selectedFrpsRiRow.riPremVat,"0"));
				var commVat = parseFloat(nvl(selectedFrpsRiRow.riCommVat,"0"));
				
			
			selectedFrpsRiRow.netDue = premAmt - premTax - commAmt + premVat - commVat;
		} catch(e) {
			showErrorMessage("computeNetDue", e);
		}
	}

	//compute_sum_d110_ri_comm_amt
	function calcSumRiCommAmt() {
		var y = String(selectedFrperil);
		// for some reason wala ung computation para sa column ng riCommAmt, based sa 8.26.2011 eh merun - irwin
		/*var riCommAmt = (parseFloat(nvl(selectedFrperilRow.riCommRt,"0")) / 100) * parseFloat(selectedFrperilRow.riPremAmt);
		frPerilGrid.setValueAt(riCommAmt, frPerilGrid.getColumnIndex('riCommAmt'), y, true);*/
		
		//sumRiCommAmt = parseFloat(sumRiCommAmt) - sveRiCommAmt + parseFloat(selectedFrperilRow.riCommAmt);
		sumRiCommAmt = parseFloat(sumRiCommAmt) - parseFloat(sveRiCommAmt) + parseFloat(selectedFrperilRow.riCommAmt);
		sumRiCommAmt = (Math.round(sumRiCommAmt * Math.pow(10, 9)) / Math.pow(10, 9));
		$("sumRiCommAmt").value = sumRiCommAmt;
	}

	function calcSumRiPremAmt(row) {
		sumRiPremAmt = parseFloat(sumRiPremAmt) - sveRiPremAmt + parseFloat(selectedFrperilRow.riPremAmt);
		$("sumRiPremAmt").value = sumRiPremAmt;
	}

	function calcSumRiTsiAmt(row) {
		sumRiTsiAmt = parseFloat(sumRiTsiAmt) - sveRiTsiAmt + parseFloat(selectedFrperilRow.riTsiAmt);
		$("sumRiTsiAmt").value = sumRiTsiAmt;
	}

	function calcSumRiPremVat(row) {
		sumRiPremVat = parseFloat(sumRiPremVat) - sveRiPremVat + parseFloat(selectedFrperilRow.riPremVat);
		$("sumRiPremVat").value = sumRiPremVat;
	}

	function calcFrpsRiCommAmt2() {
		//var temp = roundNumber(parseFloat(sumRiCommAmt), 2); bonok :: 11.27.2012
		var temp = parseFloat(sumRiCommAmt);
		selectedFrpsRiRow.riCommAmt = temp;
		vCommAmt = temp;
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
		selectedFrpsRiRow.riCommVat = parseFloat(selectedFrpsRiRow.riCommAmt) * (parseFloat($F("inputVatRate"))/100);
	}

	function calcFrpsRiCommAmt() {
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
		selectedFrpsRiRow.riCommAmt = sumRiCommAmt;
		selectedFrpsRiRow.riCommVat = parseFloat(selectedFrpsRiRow.riCommAmt)*parseFloat($F("inputVatRate"))/100;
	}

	function calcFrpsRiCommRt() {
		var temp = 0;
		if(selectedFrpsRiRow.riPremAmt != null || selectedFrpsRiRow.riPremAmt != 0) {
			temp = (nvl(vCommAmt, roundNumber(selectedFrpsRiRow.riCommAmt,2)) / selectedFrpsRiRow.riPremAmt) * 100; // modified, added vCommAmt. irwin
		}else{
			temp = 0;
		}
		selectedFrpsRiRow.riCommRt = temp;
	}

	function calcFrpsRiPremAmt() {
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
		
		selectedFrpsRiRow.riPremAmt = sumRiPremAmt;
		var riPremVat = (parseFloat(sumRiPremAmt) * parseFloat($F("inputVatRate"))/100);
		selectedFrpsRiRow.riPremVat = adjustPremVat(riPremVat);
	}

	function calcFrpsRiPremVat() {
		selectedFrpsRiRow.riPremVat = sumRiPremVat;
		riPremVatN = sumRiPremVat;
	}

	function calcFrpsRiShrPct() {
		var temp = 0;//
		if($F("totalTsi") != "" && parseFloat($F("totalTsi")) != 0) {
			temp = parseFloat(selectedFrpsRiRow.riTsiAmt) / unformatCurrencyValue($F("totalTsi"));
		}
		selectedFrpsRiRow.riShrPct = temp*100;
	}

	function calcFrpsRiTsiAmt() {
		selectedFrpsRiRow.riTsiAmt = sumRiTsiAmt;
		$("frpsRiTsiAmt").value = sumRiTsiAmt;
	}

	function calcPerilRiCommAmt() {
		var rate = selectedFrperilRow.riCommRt == null ? 0 : selectedFrperilRow.riCommRt;
		rate = (Math.round((rate/100) * Math.pow(10, 14)) / Math.pow(10, 14));
		var temp = (rate)*selectedFrperilRow.riPremAmt;
		selectedFrperilRow.riCommAmt = temp;
	}

	function calcPerilRiShrPct2() {
		var temp = 0;
		if(selectedFrperilRow.distPrem == null || selectedFrperilRow.distPrem == 0) {
			temp = 0;
		} else {
			temp = (selectedFrperilRow.riPremAmt / selectedFrperilRow.distPrem) * 100;	
		}
		//frPerilGrid.setValueAt(temp, frPerilGrid.getColumnIndex('riShrPct'), index, true);
		selectedFrperilRow.riShrPct = temp;
		$("txtRiShrPct").value = formatToNthDecimal(temp,8);
	}

	function calcPerilRiShrPct() {
		var temp = 0;
		if(selectedFrperilRow.distTsi != null || selectedFrperilRow.distTsi != 0) {
			temp = (parseFloat(selectedFrperilRow.riTsiAmt)/parseFloat(selectedFrperilRow.distTsi))*100;
		}
		selectedFrperilRow.riShrPct = temp;
		$("txtRiShrPct").value = formatToNthDecimal(temp,8);
	}

	function calcPerilRiPremAmt() {
		selectedFrperilRow.riPremAmt = selectedFrperilRow.distPrem;
		$("txtRiPremAmt").value = formatCurrency(selectedFrperilRow.distPrem);		
	}

	function calcPerilRiTsiAmt() {
		if(selectedFrperilRow.distTsi != null || selectedFrperilRow.distTsi != 0) {
			selectedFrperilRow.riTsiAmt = (selectedFrperilRow.riShrPct/100)*selectedFrperilRow.distTsi;	
			$("txtRiTsiAmt").value = formatCurrency(selectedFrperilRow.riTsiAmt);
		} else {
			selectedFrperilRow.riTsiAmt = unformatCurrency("txtRiTsiAmt");
		}
	}

	function getInputVatRate(riCd) {
		var vatRate = $F("inputVatRate");
		if($F("inputVatRate") == "" && riCd != null) {
			new Ajax.Request(contextPath+"/GIISReinsurerController", {
				method: "GET",
				parameters:{
					action: "getReinsurerVatRt",
					riCd: riCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					vatRate = response.responseText;
					$("inputVatRate").value = vatRate;
				}
			});
		} else if(riCd == null) {
			vatRate = 0;
			$("inputVatRate").value = 0;
		}
		//return vatRate;
	}
	
	function adjustPremVat(riPremVat) {
		try {
			var riCd = selectedFrpsRiRow.riCd;
			var pPremVat = 0;
			if($F("adjustPremVat") == "" && riCd != null) {
				getAdjustPremVatParam(riCd);
			}
			
			var adjustPremVat = $F("adjustPremVat");
			if(adjustPremVat == "0") {
				pPremVat = 0;
			} else if (adjustPremVat == "1") {
				if($F("vStatus") == "c") {
					pPremVat = riPremVatN;
				} else {
					pPremVat = riPremVatO; 
				}
			} else if (adjustPremVat == "2") {
				if($F("vStatus") == "c") {
					pPremVat = riPremVatN;
				} else if (pPremVat != riPremVatO) {
					pPremVat = riPremVatO;
				} else {
					pPremVat = riPremVat;
				}
			} 
			return pPremVat;
		} catch(e) {
			showErrorMessage("adjustPremVat", e);
		}
	}
	
	function getAdjustPremVatParam(riCd) {
		try {
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
				method: "POST",
				parameters: {
					action: "getAdjustPremVatParam",
					riCd: riCd,
					lineCd: objRiFrps.lineCd,
					issCd: objRiFrps.issCd,
					parYy: objRiFrps.parYy,
					parSeqNo: objRiFrps.parSeqNo,
					sublineCd: objRiFrps.sublineCd,
					renewNo: objRiFrps.renewNo,
					polSeqNo: objRiFrps.polSeqNo,
					issueYy: objRiFrps.issueYy,
					riPremVat: 0
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var premVatParam = JSON.parse(response.responseText);
					$("adjustPremVat").value = premVatParam.riPremVat;
				}
			});
		} catch(e) {
			showErrorMessage("getAdjustPremVatParam", e);
		}
	}

	$("btnRecompute").observe("click", function() {
		if($F("frpsNo") != "" && selectedFrpsRi != null) {
			$("selectedFrpsRi").value = selectedFrpsRi;
			overlayPolicyNumber = Overlay.show(contextPath+"/GIRIWFrpsRiController", {
				urlContent: true,
				urlParameters: {
					action: "loadRecomputeVatPage",
					vat: ""
				},
				title: "VAT Rate",
				height: 120,
				width: 300,
				draggable: true
			});
		} else if (selectedFrpsRi == null){
			showMessageBox();
		}
	});

	objGIRIS002.saveRiAcceptance = saveRiAcceptance;
	<!-- Added by Vincent 201604-06 SR-4797-->
	$("btnRecomputeRiComm").observe("click", function() {
		if($F("frpsNo") != "" && selectedFrpsRi != null) {
			$("selectedFrpsRi").value = selectedFrpsRi;
			frPerilGrid.refreshURL(wFrperilTable);
			frPerilGrid.refresh();
			supplyPeril(null);
			getInputVatRate(selectedFrpsRiRow.riCd);
			overlayPolicyNumber = Overlay.show(contextPath+"/GIRIWFrpsRiController", {
				urlContent: true,
				urlParameters: {
					action: "loadRecomputeRiCommPage"
				},
				title: "RI Commission Rate",
				height: 120,
				width: 300,
				draggable: true
			});
		} else if (selectedFrpsRi == null){
			showMessageBox("Please select FRPS RI first.", imgMessage.INFO);
		}
	});
	
	
	var premVatNew = null;
		
	function validateFrpsPosting() { // added by: Nica 06.19.2012 - to check if FRPS posting is allowed
		try {
			var obj = new Object();
			obj.lineCd		= objRiFrps.lineCd;
			obj.frpsYy		= objRiFrps.frpsYy;
			obj.frpsSeqNo	= objRiFrps.frpsSeqNo;
			obj.distNo		= objRiFrps.distNo;
			obj.distSeqNo	= objRiFrps.distSeqNo;
			
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
				method: "GET",
				parameters: {
					action: "validateFrpsPosting",
					parameters: JSON.stringify(obj)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response)) {
						if(response.responseText == null || response.responseText == "") {
							objGIRIS002.status = status;
							objGIRIS002.sveRiPremVat = sveRiPremVat;
							showPostingRi();
						} else {
							showMessageBox(response.responseText, "E");
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("validateFrpsPosting", e);
		}
	}

	function validateBinderPrinting() {
		try {
			var obj = new Object();
			obj.lineCd		= objRiFrps.lineCd;
			obj.frpsYy		= objRiFrps.frpsYy;
			obj.frpsSeqNo	= objRiFrps.frpsSeqNo;
			obj.distNo		= objRiFrps.distNo;
			obj.distSeqNo	= objRiFrps.distSeqNo;
			
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
				method: "GET",
				parameters: {
					action: "validateBinderPrinting",
					parameters: JSON.stringify(obj)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response)) {
						if(response.responseText == null || response.responseText == "") {
							//createBinders("PRINT");
						} else {
							showMessageBox(response.responseText, "E");
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("validateBinderPrinting", e);
		}
	}
	
/* 	
 remove by steven 1/8/2013 base on SR 0011416
  $("btnPrint").observe("click", function() {
		if(changeTag != 0) {
			showMessageBox("Please save the changes first...");
		} else {
			validateBinderPrinting();
		}
	}); */
	
	$("btnPrint").observe("click", function(){
		if(changeTag != 0)
			showMessageBox("Please save changes first before printing.");
		else
			showGenericPrintDialog("Print Sample Binder", function(){
				var content = contextPath+"/UWReinsuranceReportPrintController?action=printSampleBinder&preBinderId="+ preBinderId +
				"&reportId=GIRIR001D&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
				printGenericReport(content, "SAMPLE BINDER");
			}, "");
	});
	
	$$("div#"+"riPerilListDiv"+" input[type='text']").each(function (m) {	//start kenneth 09.07.2015 SR 0011416
		$(m.id).observe("change", function() {
 			isChanged = true;
		});
	});
	
	$("btnPost").observe("click", function() {
		if(changeTag != 0 || isChanged) { //added by steven 12/13/2012 base on SR 0011416
			showMessageBox("Please save the changes first.");	//end kenneth 09.07.2015 SR 0011416
		} else {
			//createBinders("POST"); replaced by: Nica 06.19.2012
			if(!checkUserModule('GIRIS026')){ // bonok :: 10.17.2013 :: SR473 - GENQA
				showMessageBox("You are not allowed to access this module.", "E");
				return false;	
			}
			validateFrpsPosting();
		}
	});
	
	// moved here from supplyPeril, to permanently disable the fields based on QA SR 9582 
	$("txtRiShrPct").readOnly = true;
	$("txtRiTsiAmt").readOnly = true;
	$("txtRiPremAmt").readOnly = true;
	
	function supplyPeril(obj){
		try{
			$("txtPerilName").value = nvl(obj,null) == null ? null :unescapeHTML2(obj.perilName);
			$("txtRiShrPct").value 	= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riShrPct,8);
			$("txtRiTsiAmt").value 	= nvl(obj,null) == null ? null :formatCurrency(obj.riTsiAmt);
			$("txtRiPremAmt").value = nvl(obj,null) == null ? null :formatCurrency(obj.riPremAmt);
			$("txtRiCommRt").value 	= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riCommRt,9);
			$("txtRiPremVat").value = nvl(obj,null) == null ? null :formatCurrency(obj.riPremVat);
			$("txtPremTax").value 	= nvl(obj,null) == null ? null :formatCurrency(nvl(obj.premTax,"0.00"));
			
			sveRiShrPct = nvl(obj,null) == null ? null :parseFloat(obj.riShrPct);
			sveRiPremAmt = nvl(obj,null) == null ? null :parseFloat(obj.riPremAmt);
			sveRiCommAmt = nvl(obj,null) == null ? null :parseFloat(obj.riCommAmt); 
			sveRiCommAmt = (Math.round(sveRiCommAmt * Math.pow(10, 9)) / Math.pow(10, 9));
			//sveRiCommAmt = nvl(obj,null) == null ? null :parseFloat(obj.riPremAmt * (obj.riCommRt / 100)); // bonok :: 06.13.2013 :: recomputed for sveRiCommAmt to get a value that is not rounded off
			sveRiTsiAmt = nvl(obj,null) == null ? null :unformatCurrencyValue(obj.riTsiAmt);
			sveRiCommRt = nvl(obj,null) == null ? null :parseFloat(obj.riCommRt);
			sveRiPremVat = nvl(obj,null) == null ? null :parseFloat(obj.riPremVat);
			
			if(nvl(obj,null) == null){
				
				/* $("txtRiShrPct").readOnly = true;
				$("txtRiTsiAmt").readOnly = true;
				$("txtRiPremAmt").readOnly = true; */
				$("txtRiCommRt").readOnly = true;
				//$("txtRiPremVat").readOnly = true; // andrew - according to jhing, this field should always be readonly
				//$("txtPremTax").readOnly = true; // andrew - according to jhing, this field should always be readonly
				disableButton("btnRecompute");
				($$("div#riPerilListMainDiv [changed=changed]")).invoke("removeAttribute", "changed"); //added by steven 1/3/2013
				disableButton("btnUpdatePeril");
			}else {
				if (fnlBinderId == null){
					enableButton("btnUpdatePeril");
				}else{
					disableButton("btnUpdatePeril");
				}	
				//$("txtRiShrPct").readOnly = fnlBinderId == null ? false :true;
				//$("txtRiTsiAmt").readOnly = fnlBinderId == null ? false :true;
				//$("txtRiPremAmt").readOnly = fnlBinderId == null ? false :true;
				$("txtRiCommRt").readOnly = fnlBinderId == null ? false :true;
				//$("txtRiPremVat").readOnly = fnlBinderId == null ? false :true; // andrew - according to jhing, this field should always be readonly
				//$("txtPremTax").readOnly = fnlBinderId == null ? false :true; // andrew - according to jhing, this field should always be readonly
			}	
		}catch(e){
			showErrorMessage("supplyPeril",e);	
		}	
	}
	
	$("txtRiShrPct").observe("change", function(){
		if (selectedFrperil == null) return;
		selectedFrperilRow.riShrPct = parseFloat($F("txtRiShrPct"));
		if(selectedFrperilRow.riShrPct != sveRiShrPct) {
			calcPerilRiPremAmt();
			calcPerilRiTsiAmt();
			calcPerilRiCommAmt();
			calcSumRiPremAmt();
			calcSumRiTsiAmt();
			calcSumRiCommAmt();
			calcFrpsRiPremAmt();
			calcFrpsRiTsiAmt();
			calcFrpsRiShrPct();
			calcFrpsRiCommAmt();
			calcFrpsRiCommRt();
			computeNetDue();
		}
	});	
	
	$("txtRiTsiAmt").observe("change", function(){
		if (selectedFrperil == null) return;
		var value = unformatCurrency("txtRiTsiAmt");
		selectedFrperilRow.riTsiAmt = value;
		if(sveRiPremAmt != value) {
			calcPerilRiShrPct();
			calcPerilRiPremAmt();
			calcPerilRiCommAmt();
			calcSumRiPremAmt();
			calcSumRiTsiAmt();
			calcSumRiCommAmt();
			calcFrpsRiPremAmt();
			calcFrpsRiTsiAmt();
			calcFrpsRiShrPct();
			calcFrpsRiCommAmt();
			calcFrpsRiCommRt();
			computeNetDue();
		}
	});
	
	$("txtRiPremAmt").observe("change", function(){
		if (selectedFrperil == null) return;
		var value = unformatCurrency("txtRiPremAmt");
		selectedFrperilRow.riPremAmt = value;
		
		if(parseFloat(sveRiPremAmt) != parseFloat(value)) {
			getInputVatRate(selectedFrperilRow.riCd);
			var tempVat = value*parseFloat($F("inputVatRate"))/100;
			selectedFrperilRow.riPremVat = adjustPremVat(tempVat);
			$("txtRiPremVat").value = formatCurrency(selectedFrperilRow.riPremVat);
			
			calcPerilRiShrPct2();	
			calcPerilRiTsiAmt();	
			calcPerilRiCommAmt();
			calcSumRiPremAmt();
			calcSumRiTsiAmt();
			calcSumRiCommAmt();
			calcFrpsRiPremAmt();
			calcFrpsRiTsiAmt();
			calcFrpsRiShrPct();
			calcFrpsRiCommAmt();
			calcFrpsRiCommRt();
			computeNetDue();
		}
	});	
	
	// commented out by christian 09212012 - moved into btnUpdatePeril click function
/* 	$("txtRiCommRt").observe("change", function(){
		// area 2
		if (selectedFrperil == null) return;
		selectedFrperilRow.riCommRt = parseFloat($F("txtRiCommRt"));
		if(selectedFrperilRow.riCommRt != sveRiCommRt) {
			calcPerilRiCommAmt();
			calcSumRiCommAmt();
			calcFrpsRiCommAmt2();
			calcFrpsRiCommRt(); 
			computeNetDue();
		}
	});	 */
	
	$("txtRiPremVat").observe("change", function(){
		if (selectedFrperil == null) return;
		if(unformatCurrency("txtRiPremVat") > unformatCurrency("txtRiPremAmt")) {
			//showMessageBox("Ri Premium Vat must not be greater than the Ri Premium Amount.");
			showMessageBox("Invalid RI Prem VAT. Valid value should be from -9,999,999,999.99 to "+formatCurrency("txtRiPremAmt")+".");
			$("txtRiPremVat").value = formatCurrency(selectedFrperil.riPremVat);
			return;
		}
		// commented out by christian 09212012 - moved into btnUpdatePeril click function
		/* selectedFrperilRow.riPremVat = unformatCurrency("txtRiPremVat");
		if(sveRiPremVat != selectedFrperilRow.riPremVat) {
			calcSumRiPremVat();
			calcFrpsRiPremVat();
			status = "CHANGED";
		} */
	});	

	$("txtPremTax").observe("change", function(){
		if (selectedFrperil == null) return;
		selectedFrperilRow.premTax = nvl(unformatCurrency("txtPremTax"), 0);
	});	
	
	function updateWfrpsRiAmounts() {
		try {
			
		} catch(e) {
			showErrorMessage("updateWfrpsRiAmounts", e);
		}
	}
	
	$("btnUpdatePeril").observe("click", function(){ 
		try {
			if (selectedFrperil == null) return;
			//added by christian
			selectedFrperilRow.riCommRt = parseFloat(nvl($F("txtRiCommRt"), 0));
			var y = String(selectedFrperil);
			if(selectedFrperilRow.riCommRt != sveRiCommRt) {
				//irwin
				new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {// GET_TSI_PREM_AMT
					method: "POST",
					parameters: {
						action: "getTsiPremAmt",
						distNo: objRiFrps.distNo,
						distSeqNo: objRiFrps.distSeqNo,
						perilCd: selectedFrperilRow.perilCd
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						var res  = response.responseText.toQueryParams();
						frPerilGrid.setValueAt(res.premAmt, frPerilGrid.getColumnIndex('premAmt'), y, true);
						frPerilGrid.setValueAt(res.tsiAmt, frPerilGrid.getColumnIndex('tsiAmt'), y, true);
						calcPerilRiCommAmt();
						calcSumRiCommAmt();
						calcFrpsRiCommAmt2();
						calcFrpsRiCommRt();
						computeNetDue();
						
						//var tempComVat = parseFloat(selectedFrperilRow.riCommVat);
						selectedFrperilRow.riCommVat = parseFloat(selectedFrperilRow.riCommAmt) * (parseFloat($F("inputVatRate")) /100);
					}
				});
			}
			
			selectedFrperilRow.riPremVat = nvl(unformatCurrency("txtRiPremVat"), 0);
			if(sveRiPremVat != selectedFrperilRow.riPremVat) {
				calcSumRiPremVat();
				calcFrpsRiPremVat();
				computeNetDue(); //marco - 04.18.2013
				status = "CHANGED";
			}
			// area 1
			//frPerilGrid.updateVisibleRowOnly(selectedFrperilRow, y, false);
			frPerilGrid.setValueAt(selectedFrperilRow.riShrPct, frPerilGrid.getColumnIndex('riShrPct'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riTsiAmt, frPerilGrid.getColumnIndex('riTsiAmt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riPremAmt, frPerilGrid.getColumnIndex('riPremAmt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riCommRt, frPerilGrid.getColumnIndex('riCommRt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riPremVat, frPerilGrid.getColumnIndex('riPremVat'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.premTax, frPerilGrid.getColumnIndex('premTax'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riCommAmt, frPerilGrid.getColumnIndex('riCommAmt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riCommVat, frPerilGrid.getColumnIndex('riCommVat'), y, true);// added by irwin
			//added by steven 10/09/2012
			selectedFrperilRow.recordStatus = 1;
			var cnt = -1;
 			for ( var i = 0; i < objFrPeril.length; i++) {
				if(objFrPeril[i].perilCd == selectedFrperilRow.perilCd && objFrPeril[i].frpsSeqNo == selectedFrperilRow.frpsSeqNo && objFrPeril[i].riCd == selectedFrperilRow.riCd && objFrPeril[i].riSeqNo == selectedFrperilRow.riSeqNo){
					cnt = i;
				}	
			}
 			if(cnt == -1){
 				objFrPeril.push(selectedFrperilRow);
 			}else{
 				objFrPeril.splice(cnt, 1, selectedFrperilRow);
 			}
			//end steve
			
			frPerilGrid.unselectRows();
			
			frPerilUpdated = true;
			selectedFrpsRiRowTemp = selectedFrpsRiRow;
			//frpsRiGrid.updateVisibleRowOnly(selectedFrpsRiRow, selectedFrpsRi, true);
			frpsRiGrid.updateRowAt(selectedFrpsRiRow, selectedFrpsRi, true);
			setWFrpsRiAddtlInfo(selectedFrpsRiRow);
			
			supplyPeril(null);
			isChanged = false;	//kenneth 09.07.2015 SR 0011416
			changeTag = 1;
		} catch(e) {
			showErrorMessage("btnUpdatePeril", e);
		}
	});	
	
	supplyPeril(null);
	//end ni niknok

	initializeChangeTagBehavior(saveRiAcceptance); 
	initializeChangeAttribute();
	
	//Gzelle 10.21.2013
	$("riExit").stopObserving("click");
	$("riExit").observe("click", function() {
		if (changeTag == 1) {
			objRiFrps.cancelGIRIS002 = true;
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function() {
						saveRiAcceptance();
					}, function() {
						changeTag = 0;
						cancelFunc();
					},"","");
		}else {
			cancelFunc();
		}
	});
	var gotoMenu = "";
	$("createRiPlacement").stopObserving("click");
	$("createRiPlacement").observe("click", function() {
		if (changeTag == 1) {
			gotoMenu = "C";
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function() {
						saveRiAcceptance();
					}, function() {
						changeTag = 0;
						showCreateRiPlacementPage();
					},"","");
		}else {
			showCreateRiPlacementPage();
		}
	});
	
	$("frpsListing").stopObserving("click");
	$("frpsListing").observe("click", function() {
		if (changeTag == 1) {
			gotoMenu = "F";
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function() {
						saveRiAcceptance();
					}, function() {
						changeTag = 0;
						updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
						  "Getting FRPS listing, please wait...");
					},"","");
		}else {
			updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
			  "Getting FRPS listing, please wait...");
		}
	});
</script>