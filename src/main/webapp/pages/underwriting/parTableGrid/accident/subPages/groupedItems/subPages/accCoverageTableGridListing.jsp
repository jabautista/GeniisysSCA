<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="grpItemsCoverageTable" name="grpItemsCoverageTable" style="width : 100%;">
	<div id="grpItemsCoverageTableGridSectionDiv" class="">
		<div id="grpItemsCoverageTableGridDiv" style="padding: 10px;">
			<div id="grpItemsCoverageTableGrid" style="height: 198px; width: 860px;"></div>
		</div>
	</div>	
</div>
<input id="daysDuration" value="${days}" type="hidden"/>
<script type="text/javascript">
try{
	var objItmperlGrouped = JSON.parse('${accItmperlGrouped}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
	var tbItmperlGrouped = {
		url : contextPath + "/GIPIWItmperlGroupedController?action=getItmperlGroupedTableGrid&parId=" + parId + 
			"&itemNo=" + $F("itemNo") + "&groupedItemNo=" + $F("groupedItemNo") + "&refresh=1",
		options : {
			width : '855px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgItmperlGrouped.geniisysRows[y];
				
				tbgItmperlGrouped.keys.releaseKeys();
				setItmperlGroupedFormTG(objSelected);				
			},
			onRemoveRowFocus : function(){
				setItmperlGroupedFormTG(null);
				tbgItmperlGrouped.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWItmperlGrouped).length > 0 || getDeletedJSONObjects(objGIPIWItmperlGrouped).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				//$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objGIPIWItmperlGrouped = objItmperlGrouped.gipiWItmperlGrouped.slice(0);
				setItmperlGroupedFormTG(null);
			},
			toolbar : {
				elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			}
		},
		columnModel : [
			{
				id : 'recordStatus',
				width : '20px',
				editor : 'checkbox',
				visible : false
			},
			{
				id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{
				id : 'parId',
				width : '0px',
				visible : false
			},
			{
				id : 'itemNo',
				width : '0px',
				visible : false
			},
			{
				id : 'groupedItemNo',
				width : '0px',
				visible : false
			},
			{
				id : 'bascPerlCd',
				width : '0px',
				visible : false
			},
			{
				id : 'groupedItemTitle',
				width : '165px',
				title : 'Enrollee Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'perilName',
				width : '165px',
				title : 'Peril Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'premRt',
				width : '80px',
				title : 'Rate',
				type : 'number',
				geniisysClass : 'rate',
				sortable : true
			},
			{
				id : 'tsiAmt',
				width : '100px',
				title : 'TSI Amt',
				type : 'number',
				geniisysClass : 'money',
				sortable : true
			},
			{
				id : 'premAmt',
				width : '100px',
				title : 'Prem Amt',
				type : 'number',
				geniisysClass : 'money',
				sortable : true
			},
			{
				id : 'noOfDays',
				width : '70px',
				type : 'number',
				title : 'No. of Days',
				sortable : true
			},
			{
				id : 'baseAmt',
				width : '100px',
				type : 'number',
				title : 'Base Amt',
				geniisysClass : 'money',
				sortable : true
			},
			{
				id : 'aggregateSw',
				title: '&#160;&#160;A',
				width : '23px',
				align : 'center',
				titleAlign : 'center',
				//defaultValue: "N",
				defaultValue: false,
			  	otherValue: false,				  	
			  	editable: false,
			  	sortable : false,
			  	editor: new MyTableGrid.CellCheckbox({					  	
					getValueOf: function(value){		            		
						//return value == "Y" ? true : false;		
						if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}
	            	}})	
			},				
		               ],
		rows : objItmperlGrouped.rows,
		id : 12
	};
	
	tbgItmperlGrouped = new MyTableGrid(tbItmperlGrouped);
	tbgItmperlGrouped.pager = objItmperlGrouped;
	tbgItmperlGrouped._mtgId = 12;
	tbgItmperlGrouped.render('grpItemsCoverageTableGrid');
	tbgItmperlGrouped.afterRender = function(){
		//objGIPIWItmperlGrouped = objItmperlGrouped.gipiWItmperlGrouped.slice(0);	
		//objItemTempStorage.objGIPIWItmperlGrouped = objItmperlGrouped.gipiWItmperlGrouped.slice(0);
		
		setItmperlGroupedFormTG(null);
		tbgItmperlGrouped.keys.releaseKeys();
	};
	
}catch(e){
	showErrorMessage("Accident Grouped Items Coverage Listing", e);
}
</script>