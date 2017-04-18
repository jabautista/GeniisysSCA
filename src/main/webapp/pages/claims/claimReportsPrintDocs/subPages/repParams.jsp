<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div class="sectionDiv" id="repListDivMain" style=" height: 300px; width: 320px; margin-left:5px; float: left;">
	<div id="reportsListDiv" style="height:220px; width:320px;"> 
			<input type="hidden" id="reportId" name="reportId" value="" />
		    <input type="hidden" id="version"  name="version"  value="" />
		<c:forEach var="list" items="${reportsList}">
		    <div id="${list.reportId}" name="repListRow" class="tableRow" version="${list.version}" style="height: 25px;"/> 
				 <label name="repTitle" >${list.reportTitle}</label>
			</div>
		</c:forEach>
	</div>
	<div class="buttonsDiv" id="buttonDiv">
		<input type="button" class="button hover"  style="width:150px; margin-left:8px;" id="btnGenerateDocs" name="generateDocs" value="Generate Document" />
		<input type="button" class="button hover"  style="width:150px;" id="btnReturn" name="return" value="Return" />
	</div>
</div>
<div class="sectionDiv" id="paramsDiv" name="paramsDiv" style="height: 300px; width:450px; float: left;">
	<label id="params">Parameters : </label><br />
	<!-- for documents canvas -->
	<table width="450px" border="0" id="documents" name="documents">
		<tr>
			<td class="rightAligned" style="width: 100px;" id="docuDate">Document Date</td>
			<td class="lefttAligned" colspan="4">
				<div id="txtDocudateDiv" name="txtDocudateDiv" style="float: left; width: 155px;" class="withIconDiv ">
					<input style="width: 130px;" id="txtDocudate" name="txtDocudate" type="text" value="" class="withIcon " readonly="readonly" />
					<img id="hrefDocuDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Document Date" onClick="scwShow($('txtDocudate'),this, null);" />
				</div>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;" id="time">Time</td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="txtTime" name="txtTime" style="width: 150px;"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;" id="language">Language</td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="txtLanguage" name="txtLanguage" style="width: 150px;" maxLength="30"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;" id="place">Place</td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="txtPlace" name="txtPlace" style="width: 320px;" maxLength="500" />
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;" id="docuDate">Witness</td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="witness1" name="witness1" style="width: 320px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="witness2" name="witness2" style="width: 320px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="witness3" name="witness3" style="width: 320px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="witness4" name="witness4" style="width: 320px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;" id="signatory">Signatory</td>
			<td class="lefttAligned">
				<input type="radio" id="rdoAssured" name="radBtn" style="margin-left: 30px;"/>
			</td>
			<td colspan="1">Assured</td>	
			<td class="lefttAligned">
				<input type="radio" id="rdoThirdParty" name="radBtn" style="margin-left: 20px;"/>
			</td>
			<td style="margin-left: 10px;">Third Party Claimant</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="lefttAligned" colspan="4">
				<input type="text" id="txtSignatory" name="txtSignatory" style="width: 320px;" maxlength="500" />
			</td>	
		</tr>
	</table>
	<!-- for third party canvas -->
	<table width="450px" border="0" id="thirdParty" name="thirdParty">
		<tr>
			<td class="rightAligned" style="width: px;" id="tpName">Third Party Name</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtTpName" name="txtTpName" style="width: 300px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="tpAddress">Address</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtTpAddress" name="txtTpAddress" style="width: 300px;" maxLength="500"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="tpVehicle">Vehicle</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtTpVehicle" name="txtTpVehicle" style="width: 300px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="tpPlateNo">Plate No.</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtTpPlateNo" name="txtTpPlateNo" style="width: 150px;" maxLength="30"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="tpLanguage">Language</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtTpLanguage" name="txtTpLanguage" style="width: 150px;" maxLength="30"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="affOfDesistDate">Date</td>
			<td class="leftAligned" colspan="2">
				<div id="txtDesistDateDiv" name="txtDesistDateDiv" style="float: left; width: 155px;" class="withIconDiv ">
					<input style="width: 130px;" id="txtAffOfDesistDate" name="txtAffOfDesistDate" type="text" value="" class="withIcon " readonly="readonly" />
					<img id="hrefDesistDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Desist Date" onClick="scwShow($('txtAffOfDesistDate'),this, null);" />
				</div>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="affOfDesistPlace">Place</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtAffOfDesistPlace" name="txtAffOfDesistPlace" style="width: 150px;" maxLength="500"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;" id="affOfDesistWit1">Witness</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtAffOfDesistWit1" name="txtAffOfDesistWit1" style="width: 300px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;"></td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtAffOfDesistWit2" name="txtAffOfDesistWit2" style="width: 300px;" maxLength="100"/>
			</td>	
		</tr>
	</table>
	<!-- for deed of MC sale canvas -->
	<table width="450px" border="0" id="deedOfMcSale" name="deedOfMcSale">	
		<tr>
			<td class="rightAligned" style="width:80px;">Vendee</td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="vendee" name="vendee" style="width: 350px;" maxLength="100"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 80px;">Address</td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="vendeeAdd" name="vendeeAdd" style="width:224px;" maxLength="500"/>
				TIN <input type="text" id="vendeeTin" name="vendeeTin" style="width: 90px;" maxLength="30"/>
			</td>			
		</tr>
		<tr>
			<td class="rightAligned" style="width: 80px;">Vendor</td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="vendor" name="vendor" style="width: 350px;" maxLength="100"/>
			</td>	
		</tr>
		<tr>
			<td class="rightAligned" style="width: 80px;" id="vendorAdd">Address</td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="txtVendorAdd" name="txtVendorAdd" style="width:224px;" maxLength="500"/>
				TIN <input type="text" id="vendorTin" name="vendeeTin" style="width: 90px;" maxLength="30"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 80px;" id="amount">Amount</td>
			<td class="leftAligned" colspan="5">
				<input class="money" type="text" id="txtAmt" name="txtAmt" style="width: 180px; text-align: right; " errorMsg="Invalid Amount. Valid value should be from 0.00 to  999,999,999.99." min="0.00" max="999999999.99."/> <!-- added by steven 12/13/2012 -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 80px;" id="date">Date</td>
			<td class="leftAligned" style="width: 60px;">
				<div id="txtDeedDateDiv" name="txtDeedDateDiv" style="float: left; width: 155px;" class="withIconDiv ">
					<input style="width: 130px;" id="txtDeedDate" name="txtDeedDate" type="text" value="" class="withIcon " readonly="readonly" />
					<img id="hrefDeedDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Deed Date" onClick="scwShow($('txtDeedDate'),this, null);" />
				</div>
			</td>
			<td class="rightAligned" id="date">Place</td>
			<td class="leftAligned">
				<input type="text" id="txtDeedPlace" name="txtDeedPlace" style="width:156px;" maxLength="500"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Witness</td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="txtDeedOfSaleWitness1" name="txtDeedOfSaleWitness1" style="width: 350px;" maxLength="100"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;"></td>
			<td class="leftAligned" colspan="5">
				<input type="text" id="txtDeedOfSaleWitness2" name="txtDeedOfSaleWitness2" style="width: 350px;" maxLength="100"/>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="5">
			<input type="button" class="button hover"  style="width:150px; margin-left:8px; margin-top:15px;" id="btnItemInfo" name="btnItemInfo" value="Item Info" />
			</td>
		</tr>
	</table>	
	<!-- for item info  -->
	<table width="450px" border="0" id="itemInfo" name="itemInfo" style="margin-top: 30px;">	
		<tr>
			<td class="rightAligned" style="width:80px;">Item</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="itemNo" name="itemNo" style="width: 60px;" maxLength="9" readOnly="readonly"/>
				<input type="text" id="itemTitle" name="itemTitle" style="width: 260px;" maxLength="250" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Model</td>
			<td class="leftAligned">
				<input type="text" id="itemModel" name="itemModel" style="width: 100px;" maxLength="9" readOnly="readonly"/>
			</td>
			<td class="rightAligned" style="width:80px;">Serial No.</td>
			<td class="leftAligned" >
				<input type="text" id="itemSerialNo" name="itemSerialNo" style="width: 120px;" maxLength="25" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Make</td>
			<td class="leftAligned" >
				<input type="text" id="itemMake" name="itemMake" style="width: 100px;" maxLength="100" readOnly="readonly"/>
			</td>
			<td class="rightAligned" style="width:80px;">Motor No.</td>
			<td class="leftAligned" >
				<input type="text" id="itemMotorNo" name="itemMotorNo" style="width: 120px;" maxLength="30" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Type</td>
			<td class="leftAligned" >
				<input type="text" id="itemSublineType" name="itemSublineType" style="width: 100px;" maxLength="100" readOnly="readonly"/>
			</td>
			<td class="rightAligned" style="width:80px;">Plate No.</td>
			<td class="leftAligned" >
				<input type="text" id="itemPlateNo" name="itemPlateNo" style="width: 120px;" maxLength="10" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Color</td>
			<td class="leftAligned" >
				<input type="text" id="itemColor" name="itemColor" style="width: 100px;" maxLength="20" readOnly="readonly"/>
			</td>
			<td class="rightAligned" style="width:80px;">MV File No.</td>
			<td class="leftAligned" >
				<input type="text" id="itemMVFileNo" name="itemMVFileNo" style="width: 120px;" maxLength="15" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:80px;">Driver</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="itemDrvrName" name="itemDrvrName" style="width: 333px;" maxLength="100" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="5">
			<input type="button" class="button hover"  style="width:150px; margin-left:8px; margin-top:15px;" id="btnItemRtrn" name="btnItemRtrn" value="Return" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
