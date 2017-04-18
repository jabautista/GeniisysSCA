<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="noClaimMultiYyPolicyDetailsTableGrid3" class="sectionDiv" style="border: none; padding-left: 5px;"></div>
<script type="text/javascript"> 
	var objNoClmPolicy3 = new Object(); 
	var selectedNoClaim = null;
	var selectedNoClaimRow = new Object();
	var mtgId = null;
	objNoClmPolicy3.noClaimPolicyListTableGrid3 = JSON.parse('${noClaimPolicyList3}'.replace(/\\/g, '\\\\'));
	var motorNo = '${motorNo}';
	objNoClmPolicy3.noClaimPolicyList3= objNoClmPolicy3.noClaimPolicyListTableGrid3.rows || [];
		try{
			var noClaimPolicyTable3 = {
					url: contextPath+"/GICLNoClaimMultiYyController?action=getNoClaimPolicyListByMotorNo&refresh=1&motorNo="+motorNo,
					options: {
						title: '',
						width: '720px',
						height: '200px',
						onRowDoubleClick: function(param){
							noClaimPolicyGrid3.keys.removeFocus(noClaimPolicyGrid3.keys._nCurrentFocus, true);
							noClaimPolicyGrid3.keys.releaseKeys();	
							var obj = noClaimPolicyGrid3.geniisysRows[param];
							observeNoClaimPolicyDetails(obj);
						},
						onCellFocus: function(element, value, x, y, id) {
							noClaimPolicyGrid3.keys.removeFocus(noClaimPolicyGrid3.keys._nCurrentFocus, true);
							noClaimPolicyGrid3.keys.releaseKeys();
							noClaimPolicyGrid3.keys._nOldFocus = null;
							object = noClaimPolicyGrid3.geniisysRows[y];
							var mtgId = noClaimPolicyGrid3._mtgId;
							objCLMGlobal.noClaimTypeListSelectedIndex = -1;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								objCLMGlobal.noClaimTypeListSelectedIndex = y;
							}
						},
						onRemoveRowFocus : function(){
					  	}, 
						/* toolbar: {
							//elements: [MyTableGrid.ADD_BTN , MyTableGrid.EDIT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
						} */						
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
									id: lineCd,
									width: '0',
									visible: false
								},
								{
									id: sublineCd,
									width: '0',
									visible: false
								},
								{
									id: issCd,
									width: '0',
									visible: false
								},
								{
									id: issueYy,
									width: '0',
									visible: false
								},
								{
									id: polSeqNo,
									width: '0',
									visible: false
								},
								{
									id: renewNo,
									width: '0',
									visible: false
								},
								{
									id: refPolNo,
									width: '0',
									visible: false
								},
								{
									id: nbtLineCd,
									width: '0',
									visible: false
								},
								{
									id: nbtIssCd,
									width: '0',
									visible: false
								},
								{
									id: parYy,
									width: '0',
									visible: false
								},
								{
									id: parSeqNo,
									width: '0',
									visible: false
								},
								{
									id: quoteSeqNO,
									width: '0',
									visible: false
								}
					             ],
					             resetChangeTag: true,
					 			rows: objNoClmPolicy3.noClaimPolicyList3					
			};
			noClaimPolicyGrid3 = new MyTableGrid(noClaimPolicyTable3);
			noClaimPolicyGrid3.pager = objNoClmPolicy3.noClaimPolicyListTableGrid3;
			noClaimPolicyGrid3.render('noClaimMultiYyPolicyDetailsTableGrid3');	
			
			tableGridId = "noClaimPolicyGrid3";
			
		}
		catch(e){
			showErrorMessage("noClaimPolicyTableGrid3.jsp" ,e);
			
		}
</script>