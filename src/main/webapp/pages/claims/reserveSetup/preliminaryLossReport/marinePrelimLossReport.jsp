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
			<div id="itemInfoDiv" name="itemInfoDiv" class="sectionDiv" style="height: 225px; padding: 15px 15px 15px 15px; width: 891px;">
				<div id="marineItemInfoTableGrid" name="marineItemInfoTableGrid" style="height: 220px;"></div>
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
	
	var objTGMarineInfoDetails = JSON.parse('${mnInfoTableGrid}'.replace(/\\/g,'\\\\'));
	try{
		var marineInfoModel = {
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
							id:	'itemTitle',
							title: 'Item',
							titleAlign: 'center',
							width: '150px'
						},
						{
							id:	'etd',
							title: 'ETD',
							align: 'center',
							titleAlign: 'center',
							width: '100px',
							type: 'date',
							format: 'mm-dd-yyyy'
						},
						{
							id:	'eta',
							title: 'ETA',
							align: 'center',
							titleAlign: 'center',
							width: '100px',
							type: 'date',
							format: 'mm-dd-yyyy'
						},
						{
							id:	'vesselName',
							title: 'Vessel',
							titleAlign: 'center',
							width: '158px'
						},
						{
							id:	'cargoClassDesc',
							title: 'Shipment',
							titleAlign: 'center',
							width: '158px'
						},
						{
							id:	'lcNo',
							title: 'L/C No.',
							titleAlign: 'center',
							width: '100px'
						},
						{
							id:	'blAwb',
							title: 'B/L No.',
							titleAlign: 'center',
							width: '100px'
						}
  					],
  				rows: objTGMarineInfoDetails.rows,
  				id: 1123
		};
		itemInfoTableGrid = new MyTableGrid(marineInfoModel);
		itemInfoTableGrid.pager = objTGMarineInfoDetails;
		itemInfoTableGrid.render('marineItemInfoTableGrid');
	}catch(e){
		showMessageBox("Error in Marine Cargo Item Information: " + e, imgMessage.ERROR);		
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