package com.lisentia.jails.test;

import org.junit.Test;

import android.test.ActivityTestCase;

import com.lisentia.jails.Jails;
import com.lisentia.jails.test.activity.TestActivity;

public class JailsTest extends ActivityTestCase {
	@Test
	public void testMain() {
//	    assertTrue(false);
	    
	    Jails jails = Jails.getSharedInstance();
	    jails.loadConfig("");
	    TestActivity activity = new TestActivity();
	    
		System.out.println(activity.button);
		
		activity.button.setLeft(200);
	}
}
