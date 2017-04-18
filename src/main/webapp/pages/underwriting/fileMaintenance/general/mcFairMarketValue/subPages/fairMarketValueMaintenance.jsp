<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div id="fairMarketValueMaintenanceSubSectionDiv" class= "subSectionDiv" style="height: 457px; bottom: 10px;">
	<div id="fairMarketValueMaintenanceTable" style="height: 230px; position:relative; left:50px; top:10px; right: 10px;" ></div>
<!-- Form -->
	<div id="fairMarketValueMaintenanceInfo" class="subSectionDiv" style="top:10px; bottom:10px; position:relative; height: 180px; width: 100%;">
	<table align="center">

		<tr>
			<td class="leftAligned">Year</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned">
				<span class="lovSpan required" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
					<input id="txtModelYear" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="101" maxlength="4" ignoreDelKey="true" readonly="readonly">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchModelYear" name="searchModelYear" alt="Go" style="float: right;">
				</span>		
			</td>
			<td class="leftAligned">No.</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned" ><input class="integerNoNegativeUnformattedNoComma" type="text" id="txtHistNo" name="txtHistNo" style="width: 230px;" maxlength="3" readonly="readonly" tabindex="102"/></td>
		</tr>
		<tr>
			<td class="leftAligned">Min. Fair Market Value</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned" ><input type="text" class="applyDecimalRegExp" regExpPatt="pDeci1402" min="0.00" max="99999999999999.99" id="txtFmvValueMin" name="txtFmvValueMin" style="width: 230px;" maxlength="17" readonly="readonly" tabindex="103"/></td>
			<td class="leftAligned" style="width: 150px;">Max Fair Market Value</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned"><input type="text" class="applyDecimalRegExp" regExpPatt="pDeci1402" min="0.00" max="99999999999999.99" id="txtFmvValueMax" name="txtFmvValueMax" style="width: 230px;"  maxlength="17" readonly="readonly" tabindex="104"/></td>
		</tr>
		<tr>
			<td class="leftAligned">Latest Fair Market Value</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned"><input type="text" class="applyDecimalRegExp required" regExpPatt="pDeci1402" min="0.00" max="99999999999999.99" id="txtFmvValue" name="txtFmvValue" style="width: 230px;"  maxlength="17" readonly="readonly" tabindex="105"/></td>
			<td class="leftAligned" style="width: 100px;">Effectivity Date</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned" colspan="2">
				<div style="float: left; width: 235px;" class="withIconDiv" id="divEffDate">
					<input type="text" class="withIcon disableDelKey required" readonly="readonly" id="txtEffDate" name="txtEffDate" style="width: 210px;"  maxlength="50" tabindex="106"/>
					<img id="hrefEffDate" alt="hrefEffDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('txtEffDate'),this, null);" tabindex="107"/> 
				</div>					
			</td>					
		</tr>
		<tr>
			<td class="leftAligned">User ID</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" readonly="readonly" style="width: 230px;" tabindex="108"/></td>
			<td class="leftAligned" width="85">Last Update</td>
			<td style="width: 5px;">:</td>
			<td class="leftAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly" style="width: 230px;" tabindex="109"/></td>
		</tr>	
	</table>
	</div>
<!-- Add/Delete -->
	<div style="float:left; width: 100%; margin-top: 10px; margin-bottom: 10px;" align = "center">
		<input type="button" class="disabledButton" id="btnAddFairMarketValue" name="btnAddFairMarketValue" value="Add" disabled="disabled" tabindex="110"/>
		<input type="button" class="disabledButton" id="btnDeleteFairMarketValue" name="btnDeleteFairMarketValue" value="Delete" disabled="disabled" tabindex="111"/>
	</div>
	<div id="hidden" style="display: none;">
		<input type="hidden" id="dateFormat" name="dateFormat">
	</div>	
</div>

