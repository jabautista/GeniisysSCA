<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div  id="motorCarListingSubSectionDiv" class= "subSectionDiv" style="height: 245px; top: 10px; bottom: 10px;" >
	<div id="motorCarListingTable" style="position:relative; left:65px; top:10px; bottom: 10px;" ></div>
	<input type="hidden" id="carCompanyCd" name="carCompanyCd"/>
	<input type="hidden" id="makeCd" name="makeCd"/>
	<input type="hidden" id="seriesCd" name="seriesCd"/>
</div>

<script type="text/javascript">
 
	setDocumentTitle("Fair Market Value Maintenance");
	setModuleId("GIISS223");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	objMotorCarMaintain = null;

	try{
		var row = 0;
		var objFmvMain = [];
		var objMotorCar = new Object();
		objMotorCar.objMotorCarListing = JSON.parse('${motorCarListing}'.replace(/\\/g, '\\\\'));
		objMotorCar.objMotorCarMaintenance = objMotorCar.objMotorCarListing.rows || [];
	
		var motorCarListTG = {
				url: contextPath+"/GIISMcFairMarketValueController?action=showSourceMcFairMarketValueMaintenance",
				options: {
					width: '790px',
					height: '200px',
				onCellFocus: function(element, value, x, y, id){
					row = y;
					objMotorCarMaintain = motorCarListTableGrid.geniisysRows[y];
					fmvListTableGrid.url = contextPath+"/GIISMcFairMarketValueController?action=showMcFairMarketValueMaintenance"
			    										+"&carCompanyCd="+objMotorCarMaintain.carCompanyCd
			    										+"&makeCd="+objMotorCarMaintain.makeCd
			    										+"&seriesCd="+objMotorCarMaintain.seriesCd;
					clearForm();
					displayValue();
					enableForm();			
				},
				onRemoveRowFocus: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					refreshFmv();
    					displayValue();
    					disableForm();		    					
                	}
            	},
           		beforeSort: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		clearForm();
                		displayValue();	
                		refreshFmvNull();
                	}
           	 	},
            	onSort: function(){
					clearForm(); 
					displayValue();
					refreshFmvNull();
					disableForm();					
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
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					refreshFmv();
    					displayValue();
    					disableForm();		
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
    						refreshFmv();
    						displayValue();
	    					disableForm();		
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
					id: 'carCompany',
			    	title: 'Car Company',
				    width: '215px',
				    visible: true,
				    filterOption: true,
			    	sortable:true
				},
		    	{   
					id: 'carCompanyCd',		
					width: '0',
					visible: false
				},				
				{	
					id: 'make',
					title: 'Make',
					width: '270px',
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
					id: 'engineSeries',
					title: 'Engine Series',
					width: '270px',
					visible: true,
					filterOption: true,
					sortable:true
				},
		    	{   
					id: 'seriesCd',		
					width: '0',
					visible: false
				}
			],
			rows: objMotorCar.objMotorCarMaintenance
		};
		motorCarListTableGrid = new MyTableGrid(motorCarListTG);
		motorCarListTableGrid.pager = objMotorCar.objMotorCarListing;
		motorCarListTableGrid.render('motorCarListingTable');
		motorCarListTableGrid.afterRender = function(){
			objFmvMain = motorCarListTableGrid.geniisysRows;
			changeTag = 0;
		};
	
		function clearForm() {
 			$("carCompanyCd").value = null;
		 	$("makeCd").value = null;
     		$("seriesCd").value = null;
			$("txtModelYear").value = null;
		 	$("txtHistNo").value = null;
	 		$("txtFmvValueMin").value = null;
		 	$("txtFmvValueMax").value = null;
		 	$("txtFmvValue").value = null;
	 		$("txtEffDate").value = null;
	 		fmvListTableGrid.refresh();
			motorCarListTableGrid.keys.releaseKeys();					
		}
	
		function enableForm() {
 			enableInputField("txtModelYear");
 			enableSearch("searchModelYear");
			enableInputField("txtFmvValueMin");
			enableInputField("txtFmvValueMax");
			enableInputField("txtFmvValue");
			enableDate("hrefEffDate");
	   		enableButton("btnAddFairMarketValue");
			$(mtgRefreshBtn2).removeClassName("disabled"); 
			$(mtgRefreshBtn2).addClassName("refreshbutton");	  
			$(mtgFilterBtn2).removeClassName("disabled"); 
			$(mtgFilterBtn2).addClassName("filterbutton");	  	
		}
	
		function disableForm() {
			disableDate("hrefEffDate");
			disableSearch("searchModelYear");
 			disableInputField("txtModelYear");
			disableInputField("txtFmvValueMin");
			disableInputField("txtFmvValueMax");
			disableInputField("txtFmvValue");		
	   		disableButton("btnAddFairMarketValue");	 	
			$(mtgRefreshBtn2).removeClassName("refreshbutton"); 
			$(mtgRefreshBtn2).addClassName("disabled");	   	
			$(mtgFilterBtn2).removeClassName("filterbutton"); 
			$(mtgFilterBtn2).addClassName("disabled");	  			
		}
	
		function displayValue() {
			$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
			$("txtUserId").value = "${PARAMETERS['USER'].userId}"; 
		}	
	
 		function refreshFmv() {
 			fmvListTableGrid.url = contextPath+"/GIISMcFairMarketValueController?action=showMcFairMarketValueMaintenance";
 			fmvListTableGrid._refreshList();
		} 
 		
 		function refreshFmvNull() {
			fmvListTableGrid.url = contextPath+"/GIISMcFairMarketValueController?action=showMcFairMarketValueMaintenance"	
		    +"&carCompanyCd="+""
			+"&makeCd="+""
			+"&seriesCd="+"";
 		}

	}catch (e) {
		 showErrorMessage("Motor Car Table Grid", e); 
	}
</script>