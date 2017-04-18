<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="perilMaintenance" name="perilMaintenance" style="float: left; width: 100%;">
	<div id="perilMaintenanceExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="perilMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Peril Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv" id="showLineDiv" style="height: 243px;">
			<div>
				<div id="lineMaintenanceTable" style="height: 245px;position:relative;left:240px;top:10px;border-bottom: 0px; width: 460px;"></div>
			</div>
		</div>			
		<div class="sectionDiv" id="showPerilDiv" style="height: auto;">
			<div id="perilMaintenanceTableDiv" style="padding: 10px;">
				<div id="perilMaintenanceTable" style="height: 306px"></div>
				<div id="perilMaintenanceInfoSectionDiv" style="width: 100%;">
					<jsp:include page="/pages/underwriting/fileMaintenance/general/peril/perilMaintenance/subpages/perilMaintenanceInfo.jsp"></jsp:include>
					<div align="center" style="margin-top: 8px">
						<input type="button" class="button" id="btnAddPeril" name="btnAddPeril" value="Add" /> 
						<input type="button" class="button" id="btnDeletePeril" name="btnDeletePeril" value="Delete" />
					</div>
				</div>
			</div>
		</div>
		<div>
			<div class="sectionDiv" id="showLineDiv" style="height: 45px" align="center">
				<div class="buttonsDiv" style="float:left; width: 100%; margin-top: 10px;">
					<input type="button" style="width: 150px;" class="button" id="btnTariffCd" name="btnTariffCd" value="Tariff Codes"/>
					<input type="button" style="width: 150px;" class="button" id="btnWandC" name="btnWandC" value="Warranty & Clause"/>
				</div>
			</div>
			<div class="buttonsDiv" style="float:left; width: 100%; margin-top: 10px;">
				<input type="button" class="button" id="btnCancelLine" name="btnCancelLine" value="Cancel"/>
				<input type="button" class="button" id="btnSaveLine" name="btnSaveLine" value="Save"/>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
	setModuleId("GIISS003");
	setDocumentTitle("Peril Maintenance");
	selectedIndex = -1;
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	initializeAll();
	changeTag = 0;
	var delObj;
	var rowObj;
	var deleteStatus = false;
	var addStatus = false;
	var addSnameStatus = false;
	var addDefaultTsiStatus = false;
	var changeCounter = 0;
	var objPeril = new Object();
	var func = new Object;
	originalSname = null;  //added Kenneth L. 05.24.2013 for Short name validation
	changed = false;
	valPerilSname = null;
	var allPerils = []; //pol cruz 01.14.2015
	
	try{	
		var row = 0;
		var objPerilDepreciationMain = [];
		objPeril.objPerilListing = [];
		objPeril.objPerilMaintenance = objPeril.objPerilListing.rows || [];	
		
		var perilMaintenanceTG = {
				url: contextPath+"/GIISSPerilMaintenanceController?action=getGIISPerilGIISS003",
			options: {
				width: '900px',
				height: '330px',
				onCellFocus: function(element, value, x, y, id){
					row = y; 
					objPerilMaintain = perilMaintenanceTableGrid.geniisysRows[y];
					perilMaintenanceTableGrid.keys.releaseKeys();
					populatePerilMaintenanceInfo(objPerilMaintain);
					valPerilSname = $F("txtPerilShortName");
					onFocus();
					toggleEqZoneType(); //edgar 03/10/2015
				},
				onRemoveRowFocus: function(){
					onRemove();
	            },
	            beforeSort: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
                },
                onSort: function(){
                	onRemove();
                },
                prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	            		
                		onRemove();
                	}
                },
                onRefresh: function(){
                	onRemove();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		onRemove();
	                	}
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
				{	id: 'profCommTag', 
					title: 'C',
					altTitle: 'Prof Comm Tag',
					width: '30px',
					titleAlign: 'center',
					visible: true,
					editor: 'checkbox' ,
					align :"center",
                    defaultValue: false,
                    otherValue: false,
                    editor: new MyTableGrid.CellCheckbox({
                        getValueOf: function(value){
                                if (value){
                                    return "Y";
	                            }else{
	                            	return "N";        
	                            }
                        }
                    }) 
					
				},
				{
					id : 'defaultTag',
					title : 'D',
					altTitle : 'Default Tag',
					width : '30px',
					align : 'center',
					titleAlign : 'center',
					defaultValue : false,
					otherValue : false,
					visible: true,
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id : 'evalSw',
					title : 'E',
					altTitle : 'MC Evaluation Tag',
					width : '30px',
					align : 'center',
					titleAlign : 'center',
					defaultValue : false,
					otherValue : false,
					visible: true,
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{   id: 'sequence',
				    title: 'S',
				    altTitle: 'Sequence',
				    width: '30px',
				    visible: true,
				    titleAlign: 'right',
				    align: 'right',
				    renderer: function(value){
	            		   return value == "" ? "" : lpad(value, 2, 0);
	            	   }
				},
				{	id: 'perilCd',
					title: 'Cd',
					altTitle: 'Peril Code',
					width: '40px',
					visible: true,
					filterOption: true,
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
				    align: 'right',
			    	renderer: function(value){
	            		   return lpad(value, 5, 0);
	            	   }
				},
				{	id: 'perilSname',
					title: 'Short Nm',
					altTitle: 'Short Name',
					width: '70px',
					visible: true,
					filterOption: true
				},
				{	id: 'perilName',
					title: 'Peril Name',
					width: '160px',
					visible: true,
					filterOption: true
				},
				{	id: 'perilType',
					title: 'Type',
					width: '45px',
					visible: true,
					filterOption: true
				},
				{	id: 'sublineCd',
					title: 'Subline',
					width: '55px',
					visible: true,
					filterOption: true
				},
				{	id: 'riCommRt',
					title: 'RI Comm Rt',
				    align: 'right',
					width: '85px',
					visible: true,
					filterOption: true,
					filterOptionType: 'numberNoNegative',
					titleAlign: 'right',
				    align: 'right',
					renderer : function(value){
						return formatToNineDecimal(value);}
				},
				{	id: 'prtFlag',
					title: 'Prt Tag',
					width: '50px',
					visible: true,
					filterOption: true,
					titleAlign: 'right',
				    align: 'right'
				},
				{	id: 'bascPerlCd',
					title: 'Basic Peril Cd',
					width: '90px',
					visible: true,
					filterOption: true,
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
				    align: 'right',
			    	renderer: function(value){
			    		return value == "" ? "" : lpad(value, 5, 0);
	            	   }
				},
				{   id: 'zoneType',
					title: 'Z',
					altTitle : 'Zone Type',
					visible: true,
					width: '30px'
				},
				{   id: 'zoneType',
					title: 'Z',
					altTitle : 'Zone Type',
					visible: true,
					width: '30px',
					titleAlign: 'right',
				    align: 'right'
				},
				{   id: 'eqZoneType', /*added eqZoneTye : edgar 03/10/2015*/
					title: 'E',
					altTitle : 'Earthquake Zone Type',
					visible: true,
					width: '30px',
					titleAlign: 'right',
				    align: 'right'
				},
				{	id: 'defaultRate',
					title: 'Default Rate',
					width: '90px',
					visible: true,
					filterOption: true,
					filterOptionType: 'numberNoNegative',
					titleAlign: 'right',
				    align: 'right',
					renderer : function(value){
						return formatToNineDecimal(value);}
				},
				{	id: 'defaultTsi',
					title: 'Default Tsi',
					width: '90px',
					visible: true,
					filterOption: true,
					filterOptionType: 'numberNoNegative',
					titleAlign: 'right',
				    align: 'right',
				    renderer : function(value){
						return formatCurrency(value);}
				}
				],
			rows: objPeril.objPerilMaintenance
		};
		perilMaintenanceTableGrid = new MyTableGrid(perilMaintenanceTG);
		perilMaintenanceTableGrid.pager = objPeril.objPerilListing;
		perilMaintenanceTableGrid.render('perilMaintenanceTable');
		perilMaintenanceTableGrid.afterRender = function(){
			objPerilDepreciationMain = perilMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
			allPerils = (typeof perilMaintenanceTableGrid.pager.allPerils == "undefined") ? null : perilMaintenanceTableGrid.pager.allPerils; //pol cruz 01.14.2015
		};
	}catch (e) {
		showErrorMessage("Peril Maintenance Table Grid", e);
	}
		
	function populatePerilMaintenanceInfo(obj){
		try{
			clearFields(); 
			$("hidLineCd").value 				= obj			== null ? "" : obj.lineCd; 
			$("txtPerilCode").value 			= obj			== null ? "" : formatNumberDigits(obj.perilCd,5); 
			$("txtSequence").value 				= obj			== null ? "" : obj.sequence == null ? "" : obj.sequence == "" ? "" : formatNumberDigits(obj.sequence,2); 
			$("txtPerilShortName").value 		= obj			== null ? "" : unescapeHTML2(obj.perilSname);
			$("txtPerilName").value 			= obj			== null ? "" : unescapeHTML2(obj.perilName); 
			$("dDnPerilType").value 			= obj			== null ? "" : unescapeHTML2(obj.perilType);
			$("txtSubline").value 				= obj			== null ? "" : unescapeHTML2(obj.sublineCd);
			$("txtRiCommRate").value 			= obj			== null ? "" : formatToNineDecimal(obj.riCommRt);
			$("dDnPrintTag").value 				= obj			== null ? "" : obj.prtFlag;
			$("txtBasicPerilCd").value 			= obj			== null ? "" : obj.bascPerlCd == null ||obj.bascPerlCd ==""? "" : formatNumberDigits(obj.bascPerlCd,5);//edgar 03/12/2015 
			$("txtPerilLongName").value 		= obj			== null ? "" : unescapeHTML2(obj.perilLname);
			$("txtRemarks").value 				= obj			== null ? "" : unescapeHTML2(obj.remarks);
			$("txtUserId").value 				= obj			== null ? "" : unescapeHTML2(obj.userId);
			$("txtLastUpdate").value 			= obj			== null ? "" : unescapeHTML2(obj.lastUpdate);
			$("chkProfitCommTag").checked 		= obj			== null ? "" : obj.profCommTag == 'Y' ? true : false;
			$("txtZoneTypeFi").value 			= obj			== null ? "" : obj.zoneType;
			$("txtEqZoneTypeFi").value 			= obj			== null ? "" : obj.eqZoneType; //edgar 03/10/2015
			$("txtZoneTypeMc").value 			= obj			== null ? "" : obj.zoneType;
			$("chkEvalSw").checked 				= obj			== null ? "" : obj.evalSw == 'Y' ? true : false;
			$("chkDefaultTag").checked 			= obj			== null ? "" : obj.defaultTag == 'Y' ? true : false;
			$("txtDefaultRate").value 			= obj			== null ? "" : formatToNineDecimal(obj.defaultRate);
			$("txtDefaultTsi").value 			= obj			== null ? "" : formatCurrency(obj.defaultTsi);
			$("hidBasicPerilCd").value 			= obj			== null ? "" : obj.bascPerlCd;
		}catch(e){
			showErrorMessage("populatePerilMaintenanceInfo", e);
		}
	}
	
	function setPerilMaintenanceTableValues(func){
		var rowObjectPeril = new Object(); 
		rowObjectPeril.lineCd	 		= $("hidLineCd").value;
		rowObjectPeril.perilCd	 		= $("txtPerilCode").value;
		rowObjectPeril.sequence 		= $("txtSequence").value;
		rowObjectPeril.perilSname	 	= escapeHTML2($("txtPerilShortName").value);
		rowObjectPeril.perilName 		= escapeHTML2($("txtPerilName").value);
		rowObjectPeril.perilType	 	= escapeHTML2($("dDnPerilType").value);
		rowObjectPeril.sublineCd 		= escapeHTML2($("txtSubline").value);
		rowObjectPeril.riCommRt 		= formatToNineDecimal($("txtRiCommRate").value); 
		rowObjectPeril.prtFlag			= $("dDnPrintTag").value;
		rowObjectPeril.bascPerlCd 		= $("txtBasicPerilCd").value;
		rowObjectPeril.perilLname 		= escapeHTML2($("txtPerilLongName").value);
		rowObjectPeril.remarks 			= escapeHTML2($("txtRemarks").value);
		rowObjectPeril.profCommTag 		= ($("chkProfitCommTag").checked ? "Y" : "N");
		rowObjectPeril.zoneType			= escapeHTML2($("hidLineCd").value == "FI" || $("hidMenuLineCd").value == 'FI'? $("txtZoneTypeFi").value : $("txtZoneTypeMc").value); //edgar 03/10/2015
		rowObjectPeril.eqZoneType		= escapeHTML2($("hidLineCd").value == "FI" || $("hidMenuLineCd").value == 'FI'? $("txtEqZoneTypeFi").value : ""); //edgar 03/10/2015
		rowObjectPeril.evalSw 			= ($("chkEvalSw").checked ? "Y" : "N");
		rowObjectPeril.defaultTag		= ($("chkDefaultTag").checked ? "Y" : "N");
		rowObjectPeril.defaultRate 		= $("txtDefaultRate").value == "" ? "" : formatToNineDecimal($("txtDefaultRate").value);
		rowObjectPeril.defaultTsi 		= $("txtDefaultTsi").value == "" ? "" : formatCurrency($F("txtDefaultTsi").replace(/,/g, ""));
		rowObjectPeril.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		rowObjectPeril.userId 			= userId;
		var lastUpdate = new Date();
		rowObjectPeril.lastUpdate 		= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
		return rowObjectPeril;                         
	}
	
	/*Validates if peril code is already exists*/
	function validateAddPeril(){
		addStatus = false;
		rowObj  = setPerilMaintenanceTableValues($("btnAddPeril").value);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validateAddPeril",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2(rowObj.lineCd),
				perilCd : rowObj.perilCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice();
				if(response.responseText == '1'){
					$("hidLastValidPerilCode").value = $("txtPerilCode").value;
					$("txtPerilCode").value = formatNumberDigits($F("txtPerilCode"), 5);
					addStatus = true; 
				}else{
					customShowMessageBox("Peril must be unique.", imgMessage.ERROR, "txtPerilCode");
					$("txtPerilCode").value = $F("hidLastValidPerilCode");
					addStatus = true; 
				}
			}
		});	
	}
	
	/*Validates if record exists with the same peril short name*/
	function validatePerilSname(){
		addSnameStatus = false;
		rowObj  = setPerilMaintenanceTableValues($("btnAddPeril").value);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validatePerilSname",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2(rowObj.lineCd),
				perilSname : unescapeHTML2(rowObj.perilSname)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice();
				if(response.responseText == '1' || $("txtPerilShortName").value == originalSname){ //added additional condition for validation Kenneth L. 05.24.2013
					$("hidLastValidPerilShortName").value = $F("txtPerilShortName");
					addSnameStatus = false;
				}else if(response.responseText != '1'){
					customShowMessageBox("Record exists with the same peril short name.", imgMessage.ERROR, "txtPerilShortName");
					$("txtPerilShortName").value = $F("hidLastValidPerilShortName");
					addSnameStatus = true;
				}
			}
		});	
		return addSnameStatus;
	}
	
	/*Validates if record exists with the same peril name*/
	function validatePerilName(){
		addNameStatus = false;
		rowObj  = setPerilMaintenanceTableValues($("btnAddPeril").value);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validatePerilName",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2(rowObj.lineCd),
				perilName : unescapeHTML2(rowObj.perilName)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice();
				if(response.responseText == '0'){
					addNameStatus = true;
					$("hidLastValidPerilName").value = $F("txtPerilName");
				}else{
					var type;
					if (response.responseText == 'A'){
						type = "Allied";
						$("txtPerilName").value = $F("hidLastValidPerilName");
						customShowMessageBox("An " + type + " peril already exists with this name. Operation requested cannot be performed.", imgMessage.INFO, "txtPerilName");
						addNameStatus = true;
					}else if (response.responseText == 'B'){
						type = "Basic";
						$("txtPerilName").value = $F("hidLastValidPerilName");
						customShowMessageBox("A  " + type + " peril already exists with this name. Operation requested cannot be performed.", imgMessage.INFO, "txtPerilName");
						addNameStatus = true;
					} 
				}
			}
		});	
	}
	
	/* Validates Default Tsi input
	  --basic peril default tsi is less than its attached allied
        	RETURN '0';
      --basic peril default tsi is less than the min tsi of all allied peril
        	RETURN '1';
      --passed the validation
      		RETURN '2';
      --allied default tsi is greater than the max tsi of all basic peril
         	RETURN '3';
      --allied default tsi is greater than its basic peril
        RETURN v_peril_name;	*/
	function validateDefaultTsi(){
		addDefaultTsiStatus = false;
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validateDefaultTsi",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2($("hidLineCd").value),
				perilCd : $("txtPerilCode").value,
				defaultTsi : unformatCurrencyValue($("txtDefaultTsi").value),
				bascPerlCd : $("txtBasicPerilCd").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice();
				if(response.responseText == '0' && $F("txtDefaultTsi") != ""){
					customShowMessageBox("Peril (" +  $F("txtPerilName") + ") has attached perils. Default TSI Amount of this peril must not be lower than its attached perils. Please check attached allied peril amount.", imgMessage.INFO, "txtDefaultTsi");
					$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
					addDefaultTsiStatus = true;
				}else if(response.responseText == '1' && $F("txtDefaultTsi") != "" && $F("dDnPerilType") == 'B'){
					customShowMessageBox("Default TSI amount of Basic Peril (" +  $F("txtPerilName") + ") must not be lower than any open allied peril.", imgMessage.INFO, "txtDefaultTsi");
					$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
					addDefaultTsiStatus = true;
				}else if(response.responseText == '2' && $F("txtDefaultTsi") != ""){
					$("hidLastValidDefaultTsi").value = $F("txtDefaultTsi");
					addDefaultTsiStatus = true;
				}else if(response.responseText == '3' && $F("txtDefaultTsi") != "" && $F("dDnPerilType") == 'A'){
					customShowMessageBox("Default TSI Amount of this Allied must not exceed that of the highest among Basic Perils.", imgMessage.INFO, "txtDefaultTsi");
					$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
					addDefaultTsiStatus = true;
				}else if (response.responseText != "-#geniisys#-"){
					customShowMessageBox("Default TSI Amount of attached peril (" + $F("txtPerilName") + ") must not be higher than Basic Peril (" + response.responseText + ").", imgMessage.INFO, "txtDefaultTsi");
					$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
					addDefaultTsiStatus = true;	
				}
			}
		});	
	} 
	
    /* checks if there are available clauses for the line chosen */
	function checkAvailableWarrcla(){ 
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=checkAvailableWarrcla",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2($("hidLineCd").value)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
			},
			onComplete: function(response){
				if(response.responseText == '1'){
					showMessageBox("No availabe warranties for line " + $("hidLineName").value + " at this time.", "E");
				}else{
					showOverlay("getGIISWarrClauses", "Warranty and Clauses", "showWarrClaOverlay");
				}
			}
		});
	}
	
    /* validates if the peril is being used in par, policy or has existing records on dependent table */
	function validateDelete(){
		deleteStatus = false;
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validateDeletePeril",{
			method: "POST",
			parameters:{
				"lineCd" : unescapeHTML2(delObj.lineCd),
				"perilCd" : delObj.perilCd
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("validating Peril, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					deleteStatus = true;
				}
				/* hideNotice("");
				if(response.responseText == '1'){
					deleteStatus = true;
				}else{
					if(delObj.unsavedAddStat == 1){
						deleteStatus = true;
					}else{
						if(response.responseText == 'GIPI_WITMPERL'){
							showMessageBox("Cannot delete Peril, dependent record exists on PAR", imgMessage.ERROR);
						}else if(response.responseText == 'GIPI_ITMPERIL'){
							showMessageBox("Cannot delete peril, dependent record exist on policy.", imgMessage.ERROR);
						}else{
							showMessageBox("Existing records on dependent tables found; cannot delete record/s.", imgMessage.ERROR);
						}
					}
				} */
			}
		});
	}
	
    /* delete function */
	function deletePeril(){ 
		delObj = setPerilMaintenanceTableValues($("btnDeletePeril").value);
		validateDelete();
		if(deleteStatus){ 
			updateAllPerils(delObj, true);
			objPerilDepreciationMain.splice(row, 1, delObj);
			perilMaintenanceTableGrid.deleteVisibleRowOnly(row);
			if(changeCounter == 1 && delObj.unsavedAddStat == 1){
				changeTag = 0;
				changeCounter = 0;
			}else{
				changeCounter++;
				changeTag=1;
				perilMaintenanceTableGrid.onRemoveRowFocus();
				addUpdateDelete();
			}
		}
	}
	
    /* for add and update */
	function addUpdatePeril(){  
		rowObj  = setPerilMaintenanceTableValues($("btnAddPeril").value);
		if(checkAllRequiredFieldsInDiv("perilMaintenanceInfo")){
			/* if($("btnAddPeril").value != "Add"){
				rowObj.recordStatus = 1;
				objPerilDepreciationMain.splice(row, 1, rowObj);
				perilMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
				perilMaintenanceTableGrid.onRemoveRowFocus();
				changeTag = 1;
				changeCounter++;
				addUpdateDelete();
			}else{
				rowObj.recordStatus = 0;
				rowObj.unsavedAddStat = 1;
				objPerilDepreciationMain.push(rowObj);
				perilMaintenanceTableGrid.addBottomRow(rowObj);
				perilMaintenanceTableGrid.onRemoveRowFocus();
				changeTag = 1;
				changeCounter++;
				addUpdateDelete();
			} */
			if ($("btnAddPeril").value != "Add") {
				if (changed) {
					var addedSameExists = false;
					var deletedSameExists = false;	
					var column = null;
					for(var i=0; i<perilMaintenanceTableGrid.geniisysRows.length; i++){
						if(perilMaintenanceTableGrid.geniisysRows[i].recordStatus == 0 || perilMaintenanceTableGrid.geniisysRows[i].recordStatus == 1){	
							if(unescapeHTML2(perilMaintenanceTableGrid.geniisysRows[i].perilSname) == $F("txtPerilShortName")){
								addedSameExists = true;	
								column = "peril_sname";
							}
						} else if(perilMaintenanceTableGrid.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(perilMaintenanceTableGrid.geniisysRows[i].perilSname) == $F("txtPerilShortName")){
								deletedSameExists = true;
								column = "peril_sname";
							}	
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showWaitingMessageBox("Record already exists with the same " + column + ".", "E", function(){
							$("txtPerilShortName").value = valPerilSname;
						});
						return;
					}else{
						if (!validatePerilSname()) {
							rowObj.recordStatus = 1;
							updateAllPerils(rowObj);
							objPerilDepreciationMain.splice(row, 1, rowObj);
							perilMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
							perilMaintenanceTableGrid.onRemoveRowFocus();
							changeTag = 1;
							changeCounter++;
							addUpdateDelete();
						}
					}
				}else{
					rowObj.recordStatus = 1;
					updateAllPerils(rowObj);
					objPerilDepreciationMain.splice(row, 1, rowObj);
					perilMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
					perilMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
					addUpdateDelete();
				}
			}else{
				var addedSameExists = false;
				var deletedSameExists = false;	
				var column = null;
				for(var i=0; i<perilMaintenanceTableGrid.geniisysRows.length; i++){
					if(perilMaintenanceTableGrid.geniisysRows[i].recordStatus == 0 || perilMaintenanceTableGrid.geniisysRows[i].recordStatus == 1){	
						if(perilMaintenanceTableGrid.geniisysRows[i].perilCd == unformatNumber($F("txtPerilCode"))){
							addedSameExists = true;	
							column = "peril_cd";
						}
						if(unescapeHTML2(perilMaintenanceTableGrid.geniisysRows[i].perilSname) == $F("txtPerilShortName")){
							addedSameExists = true;	
							column = "peril_sname";
						}
					} else if(perilMaintenanceTableGrid.geniisysRows[i].recordStatus == -1){
						if(perilMaintenanceTableGrid.geniisysRows[i].perilCd == unformatNumber($F("txtPerilCode"))){
							deletedSameExists = true;
							column = "peril_cd";
						}
						if(unescapeHTML2(perilMaintenanceTableGrid.geniisysRows[i].perilSname) == $F("txtPerilShortName")){
							deletedSameExists = true;
							column = "peril_sname";
						}	
					}
				}
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showWaitingMessageBox("Record already exists with the same " + column + ".", "E", function(){
						if(column == "peril_sname"){
							$("txtPerilShortName").value = valPerilSname;
						}
					});
					return;
				}else{
					if (!validatePerilSname()) {
						rowObj.recordStatus = 0;
						rowObj.unsavedAddStat = 1;
						updateAllPerils(rowObj);
						objPerilDepreciationMain.push(rowObj);
						perilMaintenanceTableGrid.addBottomRow(rowObj);
						perilMaintenanceTableGrid.onRemoveRowFocus();
						changeTag = 1;
						changeCounter++;
						addUpdateDelete();
					}
					return;
				}
			}
		}
	}
	
    /* for saving the peril code */
	function savePerilDetail(){ 
		var objParams = new Object(); 
		objParams.setRows = getAddedAndModifiedJSONObjects(objPerilDepreciationMain); 
		objParams.delRows = getDeletedJSONObjects(objPerilDepreciationMain);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=savePeril",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Peril, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						changeTag = 0;
						showMessageBox(objCommonMessage.SUCCESS, "S");
						perilMaintenanceTableGrid.refresh();
						perilMaintenanceTableGrid.onRemoveRowFocus();
						clearLastValidValueDetails();
						toggleEqZoneType();//edgar 03/10/2015
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

    /* for pop-ups*/
	function showOverlay(action, title, error){
		try{
			overlayWarrTarf = Overlay.show(contextPath+"/GIISSPerilMaintenanceController?ajax=1"
									+"&lineCd="+encodeURIComponent(unescapeHTML2($("hidLineCd").value))+"&perilCd="+$("txtPerilCode").value, {
				urlContent: true,
				urlParameters: {action : action},
			    title: title,
			    height: 440,
			    width: 650,
			    draggable: true
			});
		}catch(e){
			showErrorMessage(error, e);
		}		
	}
	
	$("btnWandC").observe("click", function() {
		if (changeTag == 1){
    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			checkAvailableWarrcla();
		}
	});
	
	$("btnTariffCd").observe("click", function() {
		if (changeTag == 1){
    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showOverlay("getGIISTariff", "Tariff Codes", "showTariffOverlay");
		}
	});
	
	/* for getting the name of subline code to be displayed in the subline field */
	function getSublineCdName(){ 
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=getSublineCdName",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2($("hidLineCd").value),
				sublineCd : $("txtSubline").value
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
			},
			onComplete: function(response){
				$("txtSublineName").value = unescapeHTML2(response.responseText);
			}
		});
	}
	
	/* for getting the name of basic peril code to be displayed in the basic peril field */
	function getBasicPerilCdName(){
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=getBasicPerilCdName",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2($("hidLineCd").value),
				bascPerlCd : $("txtBasicPerilCd").value
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
			},
			onComplete: function(response){
				$("txtBasicPerilName").value = unescapeHTML2(response.responseText);
			}
		});
	}
	
	/* for getting the name of zone type to be displayed in the zone field */
	function getZoneName(action, zoneId, zoneName){
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController",{
			method: "POST",
			parameters:{
				action : action,
				zoneType : zoneId.value
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
			},
			onComplete: function(response){
				zoneName.value = response.responseText;
			}
		});
	}

	function toDoSequence(){
		$("hidLastValidSequence").value = $("txtSequence").value;
		$("txtSequence").value = $F("txtSequence") == "" ? "" : formatNumberDigits($F("txtSequence"), 2);
	}
	
	/*validates  input for peril code and sequence(if not a number, includes "." and out of range return to its last valid value) */
	/* function validateInput(input, lastValid, fieldLabel, min, max, toDo, focus) {
		func.toDo = toDo;
		if(input.value != "" && isNaN(input.value)) {
			input.value = lastValid.value;
		}else if(input.value != "" && input.value.include(".")){
			input.value = lastValid.value;
		}else if (input.value <= 0 && input.value != "") {
			customShowMessageBox("Invalid " + fieldLabel + ". Valid value should be from " + min + " to " + max + ".", imgMessage.INFO, focus);
			input.value = lastValid.value;
		}else{
			toDo();
		}
	} */
	
	$("txtPerilCode").observe("change",	function(e){
		/* validateInput($("txtPerilCode"), $("hidLastValidPerilCode"), "Peril Code", 1, 99999,  function() {
			validateAddPeril();}, "txtPerilCode"); */
		validateAddPeril();
	});
	
	$("txtSequence").observe("change",	function(e){
		/* validateInput($("txtSequence"), $("hidLastValidSequence"), "Sequence", 1, 99,  function() {
			toDoSequence();}, "txtSequence"); */
		toDoSequence();
	});
	
	/*validates  input for default tsi(if not a number, includes "." and out of range return to its last valid value) */
	function validateTsi(input, lastValidValue, focus){
		if (isNaN(input.value)) {
			input.value = lastValidValue.value;
		} else if ((unformatCurrencyValue(input.value) < (input.getAttribute("min"))) || (unformatCurrencyValue(input.value) > (input.getAttribute("max")))) {
			customShowMessageBox("Invalid " + input.getAttribute("customLabel") + ". Valid value should be from " + formatToNthDecimal(input.getAttribute("min"), 2) + " to " + input.getAttribute("max") + ".", imgMessage.INFO, focus);
			input.value = lastValidValue.value;
		} else if ((input.value).include("-")) {
			customShowMessageBox("Invalid " + input.getAttribute("customLabel") + ". Valid value should be from " + formatToNthDecimal(input.getAttribute("min"), 2) + " to " + input.getAttribute("max") + ".", imgMessage.INFO, focus);
			input.value = lastValidValue.value;
		} else {
			input.value = addSeparatorToNumber2(formatNumberByRegExpPattern(input), ",");
			var decimalinput = ((input.value).include(".") ? input.value : (input.value)).split(".");
			if(decimalinput[1].length > 2){				
				customShowMessageBox("Invalid " + input.getAttribute("customLabel") + ". Valid value should be from " + formatToNthDecimal(input.getAttribute("min"), 2) + " to " + input.getAttribute("max") + ".", imgMessage.INFO, focus);
				input.value = lastValidValue.value;
			}else{	
				validateDefaultTsi();
			}
		}
	} 
	
	//pol cruz 01.14.2015
	function updateAllPerils(rowObj, isDelete) {
		rowObj.defaultTsi = unformatCurrencyValue(rowObj.defaultTsi);
		rowObj.perilCd = removeLeadingZero(rowObj.perilCd.toString()); 
		if(isDelete) {
			for(var i = 0; i < allPerils.length; i++) {
				if(removeLeadingZero(allPerils[i].perilCd.toString()) == rowObj.perilCd) {
					allPerils.splice(i, 1);
					break;
				}
			}
		} else {			
			if($F("btnAddPeril") == "Add") {			
				allPerils.push(rowObj);
			} else {
				for(var i = 0; i < allPerils.length; i++) {
					if(removeLeadingZero(allPerils[i].perilCd.toString()) == rowObj.perilCd) {
						allPerils.splice(i, 1, rowObj);
						break;
					}
				}
			}		
		}
	}
	
	//pol cruz 01.14.2015
	function validateDefaultTsi2() {
		var perilCd = removeLeadingZero($F("txtPerilCode"));
		var defaultTsi = unformatCurrencyValue(nvl($F("txtDefaultTsi"), 0));
		var bascPerlCd = removeLeadingZero($F("txtBasicPerilCd"));
		var perilType = $F("dDnPerilType");
					
		for(var i = 0; i < allPerils.length; i++) {
			if(perilType == "B") {
				if(defaultTsi < allPerils[i].defaultTsi && allPerils[i].perilType == "A" && allPerils[i].defaultTsi != null) {
					if(removeLeadingZero(allPerils[i].bascPerlCd.toString()) == perilCd || allPerils[i].bascPerlCd == "" || allPerils[i].bascPerlCd == null){
						if(allPerils[i].bascPerlCd == perilCd)
							customShowMessageBox("Peril (" +  $F("txtPerilName") + ") has attached perils. Default TSI Amount of this peril must not be lower than its attached perils. Please check attached allied peril amount.", imgMessage.INFO, "txtDefaultTsi");
						else
							customShowMessageBox("Default TSI amount of Basic Peril (" +  $F("txtPerilName") + ") must not be lower than any open allied peril.", imgMessage.INFO, "txtDefaultTsi");
						
						$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
						break;
					}
				}
			} else if(perilType == "A") {
				if(defaultTsi > nvl(allPerils[i].defaultTsi, 0) && allPerils[i].perilType == "B") {					
					if(allPerils[i].perilCd == bascPerlCd) {
						customShowMessageBox("Default TSI Amount of attached peril (" + $F("txtPerilName") + ") must not be higher than Basic Peril (" + allPerils[i].perilName + ").", imgMessage.INFO, "txtDefaultTsi");
						$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
						break;
					} else if((bascPerlCd == "" || bascPerlCd == null)  && allPerils[i].defaultTsi != null) {
						customShowMessageBox(" Default TSI Amount of this Allied peril must not be higher than the Default TSI Amount of any Basic Peril.", imgMessage.INFO, "txtDefaultTsi");
						$("txtDefaultTsi").value = $F("hidLastValidDefaultTsi");
						break;
					}
				}
			}
		}
		
	}
	
	$$("input[name='valDefaultTsi']").each(function(gl) {
		gl.observe("change", function() {
			/* if (gl.value != null || gl.value != "") {
				validateDefaultTsi();
			} */
			
			/* if (gl.value == null || gl.value == "") 
				gl.value = 0; */
			
			validateDefaultTsi2();
		});
	});
	
