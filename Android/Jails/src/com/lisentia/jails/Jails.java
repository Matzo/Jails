package com.lisentia.jails;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.res.Resources;
import android.view.View;
import android.view.ViewGroup;

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
	
	public void breakWithConfURL(String url) {
		Jails jails = Jails.getSharedInstance();
		jails.loadConfig(url);
	}
	
	public void adjustViews(Activity activity) {

		// 1. getConfig(activity)
		
		// 2. adjustViews(activity, conf)
		ViewGroup layout = (ViewGroup)activity.getWindow().getDecorView();
		List<View> childViews = getTargetViews(activity, layout);
		
//		activity.getTitle()
		
//		Log.i("JAILS", decor.toString());
//		Log.i("JAILS", Integer.toString(decor.getLeft()));
	}
	
	
	private List<View> getTargetViews(Activity activity, ViewGroup layout) {
		List<View> list = new ArrayList<View>();
		Resources res = activity.getResources();
		String packageName = activity.getPackageName();

        for(int i = 0; i < layout.getChildCount(); i++) {
            View v = (View)layout.getChildAt(i);
//			Log.i("JAILS VG1:", v.getClass().getSimpleName());
//			Log.i("JAILS VG2:", v.getClass().getPackage().getName());
//			Log.i("JAILS VG3:", v.getClass().getName());
//			Log.i("JAILS VG4:", v.getClass().getCanonicalName());
////			Log.i("JAILS VG5:", v.getClass().getSigners().getClass().getName());
//			Log.i("JAILS VG6:", Integer.toString(v.getId()));
//			
			if (0 <= v.getId()) {
//				Log.i("JAILS VG7:", res.getResourceName(v.getId()));
				String resourceName = res.getResourceName(v.getId());
				if (resourceName.startsWith(packageName + ":")) {
					list.add(v);
				}
			}
			
			if (v instanceof ViewGroup == true) {
				list.addAll(getTargetViews(activity, (ViewGroup)v));
			}
        }
		
		return list;
	}
}
