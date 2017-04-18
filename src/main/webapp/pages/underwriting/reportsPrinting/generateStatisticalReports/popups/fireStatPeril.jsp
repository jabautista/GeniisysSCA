<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="perilFireStatMainDiv" style="width: 340px;">
	<div class="sectionDiv" style="width: 330px; height: 110px; margin: 5px 10px 2px 5px;">
		<table style="margin: 20px 0 0 30px;">
			<tr>
				<td>
					<input type="checkbox" id="chkBasic" name="chkRG" value="B" style="margin: 2px 5px 4px 2px; float: left;" ><label for="chkBasic" style="margin: 2px 0 4px 3px" tabindex="101">Basic Peril/s Only</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" id="chkAllied" name="chkRG" value="A" style="margin: 10px 5px 4px 2px; float: left;"><label for="chkAllied" style="margin: 10px 0 4px 3px" tabindex="102">Allied Peril/s Only</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" id="chkBoth" name="chkRG" value="AB" style="margin: 10px 5px 4px 2px; float: left;"><label for="chkBoth" style="margin: 10px 0 4px 3px" tabindex="103">Both peril types (Basic + Allied Perils)</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv">		
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 120px; margin-top: 0px;" tabindex="104">
	</div>
</div>

<script type="text/javascript">
try{
	function checkFireStatCheckboxStatus(){
		for (var i=0; i < objGIPIS901.chkboxStat.length; i++){
			$(objGIPIS901.chkboxStat[i].chkboxId).checked = objGIPIS901.chkboxStat[i].stat;
		}
	}
	
	
	$("btnPrint").focus();
	
	$$("input[type='checkbox']").each(function(cb){
		if (cb.value == objGIPIS901.firePerilType){
			$(cb).checked = true;
		}else{
			$(cb).checked = false;
		}
	});
	
	$("chkBasic").observe("click", function(){
		if($("chkBasic").checked){
			objGIPIS901.firePerilType = "B";
			$("chkAllied").checked = false;
			$("chkBoth").checked = false;
		}else if($("chkBasic").checked == false){
			$("chkBasic").checked = true;
		}
	});
	
	$("chkAllied").observe("click", function(){
		if($("chkAllied").checked){
			objGIPIS901.firePerilType = "A";
			$("chkBasic").checked = false;
			$("chkBoth").checked = false;
		}else if($("chkAllied").checked == false){
			$("chkAllied").checked = true;
		}
	});
	
	$("chkBoth").observe("click", function(){
		if($("chkBoth").checked){
			objGIPIS901.firePerilType = "A";
			$("chkBasic").checked = false;
			$("chkAllied").checked = false;
		}else if($("chkBoth").checked == false){
			$("chkBoth").checked = true;
		}
	});
	
	$("btnReturn").observe("click", function(){
		checkFireStatCheckboxStatus();
		overlayPerilFireDialog.close();
	});
}catch(e){
	showErrorMessage("popup page error", e);
}
</script>