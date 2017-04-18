<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="b480GrpListingTableGridSectionDiv" style="height: 210px; margin-left: 70px; margin-top: 20px;">
	<div id="b480GrpListingTableGrid"changeTagAttr="true"></div>
</div>

<script>
	var selectedB480Grp = null;
	var selectedB480GrpRow = new Object();
	var mtgId = null;
	var selectedIndex = -1;
	objItmPerlGrp .b480GrpListTableGrid = JSON.parse('${b480GrpDtls}'.replace(/\\/g, '\\\\'));
	objItmPerlGrp .b480Grp= objItmPerlGrp .b480GrpListTableGrid.rows || [];
	
	try {
		var b480GrpListingTable = {
			url: contextPath+"/GIEXItmperilGroupedController?action=getGIEXS007B480GrpInfo&refresh=1&mode=1&policyId="+$F("txtB240PolicyId"),
			options: {
				width: '780px',
				height: '180px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = b480GrpGrid._mtgId;
					selectedIndex = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedB480GrpRow = b480GrpGrid.geniisysRows[y];
						objItmPerl.b480Row = selectedB480GrpRow;
						setB480GrpInfo(selectedB480GrpRow);
						b490GrpGrid.url = contextPath + "/GIEXItmperilGroupedController?action=getGIEXS007B490GrpInfo&refresh=1&mode=1&policyId="+selectedB480GrpRow.policyId+
								"&itemNo="+selectedB480GrpRow.itemNo+"&groupedItemNo="+selectedB480GrpRow.groupedItemNo;
						b490GrpGrid._refreshList();
						removeItemInfoFocus();
					}
				},
				onRemoveRowFocus : function(){
					objItmPerlGrp.b480GrpRow = null;
                    objItmPerl.b480Row = null; //Added by Jerome Bautista 12.04.2015 SR 21016
					clearB490GrpDtls();
					setB480GrpInfo(null);
					removeItemInfoFocus();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            onRefresh: function() {
		            	if(selectedIndex > -1){
		            		clearB490GrpDtls();
		            	}
		            	selectedIndex = -1;
		            },
		            onFilter: function() {
		            	if(selectedIndex > -1){
		            		clearB490GrpDtls();
		            	}
		            	selectedIndex = -1;
		            }
				}
			},
			columnModel: [
							{   
								id: 'recordStatus',
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
								id: 'itemNo',
								title: 'Item No.',
								width: '106',
								titleAlign: 'right',
								align: 'right',
								filterOption: true,
								filterOptionType: 'number',
								editable: false,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
								}
							}, 
							{
								id: 'nbtItemTitle',
								title: 'Item Title',
								width: '300',
								editable: false,
								filterOption: true
							},
							{
								id: 'groupedItemNo',
								title: 'Enrollee No.',
								width: '106',
								titleAlign: 'right',
								align: 'right',
								filterOption: true,
								filterOptionType: 'number',
								editable: false,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
								}
							}, 
							{
								id: 'nbtGroupedItemTitle',
								title: 'Enrollee Title',
								width: '300',
								editable: false,
								filterOption: true
							},
							{
								id: 'nbtTsiAmt',
								title: 'TSI Amount',
								width: '180',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false
							}, 
							{
								id: 'nbtPremAmt',
								title: 'Premium Amount',
								width: '180',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false
							}
						],
			resetChangeTag: true,
			rows: objItmPerlGrp .b480Grp
		};
		b480GrpGrid = new MyTableGrid(b480GrpListingTable);
		objItmPerlGrp.b480GrpGrid = b480GrpGrid;
		b480GrpGrid.pager = objItmPerlGrp .b480GrpListTableGrid;
		b480GrpGrid.render('b480GrpListingTableGrid');
	}catch(e) {
		showErrorMessage("b480GrpGrid", e);
	}
	
	function removeItemInfoFocus(){
		b480GrpGrid.keys.removeFocus(b480GrpGrid.keys._nCurrentFocus, true);
		b480GrpGrid.keys.releaseKeys();
	}
	
	function clearB490GrpDtls(){
		b490GrpGrid.url = contextPath + "/GIEXItmperilGroupedController?action=getGIEXS007B490GrpInfo&refresh=1&mode=1&policyId=";
		b490GrpGrid._refreshList();
	}
	
	function setB480GrpInfo(obj) {
		try {
			$("txtB480GrpItemNo").value						= obj == null ? null :obj.itemNo;
			$("txtB480GrpItemTitle").value						= obj == null ? null :unescapeHTML2(obj.nbtItemTitle);
			$("txtB480GrpGroupedItemNo").value		= obj == null ? null :obj.groupedItemNo;
			$("txtB480GrpGroupedItemTitle").value		= obj == null ? null :unescapeHTML2(obj.nbtGroupedItemTitle);
			$("txtB480GrpAnnTsiAmt").value					= obj == null ? null :unescapeHTML2(obj.nbtTsiAmt);
			$("txtB480GrpAnnPremAmt").value				= obj == null ? null :unescapeHTML2(obj.nbtPremAmt);
			$("txtB480GrpLineCd").value							= obj == null ? null :unescapeHTML2(obj.lineCd);
		} catch(e) {
			showErrorMessage("setB480GrpInfo", e);
		}
	}

</script>