printDocsItemInfoTableGrid.keys.releaseKeys();
histInfoTableGrid.keys.releaseKeys();
var mode = null;
loadPrintDocsParams();
initializeAllMoneyFields();//added by steven 12/13/2012

function toggleSignatoryGrp(mode){
	if (mode == 'A') {
		$('txtSignatory').value = $('txtAssdName').value;
	}else if (mode == 'T'){
		$('txtSignatory').value = null;
		var signatory = $('txtSignatory').value;
		if ($F("lineCd") == 'MC'){
			showTpClaimantLov(signatory);
		}
	}
}

// belle 10112011 load parameter pages for GICLS041
function loadPrintDocsParams(){
	try{
		var mode = null;
		$("deedOfMcSale").hide();
		$("thirdParty").hide();
		$("itemInfo").hide();

		$$("div#reportsListDiv div[name='repListRow']").each(function(row){
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){	
				row.toggleClassName("selectedRow");
				
				if(row.hasClassName("selectedRow")){			
					($$("div#reportsListDiv div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
					
					if (row.id == "GICLR036"){
						$("thirdParty").show();
						$("documents").hide();
						$("deedOfMcSale").hide();
						$("itemInfo").hide();
						$("params").show(); 
						$("txtTpName").focus();
						
						$("reportId").value = row.id;
						$("version").value = row.getAttribute("version");
						$("txtAffOfDesistDate").value = dateFormat(new Date(), "mm-dd-yyyy");
					} else if (row.id == "GICLR038"){
						$("deedOfMcSale").show(); 
						$("thirdParty").hide();
						$("documents").hide();
						$("itemInfo").hide();
						$("vendee").focus();
						
						$("reportId").value = row.id;
						$("version").value = row.getAttribute("version");
						$("txtDeedDate").value = dateFormat(new Date(), "mm-dd-yyyy");
					}else if (row.id == "GICLR048"){
						$("witness3").hide();
						$("witness4").hide();
						$("documents").show();
						$("itemInfo").hide();
						$("thirdParty").hide(); 
						$("deedOfMcSale").hide();
						$("params").show();
						$("txtTime").focus();
						
						$("reportId").value = row.id;
						$("version").value = row.getAttribute("version");
						$("txtDocudate").value = dateFormat(new Date(), "mm-dd-yyyy");
						
						$("rdoAssured").checked = true;
						fireEvent($("rdoAssured"), "click");
					}else{
						$("documents").show();
						$("deedOfMcSale").hide();
						$("thirdParty").hide();
						$("itemInfo").hide();
						$("params").show(); 
						$("txtTime").focus();
						
						$("witness3").show();
						$("witness4").show();
						
						$("reportId").value = row.id;
						$("version").value = row.getAttribute("version");
						$("txtDocudate").value = dateFormat(new Date(), "mm-dd-yyyy");
						
						$("rdoAssured").checked = true;
						fireEvent($("rdoAssured"), "click");
					}
				}
			});
		});	
	}catch(e){
		showErrorMessage("loadPrintDocsParams", e);
	}
}

