<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="noClaimMultiYyPolicyDetailsTableGrid" class="sectionDiv" style="border: none; padding-left: 5px;"></div>
<script type="text/javascript"> 
	var objNoClmPolicy = new Object(); 
	var selectedNoClaim = null;
	var selectedNoClaimRow = new Object();
	var mtgId = null;
	objNoClmPolicy.noClaimPolicyListTableGrid = JSON.parse('${noClaimPolicyList}'.replace(/\\/g, '\\\\'));
	var plateNo = unescapeHTML2('${plateNo}');
	var serialNo = unescapeHTML2('${serialNo}');
	var motorNo = unescapeHTML2('${motorNo}');
	
	objNoClmPolicy.noClaimPolicyList= objNoClmPolicy.noClaimPolicyListTableGrid.rows || [];
		try{
			var noClaimPolicyTable = {
					//url: contextPath+"/GICLNoClaimMultiYyController?action=getNoClaimPolicyList&refresh=1&plateNo="+plateNo/* +"&serialNo="+serialNo+"&motorNo="+motorNo */,
					url: contextPath+"/GICLNoClaimMultiYyController?action=getNoClaimPolicyList&refresh=1&plateNo="+encodeURIComponent(plateNo)+"&serialNo="+encodeURIComponent(serialNo)+"&motorNo="+encodeURIComponent(motorNo), // bonok :: 02.26.2014 :: fix problem in sorting tablegrid
					options: {
						title: '',
						width: '720px',
						height: '200px',
						/*remove double click event by MAC 11/22/2013.
						onRowDoubleClick: function(param){
							noClaimPolicyGrid.keys.removeFocus(noClaimPolicyGrid.keys._nCurrentFocus, true);
							noClaimPolicyGrid.keys.releaseKeys();	
							var obj = noClaimPolicyGrid.geniisysRows[param];	
							goToBasicInfo(obj, $F("hidNoClaimNo"));
						},*/
						onCellFocus: function(element, value, x, y, id) {
							noClaimPolicyGrid.keys.removeFocus(noClaimPolicyGrid.keys._nCurrentFocus, true);
							noClaimPolicyGrid.keys.releaseKeys();
							noClaimPolicyGrid.keys._nOldFocus = null;
							object = noClaimPolicyGrid.geniisysRows[y];
							var mtgId = noClaimPolicyGrid._mtgId;
							objCLMGlobal.noClaimTypeListSelectedIndex = -1;
							objCLMGlobal.noClaimPolicyId = object.policyId;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								objCLMGlobal.noClaimTypeListSelectedIndex = y;
							}
							
						},
						onRemoveRowFocus : function(){
							objCLMGlobal.noClaimTypeListSelectedIndex = null;
					  	} 
						/* toolbar: {
							//elements: [MyTableGrid.ADD_BTN , MyTableGrid.EDIT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
						}	 */					
					},
					columnModel:[
								{   
									id: 'recordStatus',
								    width: '0px',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	
									id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{
									id: 'policyNo',
									title: 'Policy No.',
									width: '280px',
									titleAlign: 'left'
								},{
									id: 'strInceptDate',
									title: 'Incept Date',
									width: '180px;',
									titleAlign: 'center',
									align: 'center'
								},{
									id: 'strExpiryDate',
									title: 'Expiry Date',
									width: '180px',
									titleAlign: 'center',
									align: 'center'
								},	{
									id: 'inceptDate',
									width: '0px',
									visible: false
								},
								{
									id: 'expiryDate',
									width: '0px',
									visible: false
								},
								{
									id: 'lineCd',
									width: '0px',
									visible: false
								},
								{
									id: 'sublineCd',
									width: '0px',
									visible: false
								},
								{
									id: 'issCd',
									width: '0px',
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
								}/* ,
								{
									id: 'refPolNo',
									width: '0',
									visible: false
								},
								{
									id: 'nbtLineCd',
									width: '0px',
									visible: false
								},
								{
									id: 'nbtIssCd',
									width: '0px',
									visible: false
								},
								{
									id: 'parYy',
									width: '0px',
									visible: false
								},
								{
									id: 'parSeqNo',
									width: '0px',
									visible: false
								},
								{
									id: 'quoteSeqNo',
									width: '0px',
									visible: false
								},
								{
									id: 'assdName',
									width: '0px',
									visible: false
								},
								{
									id: 'issueDate',
									width: '0px',
									visible: false
								},
								{
									id: 'meanPolFlag',
									width: '0px',
									visible: false
								},
								{
									id: 'lineCdRn',
									width: '0px',
									visible: false
								},
								{
									id: 'issCdRn',
									width: '0px',
									visible: false
								},
								{
									id: 'rnYy',
									width: '0px',
									visible: false
								},
								{
									id: 'rnSeqNo',
									width: '0',
									visible: false
								},
								{
									id: 'credBranch',
									width: '0px',
									visible: false
								},
								{
									id: 'packPolNo',
									width: '0px',
									visible: false
								}*/,
								{
									id: 'effDate',
									width: '0px',
									visible: false
								},
								/* {
									id: 'menuLineCd',
									width: '0px',
									visible: false
								}, */
								{
									id: 'lineCdMC',
									width:'0px',
									visible: false
								}
					             ],
					             resetChangeTag: true,
					 			rows: objNoClmPolicy.noClaimPolicyList					
			};
			noClaimPolicyGrid = new MyTableGrid(noClaimPolicyTable);
			noClaimPolicyGrid.pager = objNoClmPolicy.noClaimPolicyListTableGrid;
			noClaimPolicyGrid.render('noClaimMultiYyPolicyDetailsTableGrid');	
			
			tableGridId = "noClaimPolicyGrid";
		}
		catch(e){
			showErrorMessage("noClaimPolicyTableGrid.jsp" ,e);
			
		}
</script>