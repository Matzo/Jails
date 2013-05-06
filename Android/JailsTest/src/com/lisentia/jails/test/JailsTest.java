package com.lisentia.jails.test;

import junit.framework.Assert;
import android.app.Instrumentation;
import android.test.ActivityInstrumentationTestCase2;
import android.view.View;

import com.lisentia.jails.Jails;
import com.lisentia.jails.test.activity.TestActivity;

public class JailsTest extends ActivityInstrumentationTestCase2<TestActivity> {
	public JailsTest() {
		super(TestActivity.class);
	}
	public JailsTest(String p) {
		super(TestActivity.class);
	}
	public JailsTest(Class<TestActivity> activityClass) {
		super(activityClass);
	}
    private TestActivity activity;
    private Instrumentation instrumentation;

    @Override
    public void setUp() throws Exception {
        super.setUp();
        activity = (TestActivity)getActivity();
        instrumentation = getInstrumentation();
        setActivityInitialTouchMode(false);
    }

	public void testFrame() {
	    Jails jails = Jails.getSharedInstance();
	    jails.loadConfig("");
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
        		Assert.assertEquals(1, activity.view.getTop());
        		Assert.assertEquals(2, activity.view.getBottom());
        		Assert.assertEquals(3, activity.view.getLeft());
        		Assert.assertEquals(4, activity.view.getRight());
            }
        });
        instrumentation.waitForIdleSync();
	}
	
	public void testHidden() {
	    Jails jails = Jails.getSharedInstance();
	    jails.loadConfig("");
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
        		Assert.assertEquals(View.GONE, activity.view.getVisibility());
        		Assert.assertEquals(View.VISIBLE, activity.invisibleView.getVisibility());
            }
        });
        instrumentation.waitForIdleSync();
	}

	public void testText() {
	}

	public void testBackground() {
	}

	public void testAction() {
	}
	
	public void testCreateSubviews() {
	}

	public void testBranchName() {
	}
}
