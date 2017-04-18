function disableSearchIcons(x){
	if(x){
		disableSearch("txtNbtLineCdIcon");
		disableSearch("txtNbtSublineCdIcon");
		disableSearch("txtNbtPolIssCdIcon");
		disableSearch("txtNbtIssueYyIcon");
		disableSearch("nbtSearchPolicyIcon");
	} else {
		enableSearch("txtNbtLineCdIcon");
		enableSearch("txtNbtSublineCdIcon");
		enableSearch("txtNbtPolIssCdIcon");
		enableSearch("txtNbtIssueYyIcon");
		enableSearch("nbtSearchPolicyIcon");
	}
}