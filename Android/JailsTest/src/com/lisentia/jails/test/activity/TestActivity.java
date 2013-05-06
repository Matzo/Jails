package com.lisentia.jails.test.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.TextView;

import com.lisentia.jails.test.R;

public class TestActivity extends Activity {
	public Button button = null;
	public View view = null;
	public View invisibleView = null;
	public TextView textView = null;
	public WebView web = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_test);
		initViews();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.test, menu);
		return true;
	}
	
	private void initViews() {
		this.button = (Button)findViewById(R.id.button1);
		this.view = (View)findViewById(R.id.view1);
		this.invisibleView = (View)findViewById(R.id.invisible_view);
		this.textView = (TextView)findViewById(R.id.textView1);
		this.web = (WebView)findViewById(R.id.webView1);
	}
}
