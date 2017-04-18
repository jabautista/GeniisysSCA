<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="packSubPolicyListingTableGridSectionDiv" style="height: 210px; margin-left: 70px; margin-top: 20px;">
	<div id="packSubPolicyListingTableGrid"changeTagAttr="true"></div>
</div>

<script>
	
	var selectedpackSubPolicy = null;
	var selectedpackSubPolicyRow = new Object();
	var mtgId = null;
	var selectedIndex = -1;
	objItmPerl .packSubPolicyListTableGrid = JSON.parse('${packSubPolicyList}'.replace(/\\/g, '\\\\'));
	objItmPerl .packSubPolicy= objItmPerl .packSubPolicyListTableGrid.rows || [];
	
	try {
		var packSubPolicyListingTable = { 
			url: contextPath+"/GIEXItmperilController?action=getPackSubPolicies&refresh=1&mode=1&packPolicyId="+$F("txtB240PackPolicyId")+
					"&summarySw="+$F("txtSummarySw"), //joanne 02.03.14
			id: 3, // bonok :: 12.2.2015 :: UCPB SR 21015
			options: {
				width: '780px',
				height: '180px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = packSubPolicyGrid._mtgId;
					selectedIndex = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedpackSubPolicyRow = packSubPolicyGrid.geniisysRows[y];
						objItmPerl.packSubPolicyRow = selectedpackSubPolicyRow;
						setpackSubPolicyInfo(selectedpackSubPolicyRow);
						b480Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B480Info&refresh=1&mode=1&policyId="+selectedpackSubPolicyRow.policyId;
						b480Grid._refreshList();
						removeItemInfoFocus3();
						clearB490Dtls2();
						setButtons(selectedpackSubPolicyRow.buttonSw);
					}
				},
				onRemoveRowFocus : function(){
					objItmPerl.packSubPolicyRow = null;
					clearB490Dtls2();
					//setB490Info(null);
					setB480Info2(null);
					clearB480Dtls();
					setpackSubPolicyInfo(null);
					removeItemInfoFocus3();
					setButtons(objUW.expiry);
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            onRefresh: function() {
		            	if(selectedIndex > -1){
		            		clearB490Dtls2();
		            		//setB490Info(null);
		            		setB480Info2(null);
		            		clearB480Dtls();
		            	}
		            	selectedIndex = -1;
		            },
		            onFilter: function() {
		            	if(selectedIndex > -1){
		            		clearB490Dtls2();
		            		//setB490Info(null);
		            		setB480Info2(null);
		            		clearB480Dtls();
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
								id: 'lineName',
								title: 'Line',
								width: '180',
								editable: false,
								sortable: false,
								filterOption: false
							},
							{
								id: 'sublineName',
								title: 'Subline',
								width: '250',
								editable: false,
								sortable: false,
								filterOption: false
							},
							{
								id: 'policyNo',
								title: 'Policy No.',
								width: '332',
								editable: false,
								sortable: false,
								filterOption: false
							},
							{
								id: 'policyId',
								width: '0',
								visible: false
							},
							{
								id: 'lineCd',
								width: '0',
								visible: false
							},
							{
								id: 'sublineCd',
								width: '0',
								visible: false
							},
							{
								id: 'issCd',
								width: '0',
								visible: false
							},
							{
								id: 'issueYy',
								width: '0',
								visible: false
							},
							{
								id: 'polSeqNo',
								width: '0',
								visible: false
							},
							{
								id: 'renewNo',
								width: '0',
								visible: false
							},
							{
								id: 'packPolFlag',
								width: '0',
								visible: false
							},
							{
								id: 'buttonSw',
								width: '0',
								visible: false
							}
						],
			resetChangeTag: true,
			rows: objItmPerl .packSubPolicy
		};
		packSubPolicyGrid = new MyTableGrid(packSubPolicyListingTable);
		objItmPerl.packSubPolicyGrid = packSubPolicyGrid;
		packSubPolicyGrid.pager = objItmPerl .packSubPolicyListTableGrid;
		packSubPolicyGrid.render('packSubPolicyListingTableGrid');
	}catch(e) {
		showErrorMessage("packSubPolicyGrid", e);
	}
	
	function setpackSubPolicyInfo(obj) {
		try {
			$("txtPolicyNo").value					= obj == null ? null :unescapeHTML2(obj.policyNo);
			$("txtB240PolicyId").value				= obj == null ? null :unescapeHTML2(obj.policyId);
			$("txtLineCd").value					= obj == null ? null :unescapeHTML2(obj.lineCd);
			$("txtSublineCd").value					= obj == null ? null :unescapeHTML2(obj.sublineCd);
			$("txtIssCd").value					= obj == null ? null :unescapeHTML2(obj.issCd);
			$("txtNbtIssueYy").value				= obj == null ? null :unescapeHTML2(obj.issueYy);
			$("txtNbtPolSeqNo").value				= obj == null ? null :unescapeHTML2(obj.polSeqNo);
			$("txtNbtRenewNo").value				= obj == null ? null :unescapeHTML2(obj.renewNo);
			$("txtPackPolFlag").value				= obj == null ? null :unescapeHTML2(obj.packPolFlag);
		} catch(e) {
			showErrorMessage("setpackSubPolicyInfo", e);
		}
	}
	
	function setButtons(buttonSw) {
		if (buttonSw == 'Y'){
			$("btnCrtePrls").value = 'Recreate Peril(s)';
			enableButton("btnDelPerls");
			enableButton("btnEditTax");
			enableButton("btnEditDed");
		}else{
			$("btnCrtePrls").value = 'Create Peril(s)';
			disableButton("btnDelPerls");
			disableButton("btnEditTax");
			disableButton("btnEditDed");
		}
	}
	
	function setB480Info2(obj) {
		try {
			$("txtB480ItemNo").value					= obj == null ? null :obj.itemNo;
			$("txtB480ItemTitle").value				= obj == null ? null :unescapeHTML2(obj.nbtItemTitle);
			$("txtB480CurrencyRt").value			= obj == null ? null :unescapeHTML2(obj.currencyRt);
			$("txtB480AnnPremAmt").value		= obj == null ? null :unescapeHTML2(obj.annPremAmt);
			$("txtB480AnnTsiAmt").value				= obj == null ? null :unescapeHTML2(obj.annTsiAmt);
			$("txtB480LineCd").value						= obj == null ? null :unescapeHTML2(obj.lineCd);
			$("txtB480SublineCd").value				= obj == null ? null :unescapeHTML2(obj.sublineCd);
		} catch(e) {
			showErrorMessage("setB480Info2", e);
		}
	}
	
	function removeItemInfoFocus3(){
		packSubPolicyGrid.keys.removeFocus(packSubPolicyGrid.keys._nCurrentFocus, true);
		packSubPolicyGrid.keys.releaseKeys();
	}
	
	function clearB480Dtls(){
		b490Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B480Info&refresh=1&mode=1&policyId=";
		b490Grid._refreshList();
	}
	
	function clearB490Dtls2(){
		b490Grid.url = contextPath + "/GIEXItmperilController?action=getGIEXS007B490Info&refresh=1&mode=1&policyId=&itemNo=";
		b490Grid._refreshList();
	}

</script>