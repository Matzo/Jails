package com.lisentia.jails.test.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.widget.Button;

import com.lisentia.jails.demo.test.R;

public class TestActivity extends Activity {
	public Button button = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_test);
		initViews();
		adjustViews();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.test, menu);
		return true;
	}
	
	private void initViews() {
		this.button = (Button)findViewById(R.id.button1);
	}
	private void adjustViews() {
	}
}