// 	$("txtDefaultTsi").observe("change", function(e){
// 		if($("txtDefaultTsi").value != ""){
// 			validateTsi($("txtDefaultTsi"), $("hidLastValidDefaultTsi"), "txtDefaultTsi");
// 		}else {
// 			$("hidLastValidDefaultTsi").value = $F("txtDefaultTsi");
// 		}
// 	});
	
// 	$("txtDefaultTsi").observe("blur", function(e){
// 		if($("txtDefaultTsi").value != ""){
// 			validateTsi($("txtDefaultTsi"), $("hidLastValidDefaultTsi"), "txtDefaultTsi");
// 		}
// 	});
	
	/*validates  input for ri comm rate and default rate(if not a number, includes "." and out of range return to its last valid value) */
	function validateRate(inputRate, lastValid, fieldLabel, min, max, decimalPlaces, focus, toDo){
		var defaultRateFieldValue = formatToNineDecimal(inputRate.value);
		if (defaultRateFieldValue < 0 && defaultRateFieldValue != "") {
			customShowMessageBox("Invalid " + fieldLabel + ". Valid value should be from " + min + " to " + max + ".", imgMessage.INFO, focus);
			inputRate.value = lastValid.value;
		} else if (inputRate.value != "" && isNaN(inputRate.value)) {
			inputRate.value = lastValid.value;
		}else if (defaultRateFieldValue > 100 && defaultRateFieldValue != ""){
			customShowMessageBox("Invalid " + fieldLabel + ". Valid value should be from " + min + " to " + max + ".", imgMessage.INFO, focus);
			inputRate.value = lastValid.value;
		}else if (inputRate.value.include("-")){
			customShowMessageBox("Invalid " + fieldLabel + ". Valid value should be from " + min + " to " + max + ".", imgMessage.INFO, focus);
			inputRate.value = lastValid.value;
		}else if (inputRate.value == ""){
			inputRate.value = toDo;
			lastValid.value = toDo;
		}else{
			var returnValue = "";
			var amt;
			amt = ((inputRate.value).include(".") ? inputRate.value : (inputRate.value).concat(".00")).split(".");
			if(decimalPlaces < amt[1].length){				
				returnValue = amt[0] + "." + amt[1].substring(0, decimalPlaces);
				customShowMessageBox("Invalid " + fieldLabel + ". Valid value should be from " + min + " to " + max + ".", imgMessage.INFO, focus);
				inputRate.value = lastValid.value;
			}else{
				if (amt[0] == ""){
					returnValue = "0" + amt[0] + "." + rpad(amt[1], decimalPlaces, "0");
				}else {
					returnValue = amt[0] + "." + rpad(amt[1], decimalPlaces, "0");
				}
				
				inputRate.value = returnValue;
				lastValid.value = returnValue;
			}
		} 
	}
	
	$("txtDefaultRate").observe("change",	function(e){
		validateRate($("txtDefaultRate"), $("hidLastValidDefaultRate"), "Default Rate", "0.000000000", "100.000000000", 9, "txtDefaultRate", "");
	});
	
	$("txtRiCommRate").observe("change",	function(e){
		validateRate($("txtRiCommRate"), $("hidLastValidRiCommRate"), "RI Comm Rate", "0.000000000", "100.000000000", 9, "txtRiCommRate", formatToNineDecimal(0));
	});
	
	function clearLastValidValueDetails() {
		$("hidLastValidSequence").value = "";
		$("hidLastValidPerilCode").value = "";
		$("hidLastValidPerilShortName").value = "";
		$("hidLastValidPerilName").value = "";
		$("hidLastValidDefaultRate").value = "";
		$("hidLastValidRiCommRate").value = "";
		$("hidLastValidDefaultTsi").value = "";
		$("hidLastValidSublineName").value = "";
		$("hidLastValidBasicPerilName").value = "";
		$("hidLastValidFi").value = "";
		$("hidLastValidEqFi").value = ""; //edgar 03/10/2015
		$("hidLastValidMc").value = "";
		$("hidLastValidSublineName").setAttribute("code", "");		//marco - 05.03.2013 - added attributes
		$("hidLastValidBasicPerilName").setAttribute("code", "");
		$("hidLastValidFi").setAttribute("code", "");
		$("hidLastValidEqFi").setAttribute("code", ""); //edgar 03/10/2015
		$("hidLastValidMc").setAttribute("code", "");
	}
	
	function clearFields() {
		$("txtSublineName").value		= "";
		$("txtBasicPerilName").value	= "";
		$("txtZoneNameMc").value		= "";
		$("txtZoneNameFi").value		= "";
		$("txtPerilCode").value 		= ""; 
		$("txtSequence").value 			= ""; 
		$("txtPerilShortName").value 	= "";
		$("txtPerilName").value 		= "";
		$("dDnPerilType").value 		= "B";
		$("txtSubline").value 			= "";
		$("txtRiCommRate").value 		= formatToNineDecimal(0); 
		$("dDnPrintTag").value 			= "1";
		$("txtBasicPerilCd").value 		= "";
		$("hidBasicPerilCd").value 		= "";
		$("chkProfitCommTag").checked	= false;
		$("txtPerilLongName").value 	= "";
		$("txtRemarks").value 			= "";
		$("txtZoneTypeFi").value 		= "";
		$("txtEqZoneTypeFi").value 		= ""; //edgar 03/10/2015
		$("txtZoneTypeMc").value 		= "";
		$("chkEvalSw").checked			= false;
		$("chkDefaultTag").checked		= false;
		$("txtDefaultRate").value 		= "";
		$("txtDefaultTsi").value 		= "";
		$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:M:ss TT');
		$("btnAddPeril").value = "Add";
	}
	
	function disableEdit(){
		disableInputField("txtPerilCode");
		$("dDnPerilType").disabled		= true;
	}
	
	function removeDisable(){
		enableInputField("txtPerilCode");
		$("dDnPerilType").disabled		= false;
	}
	
	function onRemove(){
		removeDisable();
		clearFields();
       	clearLastValidValueDetails();
       	disableSearch("btnSearchBasicPerilCd");
       	disableButton("btnDeletePeril");
       	disableButton("btnWandC");
       	disableButton("btnTariffCd");
       	$("txtDefaultTsi").removeClassName("required");
       	$("txtPerilCode").focus();
       	changed = false;
       	valPerilSname = null;
       	toggleEqZoneType(); //edgar 03/10/2015
	}
	
	function onFocus(){
		disableEdit();
		checkIfAllied();
		getSublineCdName();
		getBasicPerilCdName();
		getZoneName("getZoneNameMcName", $("txtZoneTypeMc"), $("txtZoneNameMc"));
		getZoneName("getZoneNameFiName", $("txtZoneTypeFi"), $("txtZoneNameFi"));
		getZoneName("getZoneNameFiName", $("txtEqZoneTypeFi"), $("txtEqZoneNameFi")); //edgar 03/10/2015
		checkDefaultTag();
		enableButton("btnWandC");
		enableButton("btnTariffCd");
		enableButton("btnDeletePeril");
		$("txtSequence").focus();
		$("btnAddPeril").value="Update";
		$("hidLastValidSequence").value = $F("txtSequence");
		$("hidLastValidPerilShortName").value = $F("txtPerilShortName");
		$("hidLastValidDefaultRate").value = $F("txtDefaultRate");
		$("hidLastValidRiCommRate").value = $F("txtRiCommRate");
		$("hidLastValidPerilName").value = $F("txtPerilName");
		$("hidLastValidDefaultTsi").value = $F("txtDefaultTsi");
		$("hidLastValidSublineName").value = $F("txtSublineName");
		$("hidLastValidFi").value = $F("txtZoneNameFi");
		$("hidLastValidEqFi").value = $F("txtEqZoneNameFi"); //edgar 03/10/2015
		$("hidLastValidMc").value = $F("txtZoneNameMc");
		$("hidLastValidBasicPerilName").value = $F("txtBasicPerilName");
		$("hidLastValidSublineName").setAttribute("code", $F("txtSubline"));			//marco - 05.03.2013 - added attributes
		$("hidLastValidBasicPerilName").setAttribute("code", $F("txtBasicPerilCd"));
		$("hidLastValidFi").setAttribute("code", $F("txtZoneTypeFi"));
		$("hidLastValidEqFi").setAttribute("code", $F("txtEqZoneTypeFi")); //edgar 03/10/2015
		$("hidLastValidMc").setAttribute("code", $F("txtZoneTypeMc"));
		originalSname = $F("txtPerilShortName");
	}
	
	function addUpdateDelete(){
		clearFields();
		clearLastValidValueDetails();
		disableButton("btnDeletePeril");
		disableButton("btnWandC");
		disableButton("btnTariffCd");
		$("txtPerilCode").focus();
	}
	
	function checkIfAllied(){
		if ($("dDnPerilType").value == 'A'){
			enableSearch("btnSearchBasicPerilCd");
			enableInputField("txtBasicPerilName");
		} else {
			disableSearch("btnSearchBasicPerilCd");
			disableInputField("txtBasicPerilName");
		}
	}
	
	function checkDefaultTag(){
		if ($("chkDefaultTag").checked == true){
			$("txtDefaultTsi").addClassName("required");
		}else{
			$("txtDefaultTsi").removeClassName("required");
		}
	}
	
	//marco - 05.03.2013 - moved from underwriting-lov.js (duplicate showSublineCdLOV function name)
	/*LOV for subline by lineCd
	for peril maintenance(giiss003)
	kenneth 10.17.2012*/
	var fromSubline = false;
	function showSublineCdLOV(lineCd, sublineName){
		fromSubline = false;
		
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getSublineCdLOV",
					lineCd : unescapeHTML2(lineCd),
					sublineName : unescapeHTML2(sublineName),
					page : 1
				},
				title: "List of Sublines",
				width : 375,
				 height : 386.5,
				columnModel : [{
					id : 'sublineCd',
	            	title : 'Subline Code',
	            	titleAlign: 'left',
	            	width :'100px'
	              },
	              {
	            	id :  'sublineName',
		            title : 'Subline Name',
		            titleAlign: 'left',
		            width : '259px'
	              },
	              ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(sublineName),
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtSublineName").value = $("hidLastValidSublineName").value;
					$("txtSubline").value = $("hidLastValidSublineName").getAttribute("code");
				},
				onSelect: function(row){
					$("txtSubline").value = unescapeHTML2(row.sublineCd);
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("hidLastValidSublineName").value = unescapeHTML2(row.sublineName);
					$("hidLastValidSublineName").setAttribute("code", unescapeHTML2(row.sublineCd));
				},
				onCancel: function(){
					$("txtSublineName").value = $("hidLastValidSublineName").value;
					$("txtSubline").value = $("hidLastValidSublineName").getAttribute("code");
				}
			});
		}catch(e){
			showErrorMessage("showSublineCdLOV", e);
		}
	}
	
	//marco - 05.03.2013 - added conditions for LOVs and text fields
 	$("btnSearchSubline").observe("click", function() {
 		if(!fromSubline){
 			if($F("txtSubline") == ""){
 	 			showSublineCdLOV($("hidLineCd").value, $("txtSublineName").value);
 	 		}else{
 	 			showSublineCdLOV($("hidLineCd").value, "%");
 	 		}
 		}
 		fromSubline = false;
	});
 	
 	$("txtSublineName").observe("change",function() {
 		$("txtSubline").value = "";
 		
		if($F("txtSublineName") != ""){
			showSublineCdLOV($("hidLineCd").value, $("txtSublineName").value);
		}else{
			$("txtSubline").value = "";
			$("hidLastValidSublineName").value = "";
			$("hidLastValidSublineName").setAttribute("code", "");
		}
		fromSubline = true;
	});
	
 	//marco - 05.03.2013 - moved from underwriting-lov.js
 	/*LOV for basic peril by lineCd
	for peril maintenance(giiss003)
	kenneth 10.17.2012*/
	var fromBasic = false;
	function showBasicPerilCdLOV(lineCd, perilName){
		fromBasic = false;
		
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getBasicPerilCdLOV",
					lineCd : unescapeHTML2(lineCd),
					perilName : perilName,
					page : 1
				},
				title: "List of Basic Perils",
				width : 375,
				 height : 386.5,
				columnModel : [{
					id :  'perilCd',
	            	title : 'Peril Code',
	            	titleAlign : 'right',
	            	align : 'right',
	            	width : '100px',
	            	renderer: function(value){
			    		return value == "" ? "" : lpad(value, 5, 0);
	            	}
	              },
	              {
	            	id : 'perilName',
	            	title : 'Peril Name',
	            	titleAlign: 'left',
	            	width :'259px'
	              },
	              ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : perilName,
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtBasicPerilName").value = $("hidLastValidBasicPerilName").value;
					$("txtBasicPerilCd").value = $("hidLastValidBasicPerilName").getAttribute("code");
				},
				onSelect: function(row){
					$("txtBasicPerilCd").value = row.perilCd;
					$("txtBasicPerilName").value = unescapeHTML2(row.perilName);
					$("hidLastValidBasicPerilName").value = unescapeHTML2(row.perilName);
					$("hidLastValidBasicPerilName").setAttribute("code", row.perilCd);
					if($F("hidBasicPerilCd") != row.perilCd){
						customShowMessageBox("Changing this basic peril code will delete its current Default TSI Amount.", imgMessage.INFO, "txtDefaultTsi");
						$("txtDefaultTsi").value = "";
					}
				},
				onCancel: function(){
					$("txtBasicPerilName").value = $("hidLastValidBasicPerilName").value;
					$("txtBasicPerilCd").value = $("hidLastValidBasicPerilName").getAttribute("code");
				}
			});
		}catch(e){
			showErrorMessage("showBascPerlCdLOV", e);
		}
	}
	
	//marco - 05.03.2013 - added conditions for LOVs and text fields
	$("btnSearchBasicPerilCd").observe("click", function() {
		if(!fromBasic){
			if($F("txtBasicPerilCd") == ""){
				showBasicPerilCdLOV($("hidLineCd").value, $("txtBasicPerilName").value);
			}else{
				showBasicPerilCdLOV($("hidLineCd").value, "%");
			}
		}
		fromBasic = false;
	});
	
	$("txtBasicPerilName").observe("change",function() {
		$("txtBasicPerilCd").value = "";
		
		if ($("txtBasicPerilName").value != ""){
			showBasicPerilCdLOV($("hidLineCd").value, $("txtBasicPerilName").value);
		}else if ($("txtBasicPerilName").value == ""){
			$("txtBasicPerilCd").value = "";
			$("hidLastValidBasicPerilName").value = "";
			$("hidLastValidBasicPerilName").setAttribute("code", "");
		}
		fromBasic = true;
	});
	
	//marco - 05.03.2013 - moved from underwriting-lov.js
	/*LOV for zone tpye of lines(MC and FI)
	for peril maintenance(giiss003)
	kenneth 10.17.2012*/
	var fromZone = false;
	function showZoneLOV(action, type, name, rvMeaning, lastValid){
		fromZone = false;
		
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : action,
					page : 1,
					rvMeaning : rvMeaning
				},
				title: "Zone Type",
				width : 375,
				 height : 386.5,
				columnModel : [{
					id :  'rvLowValue',
	            	title : 'Zone',
	            	titleAlign: 'left',
	            	width : '100px'
	              },
	              {
	            	id : 'rvMeaning',
	            	title : 'Description',
	            	titleAlign: 'left',
	            	width :'259px'
	              },
	              ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : rvMeaning,
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
					name.value = lastValid.value;
					type.value = lastValid.getAttribute("code"); //marco - 05.03.2013
				},
				onSelect: function(row){
					type.value = row.rvLowValue;
					name.value = unescapeHTML2(row.rvMeaning);
					lastValid.value = unescapeHTML2(row.rvMeaning);
					lastValid.setAttribute("code", row.rvLowValue); //marco - 05.03.2013
					toggleEqZoneType();//edgar 03/10/2015
				},
				onCancel: function(){
					name.value = lastValid.value;
					type.value = lastValid.getAttribute("code"); //marco - 05.03.2013
				}
			});
		}catch(e){
			showErrorMessage("showZoneType", e);
		}
	}
	
	//marco - 05.03.2013 - added conditions for LOVs and text fields
	$("btnSearchZoneTypeFi").observe("click", function() {
		if(!fromZone){
			if($F("txtZoneTypeFi") == ""){
				showZoneLOV("getZoneTypeFiLOV", $("txtZoneTypeFi"), $("txtZoneNameFi"), $("txtZoneNameFi").value, $("hidLastValidFi"));
			}else{
				showZoneLOV("getZoneTypeFiLOV", $("txtZoneTypeFi"), $("txtZoneNameFi"), "%", $("hidLastValidFi"));
			}
		}
		fromZone = false;
	});
	
	$("btnSearchZoneTypeMc").observe("click", function() {
		if(!fromZone){
			if($F("txtZoneTypeMc") == ""){
				showZoneLOV("getZoneTypeMcLOV", $("txtZoneTypeMc"), $("txtZoneNameMc"), $("txtZoneNameMc").value, $("hidLastValidMc"));
			}else{
				showZoneLOV("getZoneTypeMcLOV", $("txtZoneTypeMc"), $("txtZoneNameMc"), "%", $("hidLastValidMc"));
			}
		}
		fromZone = false;
	});
	
	$("txtZoneNameFi").observe("change",function() {
		$("txtZoneTypeFi").value = "";
		
		if ($("txtZoneNameFi").value != ""){
			showZoneLOV("getZoneTypeFiLOV", $("txtZoneTypeFi"), $("txtZoneNameFi"), $("txtZoneNameFi").value, $("hidLastValidFi"));
		}else if ($("txtZoneNameFi").value == ""){
			$("txtZoneTypeFi").value = "";
			$("hidLastValidFi").value = "";
		}
		fromZone = true;
	});
	
	$("txtZoneNameMc").observe("change",function() {
		$("txtZoneTypeMc").value = "";
		
		if ($("txtZoneNameMc").value != ""){
			showZoneLOV("getZoneTypeMcLOV", $("txtZoneTypeMc"), $("txtZoneNameMc"), $("txtZoneNameMc").value, $("hidLastValidMc"));
		}else if ($("txtZoneNameMc").value == ""){
			$("txtZoneTypeMc").value = "";
			$("hidLastValidMc").value = "";
		}
		fromZone = true;
	});
 	
	$("chkDefaultTag").observe("change",function() {
		checkDefaultTag();
	});
	
	observeCancelForm("perilMaintenanceExit", savePerilDetail, function(){
		lineMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	
	observeCancelForm("btnCancelLine", savePerilDetail, function(){
		lineMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
		
	observeSaveForm("btnSaveLine", savePerilDetail);
	observeReloadForm("reloadForm", showPerilMaintenance);
	$("btnAddPeril").observe("click", addUpdatePeril);
	$("txtPerilName").observe("change", validatePerilName);
	//$("txtPerilShortName").observe("change", validatePerilSname);
	$("btnDeletePeril").observe("click", deletePeril);
	
	$("txtPerilShortName").observe("change",function() {
		if ($F("txtPerilShortName") != valPerilSname) {
			changed = true;
		}else {
			changed = false;
		}
	});
	
	//added edgar 03/10/2015
	function toggleEqZoneType(){
		if ($("txtZoneTypeFi").value != 3){
			disableSearch("btnSearchEqZoneTypeFi");
			disableInputField("txtEqZoneNameFi");
			$("txtEqZoneNameFi").value = "";
			$("txtEqZoneTypeFi").value = "";
			$("txtEqZoneNameFi").removeClassName("required");
		}else{
			enableSearch("btnSearchEqZoneTypeFi");
			enableInputField("txtEqZoneNameFi");
			$("txtEqZoneNameFi").addClassName("required");
		}
	}
	
	$("btnSearchEqZoneTypeFi").observe("click", function() {
		if(!fromZone){
			if($F("txtEqZoneTypeFi") == ""){
				showZoneLOV("getEqZoneTypeFiLOV", $("txtEqZoneTypeFi"), $("txtEqZoneNameFi"), $("txtEqZoneNameFi").value, $("hidLastValidEqFi"));
			}else{
				showZoneLOV("getEqZoneTypeFiLOV", $("txtEqZoneTypeFi"), $("txtEqZoneNameFi"), "%", $("hidLastValidEqFi"));
			}
		}
		fromZone = false;
	});
	
	$("txtEqZoneNameFi").observe("change",function() {
		$("txtEqZoneTypeFi").value = "";
		
		if ($("txtEqZoneNameFi").value != ""){
			showZoneLOV("getEqZoneTypeFiLOV", $("txtEqZoneTypeFi"), $("txtEqZoneNameFi"), $("txtEqZoneNameFi").value, $("hidLastValidEqFi"));
		}else if ($("txtEqZoneNameFi").value == ""){
			$("txtEqZoneTypeFi").value = "";
			$("hidLastValidEqFi").value = "";
		}
		fromZone = true;
	});
	toggleEqZoneType();
</script>