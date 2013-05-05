package com.lisentia.jails;

import android.app.Activity;
import android.util.Log;

public class Jails {
	static Jails instance = null;
	static public Jails getSharedInstance() {
		if (instance == null) {
			instance = new Jails();
		}
		return instance;
	}
	
	public void loadConfig(String path) {
	}
	
	public void adjustViews(Activity activity) {
		Log.i("debug", activity.toString());
		// 1. getConfig(activity)
		
		// 2. adjustViews(activity, conf)
	}
}
