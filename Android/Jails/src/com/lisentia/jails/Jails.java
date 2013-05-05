package com.lisentia.jails;

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
}
