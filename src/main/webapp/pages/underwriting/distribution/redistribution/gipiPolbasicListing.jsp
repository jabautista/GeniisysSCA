<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="gipiPolbasicListingMainDiv" name="gipiPolbasicListingMainDiv">
	<div id="gipiPolbasicTableGridDiv" align="center">
		<div id="polDistGridDiv" style="height: 330px; margin-top: 10px;">
			<div id="polDistTableGrid" style="height: 306px; width: 900px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 90px;" class="button hover"   value="Ok" />
			<input type="button" id="btnCancel" name="btnCancel" style="width: 90px;" class="button hover"   value="Cancel" />
		</div>
	</div>
</div>

<script type="text/javascript">

	var selectedRecord = null;

	try{
		var objPolDist = new Object();
		objPolDist.objPolDistListTableGrid = JSON.parse('${gipiPolbasicTableGrid}'.replace(/\\/g, '\\\\'));
		objPolDist.objPolDistList = objPolDist.objPolDistListTableGrid.rows || [];
		var refreshAction = '${refreshAction}';

		var polDistTableModel = {
			url: contextPath+"/GIPIPolbasicController?action="+refreshAction,
			options:{
				title: '',
				width: '902px',
				height: '306px',
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onCellFocus: function(element, value, x, y, id){
					selectedRecord = polDistTableGrid.geniisysRows[y];
				},
				onRemoveRowFocus : function(){
					selectedRecord = null;				  		
			  	},
				onRowDoubleClick: function(y){
					selectedRecord = polDistTableGrid.geniisysRows[y];
					onSelectGIPIPolbasicForRedistribution();
				}				
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'lineCd',
					title: 'Line Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'sublineCd',
					title: 'Subline Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'issCd',
					title: 'Issue Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'issueYy',
					width: '0',
					title: 'Issue Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'polSeqNo',
					width: '0',
					title: 'Pol. Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'renewNo',
					width: '0',
					title: 'Renew No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtIssCd',
					width: '0',
					title: 'Endt Iss Code',
					visible: false,
					filterOption: true
				},
				{	id: 'endtYy',
					width: '0',
					title: 'Endt. Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtSeqNo',
					width: '0',
					title: 'Endt Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id: 'policyNo',
					title : 'Policy No.',
					width : '180px'
				},
				{ 	id: 'endtNo',
					title : 'Endt. No.',
					width : '180px'
				},
				{	id: 'assdName',
					title: 'Assured Name',
					width: '280px',
					filterOption: true
				},
				{	id: 'effDate',
					title: 'Eff. Date',
					width: '114px',
					type: 'date',
					filterOptionType: 'formattedDate',
					align: 'center',
					titleAlign: 'center',
					format: 'mm-dd-yyyy',
					filterOption: true
				},
				{	id: 'expiryDate',
					title: 'Expiry Date',
					width: '114px',
					type: 'date',
					filterOptionType: 'formattedDate',
					align: 'center',
					titleAlign: 'center',
					format: 'mm-dd-yyyy',
					filterOption: true
				}
			],
			rows: objPolDist.objPolDistList
		};

		polDistTableGrid = new MyTableGrid(polDistTableModel);
		polDistTableGrid.pager = objPolDist.objPolDistListTableGrid;
		polDistTableGrid.afterRender = function(){
			//added by Nok 07.28.2011 para lang ito sa mga meron endt iss code sa filter option
			var index = 0;
			var moduleId = $("lblModuleId").getAttribute("moduleId");
			for(var i = 1; i < $("mtgFilterBy"+polDistTableGrid._mtgId).options.length; i++){ 
				if ("endtIssCd" == $("mtgFilterBy"+polDistTableGrid._mtgId).options[i].value){
					$("mtgFilterBy"+polDistTableGrid._mtgId).options[i].hide();
					$("mtgFilterBy"+polDistTableGrid._mtgId).options[i].disabled = true;
					index = i;
				}
			}
		};
		polDistTableGrid.render('polDistTableGrid');

	}catch(e){
		showErrorMessage("gipiPolbasicPolDist", e);
	}

	$("btnOk").observe("click", function(){
		if(selectedRecord == null){
			showMessageBox("Please select record first.");
		}else{
			onSelectGIPIPolbasicForRedistribution();		
		}
	});

	$("btnCancel").observe("click", function(){
		polDistTableGrid.keys.removeFocus(polDistTableGrid.keys._nCurrentFocus, true);
		polDistTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_polbasic");
	});

	function onSelectGIPIPolbasicForRedistribution(){
		objGIPIPolbasic = selectedRecord;
		objGIPIPolbasic.sveFacultativeCode = null;
		objGIPIPolbasic.negDistNo = null;
		objGIPIPolbasic.tempDistNo = null;
		populateRedistributionPolicyInfoFields(objGIPIPolbasic);
		
		loadRedistribution();
		
		polDistTableGrid.keys.removeFocus(polDistTableGrid.keys._nCurrentFocus, true);
		polDistTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_polbasic");
	}

</script>