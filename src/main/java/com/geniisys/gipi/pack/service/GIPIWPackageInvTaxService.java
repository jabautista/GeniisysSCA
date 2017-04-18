package com.geniisys.gipi.pack.service;

import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

public interface GIPIWPackageInvTaxService {
	List<Map<String, Object>> prepareGIPIWPackageInvTaxForDelete(JSONArray delRows) throws JSONException;
}
