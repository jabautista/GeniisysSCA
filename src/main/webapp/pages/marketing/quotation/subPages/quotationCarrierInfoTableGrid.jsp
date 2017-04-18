<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;" name="outerDiv">
	<div id="innerDiv" >
   		<label>Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="hideForm" name="hideForm" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadGIIMM009" name="reloadGIIMM009">Reload Form</label>
   		</span>
   	</div>
</div>

<div id="carrierInfoMainDiv" name="carrierInfoMainDiv" style="margin-top: 1px; display: none;">
	<form id="carrierInfoMainForm" name="carrierInfoMainForm">
		<input type="hidden" id="lineCd" value="MH"/>
		<input type="hidden" id="lineName" value=""/>
		<input type="hidden" name="quoteId"  	id="quoteId" 	value="${gipiQuote.quoteId}" />
		<div id="carDiv" name="carDiv" class="sectionDiv">
			<div id="quoteInfo" name="quoteInfo" style="margin: 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Quotation No. </td>
						<td class="leftAligned"><input type="text" style="width: 250px;" id="quoteNo" name="quoteNo" readonly="readonly" value="${gipiQuote.quoteNo}" />
						<td class="rightAligned">Assured Name </td>
						<td class="leftAligned">
							<input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${gipiQuote.assdName}" />
							<input type="hidden" id="assuredNo" name="assuredNo" value="${gipiQuote.assdNo}" />
						</td>	
					</tr>
				</table>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Carrier Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
				
		<div id="carrierInfoDivAndFormDiv" name="carrierInfoDivAndFormDiv" class="sectionDiv">
			<div id="carrierInfoTableGridDiv" style= "padding: 10px 137px 10px 137px;">
				<div id="carrierInfoTableGrid" style="height: 300px; width: 650px;"></div>
			</div>
			<div id="carrierInfoFormDiv" name="carrierInfoFormDiv" style="width: 100%; margin: 10px 0px 5px 0px;">
				<table align="center" width="50%">
					<tr>
						<td class="rightAligned" width="20%">Carrier/Conveyance</td>
						<td class="leftAligned" width="80%">
							<span class="required lovSpan" style="width: 305px;">
								<input id="hidVesFlag" name="hidVesFlag" type="hidden">
								<input id="hidVesselCd" name="hidVesselCd" type="hidden">
								<input id="hidRecFlag" name="hidrecFlag" type="hidden">
								<input id="inputVessel" name="inputVessel" type="text" readonly="readonly" style="border: none; float: left; width: 260px; height: 13px; margin: 0px;" class="required">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCarrierName" name="searchCarrierName" alt="Go" style="float: right;"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Vessel Flag</td>
						<td class="leftAligned"><input type="text" id="inputVesselFlag" name="inputVesselFlag" style="width: 300px;" readonly="readonly"/></td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="carrierInfoButtonsDiv">
			<input type="button" class="button" style="width: 130px;" id="btnMaintainVessel" name="btnMaintainVessel" value="Maintain Vessel Info" />
			<input type="button" class="button" style="width: 130px;" id="btnMaintainInland" name="btnMaintainInland" value="Maintain Inland Info" />
			<input type="button" class="button" style="width: 130px;" id="btnMaintainAircraft" name="btnMaintainAircraft" value="Maintain Aircraft Info" />
			<input type="button" class="button" style="width: 150px;" id="btnEditQuotation" name="btnEditQuotation" value="Edit Basic Quotation Info" />
			<input type="button" class="button" style="width: 70px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>
