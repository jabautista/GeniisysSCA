<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="carrierInfoMainDiv" name="carrierInfoMainDiv" style="margin-top: 1px;">
	<form id="carrierInfoMainForm" name="carrierInfoMainForm">
		<c:if test="${'Y' ne isPack}" >
			<jsp:include page="subPages/parInformation.jsp"></jsp:include>
		</c:if>		

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Carrier Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="carrierInfoDivAndFormDiv" name="carrierInfoDivAndFormDiv" class="sectionDiv" align="center" >
		<div style="width: 610px;  height: 250px; margin: 10px 0px 5px; align="center" id="carInfoTablegrid">
		</div>
 			<div id="carrierInfoDiv" name="carrierInfoDiv" style="margin: 10px; width: 600px;">
				<!-- div class="tableHeader" id="carrierInfoTable" name="carrierInfoTable">
					<label style="width: 430px; text-align: left; margin-left: 5px;">Carrier/Conveyance</label>
					<label style="width: 130px; text-align: left; margin-left: 5px;">Vessel Flag</label>
				</div> -->
				<div id="forDeleteDiv" name="forDeleteDiv" style="visibility: hidden;">
				</div>
				<div id="forInsertDiv" name="forInsertDiv" style="visibility: hidden;">
				</div>
			<div class="tableContainer" id="carrierInfoList" name="carrierInfoList">
					<c:forEach var="carrier" items="${carriers}">
						<div id='carrier${fn:join(fn:split(carrier.vesselCd, "  "), "")}' name="rowCarrier" class="tableRow">
							<input type="hidden" id='vesselCd${fn:join(fn:split(carrier.vesselCd, "  "), "")}'   	name="vesselCd"     value="${carrier.vesselCd}" />
							<input type="hidden" id='vesselName${fn:join(fn:split(carrier.vesselCd, "  "), "")}' 	name="vesselName" 	value="${carrier.vesselName}" />
							<input type="hidden" id='vesselFlag${fn:join(fn:split(carrier.vesselCd, "  "), "")}'	name="vesselFlag"	value="${carrier.vesselFlag}" />
							<input type="hidden" id='vesselType${fn:join(fn:split(carrier.vesselCd, "  "), "")}' 	name="vesselType"	value="${carrier.vesselType}" />
							<input type="hidden" id='recFlag${fn:join(fn:split(carrier.vesselCd, "  "), "")}'  		name="recFlag" 		value="${carrier.recFlag}" />
							
							<label style="width: 430px; text-align: left; margin-left: 5px;" title="${carrier.vesselName}" name="vesselName" id="vesselName${carrier.vesselCd}">${carrier.vesselName}</label>
							<label style="width: 130px; text-align: left; margin-left: 5px;" title="${carrier.vesselType}">${carrier.vesselType}</label>
					 	</div>
					</c:forEach>
				</div>
			</div> 
			
			<div id="carrierInfoFormDiv" name="carrierInfoFormDiv" style="width: 100%; margin: 30px 0px 5px 0px" changeTagAttr="true">
				<table align="center" width="50%">
					<tr>
					<input type="hidden" id="selectedInputVessel" name="selectedInputVessel"/>
						<td class="rightAligned" width="20%">Carrier/Conveyance</td>
						<td class="leftAligned" width="80%">
						<input type="hidden" id="hidMultiSw" name="hidMultiSw"/> 
						<span class="required lovSpan" style="width: 430px;">
									<input type="hidden" id="inputVessel" name="inputVessel"/> 								
									<input type="hidden" id="inputVesselRecFlag" name="inputVesselRecFlag"/>
									<input type="text" id="inputVesselDisplay" readonly="readonly"class="required" style="width: 405px;  float: left; border: medium none; height: 13px; margin: 0pt;" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCarrier" name="searchCarrier" alt="Go" style="float: right;"/>
						</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Vessel Flag</td>
						<td class="leftAligned"><input type="text" id="inputVesselFlag" name="inputVesselFlag" style="width: 60%" readonly="readonly"/></td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAddVesselInfo" name="btnAddVesselInfo" value="Add" />
				<input type="button" class="button disabledButton" style="width: 60px;" id="btnDeleteVesselInfo" name="btnDeleteVesselInfo" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="carrierInfoButtonsDiv">
			<input type="button" class="button" id="btnMaintVessel" 	name="btnMaintVessel" 	value="Maintain Vessel Info" />
			<input type="button" class="button" id="btnMaintInland" 	name="btnMaintInland" 	value="Maintain Inland Info" />
			<input type="button" class="button" id="btnMaintAircraft" 	name="btnMaintAircraft" value="Maintain Aircraft Info" />
			<input type="button" class="button" style="width: 90px;" id="btnCancelVesselInfo" name="btnCancelVesselInfo" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnSaveVesselInfo" name="btnSaveVesselInfo" value="Save" />
		</div>
	</form>
