<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="prelimLossRepMainDiv" name="prelimLossRepMainDiv" style="margin-top: 1px; display: none;">
	<form id="prelimLossRepForm" name="prelimLossRepForm">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Claim Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="groDivTop" name="groDivTop">
			<input type="hidden">
			<c:if test="${prelim=='Y'}">
				<jsp:include page="/pages/claims/reserveSetup/preliminaryLossReport/subPages/claimInformation.jsp"></jsp:include>
			</c:if>
			<c:if test="${prelim=='N'}">
				<jsp:include page="/pages/claims/generateAdvice/finalLossReport/finalLossRepClaimInfo.jsp"></jsp:include>
			</c:if>
		</div>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Item Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="groDivBot" name="groDivBot">
			<div id="itemInfoDiv" name="itemInfoDiv" class="sectionDiv" style="height: 255px; padding: 5px 15px 15px 15px; width: 891px;">
				<label style="padding: 5px 5px 5px 0">Item: </label><input id="itemTitle" name="itemTitle" type="text" readonly="readonly" style="width: 225px; margin-bottom: 8px;">
				<div id="accidentItemInfoTableGrid" name="accidentItemInfoTableGrid" style="height: 220px;"></div>
			</div>
		</div>
		<c:if test="${prelim=='N'}">
			<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
				<div id="innerDiv" name="innerDiv">
					<label>Payee Details</label>
					<span class="refreshers" style="margin-top: 0;">
						<label id="showPayee" name="gro" style="margin-left: 5px;">Hide</label>
					</span>
				</div>
			</div>
		</c:if>
		<div id="groDivPayee" name="groDivPayee">
		
		</div>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Distribution Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showPeril" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="groDivPeril" name="groDivPeril">
		
		</div>
		<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 150px;" id="btnPremPayment" name="btnPremPayment" value="Premium Payment">
						<input type="button" class="button" style="width: 150px;" id="btnDocsOnFile" name="btnDocsOnFile" value="Documents on File">
						<input type="button" class="button" style="width: 90px;" id="btnPrint" name="btnPrint" value="Print">
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script>
	initializeAll();
	initializeAccordion();
	var claimId = '${claimId}';
	var lineCd = '${lineCd}';
	var prelim = '${prelim}';
	var arrGICLS029Buttons = [MyTableGrid.REFRESH_BTN];
	var selectedIndex = -1;

	if(prelim == 'Y'){
		observeReloadForm("reloadForm", showPreliminaryLossReport);
		objCLM.prelimLossInfo = JSON.parse('${prelimLossInfoJSON}'.replace(/\\/g, '\\\\'));
		populatePrelimLossInfo();
		showPerilInfoListing(null, null, "Y");
		function clearSubTG(){
			perilInfoTableGrid.url = contextPath + "/GICLReserveSetupController?action=getPerilInformation&refresh=1&claimId=&lineCd=";
			perilInfoTableGrid._refreshList();
		}
	}else if(prelim == 'N'){
		observeReloadForm("reloadForm", showFinalLossReport);
		objCLM.finalLossInfo = JSON.parse('${finalLossInfoJSON}'.replace(/\\/g, '\\\\'));
		populateFinalLossInfo();
		showFinalPerilInfoListing(null, null, null, "N");
		function clearSubTG(){
			payeeInfoTableGrid.url = contextPath + "/GICLReserveSetupController?action=getPayeeDetails&refresh=1&claimId=&adviceId=";
			payeeInfoTableGrid._refreshList();
			perilInfoTableGrid.url = contextPath + "/GICLReserveSetupController?action=getPerilInformation&refresh=1&claimId=&lineCd=";
			perilInfoTableGrid._refreshList();
		}
	}
	
	var objTGAccidentInfoDetails = JSON.parse('${accidentInfoTableGrid}'.replace(/\\/g,'\\\\'));
	try{
		var accidentInfoModel = {
			url: contextPath+"/GICLReserveSetupController?action=getItemInformation&refresh=1&claimId=${claimId}&menuLineCd=" + nvl(objCLMGlobal.menuLineCd, "") +
					"&prelim=${prelim}&lineCd=" + objCLMGlobal.lineCd,
			options: {
				title: '',
	          	height: '200px',
	          	width: '888px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = itemInfoTableGrid._mtgId;
	          		selectedIndex = y;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		if(prelim == 'Y'){
	            			showPerilInfoListing(claimId, lineCd, prelim);
	            		}else if(prelim == 'N'){
            				showFinalPerilInfoListing(claimId, lineCd, $("adviceId").value, prelim);
	            		}
	            	}
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	clearSubTG();
	            	removeItemInfoFocus();
	            },
	            onSort: function() {
	            	if(selectedIndex > -1){
	            		clearSubTG();	
	            	}
	            	selectedIndex = -1;
	            },
	            onRefresh: function() {
	            	if(selectedIndex > -1){
	            		clearSubTG();	
	            	}
	            	selectedIndex = -1;
	            },
	            toolbar: {
	            	elements:	(arrGICLS029Buttons)
	            }
			},
			columnModel:[
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
							id:	'itemNo',
							width: '0px',
							visible: false
						},
						{
							id:	'groupedItemNo',
							width: '0px',
							visible: false
						},
						{
							id:	'itemTitle',
							width: '0px',
							visible: false
						},
						{
							id:	'groupedItemTitle',
							title: 'Grouped Item',
							titleAlign: 'center',
							width: '0px',
							visible: false
						},
						{
							id:	'dateOfBirth',
							title: 'Date of Birth',
							titleAlign: 'center',
							align: 'center',
							width: '150px',
							type: 'date',
							format: 'mm-dd-yyyy'
						},
						{
							id:	'dspPosition',
							title: 'Position',
							titleAlign: 'center',
							width: '150px'
						},
						{
							id:	'beneficiaryName',
							title: 'Beneficiary Name',
							titleAlign: 'center',
							width: '200px'
						},
						{
							id:	'beneficiaryAddr',
							title: 'Beneficiary Address',
							titleAlign: 'center',
							width: '200px'
						},
						{
							id:	'relation',
							title: 'Relation',
							titleAlign: 'center',
							width: '164px'
						}
  					],
  				rows: objTGAccidentInfoDetails.rows,
  				id: 1125
		};
		if(objTGAccidentInfoDetails.rows.length > 0){
			if(objTGAccidentInfoDetails.rows[0].groupedItemNo > 0){
				accidentInfoModel.columnModel[5].width = '200px';
				accidentInfoModel.columnModel[5].visible = true;
			}
		}
		itemInfoTableGrid = new MyTableGrid(accidentInfoModel);
		itemInfoTableGrid.pager = objTGAccidentInfoDetails;
		itemInfoTableGrid.render('accidentItemInfoTableGrid');
		itemInfoTableGrid.afterRender = function(){
			if(itemInfoTableGrid.rows.length > 0){
				$("itemTitle").value = itemInfoTableGrid.geniisysRows[0].itemTitle;
		    }else{
		    	$("itemTitle").value = "";
		    }
		};
	}catch(e){
		showMessageBox("Error in Personal Accident Item Information: " + e, imgMessage.ERROR);		
	}

	$("btnPremPayment").observe("click", function(){
		if(selectedIndex == -1){
			showMessageBox("Please select an item first.", "I");
		}else{
			removeItemInfoFocus();
			showPrelimPremPayment(claimId);
		}
	});
	
	$("btnDocsOnFile").observe("click", function(){
		if(selectedIndex == -1){
			showMessageBox("Please select an item first.", "I");
		}else{
			removeItemInfoFocus();
			showPrelimDocsOnFile(claimId);
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(selectedIndex == -1){
			showMessageBox("Please select an item first.", "I");
		}else{
			if(prelim == 'Y'){
				removeItemInfoFocus();
				showPreLossRepPrintDialog();
			}else if(prelim == 'N'){
				showFinalLossReportPrintDialog();
				//showMessageBox("Print module is not yet existing.", imgMessage.INFO);	
			}
		}
	});
	
	function showPreLossRepPrintDialog(){
		preLossRepPrintDialog = Overlay.show(contextPath+"/GICLReserveSetupController", {
			urlContent : true,
			urlParameters: {
				action : "showPreLossRepPrintDialog",
				claimId : claimId,
				lineCd : lineCd,
				reportId : "GICLR029"
			},
		    title: "Print Preliminary Loss Report",
		    height: 165,
		    width: 380,
		    draggable: true
		});
	}
	
	function removeItemInfoFocus(){
		itemInfoTableGrid.keys.removeFocus(itemInfoTableGrid.keys._nCurrentFocus, true);
    	itemInfoTableGrid.keys.releaseKeys();
	}
</script>