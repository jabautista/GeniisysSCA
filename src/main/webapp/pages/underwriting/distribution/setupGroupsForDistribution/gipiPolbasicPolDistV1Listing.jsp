<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="gipiPolbasicPolDistV1ListingMainDiv" name="gipiPolbasicPolDistV1ListingMainDiv">
	<div id="gipiPolbasicPolDistV1TableGridDiv" align="center">
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
		objPolDist.objPolDistListTableGrid = JSON.parse('${gipiPolbasicPolDistV1TableGrid}'.replace(/\\/g, '\\\\'));
		objPolDist.objPolDistList = objPolDist.objPolDistListTableGrid.rows || [];
		var refreshAction = '${refreshAction}';

		var polDistTableModel = {
			url: contextPath+"/GIPIPolbasicPolDistV1Controller?action="+refreshAction,
			options:{
				title: '',
				width: '900px',
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
					onSelectGIPIPolbasicPolDistV1();
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
				{	id: 'distNo',
					width: '0',
					title: 'Dist. No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id: 'policyNo',
					title : 'Policy No.',
					width : '180px'
				},
				{	id: 'assdName',
					title: 'Assured Name',
					width: '280px',
					filterOption: true
				},
				{ 	id: 'endtNo',
					title : 'Endt No.',
					width : '180px'
				},
				{ 	id: 'distNo',
					title : 'Dist No.',
					width : '75px'
				},
				{ 	id: 'meanDistFlag',
					title : 'Dist. Status',
					width : '149px'
				},	
			],
			requiredColumns: 'policyNo meanDistFlag',
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
			if(moduleId == "GIUWS017"){ 
				$("mtgFilterBy"+polDistTableGrid._mtgId).options[index].show();
				$("mtgFilterBy"+polDistTableGrid._mtgId).options[index].disabled = false;
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
			onSelectGIPIPolbasicPolDistV1();		
		}
	});

	$("btnCancel").observe("click", function(){
		polDistTableGrid.keys.removeFocus(polDistTableGrid.keys._nCurrentFocus, true);
		polDistTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_polbasicDistV1");
	});

	function onSelectGIPIPolbasicPolDistV1(){
		var moduleId = $("lblModuleId").getAttribute("moduleId");
		
		objGIPIPolbasicPolDistV1 = selectedRecord;
		populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
		
		if(moduleId == "GIUWS010"){
			loadGIUWWitemdsTableListing(); // nica 07.08.2011
		}else if(moduleId == "GIUWS018"){
			loadGIUWWPerildsTableListing(); //belle 07.11.2011
		}else if(moduleId == "GIUWS013"){ //tonio 07.15.2011
			loadDistributionByGroups();
		}else if(moduleId == "GIUWS012"){ // emman 07.19.2011
			loadDistributionByPeril();
		}else if(moduleId == "GIUWS016"){ // nica 07.28.2011
			loadDistributionByTsiPremGroup();
		}else if(moduleId == "GIUWS017"){ // nok 07.28.2011
			loadDistByTsiPremPeril();
		}else if(moduleId == "GIUTS002"){ // robert 07.28.2011
			loadPostedDistribution();
		}else if(moduleId == "GIUTS999"){ // nok 08.12.2011
			/*if (nvl(objGIPIPolbasicPolDistV1.msgAlert,"N") == "N") disableButton("btnCreateMissingRec");
			else enableButton("btnCreateMissingRec"); replaced by: Nica 12.27.2012*/
			$("txtDistNo").writeAttribute("readonly", "readonly");
			validateExistingDist();
		}	
		polDistTableGrid.keys.removeFocus(polDistTableGrid.keys._nCurrentFocus, true);
		polDistTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_polbasicDistV1");
	}

</script>