// belle 10122011 show settlement hist page for GICLS041
function showSettlementHist(){
	try{
		itemNo = removeLeadingZero(printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("dspItemNo"), printDocsItemInfoTableGrid.getCurrentPosition()[1]));
		perilCd = printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("dspPerilCd"), printDocsItemInfoTableGrid.getCurrentPosition()[1]);

		overlaySettlementHist = Overlay.show(contextPath+ "/GICLClaimLossExpenseController", {
			urlContent: true,
			urlParameters: {action: "getSettlementHistInfo",
						   claimId: objCLMGlobal.claimId,
			             dspItemNo: itemNo,
			            dspPerilCd: perilCd},
            height: 310, 
		    width: 604,
		    draggable: true,
		    //closable: true
		});
	}catch(e){
		showErrorMessage("showSettlementHist", e);
	}
}

function observeBlur(element){
	$(element).observe("blur", function(){
		var sysdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM TT');
		 if(Date.parse($F(element)) > Date.parse(sysdate)){
			 showWaitingMessageBox("Document Date should not be later than the current date.", "I", function(){
			 	$(element).clear();
				$(element).focus();
				return false;
			 });
		 }
	});
}
//belle 02.24.2012
function populateMCItemInfo(){
	$("itemNo").value = objCLMItem.mcItemInfo.dspItemNo == null ? "" :  objCLMItem.mcItemInfo.dspItemNo;
	$("itemTitle").value = objCLMItem.mcItemInfo.dspItemTitle == null ? "" :  objCLMItem.mcItemInfo.dspItemTitle;
	$("itemModel").value = objCLMItem.mcItemInfo.modelYear== null ? "" :  objCLMItem.mcItemInfo.modelYear;
	$("itemMake").value = objCLMItem.mcItemInfo.dspMake== null ? "" :  objCLMItem.mcItemInfo.dspMake;
	$("itemSerialNo").value = objCLMItem.mcItemInfo.serialNo == null ? "" :  objCLMItem.mcItemInfo.serialNo;
	$("itemMotorNo").value = objCLMItem.mcItemInfo.motorNo == null ? "" :  objCLMItem.mcItemInfo.motorNo;
	$("itemSublineType").value = objCLMItem.mcItemInfo.dspSublineType== null ? "" :  objCLMItem.mcItemInfo.dspSublineType;
	$("itemPlateNo").value = objCLMItem.mcItemInfo.plateNo== null ? "" :  objCLMItem.mcItemInfo.plateNo;
	$("itemColor").value = objCLMItem.mcItemInfo.color== null ? "" :  objCLMItem.mcItemInfo.color;
	$("itemMVFileNo").value = objCLMItem.mcItemInfo.mvFileNo== null ? "" :  objCLMItem.mcItemInfo.mvFileNo;
	$("itemDrvrName").value = objCLMItem.mcItemInfo.drvrName== null ? "" :  objCLMItem.mcItemInfo.drvrName;
}

