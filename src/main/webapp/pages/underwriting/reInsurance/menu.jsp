<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="frpsListing">FRPS Listing</a></li>
			<li><a id="createRiPlacement">Create RI Placement</a></li>
	<!-- 		<li><a id="riAcceptance">RI Acceptance</a></li>  -->
			<li><a id="enterRiAcceptance">RI Acceptance</a></li>
			<li><a id="riExit">Exit</a></li>
		</ul>
	</div>
</div>
<script type="text/javascript">
	observeAccessibleModule(accessType.MENU, "GIRIS001", "createRiPlacement", function() {showCreateRiPlacementPage();});
	observeAccessibleModule(accessType.MENU, "GIRIS006", "frpsListing", function() {
			if (nvl(objRiFrps.lineCd,null) == null && nvl(objRiFrps.lineName,null) == null){	
				getLineListingForFRPS();
			}else{
				updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
				  "Getting FRPS listing, please wait...");
			}	
		}); 
	
	observeAccessibleModule(accessType.MENU, "GIRIS002", "enterRiAcceptance", function() {showEnterRIAcceptancePage("N");});
	observeGoToModule("riExit", frpsExit);

	function frpsExit(){
		if(nvl(frpsTableGrid, null) != null) {
			frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true);
			frpsTableGrid.keys.releaseKeys();
		}
		//clearObjectValues(objRiFrps);
		objRiFrps = {};
		retrievedDtlsGIRIS001 = false; 
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
	}
</script>