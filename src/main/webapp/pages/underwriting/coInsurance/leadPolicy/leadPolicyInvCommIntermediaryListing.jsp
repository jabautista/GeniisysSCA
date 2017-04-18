<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div class="sectionDiv" style="margin: 15px 0; border: none;">
	<div id="lpIntrmdryListingDiv" style="border: none; padding-left: 75px;" >
		<div id="lpIntrmdryTableGridDiv" style="height: 105px; width: 740px;"></div>
	</div>
</div>
<div id="lpInvCommPerilDiv" class="sectionDiv"style="border: none;"></div>

<script>
	var objLpIntrmdry = new Object();
	objLpIntrmdry.objLpIntrmdryTableGrid = JSON.parse('${leadPolicyIntrmdryTableGrid}'.replace(/\\/g, '\\\\'));
	objLpIntrmdry.objLpIntrmdryListing = objLpIntrmdry.objLpIntrmdryTableGrid.rows || null;
	
	var lpIntrmdryTableModel = {
		url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyIntrmdryListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd")),
		options:{
			title: '',
			width: '730px',
			onCellFocus: function (element, value, x, y, id) {
				var invCommIntrmdry = objLpIntrmdry.objLpIntrmdryListing;
				populateLeadPolicyCommInvFieldValues(invCommIntrmdry[y]);
				populateLeadPolicyCommInvPerilNameFields(null);
				showTableGridRowsPerItemNoAndIntrmdryNo(lpCommInvPerilTableGrid,invCommIntrmdry[y]);
				showTableGridRowsPerItemNoAndIntrmdryNo(lpCommInvPerilTableGrid2,invCommIntrmdry[y]);
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				populateLeadPolicyCommInvFieldValues(null);
				populateLeadPolicyCommInvPerilNameFields(null);
				hideAllTableGridRows(lpCommInvPerilTableGrid);
				hideAllTableGridRows(lpCommInvPerilTableGrid2);
			}
		},
		columnModel: [
		    { 	id: 'recordStatus',
			  	title: '',
			  	width: '0',
			  	visible: false,
			  	editor: 'checkbox'
		    },
		    { 	id: 'divCtrId',
			  	width: '0',
			  	visible: false
		    },
		    { 	id: 'itemGrp',
			  	width: '0',
			  	visible: false
			},
			{	id: 'intermediaryNo',
			    title: 'Intm No.',
			    sortable: false,
				width: '100px',
				visible: true
			},
			{	id: 'intermediaryName',
			    title: 'Intermediary Name',
			    sortable: false,
				width: '257px',
				visible: true
			},
			{	id: 'parentIntermediaryNo',
			    title: 'Parent Intm No.',
			    sortable: false,
				width: '100px',
				visible: true
			},
			{	id: 'parentIntermediaryName',
			    title: 'Parent Intermediary Name',
			    sortable: false,
				width: '257px',
				visible: true
			},
		],
		requiredColumns: 'itemGrp',
		rows: objLpIntrmdry.objLpIntrmdryListing,
		hideRowsOnLoad: true
	};
	
	lpIntrmdryTableGrid = new MyTableGrid(lpIntrmdryTableModel);
	lpIntrmdryTableGrid.pager = "";
	lpIntrmdryTableGrid.render('lpIntrmdryTableGridDiv');

	loadLeadPolicyCommInvPerilListing();

	function showTableGridRowsPerItemNoAndIntrmdryNo(tableGrid, objArray){
		var id = tableGrid._mtgId;
		var rows = tableGrid.rows;
		var x = tableGrid.getColumnIndex('itemGrp');
		var intmNo = tableGrid.getColumnIndex('intrmdryNo');
		var firstRowId = "";

		var ctr = 0;
		for (y = 0; y < rows.length; y++) {
			var itemGroup = tableGrid.getValueAt(x, y);
			var intmNum = tableGrid.getValueAt(intmNo, y);
			$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
			$('mtgRow'+id+'_'+y).hide();
			if(objArray.itemGrp == itemGroup && objArray.intermediaryNo == intmNum){
				$('mtgRow'+id+'_'+y).show();
				ctr++;
				if(ctr == 1){
					firstRowId = 'mtgC'+id+'_'+x+','+ y;
				}
			}
		}
		if(firstRowId != "" && $(firstRowId) != null){
			fireEvent($(firstRowId), 'click');
		}
		removeTableGridCellClassSelectedRow(tableGrid);
		tableGrid.scrollTop = tableGrid.bodyDiv.scrollTop = 0;
	}

	
		
</script>