//belle 06.25.2012
function computeTotalPdAmt(){
	var rows = histInfoTableGrid.getModifiedRows();
	var totalPdAmt = 0;
	for (var i=0; i<rows.length; i++){
		if(rows[i].checkBox1 == true){
			totalPdAmt = totalPdAmt + parseFloat(rows[i].paidAmount);
		}
	}
   return totalPdAmt;
}

function populatePrintDocs(){
	try{
		var version  = $F("version");
		var reportId = $F("reportId");
		var reportTitle = "";
		var payeeClCd = (histInfoTableGrid.geniisysRows.length == 0 ? "" : objPayee.payeeClCd);
		var payeeCd = (histInfoTableGrid.geniisysRows.length == 0 ? "" : parseFloat(objPayee.payeeCd));
		var payeeName = (histInfoTableGrid.geniisysRows.length == 0 ? "" : encodeURIComponent(unescapeHTML2(objPayee.payeeName)));
		var itemTitle = printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("dspItemTitle"), printDocsItemInfoTableGrid.getCurrentPosition()[1]);
		var itemNo = parseFloat(printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("dspItemNo"), printDocsItemInfoTableGrid.getCurrentPosition()[1]));
		var perilCd = printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("dspPerilCd"), printDocsItemInfoTableGrid.getCurrentPosition()[1]); // added by: Nica 04.04.2013
		var groupedItemNo = printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("groupedItemNo"), printDocsItemInfoTableGrid.getCurrentPosition()[1]);
		var currencyCd =  printDocsItemInfoTableGrid.getValueAt(printDocsItemInfoTableGrid.getColumnIndex("currencyCd"), printDocsItemInfoTableGrid.getCurrentPosition()[1]);
		var totalPdAmt = (histInfoTableGrid.geniisysRows.length == 0 ? "" : computeTotalPdAmt());
		var adviceId = (histInfoTableGrid.geniisysRows.length == 0 ? "" : histInfoTableGrid.getValueAt(histInfoTableGrid.getColumnIndex("adviceId"), histInfoTableGrid.getCurrentPosition()[1]));
		var clmLossId = (histInfoTableGrid.geniisysRows.length == 0 ? "" : objPayee.clmLossId); //get value of clm_loss_id field by MAC 12/6/2012
		
		var content = contextPath+"/PrintDocumentsController?action=populatePrintDocs&reportId="+reportId+"&version="+version
		  			  +"&claimId="+objCLMGlobal.claimId;
		 //added by steve 10/12/2012 - added encodeURIComponent to the parameter to escape the '&' in the value of the parameters
			if (reportId == 'GICLR036'){
				reportTitle = "AOD-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
				  	  	  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+
						  "&affOfDesistWit1="+encodeURIComponent(escapeHTML2($F("txtAffOfDesistWit1")))+ //encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
						  "&affOfDesistWit2="+encodeURIComponent(escapeHTML2($F("txtAffOfDesistWit2")))+ //encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
						  "&assdName="+encodeURIComponent($F("txtAssdName"))+
						  "&plateNo="+$F("txtTpPlateNo")+
						  "&itemTitle="+encodeURIComponent(itemTitle)+
						  "&itemNo="+itemNo+
						  "&tpName2="+encodeURIComponent($F("txtTpName"))+
						  "&tpAddress="+encodeURIComponent($F("txtTpAddress"))+   // added by jeffdojello 05.09.2013
						  "&totalPdAmt="+totalPdAmt+                              // added by jeffdojello 05.09.2013
						  "&affOfDesistPlace="+encodeURIComponent($F("txtAffOfDesistPlace"))+
						  "&payeeName="+payeeName+
						  "&witness1="+encodeURIComponent($F("witness1"))+ // added by: Nica 04.06.2103
						  "&witness2="+encodeURIComponent($F("witness2"))+ // added by: Nica 04.06.2103
						  //"&language="+encodeURIComponent($F("txtLanguage"))+ // added by: Nica 04.06.2103 --commented out by jeffdojello 05.09.2013
						  "&tpLanguage="+encodeURIComponent($F("txtTpLanguage"))+ // added by jeffdojello 05.09.2013
						  "&tpVehicle="+encodeURIComponent($F("txtTpVehicle"))+ // added by robert 09302013
						  "&date="+$F("txtAffOfDesistDate"); 
			}else if (reportId == 'GICLR037') {
				reportTitle = "AOD-"+$F("txtClaimNo");
				content = content+
				  		  "&title="+reportTitle+				
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+
						  "&payeeName="+payeeName+   //added by christian
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+  //added by christian
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&witness3="+encodeURIComponent($F("witness3"))+ //added parameter for WITNESS3 since GICLS041 has field for WITNESS3 by MAC 09/28/2013.
						  "&witness4="+encodeURIComponent($F("witness4"))+ //added parameter for WITNESS4 since GICLS041 has field for WITNESS4 by MAC 09/28/2013.
						  "&itemNo="+itemNo+
						  "&groupedItemNo="+groupedItemNo+
						  "&totalPdAmt="+totalPdAmt+
						  "&date="+$F("txtDocudate")+  //added by christian
						  "&place="+encodeURIComponent($F("txtPlace"))+
						  "&currencyCd="+currencyCd; // bonok :: 09.26.2012
			}else if (reportId == 'GICLR038') {
				reportTitle = " ";
				content = content+
						  "&title="+reportTitle+
						  "&payeeClassCd="+payeeClCd+ //added payee class code by MAC 11/27/2012
						  "&payeeCd="+payeeCd+ //added payee code by MAC 11/27/2012
						  "&vendor="+encodeURIComponent($F("vendor"))+
						  "&vendorAddress="+encodeURIComponent($F("txtVendorAdd"))+
						  "&totalPdAmt="+totalPdAmt+
						  "&vendee="+encodeURIComponent($F("vendee"))+
						  "&vendeeAddress="+encodeURIComponent($F("vendeeAdd"))+
						  "&place="+encodeURIComponent($F("txtDeedPlace"))+
						  "&vendeeTin="+encodeURIComponent($F("vendeeTin"))+
						  "&vendorTin="+encodeURIComponent($F("vendorTin"))+
						  "&witness1="+encodeURIComponent($F("txtDeedOfSaleWitness1"))+
						  "&witness2="+encodeURIComponent($F("txtDeedOfSaleWitness2"))+
						  "&date="+encodeURIComponent($F("txtDeedDate"))+
						  "&currencyCd="+currencyCd+
						  "&enteredAmount="+$F("txtAmt")+ //added user entered amount by MAC 12/4/2012
						  "&clmLossId="+clmLossId; //added clm_loss_id field by MAC 12/6/2012
			}else if (reportId == 'GICLR039') {
				reportTitle = " ";
				content = content+
						  "&title="+reportTitle+
						  "&totalPdAmt="+totalPdAmt+
						  "&payeeName="+payeeName+
						  "&language="+encodeURIComponent($F("txtLanguage"))+
						  "&date="+$F("txtDocudate")+
						  "&place="+encodeURIComponent($F("txtPlace"))+
						  "&currencyCd="+currencyCd+
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&witness3="+encodeURIComponent($F("witness3"))+
						  "&witness4="+encodeURIComponent($F("witness4"))+
						  "&signatory="+encodeURIComponent($F("txtSignatory")); //added singnatory by robert 11.08.2013
			} else if (reportId=="GICLR039B") { // apollo cruz 02.05.2016
				reportTitel = "";
				content += "&itemNo=" + itemNo +
				"&perilCd=" + perilCd +
				"&currencyCd=" + currencyCd +
				"&totalPdAmt=" + totalPdAmt +
				"&signatory=" + encodeURIComponent($F("txtSignatory")) +
				"&place=" + encodeURIComponent($F("txtPlace")) +
				"&date=" + $F("txtDocudate") +
				"&witness1=" + encodeURIComponent($F("witness1")) +
				"&witness2=" + encodeURIComponent($F("witness2"));
			} else if (reportId == 'GICLR041') {
				reportTitle = "LSR-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
						  "&totalPdAmt="+totalPdAmt+
						  "&date="+$F("txtDocudate")+
						  "&place="+encodeURIComponent($F("txtPlace"))+
						  "&itemNo="+itemNo+
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+
						  "&currencyCd="+currencyCd+ // - irwin 8.10.2012
						  "&payeeName="+payeeName;
			}else if (reportId == 'GICLR042') {
				reportTitle = "AOD-"+$F("txtClaimNo");
				content = content+
				  		  "&title="+reportTitle+				
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+		  
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&itemNo="+itemNo+
						  "&groupedItemNo="+groupedItemNo+
						  "&totalPdAmt="+totalPdAmt+
						  "&place="+encodeURIComponent($F("txtPlace"))+
						  "&payeeName="+payeeName+
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+
						  "&currencyCd="+currencyCd; // bonok :: 09.24.2012
			}else if (reportId == 'GICLR042B'){
				reportTitle = "RQ-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+
						  "&adviceId="+nvl(adviceId,0)+
						  "&lineCd="+$F("lineCd")+ 
						  "&totalPdAmt="+totalPdAmt+
						  "&payeeName="+payeeName+
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&date="+$F("txtDocudate")+
						  "&place="+encodeURIComponent($F("txtPlace"))+        // Nante 10.21.2013
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+  // Nante 10.21.2013
						  "&itemNo="+nvl(itemNo,0);
			}if (reportId == 'GICLR045'){
				reportTitle = "LSR(FIRE)-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
						  "&totalPdAmt="+totalPdAmt+
					      "&date="+$F("txtDocudate")+
						  "&itemNo="+itemNo+
						  "&perilCd="+perilCd+
						  "&groupedItemNo="+groupedItemNo+
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&witness3="+encodeURIComponent($F("witness3"))+
						  "&witness4="+encodeURIComponent($F("witness4"))+
						  "&payeeName="+payeeName+
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+
						  "&currencyCd="+currencyCd;
			}else if (reportId == 'GICLR046'){
				reportTitle = "LTR-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
				          "&payeeName="+payeeName+
				          "&totalPdAmt="+totalPdAmt+
				          "&date="+$F("txtDocudate")+
				          "&place="+encodeURIComponent($F("txtPlace"))+
					      "&itemNo="+itemNo+
						  "&groupedItemNo="+groupedItemNo+
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&witness3="+encodeURIComponent($F("witness3"))+
						  "&witness4="+encodeURIComponent($F("witness4"))+
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+
						  "&perilCd="+perilCd+     //Nante  10.21.2013  AUII
						  "&currencyCd="+currencyCd;
			}else if(reportId == 'GICLR047'){
				reportTitle = "RRC-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+ 
				          "&totalPdAmt="+totalPdAmt+
				          "&payeeName="+payeeName+
				          "&date="+$F("txtDocudate")+
				          "&place="+encodeURIComponent($F("txtPlace"))+
				          "&signatory="+encodeURIComponent(unescapeHTML2($F("txtSignatory")))+ 
				          "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&currencyCd="+currencyCd;   //added by steve 8/6/2012
			}else if (reportId == 'GICLR048') {
				reportTitle = "AOD-"+$F("txtClaimNo");
				content = content+
				  		  "&title="+reportTitle+				
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+		  
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&itemNo="+itemNo+
						  "&groupedItemNo="+groupedItemNo+
						  "&totalPdAmt="+totalPdAmt+
						  "&place="+encodeURIComponent($F("txtPlace"))+
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+
						  "&date="+$F("txtDocudate")+
						  "&currencyCd="+currencyCd;
			}else if (reportId == 'GICLR049'){
				reportTitle = "LATR-"+$F("txtClaimNo");
				content = content+
						  "&title="+reportTitle+
						  "&payeeClassCd="+payeeClCd+
						  "&payeeCd="+payeeCd+
						  "&currencyCd="+currencyCd+
						  "&totalPdAmt="+totalPdAmt+
						  "&policyNo="+$F("txtPolicyNo")+
						  "&lossCtgry="+$F("txtLossCtgry")+
						  "&lossDate="+$F("txtLossDate")+
						  "&witness1="+encodeURIComponent($F("witness1"))+
						  "&witness2="+encodeURIComponent($F("witness2"))+
						  "&witness3="+encodeURIComponent($F("witness3"))+       //Nante 10.21.2013  AUII
						  "&witness4="+encodeURIComponent($F("witness4"))+       //Nante 10.21.2013  AUII
						  "&place="+encodeURIComponent($F("txtPlace"))+          //Nante 10.21.2013  AUII
						  "&signatory="+encodeURIComponent($F("txtSignatory"))+  //Nante 10.21.2013  AUII
						  "&date="+$F("txtDocudate")+
						  "&payeeName="+payeeName;			  
			}
				
		/* else if (version == 'RSIC'){
			if (reportId != 'GICLR041'){
				content = content +"&selPayeeClCd="+(histInfoTableGrid.geniisysRows == "" ? "" : settHist.payeeClCd)+"&selPayeeCd="+(histInfoTableGrid.geniisysRows == "" ? "" : settHist.payeeCd) +"&payeeClassCd="+payeeClCd
						  +"&payeeCd="+payeeCd;
				if (reportId == 'GICLR036'){
					reportTitle = "AOD-"+$F("txtClaimNo");
					content = content +"&title="+reportTitle+"&affOfDesistWit1="+$F("txtAffOfDesistWit1") +"&affOfDesistWit2="+$F("txtAffOfDesistWit2") 
							  +"&assdName="+$F("txtAssdName") +"&plateNo="+$F("txtTpPlateNo")+"&itemTitle="+itemTitle 
							  +"&tpName2="+$F("txtTpName") +"&affOfDesistPlace="+$F("txtAffOfDesistPlace");
					
				}
			}else if (reportId == 'GICLR041') {
				reportTitle = "LSR-"+$F("txtClaimNo");
				content = content +"&title="+reportTitle +"&totalStlPdAmt="+totalPdAmt +"&paidAmt="+paidAmt 
						  +"&date="+$F("txtDocudate") +"&place="+$F("txtPlace");
				}
		}  */
		
		//window.open(content, "", "location=0, toolbar=0, menubar=0, fullscreen=1"); 		
		showPdfReport(content, reportTitle); // andrew - 12.12.2011
	}catch(e){
		showErrorMessage("populatePrintDocs", e);
	}
}

