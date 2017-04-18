<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div  id="mcDepRateListingSubSectionDiv" class= "subSectionDiv" style="height: 340px; top: 10px; bottom: 10px;" >
	<div id="mcDepRateListingTable" style="position:relative; left:15px; top:10px; bottom: 10px;" ></div>
	<input type="hidden" id="id" name="id"/>
	<input type="hidden" id="carCompanyCd" name="carCompanyCd"/>
	<input type="hidden" id="makeCd" name="makeCd"/>
	<input type="hidden" id="sublineCd" name="sublineCd"/>
	<input type="hidden" id="seriesCd" name="seriesCd"/>
	<input type="hidden" id="sublineTypeCd" name="sublineTypeCd"/>
	<input type="hidden" id="deleteSw" name="deleteSw"/>	
	<input type="hidden" id="perilRec" name="perilRec"/>
	<input id="lineCd" type="hidden" value="" name="lineCd"/>
</div>

<!-- Form -->
	<div id="mcDepRateMaintenanceInfo" class="subSectionDiv" style="top:10px; bottom:10px; position:relative; height: 150px; width: 100%;">
		<table align="center">
			<tr>
				<td class="leftAligned" style="width: 120px;">Car Company</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtCarCompany" type="text" class="required upper" readonly="readonly" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="100" maxlength="50" ignoreDelKey="true">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCarCompany" name="searchCarCompany" alt="Go" style="float: right;">
					</span>		
				</td>			
				<td class="leftAligned" style="width: 120px; padding-left: 40px;">Make</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtMake" type="text" class="upper"  style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="101" maxlength="50">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchMake" name="searchMake" alt="Go" style="float: right;">
					</span>		
				</td>				
			</tr>		
			<tr>
				<td class="leftAligned" style="width: 120px;">Model Year</td>
				<td style="width: 5px;">:</td>
					<td class="leftAligned" style="width: 236px;">
						<select id="modelYear" name="modelYear" style="width: 99%;" value="${txtLineCd}">
							<option></option>
							<c:forEach var="year" items="${modelYearListing}">
								<option value="${year.modelYear}" modelYear="${year.modelYear}">${year.modelYear}</option>				
							</c:forEach>
						</select>
					</td>
				<td class="leftAligned" style="width: 120px; padding-left: 40px;">Engine Series</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtEngineSeries" type="text" class="upper" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="102" maxlength="50">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEngineSeries" name="searchEngineSeries" alt="Go" style="float: right;">
					</span>		
				</td>	
			</tr>
			<tr>
				<td class="leftAligned" style="width: 120px;">Line</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtLineCd" type="text" class="required upper" readonly="readonly" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="103" maxlength="50"  ignoreDelKey="true">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;">
					</span>		
				</td>				
				<td class="leftAligned" style="width: 120px; padding-left: 40px;">Subline</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtSubline" type="text" class="upper" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="102" maxlength="50">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSubline" name="searchSubline" alt="Go" style="float: right;">
					</span>		
				</td>	
			</tr>			
			<tr>
				<td class="leftAligned" style="width: 120px;">Subline Type</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 236px; height: 22px; margin: 2px 2px 0 0; float: left;">
						<input id="txtSublineType" type="text" class="upper" style="width: 200px; text-align: left; height: 13px; float: left; border: none;" tabindex="103" maxlength="50">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineType" name="searchSublineType" alt="Go" style="float: right;">
					</span>		
				</td>				
				<td class="leftAligned" style="width: 120px; padding-left: 40px;">Depreciation Rate</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned"><input type="text" class="required applyDecimalRegExp" regExpPatt="pDeci1402" min="0.00" max="100.00" id="txtDepreciationRate" name="txtDepreciationRate" style="width: 230px;"  maxlength="6" tabindex="104"/></td>
			</tr>
			<tr>
				<td class="leftAligned" style="width: 120px;">User ID</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" readonly="readonly" style="width: 230px;" tabindex="105"/></td>
				<td class="leftAligned" style="width: 120px; padding-left: 40px;">Last Update</td>
				<td style="width: 5px;">:</td>
				<td class="leftAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly" style="width: 230px;" tabindex="106"/></td>
			</tr>	
		</table>
	</div>
	
	<!-- Add/Delete/Perils -->
	<div style="float:left; width: 100%; margin-top: 30px; margin-bottom: 10px;" align = "center">
		<input type="button" class="disabledButton" id="btnAddMcDepRate" name="btnAddMcDepRate" value="Add" tabindex="107"/>
		<input type="button" class="disabledButton" id="btnDeleteMcDepRate" name="btnDeleteMcDepRate" value="Delete" disabled="disabled" tabindex="108"/>
		<input type="button" class="disabledButton" id="btnPerilsMcDepRate" name="btnPerilsMcDepRate" value="Perils" disabled="disabled" tabindex="109" style="width: 65px;"/>
	</div>