<script type="text/javascript">
	
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var delObj;
	var rowObj;
	var unsavedStatus;
	var changeCounter = 0;
	objFmvMaintain = null;
	
	try{			
		var row = 0;
		var objFmvMain = [];
		var objFmv = new Object();
		objFmv.objFmvListing = [];
		objFmv.objFmvMaintenance = objFmv.objFmvListing.rows || [];
		disableButton("btnDeleteFairMarketValue");
	
		var fmvListTG = {
				url: contextPath+"/GIISMcFairMarketValueController?action=showMcFairMarketValueMaintenance",
				options: {
					width: '820px',
					height: '200px',
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objFmvMaintain = fmvListTableGrid.geniisysRows[y]; 
						populateFmvDetails(objFmvMaintain);	
						disableForm();
					},
					onRemoveRowFocus: function(){
						fmvListTableGrid.keys.releaseKeys();
				 		fmvListTableGrid.keys.removeFocus(fmvListTableGrid.keys._nCurrentFocus, true);
				 		formatAppearance();
				 		displayValue();
				 		objFmvMaintain = null;
            		},	
            		beforeSort: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			displayValue();		
               			}				
            		},	
            		prePager: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			formatAppearance();
                			displayValue();		
               			}				
            		},
            		onSort: function(){
            			formatAppearance();
            			displayValue();
            		},
					onRefresh: function(){
	            		if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
                		} else {
                			if ($(mtgRefreshBtn2).getAttribute("class") == "disabled") {
                				null;
                			} else {
                    			formatAppearance();
                    			displayValue();	                				
                			}
               			}
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
	                			if ($(mtgFilterBtn2).getAttribute("class") == "disabled filterbutton") {
	                				null;
	                			} else {
	                    			formatAppearance();
	                    			displayValue();	                				
	                			}	                				
	               			}
						}	
					}
				},
				columnModel: [
					{   
						id: 'recordStatus',
			    		title: '',
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
						id: 'carCompanyCd',
						width: '0',
						visible: false
					},
					{	
						id: 'makeCd',
						width: '0',
						visible: false
					},
					{	
						id: 'seriesCd',
						width: '0',
						visible: false
					},					
		    		{   		
						id: 'modelYear',
			    		title: 'Year',
					    width: '80px',
					    visible: true,
			    		filterOption: true,
			    		sortable:true
					},
					{	
						id: 'histNo',
						title: 'No.',
						width: '60px',
						visible: true,
						filterOption: true,
						filterOptionType : 'integerNoNegative',
						sortable:true,
						renderer: function(value) {
						  	return value == "" ? "" : formatNumberDigits(value, 2);
				   		}
					},
					{	
						id: 'effDate',
						title: 'Effectivity Date',
						width: '150px',
						visible: true,
 						filterOption: true,
 						filterOptionType : 'formattedDate',
						sortable:true,
			           	renderer : function(val) {
				           	if(val != "" && val != null)
				           	return dateFormat(val, "mm-dd-yyyy");
				           	else
				           	return ""; } 							
					}, 				
					{	
						id: 'fmvValue',
						title: 'Value',
						width: '150px',
						visible: true,
						filterOption: true,
						sortable:true,
						align: 'right',
						titleAlign: 'right',
						renderer : function(value){
							return formatCurrency(value);}						
					},
					{	
						id: 'fmvValueMin',
						title: 'Minimum',
						width: '150px',
						visible: true,
						filterOption: true,
						sortable:true,
						align: 'right',
						titleAlign: 'right',
						renderer : function(value){
							return formatCurrency(value);}		
					},
					{	
						id: 'fmvValueMax',
						title: 'Maximum',
						width: '150px',
						visible: true,
						filterOption: true,
						sortable:true,
						align: 'right',
						titleAlign: 'right',
						renderer : function(value){
							return formatCurrency(value);}		
					},
					{	
						id: 'deleteSw',
						title: 'D',
						width: '30px',
						filterOption: true,
						sortable:true,
						align: 'center',
						titleAlign: 'center',
						filterOptionType: true,
						filterOptionType: 'checkbox',
						altTitle : 'Deleted',
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
						id: 'userId',
						width: '0px',
						visible: false
					},
					{	
						id: 'lastUpdate',
						width: '0px',
						visible: false
					}
				],
				rows: objFmv.objFmvMaintenance
		};
		fmvListTableGrid = new MyTableGrid(fmvListTG);
		fmvListTableGrid.pager = objFmv.objFmvListing;
		fmvListTableGrid.render('fairMarketValueMaintenanceTable');
		fmvListTableGrid.afterRender = function(){
			objFmvMain = fmvListTableGrid.geniisysRows;
			changeTag = 0;
			getMaxSequence();
			getLastEffDate();			
		};
	
		function setFmvObj(func){
			var objFmv = new Object();
			objFmv.carCompanyCd 			= objMotorCarMaintain.carCompanyCd;
			objFmv.makeCd 					= objMotorCarMaintain.makeCd;
			objFmv.seriesCd 				= objMotorCarMaintain.seriesCd;
			objFmv.modelYear 				= escapeHTML2($("txtModelYear").value);
			objFmv.histNo 					= escapeHTML2($("txtHistNo").value);
			objFmv.effDate 					= escapeHTML2($("txtEffDate").value);
			objFmv.fmvValue 				= escapeHTML2($("txtFmvValue").value);
			objFmv.fmvValueMin 				= escapeHTML2($("txtFmvValueMin").value);
			objFmv.fmvValueMax 				= escapeHTML2($("txtFmvValueMax").value);
			objFmv.deleteSw 				= "N";
			objFmv.userId 					= $("txtUserId").value;
			objFmv.lastUpdate				= $("txtLastUpdate").value;
			objFmv.recordStatus  	 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return objFmv;							
		}
	
		function populateFmvDetails(obj){
			$("carCompanyCd").value 	= obj == null ? "" : obj.carCompanyCd;
			$("makeCd").value 			= obj == null ? "" : obj.makeCd;
			$("seriesCd").value 		= obj == null ? "" : obj.seriesCd;
			$("txtModelYear").value 	= obj == null ? "" : unescapeHTML2(obj.modelYear);
			$("txtHistNo").value 		= obj == null ? "" : formatNumberDigits(obj.histNo,2);
			$("txtEffDate").value 		= obj == null ? "" : dateFormat(new Date(obj.effDate),'mm-dd-yyyy');
			$("txtFmvValue").value 		= obj == null ? "" : formatCurrency(unescapeHTML2(obj.fmvValue));
			$("txtFmvValueMin").value 	= obj == null ? "" : formatCurrency(unescapeHTML2(obj.fmvValueMin));
			$("txtFmvValueMax").value 	= obj == null ? "" : formatCurrency(unescapeHTML2(obj.fmvValueMax));	
			$("txtUserId").value 		= obj == null ? "" : obj.userId;
			$("txtLastUpdate").value 	= obj == null ? "" : obj.lastUpdate; 	
		}
	
 		function deleteFmv(){
			delObj = setFmvObj($("btnDeleteFairMarketValue").value);
			objFmvMain.splice(row, 1, delObj);
			fmvListTableGrid.updateVisibleRowOnly(delObj, row);
			fmvListTableGrid.onRemoveRowFocus();
			changeTag = 1;
			changeCounter++;
		} 		
	
		function addFairMarketValue(){
			rowObj = setFmvObj($("btnAddFairMarketValue").value);
			if(checkAllRequiredFieldsInDiv("fairMarketValueMaintenanceInfo")){
				unsavedStatus = 1;
				objFmvMain.push(rowObj);
				fmvListTableGrid.addBottomRow(rowObj);
				fmvListTableGrid.onRemoveRowFocus();
				changeTag = 1;
				changeCounter++;
			}
		}	
 
 		function saveFmv() {
 			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objFmvMain);
			objParams.delRows = getDeletedJSONObjects(objFmvMain);			
			
			new Ajax.Request(contextPath+"/GIISMcFairMarketValueController?action=saveFmv",{
				method: "POST",
				parameters:{
					parameters : JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					changeTag = 0;
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							formatAppearance();
							fmvListTableGrid.refresh();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
 	
		function formatAppearance() {
			try{
				$("btnAddFairMarketValue").value = "Add";
				disableButton("btnDeleteFairMarketValue");
				populateFmvDetails(null); 
				getMaxSequence();
				getModelYear();
				getLastEffDate();
				enableForm();
				fmvListTableGrid.keys.releaseKeys();
			}catch (e) {
				showErrorMessage("formatAppearance",e);
			}
		}
	
		function enableForm() {		 
 			enableInputField("txtModelYear");
 			enableDate("hrefEffDate");
 			enableSearch("searchModelYear");
			enableInputField("txtFmvValueMin");
			enableInputField("txtFmvValueMax");
			enableInputField("txtFmvValue");
	   		enableButton("btnAddFairMarketValue");
		}
		
		function disableForm() {
 			disableDate("hrefEffDate");
			disableSearch("searchModelYear");
 			disableInputField("txtModelYear");
			disableInputField("txtFmvValueMin");
			disableInputField("txtFmvValueMax");
			disableInputField("txtFmvValue");					
	   		disableButton("btnAddFairMarketValue");	 
	   		enableButton("btnDeleteFairMarketValue");	
		}		
	
		function displayValue() {
			$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
			$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		}
				
		function getMaxSequence() {		
			if(fmvListTableGrid.geniisysRows.length > 0){
				var rec = fmvListTableGrid.geniisysRows[0];
				maxSequence = rec.maxSequence;				
				$("txtHistNo").value = formatNumberDigits(maxSequence,2);				
			} else {
				$("txtHistNo").value = formatNumberDigits(1,2);
			}	 
		}
		
		function getLastEffDate() {
			var currentEffDate = dateFormat(new Date(),'mm-dd-yyyy');			
			
 			if(fmvListTableGrid.geniisysRows.length > 0){
				var rec = fmvListTableGrid.geniisysRows[0];
				lastEffDate = rec.lastEffDate
			} else {
				lastEffDate = currentEffDate;
			}			
			$("txtEffDate").value = currentEffDate;
		}

		function toUpperCase() {
			this.value = this.value.toUpperCase();
		}
		
		function getModelYear() {
			if ($("txtModelYear").value == ""){
				$("txtModelYear").setAttribute("lastValidValue", dateFormat(new Date(),'yyyy'));
				$("txtModelYear").value = dateFormat(new Date(),'yyyy');
			} 
			$("txtEffDate").value = (lastEffDate == null ? null : dateFormat(new Date(lastEffDate),'mm-dd-yyyy'));
		}

 		$("btnAddFairMarketValue").observe("click", function(){
  			var d1 = Date.parse(lastEffDate);
  			var d2 = Date.parse($F("txtEffDate"));
  			var currentEffDate = dateFormat(new Date(),'mm-dd-yyyy');
  			
  			if ($("txtModelYear").readAttribute("readonly") == "readonly") {  				
				null;
  			} else {
	  			if ((d1 > d2) && fmvListTableGrid.geniisysRows.length > 0) { 	  				
	  				customShowMessageBox("Effectivity Date should be greater than the effectivity date of previous history record.", "E", "txtEffDate");
	  				$("txtEffDate").value = currentEffDate;
	  			} else {
	  	 			addFairMarketValue();
	  	 			saveFmv();
	  			}
  			}   
		});
	
 		$("btnDeleteFairMarketValue").observe("click", function(){
  			if (objFmvMaintain.deleteSw == "Y") {
 				customShowMessageBox("Record is already tagged as Deleted.", "E", "btnDeleteFairMarketValue");
 			} else {
				showConfirmBox("Confirmation", "Are you sure you want to delete this record?", 
						"Yes", "No", function(){deleteFmv();saveFmv();}, "");
				return false;
 			} 
		});
		
		$("txtModelYear").setAttribute("lastValidValue", "");
		
		$("txtModelYear").observe("keyup", function(){
			$("txtModelYear").value = $F("txtModelYear").toUpperCase();
		});
		
		$("txtModelYear").observe("change", function() {				
			if($F("txtModelYear").trim() == "") {
				$("txtModelYear").value = "";
				$("txtModelYear").setAttribute("lastValidValue", "");
			} else { 
				if($F("txtModelYear").trim() != "" && $F("txtModelYear") != $("txtModelYear").readAttribute("lastValidValue")) {
					showGIISS223ModelYear();
				}
			} 
		});		
				
		function showGIISS223ModelYear(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS223ModelYear", 
					filterText : ($("txtModelYear").readAttribute("lastValidValue").trim() != $F("txtModelYear").trim() ? $F("txtModelYear").trim() : ""),
					page : 1
				},
				title: "List of Model Years",
				width: '400px',
				height: '250px',
				columnModel : [
						{
							id : "modelYear",
							title: "Year",
							width: '100px',
							filterOption: true
						}
				],
				autoSelectOneRecord: true,
				filterText : ($("txtModelYear").readAttribute("lastValidValue").trim() != $F("txtModelYear").trim() ? $F("txtModelYear").trim() : ""),
				onSelect: function(row) {
					$("txtModelYear").value = unescapeHTML2(row.modelYear);
					$("txtModelYear").setAttribute("lastValidValue", $("txtModelYear").value);
				},
				onCancel: function (){
					$("txtModelYear").value = $("txtModelYear").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtModelYear").value = $("txtModelYear").readAttribute("lastValidValue");
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}
		
		$("searchModelYear").observe("click", showGIISS223ModelYear);
		
 		$("txtFmvValueMin").observe("change",function() { 
 			var minVal = parseFloat(unformatNumber($F("txtFmvValueMin")));
			var maxVal = parseFloat(unformatNumber($F("txtFmvValueMax")));
			var latestVal = parseFloat(unformatNumber($F("txtFmvValue"))); 
 			
			if ($("txtFmvValue").value != "" && minVal >= latestVal) {
 				customShowMessageBox("Min FMV should be less than Latest FMV.", "E", "txtFmvValueMin");
 				$("txtFmvValueMin").value = "";
 			} else if ($("txtFmvValueMax").value != "" && minVal >= maxVal) {
 				customShowMessageBox("Min FMV should be less than Max FMV.", "E", "txtFmvValueMin");
 				$("txtFmvValueMin").value = "";
 			}
		}); 
 		
  		$("txtFmvValueMax").observe("change",function() {
 			var minVal = parseFloat(unformatNumber($F("txtFmvValueMin")));
			var maxVal = parseFloat(unformatNumber($F("txtFmvValueMax")));
			var latestVal = parseFloat(unformatNumber($F("txtFmvValue")));
 			
			if ($("txtFmvValue").value != "" && latestVal >= maxVal) {
 				customShowMessageBox("Max FMV should be greater than Latest FMV.", "E", "txtFmvValueMax");
 				$("txtFmvValueMax").value = "";
 			} else if ($("txtFmvValueMin").value != "" && minVal >= maxVal) {
 				customShowMessageBox("Max FMV should be greater than Min FMV.", "E", "txtFmvValueMax");
 				$("txtFmvValueMax").value = "";
 			}
		});   		
		
  		$("txtFmvValue").observe("change",function() {
 			var minVal = parseFloat(unformatNumber($F("txtFmvValueMin")));
			var maxVal = parseFloat(unformatNumber($F("txtFmvValueMax")));
			var latestVal = parseFloat(unformatNumber($F("txtFmvValue")));
 			
			if ($("txtFmvValueMin").value != "" && minVal >= latestVal) {
 				customShowMessageBox("Latest FMV should be greater than Min FMV.", "E", "txtFmvValue");
 				$("txtFmvValue").value = "";
 			} else if ($("txtFmvValueMax").value != "" && latestVal >= maxVal) {
 				customShowMessageBox("Latest FMV should be less than Max FMV.", "E", "txtFmvValue");
 				$("txtFmvValue").value = "";
 			}
		});     
  		
  		$("txtEffDate").observe("change",function() {  		  			
  			var d1 = Date.parse(lastEffDate);
  			var d2 = Date.parse($F("txtEffDate"));
  			var currentEffDate = dateFormat(new Date(),'mm-dd-yyyy');
  			
  			if ($("txtModelYear").readAttribute("readonly") == "readonly") {  				
				null;
  			} else {
	  			if (d1 > d2) { 	  				
	  				customShowMessageBox("Effectivity Date should be greater than the effectivity date of previous history record.", "E", "txtEffDate");
	  				$("txtEffDate").value = currentEffDate;
	  			} 
  			} 
		});	
	
		observeReloadForm("reloadForm",showMcFairMarketValueMaintenance);	
	
		observeCancelForm("mcFairMarketValueMainExit", saveMortgagee, function(){
			fmvListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
		}); 

	}catch (e) {
	 	showErrorMessage("Fair Market Value Maintenance Table Grid", e); 
	}
	
</script>