observeBlur("txtDocudate");
observeBlur("txtAffOfDesistDate");
observeBlur("txtDeedDate");

observeBackSpaceOnDate("txtDocudate");
observeBackSpaceOnDate("txtAffOfDesistDate");
observeBackSpaceOnDate("txtDeedDate");

$("btnReturn").observe("click", function(){
	overlayReportsList.close();
});

$("rdoAssured").observe("click", function(){
	mode = 'A';
	toggleSignatoryGrp(mode);
	$("txtSignatory").readOnly = true;
});

$("rdoThirdParty").observe("click", function(){
	mode = 'T';
	toggleSignatoryGrp(mode);	
	$("txtSignatory").readOnly = false;
});

$("btnGenerateDocs").observe("click", function(){
	if(($$("div#reportsListDiv .selectedRow")).length < 1) {
		showMessageBox("Please select a document first.", imgMessage.INFO);					
		return false;
    /*} else if (objCLM.histInfoTBLength < 2 ){
		populatePrintDocs();
	}else{
		showSettlementHist();
		$("selectedItem").checked = true;
	} */ //belle 06.25.2012 
	}else{
		populatePrintDocs();
	}
});

//belle 05.23.2012
$("btnItemInfo").observe("click", function(){
	$("itemInfo").show();
	$("deedOfMcSale").hide(); 
	$("params").hide(); 
	populateMCItemInfo();
});

$("btnItemRtrn").observe("click", function(){
	$("itemInfo").hide();
	$("deedOfMcSale").show(); 
	$("params").show(); 
});

$("txtTime").observe("blur", function(){
	var time = isValidTime("txtTime", "AM", true, false);
	if (!time){
		$("txtTime").value = "";
	} 
});

// $("txtAmt").observe("blur", function() {
// 	this.value = ($F("txtAmt")).replace(/,/g, "");
// 	if(isNaN($F("txtAmt")) || parseFloat(($F("txtAmt")).replace(/,/g, "")) > 999999999.99) {
// 		showMessageBox("Invalid Amount. Valid value should be from 0.00 to  999,999,999.99.");
// 		$("txtAmt").clear();
// 		$("txtAmt").focus();
// 	}
// 	$("txtAmt").value = formatCurrency($F("txtAmt"));
// }); remove by steven 12/13/2012 use the util "initializeAllMoneyFields()"

fireEvent($("reportsListDiv").down("div", 0), "click"); //belle 05.28.2012

</script>

	

