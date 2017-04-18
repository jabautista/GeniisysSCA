<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perilStatusGrid" style="position: relative; height: 331px; margin: auto; margin-top: 10px; margin-bottom: 10px; width: 800px;"> </div>

<script type="text/javascript">
try{
	objCLMItem.objPerilStatusTableGrid = JSON.parse('${giclItemPeril}'.replace(/\\/g, '\\\\'));
	objCLMItem.objGiclItemPerilStatus = objCLMItem.objPerilStatusTableGrid.rows;
	objCLMItem.objGiclItemPerilStatus.length > 5 ? $("perilStatusGrid").setStyle("height: 331px") :$("perilStatusGrid").setStyle("height: 206px");
	
	perilStatusModel = {
		url: contextPath+"/GICLItemPerilController?action=getItemPerilGrid&claimId="+objCLMGlobal.claimId+"&itemNo="+$F("txtItemNo")+"&lineCd="+objCLMGlobal.lineCd,
		options : {
			hideColumnChildTitle: true,
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				objCLMItem.selPerilIndex = y;
				perilStatusGrid.releaseKeys();
			},
			onCellBlur : function(element, value, x, y, id) {
				perilStatusGrid.releaseKeys();
			},
			onRemoveRowFocus: function() {
				perilStatusGrid.releaseKeys();
			}
		},
		columnModel : [
			{ 								// this column will only be used for deletion
				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			   	title: '&#160;D',
			   	altTitle: 'Delete?',
			   	titleAlign: 'center',
			   	width: 19,
			   	sortable: false,
			   	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
			   	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
			   	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
			   	editor: 'checkbox',
			   	hideSelectAllBox: true,
			   	visible: false 
			},
			{
			   	id: 'divCtrId',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'claimId',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'itemNo',
			   	width: '0',
			   	visible: false 
			},
		 	{
				id: 'userId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'lastUpdate',
			  	width: '0',
			  	visible: false 
		 	},
			{
			   	id: 'cpiRecNo',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'cpiBranchCd',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'motshopTag',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'lineCd',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'closeDate',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'closeFlag',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'closeFlag2',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'closeDate2',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'aggregateSw',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'groupedItemNo',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'allowTsiAmt',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'baseAmt',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'noOfDays',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'allowNoOfDays',
			   	width: '0',
			   	visible: false 
			}, 
	        {
	            id: 'histIndicator',
	            title: '&#160;&#160;R',
	            altTitle: 'With Reserve',
	            width: 23,
	            maxlength: 1,
	            visible: false,
	            sortable:	false,
	            defaultValue: false,	
	            otherValue: false,
	            editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "U";
	            		}else{
							return "D";	
	            		}	
	            	}
	            	
	            })
	        },
		   	{
				id: 'perilCd dspPerilName',
				title: 'Peril',
				width : 250,
				children : [
		            {   id : 'perilCd',
		                width : 50,
		                editable: false 		
		            },
		            {   id : 'dspPerilName', 
		                width : 200,
		                editable: false
		            }
				]
			},
		   	{	id: 'lossCatCd dspLossCatDes',
				title: 'Loss Category',
				width : 245,
				children : [
		            {
		                id : 'lossCatCd',
		                width : 50,
		                editable: false 		
		            },
		            {
		                id : 'dspLossCatDes', 
		                width : 195,
		                editable: false
		            }
				]
			},
			{  	id: 'annTsiAmt',
			   	title: 'Total Sum Insured',
			   	type : 'number',
			  	width: '0',
			  	visible: false,
			  	geniisysClass : 'money'
			},
			{  	id: 'nbtCloseFlag',
				title: 'Loss Status',
			   	width: 100
			},
			{  	id: 'nbtCloseFlag2',
				title: 'Expense Status',
			   	width: 105
			}
		],
		resetChangeTag: true,
		requiredColumns: '',
		rows : objCLMItem.objGiclItemPerilStatus,
		id : 20
	};   
	
	perilStatusGrid = new MyTableGrid(perilStatusModel);
	perilStatusGrid.pager = objCLMItem.objPerilStatusTableGrid;
	perilStatusGrid._mtgId = 20;
	perilStatusGrid.render('perilStatusGrid');
	
	$("groPerilStatus").show();
	$("loadPerilStatus").hide();
}catch(e){
	showErrorMessage("Claims item peril status info", e);		
}
</script>