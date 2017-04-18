<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reinsurerMaintenance" name="reinsurerMaintenance" style="float: left; width: 100%;">
	<div id="reinsurerMaintenanceExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Reinsurer Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">			
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="reinsurerTable" style="height: 337px;width:900px;"></div>
			</div>	
			<div>	
				<div id="reinsurerFormDiv" align="center">
					<table>					
						<tr>
							<td class="rightAligned">RI Code</td>
							<td>
								<input id="txtRiCode" class="rightAligned" maxlength="6" readonly="readonly" type="text" style="width:270px;" tabindex="200">
								<input id="hidRiCode" type="hidden">
							</td>
							<td class="rightAligned" style="width: 150px;">Short Name</td>
							<td><input class="required" id="txtShortName" maxlength="15" type="text" style="width:270px;" tabindex="201"></td>
						</tr>	
						<tr>
							<td class="rightAligned">RI Name</td>
							<td colspan="3">
								<input class="required" id="txtRiName" maxlength="50" type="text" style="width:706px;" tabindex="202">
								<input id="hidRiName" type="hidden">
							</td>							
						</tr>
						<tr>
							<td class="rightAligned">Mailing Address</td>
							<td><input class="required" id="txtMailAddress1" maxlength="50" type="text" style="width:270px;" tabindex="203"></td>
							<td class="rightAligned" style="width: 150px;">Billing Address</td>
							<td><input id="txtBillAddress1" maxlength="50" type="text" style="width:270px;" tabindex="204"></td>
						</tr>
						<tr>
							<td></td>
							<td><input id="txtMailAddress2" maxlength="50" type="text" style="width:270px;" tabindex="205"></td>
							<td></td>
							<td><input id="txtBillAddress2" maxlength="50" type="text" style="width:270px;" tabindex="206"></td>
						</tr>
						<tr>
							<td></td>
							<td><input id="txtMailAddress3" maxlength="50" type="text" style="width:270px;" tabindex="207"></td>
							<td></td>
							<td><input id="txtBillAddress3" maxlength="50" type="text" style="width:270px;" tabindex="208"></td>
						</tr>
						<tr>
							<td class="rightAligned">Contact No.</td>
							<td><input id="txtContactNo" maxlength="40" type="text" style="width:270px;" tabindex="209"></td>
							<td class="rightAligned" style="width: 150px;">Contact</td>
							<td><input id="txtContact" maxlength="50" type="text" style="width:270px;" tabindex="210"></td>
						</tr>
						<tr>
							<td class="rightAligned">Default Mobile No.</td>
							<td><input id="txtDefaultMobileNo" maxlength="40" type="text" style="width:270px;" tabindex="211"></td>
							<td class="rightAligned" style="width: 150px;">Sun Mobile No.</td>
							<td><input id="txtSunMobileNo" maxlength="40" type="text" style="width:270px;" tabindex="212"></td>
						</tr>
						<tr>
							<td class="rightAligned">Smart Mobile No.</td>
							<td><input id="txtSmartMobileNo" maxlength="40" type="text" style="width:270px;" tabindex="213"></td>
							<td class="rightAligned" style="width: 150px;">Globe Mobile No.</td>
							<td><input id="txtGlobeMobileNo" maxlength="40" type="text" style="width:270px;" tabindex="214"></td>
						</tr>
						<tr>
							<td class="rightAligned">Fax No.</td>
							<td><input id="txtFaxNo" maxlength="40" type="text" style="width:270px;" tabindex="215"></td>
							<td class="rightAligned" style="width: 150px;">Telex No.</td>
							<td><input id="txtTelexNo" maxlength="40" type="text" style="width:270px;" tabindex="216"></td>
						</tr>	
						<tr>
							<td class="rightAligned">Tax Rate</td>
							<td><input class="rightAligned money2" id="txtTaxRate" maxlength="9" type="text" style="width:120px;" tabindex="217">&nbsp&nbsp&nbspInput VAT&nbsp<input class="rightAligned money2" id="txtInputVat" type="text" maxlength="6" style="width:70px;" tabindex="218">
							</td>
							<td class="rightAligned" style="width: 150px;">TIN</td>
							<td><input id="txtTin" maxlength="30" type="text" style="width:270px;" tabindex="219"></td>
						</tr>
						<tr>
							<td class="rightAligned">Attention</td>
							<td><input id="txtAttention" maxlength="50" type="text" style="width:270px;" tabindex="220"></td>
							<td class="rightAligned" style="width: 150px;">License</td>
							<td><input id="txtLicense" maxlength="15" type="text" style="width:270px;" tabindex="221"></td>
						</tr>
						<tr>
							<td class="rightAligned">Pres. & XO's</td>
							<td><input id="txtPresXos" maxlength="255" type="text" style="width:270px;" tabindex="222"></td>
							<td class="rightAligned" style="width: 150px;">Eff. Date</td>
							<td class="leftAligned" style="padding-left: 1px;">
								<div style="float: left; width: 100px;" class="withIconDiv">
									<input type="text" id="txtEffDate" name="txtEffDate" class="withIcon disableDelKey" readonly="readonly" style="width: 75px;" tabindex="223"/>
									<img id="hrefEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Effectivity Date" onclick="scwShow($('txtEffDate'),this, null);" tabindex="224"/>
								</div>
							<label class="rightAligned" style="margin: 5px 4px 0 10px;">Exp. Date</label>
								<div style="float: left; width: 100px;" class="withIconDiv">
									<input type="text" id="txtExpDate" name="txtExpDate" class="withIcon disableDelKey" readonly="readonly" style="width: 75px;" tabindex="225"/>
									<img id="hrefExpDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" onclick="scwShow($('txtExpDate'),this, null);" tabindex="226"/>
								</div>
							</td>							
						</tr>
						<tr>
							<td class="rightAligned">Line Net Ret.</td>
							<td><input id="txtLineNetRet" maxlength="160" type="text" style="width:270px;" tabindex="227"></td>
							<td class="rightAligned" style="width: 150px;">Facilities</td>
							<td><input id="txtFacilities" maxlength="4000" type="text" style="width:270px;" tabindex="228"></td>
						</tr>
						<tr>
							<td class="rightAligned">Net Ret</td>
							<td><input class="rightAligned money2" id="txtNetRet" maxlength="22" type="text" style="width:270px;" tabindex="229"></td>
							<td class="rightAligned" style="width: 150px;">Asset</td>
							<td><input class="rightAligned money2" id="txtAsset" maxlength="22" type="text" style="width:270px;" tabindex="230"></td>
						</tr>
						<tr>
							<td class="rightAligned">Liability</td>
							<td><input class="rightAligned money2" id="txtLiability" maxlength="22" type="text" style="width:270px;" tabindex="231"></td>
							<td class="rightAligned" style="width: 150px;">Net Worth</td>
							<td><input class="rightAligned money2" id="txtNetWorth" maxlength="22" type="text" style="width:270px;" tabindex="232"></td>
						</tr>
						<tr>
							<td class="rightAligned">Filipino Part</td>
							<td><input class="rightAligned money2" id="txtFilipinoPart" maxlength="9" type="text" style="width:270px;" tabindex="233"></td>
							<td class="rightAligned" style="width: 150px;">Status</td>
							<td><span class="lovSpan" style="width: 60px; margin-top:2px;height:19px;">
									<input id="txtStatus" maxlength="2" type="text" style="width:35px;margin: 0;height:13px;border: 0" class="rightAligned integerNoNegative required" tabindex="234"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchStatus" alt="Go" style="float: right; margin-top: 2px;" class="required" tabindex="235"/>
								</span>	
								&nbsp<input readonly="readonly" id="txtStatusDesc" maxlength="20" type="text" style="width:204px;" tabindex="236">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">RI Base</td>
							<td>
								<select id="dDnMenuRiBase" class="required" name="dDnMenuRiBase" maxlength="30" style="text-align: left; width: 100%;" tabindex="237">
									<option></option>
									<c:forEach var="ribase" items="${riBaseList}">
										<option value="${ribase.rvLowValue}">${ribase.rvMeaning}</option>				
									</c:forEach> 									
 								</select>
 							</td>
							<td class="rightAligned" style="width: 150px;">RI Type</td>
							<td><span class="lovSpan" style="width: 276px; margin-top:2px;height:19px;">
									<input class="required" id="txtRiType" maxlength="30" type="text" style="width:251px;margin: 0;height:13px;border: 0" tabindex="238"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchRiType" alt="Go" style="float: right; margin-top: 2px;" class="required" tabindex="239"/>
								</span>	
								<input id="hidRiType" type="hidden">
							</td>
						</tr>									
						<tr>
							<td class="rightAligned">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width:712px; margin: 0">
										<input maxlength="4000"
										style="width: 687px; float: left; height: 14px; border: none; margin:0"
										type="text" id="txtRemarks" tabindex="240"/> 
										<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										id="imgEditRemarks" alt="Go" style="float: right; margin-top: 2px;" tabindex="241"/>
								</span>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td><input id="txtUserId" type="text" style="width:270px" readonly="readonly" tabindex="242"></td>
							<td class="rightAligned" style="width: 70px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:270px" readonly="readonly" tabindex="243"></td>
						</tr>				
					</table>	
				</div>
				<div align="center" style="margin: 15px">
					<div>
						<input type="button" class="button" id="btnAdd" value="Add" tabindex="244">
						<input type="button" class="button" id="btnDelete" value="Delete" tabindex="245">
					</div>
				</div>
			</div>
		</div>		
	</div>	
	<div class="sectionDiv" style="border: 0; margin-bottom: 50px;margin-top: 15px" align="center">
		<div>
			<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="246">
			<input type="button" class="button" id="btnSave" value="Save" tabindex="247">
		</div>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIISS030");
	setDocumentTitle("Reinsurer Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var rowIndex = -1;
	var allRecObj = {};
	var addMaxRiCd;
	changeTag = 0;
	
	var objGIISS030 = {};
	var objReinsurer = {};
	var objCurrReinsurer = null;
	objGIISS030.reinsurerList = JSON.parse('${jsonReinsurerList}');
	objGIISS030.exitPage = null;

	function saveGiiss030(){
		try{	
			if(changeTag == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var setRows = getAddedAndModifiedJSONObjects(tbgReinsurer.geniisysRows);
			new Ajax.Request(contextPath+"/GIISReinsurerController", {
				method: "POST",
				parameters : {action : "saveGiiss030",
						 	  setRows : prepareJsonAsParameter(setRows)
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIISS030.exitPage != null) {
								objGIISS030.exitPage();
							} else {
								tbgReinsurer._refreshList();
							}
						});
						changeTag = 0;
					}
				}
			});			
		}catch(e){
			showErrorMessage("saveGiiss030", e);
		}
	}
	
	var reinsurerTable = {
			url : contextPath + "/GIISReinsurerController?action=showGiiss030&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrReinsurer = tbgReinsurer.geniisysRows[y];
					setFieldValues(objCurrReinsurer);	
					setObjVDefault(objCurrReinsurer);
					setObjReinsurer(objCurrReinsurer);
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();						
					$("txtShortName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					setObjVDefault(null);
					setObjReinsurer(null);
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();
					$("txtShortName").focus();	
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						setObjVDefault(null);	
						setObjReinsurer(null);
						tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
						tbgReinsurer.keys.releaseKeys();
						$("txtShortName").focus();	
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}	
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();
				},
				onSort: function(){					
					rowIndex = -1;
					setFieldValues(null);
					setObjVDefault(null);	
					setObjReinsurer(null);
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();
					$("txtShortName").focus();	
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					setObjVDefault(null);	
					setObjReinsurer(null);
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();
					$("txtShortName").focus();	
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					setObjVDefault(null);	
					setObjReinsurer(null);
					tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
					tbgReinsurer.keys.releaseKeys();
					$("txtShortName").focus();	
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
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "riCd",
					title : "RI Code",
					width : '120px',
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative'	
				}, 
				{
					id : "riSname",
					title : "Short Name",			
					width : '210px',
					align : "left",
					titleAlign : "left",
					filterOption : true,
				}, 
				{
					id : "riName",
					title : "RI Name",
					width : '538',
					align : "left",
					titleAlign : "left",
					filterOption : true,		
				}
			],
			rows : objGIISS030.reinsurerList.rows
		};

		tbgReinsurer = new MyTableGrid(reinsurerTable);
		tbgReinsurer.pager = objGIISS030.reinsurerList;
		tbgReinsurer.render("reinsurerTable");
		tbgReinsurer.afterRender = function(){
     		allRecObj = getAllRecord();				
		};	
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISReinsurerController", {
				parameters : {action : "getAllReinsurer"},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, '\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	function getRiStatusLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getRiStatusLOV",
				searchString : ($("txtStatus").readAttribute("lastValidValue") != $F("txtStatus") ? nvl($F("txtStatus"),"%") : "%"),
				page : 1,				
			},
			title : "List of RI Statuses",
			width : 420,
			height : 386,
			columnModel : [{
				id : "statusCd",
				title : "Status Code",
				width : '135px',
				titleAlign: 'right',
				align: 'right'
			},{
				id : "statusDesc",
				title : "Description",
				width : '270px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtStatus").readAttribute("lastValidValue") != $F("txtStatus") ? nvl($F("txtStatus"),"%") : "%"),
			onSelect : function(row) {
				$("txtStatus").value = row.statusCd;	
				$("txtStatusDesc").value = unescapeHTML2(row.statusDesc);				
				$("txtStatus").setAttribute("lastValidValue", row.statusCd);
				$("txtStatusDesc").setAttribute("lastValidValue", unescapeHTML2(row.statusDesc));			
			},
			onCancel : function() {
				$("txtStatus").value = $("txtStatus").readAttribute("lastValidValue");
				$("txtStatusDesc").value=$("txtStatusDesc").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtStatus");		
				$("txtStatus").value = $("txtStatus").readAttribute("lastValidValue");
				$("txtStatusDesc").value=$("txtStatusDesc").readAttribute("lastValidValue");	
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getRiTypeLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getRiTypeLOV",
				searchString : ($("txtRiType").readAttribute("lastValidValue") != $F("txtRiType") ? nvl($F("txtRiType"),"%") : "%"),
				page : 1,				
			},
			title : "List of Reinsurer Types",
			width : 420,
			height : 386,
			columnModel : [{
				id : "riType",
				title : "RI Type",
				width : '135px',
			},{
				id : "riTypeDesc",
				title : "Description",
				width : '270px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtRiType").readAttribute("lastValidValue") != $F("txtRiType") ? nvl(escapeHTML2($F("txtRiType")),"%") : "%"),
			onSelect : function(row) {
				$("txtRiType").value = unescapeHTML2(row.riTypeDesc);									
				$("txtRiType").setAttribute("lastValidValue", unescapeHTML2(row.riTypeDesc));	
				$("hidRiType").value = unescapeHTML2(row.riType);
			},
			onCancel : function() {
				$("txtRiType").value = $("txtRiType").readAttribute("lastValidValue");				
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtRiType");		
				$("txtRiType").value = $("txtRiType").readAttribute("lastValidValue");			
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	

	function setFieldValues(obj){
		try{			
			$("txtRiCode").value = obj == null ? "" : (obj.riCd == null ?"":unescapeHTML2(obj.riCd));
			$("hidRiCode").value = obj == null ? "" : (obj.riCd == null ?"":unescapeHTML2(obj.riCd));
			$("txtShortName").value = obj == null ? "" : (obj.riSname == null ?"":unescapeHTML2(obj.riSname));
			$("txtRiName").value = obj == null ? "" : (obj.riName == null ?"":unescapeHTML2(obj.riName));
			$("hidRiName").value = obj == null ? "" : (obj.riName == null ?"":unescapeHTML2(obj.riName));
			$("txtMailAddress1").value = obj == null ? "" : (obj.mailAddress1 == null ?"":unescapeHTML2(obj.mailAddress1));
			$("txtBillAddress1").value = obj == null ? "" : (obj.billAddress1 == null ?"":unescapeHTML2(obj.billAddress1));
			$("txtMailAddress2").value = obj == null ? "" : (obj.mailAddress2 == null ?"":unescapeHTML2(obj.mailAddress2));
			$("txtBillAddress2").value = obj == null ? "" : (obj.billAddress2 == null ?"":unescapeHTML2(obj.billAddress2));
			$("txtMailAddress3").value = obj == null ? "" : (obj.mailAddress3 == null ?"":unescapeHTML2(obj.mailAddress3));
			$("txtBillAddress3").value = obj == null ? "" : (obj.billAddress3 == null ?"":unescapeHTML2(obj.billAddress3));
			$("txtContactNo").value = obj == null ? "" : (obj.phoneNo == null ?"":unescapeHTML2(obj.phoneNo));
			$("txtContact").value = obj == null ? "" : (obj.contactPers == null ?"":unescapeHTML2(obj.contactPers));
			$("txtDefaultMobileNo").value = obj == null ? "" : (obj.cpNo == null ?"":unescapeHTML2(obj.cpNo));
			$("txtSunMobileNo").value = obj == null ? "" : (obj.sunNo == null ?"":unescapeHTML2(obj.sunNo));
			$("txtSmartMobileNo").value = obj == null ? "" : (obj.smartNo == null ?"":unescapeHTML2(obj.smartNo));
			$("txtGlobeMobileNo").value = obj == null ? "" : (obj.globeNo == null ?"":unescapeHTML2(obj.globeNo));
			$("txtFaxNo").value = obj == null ? "" : (obj.faxNo == null ?"":unescapeHTML2(obj.faxNo));
			$("txtTelexNo").value = obj == null ? "" : (obj.telexNo == null ?"":unescapeHTML2(obj.telexNo));
			$("txtTaxRate").value = obj == null ? "" : (obj.intTaxRt == null ?"":formatToNthDecimal(unescapeHTML2(obj.intTaxRt),4));
			$("txtInputVat").value = obj == null ? "" : (obj.inputVatRate == null ?"":formatToNthDecimal(unescapeHTML2(obj.inputVatRate),2));
			$("txtTin").value = obj == null ? "" : (obj.riTin == null ?"":unescapeHTML2(obj.riTin));
			$("txtAttention").value = obj == null ? "" : (obj.attention == null ?"":unescapeHTML2(obj.attention));
			$("txtLicense").value = obj == null ? "" : (obj.liscenceNo == null ?"":unescapeHTML2(obj.liscenceNo));
			$("txtPresXos").value = obj == null ? "" : (obj.presAndXos == null ?"":unescapeHTML2(obj.presAndXos));
			$("txtEffDate").value = obj == null ? "" : (obj.effDate == null ?"":unescapeHTML2(obj.effDate));
			$("txtExpDate").value = obj == null ? "" : (obj.expiryDate == null ?"":unescapeHTML2(obj.expiryDate));
			$("txtLineNetRet").value = obj == null ? "" : (obj.maxLineNetRet == null ?"":unescapeHTML2(obj.maxLineNetRet));
			$("txtFacilities").value = obj == null ? "" : (obj.facilities == null ?"":unescapeHTML2(obj.facilities));
			$("txtNetRet").value = obj == null ? "" : (obj.maxNetRet == null ?"":formatCurrency(unescapeHTML2(obj.maxNetRet)));
			$("txtAsset").value = obj == null ? "" : (obj.totAsset == null ?"":formatCurrency(unescapeHTML2(obj.totAsset)));
			$("txtLiability").value = obj == null ? "" : (obj.totLiab == null ?"":formatCurrency(unescapeHTML2(obj.totLiab)));
			$("txtNetWorth").value = obj == null ? "" : (obj.totNetWorth == null ?"":formatCurrency(unescapeHTML2(obj.totNetWorth)));
			$("txtFilipinoPart").value = obj == null ? "" : (obj.capitalStruc == null ?"":formatToNthDecimal(unescapeHTML2(obj.capitalStruc),4));
			$("txtStatus").value = obj == null ? "" : (obj.riStatusCd == null ?"":unescapeHTML2(obj.riStatusCd));
			$("txtStatusDesc").value = obj == null ? "" : (obj.riStatusDesc == null ?"":unescapeHTML2(obj.riStatusDesc));
			$("dDnMenuRiBase").value = obj == null ? "" : (obj.localForeignSw == null ?"":unescapeHTML2(obj.localForeignSw));
			$("txtRiType").value = obj == null ? "" : (obj.riTypeDesc == null ?"":unescapeHTML2(obj.riTypeDesc));
			$("hidRiType").value = obj == null ? "" : (obj.riType == null ?"":unescapeHTML2(obj.riType));
			$("txtRemarks").value = obj == null ? "" : (obj.remarks == null ?"":unescapeHTML2(obj.remarks));
			$("txtUserId").value = obj == null ? "" : (obj.userId == null ?"":unescapeHTML2(obj.userId));
			$("txtLastUpdate").value = obj == null ? "" : (obj.lastUpdate == null ?"":unescapeHTML2(obj.lastUpdate));
			$("txtStatus").setAttribute("lastValidValue", obj == null ? "": (obj.riStatusCd==null? "":obj.riStatusCd));
			$("txtStatusDesc").setAttribute("lastValidValue", obj == null ? "": (obj.riStatusDesc==null? "":obj.riStatusDesc));	
			$("txtRiType").setAttribute("lastValidValue", obj == null ? "": (obj.riTypeDesc==null? "":obj.riTypeDesc));
			
			obj == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			obj == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrReinsurer = obj;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}			
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);		
			obj.riCd = $("hidRiCode").value;	
			obj.localForeignSw = escapeHTML2($("dDnMenuRiBase").value);
			obj.riStatusCd = escapeHTML2($("txtStatus").value);
			obj.riSname = escapeHTML2($("txtShortName").value);
			obj.riName = escapeHTML2($("txtRiName").value);		
			obj.mailAddress1 = escapeHTML2($("txtMailAddress1").value);
			obj.mailAddress2 = escapeHTML2($("txtMailAddress2").value);
			obj.mailAddress3 = escapeHTML2($("txtMailAddress3").value);	
			obj.billAddress1 = escapeHTML2($("txtBillAddress1").value);
			obj.billAddress2 = escapeHTML2($("txtBillAddress2").value);		
			obj.billAddress3 = escapeHTML2($("txtBillAddress3").value);
			obj.phoneNo = escapeHTML2($("txtContactNo").value);
			obj.faxNo = escapeHTML2($("txtFaxNo").value);
			obj.telexNo = escapeHTML2($("txtTelexNo").value);
			obj.contactPers = escapeHTML2($("txtContact").value);
			obj.attention = escapeHTML2($("txtAttention").value);
			obj.intTaxRt = $("txtTaxRate").value;		
			obj.presAndXos = escapeHTML2($("txtPresXos").value);
			obj.liscenceNo = escapeHTML2($("txtLicense").value);			
			obj.maxLineNetRet = escapeHTML2($("txtLineNetRet").value);			
			obj.maxNetRet = $F("txtNetRet").replace(/,/g, "");
			obj.totAsset = $F("txtAsset").replace(/,/g, "");
			obj.totLiab = $F("txtLiability").replace(/,/g, "");
			obj.totNetWorth = $F("txtNetWorth").replace(/,/g, "");
			obj.capitalStruc = $("txtFilipinoPart").value;			
			obj.riType = escapeHTML2($("hidRiType").value);			
			obj.effDate = $("txtEffDate").value;		
			obj.expiryDate = $("txtExpDate").value;
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.remarks = escapeHTML2($("txtRemarks").value);
			obj.cpNo = $("txtDefaultMobileNo").value;
			obj.sunNo = $("txtSunMobileNo").value;
			obj.smartNo = $("txtSmartMobileNo").value;			
			obj.globeNo = $("txtGlobeMobileNo").value;					
			obj.inputVatRate = $("txtInputVat").value;
			obj.riTin = escapeHTML2($("txtTin").value);
			obj.facilities = escapeHTML2($("txtFacilities").value);
			obj.riStatusDesc = escapeHTML2($("txtStatusDesc").value);	
			obj.riTypeDesc = escapeHTML2($("txtRiType").value);	
			
			rec == null ? obj.newRecord = "Yes" : obj.newRecord = rec.newRecord;
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function setObjReinsurer(obj) {
		try {					
			objReinsurer.riCd = obj == null ? "" : (obj.riCd==null?"":obj.riCd);
			objReinsurer.localForeignSw = obj == null ? "" : (obj.localForeignSw==null?"":obj.localForeignSw);	
			objReinsurer.riStatusCd = obj == null ? "" : (obj.riStatusCd==null?"":obj.riStatusCd);
			objReinsurer.riSname = obj == null ? "" : (obj.riSname==null?"":obj.riSname);
			objReinsurer.riName = obj == null ? "" : (obj.riName==null?"":obj.riName);		
			objReinsurer.mailAddress1 = obj == null ? "" : (obj.mailAddress1==null?"":obj.mailAddress1);
			objReinsurer.mailAddress2 = obj == null ? "" : (obj.mailAddress2==null?"":obj.mailAddress2);			
			objReinsurer.mailAddress3 = obj == null ? "" : (obj.mailAddress3==null?"":obj.mailAddress3);			
			objReinsurer.billAddress1 = obj == null ? "" : (obj.billAddress1==null?"":obj.billAddress1);			
			objReinsurer.billAddress2 = obj == null ? "" : (obj.billAddress2==null?"":obj.billAddress2);			
			objReinsurer.billAddress3 = obj == null ? "" : (obj.billAddress3==null?"":obj.billAddress3);			
			objReinsurer.phoneNo = obj == null ? "" : (obj.phoneNo==null?"":obj.phoneNo);			
			objReinsurer.faxNo = obj == null ? "" : (obj.faxNo==null?"":obj.faxNo);			
			objReinsurer.telexNo = obj == null ? "" : (obj.telexNo==null?"":obj.telexNo);				
			objReinsurer.contactPers = obj == null ? "" : (obj.contactPers==null?"":obj.contactPers);			
			objReinsurer.attention = obj == null ? "" : (obj.attention==null?"":obj.attention);			
			objReinsurer.intTaxRt = obj == null ? "" : (obj.intTaxRt==null?"":formatToNthDecimal(obj.intTaxRt,4));			
			objReinsurer.presAndXos = obj == null ? "" : (obj.presAndXos==null?"":obj.presAndXos);			
			objReinsurer.liscenceNo = obj == null ? "" : (obj.liscenceNo==null?"":obj.liscenceNo);			
			objReinsurer.maxLineNetRet = obj == null ? "" : (obj.maxLineNetRet==null?"":obj.maxLineNetRet);			
			objReinsurer.maxNetRet = obj == null ? "" : (obj.maxNetRet==null?"":formatToNthDecimal(obj.maxNetRet,2));			
			objReinsurer.totAsset = obj == null ? "" : (obj.totAsset==null?"":formatToNthDecimal(obj.totAsset,2));			
			objReinsurer.totLiab = obj == null ? "" : (obj.totLiab==null?"":formatToNthDecimal(obj.totLiab,2));			
			objReinsurer.totNetWorth = obj == null ? "" : (obj.totNetWorth==null?"":formatToNthDecimal(obj.totNetWorth,2));			
			objReinsurer.capitalStruc = obj == null ? "" : (obj.capitalStruc==null?"":formatToNthDecimal(obj.capitalStruc,4));			
			objReinsurer.riType = obj == null ? "" : (obj.riType==null?"":obj.riType);			
			objReinsurer.effDate = obj == null ? "" : (obj.effDate==null?"":obj.effDate);			
			objReinsurer.expiryDate = obj == null ? "" : (obj.expiryDate==null?"":obj.expiryDate);			
			objReinsurer.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);			
			objReinsurer.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);			
			objReinsurer.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);			
			objReinsurer.cpNo = obj == null ? "" : (obj.cpNo==null?"":obj.cpNo);			
			objReinsurer.sunNo = obj == null ? "" : (obj.sunNo==null?"":obj.sunNo);			
			objReinsurer.smartNo = obj == null ? "" : (obj.smartNo==null?"":obj.smartNo);			
			objReinsurer.globeNo = obj == null ? "" : (obj.globeNo==null?"":obj.globeNo);			
			objReinsurer.inputVatRate = obj == null ? "" : (obj.inputVatRate==null?"":formatToNthDecimal(obj.inputVatRate,2));			
			objReinsurer.riTin = obj == null ? "" : (obj.riTin==null?"":obj.riTin);			
			objReinsurer.facilities = obj == null ? "" : (obj.facilities==null?"":obj.facilities);			
			objReinsurer.riStatusDesc = obj == null ? "" : (obj.riStatusDesc==null?"":obj.riStatusDesc);			
			objReinsurer.riTypeDesc = obj == null ? "" : (obj.riTypeDesc==null?"":obj.riTypeDesc);		
			objReinsurer.newRecord = obj == null ? "" : (obj.newRecord==null?"":obj.newRecord);	
		} catch (e) {
			showErrorMessage("setObjReinsurer", e);
		}
	}
	
	function addRec(){
		try {
			if($F("txtBillAddress1")==""){
				$("txtBillAddress1").value = $("txtMailAddress1").value;
				$("txtBillAddress2").value = $("txtMailAddress2").value;
				$("txtBillAddress3").value = $("txtMailAddress3").value;			
			}
			changeTagFunc = saveGiiss030;
			var rec = setRec(objCurrReinsurer);
			var newObj = setRec(null);
			if($F("btnAdd") == "Add"){
				addMaxRiCd = getRiCd();
				if(addMaxRiCd >= 10000){					
					showMessageBox("You have used up all available industry codes in the sequence!!!","I");								
				}else{		
					addMaxRiCd++;
					tbgReinsurer.addBottomRow(rec);
					newObj.recordStatus = 0;
					allRecObj.push(newObj);
				}
				
			} else {
				tbgReinsurer.updateVisibleRowOnly(rec, rowIndex, false);
				for(var i = 0; i<allRecObj.length; i++){
					if ((allRecObj[i].riCd == newObj.riCd)&&(allRecObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRecObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReinsurer.keys.removeFocus(tbgReinsurer.keys._nCurrentFocus, true);
			tbgReinsurer.keys.releaseKeys();				
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("reinsurerFormDiv")) {
				for(var i=0; i<allRecObj.length; i++){
					if(allRecObj[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(unescapeHTML2(allRecObj[i].riName.toUpperCase()) == $F("txtRiName").toUpperCase()){
								showMessageBox("Record already exists with the same ri_name.", "E");
								return;
							}
						} else{
							if($F("hidRiName") != $F("txtRiName") && unescapeHTML2(allRecObj[i].riName.toUpperCase()) == $F("txtRiName")){
								showMessageBox("Record already exists with the same ri_name.", "E");
								return;
							}
						}
					} 
				}
				addRec();	
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}	

	function deleteInReinsurerTableGrid() {
		var newObj = setRec(null);
		objCurrReinsurer.recordStatus = -1;
		tbgReinsurer.deleteRow(rowIndex);
		tbgReinsurer.geniisysRows[rowIndex].riCd = escapeHTML2($F("txtRiCode"));
		for(var i = 0; i<allRecObj.length; i++){
			if ((allRecObj[i].riCd == newObj.riCd)&&(allRecObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRecObj.splice(i, 1, newObj);
			}
		}
		setFieldValues(null);
	}	
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss030() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS030.exitPage = exitPage;
						saveGiiss030();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}		
	
	function setObjVDefault(obj){
		if(obj!=null){			
			if (obj.cpNo != null&&obj.sunNo != null&&obj.cpNo == obj.sunNo){		
				objReinsurer.vDefault = 1;
			}else if(obj.cpNo != null&&obj.globeNo != null&&obj.cpNo == obj.globeNo){
				objReinsurer.vDefault = 2;
			}else if(obj.cpNo != null&&obj.smartNo&&obj.cpNo == obj.smartNo){
				objReinsurer.vDefault = 3;
			}else{
				objReinsurer.vDefault = 0;
			}	
		}else{
			objReinsurer.vDefault = 0;
		}		
		objReinsurer.vDefaultNo = getDefaultNo();
	}
	
	function getDefaultNo(){
		var cellNo;
	  	if(objReinsurer.vDefault ==1){
			cellNo = $("txtSunMobileNo").value;
	  	}else if(objReinsurer.vDefault ==2){
		  	cellNo = $("txtGlobeMobileNo").value;
	  	}else if(objReinsurer.vDefault ==3){
		  	cellNo = $("txtSmartMobileNo").value;
		}else{
			cellNo=null;
		}
	  	return cellNo;
  	}
  	
	function validateGIISS030MobileNo(param,field,ctype){
		try{	
		 	new Ajax.Request(contextPath + "/GIISReinsurerController", {
				method : "POST",
				parameters : {
					action : "validateGIISS030MobileNo",
					param : param,
					field : field,
					ctype : ctype				
				},
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));							
					if (res.result.message != null){	
						objReinsurer.vDefCheck = "";
						showWaitingMessageBox(res.result.message, "E", function() {
							if(res.ctype=="Sun"){
								$("txtSunMobileNo").value = nvl(objReinsurer.sunNo,"");
								$("txtSunMobileNo").focus();
							}else if(res.ctype=="Globe"){
								$("txtGlobeMobileNo").value = nvl(objReinsurer.globeNo,"");
								$("txtGlobeMobileNo").focus();
							}else if(res.ctype=="Smart"){
								$("txtSmartMobileNo").value = nvl(objReinsurer.smartNo,"");
								$("txtSmartMobileNo").focus();
							}else if(res.ctype=="all"){
								$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
								$("txtDefaultMobileNo").focus();
							}
						});						
					}else{
						objReinsurer.vDefCheck = res.result.defCheck;
						if(res.ctype=="Sun"){
							objReinsurer.sunNo = $("txtSunMobileNo").value;
						}else if(res.ctype=="Globe"){
							objReinsurer.globeNo = $("txtGlobeMobileNo").value;
						}else if(res.ctype=="Smart"){
							objReinsurer.smartNo = $("txtSmartMobileNo").value;
						}else if(res.ctype=="all"){
							$("txtDefaultMobileNo").setAttribute("lastValidValue",$("txtDefaultMobileNo").value);
						}
					}
					
				}
			}); 
		}catch(e){
			showErrorMessage("validateMobileNo", e);
		}
	}				
	
	function getGIISS030MaxRiCd(){
		try{	
			var maxRiCd;
		 	new Ajax.Request(contextPath + "/GIISReinsurerController", {
				method : "POST",
				parameters : {
					action : "getGIISS030MaxRiCd"				
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					maxRiCd = res.result;
				}
			}); 
		 	return maxRiCd;
		}catch(e){
		}
	}		
	
	function getRiCd(){
		objReinsurer.maxRiCd = getGIISS030MaxRiCd();	
		var maxRiCd = formatNumberDigits((parseInt(objReinsurer.maxRiCd)+1),5);	
		if(changeTag==0){
			return maxRiCd;
		}else{
			return formatNumberDigits(addMaxRiCd,5);
		}
	}	
			
	$("imgSearchStatus").observe("click", function() {
		getRiStatusLOV();
	});
	
	$("imgSearchRiType").observe("click", function() {	
		getRiTypeLOV();
	});
	
	$("imgEditRemarks").observe("click", function() {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
		
	$("txtStatus").observe("change", function() {
		if($F("txtStatus").trim()!=""&& $("txtStatus").value != $("txtStatus").readAttribute("lastValidValue")){
			getRiStatusLOV();
		}else if($F("txtStatus").trim() == "") {
			$("txtStatus").value="";
			$("txtStatus").setAttribute("lastValidValue", "");
			$("txtStatusDesc").setAttribute("lastValidValue", "");
			$("txtStatusDesc").value="";			
		}
	});	
	
	$("txtRiType").observe("change", function() {
		if($F("txtRiType").trim()!=""&& $("txtRiType").value != $("txtRiType").readAttribute("lastValidValue")){
			getRiTypeLOV();
		}else if($F("txtRiType").trim() == "") {
			$("txtRiType").value = "";
			$("txtRiType").setAttribute("lastValidValue", "");						
		}
	});	
	
	$("txtShortName").observe("keyup", function(){
		$("txtShortName").value = $F("txtShortName").toUpperCase();
	});
	
	$("txtShortName").observe("change", function(){
		$("txtShortName").value = $F("txtShortName").toUpperCase();
	});
	
	$("txtRiName").observe("keyup", function(){
		$("txtRiName").value = $F("txtRiName").toUpperCase();	
	});
	
	$("txtRiName").observe("change", function(){
		$("txtRiName").value = $F("txtRiName").toUpperCase();	
	});
	
	$("txtContact").observe("keyup", function(){
		$("txtContact").value = $F("txtContact").toUpperCase();
	});
	
	$("txtLicense").observe("keyup", function(){
		$("txtLicense").value = $F("txtLicense").toUpperCase();
	});
	
	$("txtLicense").observe("change", function(){
		$("txtLicense").value = $F("txtLicense").toUpperCase();
	});
	
	$("txtRemarks").observe("keyup", function(){
		$("txtRemarks").value = $F("txtRemarks").toUpperCase();
	});
	
	$("txtRemarks").observe("change", function(){
		$("txtRemarks").value = $F("txtRemarks").toUpperCase();
	});
	
	$("txtTaxRate").observe("change", function(){
		if (parseFloat($F("txtTaxRate").replace(/,/g, "")) > 999.9999|| parseFloat($F("txtTaxRate").replace(/,/g, "")) < 0) {
			showWaitingMessageBox("Invalid Tax Rate. Valid value should be from 0.0000 to 999.9999.", imgMessage.ERROR,
					function() {
						$("txtTaxRate").clear();
						$("txtTaxRate").focus();
					});
		}else{
			$("txtTaxRate").value = formatToNthDecimal($F("txtTaxRate").trim(),4);
		}			
	});
	
	$("txtInputVat").observe("change", function(){	
		if (parseFloat($F("txtInputVat").replace(/,/g, "")) > 100.00|| parseFloat($F("txtInputVat").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Input VAT. Valid value should be from 0.00 to 100.00.", imgMessage.ERROR,
					function() {
						$("txtInputVat").clear();
						$("txtInputVat").focus();
					});
		}else{
			$("txtInputVat").value = formatToNthDecimal($F("txtInputVat").trim(),2);
		}			
	});
	
	$("txtNetRet").observe("change", function(){	
		if (parseFloat($F("txtNetRet").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtNetRet").replace(/,/g, "")) < 0) {
			showWaitingMessageBox("Invalid Net Ret. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR,
					function() {
						$("txtNetRet").clear();
						$("txtNetRet").focus();
					});
		}else{
			$("txtNetRet").value = formatCurrency($F("txtNetRet"));
		}	
	});
	
	$("txtAsset").observe("change", function(){	
		if (parseFloat($F("txtAsset").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtAsset").replace(/,/g, "")) < 0) {
			showWaitingMessageBox("Invalid Asset. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR,
					function() {
						$("txtAsset").clear();
						$("txtAsset").focus();
					});
		}else{
			$("txtAsset").value = formatCurrency($F("txtAsset"));
		}		
	});
	
	$("txtLiability").observe("change", function(){	
		if (parseFloat($F("txtLiability").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtLiability").replace(/,/g, "")) < 0) {
			showWaitingMessageBox("Invalid Liability. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR,
					function() {
						$("txtLiability").clear();
						$("txtLiability").focus();
					});
		}else{
			$("txtLiability").value = formatCurrency($F("txtLiability"));
		}	
	});
	
	$("txtNetWorth").observe("change", function(){	
		if (parseFloat($F("txtNetWorth").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtNetWorth").replace(/,/g, "")) < 0) {
			showWaitingMessageBox("Invalid Net Worth. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR,
					function() {
						$("txtNetWorth").clear();
						$("txtNetWorth").focus();
					});
		}else{
			$("txtNetWorth").value = formatCurrency($F("txtNetWorth"));
		}			
	});
	
	$("txtFilipinoPart").observe("change", function(){	
		if (parseFloat($F("txtFilipinoPart").replace(/,/g, "")) > 999.9999 || parseFloat($F("txtFilipinoPart").replace(/,/g, "")) < -999.9999) {
			showWaitingMessageBox("Invalid Filipino Part. Valid value should be from 0.0000 to 999.9999.", imgMessage.ERROR,
					function() {
						$("txtFilipinoPart").clear();
						$("txtFilipinoPart").focus();
					});
		}else{
			$("txtFilipinoPart").value = formatToNthDecimal($F("txtFilipinoPart").trim(),4);
		}				
	});
	
	$("txtDefaultMobileNo").observe("change", function(){
		if ($F("txtDefaultMobileNo")=="" && objReinsurer.vDefaultNo!=null){
			showWaitingMessageBox("You cannot delete the default mobile number.", "E", function() {
				$("txtDefaultMobileNo").focus();
				$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
			});
		}else if($F("txtDefaultMobileNo")!=""){
			validateGIISS030MobileNo('SUN_NUMBER', $F("txtDefaultMobileNo"), 'all');
			if(objReinsurer.vDefCheck==0){
				validateGIISS030MobileNo('GLOBE_NUMBER', $F("txtDefaultMobileNo"), 'all');
				if(objReinsurer.vDefCheck==0){
					validateGIISS030MobileNo('SMART_NUMBER', $F("txtDefaultMobileNo"), 'all');
					if(objReinsurer.vDefCheck==0){
						showWaitingMessageBox('Not a valid smart, sun, or globe cell number.','E',function() {
							$("txtDefaultMobileNo").focus();
							$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
						});
					}else if(objReinsurer.vDefCheck==1){
						if($F("txtSmartMobileNo")==""){
							$("txtSmartMobileNo").value = $("txtDefaultMobileNo").value; 		
							objReinsurer.smartNo = ("txtDefaultMobileNo").value;
							objReinsurer.vDefault = 3; 				
							objReinsurer.vDefaultNo = $("txtSmartMobileNo").value; 
						}else if(!($F("txtDefaultMobileNo")==$F("txtSmartMobileNo"))){
							showConfirmBox("Confirmation","Do you want to change your smart mobile no?","Yes","No",
									function(){
								$("txtSmartMobileNo").value = $("txtDefaultMobileNo").value; 	
								objReinsurer.smartNo = ("txtDefaultMobileNo").value;
								objReinsurer.vDefault = 3; 										
								objReinsurer.vDefaultNo = $("txtSmartMobileNo").value;
							},function(){
								showMessageBox("You cannot set a default number that is not found on your available mobile nos.","E");								  
								$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
							},1);
						}else if(($F("txtDefaultMobileNo")==$F("txtSmartMobileNo"))){
							objReinsurer.vDefaultNo = $("txtSmartMobileNo").value;				
							objReinsurer.vDefault = 3;
						}
					}
				}else if(objReinsurer.vDefCheck==1){
					if($F("txtGlobeMobileNo")==""){
						$("txtGlobeMobileNo").value = $("txtDefaultMobileNo").value; 	
						objReinsurer.globeNo = ("txtDefaultMobileNo").value;
						objReinsurer.vDefault = 2; 				
						objReinsurer.vDefaultNo = $("txtGlobeMobileNo").value; 
					}else if(!($F("txtDefaultMobileNo")==$F("txtGlobeMobileNo"))){
						showConfirmBox("Confirmation","Do you want to change your globe mobile no?","Yes","No",
								function(){
							$("txtGlobeMobileNo").value = $("txtDefaultMobileNo").value; 	
							objReinsurer.globeNo = ("txtDefaultMobileNo").value;
							objReinsurer.vDefault = 2; 										
							objReinsurer.vDefaultNo = $("txtGlobeMobileNo").value;
						},function(){
							showMessageBox("You cannot set a default number that is not found on your available mobile nos.","E");								  
							$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
						},1);
					}else if(($F("txtDefaultMobileNo")==$F("txtGlobeMobileNo"))){
						objReinsurer.vDefaultNo = $("txtGlobeMobileNo").value;				
						objReinsurer.vDefault = 2;
					}
				}
			}else if(objReinsurer.vDefCheck==1){
				if($F("txtSunMobileNo")==""){
					$("txtSunMobileNo").value = $("txtDefaultMobileNo").value; 	
					objReinsurer.sunNo = ("txtDefaultMobileNo").value;
					objReinsurer.vDefault = 1; 				
					objReinsurer.vDefaultNo = $("txtSunMobileNo").value; 
				}else if(!($F("txtDefaultMobileNo")==$F("txtSunMobileNo"))){
					showConfirmBox("Confirmation","Do you want to change your sun mobile no?","Yes","No",
							function(){
						$("txtSunMobileNo").value = $("txtDefaultMobileNo").value; 	
						objReinsurer.sunNo = ("txtDefaultMobileNo").value;
						objReinsurer.vDefault = 1; 										
						objReinsurer.vDefaultNo = $("txtSunMobileNo").value;
					},function(){
						showMessageBox("You cannot set a default number that is not found on your available mobile nos.","E");								  
						$("txtDefaultMobileNo").value = objReinsurer.vDefaultNo;
					},1);
				}else if(($F("txtDefaultMobileNo")==$F("txtSunMobileNo"))){
					objReinsurer.vDefaultNo = $("txtSunMobileNo").value;				
					objReinsurer.vDefault = 1;
				}
			}			
		}		
	});
	
	$("txtSunMobileNo").observe("change", function(){
		if ($F("txtSunMobileNo")!=""){
			validateGIISS030MobileNo('SUN_NUMBER', $F("txtSunMobileNo"), 'Sun');
		}
		if(objReinsurer.vDefCheck==1){
			if ($F("txtDefaultMobileNo")==""||(objReinsurer.vDefault==1&&$F("txtSunMobileNo")!="")){
				$("txtDefaultMobileNo").value = $("txtSunMobileNo").value;
				objReinsurer.sunNo = $("txtSunMobileNo").value;
				objReinsurer.vDefault=1;
				objReinsurer.vDefaultNo =$("txtSunMobileNo").value;
			}else if($F("txtSunMobileNo")==""&&objReinsurer.vDefault==1){
				showWaitingMessageBox('You cant delete the default cellphone number.','E',function() {
					$("txtSunMobileNo").value = $("txtDefaultMobileNo").value;
					$("txtSunMobileNo").focus();
				});
			}else if($F("txtDefaultMobileNo")!=""&&$F("txtSunMobileNo")!=""){
				showConfirmBox("Confirmation","Do you want to change your default cellphone number?","Yes","No",
						function(){
					$("txtDefaultMobileNo").value = $("txtSunMobileNo").value; 												
					objReinsurer.vDefault = 1; 							
					objReinsurer.vDefaultNo =$("txtSunMobileNo").value;
				},"",1);
			}
		}
	});
	
	$("txtSmartMobileNo").observe("change", function(){
		if ($F("txtSmartMobileNo")!=""){
			validateGIISS030MobileNo('SMART_NUMBER', $F("txtSmartMobileNo"), 'Smart');
		}
		if(objReinsurer.vDefCheck==1){
			if ($F("txtDefaultMobileNo")==""||(objReinsurer.vDefault==3&&$F("txtSmartMobileNo")!="")){
				$("txtDefaultMobileNo").value = $("txtSmartMobileNo").value;
				objReinsurer.vDefault=3;
				objReinsurer.vDefaultNo =$("txtSmartMobileNo").value;
			}else if($F("txtSmartMobileNo")==""&&objReinsurer.vDefault==3){
				showWaitingMessageBox('You cant delete the default cellphone number.','I',function() {
					$("txtSmartMobileNo").value = $("txtDefaultMobileNo").value;
					$("txtSmartMobileNo").focus();
				});
			}else if($F("txtDefaultMobileNo")!=""&&$F("txtSmartMobileNo")!=""){
				showConfirmBox("Confirmation","Do you want to change your default cellphone number?","Yes","No",
						function(){
							$("txtDefaultMobileNo").value = $("txtSmartMobileNo").value; 												
							objReinsurer.vDefault = 3; 	
							objReinsurer.vDefaultNo =$("txtSmartMobileNo").value;
				},"",1);
			}
		}
	});
	
	$("txtGlobeMobileNo").observe("change", function(){
		if ($F("txtGlobeMobileNo")!=""){
			validateGIISS030MobileNo('GLOBE_NUMBER', $F("txtGlobeMobileNo"), 'Globe');
		}
		if(objReinsurer.vDefCheck==1){
			if ($F("txtDefaultMobileNo")==""||(objReinsurer.vDefault==2&&$F("txtGlobeMobileNo")!="")){
				$("txtDefaultMobileNo").value = $("txtGlobeMobileNo").value;
				objReinsurer.vDefault=2;
				objReinsurer.vDefaultNo =$("txtGlobeMobileNo").value;
			}else if($F("txtGlobeMobileNo")==""&&objReinsurer.vDefault==2){
				showWaitingMessageBox('You cant delete the default cellphone number.','I',function() {
					$("txtGlobeMobileNo").value = $("txtDefaultMobileNo").value;
					$("txtGlobeMobileNo").focus();
				});
			}else if($F("txtDefaultMobileNo")!=""&&$F("txtGlobeMobileNo")!=""){
				showConfirmBox("Confirmation","Do you want to change your default cellphone number?","Yes","No",
						function(){
							$("txtDefaultMobileNo").value = $("txtGlobeMobileNo").value; 												
							objReinsurer.vDefault = 2; 		
							objReinsurer.vDefaultNo =$("txtGlobeMobileNo").value;
				},"",1);
			}
		}
	});	

	$("btnAdd").observe("click", function() {		
		valAddRec();			
	});	
	
	$("btnDelete").observe("click", function(){		
		if(objCurrReinsurer.newRecord=="Yes"){
			deleteInReinsurerTableGrid();				
		}else{
			showMessageBox("Deletion of record is not allowed.", imgMessage.INFO);	
		}
	});	
		

	observeReloadForm("reloadForm", showReinsurer);	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss030);
	$("btnCancel").observe("click", cancelGiiss030);
	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtShortName").focus();	
	setObjVDefault(null);
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>