</div>
<div id="maintainDiv"></div>
<script type="text/javascript">
	setDocumentTitle("Enter Vessel Information");
	var parType = $("policyNo") == null ? "P" : "E";
	if (parType == "P") {
		setModuleId("GIPIS007");
	} else if (parType == "E") {
		setModuleId("GIPIS076");
	}
	var parIdTemp = objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"); //added by steven 11/13/2012
	/*addStyleToInputs();
	initializeAll();
	initializeTable("tableContainer", "rowCarrier", "", "");
	if("${isPack}" != "Y") setDocumentTitle("Carrier Information");
	checkTableIfEmpty("rowCarrier", "carrierInfoDiv");
	checkIfToResizeTable("carrierInfoList", "rowCarrier");
	initializeAccordion(); */
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
// 	setModuleId("GIPIS007"); remove by steven 11/13/2012  redundant code
	objUW.hidObjGIPIS007 = {}; //added by steven 11/13/2012
	
	if ('${giiss039Access}' == 0){ //Added by Jerome 09.01.2016 SR 5623
		disableButton("btnMaintVessel");
	}
	
	if('${giiss049Access}' == 0){ //Added by Jerome 09.01.2016 SR 5623
		disableButton("btnMaintAircraft");
	}
	
	if('${giiss050Access}' == 0){ //Added by Jerome 09.01.2016 SR 5623
		disableButton("btnMaintInland");
	}
	
	try {
		
		var objCarInfo = new Object();
		objCarInfo.objCarInfoTblGrid = JSON.parse('${jsonCarInfoTableGrid}'.replace(/\\/g, '\\\\'));
		objCarInfo.carInfo = objCarInfo.objCarInfoTblGrid.rows || [];
		var carInfoProto = new Object();
		var objGIPICarInfo = [];
		var carInfoTableModel = {
			url : contextPath
					+ "/GIPIWVesAirController?action=showWVesAirPage&globalParId="+ parIdTemp, //added by steven 11/13/2012
			options : {
				width : '610px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					var objCurrCarInfo = objGIPICarInfo[y];
					setCarInfoForm(objCurrCarInfo);
					currentRowIndex = y;
					tbgCarInfo.keys.removeFocus(tbgCarInfo.keys._nCurrentFocus,
							true);
					tbgCarInfo.keys.releaseKeys();
					disableButton("btnAddVesselInfo");
					enableButton("btnDeleteVesselInfo");
					$("searchCarrier").hide();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					currentRowIndex = -1;
					setCarInfoForm(null);
					enableButton("btnAddVesselInfo");
					disableButton("btnDeleteVesselInfo");
					$("searchCarrier").show();
				},
				afterRender : function() {
					showCarrierInfoPage();
					$("searchCarrier").show();
				},
				onRefresh : function() {
					setCarInfoForm(null);
					enableButton("btnAddVesselInfo");
					disableButton("btnDeleteVesselInfo");
					$("searchCarrier").show();
				},
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						setCarInfoForm(null);
						enableButton("btnAddVesselInfo");
						disableButton("btnDeleteVesselInfo");
						$("searchCarrier").show();
					},
					onFilter : function() {
						setCarInfoForm(null);
						enableButton("btnAddVesselInfo");
						disableButton("btnDeleteVesselInfo");
						$("searchCarrier").show();
					}
				},
				onSort : function() {
					tbgCarInfo.keys.removeFocus();
					tbgCarInfo.releaseKeys();
					setCarInfoForm(null);
					enableButton("btnAddVesselInfo");
					disableButton("btnDeleteVesselInfo");
					$("searchCarrier").show();
				},
				beforeSort : function() {
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveVesselInfo").focus();
						});
						return false;
					}
					/* if (changeTag == 1) {
						showConfirmBox4("CONFIRMATION",
								objCommonMessage.WITH_CHANGES, "Yes", "No",
								"Cancel", function() {
									saveCarInfoPageChanges();
									$("searchCarrier").show();
								}, function() {
									showCarrierInfoPage();
									 $("searchCarrier").show(); 
									changeTag = 0;
								}, "");
						return false;
					} else {
						return true;
					} */
				},
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveVesselInfo").focus();
						});
						return false;
					}
				},
				postPager : function() {
					tbgCarInfo.keys.removeFocus();
					tbgCarInfo.releaseKeys();
					setCarInfoForm(null);
					enableButton("btnAddVesselInfo");
					disableButton("btnDeleteVesselInfo");
					$("searchCarrier").show();
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
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'vesselName',
				title : 'Carrier/Conveyance',
				width : '300px',
				align : 'left',
				filterOption : true,
				sortable : true
			}, {
				id : 'vesselType',
				title : 'Vessel Flag',
				width : '300px',
				align : 'left',
				filterOption : true,
				sortable : true
			}, {
				id : 'multiSw',
				width : '0',
				visible: false
			}
			],
			rows : objCarInfo.carInfo
		};
		tbgCarInfo = new MyTableGrid(carInfoTableModel);
		tbgCarInfo.pager = objCarInfo.objCarInfoTblGrid;
		tbgCarInfo.render('carInfoTablegrid');
		tbgCarInfo.afterRender = function() {
			objGIPICarInfo = tbgCarInfo.geniisysRows;
		};
		 initializeChangeTagBehavior(saveCarInfoPageChanges); 
	} catch (e) {
		showErrorMessage("Carrier Information", e);
	}
	
	//populate func
	function setCarInfoForm(obj) {
		try {
			$("selectedInputVessel").value = (obj) == null ? "" : (nvl(
					unescapeHTML2(obj.vesselCd), ""));
			$("inputVessel").value = (obj) == null ? ""
					: (nvl(unescapeHTML2(obj.vesselCd), ""));
			$("inputVesselRecFlag").value = (obj) == null ? "" : (nvl(
					unescapeHTML2(obj.recFlag), ""));
			$("inputVesselDisplay").value = (obj) == null ? "" : (nvl(
					unescapeHTML2(obj.vesselName), ""));
			$("inputVesselFlag").value = (obj) == null ? "" : (nvl(
					unescapeHTML2(obj.vesselType), ""));
			$("hidMultiSw").value = (obj) == null ? "" : (nvl(obj.multiSw, ""));
		} catch (e) {
			showErrorMessage("setCarInfoForm", e);
		}
	}
	
	//gettter func
	function getCarInfoFormToObj() {
		try {
			var obj = new Object();
			obj.vesselCd = $F("inputVessel");
			obj.recFlag = $F("inputVesselRecFlag");
			obj.vesselFlag = $F("inputVesselRecFlag");
			obj.vesselName = $F("inputVesselDisplay");
			obj.vesselType = $("inputVesselFlag").value;
			obj.lineCd = objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"); //added by steven 11/13/2012 
			obj.parId = parseInt(parIdTemp);
			obj.recordStatus = "";
			obj.multiSw = $F("hidMultiSw");
			return obj;
		} catch (e) {
			showErrorMessage("getCarInfoFormToObj", e);
		}
	}
	$("btnAddVesselInfo").observe("click",function(){
		
		if ($("inputVesselDisplay").value == "") {
			showMessageBox("Required fields must be entered.",
					imgMessage.ERROR);
			$("inputVesselDisplay").focus();
		} else {
			addCI();
		}
	});
	$("btnDeleteVesselInfo").observe("click",function(){
		delCI();
	});
	
	//add func
	
	function addCI() {
		try {
			var newCarInfo = getCarInfoFormToObj();
			newCarInfo.recordStatus = 0;
			objGIPICarInfo.push(newCarInfo);
			tbgCarInfo.addBottomRow(newCarInfo);
			changeTag = 1;
			tbgCarInfo.keys.removeFocus();
			tbgCarInfo.releaseKeys();
			setCarInfoForm(null);
			enableButton("btnAddVesselInfo");
			disableButton("btnDeleteVesselInfo");
		} catch (e) {
			showErrorMessage("addCI", e);
		}
	}
	
	//del func
	function delCI() {
		try {
			var delObj = getCarInfoFormToObj();
			for ( var i = 0; i < objGIPICarInfo.length; i++) {
				if ((objGIPICarInfo[i].vesselCd == delObj.vesselCd)
						&& (objGIPICarInfo[i].recordStatus != -1)) {
					delObj.recordStatus = -1;
					objGIPICarInfo.splice(i, 1, delObj);
					tbgCarInfo.deleteRow(tbgCarInfo.getCurrentPosition()[1]);
					changeTag = 1;
				}
			}
			tbgCarInfo.keys.removeFocus();
			tbgCarInfo.releaseKeys();
			setCarInfoForm(null);
			enableButton("btnAddVesselInfo");
			disableButton("btnDeleteVesselInfo");
			$("searchCarrier").show();
		} catch (e) {
			showErrorMessage("delCI", e);
		}
	}
	
	//search using LOV
	$("searchCarrier").observe("click", function() {
		var notIn = "";
		var withPrevious = false;
		try {
			objGIPICarInfo.filter(function(obj) {
				return obj.recordStatus != -1;
			}).each(function(row) {
				if (withPrevious)
					notIn += ",";
				notIn += "'" + row.vesselCd + "'";
				withPrevious = true;
			});
			notIn = (notIn != "" ? "(" + notIn + ")" : "");
			showCarInfoLOV((objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")) /* added by steven 11/13/2012 */ , notIn);
		} catch (e) {
			showErrorMessage("searchCarrier", e);
		}

	});
	
	//save func
	function saveCarInfoPageChanges(){
		try{			
				objParam = new Object();
				objParam.setCI = getAddedAndModifiedJSONObjects(objGIPICarInfo);
				objParam.delCI = getDeletedJSONObjects(objGIPICarInfo);
				new Ajax.Request(contextPath+"/GIPIWVesAirController?action=saveCarrierInfo",{
					method: "POST",
					parameters:{
					parameters: JSON.stringify(objParam)	
					},
					onCreate:function(){
						showNotice("Saving Carrier Information. Please Wait...");	
					},
					onComplete: function(response) {
						hideNotice("");
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							if(response.responseText == "SUCCESS"){
								changeTag=0;
								tbgCarInfo.refresh();
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									if (lastAction != "" && lastAction != null) lastAction();
									lastAction = "";}
								);
							}
							
						}
					}
				});
		}catch (e){
			showErrorMessage("saveCarInfoPageChanges", e);
		}
	}
	objUW.hidObjGIPIS007.saveCarInfoPageChanges = saveCarInfoPageChanges;


 	$("btnSaveVesselInfo").observe("click", function() {
		if (changeTag == 0) {
			showMessageBox("No changes to save.");
		} else {
			saveCarInfoPageChanges();
		}
	}); 

 	$("btnCancelVesselInfo").observe(
			"click",
			function() {
				if (changeTag == 1) {
					showConfirmBox4("Confirmation",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
						saveCarInfoPageChanges();
								showListing();
							}, showListing, "");
				} else {
					showListing();
				}
			});
	
 	function showListing(){
		if(objUWGlobal.packParId != null){
			showPackParListing();
		} else {
			if (parType == "P"){
				showParListing();
			}else if(parType == "E"){
				showEndtParListing();
			}
		}
	}
 	
 	//	edited by gab 10.21.2015
	//	observeReloadForm("reloadForm", showCarrierInfoPage);
	observeReloadForm("reloadForm", function(){
		changeTag = 0;
		showCarrierInfoPage();
	});
	
	function loadMaintModule(modId){
		if (parType == "P") {
			objUWGlobal.callingForm = "GIPIS007";
		} else if (parType == "E") {
			objUWGlobal.callingForm = "GIPIS076";
		}
		
		if (modId == "GIISS039"){
			showGiiss039();
		}else if (modId == "GIISS049"){
			showGIISS049();
		}else if (modId == "GIISS050"){
			showGIISS050();
		}
	}
	
	$("btnMaintVessel").observe("click", function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						lastAction = function(){
							loadMaintModule("GIISS039");
						};
						saveCarInfoPageChanges();
					}, function(){
						changeTag = 0;
						tbgCarInfo.refresh();
						loadMaintModule("GIISS039");
					}, "");
		}else{
			loadMaintModule("GIISS039");
		}		
	});
	$("btnMaintInland").observe("click", function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						lastAction = function(){
							loadMaintModule("GIISS050");
						};
						saveCarInfoPageChanges();
					}, function(){
						changeTag = 0;
						tbgCarInfo.refresh();
						loadMaintModule("GIISS050");
					}, "");
		}else{
			loadMaintModule("GIISS050");
		}
	});	
	$("btnMaintAircraft").observe("click", function(){
		//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						lastAction = function(){
							loadMaintModule("GIISS049");
						};
						saveCarInfoPageChanges();
					}, function(){
						changeTag = 0;
						tbgCarInfo.refresh();
						loadMaintModule("GIISS049");
					}, "");
		}else{
			loadMaintModule("GIISS049");
		}
	});
</script>