<script type="text/javascript">
	initializeMenu();
	initializeAccordion();
    setModuleId("GIIMM009"); 
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	setDocumentTitle("Carrier Information");
	selectedIndex = -1;
	disableButton("btnDelete");
	var objGIIMM009 = {};
	objGIIMM009.exitPage = null;
	objGIIMM009.savePage = null;
	objGIIMM009.logoutPage = null;
	
	objMKGlobal.callingForm = null;
	
	$("btnMaintainVessel").observe("click", function(){
		objMKGlobal.callingForm = "GIIMM009";
		$("mainNav").hide();
		showGiiss039();
	});
	$("btnMaintainInland").observe("click", function(){
		objMKGlobal.callingForm = "GIIMM009";
		$("mainNav").hide();
		showGIISS050();
	});
	
	/*
	$("btnMaintainAircraft").observe("click", function(){
		objMKGlobal.callingForm = "GIIMM009";
		$("mainNav").hide();
		showGIISS049();
	});
	*///Replaced by John 02.19.2014
	observeAccessibleModule(accessType.BUTTON, "GIISS049", "btnMaintainAircraft", function(){
		objMKGlobal.callingForm = "GIIMM009";
		$("mainNav").hide();
		showGIISS049();
	}); 
	
		try{
			var quotationCarrierInfoObj= new Object();
			var objCarrierInfo = [];
			quotationCarrierInfoObj.quotationCarrierInfoObjListTableGrid = JSON.parse('${objGipiQuoteVesAirTableGrid}'.replace(/\\/g,'\\\\'));
			quotationCarrierInfoObj.quotationCarrierInfoObjList = quotationCarrierInfoObj.quotationCarrierInfoObjListTableGrid.rows || [];
	
			var quotationCarrierTableModel={
					url: contextPath + "/GIPIQuoteVesAirController?action=showQuoteVesAirPageTableGrid&quoteId="+$F("quoteId"),
					resetChangeTag: true,
					options: {
						title: '',
		              	height:'290px',
			          	width:'650px',
						onCellFocus: function(element, value, x, y, id){
							selectedIndex = y;
							var obj = carrierInfoTableGrid.geniisysRows[y];
							populateQuotationCarrierInfo(obj);
							enableButton("btnDelete");
							disableButton("btnAdd");
							disableSearch("searchCarrierName");
							carrierInfoTableGrid.keys.releaseKeys();
						},
						onRemoveRowFocus: function (){
							selectedIndex = -1;
							populateQuotationCarrierInfo(null);
							formatAppearance();
							carrierInfoTableGrid.keys.releaseKeys();
						},
						onCellBlur : function() {
							observeChangeTagInTableGrid(carrierInfoTableGrid);
						},
						beforeSort: function(){
							if(changeTag == 1){
								showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											saveQuoteCarrierInfo();
										}, function(){
											carrierInfoTableGrid.refresh();
											changeTag = 0;
										}, "");
								return false;
							}else{
								return true;
							}
						},
						onSort: function(){
							populateQuotationCarrierInfo(null);
							formatAppearance();
						},
						postPager: function () {
							selectedIndex = -1;
							populateQuotationCarrierInfo(null);
							formatAppearance();
						},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
							onRefresh: function(){
								formatAppearance();
								populateQuotationCarrierInfo(null);
							},
							onFilter: function(){
								formatAppearance();
								populateQuotationCarrierInfo(null);
							}
						}
					},		
					columnModel: [
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
								{	id: 'quoteId',
									title: 'Quotation ID.',
									width: '0',
									visible: false
								},
								{	id: 'recFlag',
									title: 'Rec Flag',
									width: '0',
									visible: false
								},
								{	id: 'vesselCd',
									title: 'Vessel CD',
									width: '0',
									visible: false
								},
								{	id: 'vesselFlag',
									title: 'Vessel Flag2',
									width: '0',
									visible: false
								},
								{	id: 'vesselName',
									tooltip: 'Carrier/Conveyance',
									title: 'Carrier/Conveyance',
									name: 'vesselName',
									width: '380px',
									visible: true,
									filterOption : true
								},
								{	id: 'vesselType',
									tooltip: 'Vessel Flag',
									title: 'Vessel Flag',
									width: '250',
									visible: true,
									filterOption : true
								}
									],
					rows: quotationCarrierInfoObj.quotationCarrierInfoObjList
					
			};
			carrierInfoTableGrid = new MyTableGrid(quotationCarrierTableModel);
			carrierInfoTableGrid.pager = quotationCarrierInfoObj.quotationCarrierInfoObjListTableGrid;
			carrierInfoTableGrid.render('carrierInfoTableGrid');
			carrierInfoTableGrid.afterRender = function(){
													objCarrierInfo=carrierInfoTableGrid.geniisysRows;
												};
		}catch(e){
			showErrorMessage("quotationCarrierInfoTableGrid.jsp",e);
		}

	function saveAndReload(){
		pAction = pageActions.reload;
		saveQuoteCarrierInfo();
	} 
	
	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveQuoteCarrierInfo();
		
	}
	
	function setCarrierObject(val){
		try{
			var obj = new Object;
			obj.recFlag = $("hidRecFlag").value;
			if (val==1) {
				obj.vesselCd = $("inputVessel").getAttribute("vesselCd");
			}else{	
				obj.vesselCd=$("hidVesselCd").value;
			}
			obj.vesselFlag = $("hidVesFlag").value;
			obj.vesselName = escapeHTML2($("inputVessel").value);
			obj.vesselType = $("inputVesselFlag").value;
			obj.quoteId =$("quoteId").value;
			return obj;
		} catch(e){
			showErrorMessage("setCarrierObject()", e);
		}
	} 
	function addCarrierInfo(){
		try{
			var val=1;
			var newObj = setCarrierObject(val);
			
			if ($("inputVessel").value == "") {
				showMessageBox("Required fields must be entered.", imgMessage.ERROR);
				$("inputVessel").focus();
			} else{
				newObj.recordStatus = 0;
				objCarrierInfo.push(newObj);
				carrierInfoTableGrid.addBottomRow(newObj);
				changeTag = 1;
			}
			populateQuotationCarrierInfo(null);
		} catch(e){
			showErrorMessage("addCarrier()", e);
		}
	}
	function deleteCarrier(){
		try{
			var val=0;
			var delObj = setCarrierObject(val);
			for(var i = 0; i<objCarrierInfo.length; i++){
				if ((objCarrierInfo[i].vesselCd == delObj.vesselCd)&& (objCarrierInfo[i].recordStatus != -1)){
					delObj.recordStatus = -1;
					objCarrierInfo.splice(i, 1, delObj);
					carrierInfoTableGrid.deleteRow(carrierInfoTableGrid.getCurrentPosition()[1]);
					formatAppearance();
					
				}
			}
			changeTag = 1;
			populateQuotationCarrierInfo(null);
		} catch(e){
			showErrorMessage("deleteCarrier()", e);
		}
	}
	function saveQuoteCarrierInfo()	{
		try{
			var objParameters = new Object();
			objParameters.setCarrierInfo  = getAddedAndModifiedJSONObjects(objCarrierInfo);
			objParameters.delCarrierInfo  = getDeletedJSONObjects(objCarrierInfo);
			new Ajax.Request(contextPath + "/GIPIQuoteVesAirController?action=saveCarrierInfoTableGrid", {
				asynchronous: true,
				parameters:{
					param: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIIMM009.exitPage != null) {
								objGIIMM009.exitPage();
							}else if(objGIIMM009.logoutPage != null ){
								carrierInfoTableGrid._refreshList();
								carrierInfoTableGrid.keys.releaseKeys();
							} else if( objGIIMM009.savePage != null){
								carrierInfoTableGrid._refreshList();
								carrierInfoTableGrid.keys.releaseKeys();
							}else{
								lastAction();
								lastAction = "";
							}
						});
						carrierInfoExitCtr = 0;
						changeTag=0;
					}	
				}
			});
		} catch(e){
			showErrorMessage("saveQuoteCarrierInfo()", e);
		}
	}
	
	function formatAppearance() { //added by steven 3.21.2012
		enableButton("btnAdd");
		disableButton("btnDelete");
		enableSearch("searchCarrierName");
	}
	
	initializeChangeTagBehavior(saveQuoteCarrierInfo);
	//setCarrierInfoForm(false, null);
	$("lineCd").value = objGIPIQuote.lineCd; // andrew - 01.17.2012 - added to hold the lineCd when Exit is pressed
	$("lineName").value = objGIPIQuote.lineName; // andrew - 01.17.2012 - added to hold the lineCd when Exit is pressed
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIIMM009.exitPage = showQuotationListing;
						saveQuoteCarrierInfo();
					}, function(){
						showQuotationListing();
						changeTag = 0;
					}, "");
		}else{
			showQuotationListing();
		}
	});
	function populateQuotationCarrierInfo(obj){
		$("hidVesselCd").value    = (obj) == null ? "" : unescapeHTML2(nvl(obj.vesselCd,""));
		$("hidVesFlag").value    = (obj) == null ? "" : unescapeHTML2(nvl(obj.vesselFlag,""));
		$("hidRecFlag").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.recFlag,""));
		$("inputVessel").value    = (obj) == null ? "" : unescapeHTML2(nvl(obj.vesselName,""));
		$("inputVesselFlag").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.vesselType,""));
	}
	
	/* observe... */
	$("btnAdd").observe("click", addCarrierInfo);
	$("btnDelete").observe("click", deleteCarrier);
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		objGIIMM009.savePage = "Y";
		saveQuoteCarrierInfo();
		changeTag = 0;
	});
	
	$("reloadGIIMM009").observe("click", function () {
		if(changeTag > 0) {
			showConfirmBox("Reload Engineering Basic Info.", "Reloading form will disregard all changes. Proceed?", "Yes", "No", function(){
																																	showQuotationCarrierInfoPage();
																																	changeTag = 0;
																																	carrierInfoTableGrid.keys.releaseKeys();
																																	} , "");
		}else{
			showQuotationCarrierInfoPage();
			carrierInfoTableGrid.keys.releaseKeys();
			changeTag = 0;
		}	
	});
	
	$("hideForm").observe("click", function (){
		if ($("hideForm").innerHTML == "Show")  {
			$("carDiv").show();
			$("hideForm").innerHTML = "Hide";
		}else{
			$("hideForm").innerHTML = "Show";
			$("carDiv").hide();
		}
	});
	
	$("btnEditQuotation").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveQuoteCarrierInfo();
						editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
					}, function(){
						carrierInfoTableGrid.keys.releaseKeys();
						editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
						changeTag = 0;
					}, "");
		}else{
			carrierInfoTableGrid.keys.releaseKeys();
			editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
			changeTag = 0;
		}
	});
	
	$("searchCarrierName").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		var objRows= carrierInfoTableGrid.geniisysRows;
		for ( var i = 0; i < objRows.length; i++) {
			if (objRows[i].recordStatus != -1) {
				if(withPrevious) notIn += ",";
				notIn += "'"+objRows[i].vesselCd+"'";
				withPrevious = true;
			}
		}
		notIn = (notIn != "" ? "("+notIn+")" : "");
		getCarrierVesselLOV($("lineCd").value, notIn);		
	});
	
	$("logout").observe("mousedown", function(){
		if(changeTag == 1){
			objGIIMM009.logoutPage = "Y";
		}else{
			objGIIMM009.logoutPage = null;
		}	
	});
	
</script>