<script type="text/javascript">
 
    makeInputFieldUpperCase();
	setDocumentTitle("Motorcar Depreciation Maintenance");
	setModuleId("GIISS224");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var delObj;
	var rowObj;
	var unsavedStatus;
	var changeCounter = 0;
	objMcDepRateMaintain = null;
	var rowIndex = -1;
	var delSw = null;

	try{
		var row = 0;
		var objMcDrMain = [];
		var objMcDepRate = new Object();
		objMcDepRate.objMcDepRateListing = JSON.parse('${mcDepRateListing}'.replace(/\\/g, '\\\\'));
		objMcDepRate.objMcDepRateMaintenance = objMcDepRate.objMcDepRateListing.rows || [];
	
		var mcDepRateListTG = {
				url: contextPath+"/GIISMcDepreciationRateController?action=showSourceMcDepreciationRateMaintenance",
				options: {
					width: '890px',
					height: '300px',
				onCellFocus: function(element, value, x, y, id){
					row = y;					
					rowIndex = y;
					objMcDepRateMaintain = mcDepRateListTableGrid.geniisysRows[y];
					populateMcDrDetails(objMcDepRateMaintain);	
				},
				onRemoveRowFocus: function(){
					rowIndex = -1;				
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					populateMcDrDetails(null);
    					displayValue();
                	}
            	},
           		beforeSort: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		clearForm();
                		displayValue();		
                	}
           	 	},
            	onSort: function(){
            		rowIndex = -1;
					clearForm();					
					populateMcDrDetails(null);
					displayValue();
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
				onRefresh: function(){
					rowIndex = -1;
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					populateMcDrDetails(null);
    					displayValue();
                	}
				},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
	 	            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
            	    	} else {
    						clearForm();
	    					populateMcDrDetails(null);
	    					displayValue();
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
					id: 'id',		
					width: '0',
					visible: false
				},	
		    	{   
					id: 'carCompanyCd',		
					width: '0',
					visible: false
				},					
		    	{   
					id: 'carCompany',
			    	title: 'Car Company',
				    width: '139px',
				    visible: true,
				    filterOption: true,
			    	sortable:true
				},
		    	{   
					id: 'makeCd',		
					width: '0',
					visible: false
				},					
				{	
					id: 'make',
					title: 'Car Make',
					width: '140px',
					visible: true,
					filterOption: true,
					sortable:true
				},	
		    	{   
					id: 'seriesCd',		
					width: '0',
					visible: false
				},	
				{	
					id: 'engineSeries',
					title: 'Engine Series',
					width: '123px',
					visible: true,
					filterOption: true,
					sortable:true
				},
				{	
					id: 'modelYear',
					title: 'Model Yr',
					width: '55px',
					visible: true,
					filterOption: true,
					sortable:true,
					align: 'right'
				},
				{	
					id: 'lineCd',
					title: 'Line',
					width: '30px',
					visible: true,
					filterOption: true,
					sortable:true
				},							
		    	{   
					id: 'sublineCd',		
					width: '0',
					visible: false
				},	
				{	
					id: 'sublineName',
					title: 'Subline',
					width: '155px',
					visible: true,
					filterOption: true,
					sortable:true
				},					
		    	{   
					id: 'sublineTypeCd',		
					width: '0',
					visible: false
				},					
				{	
					id: 'sublineType',
					title: 'Subline Type',
					width: '155px',
					visible: true,
					filterOption: true,
					sortable:true
				},	
				{	
					id: 'rate',
					title: 'Rate',
					width: '40px',
					visible: true,
					filterOption: true,
					sortable:true,			
					align: 'right',
					renderer : function(value){
						return formatCurrency(value)+"%";}						
				},						
		    	{   
					id: 'deleteSw',		
					width: '0',
					visible: false
				}	
			],
			rows: objMcDepRate.objMcDepRateMaintenance
		};
		mcDepRateListTableGrid = new MyTableGrid(mcDepRateListTG);
		mcDepRateListTableGrid.pager = objMcDepRate.objMcDepRateListing;
		mcDepRateListTableGrid.render('mcDepRateListingTable');
		mcDepRateListTableGrid.afterRender = function(){
			objMcDrMain = mcDepRateListTableGrid.geniisysRows;
			changeTag = 0;
		};
	
		function clearForm() {
 			$("id").value = null;
			$("carCompanyCd").value = null;
		 	$("makeCd").value = null;
		 	$("lineCd").value = null;
		 	$("sublineCd").value = null;
     		$("seriesCd").value = null;
     		$("sublineTypeCd").value = null;
     		$("deleteSw").value = null;     		
     		$("txtCarCompany").value = null;     		
			$("modelYear").value = "";
			$("txtLineCd").value = null;
			$("txtSubline").value = null;
			$("txtSublineType").value = null;
	 		$("txtMake").value = null;
		 	$("txtEngineSeries").value = null;
		 	$("txtDepreciationRate").value = null;
			mcDepRateListTableGrid.keys.releaseKeys();						
		}	
		
		function setMcDrObj(func){
			var objMcDr = new Object();
			objMcDr.id 						= $("id").value;
			objMcDr.carCompanyCd 			= $("carCompanyCd").value;
			objMcDr.carCompany 				= escapeHTML2($("txtCarCompany").value);
			objMcDr.makeCd 				    = $("makeCd").value;
			objMcDr.make 					= escapeHTML2($("txtMake").value);
			objMcDr.seriesCd 				= $("seriesCd").value;
			objMcDr.engineSeries 			= escapeHTML2($("txtEngineSeries").value);
			objMcDr.modelYear 				= $("modelYear").value;
			objMcDr.lineCd 				    = $("txtLineCd").value;		
			objMcDr.sublineCd 				= $("sublineCd").value;			
			objMcDr.sublineTypeCd 			= $("sublineTypeCd").value;
			objMcDr.sublineType 			= $("txtSublineType").value;
			objMcDr.rate				    = formatCurrency(escapeHTML2($("txtDepreciationRate").value));
			objMcDr.deleteSw 				= delSw;
			objMcDr.userId 					= $("txtUserId").value;
			objMcDr.lastUpdate				= $("txtLastUpdate").value;			
			objMcDr.recordStatus  	 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;					
			return objMcDr;							
		}		
		
		function populateMcDrDetails(obj){
			try{
				clearForm();
				$("id").value 			    		= obj == null ? "" : obj.id;
				$("carCompanyCd").value 			= obj == null ? "" : obj.carCompanyCd;
				$("carCompanyCd").setAttribute("lastValidValue", (obj == null ? "" : obj.carCompanyCd));
				$("makeCd").value 					= obj == null ? "" : obj.makeCd;
				$("makeCd").setAttribute("lastValidValue", (obj == null ? "" : obj.makeCd));
				$("lineCd").value 		         	= obj == null ? "" : unescapeHTML2(obj.lineCd);
				$("lineCd").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.lineCd)));				
				$("sublineCd").value 		    	= obj == null ? "" : unescapeHTML2(obj.sublineCd);
				$("sublineCd").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.sublineCd)));
				$("seriesCd").value 				= obj == null ? "" : obj.seriesCd;
				$("sublineTypeCd").value 			= obj == null ? "" : obj.sublineTypeCd;
				$("deleteSw").value 	  			= obj == null ? "" : obj.deleteSw;
				$("txtCarCompany").value 			= obj == null ? "" : unescapeHTML2(obj.carCompany);
				$("txtCarCompany").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.carCompany)));
				$("txtMake").value 		   			= obj == null ? "" : unescapeHTML2(obj.make);
				$("txtMake").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.make)));
				$("txtEngineSeries").value 			= obj == null ? "" : unescapeHTML2(obj.engineSeries);
				$("txtEngineSeries").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.engineSeries)));								
				$("modelYear").value 			    = obj == null ? "" : obj.modelYear;
				$("txtLineCd").value   	  	        = obj == null ? "" : unescapeHTML2(obj.lineCd);
				$("txtLineCd").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.lineCd)));				
				$("txtSubline").value   	  	    = obj == null ? "" : unescapeHTML2(obj.sublineName);
				$("txtSubline").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.sublineName)));				
				$("txtSublineType").value   		= obj == null ? "" : unescapeHTML2(obj.sublineType);
				$("txtSublineType").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.sublineType)));
				$("txtDepreciationRate").value 		= obj == null ? "" : formatCurrency(unescapeHTML2(obj.rate));
				$("txtUserId").value 				= obj == null ? "" : obj.userId;
				$("txtLastUpdate").value 			= obj == null ? "" : obj.lastUpdate; 	
				obj == null ? $("btnAddMcDepRate").value = "Add" : $("btnAddMcDepRate").value = "Update";
				obj == null ? disableButton("btnDeleteMcDepRate") : enableButton("btnDeleteMcDepRate");
				obj == null ? disableButton("btnPerilsMcDepRate") : enableButton("btnPerilsMcDepRate");
				objMcDepRateMaintain = obj;	
			} catch(e){
				showErrorMessage("populateMcDrDetails", e);
			}				
		}		
	
		function displayValue() {	
 			$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT'); 		
			$("txtUserId").value = "${PARAMETERS['USER'].userId}";  
		}	
	
 	    //Rate Validation
 	    $("txtDepreciationRate").observe("change", function() {	
 	    	if ($("txtDepreciationRate").value > 100.00) {
 	    		customShowMessageBox("Invalid . Valid value should be from 0.00 to 100.00.", "E", "txtDepreciationRate");
 	    	}
 	    });
		
		//Car Company LOV
		$("searchCarCompany").observe("click", function(){
			clearMake();
			clearEngineSeries();
			showGIISS224CarCompany();
		});
		
		$("txtCarCompany").setAttribute("lastValidValue", "");
		
		$("txtCarCompany").observe("keyup", function(){
			clearMake();
			clearEngineSeries();
			$("txtCarCompany").value = $F("txtCarCompany").toUpperCase();
		});
		
		$("txtCarCompany").observe("change", function() {	
			clearMake();
			clearEngineSeries();
			if($F("txtCarCompany").trim() == "") {
				$("txtCarCompany").value = "";
				$("txtCarCompany").setAttribute("lastValidValue", "");
				$("carCompanyCd").value = "";
				$("carCompanyCd").setAttribute("lastValidValue", "");				
			} else { 
				if($F("txtCarCompany").trim() != "" && $F("txtCarCompany") != $("txtCarCompany").readAttribute("lastValidValue")) {
					showGIISS224CarCompany();
				}
			} 
		});				
		
		function showGIISS224CarCompany(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224CarCompany", 
					filterText : ($("txtCarCompany").readAttribute("lastValidValue").trim() != $F("txtCarCompany").trim() ? $F("txtCarCompany").trim() : ""),
					page : 1
				},
				title: "List of Car Company",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "carCompanyCd",
							title: "Car Company Code",
							width: '130px',
							filterOption: true
						},
						{
							id : "carCompany",
							title: "Car Company Name",
							width: '280px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtCarCompany").readAttribute("lastValidValue").trim() != $F("txtCarCompany").trim() ? $F("txtCarCompany").trim() : ""),
				onSelect: function(row) {
					$("txtCarCompany").value = unescapeHTML2(row.carCompany);
					$("txtCarCompany").setAttribute("lastValidValue", $("txtCarCompany").value);
					$("carCompanyCd").value = unescapeHTML2(row.carCompanyCd);
					$("carCompanyCd").setAttribute("lastValidValue", $("carCompanyCd").value);		
					$("txtMake").setAttribute("lastValidValue", "");
					$("makeCd").setAttribute("lastValidValue", "");					
					$("txtEngineSeries").setAttribute("lastValidValue", "");
					$("seriesCd").setAttribute("lastValidValue", "");									
				},
				onCancel: function (){
					$("txtCarCompany").value = $("txtCarCompany").readAttribute("lastValidValue");
					$("carCompanyCd").value = $("carCompanyCd").readAttribute("lastValidValue");
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");	
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");	
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");		
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtCarCompany").value = $("txtCarCompany").readAttribute("lastValidValue");
					$("carCompanyCd").value = $("carCompanyCd").readAttribute("lastValidValue");
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");	
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");	
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");		
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}		 
		
		//Make LOV
		$("searchMake").observe("click", function() {
			clearEngineSeries();
			if($("txtCarCompany").value == ""){
				customShowMessageBox("Please select Car Company first.", "E", "txtMake");
				$("txtMake").value = "";
			}else {
				showGIISS224Make();
			}		
		});
		
		$("txtMake").setAttribute("lastValidValue", "");
		
		$("txtMake").observe("keyup", function(){
			clearEngineSeries();
			$("txtMake").value = $F("txtMake").toUpperCase();
		});
		
		$("txtMake").observe("change", function() {
			clearEngineSeries();
			if($F("txtMake").trim() == "") {
				$("txtMake").value = "";
				$("txtMake").setAttribute("lastValidValue", "");
				$("makeCd").value = "";
				$("makeCd").setAttribute("lastValidValue", "");						
			} else { 
				if($F("txtMake").trim() != "" && $F("txtMake") != $("txtMake").readAttribute("lastValidValue")) {
					if($("txtCarCompany").value == ""){
						customShowMessageBox("Please select Car Company first.", "E", "txtMake");
						$("txtMake").value = "";
					}else {
						showGIISS224Make();
					}								
				}
			} 
		});		
		
		function clearMake(){
			$("txtMake").value = "";
			$("makeCd").value = "";				
		}	
			
		function showGIISS224Make(){ 
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224Make", 
					filterText : ($("txtMake").readAttribute("lastValidValue").trim() != $F("txtMake").trim() ? $F("txtMake").trim() : ""),
					page : 1,
					carCompanyCd : $("carCompanyCd").value
				},
				title: "List of Make",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "makeCd",
							title: "Make Code",
							width: '100px',
							filterOption: true
						},
						{
							id : "make",
							title: "Make Name",
							width: '280px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtMake").readAttribute("lastValidValue").trim() != $F("txtMake").trim() ? $F("txtMake").trim() : ""),
				onSelect: function(row) {
					$("txtMake").value = unescapeHTML2(row.make);
					$("txtMake").setAttribute("lastValidValue", $("txtMake").value);
					$("makeCd").value = unescapeHTML2(row.makeCd);
					$("makeCd").setAttribute("lastValidValue", $("makeCd").value);							
					$("txtEngineSeries").setAttribute("lastValidValue", "");
					$("seriesCd").setAttribute("lastValidValue", "");
				},
				onCancel: function (){
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");		
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					$("makeCd").value = $("makeCd").readAttribute("lastValidValue");
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");				
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}		 		
		
		//Engine Series LOV
		$("searchEngineSeries").observe("click", function() {
			if($("txtCarCompany").value == "" || $("txtMake").value == ""){
				customShowMessageBox("Please select Car Company and Make first.", "E", "txtEngineSeries");
				$("txtMake").value = "";
				$("txtEngineSeries").value = "";
			}else {
				showGIISS224EngineSeries();
			}		
		});
		
		$("txtEngineSeries").setAttribute("lastValidValue", "");
		
		$("txtEngineSeries").observe("keyup", function(){
			$("txtEngineSeries").value = $F("txtEngineSeries").toUpperCase();
		});
		
		$("txtEngineSeries").observe("change", function() {				
			if($F("txtEngineSeries").trim() == "") {
				$("txtEngineSeries").value = "";
				$("txtEngineSeries").setAttribute("lastValidValue", "");
				$("seriesCd").value = "";
				$("seriesCd").setAttribute("lastValidValue", "");				
			} else { 
				if($F("txtEngineSeries").trim() != "" && $F("txtEngineSeries") != $("txtEngineSeries").readAttribute("lastValidValue")) {
					if($("txtCarCompany").value == "" || $("txtMake").value == ""){
						customShowMessageBox("Please select Car Company and Make first.", "E", "txtEngineSeries");
						$("txtMake").value = "";
						$("txtEngineSeries").value = "";
					}else {
						showGIISS224EngineSeries();
					}							
				}
			} 
		});		
		
		function clearEngineSeries(){
			$("txtEngineSeries").value = "";
			$("seriesCd").value = "";				
		}
	
			
		function showGIISS224EngineSeries(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224EngineSeries", 
					filterText : ($("txtEngineSeries").readAttribute("lastValidValue").trim() != $F("txtEngineSeries").trim() ? $F("txtEngineSeries").trim() : ""),
					page : 1,
					carCompanyCd : $("carCompanyCd").value,
					makeCd : $("makeCd").value
				},
				title: "List of Engine",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "seriesCd",
							title: "Series Code",
							width: '100px',
							filterOption: true
						},
						{
							id : "engineSeries",
							title: "Engine Series",
							width: '280px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtEngineSeries").readAttribute("lastValidValue").trim() != $F("txtEngineSeries").trim() ? $F("txtEngineSeries").trim() : ""),
				onSelect: function(row) {
					$("txtEngineSeries").value = unescapeHTML2(row.engineSeries);
					$("txtEngineSeries").setAttribute("lastValidValue", $("txtEngineSeries").value);
					$("seriesCd").value = unescapeHTML2(row.seriesCd);
					$("seriesCd").setAttribute("lastValidValue", $("seriesCd").value);					
				},
				onCancel: function (){
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtEngineSeries").value = $("txtEngineSeries").readAttribute("lastValidValue");
					$("seriesCd").value = $("seriesCd").readAttribute("lastValidValue");
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}		
		
		//Line Code LOV
		$("searchLineCd").observe("click", function(){
			if ($("txtLineCd").value == "") {
				openLineCd();			
			} else {				
				validateMcPerilRec();

				if ($(perilRec).value == 'Y') {
					showConfirmBox("Confirmation", "Updating the Line will delete the perils for this record. Do you want to continue?", 
							       "Yes", "No", function(){ 
													deleteMcPerilRec();
													openLineCd();
											    }, "");
					return false;					
				} else {
					openLineCd();	
				}
			}
		});
		
		function openLineCd() {
			clearSubline();
			clearSublineType();
			showGIISS224LineCd();	
		}
		
		$("txtLineCd").setAttribute("lastValidValue", "");
		
		$("txtLineCd").observe("keyup", function(){
			clearSubline();
			clearSublineType();			
			$("txtLineCd").value = $F("txtLineCd").toUpperCase();
		});
		
		$("txtLineCd").observe("change", function() {	
			clearSubline();
			clearSublineType();			
			if($F("txtLineCd").trim() == "") {
				$("txtLineCd").value = "";
				$("txtLineCd").setAttribute("lastValidValue", "");			
				$("lineCd").value = "";
				$("lineCd").setAttribute("lastValidValue", "");						
			} else { 
				if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
					showGIISS224LineCd();
				}
			} 
		});				
		
		function showGIISS224LineCd(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224LineCd", 
					filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
					page : 1
				},
				title: "List of Line Code",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "lineCd",
							title: "Line Code",
							width: '100px',
							filterOption: true
						},
						{
							id : "lineName",
							title: "Line Name",
							width: '280px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", $("txtLineCd").value);	
					$("lineCd").value = unescapeHTML2(row.lineCd);
					$("lineCd").setAttribute("lastValidValue", $("lineCd").value);
					$("txtSubline").setAttribute("lastValidValue", "");
					$("sublineCd").setAttribute("lastValidValue", "");					
					$("txtSublineType").setAttribute("lastValidValue", "");
					$("sublineTypeCd").setAttribute("lastValidValue", "");					
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");	
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");					
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");	
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");				
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}		
		
		//Subline LOV
		$("searchSubline").observe("click", function() {
			clearSublineType();
			if($("txtLineCd").value == ""){
				customShowMessageBox("Please select Line first.", "E", "txtSubline");
				$("txtSubline").value = "";
			}else {
				showGIISS224Subline();
			}		
		});
		
		$("txtSubline").setAttribute("lastValidValue", "");
		
		$("txtSubline").observe("keyup", function(){
			clearSublineType();
			$("txtSubline").value = $F("txtSubline").toUpperCase();
		});
		
		$("txtSubline").observe("change", function() {		
			clearSublineType();
			if($F("txtSubline").trim() == "") {
				$("txtSubline").value = "";
				$("txtSubline").setAttribute("lastValidValue", "");
				$("sublineCd").value = "";
				$("sublineCd").setAttribute("lastValidValue", "");				
			} else { 
				if($F("txtSubline").trim() != "" && $F("txtSubline") != $("txtSubline").readAttribute("lastValidValue")) {
					if($("txtLineCd").value == ""){
						customShowMessageBox("Please select Line first.", "E", "txtSubline");
						$("txtSubline").value = "";
					}else {
						showGIISS224Subline();
					}							
				}
			} 
		});		
		
		function clearSubline(){
			$("txtSubline").value = "";
			$("sublineCd").value = "";	
			$("txtSublineType").value = "";	
			$("sublineTypeCd").value = "";				
		}
				
		function showGIISS224Subline(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224Subline", 
					filterText : ($("txtSubline").readAttribute("lastValidValue").trim() != $F("txtSubline").trim() ? $F("txtSubline").trim() : ""),
					page : 1,
					lineCd : $("lineCd").value
				},
				title: "List of Subline",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "sublineCd",
							title: "Subline Code",
							width: '120px',
							filterOption: true
						},
						{
							id : "sublineName",
							title: "Subline Name",
							width: '260px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtSubline").readAttribute("lastValidValue").trim() != $F("txtSubline").trim() ? $F("txtSubline").trim() : ""),
				onSelect: function(row) {
					$("txtSubline").value = unescapeHTML2(row.sublineName);
					$("txtSubline").setAttribute("lastValidValue", $("txtSubline").value);
					$("sublineCd").value = unescapeHTML2(row.sublineCd);
					$("sublineCd").setAttribute("lastValidValue", $("sublineCd").value);	
					$("txtSublineType").setAttribute("lastValidValue", "");
					$("sublineTypeCd").setAttribute("lastValidValue", "");
				},
				onCancel: function (){
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");					
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					$("sublineCd").value = $("sublineCd").readAttribute("lastValidValue");
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");						
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}					
		
		//Subline Type LOV
		$("searchSublineType").observe("click", function() {
			if($("txtSubline").value == ""){
				customShowMessageBox("Please select Subline first.", "E", "txtSublineType");
				$("txtSublineType").value = "";
			}else {
				showGIISS224SublineType();
			}		
		});
		
		$("txtSublineType").setAttribute("lastValidValue", "");
		
		$("txtSublineType").observe("keyup", function(){
			$("txtSublineType").value = $F("txtSublineType").toUpperCase();
		});
		
		$("txtSublineType").observe("change", function() {				
			if($F("txtSublineType").trim() == "") {
				$("txtSublineType").value = "";
				$("txtSublineType").setAttribute("lastValidValue", "");
				$("sublineTypeCd").value = "";
				$("sublineTypeCd").setAttribute("lastValidValue", "");				
			} else { 
				if($F("txtSublineType").trim() != "" && $F("txtSublineType") != $("txtSublineType").readAttribute("lastValidValue")) {
					if($("txtSubline").value == ""){
						customShowMessageBox("Please select Subline first.", "E", "txtSublineType");
						$("txtSublineType").value = "";
					}else {
						showGIISS224SublineType();
					}							
				}
			} 
		});		
		
		function clearSublineType(){
			$("txtSublineType").value = "";
			$("sublineTypeCd").value = "";				
		}
				
		function showGIISS224SublineType(){
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters: {
					action : "getGIISS224SublineType", 
					filterText : ($("txtSublineType").readAttribute("lastValidValue").trim() != $F("txtSublineType").trim() ? $F("txtSublineType").trim() : ""),
					page : 1,
					sublineCd : $("sublineCd").value
				},
				title: "List of Subline type",
				width: '395px',
				height: '386px',
				columnModel : [
						{
							id : "sublineTypeCd",
							title: "Subline Type Code",
							width: '120px',
							filterOption: true
						},
						{
							id : "sublineType",
							title: "Subline Type",
							width: '260px',
							filterOption: true
						}						
				],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineType").readAttribute("lastValidValue").trim() != $F("txtSublineType").trim() ? $F("txtSublineType").trim() : ""),
				onSelect: function(row) {
					$("txtSublineType").value = unescapeHTML2(row.sublineType);
					$("txtSublineType").setAttribute("lastValidValue", $("txtSublineType").value);
					$("sublineTypeCd").value = unescapeHTML2(row.sublineTypeCd);
					$("sublineTypeCd").setAttribute("lastValidValue", $("sublineTypeCd").value);					
				},
				onCancel: function (){
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineType").value = $("txtSublineType").readAttribute("lastValidValue");
					$("sublineTypeCd").value = $("sublineTypeCd").readAttribute("lastValidValue");
				},
				onShow : function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			  });
		}			
		
		//Add-Update Function
		enableButton("btnAddMcDepRate");
		
 		$("btnAddMcDepRate").observe("click", function(){
 			validateAddMcDepRate();
		});		
		
		function addMcDepRate(){
			delSw = "N";
			try {
				rowObj = setMcDrObj($("btnAddMcDepRate").value);
				if(checkAllRequiredFieldsInDiv("mcDepRateMaintenanceInfo")){
					unsavedStatus = 1;
					objMcDrMain.push(rowObj);
						if($("btnAddMcDepRate").value == "Add"){
							mcDepRateListTableGrid.addBottomRow(rowObj);
						} else {
							mcDepRateListTableGrid.updateVisibleRowOnly(rowObj, rowIndex, false);
						}				
					mcDepRateListTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
					saveMcDr();
				}
			} catch(e){
				showErrorMessage("addMcDepRate", e);
			}				
		}			
		
		//Validate Entry
		function validateAddMcDepRate() {
			rowObj  = setMcDrObj($("btnAddMcDepRate").value);
			new Ajax.Request(contextPath + "/GIISMcDepreciationRateController", {
				method : "POST",
				parameters : {
					action : 		 "validateAddMcDepRate",
					id:				 rowObj.id,
					carCompanyCd :   rowObj.carCompanyCd,
					makeCd: 		 rowObj.makeCd,
					seriesCd:		 rowObj.seriesCd,
					modelYear:		 rowObj.modelYear,
					lineCd:	         rowObj.lineCd,
					sublineCd:	     rowObj.sublineCd,
					sublineTypeCd:	 rowObj.sublineTypeCd
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == '1') {
						customShowMessageBox("Depreciation set-up already exists.", imgMessage.INFO, "btnAddMcDepRate");
					} else {
						addMcDepRate();
					}
				}
			});
		}			
		
		//Validate Peril Record
		function validateMcPerilRec() {
			rowObj  = setMcDrObj($("txtLineCd").value);
			new Ajax.Request(contextPath + "/GIISMcDepreciationRateController", {
				method : "POST",
				parameters : {
					action : 		 "validateMcPerilRec",
					id:				 rowObj.id
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == '1') {
						$(perilRec).value = 'Y';
					} else {
						$(perilRec).value = 'N';
					}
				}
			});
		}			
		
		//Delete all Peril Record
		function deleteMcPerilRec() {
			rowObj  = setMcDrObj($("txtLineCd").value);
			new Ajax.Request(contextPath + "/GIISMcDepreciationRateController", {
				method : "POST",
				parameters : {
					action : 		 "deleteMcPerilRec",
					id:				 rowObj.id
				},
				asynchronous : false,
				evalScripts : true,
			});
		}				
		
		//Delete Function
 		$("btnDeleteMcDepRate").observe("click", function(){
			showConfirmBox("Confirmation", "Are you sure you want to delete this record?", 
					"Yes", "No", function(){deleteMcDr();saveMcDr();}, "");
			return false;
		});		
		
 		function deleteMcDr(){
 			delSw = "Y";
			delObj = setMcDrObj($("btnDeleteMcDepRate").value);
			objMcDrMain.splice(row, 1, delObj);			
			mcDepRateListTableGrid.updateVisibleRowOnly(delObj, row);			
			mcDepRateListTableGrid.deleteRows(rowObj);			
			mcDepRateListTableGrid.onRemoveRowFocus();
			changeTag = 1;
			changeCounter++;
		} 		
 		
		//Peril Overlay
 		$("btnPerilsMcDepRate").observe("click", function(){
 			showOverlay("getGIISMcDrPeril", "MC Peril Depreciation Rate", "showMcDrPerilOverlay");
		});				
		
 		function showOverlay(action, title, error){
 			try{
 				overlayMcDr = Overlay.show(contextPath+"/GIISMcDepreciationRateController?ajax=1"
 										+"&id="+encodeURIComponent(unescapeHTML2($("id").value))
 										+"&lineCd="+encodeURIComponent(unescapeHTML2($("txtLineCd").value)), {
 					urlContent: true,
 					urlParameters: {action : action},
 				    title: title,
 				    height: 470,
 				    width: 500,
 				    draggable: true
 				});
 			}catch(e){
 				showErrorMessage(error, e);
 			}		
 		}		
		
		//Save Function
 		function saveMcDr() {
 			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objMcDrMain);
			objParams.delRows = getDeletedJSONObjects(objMcDrMain);
			new Ajax.Request(contextPath+"/GIISMcDepreciationRateController?action=saveMcDr",{ 
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
							objMcDepRateMaintain.refresh();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
			showMcDepreciationRateMaintenance();
		}		
		
 		observeReloadForm("reloadForm",showMcDepreciationRateMaintenance);	 		
 		
		observeCancelForm("mcDepreciationRatesMainExit", null, function(){
			mcDepRateListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
		}); 
 		
	}catch (e) {
		 showErrorMessage("Motor Car Table Grid", e); 
	}
</script>