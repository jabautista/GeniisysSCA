<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="b480ListingTableGridSectionDiv" style="height: 210px; margin-left: 70px; margin-top: 20px;">
	<div id="b480ListingTableGrid"changeTagAttr="true"></div>
</div>

<script>
	
	var selectedB480 = null;
	var selectedB480Row = new Object();
	var mtgId = null;
	var selectedIndex = -1;
	objItmPerl .b480ListTableGrid = JSON.parse('${b480Dtls}'.replace(/\\/g, '\\\\'));
	objItmPerl .b480= objItmPerl .b480ListTableGrid.rows || [];
	
	try {
		var b480ListingTable = {
			url: contextPath+"/GIEXItmperilController?action=getGIEXS007B480Info&refresh=1&mode=1&policyId="+$F("txtB240PolicyId"),
			id: 1, //Added by Jerome Bautista 10.01.2015 SR 18536
			options: {
				width: '780px',
				height: '180px',
				onCellFocus: function(element, value, x, y, id) {
					if($("changePerilTag").value == 'Y'){ //added by joanne 02.18.14, to check if perils are updated
						showMessageBox("Please save changes first.");
					}else{
						mtgId = b480Grid._mtgId;
						selectedIndex = y;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
							//console.log(JSON.stringify(b480Grid.geniisysRows[y]));
							selectedB480Row = b480Grid.geniisysRows[y];
							objItmPerl.b480Row = selectedB480Row;
							setB480Info(selectedB480Row);
							b490Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B490Info&refresh=1&mode=1&policyId="+selectedB480Row.policyId+
									"&itemNo="+selectedB480Row.itemNo;
							b490Grid._refreshList();
							removeItemInfoFocus();
						}	
					}
				},
				onRemoveRowFocus : function(){
					if($("changePerilTag").value == 'Y'){ //added by joanne 02.18.14, to check if perils are updated
						showMessageBox("Please save changes first.");
					}else{
						objItmPerl.b480Row = null;
						clearB490Dtls();
						setB480Info(null);
						removeItemInfoFocus();
					}
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            onRefresh: function() {
		            	if(selectedIndex > -1){
		            		clearB490Dtls();
		            	}
		            	selectedIndex = -1;
		            },
		            onFilter: function() {
		            	if(selectedIndex > -1){
		            		clearB490Dtls();
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
							    //editor: 'checkbox' //Commented out by Jerome Bautista 10.01.2015 SR 18536
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
								//editable: false, //Commented out by Jerome Bautista 10.01.2015 SR 18536
								sortable: false,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
								}
							}, 
							{
								id: 'nbtItemTitle',
								title: 'Item Title',
								width: '300',
								//editable: false, //Commented out by Jerome Bautista 10.01.2015 SR 18536
								sortable: false,
								filterOption: true
							},
							{
								id: 'nbtTsiAmt',
								title: 'TSI Amount',
								width: '180',
								titleAlign: 'right',
								align: 'right',
								sortable: false,
								geniisysClass: 'money',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
							}, 
							{
								id: 'nbtPremAmt',
								title: 'Premium Amount',
								width: '180',
								titleAlign: 'right',
								align: 'right',
								sortable: false,
								geniisysClass: 'money',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
							}
						],
			resetChangeTag: true,
			rows: objItmPerl .b480
		};
		b480Grid = new MyTableGrid(b480ListingTable);
		objItmPerl.b480Grid = b480Grid;
		b480Grid.pager = objItmPerl .b480ListTableGrid;
		b480Grid.render('b480ListingTableGrid');
	}catch(e) {
		showErrorMessage("b480Grid", e);
	}
	
	function setB480Info(obj) {
		try {
			$("txtB480ItemNo").value					= obj == null ? null :obj.itemNo;
			$("txtB480ItemTitle").value				= obj == null ? null :unescapeHTML2(obj.nbtItemTitle);
			$("txtB480CurrencyRt").value			= obj == null ? null :unescapeHTML2(obj.currencyRt);
			$("txtB480AnnPremAmt").value		= obj == null ? null :unescapeHTML2(obj.annPremAmt);
			$("txtB480AnnTsiAmt").value				= obj == null ? null :unescapeHTML2(obj.annTsiAmt);
			$("txtB480LineCd").value						= obj == null ? null :unescapeHTML2(obj.lineCd);
			$("txtB480SublineCd").value				= obj == null ? null :unescapeHTML2(obj.sublineCd);
		} catch(e) {
			showErrorMessage("setB480Info", e);
		}
	}
	
	function removeItemInfoFocus(){
		b480Grid.keys.removeFocus(b480Grid.keys._nCurrentFocus, true);
		b480Grid.keys.releaseKeys();
	}
	
	function clearB490Dtls(){
		b490Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B490Info&refresh=1&mode=1&policyId=&itemNo=";
		b490Grid._refreshList();
	}

</script>