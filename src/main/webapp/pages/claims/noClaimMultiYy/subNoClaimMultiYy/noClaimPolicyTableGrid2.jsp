<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="noClaimMultiYyPolicyDetailsTableGrid2" class="sectionDiv" style="border: none; padding-left: 5px;"></div>
<script type="text/javascript"> 
	var objNoClmPolicy2 = new Object(); 
	var selectedNoClaim = null;
	var selectedNoClaimRow = new Object();
	var mtgId = null;
	objNoClmPolicy2.noClaimPolicyListTableGrid2 = JSON.parse('${noClaimPolicyList2}'.replace(/\\/g, '\\\\'));
	var serialNo = '${serialNo}';
	objNoClmPolicy2.noClaimPolicyList2= objNoClmPolicy2.noClaimPolicyListTableGrid2.rows || [];
		try{
			var noClaimPolicyTable2 = {
					url: contextPath+"/GICLNoClaimMultiYyController?action=getNoClaimPolicyListBySerialNo&refresh=1&serialNo="+serialNo,
					options: {
						title: '',
						width: '720px',
						height: '200px',
						onRowDoubleClick: function(param){
							noClaimPolicyGrid.keys.removeFocus(noClaimPolicyGrid.keys._nCurrentFocus, true);
							noClaimPolicyGrid.keys.releaseKeys();	
							var obj = noClaimPolicyGrid.geniisysRows[param];
							goToBasicInfo(obj);
						},
						onCellFocus: function(element, value, x, y, id) {
							noClaimPolicyGrid2.keys.removeFocus(noClaimPolicyGrid2.keys._nCurrentFocus, true);
							noClaimPolicyGrid2.keys.releaseKeys();
							noClaimPolicyGrid2.keys._nOldFocus = null;
							object = noClaimPolicyGrid2.geniisysRows[y];
							var mtgId = noClaimPolicyGrid2._mtgId;
							objCLMGlobal.noClaimTypeListSelectedIndex = -1;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								objCLMGlobal.noClaimTypeListSelectedIndex = y;
							}
						},
						onRemoveRowFocus : function(){
					  	}, 
						/* toolbar: {
						//	elements: [MyTableGrid.ADD_BTN , MyTableGrid.EDIT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
						}	 */					
					},
					columnModel:[
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
									id: 'policyNo',
									title: 'Policy No.',
									width: '290px',
									titleAlign: 'center'
								},
								{
									id: 'inceptDate',
									title: 'Incept Date',
									width: '200px',
									titleAlign: 'center',
									align: 'center',
									renderer: function(value){
										return formatDateToDefaultMask(value);
									}
								},
								{
									id: 'expiryDate',
									title: 'Expiry Date',
									width: '200px',
									titleAlign: 'center',
									align: 'center',
									renderer: function(value){
										return formatDateToDefaultMask(value);
									}
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
									id: 'refPolNo',
									width: '0',
									visible: false
								},
								{
									id: 'nbtLineCd',
									width: '0',
									visible: false
								},
								{
									id: 'nbtIssCd',
									width: '0',
									visible: false
								},
								{
									id: 'parYy',
									width: '0',
									visible: false
								},
								{
									id: 'parSeqNo',
									width: '0',
									visible: false
								},
								{
									id: 'quoteSeqNo',
									width: '0',
									visible: false
								},
								{
									id: 'assdName',
									width: '0',
									visible: false
								},
								{
									id: 'issueDate',
									width: '0',
									visible: false
								},
								{
									id: 'meanPolFlag',
									width: '0',
									visible: false
								},
								{
									id: 'lineCdRn',
									width: '0',
									visible: false
								},
								{
									id: 'issCdRn',
									width: '0',
									visible: false
								},
								{
									id: 'rnYy',
									width: '0',
									visible: false
								},
								{
									id: 'rnSeqNo',
									width: '0',
									visible: false
								},
								{
									id: 'credBranch',
									width: '0',
									visible: false
								},
								{
									id: 'packPolNo',
									width: '0',
									visible: false
								}
					             ],
					             resetChangeTag: true,
					 			rows: objNoClmPolicy2.noClaimPolicyList2					
			};
			noClaimPolicyGrid2 = new MyTableGrid(noClaimPolicyTable2);
			noClaimPolicyGrid2.pager = objNoClmPolicy2.noClaimPolicyListTableGrid2;
			noClaimPolicyGrid2.render('noClaimMultiYyPolicyDetailsTableGrid2');		
			
			tableGridId = "noClaimPolicyGrid2";
			
		}
		catch(e){
			showErrorMessage("noClaimPolicyTableGrid2.jsp" ,e);
			
		}
</script>